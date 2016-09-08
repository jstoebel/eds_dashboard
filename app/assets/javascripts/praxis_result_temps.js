// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  $(".temp_resolve_dropdown").on("click", function(){
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
        var id, prog_name, results;
        console.log("AJAX request OK!");
        console.log(data);
        // results = [];
        // for (id in data) {
        //   prog_name = data[id];
        //   results.push($("#programs_select").append('<option value="' + id + '">' + prog_name + '</option>'));
        // }
      }
    });
  })

})
