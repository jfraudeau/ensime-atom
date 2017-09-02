'use babel';
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
let LogView
const {ScrollView} = require('atom-space-pen-views')
const $ = require('jquery')

module.exports =
(LogView = class LogView extends ScrollView {
  static content (params) {
    return this.div({class: 'ensime-log-view scroll-view native-key-bindings', tabIndex: -1}, () => {
      // @h1 class: 'panel-heading', params.title
      return this.ul({class: 'list-group padded', outlet: 'list'})
    })
  }
  initialize (params) {
    return this.title = params.title
  }

  addRow (row) {
    return this.list.append(`<li>${row}</li>`)
  }
  getTitle () {
    return this.title
  }

  getURI () {
    return this.constructor.URI
  }
})
