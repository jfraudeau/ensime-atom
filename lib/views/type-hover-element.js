/* eslint-disable
    no-class-assign,
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

const Template = `\
<div class="ensime-tooltip">
  <div class="ensime-tooltip-inner"></div>
</div>\
`

// Used for hover for type
class TypeHoverElement extends HTMLElement {
  initialize (html) {
    this.innerHTML = Template
    this.container = this.querySelector('.ensime-tooltip-inner')
    this.container.innerHTML = html
    return this
  }
}

module.exports = (TypeHoverElement = document.registerElement('ensime-type-hover-view', {prototype: TypeHoverElement.prototype}))
