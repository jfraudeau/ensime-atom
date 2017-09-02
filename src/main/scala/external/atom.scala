package org.ensime.atom.external

import scala.scalajs.js
import scala.scalajs.js.annotation._
import org.scalajs.dom.Element
import org.scalajs.dom.Event

@js.native
@JSGlobal("atom")
object AtomEnvironment extends js.Object {
  val commands: CommandRegistry = js.native
  val config: Config = js.native
  val views: ViewRegistry = js.native
}

@js.native
trait Config extends js.Object{
  def get(key: String): String = js.native
  def observe[T](key: String, callback: js.Function1[T, Unit]): Disposable = js.native
}

@js.native
trait TextEditor extends js.Object {
  def getBuffer(): TextBuffer = js.native
  def getPath(): String = js.native

  def decorateMarker(marker: DisplayMarker, decorationParams: js.Dynamic): Decoration = js.native
  def markBufferPosition(position: Point): DisplayMarker = js.native
  def onDidStopChanging(callback: js.Function0[_]): Disposable = js.native
  def onDidDestroy(callback: js.Function0[_]): Disposable = js.native
}

@js.native
trait Decoration extends js.Object {

}

@js.native
trait DisplayMarker extends js.Object {
  def destroy(): Unit = js.native
}

@js.native
trait TextBuffer extends js.Object {
  def characterIndexForPosition(position: Point): Int = js.native
  def onDidSave(callback: js.Function0[_]): Disposable = js.native
  def getPath(): String = js.native
  def getText(): String = js.native
}

@js.native
trait ViewRegistry extends js.Object {
  def getView(obj: js.Object): Element = js.native
}

@js.native
trait CommandRegistry extends js.Object {
  def add(target: String, commandName: String, callback: js.Function1[Event, Unit]): Disposable = js.native
}

@js.native
trait Disposable extends js.Object {
  def dispose(): Unit = js.native
}

@js.native
trait Point extends js.Object {

}
