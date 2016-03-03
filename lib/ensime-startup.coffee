# Download and startup of ensime server
fs = require 'fs'
path = require 'path'
_ = require 'lodash'

ensimeClient = require ('ensime-client')

{packageDir, withSbt, mkClasspathFileName, mkAssemblyJarFileName} = require('./utils')
{parseDotEnsime} = ensimeClient.dotEnsimeUtils
{startServerFromFile, startServerFromAssemblyJar} = ensimeClient
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



# Check that we have a classpath that is newer than atom
# ensime package.json (updated on release), otherwise delete it
classpathFileOk = (cpF) ->
  if not fs.existsSync(cpF)
    false
  else
    cpFStats = fs.statSync(cpF)
    fine = cpFStats.isFile && cpFStats.ctime > fs.statSync(path.join(packageDir(), 'package.json')).mtime
    if not fine
      fs.unlinkSync(cpF)
    fine


# Start ensime server. If classpath file is out of date, make an update first
startEnsimeServer = (parsedDotEnsime, pidCallback) ->
  if not fs.existsSync(parsedDotEnsime.cacheDir)
    fs.mkdirSync(parsedDotEnsime.cacheDir)

  ensimeServerVersion = atom.config.get('Ensime.ensimeServerVersion')

  ensimeServerFlags = atom.config.get('Ensime.ensimeServerFlags')
  assemblyJar = mkAssemblyJarFileName(parsedDotEnsime.scalaEdition, ensimeServerVersion)
  
  if(fs.existsSync(assemblyJar))
    startServerFromAssemblyJar(assemblyJar, parsedDotEnsime, ensimeServerFlags, pidCallback)
  else
    cpF = mkClasspathFileName(parsedDotEnsime.scalaVersion, ensimeServerVersion)
    startFromCPFile = -> startServerFromFile(cpF, parsedDotEnsime, ensimeServerFlags, pidCallback)
    if(not classpathFileOk(cpF))
      updateEnsimeServerWithCoursier(parsedDotEnsime, ensimeServerVersion, cpF, startFromCPFile)
    else
      startFromCPFile()



module.exports = {
  startClient: (require 'ensime-client').ensimeClientStartup(startEnsimeServer)
}
