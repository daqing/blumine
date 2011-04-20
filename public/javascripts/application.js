// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  $(".bg_highlight").live('mouseenter', function() { $(this).css('backgroundColor', '#FFC'); })
    .live('mouseleave', function() { $(this).css('backgroundColor', '#FFF'); });
});
