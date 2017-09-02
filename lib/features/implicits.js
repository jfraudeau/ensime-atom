'use babel';
/* eslint-disable
    no-return-assign,
    no-undef,
    no-unused-vars,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const ImplicitInfo = require('../model/implicit-info')
const SubAtom = require('sub-atom')

class Implicits {
  constructor (editor, instanceLookup) {
    this.editor = editor
    this.instanceLookup = instanceLookup
    this.infos = new WeakMap()
    this.disposables = new SubAtom()
    this.markerLayer = this.editor.addMarkerLayer()
    this.disposables.add(atom.config.observe('Ensime.markImplicitsAutomatically', setting => this.handleSetting(setting)))
  }

  handleSetting (markImplicitsAutomatically) {
    if (markImplicitsAutomatically) {
      this.showImplicits()
      this.saveListener = this.editor.onDidSave(() => this.showImplicits())
      return this.disposables.add(this.saveListener)
    } else {
      if (this.saveListener != null) {
        this.saveListener.dispose()
      }
      return this.disposables.remove(this.saveListener)
    }
  }

  showImplicits () {
    const b = this.editor.getBuffer()

    const instance = this.instanceLookup()

    const continuation = () => {
      let range = b.getRange()
      const startO = b.characterIndexForPosition(range.start)
      const endO = b.characterIndexForPosition(range.end)

      this.clearMarkers()
      return instance.api.getImplicitInfo(b.getPath(), startO, endO).then(result => {
        let markers
        let info
        const createMarker = info => {
          range = [b.positionForCharacterIndex(parseInt(info.start)), b.positionForCharacterIndex(parseInt(info.end))]
          const spot = [range[0], range[0]]

          const markerRange = this.markerLayer.markBufferRange(range)
          this.infos.set(markerRange, info)

          const markerSpot = this.markerLayer.markBufferRange(spot)

          this.infos.set(markerRange, info)

          this.editor.decorateMarker(markerRange, {
            type: 'highlight',
            class: 'syntax--implicit'
          }
          )
          return this.editor.decorateMarker(markerSpot, {
            type: 'line-number',
            class: 'syntax--implicit'
          }
          )
        }

        return markers = ((() => {
          const result1 = []
          for (info of Array.from(result.infos)) {
            result1.push(createMarker(info))
          }
          return result1
        })())
      })
    }

    // If source path is under sourceRoots and modified, typecheck it first
    if (instance) {
      if (instance.isSourceOf(this.editor.getPath()) && this.editor.isModified()) {
        return instance.api.typecheckBuffer(b.getPath(), b.getText()).then(typecheckResult => continuation())
      } else {
        return continuation()
      }
    }
  }

  showImplicitsAtCursor () {
    let implicitInfo
    const pos = this.editor.getCursorBufferPosition()
    const markers = this.findMarkers({containsBufferPosition: pos})
    const infos = markers.map(marker => this.infos.get(marker))
    return implicitInfo = new ImplicitInfo(infos, this.editor, pos)
  }

  clearMarkers () {
    for (let marker of Array.from(this.findMarkers())) { marker.destroy() }
    return (this.overlayMarker != null ? this.overlayMarker.destroy() : undefined)
  }

  findMarkers (attributes) {
    return this.markerLayer.findMarkers(attributes)
  }

  deactivate () {
    this.disposables.dispose()
    this.clearMarkers()
    return this.markerLayer.destroy()
  }
}

module.exports = Implicits
