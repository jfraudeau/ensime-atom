package org.ensime.atom.external

import scala.scalajs.js
import scala.scalajs.js.annotation._

@js.native
trait Ensime extends js.Object {
  def typecheckFile(file: String): Unit = js.native
  def typecheckBuffer(file: String, buffer: String): Unit = js.native
  def getSymbolAtPoint(path: String, offset: Integer): PromiseLike[SymbolInfo] = js.native
  def symbolByName(name: String): PromiseLike[Typehinted] = js.native
}

@js.native
trait Typehinted extends js.Object {
  val typehint: String = js.native
}

@js.native
trait SymbolInfo extends js.Object {
  @JSName("type")
  val symbolType: js.Dynamic = js.native
}

@js.native
trait Api extends js.Object{
  def getCompletions(filePath: String, bufferText: String, offset: Int, noOfAutocompleteSuggestions: js.UndefOr[Int]): PromiseLike[CompletionsResponse] = js.native
}

@js.native
trait PromiseLike[T] extends js.Object{
  @JSName("then")
  def andThen(continuation: js.Function1[T, Unit]): PromiseLike[Unit] = js.native
  @JSName("catch")
  def recover(handler: js.Function1[js.Any, Unit]): Unit = js.native
}

@js.native
trait CompletionsResponse extends js.Object{
  val prefix: String = js.native
  val completions: js.UndefOr[js.Array[Completion]] = js.native
}

@js.native
trait Completion extends js.Object{
  val isCallable: js.UndefOr[Boolean] = js.native
  val name: String = js.native
  val relevance: Integer = js.native
  val typeInfo: js.UndefOr[TypeInfo] = js.native
  val toInsert: js.UndefOr[String] = js.native
}

@js.native
trait TypeInfo extends js.Object{
  val name: String = js.native
  val fullName: String = js.native
  val typeArgs: js.Array[js.Dynamic]
}
