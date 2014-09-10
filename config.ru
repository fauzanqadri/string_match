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
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('public/index.html', File::RDONLY)
    ]
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
    robin_karp = RobinKarp.new(request_hash)
    boyer_moore = BoyerMoore.new(request_hash[:second_text], request_hash[:first_text])
    response_body = {
      robin_karp: {
        first_text_ngram: robin_karp.first_text.downcase.to_ngram(request_hash[:ngram]).to_s,
        second_text_ngram: robin_karp.second_text.downcase.to_ngram(request_hash[:ngram]).to_s,
        first_text_hashes: robin_karp.first_text_hashes.to_s,
        second_text_hashes: robin_karp.second_text_hashes.to_s, 
        first_text_fingerprint: robin_karp.first_text_fingerprints.to_s,
        second_text_fingerprint: robin_karp.second_text_fingerprints.to_s,
        similar_fingerprint: robin_karp.similar_fingerprint.to_s,
        result: robin_karp.coeffision_similarity
      },
      boyer_moore: {
        result: boyer_moore.result
      }
    }
    [
      response_code,
      response_header,
      [response_body.to_json]
    ]
  }
end
