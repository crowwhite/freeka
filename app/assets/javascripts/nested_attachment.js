function NestedAttachment(parentDivId) {
  this.$parentDiv = $('#' + parentDivId);
}

NestedAttachment.prototype.createNestedAttachmentHtml = function() {
  var attachmentTimeStamp = $.now();
  return "<div class='col-md-10 single-file'>\
            <br>\
            <br>\
            <label class='col-md-2 control-label' for='file_attachment'>File</label>\
            <div class='col-md-10'>\
              <div class='row'>\
                <div class='col-md-5'>\
                  <div class='' id='requirement_files_attributes_" + attachmentTimeStamp + "_file_attachment_wrap'>\
                    <input class='' id='requirement_files_attributes_" + attachmentTimeStamp + "_file_attachment' name='requirement[files_attributes][" + attachmentTimeStamp + "][attachment]' type='file' value=''>\
                    <div id='requirement_files_attributes_" + attachmentTimeStamp + "_file_attachment_wrap_list'>\
                    </div>\
                  </div>\
                </div>\
                <!-- Caption -->\
                <label class='col-md-2 control-label' for='requirement_files_attributes_0" + attachmentTimeStamp + "_caption'> </label>\
                <div class='col-md-4'>\
                  <input class='form-control' id='requirement_files_attributes_0" + attachmentTimeStamp + "_caption' name='requirement[files_attributes][" + attachmentTimeStamp + "][caption]' type='text' value='' placeholder='Caption'>\
                </div>\
                <div class='col-md-1'>\
                  <button type='button' class='close' data-dismiss='alert'>\
                  <span aria-hidden='true'>&times;</span>\
                </div>\
              </div>\
            </div>\
          </div>";
}

NestedAttachment.prototype.addNestedAttachmentField = function() {
  this.$parentDiv.append(this.createNestedAttachmentHtml);
}

NestedAttachment.prototype.bindEvents = function(btnId) {
  var _this = this;
  $('#' + btnId).on('click', function(event) {
    event.preventDefault();
    _this.addNestedAttachmentField();
  });
}

$(function() {
  new NestedAttachment('files').bindEvents('add-files');
});

