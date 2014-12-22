$(function () {

  // FIXME_AB: You should write Object oriented JS. May be you can have a page class which on init binds events. The current implementation doesn't looks good to me

  $('#requirement_address_attributes_country_code').on('change', function () {
    _this = this;
    $.ajax({
      type: "GET",
      dataType: "html",
     // FIXME_AB: Don't hardcode urls in JS. Pass them to jS using data attributes from erb
      url: '/addresses/sub_region',
      data: { 'parent_region': _this.value },
      success: function (response) {
        $('#subregion_select').html(response)
      }
    })
  })
});