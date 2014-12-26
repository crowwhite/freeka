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
    _this.loadMoreElements();
  });
}

ScrollableElement.prototype.loadMoreElements = function() {
  var pixelsLeftAtBottom = $('body').height() - this.$windowObject.scrollTop() - this.$windowObject.height();
  if(pixelsLeftAtBottom < this.remainingPixels && this.runOncePerUpdation() && !this.waitForResponse) {
    this.waitForResponse = true;
    this.getElements();
  }
}

ScrollableElement.prototype.runOncePerUpdation = function() {
  if(this.$containerElement.height() == this.containerElementHeight) {
    return false;
  }
  return true;
}

ScrollableElement.prototype.getElements = function() {
  var _this = this;
  $.ajax({
    type: "GET",
    dataType: "html",
    url: _this.url,
    data: { 'page': $('#page').val(), 'ajax': true },
    success: function (response) {
      $('#page').remove();
      $('#tiles-not-loaded').remove();
      _this.containerElementHeight = _this.$containerElement.height();
      _this.$containerElement.append(response);
    },
    complete: function() {
      _this.waitForResponse = false;
    },
    error: function() {
      $('#tiles-not-loaded').remove();
      $('body').append($('<div>', { html: 'Some thing went wrong while fetching more records. Please refresh the page.', class: 'alert alert-danger', role: 'alert', id: 'tiles-not-loaded' }))
    }
  });
}

$(function() {
  (new ScrollableElement(300, '/', $('#requirement-tiles'))).bindEvents();
})