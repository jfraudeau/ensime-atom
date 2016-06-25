root = '..'
{formatTypeAsHtml, formatTypeAsString, formatCompletionsSignature} = require "#{root}/lib/atom-formatting"

describe 'rich atom specific type hover formatter', ->
  it "should format |@| correctly", ->
    typeStr = """
        {
          "typehint": "ArrowTypeInfo",
          "name": "[B](fb: F[B])scalaz.syntax.ApplicativeBuilder[F,A,B]",
          "resultType": {
            "name": "<refinement>",
            "fullName": "scalaz.syntax.ApplyOps$<refinement>",
            "typehint": "BasicTypeInfo",
            "typeArgs": [],
            "members": [],
            "declAs": {
              "typehint": "Class"
            }
          },
          "paramSections": [
            {
              "params": [
                [
                  "fb",
                  {
                    "name": "F",
                    "fullName": "scalaz.syntax.F",
                    "typehint": "BasicTypeInfo",
                    "typeArgs": [
                      {
                        "name": "B",
                        "fullName": "scalaz.syntax.B",
                        "typehint": "BasicTypeInfo",
                        "typeArgs": [],
                        "members": [],
                        "declAs": {
                          "typehint": "Nil"
                        }
                      }
                    ],
                    "members": [],
                    "declAs": {
                      "typehint": "Nil"
                    }
                  }
                ]
              ],
              "isImplicit": false
            }
          ]
        }
    """
    type = JSON.parse(typeStr)
  

describe 'type-hover', ->

  thing = {
    "name": "LanguageFeatureImport.Thing[LanguageFeatureImport.Thing.T]",
    "localName": "Thing",
    "typehint": "SymbolInfo",
    "declPos": {
      "typehint": "OffsetSourcePosition",
      "file": "/Users/viktor/dev/projects/ensime-test-project/src/main/scala/LanguageFeatureImport.scala",
      "offset": 49
    },
    "type": {
      "name": "Thing[T]",
      "fullName": "LanguageFeatureImport.Thing[LanguageFeatureImport.Thing.T]",
      "pos": {
        "typehint": "OffsetSourcePosition",
        "file": "/Users/viktor/dev/projects/ensime-test-project/src/main/scala/LanguageFeatureImport.scala",
        "offset": 49
      },
      "typehint": "BasicTypeInfo",
      "typeArgs": [
        {
          "name": "T",
          "fullName": "LanguageFeatureImport.Thing.T",
          "typehint": "BasicTypeInfo",
          "typeArgs": [],
          "members": [],
          "declAs": {
            "typehint": "Nil"
          }
        }
      ],
      "members": [],
      "declAs": {
        "typehint": "Class"
      }
    },
    "isCallable": false
  }
  it 'should format type variables correctly in simple strings', ->
    string = formatTypeAsString(thing.type)
    expect(string).toBe("Thing[T]")
    
  it 'should format type variables correctly in rich html', ->
    html = formatTypeAsHtml(thing.type)
    expected = """<a data-qualified-name="LanguageFeatureImport.Thing%5BLanguageFeatureImport.Thing.T%5D" title="LanguageFeatureImport.Thing%5BLanguageFeatureImport.Thing.T%5D">Thing</a>[<a data-qualified-name="LanguageFeatureImport.Thing.T" title="LanguageFeatureImport.Thing.T">T</a>]"""
    expect(html).toBe(expected)
    
    
    
describe 'formatCompletionsSignature', ->
  it "should format x, y -> z", ->
    inputParams = [[["x", "Int"], ["y", "Int"]]]
    result = formatCompletionsSignature(inputParams)

    expect(result).toBe("(${1:x: Int}, ${2:y: Int})")

  it "should format foo(asdf: Int, y: Int)", ->
    inputString =
        """
        {"name":"foo","typeId":2801,"typeSig":{"sections":[[["asdf","Int"],["y","Int"]]],"result":"Int"},"relevance":90,"isCallable":true}
        """
    json = JSON.parse(inputString)
    result = formatCompletionsSignature(json.typeSig.sections)
    expect(result).toBe("(${1:asdf: Int}, ${2:y: Int})")

  it "should format curried", ->
    sections =
       [
          [
            [
              "x",
              "Int"
            ]
          ],
          [
            [
              "y",
              "Int"
            ]
          ]
        ]

    result = formatCompletionsSignature(sections)
    expect(result).toBe("(${1:x: Int})(${2:y: Int})")
