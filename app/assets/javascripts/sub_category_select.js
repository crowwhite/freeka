$(function () {
  $('#requirement_category_ids').on('change', function () {
    _this = this;
    $.ajax({
      type: "GET",
      dataType: "html",
      url: 'sub_category',
      data: { 'parent_id': _this.value },
      success: function (response) {
        $('#sub_category_select').html(response)
      }
    })
  })
});