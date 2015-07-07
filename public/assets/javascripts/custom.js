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
            $("#action").show();
            $("#input").fadeIn("slow", function(){
              $("#robin_karp_first_text").val(data.robin_karp.first_text)
              $("#robin_karp_first_text_ngram").val(data.robin_karp.first_text_ngram)
              $("#robin_karp_first_text_hash").val(data.robin_karp.first_text_hashes)
              $("#robin_karp_first_text_fingerprint").val(data.robin_karp.first_text_fingerprints)

              $("#robin_karp_second_text").val(data.robin_karp.second_text)
              $("#robin_karp_second_text_ngram").val(data.robin_karp.second_text_ngram)
              $("#robin_karp_second_text_hash").val(data.robin_karp.second_text_hashes)
              $("#robin_karp_second_text_fingerprint").val(data.robin_karp.second_text_fingerprints)

              $("#robin_karp_similarity_fingerprint").val(data.robin_karp.similar_fingerprint)

              $("#robin_karp_duplication").val(data.robin_karp.coeffision_similarity)


              $("#aho_first_text").val(data.aho_corasick.first_text)
              $("#aho_first_text_ngram").val(data.aho_corasick.first_text_ngram)
              $("#aho_first_text_match_pattern").val(data.aho_corasick.first_text_match_pattern)

              $("#aho_second_text").val(data.aho_corasick.second_text)
              $("#aho_second_text_ngram").val(data.aho_corasick.second_text_ngram)
              $("#aho_second_text_match_pattern").val(data.aho_corasick.second_text_match_pattern)

              $("#aho_simmilar_matching_pattern").val(data.aho_corasick.similar_matching_pattern)

              $("#aho_duplication").val(data.aho_corasick.coeffision_similarity)

              $("#robin_karp_running_time").text(data.robin_karp.time_elapsed + " S")

              $("#aho_running_time").text(data.aho_corasick.time_elapsed + " S")
            })
            $("#inputForm").hide();
          },
        });
      }else{
        $("#input").fadeIn("slow", function(e){
          if(!ngram){
            $("#inputForm").prepend(window.error_message("n-Gram Tidak Boleh Kosong"));
          }
          if(!first_text){
            $("#inputForm").prepend(window.error_message("Text Pertama Tidak Boleh Kosong"));
          }
          if(!second_text){
            $("#inputForm").prepend(window.error_message("Text Kedua Tidak Boleh Kosong"));
          }
        });
      }
    });
  });
});
