var updateStatus = function(stuID, status, comment) {
  // attempts to update a student with the values of status and comment

  return new Promise(function(resolve, reject){
      $.ajax({
          type: "PATCH",
          dataType: "json",
          url: "/students/" + stuID + "/update_presumed_status",
          data: {authenticity_token : AUTH_TOKEN, student: {presumed_status: status, presumed_status_comment: comment } },
          success: function(data){
              resolve(data);
          },
          error: function(xhr, textStatus, errorThrown){
            var json = $.parseJSON(xhr.responseText);
            reject(json);
          }
      })
  })
}


var getResources = function(stuID) {
  // gets resources available for a student

  return new Promise(function(resolve, reject){
      $.ajax({
          type: "GET",
          dataType: "json",
          url: "/students/" + stuID + "/get_resources",
          data: {},
          success: function(data){
              resolve(data);
          },
          error: function(xhr, textStatus, errorThrown){
            var json = $.parseJSON(xhr.responseText);
            reject(json);
          }
      })
  })
}

$(document).ready(function(){

  $(".submit-btn").on("click", function(event){
    var stuID = $(this).data('val');
    var form = $('#edit_student_'+stuID)

    var dataArr = form.serializeArray();
    var values = {};
    $.each(dataArr, function(i, field) {
        values[field.name] = field.value;
    });

    var status = values["student[presumed_status]"]
    var comment = values["student[presumed_status_comment]"]
    updateStatus(stuID, status, comment).then(function(response){
      var footer = $(".modal-footer")
      var confirm = $('<span class="glyphicon glyphicon-ok-sign glyphicon-ok"></span>')
      //alert alert-success
      footer.prepend(confirm)
      footer.children(":first").fadeOut(1000, function(){
        this.remove()
      })

    }).catch(function(json){
      alert(json.message)
    })
  }) // change presumed status


  // when a student's action's menu is clicked, ask the backend for information and populate the menu.
  // var actionsMenus = $(".student-actions-menu")
  $(".student-actions-menu").on("click", function(event){

    var dropDown = $(this);
    var stuID = event.target.id.match(/stu-actions-menu-(\d+)/)[1]

    var actionsMenu = dropDown.find('ul:first')
    actionsMenu.empty();
    getResources(stuID).then(function(response){

      // populate the menu
      response.forEach(function(row){
        if (!row.disable){
          // row should be presented
          var menuItem = "<li><a href='"+ row.link_url + "'> " + row.menu_name + " </a></li>"
          actionsMenu.append(menuItem)
        }
      })

    }).catch(function(json){
      console.log(json);
    })

  })

})
