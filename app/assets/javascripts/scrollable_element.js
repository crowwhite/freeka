function ScrollableElement(remainingPixels, url, $containerElement) {
  this.$windowObject = $(window);
  this.url = url;
  this.$containerElement = $containerElement;
  this.containerElementHeight = 0;
  this.waitForResponse = false;
  this.remainingPixels = remainingPixels;
}

ScrollableElement.prototype.bindEvents = function() {
  var _this = this;
  _this.$windowObject.on('scroll', function() {
    var pixelsLeftAtBottom = $('body').height() - _this.$windowObject.scrollTop() - _this.$windowObject.height();
    if(pixelsLeftAtBottom < _this.remainingPixels && _this.runOncePerUpdation() && !_this.waitForResponse) {
      _this.waitForResponse = true;
      _this.loadMoreElements();
    }
  });
}

ScrollableElement.prototype.runOncePerUpdation = function() {
  if(this.$containerElement.height() == this.containerElementHeight) {
    return false;
  }
  else {
    return true;
  }
}

ScrollableElement.prototype.loadMoreElements = function() {
  var _this = this;
  $.ajax({
    type: "GET",
    dataType: "html",
    url: _this.url,
    data: { 'page': $('#page').val(), 'ajax': true },
    success: function (response) {
      $('#page').remove();
      _this.containerElementHeight = _this.$containerElement.height();
      _this.$containerElement.append(response);
      _this.waitForResponse = false;
;    }
  });
}

$(function() {
  (new ScrollableElement(300, '/', $('#requirement-tiles'))).bindEvents();
})