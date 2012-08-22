require 'coffee-script'
gpio = require 'gpio'
Timer = require './timer'
Picomachine = require 'picomachine'

class CoffeeMaker

  constructor         : () ->

    self = @
    @gpio = gpio.export 4, direction : 'out'

    @coffeeMaker = new Picomachine 'ready'
    @coffeeMaker.transitionsFor['start']   = ready   : 'cooking'
    @coffeeMaker.transitionsFor['stop']    = cooking : 'dirty'
    @coffeeMaker.transitionsFor['reset']   = cooking : 'ready',  dirty  : 'ready'

    @clock = new Timer
      countdown     : 10
      callback      : -> self.stop()

  start               : () ->
    @coffeeMaker.trigger 'start'
    @clock.startTimer()
    @gpio.set()
    console.log "LOG: make coffee"

  stop                : () ->
    @coffeeMaker.trigger 'stop'
    @clock.stopTimer()
    @gpio.set 0
    console.log "Coffee Maker stopped"

  status              : () ->
    state         : @coffeeMaker.state
    timer         : @clock.status()

  reset               : () ->
    @coffeeMaker.trigger 'reset'
    @gpio.set 0
    @clock.reset()

module.exports = CoffeeMaker
