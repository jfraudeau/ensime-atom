utils = require '../lib/utils'
log = require 'loglevel'
log.setDefaultLevel('trace')

describe 'utils', ->
  describe 'packageDir', ->
    it 'should be defined', ->
      packageDir = utils.packageDir()
      log.trace('packageDir: ' + packageDir)
      expect(packageDir).toBeDefined()
