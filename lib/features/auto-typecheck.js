'use babel';
/* eslint-disable
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__
 * DS104: Avoid inline assignments
 * DS204: Change includes calls to have a more natural evaluation order
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const SubAtom = require('sub-atom')

class AutoTypecheck {
  constructor (editor, clientLookup) {
    this.editor = editor
    this.clientLookup = clientLookup
    this.disposables = new SubAtom()

    const buffer = this.editor.getBuffer()
    this.disposables.add(buffer.onDidSave(() => {
      // typecheck file on save
      let needle
      if ((needle = atom.config.get('Ensime.typecheckWhen'), ['save', 'typing'].includes(needle))) {
        return __guard__(this.clientLookup(), x => x.typecheckFile(this.editor.getPath()))
      }
    })
    )

    // Typecheck buffer while typing
    this.disposables.add(atom.config.observe('Ensime.typecheckWhen', value => {
      if (value === 'typing') {
        this.typecheckWhileTypingDisposable = this.editor.onDidStopChanging(() => {
          const b = this.editor.getBuffer()
          const p = b.getPath()
          // Don't typecheck deps
          if (!p.includes('dep-src')) {
            return __guard__(this.clientLookup(), x => x.typecheckBuffer(p, b.getText()))
          }
        })
        return this.disposables.add(this.typecheckWhileTypingDisposable)
      } else {
        this.disposables.remove(this.typecheckWhileTypingDisposable)
        return (this.typecheckWhileTypingDisposable != null ? this.typecheckWhileTypingDisposable.dispose() : undefined)
      }
    })
    )
  }

  deactivate () {
    return this.disposables.dispose()
  }
}

module.exports = AutoTypecheck

function __guard__ (value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined
}
