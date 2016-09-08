// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  $(".temp_resolve_dropdown").on("click", function(){

    var menu = this
    $(this).empty()

    var search_name = $(this).attr("search_name");
    $.ajax("/students", {
      type: "GET",
      dataType: "json",
      data: {
        search: search_name
      },
      error: function(jqXHR, textStatus, errorThrown) {
        return console.log("AJAX Error: " + textStatus);
      },
      success: function(data, textStatus, jqXHR) {
        console.log("AJAX request OK!");
        console.log(data);
        var results = data.forEach(function(stu, i){
          //stu: object of student attributes
          // var name = stu.FirstName.concat(" ").concat(stu.LastName)
          var name = nameReadable(stu);
          var entry = '<option value="' + stu.id + '">' + name + '</option>'
          $(menu).append(entry)
        })
      }
    });
  })

})


function nameReadable(stuObj){
  //return a name string from a student object
  // same implementation as in Student model

  var firstName = stuObj.PreferredFirst !== null ? stuObj.PreferredFirst.concat(" (").concat(stuObj.FirstName).concat(")") : stuObj.FirstName
  var lastName = stuObj.LastName
  return firstName.concat(" ").concat(lastName)
}
