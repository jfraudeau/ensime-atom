SymbolSearchVue = require('../views/public-symbol-search-vue')
{addModalPanel} = require('../utils')
{goToPosition} = require './go-to'

maxSymbols = 5


module.exports = ->
  vue = new SymbolSearchVue
  modalPanel = addModalPanel(vue, false)

  api = undefined
  
  toggle = (newApi) ->
    if modalPanel.isVisible()
      modalPanel.hide()
    else
      api = newApi
      modalPanel.show()
      vue.focusSearchField()

  cancel = ->
    modalPanel.hide()
  
  vue.onSearchTextUpdated (newText, oldText) ->
    api?.searchPublicSymbols(newText.split(' '), maxSymbols).then (msg) ->
      vue.results = msg.syms
      vue.selected = 0
    

  atom.commands.add vue.$el,
    'core:move-up': (event) ->
      if(vue.selected > 0)
        vue.selected -= 1
      event.stopPropagation()

    'core:move-down': (event) ->
      if(vue.selected < maxSymbols - 1)
        vue.selected += 1
      event.stopPropagation()

    'core:confirm': (event) ->
      selected = vue.getSelected()
      if(selected)
        if(selected.pos)
          goToPosition(selected.pos)
        else
          atom.notifications.addError("Got no position from Ensime server :(", {
            dismissable: true
            detail: "There was no .pos property of the the symbol from Ensime server. Maybe no source attached? Check .ensime!"
            })
        toggle()
        event.stopPropagation()
      else
        # Do nothing


    'core:cancel': (event) ->
      cancel()
      event.stopPropagation()

  {
    toggle: toggle
    cancel: cancel
  }
