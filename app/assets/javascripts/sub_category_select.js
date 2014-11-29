// Always handle failure cases while making ajax requests.
$(function () {
  $('#requirement_category_ids').on('change', function () {
    _this = this;
    $.ajax({
      type: "GET",
      dataType: "html",
      url: '/categories/sub_categories',
      data: { 'parent_id': _this.value },
      success: function (response) {
        $('#sub_category_select').html(response)
      }
    })
  })
});