$(function(){
  $("#show-limit").on("change", function(){
    $(this).closest("form").trigger("submit");
  });
})

$("#micropost_picture").bind("change", function() {
  var size_in_megabytes = this.files[0].size/1024/1024;
  if (size_in_megabytes > Settings.feedItems) {
    alert(I18n.t("translate_to_js.notice_file"));
  }
});
