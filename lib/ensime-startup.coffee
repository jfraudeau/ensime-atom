# Download and startup of ensime server
fs = require 'fs'
path = require 'path'
_ = require 'lodash'

ensimeClient = require ('ensime-client')

{packageDir, withSbt, mkClasspathFileName} = require('./utils')
{parseDotEnsime} = ensimeClient.dotEnsimeUtils
doStartEnsimeServer = ensimeClient.ensimeServerStartup
{updateEnsimeServer} = ensimeClient.ensimeServerUpdate

updateEnsimeServerWithCoursier = require './ensime-server-update-coursier'
log = require('loglevel').getLogger('ensime.startup')
###
## Pseudo:
This code is pretty complex with lots of continuation passing.
Here is some kind of pseudo for easier understanding:

startClient(dotEnsime) ->
  if(serverRunning(dotEnsime))
    doStartClient(dotEnsime)
  else
    startServer(dotEnsime, () ->
      doStartClient(dotEnsime)
    )

startServer(dotEnsime, whenStarted) ->
  if(classpathOk(dotEnsime))
    doStartServer(dotEnsime, whenStarted)
  else
    updateServer(dotEnsime, () ->
      doStartServer(dotEnsime, whenStarted)
    )

###

# ensime server version from settings
ensimeServerVersion = ->
  atom.config.get('Ensime.ensimeServerVersion')



# Check that we have a classpath that is newer than atom
# ensime package.json (updated on release), otherwise delete it
classpathFileOk = (cpF) ->
  if not fs.existsSync(cpF)
    false
  else
    cpFStats = fs.statSync(cpF)
    fine = cpFStats.isFile && cpFStats.ctime > fs.statSync(packageDir() + path.sep + 'package.json').mtime
    if not fine
      fs.unlinkSync(cpF)
    fine


# Start ensime server. If classpath file is out of date, make an update first
startEnsimeServer = (parsedDotEnsime, pidCallback) ->
  if not fs.existsSync(parsedDotEnsime.cacheDir)
    fs.mkdirSync(parsedDotEnsime.cacheDir)

  ensimeServerFlags = atom.config.get('Ensime.ensimeServerFlags')
  
  # update server and start
  # Pull out so coursier can have different classpath file name
  cpF = mkClasspathFileName(parsedDotEnsime.scalaVersion, ensimeServerVersion())
  log.trace("classpathfile name: #{cpF}")
  if(not classpathFileOk(cpF))
    updateEnsimeServerWithCoursier(parsedDotEnsime, ensimeServerVersion(), cpF,
      () -> doStartEnsimeServer(cpF, parsedDotEnsime, pidCallback, ensimeServerFlags))
  else
    doStartEnsimeServer(cpF, parsedDotEnsime, pidCallback, ensimeServerFlags)



module.exports = {
  startClient: (require 'ensime-client').ensimeClientStartup(startEnsimeServer)
}
