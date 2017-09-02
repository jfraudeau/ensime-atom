package org.ensime.atom.external

import scala.scalajs.js
import scala.scalajs.js.annotation._
import org.scalajs.dom.Element


// TODO: not really needed
@js.native
@JSImport("dom-listener", JSImport.Namespace)
class DOMListener(element: Element) extends js.Object{
  def add(selector: String, event: String, callback: Function1[js.Dynamic, Unit]): Unit = js.native
  def destroy(): Unit = js.native
}
