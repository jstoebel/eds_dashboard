$(document).ready(function () {
	$('#view_as').change(function () {
		change_psudo_status();
	});

});

function change_psudo_status() {
	//makes an AJAX request to change the user's psudo status
	var selection = $('#view_as option:selected').val();
	console.log ("got menu seletion" + selection);
	$.ajax( {
		url: "/access/change_psudo_status",
		data: {view_as: selection},
		success: function(data, textStatus, jqXHR) {
		}
	})

}


// function change_psudo_status() {
// 	//makes an AJAX request to change the user's psudo status
// 	console.log ("starting AJAX request.");
// 	var selection =  $('.view_as_menu:selected').val();
// 	console.log ("menu seletion is "+ seletion);
// 	$.ajax( {
// 		url: "/access/change_psudo_status",
// 		type: "GET",
// 		dataType: "json",
// 		data: { choice: selection },
// 		error: function(xhr,status,error) {
// 			console.log("An error occured " + xhr.status + " "+ xhr.statusText)
// 		}
// 		success: function(data, textStatus, jqXHR) {
// 			console.log("Got a response!")
// 			console.log(data)
// 		}
// 	})

// }