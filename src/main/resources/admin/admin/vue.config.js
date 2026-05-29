// var webpack = require('webpack');
const path = require('path')
function resolve(dir) {
    return path.join(__dirname, dir)
}
function publicPath(){
    if (process.env.NODE_ENV == 'production') {
        return "././";
    } else {
        return "/";
    }
}
// vue.config.js
module.exports = {
    // publicPath:"././",
    publicPath: publicPath(),
    // 鍥介檯鍖栭厤缃?浣跨敤鍏跺畠璇█锛岄粯璁ゆ儏鍐典笅涓枃璇█鍖呬緷鏃ф槸琚紩鍏ョ殑
    configureWebpack: {
        // plugins: [
        //     new webpack.NormalModuleReplacementPlugin(/element-ui[\/\\]lib[\/\\]locale[\/\\]lang[\/\\]zh-CN/, 'element-ui/lib/locale/lang/en')
        // ]
        resolve: {
            alias: {
                '@': resolve('src')
            }
        }
    },
lintOnSave: false,
    devServer: {
        host: "0.0.0.0", //鎸囧畾浣跨敤涓€涓?host銆傞粯璁ゆ槸 localhost锛岃繖閲岄粯璁ゅ€煎嵆鍙?
        port: 8081, //鎸囧畾绔彛
        hot: true, // 寮€鍚儹鏇存柊
        https: false, // 鏄惁寮€鍚痟ttps妯″紡
        proxy: { // 璇锋眰浠ｇ悊鏈嶅姟鍣?
            '/tongyongwenjuandiaocha': { //甯︿笂api鍓嶇紑鐨?
                target: 'http://localhost:8080/tongyongwenjuandiaocha/', //浠ｇ悊鐩爣鍦板潃
                changeOrigin: true,
                secure: false,
                pathRewrite: { // 鍦ㄥ彂鍑鸿姹傚悗灏?api鏇挎崲涓?'绌哄€硷紝杩欐牱涓嶅奖鍝嶆帴鍙ｈ姹?
                    '^/tongyongwenjuandiaocha': ''
                }
            }
        }
    },
chainWebpack(config) {
    config.module
      .rule('svg')
      .exclude.add(resolve('src/icons'))
      .end()
    config.module
      .rule('icons')
      .test(/\.svg$/)
      .include.add(resolve('src/icons'))
      .end()
      .use('svg-sprite-loader')
      .loader('svg-sprite-loader')
      .options({
        symbolId: 'icon-[name]'
      })
      .end()
}
}
