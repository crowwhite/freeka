// Always handle failure cases while making ajax requests.
$(function () {
  $('#requirement_category_ids').on('change', function () {
    _this = this;
    $.ajax({
      type: "GET",
      dataType: "html",
      // FIXME_AB: Don't hardcode urls in JS. Pass them to jS using data attributes from erb
      // tobefixed
      url: $(_this).data('url-for-ajax'),
      data: { 'parent_id': _this.value },
      success: function (response) {
        $('#sub_category_select').html(response)
      },
      error: function() {
        $('#flash').empty().append($('<div>', { html: 'Could not load sub-categories. Please select a category again.', class: 'alert alert-danger', role: 'alert' }))
      }
    });
  });
});