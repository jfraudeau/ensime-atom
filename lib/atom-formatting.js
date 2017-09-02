client = require 'ensime-client'

# Atom specific formatting
{formatType, formatTypeWith, fixQualifiedTypeName, fixShortTypeName, typeConstructorFromName} = client.formatting

formatTypeNameAsHtmlWithLink = (theType) ->
  qualifiedTypeConstructor = encodeURIComponent(typeConstructorFromName(fixQualifiedTypeName(theType)))
  shortName = fixShortTypeName(theType)
  """<a data-qualified-name="#{qualifiedTypeConstructor}" title="#{qualifiedTypeConstructor}">#{shortName}</a>"""


# Format for autocomplete-plus
formatCompletionsSignature = (paramLists) ->
  formatParamLists = (paramLists) ->
    i = 0
    formatParamList = (paramList) ->
      formatParam = (param) ->
        i = i+1
        "${#{i}:#{param[0]}: #{param[1]}}"
      p = (formatParam(param) for param in paramList)
      "(" + p.join(", ") + ")"

    formattedParamLists = (formatParamList paramList for paramList in paramLists)
    formattedParamLists.join("")
  if(paramLists)
    formatParamLists(paramLists)
  else
    ""
    
formatTypeAsHtml = formatTypeWith formatTypeNameAsHtmlWithLink
  
module.exports = {
  formatTypeAsString: formatType,
  formatTypeAsHtml,
  formatCompletionsSignature,
  typeConstructorFromName
}
