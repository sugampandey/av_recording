// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require browser_timezone_rails/application.js
//= require bootstrap
//= require jquery-ui-timepicker-addon.js
//= require confirm
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap3
//= require_self

$.fn.twitter_bootstrap_confirmbox.defaults = {
    fade: true,
    title: "AV Recording",
    cancel: "Cancel",
    cancel_class: "btn btn-sm cancel",
    proceed: "Proceed",
    proceed_class: "btn btn-primary btn-sm"
};
