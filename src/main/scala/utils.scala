package org.ensime.atom

import scala.scalajs.js
import scala.scalajs.js.annotation._

import external.Point
import external.TextEditor

@js.native
@JSImport("./utils", JSImport.Namespace)
object Utils extends js.Object{
  def bufferPositionFromMouseEvent(editor: TextEditor, e: js.Any): Point = js.native
  def pixelPositionFromMouseEvent(editor: TextEditor, e: js.Any): Unit = js.native
  def getElementsByClass(): Unit = js.native
}
