path = require 'path'
log = require('loglevel').getLogger('ensime.server-update')
{packageDir,proxySettings} = require './utils'
EnsimeServerUpdateLogView = require './views/ensime-server-update-log-view'

getPidLogger = ->
  serverUpdateLog = new EnsimeServerUpdateLogView()
  pane = atom.workspace.getActivePane()
  pane.addItem serverUpdateLog
  pane.activateItem serverUpdateLog
  (s) -> serverUpdateLog.addRow s

failure = (msg, code) ->
  log.error(msg, code)
  atom.notifications.addError(msg, {
    dismissable: true
    detail: "Exit code: #{code}"
  })

tempdir = path.join(packageDir(), "ensime_update_coursier")

# updateServer(tempdir: string, getPidLogger: () => (string) => void, failure: (string, int) => void)

module.exports = (require 'ensime-client').ensimeServerUpdate(tempdir, failure, getPidLogger, proxySettings())
