/* eslint-disable
    no-return-assign,
    no-unused-vars,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let TextEditorVue
const Vue = require('vue')

module.exports = (TextEditorVue = Vue.extend({
  template: '<atom-text-editor class="editor mini" tabindex="-1" mini="" data-grammar="text plain null-grammar" data-encoding="utf8"></atom-text-editor>',
  methods: {
    getTextEditor () { return this.$el.getModel() }
  },
  ready () {
    // two ways-bind to the Atom texteditor stuff
    this.$el.getModel().getBuffer().onDidChange(() => {
      return this.text = this.$el.getModel().getBuffer().getText()
    })

    return this.watcher = this.$watch('text', function (text) { return this.$el.getModel().getBuffer().setText(this.text) })
  },

  props: ['text']

}))
