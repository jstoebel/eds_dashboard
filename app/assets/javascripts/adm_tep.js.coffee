# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$j = jQuery

$j ->
		$('.date-admit').hide()
		$(".admit-choice").on("change", ->
			choice = $(".admit-choice").val()
			if choice == "Admitted"
				$(".date-admit").show()
			else
				$(".date-admit").hide()
		)
