goToTypeAtPoint = (client, textBuffer, bufferPosition) ->
  offset = textBuffer.characterIndexForPosition(bufferPosition)

  client.getSymbolAtPoint(textBuffer.getPath(), offset).then((msg) ->
    pos = msg.declPos
    goToPosition(pos)
  ).catch((err) ->
    atom.notifications.addError("No declPos in response from Ensime server, cannot go anywhere :(")
  )

goToPosition = (pos) ->
  if(pos.typehint == "LineSourcePosition")
    atom.workspace.open(pos.file, {pending: true}).then (editor) ->
      editor.setCursorBufferPosition([parseInt(pos.line), 0])
  else
    atom.workspace.open(pos.file, {pending: true}).then (editor) ->
      targetEditorPos = editor.getBuffer().positionForCharacterIndex(parseInt(pos.offset))
      editor.setCursorBufferPosition(targetEditorPos)


module.exports = {
  goToTypeAtPoint
  goToPosition
}
