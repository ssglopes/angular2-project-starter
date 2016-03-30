#!/bin/bash

# run this script from /var/www

# check if /var/www/app exists
if [ -d /var/www/app ] 
then

# directory does exist
echo 'Directory /var/www/app does exist!'

else 

mkdir /var/www/app        

fi

# check if /etc/apache2/sites-available/app.conf exists and if not download and install it
if [ -f /etc/apache2/sites-available/app.conf ] 
then

# file does exist
echo 'File /etc/apache2/sites-available/app.conf does exist!'

else

# download the apache app.conf into sites-available, enable it and reload apache2
sudo wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/app.conf -P /etc/apache2/sites-available/ && sudo a2ensite app.conf && sudo service apache2 reload

fi

cd /var/www/app

git clone https://github.com/preboot/angular2-webpack.git $1
cd $1  

# replace beta.9 with beta.8 to avoid conflict with other libraries
sed -i 's/"angular2": "2.0.0-beta.9",/"angular2": "2.0.0-beta.8",/g' package.json
npm cache clean && npm install 

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
chmod +x bootstrap.sh

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
rm -rf src/app/components/about/about.ts
rm -rf src/app/components/about/about.spec.ts
rm -rf src/app/components/about/about.html

mkdir src/app/styles src/app/templates
mkdir src/app/styles/home src/app/styles/about
mkdir src/app/templates/home src/app/templates/about

wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/.bootstraprc
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/app.scss -P src/style/
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/customizations.scss -P src/style/
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/pre-customizations.scss -P src/style/

# download the new default files with updated example code
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/home.ts -P src/app/components/home/
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/home.html -P src/app/templates/home/
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/home.scss -P src/app/styles/home/

wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/about.ts -P src/app/components/about/
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/about.spec.ts -P src/app/components/about/
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/about.html -P src/app/templates/about/
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/about.scss -P src/app/styles/about/
	
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

sed -i "s/'dist'/'..\/..\/public\/'+siteName/g" webpack.config.js 
grep -q '"baseUrl":\ "./",' tsconfig.json || sed -i '15i"baseUrl":\ "./",' tsconfig.json

mkdir fonts php public source ts 
mkdir public/www public/mobile public/api public/admin
mkdir source/www source/mobile source/api source/admin
mkdir ts/core ts/core/classes ts/core/components ts/core/interfaces ts/core/pipes ts/core/services

./bootstrap.sh '4'

# create an array with the subdomains to create
subdomains=( www admin mobile )

# create all symlinks etc in the subdomains
for i in "${subdomains[@]}"
do
	cp -ar src source/$i/
	cp webpack.config.js source/$i/webpack.config.js
	sed -i "s/var\ siteName\ =\ 'www';/var\ siteName\ =\ '"$i"';\ /g" source/$i/webpack.config.js
	
	ln -s /var/www/app/$1/node_modules/ source/$i/
	ln -s /var/www/app/$1/typings/ source/$i/
	ln -s /var/www/app/$1/ts/core/ source/$i/src/app/components/
	ln -s /var/www/app/$1/karma.conf.js source/$i/karma.conf.js
	ln -s /var/www/app/$1/karma-shim.js source/$i/karma-shim.js
	#ln -s /var/www/app/$1/LICENSE source/$i/LICENSE
	ln -s /var/www/app/$1/package.json source/$i/package.json
	ln -s /var/www/app/$1/protractor.conf.js source/$i/protractor.conf.js
	#ln -s /var/www/app/$1/README.md source/$i/README.md
	ln -s /var/www/app/$1/tsconfig.json source/$i/tsconfig.json
	ln -s /var/www/app/$1/tslint.json source/$i/tslint.json
	ln -s /var/www/app/$1/typedoc.json source/$i/typedoc.json
	ln -s /var/www/app/$1/typings.json source/$i/typings.json
	#ln -s /var/www/app/$1/.bootstraprc-3-default source/$i/.bootstraprc-3-default
	#ln -s /var/www/app/$1/.bootstraprc-4-default source/$i/.bootstraprc-4-default
	ln -s /var/www/app/$1/.editorconfig source/$i/.editorconfig
	#ln -s /var/www/app/$1/.gitignore source/$i/.gitignore
	echo '127.0.0.1    '$i'.'$1'.app' | sudo tee -a /etc/hosts
done

rm -rf src
rm -rf webpack.config.js  
  
# transpile the example code to public/www
# cd source/mobile && npm run build && cd ../www && npm run build && cd ../admin && npm run build

# start the webserver and open http://localhost:8080/ for www
# npm start
