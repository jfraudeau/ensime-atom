ImplicitInfo = require '../model/implicit-info'
SubAtom = require 'sub-atom'

class Implicits
  constructor: (@editor, @instanceLookup) ->
    @infos = new WeakMap
    @disposables = new SubAtom
    @markerLayer = @editor.addMarkerLayer()
    @disposables.add atom.config.observe 'Ensime.markImplicitsAutomatically', (setting) => @handleSetting(setting)
    
  handleSetting: (markImplicitsAutomatically) ->
    if(markImplicitsAutomatically)
      @showImplicits()
      @saveListener = @editor.onDidSave(() => @showImplicits())
      @disposables.add @saveListener
    else
      @saveListener?.dispose()
      @disposables.remove @saveListener


  showImplicits: ->
    b = @editor.getBuffer()

    instance = @instanceLookup()

    continuation = =>
      range = b.getRange()
      startO = b.characterIndexForPosition(range.start)
      endO = b.characterIndexForPosition(range.end)

      @clearMarkers()
      instance.api.getImplicitInfo(b.getPath(), startO, endO).then (result) =>
        createMarker = (info) =>
          range = [b.positionForCharacterIndex(parseInt(info.start)), b.positionForCharacterIndex(parseInt(info.end))]
          spot = [range[0], range[0]]

          markerRange = @markerLayer.markBufferRange(range)
          @infos.set(markerRange, info)
          
          markerSpot = @markerLayer.markBufferRange(spot)
          
          @infos.set(markerRange, info)
          
          @editor.decorateMarker(markerRange,
              type: 'highlight'
              class: 'syntax--implicit'
          )
          @editor.decorateMarker(markerSpot,
              type: 'line-number'
              class: 'syntax--implicit'
          )

        markers = (createMarker info for info in result.infos)

    # If source path is under sourceRoots and modified, typecheck it first
    if(instance)
      if(instance.isSourceOf(@editor.getPath()) and @editor.isModified())
        instance.api.typecheckBuffer(b.getPath(), b.getText()).then (typecheckResult) ->
          continuation()
      else
        continuation()

  showImplicitsAtCursor: ->
    pos = @editor.getCursorBufferPosition()
    markers = @findMarkers({containsBufferPosition: pos})
    infos = markers.map (marker) => @infos.get(marker)
    implicitInfo = new ImplicitInfo(infos, @editor, pos)

  clearMarkers: ->
    marker.destroy() for marker in @findMarkers()
    @overlayMarker?.destroy()

  findMarkers: (attributes) ->
    @markerLayer.findMarkers(attributes)

  deactivate: ->
    @disposables.dispose()
    @clearMarkers()
    @markerLayer.destroy()

module.exports = Implicits
