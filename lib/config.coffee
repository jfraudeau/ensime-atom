module.exports =
  ensimeServerVersion:
    description: 'Version of Ensime server'
    type: 'string'
    default: "1.0.0"
    order: 10
  sbtExec:
    description: "Full path to sbt. 'which sbt'"
    type: 'string'
    default: ''
    order: 20
  ensimeServerFlags:
    description: 'java flags for ensime server startup'
    type: 'string'
    default: ''
    order: 40
  logLevel:
    description: 'Console log level. Turn up for troubleshooting'
    type: 'string'
    default: 'trace'
    enum: ['trace', 'debug', 'info', 'warn', 'error']
    order: 50
  runServersDetached:
    description: "Run the Ensime servers as a detached processes. Useful while developing"
    type: 'boolean'
    default: false
    order: 60
  typecheckWhen:
    description: "When to typecheck"
    type: 'string'
    default: 'typing'
    enum: ['command', 'save', 'typing']
    order: 70
  enableTypeTooltip:
    description: "Enable tooltip that shows type when hovering"
    type: 'boolean'
    default: true
    order: 80
  richTypeTooltip:
    description: "Use rich type tooltip with hrefs"
    type: 'boolean'
    default: true
    order: 90
  markImplicitsAutomatically:
    description: "Mark implicits on buffer load and save"
    type: 'boolean'
    default: true
    order: 100
  noOfAutocompleteSuggestions:
    description: "Number of autocomplete suggestions requested of server"
    type: 'integer'
    default: 10
    order: 110
  documentationSplit:
    description: "Where to open ScalaDoc"
    type: 'string'
    default: 'right'
    enum: ['right', 'external-browser']
    order: 120
  enableAutoInstallOfDependencies:
    description: "Enable auto install of dependencies"
    type: 'boolean'
    default: true
    order: 130
  
