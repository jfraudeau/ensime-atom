'use babel';

const getSymbolDesignations = function (client, editor) {
  const b = editor.getBuffer()
  const range = b.getRange()
  const startO = b.characterIndexForPosition(range.start)
  const endO = b.characterIndexForPosition(range.end)

  const msg = {
    'typehint': 'SymbolDesignationsReq',
    'requestedTypes': symbolTypehints,
    'file': b.getPath(),
    'start': startO,
    'end': endO
  }

  return client.post(msg).then(result(function () {
    let sym
    const { syms } = result

    const markers = function (sym) {
      const startPos = b.positionForCharacterIndex(parseInt(sym[1]))
      const endPos = b.positionForCharacterIndex(parseInt(sym[2]))
      const marker = editor.markBufferRange([startPos, endPos], {
        invalidate: 'inside',
        class: `scala ${sym[0]}`
      }
      )
      const decoration = editor.decorateMarker(marker, {
        type: 'highlight',
        class: sym[0]
      }
      )
      return marker
    }

    const makeCodeLink = marker => ({range: marker.getBufferRange()})

    const makers = ((() => {
      const result = []
      for (sym of Array.from(syms)) {
        result.push(markers(sym))
      }
      return result
    })())
    const codeLinks = (Array.from(makers).map((maker) => makeCodeLink(marker)))

    return codeLinks
  })
  )
}

const symbols = [
  'ObjectSymbol',
  'ClassSymbol',
  'TraitSymbol',
  'PackageSymbol',
  'ConstructorSymbol',
  'ImportedNameSymbol',
  'TypeParamSymbol',
  'ParamSymbol',
  'VarFieldSymbol',
  'ValFieldSymbol',
  'OperatorFieldSymbol',
  'VarSymbol',
  'ValSymbol',
  'FunctionCallSymbol']

var symbolTypehints = _.map(symbols, symbol => ({'typehint': `${symbol}`}))
