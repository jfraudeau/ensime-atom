fs = require 'fs'
JsDiff = require 'diff'
log = require('loglevel').getLogger('ensime.refactorings')
Promise = -> require 'bluebird'
_ = require 'lodash'

# Refactorings should be cleaned of Atom stuff and put in client module. Add callback for what to do with patches
module.exports = class Refactorings
  constructor: ->
    @ensimeRefactorId = 1

  getRefactorPatch: (client, refactoring, interactive, callback) ->
    client.getRefactoringPatch(@ensimeRefactorId++, refactoring).then callback

  getAddImportPatch: (client, qualifiedName, file, callback) ->
    @getRefactorPatch(client,
      typehint: "AddImportRefactorDesc"
      qualifiedName: qualifiedName
      file: file
    , false, callback)

  getOrganizeImportsPatch: (client, file, callback) ->
    @getRefactorPatch(client,
      typehint: "OrganiseImportsRefactorDesc"
      file: file
    , false, callback)


  # Applies unified paths to editors using files. Not used anymore.
  applyPatch: (client, patchPath, callback = ->) ->
    fs.readFile(patchPath, 'utf8', (err, unifiedDiff) ->
      
      options =
        loadFile: (index, callback) ->
          # TODO: Should we always read the "before"-file from disk? ensime could have index of unsaved edits right?
          if(index.oldFileName)
            fs.readFile(index.oldFileName, 'utf8', callback)
          else
            callback("no edits")
            
        patched: (index, content) ->
          atom.workspace.open(index.newFileName).then (editor) ->
            editor.setText(content)

        complete: (err) ->
          if not err
            callback()
          else
            log.trace(err)
      JsDiff.applyPatches(unifiedDiff, options)

    )
    
    
  applyPatchFromFile: (patchPath) ->
    Promise().promisify(fs.readFile)(patchPath, 'utf8').then (unifiedDiff) =>
      @applyPatchFromFileContent(unifiedDiff)
    
  applyPatchFromFileContent: (unifiedDiff) ->
    if(unifiedDiff.length > 0)
      @applyPatchesInEditors(unifiedDiff)
    else
      Promise().resolve()
      
  # Very atom specific. move out
  applyPatchesInEditors: (unifiedDiff) ->
    patches = JsDiff.parsePatch(unifiedDiff)
    promises = patches.map (patch) ->
      log.trace(patch)
      if(patch.oldFileName == patch.newFileName)
        atom.workspace.open(patch.newFileName).then (editor) ->
          b = editor.getBuffer()
          actions = patch.hunks.map (hunk) ->
            zeroBasedStart = hunk.newStart - 1
            range = [[zeroBasedStart, 0], [zeroBasedStart + hunk.oldLines, 0]]
            newLines = _.filter(hunk.lines, (l) -> not l.startsWith('-'))
            log.trace ['newLines: ', newLines]
            nonEmpty = _.map(newLines, (l) -> l.substring(1, l.length))
            toInsert = _.join(_.map(nonEmpty, (l) -> l + '\n'), "")
            {range, toInsert}
            
          log.trace ['diff actions: ', actions]
          for {range, toInsert} in actions
            b.setTextInRange(range, toInsert)
      else
        Promise().reject("Sorry, no file renames yet :(")
    Promise().all(promises)
          
          
        
  maybeApplyPatch: (result) ->
    if(result.typehint == 'RefactorDiffEffect')
      @applyPatchFromFile(result.diff)
    else
      log.trace(res)


  organizeImports: (client, file, callback = -> ) ->
    @getOrganizeImportsPatch(client, file, (res) =>
      @maybeApplyPatch(res)
    )
    
    
  doImport: (client, name, file, buffer, callback = ->) ->
    @getAddImportPatch(client, name, file, (importResponse) =>
      @maybeApplyPatch(importResponse, () ->
        client.typecheckBuffer(buffer.getPath(), buffer.getText()).then callback
      )
    )
  
