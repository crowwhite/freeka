var notifyOnPage = function(message) {
  var $popUpDiv = $('<div>', { id: 'pop-message' });
  var $message = $('<i>', { html: message });
  var $reloadLink = $('<a>', { html: 'Refresh', href: '#' }).css({ 'margin-bottom': '5px' });
  var $ignoreLink = $('<a>', { html: 'Ignore', href: '#' }).css({ 'margin-bottom': '5px' });
  $reloadLink.on('click', function(){
    event.preventDefault();
    location.reload();
  });
  $ignoreLink.on('click', function(){
    event.preventDefault();
    $('#pop-message').remove();
  });
  $popUpDiv.append($message).append('<br><br>').append($reloadLink).append(' | ').append($ignoreLink);
  $popUpDiv.css({ position: 'fixed', bottom: '0px', right: '0px', height: '80px', width: '200px', 'background-color': 'rgb(191, 189, 1)', padding: '10px', border: '1px solid grey' });
  $('body').append($popUpDiv);
}

var appendSocketId = function(elementId) {
  $('#' + elementId).append($socket_id);
}

$(function() {
  var pusher = new Pusher($('#app_key').val());
  var url = document.URL;
  var socketId = null;
  pusher.connection.bind('connected', function() {
    socketId = pusher.connection.socket_id;
    var $socket_id = $('<input>', { value: socketId, type: 'hidden', name: 'comment[socket_id]' })
    appendSocketId('new_comment');
  });
  var channel = pusher.subscribe('channel_' + url.substring(url.lastIndexOf('/') + 1));
  channel.bind('add_comment', function(message) {
    notifyOnPage(message)
  });
})