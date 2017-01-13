$(document).ready(function() {
  $("#course_select").append('<option value="">Select a Course</option>');
  return $(document).on('change', '#student_select', function(evt) {
    $("#course_select").empty();
    $("#course_select").append('<option value="">Select a Course</option>');
    if ($("#course_select option:selected").val() === "") {
      return console.log("Its an empty string!");
    } else {
      console.log("Not an empty string!");
      return get_transcripts();
    }
  });
});

var get_transcripts = function() {
  console.log("Starting AJAX request");
  var student_id = $("#course_select option:selected").val()
  return $.ajax(`/students/${student_id}/transcripts`, {
    type: "GET",
    dataType: "json",
    data: {
    },
    error: function(jqXHR, textStatus, errorThrown) {
      return console.log("AJAX Error: " + textStatus);
    },
    success: function(courses, textStatus, jqXHR) {
      console.log("AJAX request OK!");
      console.log(data);
      var results = courses.forEach(function(course){
        $("#course_select").append('<option value="' + course.id + '">' + course.course_code + '</option>')

      })
      return results;
    }
  });
};

// var build_menu = function(data) {
//   var id, prog_name, results;
//   if (data == null) {
//     data = null;
//   }
//   console.log("Starting build menu");
//   $("#programs_select").empty();
//   $("#programs_select").append('<option value="">Select a Program to Exit</option>');
//   if (data !== null) {
//     results = [];
//     for (id in data) {
//       prog_name = data[id];
//       results.push($("#programs_select").append('<option value="' + id + '">' + prog_name + '</option>'));
//     }
//     return results;
//   }
// };
