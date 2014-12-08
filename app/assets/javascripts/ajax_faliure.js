$(function () {
  $('.faliure_link').on('ajax:error', function () {
    $('#flash').append($('<div>', { html: 'Please login to make this link work', class: 'alert alert-danger', role: 'alert' }))
  })
});