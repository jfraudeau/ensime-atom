root = '..'
{formatTypeAsHtml, formatCompletionsSignature} = require "#{root}/lib/atom-formatting"

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
