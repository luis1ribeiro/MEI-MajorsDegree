var axios = require('axios')

axios.get("http://localhost:7200/rest/repositories")
    .then(async dados => {
        repos = await dados.data.map(async r => {
            // await fica à espera do get do size.
            var size = await axios.get("http://localhost:7200/rest/repositories/" + r.id + "/size")
            return({
                id: r.id,
                tit: r.title,
                uri: r.uri,
                size: size.data
            })
        })
        /*
            console.log(JSON.stringify(dados.data))
            console.log("-------------------")
        */
        console.dir(repos)
    })
    .catch(erro => console.log(erro))
