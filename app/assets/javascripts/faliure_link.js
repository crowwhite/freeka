$(function () {
  $('.new_comment').on('ajax:error', function () {
    $('#flash').empty().append($('<div>', { html: 'Please login first.', class: 'alert alert-danger', role: 'alert' }))
  })
});