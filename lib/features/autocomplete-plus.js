'use babel';
/* eslint-disable
    no-return-assign,
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const SubAtom = require('sub-atom')
const log = require('loglevel').getLogger('ensime.autocomplete-plus-provider')

module.exports = function (clientLookup) {
  const disposables = new SubAtom()
  let noOfAutocompleteSuggestions

  disposables.add(atom.config.observe('Ensime.noOfAutocompleteSuggestions', value => noOfAutocompleteSuggestions = value)
  )

  return {
    dispose () { return disposables.dispose() },
    getCompletions (textBuffer, bufferPosition, callback) {
      const {formatCompletionsSignature} = (require('../atom-formatting'))
      const file = textBuffer.getPath()
      const offset = textBuffer.characterIndexForPosition(bufferPosition)
      return __guard__(clientLookup(textBuffer), x => x.getCompletions(file, textBuffer.getText(), offset, noOfAutocompleteSuggestions).then(function (result) {
        let c
        const { completions } = result

        if (completions) {
          const translate = function (c) {
            const { typeSig } = c
            if (c.isCallable) {
              const formattedSignature = formatCompletionsSignature(typeSig.sections)
              return {
                leftLabel: c.typeSig.result,
                snippet: `${c.name}${formattedSignature}`,
                fullyQualified: c.typeSig.result
              }
            } else {
              return {
                snippet: c.name
              }
            }
          }

          const autocompletions = ((() => {
            const result1 = []
            for (c of Array.from(completions)) {
              result1.push(translate(c))
            }
            return result1
          })())
          return callback(autocompletions)
        }
      }))
    },

    onDidInsertSuggestion ({editor, suggestion, triggerPosition}) {
      return log.trace(['inserted suggestion', suggestion])
    }
  }
}

function __guard__ (value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined
}
