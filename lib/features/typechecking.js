{MessagePanelView, LineMessageView} = require 'atom-message-panel'
_ = require 'lodash'
{isScalaSource} = require '../utils'
log = require('loglevel').getLogger('ensime.typechecking')

module.exports = (indieLinter) ->
  lints = []
  timeout = undefined

  # API
  noteToLint = (note) ->
    severity: switch note.severity.typehint
      when "NoteError" then "error"
      when "NoteWarn" then "warning"
      else ""
    location: 
      file: note.file
      # TODO: This is only true if error doesn't span two lines. Since we don't have buffer here it might be
      # good enough? Or not?
      position: [[note.line - 1, note.col - 1], [note.line - 1, note.col - 1 + (note.end - note.beg)]]      
    excerpt: note.msg
        
  addLints = (notes) ->
    for note in notes
      if(not note.file.includes('dep-src'))
        lints.push(noteToLint(note))
    
  {
    addScalaNotes: (msg) ->
      notes = msg.notes
      addLints(notes)
      log.trace(['lints: ', lints])
      
      doit = ->
        indieLinter.setAllMessages(lints)
        
      if timeout
        clearTimeout(timeout)
      timeout = setTimeout(doit, 100)
      
    clearScalaNotes: ->
      lints = []
      indieLinter.clearMessages()
        
    destroy: ->
      indieLinter.dispose()
  }
