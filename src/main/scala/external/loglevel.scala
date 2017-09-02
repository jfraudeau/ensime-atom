package org.ensime.atom.external

import scala.scalajs.js
import scala.scalajs.js.annotation._

@js.native
@JSImport("loglevel", JSImport.Namespace)
object LogLevel extends js.Object{
  def getLogger(name: String): Logger = js.native
}

@js.native
trait Logger extends js.Object{
  def trace(value: js.Array[js.Any]): Unit = js.native
}
