require "live_assets/engine"
require "thread"
require "listen"

module LiveAssets
  autoload :SSESubscriber, 'live_assets/sse_subscriber'

  mattr_reader :subscribers
  @@subscribers = []

  def self.unsubscribe_all
    subscribers.clear
  end

  # Subscribe to all published events
  def self.subscribe(subscriber)
    subscribers << subscriber
    puts "#{subscribers}"
  end

  # Unsubscribe an existing subscriber
  def self.unsubscribe(subscriber)
    subscribers.delete(subscriber)
  end

  # Start a listener for the following directories.
  # Every time a change happens, publish the given
  # event to all subscribers available
  def self.start_listener(event, directories)
    Thread.new do
      listener = Listen.to(*directories, latency: 0.5) do |_modified, _added, _removed|
        puts 'received event'
        subscribers.each { |s| s << event }
      end
      listener.start
    end
  end

  # event is 'ping'
  # time is the time to wait
  def self.start_timer(event, time)
    Thread.new do
      while true
        subscribers.each { |s| s << event}
        sleep(time)
      end
    end
  end
end