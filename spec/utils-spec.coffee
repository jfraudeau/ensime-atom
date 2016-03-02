utils = require '../lib/utils'
log = require 'loglevel'


describe 'utils', ->
  log.setDefaultLevel('trace')
  it 'packageDir should not be undefined', ->
    packageDir = utils.packageDir()
    log.trace('packageDir: ', packageDir)
    expect(packageDir).toBeDefined()
