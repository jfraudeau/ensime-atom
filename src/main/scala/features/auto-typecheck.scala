package org.ensime.atom.features

import scala.scalajs.js
import scala.scalajs.js.annotation._

import org.ensime.atom.external.{
  AtomEnvironment,
  Disposable,
  Ensime,
  LogLevel,
  SubAtom,
  TextBuffer,
  TextEditor
}

@JSExportAll
@JSExportTopLevel("AutoTypecheck")
class AutoTypecheck(editor: TextEditor,  clientLookup: js.Function0[Ensime]) {
  val disposables = new SubAtom();

  val buffer = editor.getBuffer;

  var typecheckWhileTypingDisposable: Disposable = null
  disposables.add(buffer.onDidSave(() => {
    // typecheck file on save
    if (Seq("save", "typing").contains(AtomEnvironment.config.get("Ensime.typecheckWhen")))
    if (clientLookup() != null) {
      clientLookup().typecheckFile(editor.getPath);
    }}));

   // Typecheck buffer while typing
  disposables.add(AtomEnvironment.config.observe[String]("Ensime.typecheckWhen", (value) => {
    if(value == "typing"){
      typecheckWhileTypingDisposable = editor.onDidStopChanging(() => {
        val b = editor.getBuffer;
        val p = b.getPath;
        // Don't typecheck deps
        if(!(p.contains("dep-src")) && clientLookup() != null){
          clientLookup().typecheckBuffer(p, b.getText);
        }
        disposables.add(typecheckWhileTypingDisposable);
      });
    } else {
        disposables.remove(typecheckWhileTypingDisposable);
        if (typecheckWhileTypingDisposable != null) {
          typecheckWhileTypingDisposable.dispose();
        }}
  }));

  def deactivate(): Unit = {
    disposables.dispose();
  }
};
