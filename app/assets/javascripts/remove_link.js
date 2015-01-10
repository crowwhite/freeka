function RemoveLink(containerId, buttonClass, elementToBeRemovedClass) {
  this.buttonClass = buttonClass;
  this.containerId = containerId;
  this.elementToBeRemovedClass = elementToBeRemovedClass;
}

RemoveLink.prototype.bindEvents = function() {
  var _this = this;
  $('#' + _this.containerId).on('click', '.' + _this.buttonClass, function() {
    console.log('clicked')
    _this.removeElement($(this));
  });
}

RemoveLink.prototype.removeElement = function($buttonClicked) {
  $buttonClicked.closest('.' + this.elementToBeRemovedClass).remove();
}

$(function() {
  new RemoveLink('files', 'close', 'single-file').bindEvents();
})