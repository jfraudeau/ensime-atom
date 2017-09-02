/* eslint-disable
    no-return-assign,
    no-unused-vars,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const {MessagePanelView, LineMessageView} = require('atom-message-panel')
const _ = require('lodash')
const {isScalaSource} = require('../utils')
const log = require('loglevel').getLogger('ensime.typechecking')

module.exports = function (indieLinter) {
  let lints = []
  let timeout

  // API
  const noteToLint = note =>
    ({
      severity: (() => {
        switch (note.severity.typehint) {
          case 'NoteError': return 'error'
          case 'NoteWarn': return 'warning'
          default: return ''
        }
      })(),
      location: {
        file: note.file,
        // TODO: This is only true if error doesn't span two lines. Since we don't have buffer here it might be
        // good enough? Or not?
        position: [[note.line - 1, note.col - 1], [note.line - 1, (note.col - 1) + (note.end - note.beg)]]
      },
      excerpt: note.msg
    })

  const addLints = notes =>
    (() => {
      const result = []
      for (let note of Array.from(notes)) {
        if (!note.file.includes('dep-src')) {
          result.push(lints.push(noteToLint(note)))
        } else {
          result.push(undefined)
        }
      }
      return result
    })()

  return {
    addScalaNotes (msg) {
      const { notes } = msg
      addLints(notes)
      log.trace(['lints: ', lints])

      const doit = () => indieLinter.setAllMessages(lints)

      if (timeout) {
        clearTimeout(timeout)
      }
      return timeout = setTimeout(doit, 100)
    },

    clearScalaNotes () {
      lints = []
      return indieLinter.clearMessages()
    },

    destroy () {
      return indieLinter.dispose()
    }
  }
}
