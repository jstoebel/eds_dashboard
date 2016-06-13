('a[data-popup]').live('click', function(e) { 
  window.open( (this).attr('href'), "Popup", "height=600, width=600" ); 
  e.preventDefault(); 
});