package org.ensime.atom.external

import scala.scalajs.js
import scala.scalajs.js.annotation._
import org.scalajs.dom.Element

@js.native
@JSImport("sub-atom", JSImport.Namespace)
class SubAtom() extends js.Object{
  def add(closure: Disposable): Unit = js.native
  def add(target: Element, events: String, handler: js.Function1[js.Dynamic, Unit]): Unit = js.native
  def add(target: Element, events: String, selector: String, handler: js.Function1[js.Dynamic, Unit]): Unit = js.native
  def remove(closure: Disposable): Unit = js.native
  def dispose(): Unit = js.native
}
