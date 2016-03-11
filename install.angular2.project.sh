#!/bin/bash

if [ $1 =~ ^-?[0-9]+$ ]

then
  $2 = $1
  echo 'update already installed project to bootstrap ' $2

else 

cd /var/www/app
git clone https://github.com/preboot/angular2-webpack.git $1
cd $1
mkdir _public && cd _public && mkdir www
npm install
npm install --save jquery
sudo npm install -g tsd
tsd install jquery --save
cd /var/www/app && sudo chmod 775 $1 && cd $1
wget https://raw.githubusercontent.com/shakacode/bootstrap-loader/master/.bootstraprc-3-default
wget https://raw.githubusercontent.com/shakacode/bootstrap-loader/master/.bootstraprc-4-default
sed -e '/return\ config;/radd.to.webpack.config.js' webpack.config.js
rm -rf src/app/components/home/home.ts
rm -rf src/app/components/home/home.html
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/home.ts
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/home.html
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/add.to.webpack.config.js

fi

grep -q "import\ {Ng2BootstrapConfig,\ Ng2BootstrapTheme}\ from\ 'ng2-bootstrap/ng2-bootstrap';" src/bootstrap.ts || sed -i "20iimport\ {Ng2BootstrapConfig,\ Ng2BootstrapTheme}\ from\ 'ng2-bootstrap/ng2-bootstrap';" src/bootstrap.ts
grep -q "Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;" src/bootstrap.ts || sed -i "21iNg2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;" src/bootstrap.ts
grep -q 'var\ vBootstrap\ =\ 4;' webpack.config.js || sed -i '5ivar\ vBootstrap\ =\ 4;' webpack.config.js
grep -q "var ProvidePlugin\ =\ require('webpack/lib/ProvidePlugin');" webpack.config.js || sed -i "11ivar ProvidePlugin\ =\ require('webpack/lib/ProvidePlugin');" webpack.config.js
grep -q "import\ 'jquery';" src/vendor.ts || sed -i "15iimport\ 'jquery';" src/vendor.ts
grep -q "import\ 'bootstrap-loader';" src/vendor.ts || sed -i "16iimport\ 'bootstrap-loader';" src/vendor.ts
grep -q "import\ 'font-awesome-sass-loader';" src/vendor.ts || sed -i "17iimport\ 'font-awesome-sass-loader';" src/vendor.ts





if [$2]
then
npm uninstall bootstrap@4.0.0-alpha.2 font-awesome --save
npm uninstall tether font-awesome-sass-loader --save-dev
npm install --save-dev bootstrap-loader bootstrap-sass resolve-url-loader
npm install --save bootstrap
sed -i "/import\ 'font-awesome-sass-loader';/d" src/vendor.ts
sed -i "s/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS3;/g" src/bootstrap.ts
sed -i "s/var\ vBootstrap\ =\ 4;/var\ vBootstrap\ = 3;\ /g" webpack.config.js
rm -rf .bootstraprc && copy .bootstraprc-3-default .bootstraprc
sed -i "s/||\ Ng2BootstrapTheme.BS4/||\ Ng2BootstrapTheme.BS3/g" node_modules/ng2-bootstrap/components/ng2-bootstrap-config.ts
else

npm uninstall bootstrap --save
npm install --save-dev bootstrap-loader bootstrap-sass resolve-url-loader tether
npm install --save bootstrap@4.0.0-alpha.2
sed -i "s/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS3;/Ng2BootstrapConfig.theme\ =\ Ng2BootstrapTheme.BS4;/g" src/bootstrap.ts
sed -i "s/var\ vBootstrap\ =\ 3;/var\ vBootstrap\ = 4;\ /g" webpack.config.js
rm -rf .bootstraprc && copy .bootstraprc-4-default .bootstraprc
sed -i "s/||\ Ng2BootstrapTheme.BS3/||\ Ng2BootstrapTheme.BS4/g" node_modules/ng2-bootstrap/components/ng2-bootstrap-config.ts
fi

rm -rf https://raw.githubusercontent.com/shakacode/bootstrap-loader/master/home.ts
rm -rf https://raw.githubusercontent.com/shakacode/bootstrap-loader/master/home.html
rm -rf https://raw.githubusercontent.com/shakacode/bootstrap-loader/master/add.to.webpack.config.js




