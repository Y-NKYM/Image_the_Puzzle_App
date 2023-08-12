const { environment } = require('@rails/webpacker')

module.exports = environment

const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: 'popper.js'
  })
)

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
})