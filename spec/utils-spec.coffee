utils = require '../lib/utils'
log = require 'loglevel'
log.setDefaultLevel('trace')


describe 'utils', ->
  it 'packageDir should be undefined', ->
    packageDir = utils.packageDir()
    log.trace('packageDir: ' + packageDir)
    expect(packageDir).toBeDefined()
