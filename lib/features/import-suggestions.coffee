# Super quick one that just adds the first in list
module.exports = class ImportSuggestions
  constructor: ->
    @refactorings = new (require('./refactorings'))

  useFirst: (res) ->
    # TODO: Add ui for selection
    name = res.symLists[0][0].name
    
    @refactorings.doImport(client, name, file, buffer)
    
  getImportSuggestions: (client, buffer, pos, symbol, callback = @useFirst) ->
    file = buffer.getPath()

    req =
      typehint: 'ImportSuggestionsReq'
      file: file
      point: pos
      names: [symbol]
      maxResults: 10

    client.post(req, callback)
