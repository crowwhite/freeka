$(function () {

  // FIXME_AB: You should write Object oriented JS. May be you can have a page class which on init binds events. The current implementation doesn't looks good to me

  $('#requirement_country_code').on('change', function () {
    _this = this;
    $.ajax({
      type: "GET",
      dataType: "html",
     // FIXME_AB: Don't hardcode urls in JS. Pass them to jS using data attributes from erb
     // tobefixed
      url: $('#country_select_label').data('url-for-ajax'),
      data: { 'parent_region': _this.value },
      success: function (response) {
        $('#subregion_select').html(response)
      },
      error: function() {
        $('#flash').empty().append($('<div>', { html: 'Could not load states of this country. Please select the country again.', class: 'alert alert-danger', role: 'alert' }))
      }
    });
  });
});