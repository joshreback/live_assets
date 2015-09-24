require 'pry'

class LiveAssetsController < ActionController::Base
  include ActionController::Live

  def hello
    while true
      response.stream.write "Hello World\n"
      sleep 1
    end
  rescue IOError
    response.stream.close
  end

  def sse
    response.headers["Cache-Control"] = "no-cache"
    response.headers["Content-Type"] = "text/event-stream"

    sse = LiveAssets::SSESubscriber.new
    sse.each do |msg|
      puts "#{msg}"
      response.stream.write msg
    end
  rescue IOError
    sse.close
    response.stream.close
  end
end