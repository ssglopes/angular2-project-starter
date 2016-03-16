#!/bin/bash

new_project = false

if [ -d /var/www/app/$1 ]   
then

  # directory does exist, so we only change bootstrap version
  echo 'Directory does exist: ' $1
  echo 'Only change to bootstrap version: ' $2   
  cd /var/www/app/$1

else
 
  new_project = true

  if [ -d /var/www/app ] 
  then
  
    # directory does exist
    echo 'Directory /var/www/app does exist!'
  
  else 
 
    mkdir /var/www/app        
  
  fi
  
  if [ -f /etc/apache2/sites-available/app.conf ] 
  then
  
    # file does exist
    echo 'File /etc/apache2/sites-available/app.conf does exist!'
  
  else
  
    # download the apache app.conf into sites-available, enable it and reload apache2
    sudo wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/app.conf -P /etc/apache2/sites-available/ && sudo a2ensite app.conf && sudo service apache2 reload
  
  fi
  
  # directory does not exist so let's start basic angular 2 installation
  echo '127.0.0.1    www.'$1'.app' | sudo tee -a /etc/hosts 
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
  
  # Install typings for jquery and moment. Add --ambient to install type definitions from DefinitelyTyped
  # https://github.com/DefinitelyTyped/DefinitelyTyped
  # https://github.com/DefinitelyTyped/tsd/issues/269
  # https://github.com/typings/typings  
  yes Y | typings install moment --save
  yes Y | typings install jquery --save --ambient

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
  grep -q "var\ siteName\ =\ 'www';" webpack.config.js || sed -i "6ivar\ siteName\ =\ 'www';" webpack.config.js
    
  # add webpack providerPlugin on line 11 of webpack.config.js
  grep -q "var ProvidePlugin\ =\ require('webpack/lib/ProvidePlugin');" webpack.config.js || sed -i "11ivar ProvidePlugin\ =\ require('webpack/lib/ProvidePlugin');" webpack.config.js
  
  # add code to line 15 to import jquery so it will be loaded
  grep -q "import\ 'jquery';" src/vendor.ts || sed -i "15iimport\ 'jquery';" src/vendor.ts
  
  # add code to line 16 to import bootstrap-loader so it will be loaded
  grep -q "import\ 'bootstrap-loader';" src/vendor.ts || sed -i "16iimport\ 'bootstrap-loader';" src/vendor.ts
  
  # add code to line 17 to import font-awesome-sass-loader so it will be loaded, incase bootstrap 4 will be used
  grep -q "import\ 'font-awesome-sass-loader';" src/vendor.ts || sed -i "17iimport\ 'font-awesome-sass-loader';" src/vendor.ts
  
  # change the default production directory where all files will be transpiled to 
  mkdir public && cd public && mkdir www && mkdir mobile && mkdir api && cd ../
  sed -i "s/'dist'/'..\/..\/public\/'+siteName/g" webpack.config.js 
  
  mkdir source && cd source && mkdir www && mkdir mobile && mkdir api && cd ../

fi

if [ $2 == "4" ] 
then

  # its bootstrap 4 to be installed
  npm uninstall bootstrap --save
  npm install bootstrap@4.0.0-alpha.2 font-awesome --save
  npm install font-awesome-sass-loader tether --save-dev    
  sed -i "s/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS3;/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;/g" src/bootstrap.ts
  sed -i "s/var\ vBootstrap\ =\ 3;/var\ vBootstrap\ = 4;\ /g" webpack.config.js
  rm -rf .bootstraprc && cp .bootstraprc-4-default .bootstraprc
  sed -i "s/||\ Ng2BootstrapTheme.BS3/||\ Ng2BootstrapTheme.BS4/g" node_modules/ng2-bootstrap/components/ng2-bootstrap-config.ts

else

  # its bootstrap 3 to be installed
  npm uninstall bootstrap@4.0.0-alpha.2 font-awesome --save
  npm uninstall font-awesome-sass-loader tether --save-dev
  npm install bootstrap --save
  sed -i "/import\ 'font-awesome-sass-loader';/d" src/vendor.ts
  sed -i "s/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS3;/g" src/bootstrap.ts
  sed -i "s/var\ vBootstrap\ =\ 4;/var\ vBootstrap\ = 3;\ /g" webpack.config.js
  rm -rf .bootstraprc && cp .bootstraprc-3-default .bootstraprc
  sed -i "s/||\ Ng2BootstrapTheme.BS4/||\ Ng2BootstrapTheme.BS3/g" node_modules/ng2-bootstrap/components/ng2-bootstrap-config.ts
  
fi

if [ "$new_project" = true ]
then

  cp src source/www/
  cp src source/mobile/
  cp webpack.config.js source/www/webpack.config.js
  
  ln -s /var/www/app/$1/node_modules source/www/node_modules
  ln -s /var/www/app/$1/typings source/www/typings
  ln -s /var/www/app/$1/karma.conf.js source/www/karma.conf.js
  ln -s /var/www/app/$1/karma-shim.js source/www/karma-shim.js
  ln -s /var/www/app/$1/LICENSE source/www/LICENSE
  ln -s /var/www/app/$1/package.json source/www/package.json
  ln -s /var/www/app/$1/protractor.conf.js source/www/protractor.conf.js
  ln -s /var/www/app/$1/README.md source/www/README.md
  ln -s /var/www/app/$1/tsconfig.json source/www/tsconfig.json
  ln -s /var/www/app/$1/tslint.json source/www/tslint.json
  ln -s /var/www/app/$1/typedoc.json source/www/typedoc.json
  ln -s /var/www/app/$1/typings.json source/www/typings.json
  ln -s /var/www/app/$1/.bootstraprc-3-default source/www/.bootstraprc-3-default
  ln -s /var/www/app/$1/.bootstraprc-4-default source/www/.bootstraprc-4-default
  ln -s /var/www/app/$1/.editorconfig source/www/.editorconfig
  ln -s /var/www/app/$1/.gitignore source/www/.gitignore
    
  cp webpack.config.js source/mobile/webpack.config.js
  sed -i "s/var\ siteName\ =\ 'www';/var\ siteName\ =\ 'mobile';\ /g" source/mobile/webpack.config.js
  ln -s /var/www/app/$1/node_modules source/mobile/node_modules
  ln -s /var/www/app/$1/typings source/mobile/typings
  ln -s /var/www/app/$1/karma.conf.js source/mobile/karma.conf.js
  ln -s /var/www/app/$1/karma-shim.js source/mobile/karma-shim.js
  ln -s /var/www/app/$1/LICENSE source/mobile/LICENSE
  ln -s /var/www/app/$1/package.json source/mobile/package.json
  ln -s /var/www/app/$1/protractor.conf.js source/mobile/protractor.conf.js
  ln -s /var/www/app/$1/README.md source/mobile/README.md
  ln -s /var/www/app/$1/tsconfig.json source/mobile/tsconfig.json
  ln -s /var/www/app/$1/tslint.json source/mobile/tslint.json
  ln -s /var/www/app/$1/typedoc.json source/mobile/typedoc.json
  ln -s /var/www/app/$1/typings.json source/mobile/typings.json
  ln -s /var/www/app/$1/.bootstraprc-3-default source/mobile/.bootstraprc-3-default
  ln -s /var/www/app/$1/.bootstraprc-4-default source/mobile/.bootstraprc-4-default
  ln -s /var/www/app/$1/.editorconfig source/mobile/.editorconfig
  ln -s /var/www/app/$1/.gitignore source/mobile/.gitignore
  
  rm -rf src
  rm -rf webpack.config.js  
  
fi

# transpile the example code to public/www
cd source/mobile && npm run build && cd ../www && npm run build

# start the webserver and open http://localhost:8080/ for www
npm start
