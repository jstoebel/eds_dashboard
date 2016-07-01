var toggleState = function(updateId, newState) {

    return new Promise(function(resolve, reject){


        $.ajax({
            type: "PATCH", 
            dataType: "json",
            url: "/issue_updates/"+updateId,
            data: {authenticity_token : AUTH_TOKEN, issue_update: {addressed : newState}},
            success: function(response){
                resolve(response);
            },
            error: function(response){
                reject(response);
            }
        })
    })


}

$(document).ready(function(){

    //render switches
    $(".bs-switch.switch-on").bootstrapSwitch('state', true);
    // // $(".bs-switch.switch-on").bootstrapSwitch('OnColor', 'info')
    // // $(".bs-switch.switch-on").bootstrapSwitch('OffColor', 'danger');

    $(".bs-switch.switch-off").bootstrapSwitch('state', false);

    $(".bs-switch").bootstrapSwitch('onColor', "default");
    $(".bs-switch").bootstrapSwitch('offColor', "danger");


    $(".bs-switch").on('switchChange.bootstrapSwitch', function(event, state){
        var elemId = event.target.id;
        var updateId = elemId.match(/\d/)[0];
        toggleState(updateId, state).then(function(response){
            //successfully saved record
        }).catch(function(response){
            console.log("FAILED TO UPDATE RECORD!")
            console.log(response)
            //failed to save record
        })
    })

});