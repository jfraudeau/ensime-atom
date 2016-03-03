fs = require 'fs'
path = require 'path'
temp = require 'temp'
loglevel = require 'loglevel'
loglevel.setDefaultLevel('trace')
loglevel.setLevel('trace')

describe "ensime-server-update", ->
  beforeEach ->


  it "should be able to download coursier", ->
    # Java is installed installed on appveyor build servers C:\Program Files\Java\jdk1.8.0
    # http://www.appveyor.com/docs/installed-software#java
    tempDir = temp.mkdirSync('ensime-integration-test')
    
    dotEnsime =
      name: "test"
      scalaVersion: "2.11.7"
      scalaEdition: "2.11"
      rootDir: tempDir
      cacheDir: tempDir + path.sep + ".ensime_cache"
      dotEnsimePath: tempDir + path.sep + ".ensime"

    spy = jasmine.createSpy('classpathfile-callback')
    
    updateEnsimeServer = require '../lib/ensime-server-update-coursier'
    updateEnsimeServer(dotEnsime, "0.9.10-SNAPSHOT", tempDir + path.sep + "classpathfile", spy)
    
    waitsFor( (-> spy.callCount > 0), "callback wasn't called in time", 60000)
    runs ->
#      expect(spy.mostRecentCall.args).toEqual exp
#      expect(spy).toHaveBeenCalledWith(null, ['example.coffee'])

  afterEach ->
