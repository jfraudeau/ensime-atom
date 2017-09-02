/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const goToTypeAtPoint = function(client, textBuffer, bufferPosition) {
  const offset = textBuffer.characterIndexForPosition(bufferPosition);

  return client.getSymbolAtPoint(textBuffer.getPath(), offset).then(function(msg) {
    const pos = msg.declPos;
    return goToPosition(pos);
  }).catch(err => atom.notifications.addError("No declPos in response from Ensime server, cannot go anywhere :("));
};

var goToPosition = function(pos) {
  if(pos.typehint === "LineSourcePosition") {
    return atom.workspace.open(pos.file, {pending: true}).then(editor => editor.setCursorBufferPosition([parseInt(pos.line), 0]));
  } else {
    return atom.workspace.open(pos.file, {pending: true}).then(function(editor) {
      const targetEditorPos = editor.getBuffer().positionForCharacterIndex(parseInt(pos.offset));
      return editor.setCursorBufferPosition(targetEditorPos);
    });
  }
};


module.exports = {
  goToTypeAtPoint,
  goToPosition
};
