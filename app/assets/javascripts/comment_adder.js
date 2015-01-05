var commentAdder = function(data) {
  $('.text-area').val('')
  var $linkToUser = $('<a>', { href: '/users/' + data.user_id, html: data.user_name });
  var $bold = $('<strong>', { html: '&nbsp;' });
  var $content = $('<pre>', { html: data.comment, class: 'highlight-grey-border' });
  var $listItem = $('<li>', { class: 'highlight-grey-border round-corners' });
  var $comment = $listItem.html(' commented on ' + data.time).prepend($bold.append($linkToUser)).append($content);
  $('#add-comment').before($comment);
}

$(function() {
  var pusher = new Pusher($('#app_key').val());
  var url = document.URL;
  var channel = pusher.subscribe('channel_' + url.substring(url.lastIndexOf('/') + 1));
  channel.bind('new_comment', function(data) {
    commentAdder(data);
  });
})