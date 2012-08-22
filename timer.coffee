cronJob = require('cron').CronJob
Picomachine = require 'picomachine'

class Timer

  constructor         : ( settings = {} ) ->

    @countdown_start = @countdown = if settings.countdown? then settings.countdown else 0
    @callback = if settings.callback? then settings.callback else false

    self = @

    @timer = new Picomachine 'ready'
    @timer.transitionsFor['start']   = ready     : 'run'
    @timer.transitionsFor['pause']   = run       : 'wait'
    @timer.transitionsFor['resume']  = wait      : 'run'
    @timer.transitionsFor['stop']    = run       : 'stop'
    @timer.transitionsFor['reset']   = run       : 'ready' , pause : 'ready', stop : 'ready'
    @cron = new cronJob '* * * * * *', () ->
      self.countdown -= 1
      if self.countdown <= 0
        self.ring()
    , null, no, "Europe/London"

  ring                : () ->
    @stopTimer()
    @callback and @callback()

  status              : () ->
    state     : @timer.state
    countdown : @countdown

  setTimerWithSeconds : ( @countdown_start ) ->
    @countdown = @countdown_start

  setTimerWithCallback: ( @callback ) ->

  startTimer          : () ->
    @timer.trigger 'start'
    @cron.start()

  stopTimer           : () ->
    @timer.trigger 'stop'
    @cron.stop()

  resumeTimer         : () ->
    @timer.trigger 'resume'
    @cron.start()

  pauseTimer          : () ->
    @timer.trigger 'pause'
    @cron.stop()

  reset               : ( toZero = no ) ->
    @timer.trigger 'reset'
    @countdown = if toZero then 0 else @countdown_start
    @cron.stop()

module.exports = Timer
