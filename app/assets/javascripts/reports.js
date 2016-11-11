$(document).ready(function(){
  var table = $('#report').DataTable({
    columnDefs: [
        { targets: [0, 1, 2], visible: true},
        { targets: '_all', visible: false }
    ],
    dom: 'B<"clear">lfrtip',
    buttons: ['csv']

  });
  // more on datatables here: https://github.com/rweng/jquery-datatables-rails

  $( '.options-toggle a' ).on( 'click', function( event ) {

    // the column to toggle
    // console.log(event.target.getAttribute('data-column'))

    var column = table.column( $(this).attr('data-column'))
    column.visible( ! column.visible() );

    return false;
  });

  // table.buttons().container()
  //     .appendTo( $('.container-fluid', table.table().container() ) );

})
