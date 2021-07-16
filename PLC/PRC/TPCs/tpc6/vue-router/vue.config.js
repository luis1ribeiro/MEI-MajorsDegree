module.exports = {
    devServer: {
      proxy: {
        "/api": {
          target: "http://localhost:8081",
  
          secure: true,
  
          changeOrigin: true,
  
          pathRewrite: {
            "^/api": "",
          },
        },
      },
    },
  
    transpileDependencies: ["vuetify"],
  };