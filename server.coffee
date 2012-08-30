require 'coffee-script'
Timer = require './timer'
CoffeeMaker = require './coffeemaker'

express = require 'express'
app = express()

# app.set 'view engine', 'hbs'
app.set 'views', __dirname + '/views'
app.set 'view engine', 'html'
app.engine '.html', require('hbs').__express
app.use express.static( __dirname + '/public' )

machine = new CoffeeMaker
timer = new Timer

isDirty = (req, res, next) ->
  console.log "LOG: Middleware %o", machine.status().state
  if machine.status().state is 'dirty'
    # res.end 'Coffee made. Reset to start again'
    res.render 'aborted'
  else
    next()

# app.use isDirty()

app.get '/', ( req, res ) ->
  res.render 'index', machine : machine.status(), timer : timer.status()

app.get '/add', ( req, res ) ->
  res.render 'add'

app.get '/timer/start', isDirty, ( req, res ) ->
  console.log "LOG: start"
  timer.startTimer()

app.get '/stop', isDirty, ( req, res ) ->
  timer.reset()
  machine.stop()
  res.redirect '/'

app.get '/timer/stop', isDirty, ( req, res ) ->
  console.log "LOG: stop"
  timer.reset()
  res.redirect '/'

app.get '/timer/pause', isDirty, ( req, res ) ->
  console.log "LOG: pause"
  timer.pauseTimer()

app.get '/timer/resume', isDirty, ( req, res ) ->
  console.log "LOG: resume"
  timer.resumeTimer()

app.post '/timer/:seconds', isDirty, ( req, res ) ->
  console.log "LOG: req.params.seconds %o", req.params.seconds
  timer.setTimerWithSeconds req.params.seconds
  timer.setTimerWithCallback ->
    machine.start()

  #and start
  timer.startTimer()
  res.send 'Thanks'

app.get '/reset', ( req, res ) ->
  machine.reset()
  timer.reset( yes )
  res.redirect '/'

app.listen 3000

# clock = new Timer
#   countdown     : 10
#   callback      : () -> console.log "daniele"
# clock.startTimer()

# machine = new CoffeeMaker
# machine.start()

