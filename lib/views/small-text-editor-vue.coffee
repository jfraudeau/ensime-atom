Vue = require('vue')

module.exports = TextEditorVue = Vue.extend({
  template: """<atom-text-editor class="editor mini" tabindex="-1" mini="" data-grammar="text plain null-grammar" data-encoding="utf8"></atom-text-editor>"""
  methods:
    getTextEditor: () -> @$el.getModel()
  ready: () ->
    # two ways-bind to the Atom texteditor stuff
    @$el.getModel().getBuffer().onDidChange =>
      @text = @$el.getModel().getBuffer().getText()
    
    @watcher = @$watch('text', (text) -> @$el.getModel().getBuffer().setText(@text))
      
  props: ['text']

})
