var commentAdder = function(data) {
  $('.text-area').val('')
  var comment = "<li class='highlight-grey-border round-corners'><strong>&nbsp;<a href='/users/'" +
    data.user_id +
    ">" +
    data.user_name +
    "</a></strong> commented on " +
    data.time +
    "<pre class='highlight-grey-border'>" +
    data.comment +
    "</pre></li>";
  $('#add-comment').before(comment);
}

$(function() {
  var pusher = new Pusher('0ce2348f1428f9764747');
  var url = document.URL;
  var channel = pusher.subscribe('channel_' + url.substring(url.lastIndexOf('/') + 1));
  channel.bind('new_comment', function(data) {
    commentAdder(data);
  });
})