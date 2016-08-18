$(document).ready(function() {
  $('[data-behaviour~=datepicker]').datepicker();
  $("#programs_select").append('<option value="">Select a Program to Exit</option>');
  console.log($("#names_select option:selected").val());
  get_programs();
  return $(document).on('change', '#names_select', function(evt) {
    $("#programs_select").empty();
    $("#programs_select").append('<option value="">Select a Program to Exit</option>');
    if ($("#names_select option:selected").val() === "") {
      return console.log("Its an empty string!");
    } else {
      console.log("Not an empty string!");
      return get_programs();
    }
  });
});

var get_programs = function() {
  console.log("Starting AJAX request");
  return $.ajax("/prog_exits/get_programs", {
    type: "GET",
    dataType: "json",
    data: {
      id: $("#names_select option:selected").val()
    },
    error: function(jqXHR, textStatus, errorThrown) {
      return console.log("AJAX Error: " + textStatus);
    },
    success: function(data, textStatus, jqXHR) {
      var id, prog_name, results;
      console.log("AJAX request OK!");
      console.log(data);
      results = [];
      for (id in data) {
        prog_name = data[id];
        results.push($("#programs_select").append('<option value="' + id + '">' + prog_name + '</option>'));
      }
      return results;
    }
  });
};

var build_menu = function(data) {
  var id, prog_name, results;
  if (data == null) {
    data = null;
  }
  console.log("Starting build menu");
  $("#programs_select").empty();
  $("#programs_select").append('<option value="">Select a Program to Exit</option>');
  if (data !== null) {
    results = [];
    for (id in data) {
      prog_name = data[id];
      results.push($("#programs_select").append('<option value="' + id + '">' + prog_name + '</option>'));
    }
    return results;
  }
};
