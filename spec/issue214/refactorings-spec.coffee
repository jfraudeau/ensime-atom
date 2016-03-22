root = '../..'
Promise = require('bluebird')
temp = require 'temp'
JsDiff = require 'diff'
log = require 'loglevel'

refactorings = new (require "#{root}/lib/features/refactorings")

testDiffApplication = (fileName, before, diff, expected) ->
  waitsForPromise ->
    atom.workspace.open(fileName).then (editor) ->
      editor.setText(before)

  waitsForPromise ->
    refactorings.applyPatchFromFileContent(diff)
    
  waitsForPromise ->
    atom.workspace.open(fileName).then (editor) ->
      result = editor.getText()
      expect(result).toEqual(expected)
  
  "hej"

describe 'applyPatchesInEditors', ->
  
  beforeEach ->
    temp.track()
        
  it 'should not fail https://github.com/ensime/ensime-atom/issues/214', ->
    fileName = temp.path({suffix: '.scala'})
    
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

    testDiffApplication(fileName, fileContents, diff, expectedResult)
  
  
  
  it "should not fail like https://github.com/ensime/ensime-atom/pull/217#issuecomment-199369339", ->
    fileName = temp.path({suffix: '.scala'})
    
    fileContents = """
                  import scala.util.Try
                  
                  import scala.concurrent.ExecutionContext.Implicits.global
                  
                  object foo {
                  }
                  """
                  
    diff = """
          --- #{fileName}	2016-03-21 08:23:12 +0100
          +++ #{fileName}	2016-03-21 08:23:12 +0100
          @@ -1,5 +1,5 @@
          -import scala.util.Try
          -
           import scala.concurrent.ExecutionContext.Implicits.global
           
          +
          +
           object foo {
          """
    expectedResult = """
            import scala.concurrent.ExecutionContext.Implicits.global
            
            
            
            object foo {
            }
            """
            
    testDiffApplication(fileName, fileContents, diff, expectedResult)
  
  
  describe "empty diffs", ->
    beforeEach ->
      spyOn(atom.workspace, 'open').andCallThrough()
      
      fileName = temp.path({suffix: '.scala'})
      fileContents = ""
      diff = ""
      expectedResult = ""
      
      testDiffApplication(fileName, fileContents, diff, expectedResult)
    
    it "should not call open with undefined", ->
      log.trace('expecting!')
      expect(atom.workspace.open).not.toHaveBeenCalledWith(undefined)
    
  afterEach ->
    temp.cleanupSync()
