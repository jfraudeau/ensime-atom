path = require 'path'
log = require('loglevel').getLogger('ensime.server-update')
{packageDir} = require './utils'
EnsimeServerUpdateLogView = require './views/ensime-server-update-log-view'

getPidLogger = ->
  serverUpdateLog = new EnsimeServerUpdateLogView()
  pane = atom.workspace.getActivePane()
  pane.addItem serverUpdateLog
  pane.activateItem serverUpdateLog
  (pid) ->
    pid.stdout.on 'data', (chunk) -> serverUpdateLog.addRow(chunk.toString('utf8'))
    pid.stderr.on 'data', (chunk) -> serverUpdateLog.addRow(chunk.toString('utf8'))

failure = (msg, code) ->
  log.error(msg, code)
  atom.notifications.addError(msg, {
    dismissable: true
    detail: "Exit code: #{code}"
  })
  
tempdir = path.join(packageDir(), "ensime_update_coursier")

# updateServer(tempdir: string, getPidLogger: () => (string) => void, failure: (string, int) => void)
#doUpdateServer(parsedDotEnsime: DotEnsime, ensimeServerVersion: string, classpathFile: string, whenUpdated: () => void): void

module.exports = (require 'ensime-client').ensimeServerUpdate(tempdir, failure)
