/* eslint-disable
    no-return-assign,
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const SymbolSearchVue = require('../views/public-symbol-search-vue')
const {addModalPanel} = require('../utils')
const {goToPosition} = require('./go-to')
const SubAtom = require('sub-atom')

module.exports = function () {
  const vue = new SymbolSearchVue()
  const modalPanel = addModalPanel(vue, false)
  const disposables = new SubAtom()
  let maxSymbols

  disposables.add(atom.config.observe('Ensime.maxSymbolsInSearch', value => maxSymbols = value)
  )

  let api

  const toggle = function (newApi) {
    if (modalPanel.isVisible()) {
      return modalPanel.hide()
    } else {
      api = newApi
      modalPanel.show()
      return vue.focusSearchField()
    }
  }

  const cancel = () => modalPanel.hide()

  vue.onSearchTextUpdated((newText, oldText) =>
    api != null ? api.searchPublicSymbols(newText.split(' '), maxSymbols).then(function (msg) {
      vue.results = msg.syms
      return vue.selected = 0
    }) : undefined
  )

  atom.commands.add(vue.$el, {
    'core:move-up' (event) {
      if (vue.selected > 0) {
        vue.selected -= 1
      }
      return event.stopPropagation()
    },

    'core:move-down' (event) {
      if (vue.selected < (maxSymbols - 1)) {
        vue.selected += 1
      }
      return event.stopPropagation()
    },

    'core:confirm' (event) {
      const selected = vue.getSelected()
      if (selected) {
        if (selected.pos) {
          goToPosition(selected.pos)
        } else {
          atom.notifications.addError('Got no position from Ensime server :(', {
            dismissable: true,
            detail: 'There was no .pos property of the the symbol from Ensime server. Maybe no source attached? Check .ensime!'
          })
        }
        toggle()
        return event.stopPropagation()
      } else {}
    },
    // Do nothing

    'core:cancel' (event) {
      cancel()
      return event.stopPropagation()
    }
  }
  )

  return {
    toggle,
    cancel,
    dispose () { return disposable.dispose() }
  }
}
