$(function () {
  $('#requirement_address_attributes_country_code').on('change', function () {
    _this = this;
    $.ajax({
      type: "GET",
      dataType: "html",
      url: '/addresses/sub_region',
      data: { 'parent_region': _this.value },
      success: function (response) {
        $('#subregion_select').html(response)
      }
    })
  })
});