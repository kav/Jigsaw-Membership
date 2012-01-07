url = require('url')
module.exports = (app) ->
  ensureLogin: (req, res, next) ->
    
    return res.end() unless req.session?
    if req.session.fbid?
      return next()
    
    req.authenticate ['google'], (error, authenticated) ->
      console.log 'back from google'
      unless authenticated then return res.end()
      console.log req
      console.log req.getAuthDetails()
      
      parsedUrl = url.parse(req.url)
             
      return res.redirect(parsedUrl.pathname) if request.url isnt parsedUrl.pathname 
      return next()