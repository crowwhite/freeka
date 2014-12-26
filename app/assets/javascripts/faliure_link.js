$(function () {
  $('.new_comment').on('ajax:error', function () {
    $('#flash').empty().append($('<div>', { html: 'Please SignUp/SignIn to comment.', class: 'alert alert-danger', role: 'alert' }))
  });
});