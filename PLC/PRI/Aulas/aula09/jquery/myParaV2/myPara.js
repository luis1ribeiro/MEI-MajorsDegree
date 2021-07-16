$(()=>{
    /* usar AJAX */
    $.get("http://localhost:7709/paras", function(data){
        data.forEach(p => {
            $("#paraList").append("<li>" + p.text + "</li>")
        });
    })

    $("#addPara").click(()=>{
        $("#paraList").append("<li>" + $("#paraText").val() + "</li>")
        /* Hipótese 1 */
        /* $.post("http://localhost:7709/paras", {text: $("#paraText").val()}) */
        /* Hipótese 2 - Serializar o Formulário */
        $.post("http://localhost:7709/paras", $("#myParaForm").serialize())
        $("#paraText").val(''); /*Substituir por vazio */
    })
})