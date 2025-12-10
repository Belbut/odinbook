# isolated_request.rb
require "benchmark"
require "securerandom"
require "action_dispatch"

strategy = ARGV[0]

unless strategy
  puts "Usage: ruby isolated_request.rb <strategy>"
  exit 1
end

def new_session
  s = ActionDispatch::Integration::Session.new(Rails.application)
  s.host = "localhost"
  s
end

def bench(strategy)
  app = new_session

  # Clear AR caches for isolation
  ActiveRecord::Base.connection.clear_query_cache
  ActiveRecord::Base.connection.disable_query_cache!
  GC.start

  before = GC.stat[:heap_live_slots]

  time = Benchmark.realtime do
    app.get "/users/71/posts?strategy=#{strategy}",
            headers: { "X-Bypass" => SecureRandom.hex }
  end

  after = GC.stat[:heap_live_slots]

  { time: time, objects: after - before, status: app.response.status }
end

puts "Benchmarking strategy: #{strategy}"
puts "-" * 60

result = bench(strategy)

puts "Strategy: #{strategy}"
puts "Time:     #{result[:time].round(5)} seconds"
puts "Objects:  #{result[:objects]}"
puts "Status:   #{result[:status]}"
puts "-" * 60
