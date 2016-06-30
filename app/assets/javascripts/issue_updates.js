var toggleState = function(updateId, newState) {

    return new Promise(function(resolve, reject){


        $.ajax({
            type: "PATCH", 
            dataType: "json",
            //url: "/issue_updates/"+updateId+"?&authenticity_token="+AUTH_TOKEN,
            data: {issue_update: {addressed : newState}},
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
        console.log("swtich flipped!")
        console.log(state);
        toggleState(updateId, state).then(function(response){
            console.log("success!");
            console.log(response);
        }).catch(function(response){
            console.log("fail!");
            console.log(response)
            console.log(response);

        })
    })

});

console.log("hello");