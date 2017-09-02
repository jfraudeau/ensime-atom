'use babel';

// Download and startup of ensime server
import fs from 'fs'
import path from 'path'
import _ from 'lodash'

import Promise from 'bluebird'
import * as ensimeClient from 'ensime-client'

import {packageDir, withSbt, mkClasspathFileName} from './utils'
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

export default
  {startClient: clientStarterFromServerStarter(startEnsimeServer)}
