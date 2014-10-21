require 'rubygems'
require 'sprockets'
require 'json'
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'string'
require 'robin_karp'
require 'boyer_moore'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'public/assets/javascripts'
  environment.append_path 'public/assets/stylesheets'
  run environment
end

map '/' do
  run lambda {|env|
    body = File.open('public/index.html', File::RDONLY)

    headers = {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400'
    }
    response = Rack::Response.new body, 200, headers
    response.set_cookie(";-p", {value: "Kontribusi yuuk di https://github.com/fauzanqadri/string_match", path: "/", expires: Time.now+24*60*60})
    response.finish
  }
end

def build_response env
end

map '/calculate' do
  run lambda { |env|
    req = Rack::Request.new(env)
    response_code = env['REQUEST_METHOD'] == 'POST' ? 200 : 500
    response_header = response_code == 200 ? {"Content-Type" => "application/json"} : {"Content-Type" => "text/html"}
    request_hash = req.POST.inject({}){|memo, (k, v)| memo[k.to_sym] = k == 'ngram' ? v.to_i : v; memo}
    robin_karp_result = nil
    boyer_moore_result = nil
    robin_karp = RobinKarp.new(request_hash)
    boyer_moore = BoyerMoore.new(request_hash[:first_text], request_hash[:second_text])
    boyer_moore_second_text_suffixes = request_hash[:second_text].to_boyer_moore_suffixes
    boyer_moore_second_text_goodsuffixes = request_hash[:second_text].to_boyer_moore_goodsuffix_heuristic
    boyer_moore_second_text_boyer_table = request_hash[:second_text].to_boyer_moore_badcharacter_heuristic
    start_karp = Time.now
    robin_karp_result = robin_karp.coeffision_similarity
    stop_karp = Time.now
    karp_running_time = stop_karp - start_karp
    start_moore = Time.now
    boyer_moore_result = boyer_moore.result
    stop_moore = Time.now
    moore_running_time = stop_moore - start_moore
    puts boyer_moore.result
    response_body = {
      robin_karp: {
        first_text_ngram: robin_karp.first_text.downcase.to_ngram(request_hash[:ngram]).to_s,
        second_text_ngram: robin_karp.second_text.downcase.to_ngram(request_hash[:ngram]).to_s,
        first_text_hashes: robin_karp.first_text_hashes.to_s,
        second_text_hashes: robin_karp.second_text_hashes.to_s, 
        first_text_fingerprint: robin_karp.first_text_fingerprints.to_s,
        second_text_fingerprint: robin_karp.second_text_fingerprints.to_s,
        similar_fingerprint: robin_karp.similar_fingerprint.to_s,
        result: robin_karp_result,
        karp_runing_time: format("%.6f", karp_running_time)
      },
      boyer_moore: {
        second_text_suffixes: boyer_moore_second_text_suffixes.to_s,
        second_text_boyer_table: boyer_moore_second_text_boyer_table.to_s,
        second_text_goodsuffixes: boyer_moore_second_text_goodsuffixes.to_s,
        result: boyer_moore_result,
        moore_runing_time: format("%.6f", moore_running_time)
      }
    }
    [
      response_code,
      response_header,
      [response_body.to_json]
    ]
  }
end
