express = require('express')
stylus  = require('stylus')
url = require('url')
http = require('http')

google = require(__dirname + '/middleware/google')

app = module.exports = express.createServer()

app.configure ->
  app.set 'views', __dirname + '/../views'
  app.set 'view engine', 'jade'
  app.set 'jsonp callback', true
  app.use express.favicon()
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.methodOverride()
  
  app.use express.compiler
    src: __dirname + '/../client'
    dest: __dirname + '/../cache'
    enable: ['coffeescript']
  
  app.use express.compiler
    src: __dirname + '/../shared'
    dest: __dirname + '/../cache'
    enable: ['coffeescript']
    
  app.use stylus.middleware 
    src: __dirname + '/../client'
    dest: __dirname + '/../cache'
  
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
  process.on 'uncaughtException', (err) -> console.log "ERROR: #{err}"

#app.get '/', google.ensureLogin, (req, res) ->
app.get '/', (req, res) ->
  res.send('Hello World')
  
app.listen process.env.NODE_PORT ? 80
console.log "Express server listening on port #{app.address().port} in #{app.settings.env} mode"

