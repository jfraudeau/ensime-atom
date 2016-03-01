client = require 'ensime-client'


# Atom specific formatting
{formatType, formatTypeWith, fixQualifiedTypeName, fixShortTypeName} = client.formatting

formatTypeNameAsHtmlWithLink = (theType) ->
  qualifiedName = encodeURIComponent(fixQualifiedTypeName(theType))
  shortName = fixShortTypeName(theType)
  """<a data-qualified-name="#{qualifiedName}" title="#{qualifiedName}">#{shortName}</a>"""


module.exports =
  formatTypeAsString: formatType
  formatTypeAsHtml: formatTypeWith formatTypeNameAsHtmlWithLink
