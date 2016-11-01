const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: path.join(__dirname, 'src/js/main.js'),

  output: {
    path: 'assets/js',
    filename: '[name].bundle.js',
  },

  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ['', '.js', '.elm'],
  },

  module: {
    noParse: /.elm$/,

    loaders: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack',
      },
    ],
  },

  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
      },
    }),
  ],
};
