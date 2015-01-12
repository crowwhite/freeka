// FIXME_AB: Why do we need this js, don't we have a better way?
// I tried wrapping it in anchor tag, but it didn't work fine
function RequestTile(containerClass, tileClass) {
  this.$container = $('.' + containerClass);
  this.tileClass = tileClass;
}

RequestTile.prototype.bindEvents = function() {
  var _this = this;
  _this.$container.on('click', '.' + _this.tileClass,function() {
    _this.browseToLink(this);
  });
}

RequestTile.prototype.browseToLink = function(tile) {
  window.location = $(tile).find('div.title a').attr('href');
}

$(function() {
  new RequestTile('tiles', 'request-tile').bindEvents();
});