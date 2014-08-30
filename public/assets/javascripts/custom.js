window.error_message = function(message) {
  var html = "<div class=\"alert alert-danger alert-dismissible\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\"><span aria-hidden=\"true\">&times;</span><span class=\"sr-only\">Close</span></button><strong>Warning! </strong> "+ message +"</div>";
  return html;
}
$(document).ready(function(){
  $("#inputForm").submit(function(e){
    e.preventDefault();
    $("#input").fadeOut("slow", function(){
      $(".alert").remove();
      $("#inputTitle").text("Input Text")
      var ngram = $("#ngram").val();
      var first_text = $("#first_text").val();
      var second_text = $("#second_text").val();
      if(ngram && first_text && second_text) {
        $.ajax({
          type: "POST",
          url: "/calculate",
          data: {ngram: ngram, first_text: first_text, second_text: second_text},
          success: function(data) {
            $("#inputTitle").text("Result");
            $("#result").show();
            $("#input").fadeIn("slow", function(){
              $("#first_text_ngram").val(data.first_text_ngram);
              $("#second_text_ngram").val(data.second_text_ngram);
              $("#first_text_hash").val(data.first_text_hashes);
              $("#second_text_hash").val(data.second_text_hashes);
              $("#first_text_fingerprint").val(data.first_text_fingerprint);
              $("#second_text_fingerprint").val(data.second_text_fingerprint);
              $("#similarity_finger_print").val(data.similar_fingerprint);
              $("#duplication").val(data.result);
              console.log(data);
            })
            $("#inputForm").hide();
          },
        });
      }else{
        $("#input").fadeIn("slow", function(e){
          if(!ngram){
            $("#inputForm").prepend(window.error_message("Ngram Tidak Boleh Kosong"));
          }
          if(!first_text){
            $("#inputForm").prepend(window.error_message("Text Pertama Tidak Boleh Kosong"));
          }
          if(!second_text){
            $("#inputForm").prepend(window.error_message("Text Pertama Tidak Boleh Kosong"));
          }
        });
      }
    });
  });
});
