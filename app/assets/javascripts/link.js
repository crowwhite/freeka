function Link(linkClass) {
  this.$links = $('.' + linkClass);
// FIXME_AB: can you add some comments what is the purpose of this Link class. Why we need this. Looks like Link is not the right name for the class
// FIXME_AB: I can't judge what this class is doing
// When we edit a requirement, a X link is provided to remove files, this class is used for that.
};

Link.prototype.bindEvents = function() {
  var _this = this;
  this.$links.on('click', function(event) {
    event.preventDefault();
    _this.markForRemoval(this);
  });
};

Link.prototype.markForRemoval = function(link) {
  var $link = $(link);
  var $hiddenField = $link.nextAll(".hidden_field").first();
  var $linkTextElements = $link.find('.remove-text');
  $linkTextElements.toggleClass('hidden').toggleClass('selected');
  $hiddenField.val($linkTextElements.filter('.selected').attr('data-remove'));
};

$(function() {
  // FIXME_AB: Since we are creating only on object on the page, should we follow constructor pattern here for link class?
  // Probably we would need it somewhere else too. So used
  (new Link('remove').bindEvents());
});