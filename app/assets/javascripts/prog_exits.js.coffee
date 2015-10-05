# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#names_select', (evt) ->
    if $("#names_select option:selected").val() !== ""
      #ajax request and build menu
    else
      #build an empty menu


get_programs = ->
  $.ajax "/prog_exits/get_programs",    
      type: "GET"
      dataType: "json"
      data: {
        alt_id: $("#names_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

      success: (data, textStatus, jqXHR) ->
        console.log("AJAX request OK!")
        console.log(data)
        return data

build_menu = (data = null) ->

  $("#programs_select").empty()
  $("#programs_select").append('<option value="">Select a Program to Exit</option>')
  
  if data !== null
    for id, prog_name of data
      $("#programs_select").append('<option value="'+id+'">'+prog_name+'</option>')  


  $('[data-behaviour~=datepicker]').datepicker()
  $(document).on 'change', '#names_select', (evt) ->
    $("#programs_select").empty()
    $("#programs_select").append('<option value="">Select a Program to Exit</option>')

    #using full path, or else ajax sends a request to the wrong place if the page was rendered from somewhere else!

    
        

