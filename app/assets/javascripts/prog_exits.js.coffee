# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('[data-behaviour~=datepicker]').datepicker()
  $("#programs_select").append('<option value="">Select a Program to Exit</option>')
  $(document).on 'change', '#names_select', (evt) ->

    #clear menu to start over.
    $("#programs_select").empty()
    $("#programs_select").append('<option value="">Select a Program to Exit</option>')

    if $("#names_select option:selected").val() == ""
      console.log "Its an empty string!"
    else
      console.log "Not an empty string!"
      #ajax request and build menu
      data = get_programs()


get_programs = ->
  console.log "Starting AJAX request"
  #using full path, or else ajax sends a request to the wrong place if the page was rendered from somewhere else!

    
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

        #build menu from data.
        for id, prog_name of data
          $("#programs_select").append('<option value="'+id+'">'+prog_name+'</option>')  


build_menu = (data = null) ->

  console.log "Starting build menu"
  $("#programs_select").empty()
  $("#programs_select").append('<option value="">Select a Program to Exit</option>')
  
  if data != null
    for id, prog_name of data
      $("#programs_select").append('<option value="'+id+'">'+prog_name+'</option>')  



    
        

