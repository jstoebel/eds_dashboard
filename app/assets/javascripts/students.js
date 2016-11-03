var updateStatus = function(stuID, status, comment) {
  // attempts to update a student with the values of status and comment

    return new Promise(function(resolve, reject){
        $.ajax({
            type: "PATCH",
            dataType: "json",
            url: `/students/${stuID}/update_presumed_status`,
            data: {authenticity_token : AUTH_TOKEN, student: {presumed_status: status, presumed_status_comment: comment } },
            success: function(data){
                resolve(dataType);
            },
            error: function(data){
                reject(data);
            }
        })
    })

}


$(document).ready(function(){
  console.log("hi from students!")

  $(".submit-btn").on("click", function(event){
    console.log("clicked");
    var stuID = $(this).data('val');
    console.log(stuID);
    var form = $('#edit_student_'+stuID)

    var dataArr = form.serializeArray();
    var values = {};
    $.each(dataArr, function(i, field) {
        values[field.name] = field.value;
    });

    var status = values["student[presumed_status]"]
    var comment = values["student[presumed_status_comment]"]
    updateStatus(stuID, status, comment).then(function(response){
      console.log("success!")
      var footer = $(".modal-footer")
      var confirm = $('<span class="glyphicon glyphicon-ok-sign glyphicon-ok"></span>')
      //alert alert-success
      footer.prepend(confirm)
      footer.children(":first").fadeOut(1000, function(){
        this.remove()
      })

    }).catch(function(data){
      console.log(data.response)
    })
  })

})
