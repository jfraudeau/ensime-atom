# TODO: move to API
module.exports = class ImportSuggestions
  constructor: ->

  getImportSuggestions: (client, buffer, pos, symbol) ->
    file = buffer.getPath()

    req =
      typehint: 'ImportSuggestionsReq'
      file: file
      point: pos
      names: [symbol]
      maxResults: 10

    client.post(req)
