var path = require('path')
var webpack = require('webpack')

config = {
  context: __dirname,
  entry: {
    application: './src/js/application.js',
  },
  output: {
    path: path.join(__dirname, 'public', 'assets'),
    filename: '[name].js',
    publicPath: '/js/'
  },
  module: {
    rules: [
      { test: /\.(js)$/, use: 'babel-loader' },
    ]
  },
}

module.exports = config;
