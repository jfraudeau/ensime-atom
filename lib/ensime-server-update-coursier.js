/* eslint-disable
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const path = require('path')
const log = require('loglevel').getLogger('ensime.server-update')
const {packageDir, proxySettings} = require('./utils')
const EnsimeServerUpdateLogView = require('./views/ensime-server-update-log-view')

const getPidLogger = function () {
  const serverUpdateLog = new EnsimeServerUpdateLogView()
  const pane = atom.workspace.getActivePane()
  pane.addItem(serverUpdateLog)
  pane.activateItem(serverUpdateLog)
  return s => serverUpdateLog.addRow(s)
}

const failure = function (msg, code) {
  log.error(msg, code)
  return atom.notifications.addError(msg, {
    dismissable: true,
    detail: `Exit code: ${code}`
  })
}

const tempdir = path.join(packageDir(), 'ensime_update_coursier')

// updateServer(tempdir: string, getPidLogger: () => (string) => void, failure: (string, int) => void)

module.exports = (require('ensime-client')).ensimeServerUpdate(tempdir, failure, getPidLogger, proxySettings())
