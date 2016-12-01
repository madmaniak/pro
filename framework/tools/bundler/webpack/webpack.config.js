const path = require('path');
module.exports = {
  context: __dirname,
  entry: '../../../services/init',
  node: {
    __dirname: true
  },
  output: {
     publicPath: 'http://localhost:8080/',
     filename: 'build/bundle.js'
  },
  devtool: 'eval',
  module: {
    loaders: [
      {
        test: /\.s(c|a)ss$/,
        loaders: [
            'style',
            'css',
            'autoprefixer?browsers=last 3 versions',
            'sass?outputStyle=expanded'
        ]
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        loaders: [
            'url?limit=8192',
            'img'
        ]
      },
  	  { test: /\.imba/, loader: 'imba/loader' },
  	  { test: /\.coffee/, loader: 'coffee-loader' }
    ]
  },
  resolveLoader: { root: path.join(__dirname, "node_modules") },
  resolve: {
  extensions: ['', '.imba', '.js', '.coffee' ],
    modulesDirectories: [ 'node_modules' ]
  }
};
