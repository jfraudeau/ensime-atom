package org.ensime.atom.features

import scala.scalajs.js
import scala.scalajs.js.annotation._

import org.ensime.atom.AtomFormatting
import org.ensime.atom.external.{
  Api,
  AtomEnvironment,
  Completion,
  LogLevel,
  Point,
  SubAtom,
  TextBuffer,
  TextEditor
}

@JSExportAll
@JSExportTopLevel("AutocompletePlusProvider")
class AutocompletePlusProvider(clientLookup: js.Function1[TextBuffer, Api]) {

  val log = LogLevel.getLogger("ensime.autocomplete-plus-provider")
  val disposables = new SubAtom()
  var noOfAutocompleteSuggestions: js.UndefOr[Int] = js.undefined;

  disposables.add(AtomEnvironment.config.observe[Int]("Ensime.noOfAutocompleteSuggestions", value => {
    noOfAutocompleteSuggestions = value
  }))

  def dispose(): Unit = disposables.dispose()

  def getCompletions(textBuffer: TextBuffer, bufferPosition: Point, callback: js.Function1[js.Array[js.Dynamic], _]): Unit = {
    val file = textBuffer.getPath()
    val offset = textBuffer.characterIndexForPosition(bufferPosition)
    clientLookup(textBuffer).getCompletions(file, textBuffer.getText(), offset, noOfAutocompleteSuggestions).andThen((result) => {
      result.completions.foreach{ completions =>
        def translate(completion: Completion): js.Dynamic = {
          completion.typeInfo.map{typeInfo =>
            this.dispose
            val formattedSignature = AtomFormatting.formatCompletionsSignature(typeInfo.typeArgs)
            js.Dynamic.literal(
              leftLabel = typeInfo.name,
              snippet = s"${completion.name}${formattedSignature}",
              fullyQualified = typeInfo.fullName,
            )
          }.getOrElse{
            js.Dynamic.literal(
              snippet = completion.name
            )
          }
        }
        this.dispose
        val autocompletions = completions.map(translate _)
        callback(autocompletions)
      }
    });
  }

  def onDidInsertSuggestion(arg: OnDidInsertSuggestionArg ): Unit =
    log.trace(js.Array("inserted suggestion", arg.suggestion))
}

@js.native
trait OnDidInsertSuggestionArg extends js.Object {
  val editor: TextEditor = js.native
  val suggestion: js.Any = js.native
  val triggerPosition: String = js.native
}
