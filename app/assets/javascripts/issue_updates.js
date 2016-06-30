$(document).ready(function(){

    //render switches
    $(".bs-switch.switch-on").bootstrapSwitch('state', true);
    // // $(".bs-switch.switch-on").bootstrapSwitch('OnColor', 'info')
    // // $(".bs-switch.switch-on").bootstrapSwitch('OffColor', 'danger');

    $(".bs-switch.switch-off").bootstrapSwitch('state', false);

    $(".bs-switch").bootstrapSwitch('onColor', "default");
    $(".bs-switch").bootstrapSwitch('offColor', "danger");

});