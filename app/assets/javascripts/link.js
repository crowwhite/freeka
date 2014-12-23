function Link(classOfLink) {
  this.$links = $('.' + classOfLink)
};

Link.prototype.bindEvents = function() {
  var _this = this;
  this.$links.on('click', function(event) {
    event.preventDefault();
    _this.markForRemoval(this);
  })
};

Link.prototype.markForRemoval = function(link) {
  var link = $(link);
  var hiddenField = link.nextAll(".hidden_field").first();
  var linkTextElements = link.find('.remove-text');
  linkTextElements.toggleClass('hiddenn').toggleClass('selected');
  hiddenField.val(linkTextElements.filter('.selected').attr('data-remove'));
};

$(function() {
  (new Link('remove').bindEvents());
});