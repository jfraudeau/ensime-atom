package org.ensime.atom

import scala.scalajs.js
import scala.scalajs.js.annotation._

@js.native
@JSImport("./atom-formatting", JSImport.Namespace)
object AtomFormatting extends js.Object{
  def formatTypeAsString(theType: js.Any): String = js.native
  def formatTypeAsHtml(theType: js.Any): String = js.native
  def typeConstructorFromName(): Unit = js.native
  def formatCompletionsSignature(signature: js.Array[js.Dynamic]): String = js.native
}
