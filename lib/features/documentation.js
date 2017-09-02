# Helper for looking up ScalaDoc.
log = require('loglevel').getLogger('documentation')

class Documentation

  constructor: (@editor) ->
    @textBuffer = @editor.getBuffer()

  # If there's selected text, what's the to/from point?
  selectedPoint: () ->
    range = @editor.getSelectedBufferRange()
    {
      from: @textBuffer.characterIndexForPosition(range.start)
      to: @textBuffer.characterIndexForPosition(range.end)
    }

  # If there's no selected text, just send the offset.
  # ENSIME appears to figure out what we want just from this!
  cursorPoint: () ->
    bufferPosition = @editor.getCursorBufferPosition()
    offset = @textBuffer.characterIndexForPosition(bufferPosition)
    {
      from: offset
      to: offset
    }

  getPoint: () ->
    hasSelectedText = @editor.getSelectedText() != ""
    if hasSelectedText then this.selectedPoint() else this.cursorPoint()

  @formUrl: (host, port, path) ->
    alreadyUrl = (path.indexOf("//") != -1)
    if alreadyUrl then path else "http://#{host}:#{port}/#{path}"

  @openDoc = (url) ->
    log.trace("openDoc")
    split = atom.config.get('Ensime.documentationSplit')
    switch split
      when 'external-browser'
        @shell = require 'shell' if (not @shell)
        @shell.openExternal(url)
      else atom.workspace.open(url, {split: split})



goToDocAtPoint = (instance, editor) ->
  if(instance)
    point = new Documentation(editor).getPoint()

    instance.api.getDocUriAtPoint(editor.getBuffer().getPath(), point).then (msg) ->
      switch msg.typehint
        when "FalseResponse" then atom.notifications.addError("No documentation found")
        else Documentation.openDoc(Documentation.formUrl("localhost", instance.httpPort, msg.text))
  

goToDocIndex = (instance) ->
  Documentation.openDoc("http://localhost:#{instance.httpPort}/docs")


module.exports = {
  goToDocAtPoint
  goToDocIndex
}
