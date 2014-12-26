function RequestTile(tileClass) {
  this.$tiles = $('.' + tileClass);
}

RequestTile.prototype.bindEvents = function() {
  var _this = this;
  _this.$tiles.on('click', function() {
    _this.browseToLink(this);
  });
}

RequestTile.prototype.browseToLink = function(tile) {
  window.location = $(tile).find('div.title a').attr('href');
}

$(function() {
  new RequestTile('request-tile').bindEvents();
});