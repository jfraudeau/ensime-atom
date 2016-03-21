root = '../..'
Promise = require('bluebird')
temp = require 'temp'
JsDiff = require 'diff'
log = require 'loglevel'

refactorings = new (require "#{root}/lib/features/refactorings")

describe 'applyParsedPatchesInEditors', ->
  fileName = undefined
  diff = undefined
  
  beforeEach ->
    fileName = temp.path({suffix: '.scala'})
    temp.track()
    
    diff = """
            --- #{fileName}	2016-03-21 02:50:51 +0100
            +++ #{fileName}	2016-03-21 02:50:51 +0100
            @@ -1,2 +1,3 @@
             import scala.collection.immutable.HashMap
            +import scala.concurrent.ExecutionContext.Implicits.global
             import scala.concurrent.Future
            @@ -4,4 +5,2 @@
             
            -import scala.concurrent.ExecutionContext.Implicits.global
            -
             object foo {
          """
        
  it 'should not fail https://github.com/ensime/ensime-atom/issues/214', ->
    
    fileContents = """
                    import scala.collection.immutable.HashMap
                    import scala.concurrent.Future
                    import scala.util.Try

                    import scala.concurrent.ExecutionContext.Implicits.global

                    object foo {
                    val x = new HashMap()
                    val y = Try(1)
                    val f = Future.successful(2)
                    }
                  """

    expectedResult = """
                      import scala.collection.immutable.HashMap
                      import scala.concurrent.ExecutionContext.Implicits.global
                      import scala.concurrent.Future
                      import scala.util.Try
                       
                      object foo {
                      val x = new HashMap()
                      val y = Try(1)
                      val f = Future.successful(2)
                      }
                     """

    waitsForPromise ->
      atom.workspace.open(fileName).then (editor) ->
        editor.setText(fileContents)
        log.trace ['set text to', fileContents, ' on ', fileName]
    
    waitsForPromise ->
      refactorings.applyPatchesInEditors(diff)
      
              
    waitsForPromise ->
      atom.workspace.open(fileName).then (editor) ->
        result = editor.getText()
        log.trace [expectedResult, result]
        expect(result).toEqual(expectedResult)
  
  


  
  afterEach ->
    temp.cleanupSync()
