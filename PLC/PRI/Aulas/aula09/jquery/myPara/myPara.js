$(()=>{
    $("#addPara").click(()=>{
        $("#paraList").append("<li>" + $("#paraText").val() + "</li>")
        $("#paraText").val(''); /*Substituir por vazio */
    })
})