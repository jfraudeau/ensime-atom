package org.ensime.atom

import scala.scalajs.js
import scala.scalajs.js.annotation._

@js.native
@JSImport("./go-to", JSImport.Namespace)
object Goto extends js.Object{
  def goToPosition(): Unit = js.native
}
