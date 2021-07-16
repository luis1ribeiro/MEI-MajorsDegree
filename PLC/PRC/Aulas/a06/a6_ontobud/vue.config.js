module.exports = {
    devServer: {
     proxy: {
       '/ontobud': { 
         target: 'http://epl.di.uminho.pt:8738', 
         secure: true,
         changeOrigin: true, 
         pathRewrite: {
           '^/ontobud': ''
        }  
       },
     }  
   }   
};