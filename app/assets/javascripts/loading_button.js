function LoadingButton(buttonClass) {
  this.$buttons = $('.' + buttonClass);
}

LoadingButton.prototype.bindEvents = function() {
  this.$buttons.on('click', '.loader-btn', this.showLoader);
};

LoadingButton.prototype.showLoader = function() {
  $(this).html('<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> Loading...');
};

$(function() {
  new LoadingButton('loader').bindEvents();
});