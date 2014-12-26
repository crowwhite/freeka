function StatusButton(buttonClass) {
  this.$StatusButtons = $('.' + buttonClass);
}

StatusButton.prototype.bindEvents = function() {
  this.$StatusButtons.on('click', this.showHideRecords);
}

StatusButton.prototype.showHideRecords = function() {
  event.preventDefault();
  var $buttonClicked = $(this);

  $('#all-users').removeClass('hidden');
  $('.status-button.active').toggleClass('active');
  $buttonClicked.addClass('active');

  var recordsToHide = $('.status-button.active').data('hide');
  $('.user-table tr').removeClass('hidden');
  $('.' + recordsToHide).closest('tr').toggleClass('hidden');
}

$(function() {
  new StatusButton('status-button').bindEvents();
});