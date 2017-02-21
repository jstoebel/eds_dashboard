$(document).ready(function() {
    //menu will start out with current course, as selection
    // look up current sutdents other courses and append them as new choices.s
    update_menu();
    $(document).on('change', '#student_select', function(evt){
      console.log("menu change");
      $("#course_select").empty();
      update_menu();
    });
})

var update_menu = function(student_id){

    if ($("#student_select option:selected").val() === "") {
        console.log("no student selected!")
    } else {
      return get_transcripts();
    }
}

var get_transcripts = function() {
  console.log("Starting AJAX request");
  var student_id = $("#student_select option:selected").val()
  var url = "/students/" + student_id + "/transcripts";
  console.log(url);
  $.ajax(url, {
    type: "GET",
    dataType: "json",
    data: {},
    error: function(jqXHR, textStatus, errorThrown) {
      console.log("AJAX Error: " + textStatus);
    },
    success: function(courses, textStatus, jqXHR) {
      console.log("AJAX request OK!");

      // gather existing ids, add any new ones
      var existingIDs = []
      $("#course_select option").each(function(){
        console.log(typeof $(this).val());
        existingIDs.push($(this).val())
      })

      courses.forEach(function(course){
        if (existingIDs.indexOf(String(course.id)) === -1) {
          var row = "<option value="+ course.id +">" + course.course_code + "</option>"
          $("#course_select").append(row)
        }

      })
    }
  });
};
