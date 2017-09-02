// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let EnsimeServerUpdateLogView
const LogView = require('./log-view')

module.exports =
(EnsimeServerUpdateLogView = (function () {
  EnsimeServerUpdateLogView = class EnsimeServerUpdateLogView extends LogView {
    static initClass () {
      this.URI = 'atom://ensime/server-update-log'
    }

    constructor () {
      super({title: 'Ensime server update:'})
    }
  }
  EnsimeServerUpdateLogView.initClass()
  return EnsimeServerUpdateLogView
})())
