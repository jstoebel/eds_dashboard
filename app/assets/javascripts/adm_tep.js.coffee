# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$j = jQuery

$j ->
		$('.date-admit').hide()
		$(".admit-choice").on("change", ->
			# alert(choice = $(".admit-choice").val())
			choice = $(".admit-choice").val()
			if choice == "true"
				$(".date-admit").show()
			else
				$(".date-admit").hide()
		)

		$('[data-behaviour~=datepicker]').datepicker()