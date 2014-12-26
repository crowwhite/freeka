function StatusButton(buttonClass) {
  this.$StatusButtons = $('.' + buttonClass);
}

StatusButton.prototype.bindEvents = function() {
  this.$StatusButtons.on('click', this.showHideRecords);
}

StatusButton.prototype.showHideRecords = function() {
  event.preventDefault();
  var $buttonClicked = $(this);
  var recordsToHide = $buttonClicked.data('hide');
  $('.' + recordsToHide).closest('tr').toggleClass('hidden');
  $buttonClicked.toggleClass('active');
}

$(function() {
  new StatusButton('status-button').bindEvents();
});