function DropDownIcon(iconClass) {
  this.$icons = $('.' + iconClass);
}

DropDownIcon.prototype.bindEvents = function() {
  var _this = this;
  _this.$icons.on('click', _this.showSubItems);
}

DropDownIcon.prototype.showSubItems = function() {
  var $icon = $(this);
  var classOfChildren = $icon.closest('.parent-item').data('id');
  $('.' + classOfChildren).toggleClass('hidden');
  $icon.toggleClass('down');
}

$(function() {
  new DropDownIcon('icon-for-sub-category').bindEvents();
})