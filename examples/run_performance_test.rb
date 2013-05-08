SERVER = 'localhost'
PORT = 3000
ITERATIONS = 1
DEFAULT_NUM_CONNECTIONS = 1000
MULTI_QUERIES = 10

def do_httperf(uri, num_conns)
  command = <<BASH
httperf --hog \
        --server #{SERVER} \
        --port #{PORT} \
        --uri "#{uri}" \
        --num-conns #{num_conns}
BASH
  `#{command}`
end

class ParseHttperfLog

  def initialize(logfile_name)
    @logfile_name = logfile_name
    @stats = {
      :min => [],
      :avg =>[],
      :max => [],
      :stddev => []
    }
  end

  def run
    parse_log
    print_stats
  end

  def parse_log
    File.open(@logfile_name).readlines.each do |line|
      next if line =~ /^#/
      if line =~ /Reply rate \[replies\/s\]: min ([0-9.]+) avg ([0-9.]+) max ([0-9.]+) stddev ([0-9.]+)/
        puts line
        @stats[:min] << $1.to_f
        @stats[:avg] << $2.to_f
        @stats[:max] << $3.to_f
        @stats[:stddev] << $4.to_f
      end
    end
  end
  
  def average(arr)
    sum = arr.inject(0) { |acc, a| acc + a }
    sum > 0 ? (sum / arr.length) : 0
  end
  
  def print_stats
    average = average @stats[:avg]
    std_dev = average @stats[:stddev]
    
    "Aggregate Reply rate [replies/s]: min #{format_float @stats[:min].min} avg #{format_float average} max #{format_float @stats[:max].max} stddev #{format_float std_dev}"
  end

  def format_float(value)
    "%0.1f" % value
  end

end

tests = {
  single_insert: {
    uri: '/single_insert?user[username]=goggin13&user[bio]=helloworld'
  },
  single_query: {
    uri: '/single_query'
  },
  single_query_10: {
    uri: "/single_query?queries=#{MULTI_QUERIES}"
  },
  single_update: {
    uri: '/single_update'
  },
  single_update_10: {
    uri: '/single_update?queries=10'
  },  
  embedded_insert: {
    uri: '/embedded_insert?post[title]=goggin13&post[content]=helloworld'
  },
  embedded_update: {
    uri: '/embedded_update'
  },
  embedded_update_10: {
    uri: "/embedded_update?queries=#{MULTI_QUERIES}"
  },  
  embedded_query: {
    uri: '/embedded_query'
  },
  embedded_query_10: {
    uri: "/embedded_query?queries=#{MULTI_QUERIES}"
  }  
}
  

result_file = File.open 'perf_logs/results.txt', 'a'

result_file.puts ""
result_file.puts "*" * 80
result_file.puts Time.now
result_file.puts ""

tests.each do |test, meta|
  logfile_path = "perf_logs/#{test}.txt"
  logfile = File.open logfile_path, 'w+'
  
  ITERATIONS.times do |i|
    start = Time.now
    puts "#{test} - #{i}"
    num_connections = meta[:conns] || DEFAULT_NUM_CONNECTIONS
    results = do_httperf(meta[:uri], num_connections)
    if !(results =~ /Reply status: 1xx=0 2xx=#{num_connections} 3xx=0 4xx=0 5xx=0/)
      puts "non 200 responses"
      result_file.puts "non 200 responses"
      result_file.puts results
    end
    logfile.puts results
    duration = Time.now - start
    puts "\tcompleted in #{duration} seconds"
  end
  logfile.close
  
  stats = ParseHttperfLog.new(logfile_path).run

  result_file.puts test
  result_file.puts stats
  result_file.flush
end

result_file.close

