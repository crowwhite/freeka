$( function() {
  $('#comment_popup').popover()
  $('#commentModal').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget); // Button that triggered the modal
   // Extract info from data-* attributes
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  var $modal = $(this);
  var $commentBox = $modal.find('.comment-box')
  $commentBox.val(button.data('comment'));

  var $modalForm = $modal.find('form');
  $modalForm.attr('action', button.data('action'));
  $modalForm.find("input[name='_method']").val(button.data('method'));

  var $submitButton = $modal.find('#submit_button')
  $submitButton.val(button.data('button-name'));
  $submitButton.on('click', function(event) {
    event.preventDefault();
    if ($commentBox.val().trim().length) {
      $modalForm.submit();
    } else {
      $('#comment_popup').popover('show');
      $('#comment_popup').focus();
    }
  })

}) });