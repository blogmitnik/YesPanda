// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
//= require bootstrap-fileinput
//= require nprogress
//= require nprogress-ajax
//= require spin
//= require ladda
//= require ladda.jquery
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap
//= require dataTables/dataTables.responsive
//= require dataTables/responsive.bootstrap
//= require dataTables/dataTables.colReorder
//= require dataTables/dataTables.fixedColumns
//= require dataTables/dataTables.fixedHeader
//= require dataTables/buttons/dataTables.buttons
//= require dataTables/buttons/buttons.bootstrap
//= require dataTables/buttons/jszip
//= require dataTables/buttons/pdfmake
//= require dataTables/buttons/vfs_fonts
//= require dataTables/buttons/buttons.html5
//= require dataTables/buttons/buttons.print
//= require dataTables/buttons/buttons.colVis
//= require rwd-table
//= require raphael
//= require morris
//= require jquery-ui/datepicker
//= require datepicker
//= require moment
//= require daterangepicker
//= require responsive-paginate
//= require sweetalert
//= require select2
//= require jQDateRangeSlider-min
//= require jQRangeSlider-min
//= require sortable
//= require fileinput
//= require infinite-scroll
//= require_tree .
//= require turbolinks

Turbolinks.enableProgressBar();

NProgress.configure({
  showSpinner: false,
  ease: 'ease',
  speed: 500
});

$(function() {
  var flashCallback;
  flashCallback = function() {
    return $(".alert").fadeOut();
  };
  $(".alert").bind('click', (function(_this) {
    return function(ev) {
      return $(".alert").fadeOut();
    };
  })(this));
  return setTimeout(flashCallback, 3000);
});