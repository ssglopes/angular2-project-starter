#!/bin/bash

# run this script from /var/www/app/project/

if [ $1 == "4" ] 
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

sed -i "s/preBootstrapCustomizations,/preBootstrapCustomizations.replace('?', global.siteName),/g" node_modules/bootstrap-loader/lib/bootstrap.styles.loader.js
sed -i "s/bootstrapCustomizations,/bootstrapCustomizations.replace('?', global.siteName),/g" node_modules/bootstrap-loader/lib/bootstrap.styles.loader.js
sed -i "s/appStyles,/appStyles.replace('?', global.siteName),/g" node_modules/bootstrap-loader/lib/bootstrap.styles.loader.js
