const resolvePath = require('path').resolve
const autoPrefixer = require('autoprefixer')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const PKG = require('./package.json')

const outputConfig = {
  path: resolvePath(__dirname, 'build', 'assets'),
  publicPath: './assets/',
  filename: '[name].[hash].js',
  hash: true
}

const htmlPluginConfig = {
  title: 'JSON-ROA Browser v' + PKG.version,
  template: 'app/index.html',
  filename: '../index.html',
  inject: 'body',
  minify: {}
}

// the boring stuff
module.exports = {
  context: __dirname,
  entry: {
    app: './app/app'
  },
  output: outputConfig,
  resolve: {
    // we can leave off file extensions for js-like sources:
    // still need to transform them with a loader!
    'extensions': [
      // (node.js) defaults:
      '', // need to leave this…
      '.js',
      '.json',
      //  extra:
      '.coffee',
      '.jsx',
      '.cjsx'
    ]
  },
  // and how to load them when they are `require()`ed, also by extension:
  module: {
    // how to transform non-js sources:
    loaders: [
      // CSS will be injected into the HTML:
      { test: /\.css$/, loader: 'style!css' },
      // less will be transformed, than handled like CSS:
      { test: /\.less$/, loader: 'style!css!less' },
      // plain files: url-encode if small enough or passthrough
      {
        test: /\.(otf|eot|svg|ttf|woff)/,
        loader: 'url-loader?limit=128'
      },
      {
        test: /\.(jpe?g|png|gif)/,
        loader: 'url-loader?limit=128'
      },

      // js dialects are just transformed:
      {
        test: /\.(js|jsx)$/,
        // NOTE: some npm modules are published in ES2015, exclude from exlusion
        exclude: /(node_modules\/(?!qs))/,
        loader: 'babel-loader',
        query: { presets: ['es2015', 'react'] }
      },
      {
        test: /\.coffee$/,
        loader: 'coffee-loader'
      },
      {
        test: /\.cjsx$/,
        loader: 'coffee-jsx-loader'
      }
    ]
  },

  postcss: [autoPrefixer()],

  plugins: [
    // generate a simple index.html referencing all entries
    new HtmlWebpackPlugin(htmlPluginConfig)
  ]
}
