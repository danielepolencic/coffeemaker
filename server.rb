require 'sinatra'
require 'wiringpi'
require 'observer'

class Notifier

end

class CoffeeNotifier < Notifier
  def update( timer )
    if timer.countdown <= 0 and timer.active
      puts "Coffeeeee!"
      # io.write( pin, HIGH )
    end
  end
end

class Timer
  include Observable

  attr_accessor :active
  attr_accessor :countdown
  attr_accessor :set_at
  attr_accessor :started_at

  def update
    if @active
      countdown -= 1
    end
    notify_observers self
  end

  def setTimerWithSeconds( seconds )
    @set_at = seconds
    @countdown = seconds
    @started_at = Time.now
  end

  def reset
    @active = false
    @countdown = nil
    @set_at = nil
    @started_at = nil
  end

end

clock = Timer.new
io = WiringPi::GPIO.new
# io.write(pin,value)
# io.read(pin,value)

get '/' do
  "Home page"
end

get '/time' do
  "Time is:"
end

post '/time/:countdown' do

end
