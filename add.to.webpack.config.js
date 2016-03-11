  if (vBootstrap === 4) {
    config.module.loaders.push(
        // font-awesome only when using bootstrap 4
        {test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: 'url-loader?limit=10000&mimetype=application/font-woff' },
        {test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: 'file-loader' }
    );
    config.plugins.push(
        new ProvidePlugin({
          jQuery: 'jquery',
          $: 'jquery',
          jquery: 'jquery',
          "Tether": 'tether', // only if bootstrap 4
          "window.Tether": "tether" // only if bootstrap 4
        })
    );
  }

  if (vBootstrap === 3) {
    config.plugins.push(
        new ProvidePlugin({
          jQuery: 'jquery',
          $: 'jquery',
          jquery: 'jquery'
        })
    );
  }
