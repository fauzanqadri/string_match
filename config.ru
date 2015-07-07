require 'rubygems'
require 'sprockets'
require 'json'
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'string'
require 'robin_karp'
require 'aho'

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


map '/calculate' do
  run lambda { |env|
    req = Rack::Request.new(env)
    response_code = env['REQUEST_METHOD'] == 'POST' ? 200 : 500
    response_header = response_code == 200 ? {"Content-Type" => "application/json"} : {"Content-Type" => "text/html"}
    request_hash = req.POST.inject({}){|memo, (k, v)| memo[k.to_sym] = k == 'ngram' ? v.to_i : v; memo}
    robin_karp = RobinKarp.new(request_hash)
    aho_corasick = Aho.new(request_hash)
    robin_karp_time_elapsed = Time.now
    rk_result = robin_karp.as_hash
    rk_result.merge!(time_elapsed: (Time.now - robin_karp_time_elapsed))
    aho_corasick_time_elapsed = Time.now
    ac_result = aho_corasick.as_hash
    ac_result.merge!(time_elapsed: (Time.now - aho_corasick_time_elapsed))
    response_body = {
      robin_karp: rk_result,
      aho_corasick: ac_result
    }
    [
      response_code,
      response_header,
      [response_body.to_json]
    ]
  }
end
