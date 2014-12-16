function RemoveFile(classOfLink) {
  this.$links = $('.' + classOfLink)
};

RemoveFile.prototype.bindEvents = function() {
  this.$links.on('click', function(event) {
    event.preventDefault();
    link = $(this)
    hiddenField = link.nextAll(".hidden_field").first();
    hiddenField.val(hiddenField.val() == 'false' ? 'true' : 'false');
    link.html(link.html() == 'X' ? 'Undo Remove' : 'X')
    console.log(hiddenField.val());
  });
};

$(function() {
  (new RemoveFile('remove').bindEvents());
});