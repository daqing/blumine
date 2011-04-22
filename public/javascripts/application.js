// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {

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

  $(".bg_highlight").live('mouseenter', function() { $(this).css('backgroundColor', '#FFC'); })
    .live('mouseleave', function() { $(this).css('backgroundColor', '#FFF'); });

  $("div[clickable]").mouseover(function() { $(this).css('cursor', 'pointer'); }).click(function() {
    location.href = $(this).attr('clickable');
  });

  $("div.row").live('hover', function(ev) {
    if (ev.type == "mouseenter") {
      $(this).find('a[data-method=delete]').removeClass('hide');
    } else if (ev.type == "mouseleave") {
      $(this).find('a[data-method=delete]').addClass('hide');
    }
  });
});
