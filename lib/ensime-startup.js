/* eslint-disable
    no-undef,
    no-unused-vars,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// Download and startup of ensime server
const fs = require('fs')
const path = require('path')
const _ = require('lodash')

const Promise = require('bluebird')
const ensimeClient = require(('ensime-client'))

const {packageDir, withSbt, mkClasspathFileName} = require('./utils')
const {parseDotEnsime} = ensimeClient.dotEnsimeUtils
const {startServerFromDotEnsimeCP, startServerFromAssemblyJar, clientStarterFromServerStarter} = ensimeClient

// Start ensime server. If classpath file is out of date, make an update first
// (project: DotEnsime): Promise<ChildProcess>
const startEnsimeServer = function (parsedDotEnsime) {
  if (!fs.existsSync(parsedDotEnsime.cacheDir)) {
    fs.mkdirSync(parsedDotEnsime.cacheDir)
  }

  const ensimeServerFlags = atom.config.get('Ensime.ensimeServerFlags')

  atom.notifications.addInfo('Starting Ensime server…')

  const assemblyJar = atom.config.get('Ensime.assemblyJar')
  if (assemblyJar && fs.existsSync(assemblyJar)) {
    return Promise.resolve(startServerFromAssemblyJar(assemblyJar, parsedDotEnsime, ensimeServerVersion, ensimeServerFlags))
  } else {
    return startServerFromDotEnsimeCP(parsedDotEnsime, ensimeServerFlags)
  }
}

module.exports =
  {startClient: clientStarterFromServerStarter(startEnsimeServer)}
