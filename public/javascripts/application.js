// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  $(".bg_highlight").live('mouseenter', function() { $(this).css('backgroundColor', '#FFC'); })
    .live('mouseleave', function() { $(this).css('backgroundColor', '#FFF'); });
  
  $.make_sortable = function(id, items, url) {
    var obj = $("#" + id);
    obj.sortable({
       axis: 'y',
       dropOnEmpty: false,
       cursor: 'crosshair',
       items: items,
       opacity: 0.6,
       scroll: true, 
       update: function(event, ui) {
          $.post(url, $("#" + id).sortable('serialize'), function(result) {}, 'script');
       }
    });
  }
});
