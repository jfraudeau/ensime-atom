package org.ensime.atom.external

import scala.scalajs.js
import scala.scalajs.js.annotation._

@js.native
@JSGlobalScope
object Timers extends js.Object {
  def setTimeout(callback: js.Function0[Unit], delayMillis: Int): Timeout = js.native
  def clearTimeout(timeout: Timeout): Unit = js.native
}

@js.native
trait Timeout extends js.Object {
}
