const path = require('path')

module.exports = {
  entry: { app: './src/index.js' },
  output: {
    path: path.join(__dirname, "../app/assets/javascripts/webpack"),
    filename: 'app.js',
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader', // babel-loaderを使って変換する
          options: {
            presets: ['@babel/env', '@babel/react'], // env presetでES2015から変換、react presetでReactのJSX文法を変換
          }
        }
      },
      {
          test: /\.svg$/,
          loader: 'svg-inline-loader'
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
}
