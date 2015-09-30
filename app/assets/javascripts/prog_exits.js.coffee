# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("tbody>tr:not(:first-child").hide()
  $(document).on 'change', '#names_select', (evt) ->
    $.ajax "get_programs",
    type: "GET"
    dataType: "json"
    data: {
      alt_id: $("#names_select option:selected").val()
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log("AJAX Error: #{textStatus}")
    success: (data, textStatus, jqXHR) ->
      console.log("AJAX request OK!")
      $("tbody>tr:not(:first-child").show()
      $("#programs_select").empty()    #clear out select box to repopulate
      $("#programs_select").append('<option value="">Select a Program to Exit</option>')
      console.log(data)
      for id, prog_name of data
        $("#programs_select").append('<option value="'+id+'">'+prog_name+'</option>')
