function LoadingButton(classOfButton) {
  this.$buttons = $('.' + classOfButton)
}

LoadingButton.prototype.bindEvents = function() {
  this.$buttons.on('click', '.loader-btn', function() {
    $(this).html('<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> Loading...')
  });
};

$(function() {
  (new LoadingButton('loader').bindEvents());
})