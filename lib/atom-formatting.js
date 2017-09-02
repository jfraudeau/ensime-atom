/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const client = require('ensime-client');

// Atom specific formatting
const {formatType, formatTypeWith, fixQualifiedTypeName, fixShortTypeName, typeConstructorFromName} = client.formatting;

const formatTypeNameAsHtmlWithLink = function(theType) {
  const qualifiedTypeConstructor = encodeURIComponent(typeConstructorFromName(fixQualifiedTypeName(theType)));
  const shortName = fixShortTypeName(theType);
  return `<a data-qualified-name="${qualifiedTypeConstructor}" title="${qualifiedTypeConstructor}">${shortName}</a>`;
};


// Format for autocomplete-plus
const formatCompletionsSignature = function(paramLists) {
  const formatParamLists = function(paramLists) {
    let paramList;
    let i = 0;
    const formatParamList = function(paramList) {
      let param;
      const formatParam = function(param) {
        i = i+1;
        return `\${${i}:${param[0]}: ${param[1]}}`;
      };
      const p = ((() => {
        const result = [];
        for (param of Array.from(paramList)) {           result.push(formatParam(param));
        }
        return result;
      })());
      return `(${p.join(", ")})`;
    };

    const formattedParamLists = ((() => {
      const result = [];
      for (paramList of Array.from(paramLists)) {         result.push(formatParamList(paramList));
      }
      return result;
    })());
    return formattedParamLists.join("");
  };
  if(paramLists) {
    return formatParamLists(paramLists);
  } else {
    return "";
  }
};
    
const formatTypeAsHtml = formatTypeWith(formatTypeNameAsHtmlWithLink);
  
module.exports = {
  formatTypeAsString: formatType,
  formatTypeAsHtml,
  formatCompletionsSignature,
  typeConstructorFromName
};
