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

    $("#course_select").append('<option value="">Select a Course</option>');
    if ($("#student_select option:selected").val() === "") {
        console.log("no student selected!")
    } else {
      return get_transcripts();
    }
}

var get_transcripts = function() {
  console.log("Starting AJAX request");
  var student_id = $("#student_select option:selected").val()
  var url = `/students/${student_id}/transcripts`
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
      console.log(courses);
      courses.forEach(function(course){
        var row = `<option value=${course.id}> ${course.course_code} </option>`
        $("#course_select").append(row)
      })
    }
  });
};
