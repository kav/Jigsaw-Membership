express = require('express')
stylus  = require('stylus')
url = require('url')
http = require('http')
auth= require('connect-auth')

google = require(__dirname + '/middleware/google')(app)

app = module.exports = express.createServer()

app.configure ->
  app.set 'views', __dirname + '/../views'
  app.set 'view engine', 'jade'
  app.set 'jsonp callback', true
  app.use express.favicon()
  app.use(express.cookieParser())
  app.use(express.session({ secret: "keyboard dog" }))
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.methodOverride()
  app.use auth(
    strategies: [auth.Google2(
      appId : "1016234651494.apps.googleusercontent.com"
      appSecret: "C3Emg51hWunx0kFcEXSsDOC7"
      callback: "http://localhost/admin")]
    )
  app.use stylus.middleware 
    src: __dirname + '/../client'
    dest: __dirname + '/../cache'
  app.use express.compiler
    src: __dirname + '/../client'
    dest: __dirname + '/../cache'
    enable: ['coffeescript']
  
  app.use express.compiler
    src: __dirname + '/../shared'
    dest: __dirname + '/../cache'
    enable: ['coffeescript']
  
  app.use express.static(__dirname + '/../cache')
  app.use express.static(__dirname + '/public')
  
app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true
    
app.configure 'staging', ->
  app.use express.errorHandler()

app.configure 'production', ->
  app.use express.errorHandler()

#app.get '/', google.ensureLogin, (req, res) ->
app.get '/join', (req, res) ->
  res.render('join')
  
app.get '/admin', google.ensureLogin, (req, res) ->
  res.send('Yo Boss')
  
app.get '/PayPal_IPN', (req,res) ->
  #Handle paypal messages to this URL. May be post, not get.
  
app.listen process.env.NODE_PORT ? 80
console.log "Express server listening on port #{app.address().port} in #{app.settings.env} mode"

process.on 'uncaughtException', (err) -> console.log "ERROR: #{err}"
