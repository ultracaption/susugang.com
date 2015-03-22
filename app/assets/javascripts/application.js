//= require 'jquery-1.8.2'
//= require 'bootstrap'
//= require 'jquery-ui-1.9.1.custom'
//= require 'humane'
//= require 'jquery.cookie'

$(document).ready(function() {
  $('.btn-reply').click(function() {
    $(this).parent().parent().nextAll('.comment-to-comment-form-container').first().show();
    return false;
  });
});
