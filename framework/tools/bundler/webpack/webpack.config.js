const path = require('path');
module.exports = {
  context: __dirname,
  entry: '../../../services/init',
  node: {
    __dirname: true
  },
  output: {
	path: __dirname + '/../../../public',
    filename: 'bundle.js'
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
      { test: /\.woff$/, loader: 'url?limit=65000&mimetype=application/font-woff&name=public/fonts/[name].[ext]' },
      { test: /\.woff2$/, loader: 'url?limit=65000&mimetype=application/font-woff2&name=public/fonts/[name].[ext]' },
      { test: /\.[ot]tf$/, loader: 'url?limit=65000&mimetype=application/octet-stream&name=public/fonts/[name].[ext]' },
      { test: /\.eot$/, loader: 'url?limit=65000&mimetype=application/vnd.ms-fontobject&name=public/fonts/[name].[ext]' },

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
