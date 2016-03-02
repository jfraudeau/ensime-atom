utils = require '../lib/utils'

describe 'utils', ->
  it 'packageDir should not be undefined', ->
    expect(utils.packageDir()).toBeDefined()
