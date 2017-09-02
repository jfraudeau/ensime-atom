/* eslint-disable
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const TypeHoverElement = require('../../lib/views/type-hover-element')

describe('when we add a tooltip view', function () {
  let [typeHoverElement] = Array.from([])

  beforeEach(function () {
    typeHoverElement = new TypeHoverElement()
    return jasmine.attachToDOM(typeHoverElement)
  })

  return it('should be in DOM', () => typeHoverElement.initialize('foo'))
})
