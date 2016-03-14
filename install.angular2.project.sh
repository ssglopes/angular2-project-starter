#!/bin/bash

if [ -d /var/www/app/$1 ]   
then

  # directory does exist, so we only change bootstrap version
  echo 'Directory does exist: ' $1
  echo 'Only change to bootstrap version: ' $2   
  cd /var/www/app/$1

else 

  if [ -d /var/www/app ] 
  then
    # directory does exist
  else 
    mkdir /var/www/app        
  fi
  
  if [ -f /etc/apache2/sites-available/app.conf ] 
  then
    # file does exist
  else
    # this declares that current user is a sudoer
    sudo tee /etc/sudoers.d/$USER <<END
    END 
    # download the apache app.conf into sites-available, enable it and reload apache2
    sudo wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/app.conf -P /etc/apache2/sites-available/ && sudo a2ensite app.conf && sudo service apache2 reload
    # then to remove the sudo access from the current user
    sudo /bin/rm /etc/sudoers.d/$USER
    sudo -k  
  fi
  
  # directory does not exist so let's start basic angular 2 installation
  echo '127.0.0.1    www.'$2'.app' | sudo tee -a /etc/hosts 
  echo 'Added to /etc/hosts file!'
  
  cd /var/www/app

  git clone https://github.com/preboot/angular2-webpack.git $1
  cd $1  
  
  # replace beta.9 with beta.8 to avoid conflict with other libraries
  sed -i 's/"angular2": "2.0.0-beta.9",/"angular2": "2.0.0-beta.8",/g' package.json
  npm install 
  
  # install bootstrap required packages and save it to package.json devDependencies
  npm install bootstrap-loader bootstrap-sass resolve-url-loader --save-dev    
  
  # install ng2-bootstrap
  npm install ng2-bootstrap jquery --save
  yes Y | typings install moment --save
  sudo npm install -g tsd
  tsd install jquery --save
  cd /var/www/app && sudo chmod 775 $1 && cd $1
  
  # download the bootstrap 3 and 4 default settings used by bootstrap loader
  wget https://raw.githubusercontent.com/shakacode/bootstrap-loader/master/.bootstraprc-3-default
  wget https://raw.githubusercontent.com/shakacode/bootstrap-loader/master/.bootstraprc-4-default
  
  # download extra code chunk to insert into webpack.config.js to load appropiate packages
  wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/add.to.webpack.config.js
  
  # add marker where code chunk has to be inserted
  sed -i 's/return\ config;/\/\/bootstrap\nreturn\ config;/g' webpack.config.js
  
  # insert code chunk and remove temp file
  sed -i '/\/\/bootstrap/radd.to.webpack.config.js' webpack.config.js 
  rm -rf add.to.webpack.config.js
  
  # remove some default files   
  rm -rf src/app/components/home/home.ts
  rm -rf src/app/components/home/home.html
  
  # download the new default files with updated example code
  wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/home.ts -P src/app/components/home/
  wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/home.html -P src/app/components/home/
  
  # add code to bootstrap.ts to set the usage of either bootstrap3 or 4
  grep -q "import\ {Ng2BootstrapConfig,\ Ng2BootstrapTheme}\ from\ 'ng2-bootstrap/ng2-bootstrap';" src/bootstrap.ts || sed -i "20iimport\ {Ng2BootstrapConfig,\ Ng2BootstrapTheme}\ from\ 'ng2-bootstrap/ng2-bootstrap';" src/bootstrap.ts  
  grep -q "Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;" src/bootstrap.ts || sed -i "21iNg2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;" src/bootstrap.ts
  
  # add bootstrap variable which can be used by app
  grep -q 'var\ vBootstrap\ =\ 4;' webpack.config.js || sed -i '5ivar\ vBootstrap\ =\ 4;' webpack.config.js
  
  # add webpack providerPlugin on line 11 of webpack.config.js
  grep -q "var ProvidePlugin\ =\ require('webpack/lib/ProvidePlugin');" webpack.config.js || sed -i "11ivar ProvidePlugin\ =\ require('webpack/lib/ProvidePlugin');" webpack.config.js
  
  # add code to line 15 to import jquery so it will be loaded
  grep -q "import\ 'jquery';" src/vendor.ts || sed -i "15iimport\ 'jquery';" src/vendor.ts
  
  # add code to line 16 to import bootstrap-loader so it will be loaded
  grep -q "import\ 'bootstrap-loader';" src/vendor.ts || sed -i "16iimport\ 'bootstrap-loader';" src/vendor.ts
  
  # add code to line 17 to import font-awesome-sass-loader so it will be loaded, incase bootstrap 4 will be used
  grep -q "import\ 'font-awesome-sass-loader';" src/vendor.ts || sed -i "17iimport\ 'font-awesome-sass-loader';" src/vendor.ts
  
  # change the default production directory where all files will be transpiled to 
  mkdir _public && cd _public && mkdir www && cd ../
  sed -i "s/'dist'/'_public\/www'/g" webpack.config.js 
     
fi

if [ $2 == "3" ] 
then

  # its bootstrap 3 to be installed
  npm uninstall bootstrap@4.0.0-alpha.2 font-awesome --save
  npm uninstall font-awesome-sass-loader tether --save-dev
  npm install bootstrap --save
  sed -i "/import\ 'font-awesome-sass-loader';/d" src/vendor.ts
  sed -i "s/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS3;/g" src/bootstrap.ts
  sed -i "s/var\ vBootstrap\ =\ 4;/var\ vBootstrap\ = 3;\ /g" webpack.config.js
  rm -rf .bootstraprc && copy .bootstraprc-3-default .bootstraprc
  sed -i "s/||\ Ng2BootstrapTheme.BS4/||\ Ng2BootstrapTheme.BS3/g" node_modules/ng2-bootstrap/components/ng2-bootstrap-config.ts

else

  # its bootstrap 4 to be installed
  npm uninstall bootstrap --save
  npm install bootstrap@4.0.0-alpha.2 font-awesome --save
  npm install font-awesome-sass-loader tether --save-dev    
  sed -i "s/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS3;/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;/g" src/bootstrap.ts
  sed -i "s/var\ vBootstrap\ =\ 3;/var\ vBootstrap\ = 4;\ /g" webpack.config.js
  rm -rf .bootstraprc && copy .bootstraprc-4-default .bootstraprc
  sed -i "s/||\ Ng2BootstrapTheme.BS3/||\ Ng2BootstrapTheme.BS4/g" node_modules/ng2-bootstrap/components/ng2-bootstrap-config.ts

fi

# transpile the example code to _public/www
npm run build

# start the webserver and open http://localhost:8080/
npm start
