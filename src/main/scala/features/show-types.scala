package org.ensime.atom.features

import scala.scalajs.js
import scala.scalajs.js.annotation._

import org.ensime.atom.Utils
import org.ensime.atom.AtomFormatting
import org.ensime.atom.external.{
  AtomEnvironment,
  DisplayMarker,
  Disposable,
  DOMListener,
  Ensime,
  LogLevel,
  SubAtom,
  TextEditor,
  Timeout,
  Timers
}
import org.ensime.atom.views.TypeHoverElement

@JSExportAll
@JSExportTopLevel("ShowTypes")
class ShowTypes(editor: TextEditor,  clientLookup: js.Function0[js.UndefOr[Ensime]]) {
  val log = LogLevel.getLogger("ensime.show-types")
  val disposables = new SubAtom()
  var locked = false
  val editorElement = AtomEnvironment.views.getView(editor)

  var marker: js.UndefOr[DisplayMarker] = js.undefined

  var exprTypeTimeout: js.UndefOr[Timeout] = js.undefined
  var openerDisposable: js.UndefOr[js.Dynamic] = js.undefined

  var richTypeTooltip: js.UndefOr[js.Dynamic] = js.undefined

  var unstickCommand: js.UndefOr[Disposable] = js.undefined
  var stickCommand: js.UndefOr[Disposable] = js.undefined

  var domListener: js.UndefOr[DOMListener] = js.undefined

  AtomEnvironment.config.observe[Boolean]("Ensime.enableTypeTooltip", enabled => {
    if(enabled){
      disposables.add(editorElement, "mousemove", ".scroll-view", (e) => {
        clearExprTypeTimeout()
        exprTypeTimeout = Timers.setTimeout(() => showExpressionType(e), 100)
      })

      disposables.add(editorElement, "mouseout", ".scroll-view", (e) => clearExprTypeTimeout())

      disposables.add(editor.onDidDestroy(() => deactivate()))

      disposables.add(AtomEnvironment.config.observe[js.Dynamic]("Ensime.richTypeTooltip", richTypeTooltip_ =>
        richTypeTooltip = richTypeTooltip_
      ))
    }else{
      deactivate()
    }
  })



  def showExpressionType(e: js.Any): Unit = {
    if(locked || marker.isDefined)
      return ()
    else {
      val pixelPt = Utils.pixelPositionFromMouseEvent(editor, e)
      val bufferPt = Utils.bufferPositionFromMouseEvent(editor, e)

      val offset = editor.getBuffer().characterIndexForPosition(bufferPt)

      clientLookup().foreach{client =>
        client.getSymbolAtPoint(editor.getPath(), offset).andThen{msg =>
          marker.foreach(_.destroy())

          if(msg.symbolType.fullName.asInstanceOf[String] == "<none>"){
            // return
          } else {
            marker = editor.markBufferPosition(bufferPt)
            val typeFormatter =
              if(richTypeTooltip.isDefined) AtomFormatting.formatTypeAsHtml(_) else AtomFormatting.formatTypeAsString(_)

            val element = new TypeHoverElement().initialize(typeFormatter(msg.symbolType))
            // domListener.foreach(_.destroy())
            // domListener = new DOMListener(element)
            // domListener.get.add("a", "click", { event =>
            //   val a = event.target
            //   val qualifiedName = URIUtils.decodeURIComponent(a.dataset.qualifiedName)
            //   log.debug("asking for symbol by name: ", qualifiedName)
            //   client.symbolByName(qualifiedName).andThen{ response =>
            //     if(response.declPos)
            //       Goto.goToPosition(response.declPos)
            //       unstickAndHide()
            //   }
            // })


            val overlayDecoration = editor.decorateMarker(marker.get, js.Dynamic.literal(
              `type` = "overlay",
              item = element,
              `class` = "ensime"
            ))

            stickCommand.foreach(_.dispose())
            stickCommand = AtomEnvironment.commands.add("atom-workspace", "ensime:lock-type-hover", {_ =>
              locked = true
              stickCommand.foreach(_.dispose())
              unstickCommand.foreach(_.dispose())
              unstickCommand = AtomEnvironment.commands.add("atom-workspace", "core:cancel", _ => unstickAndHide())
            })
          }
        }.recover{(err) =>
          // Do nothing, this happens when hovering on "stuff"
        }
      }
    }
  }

  def unstickAndHide(): Unit = {
    unstickCommand.foreach(_.dispose())
    locked = false
    hideExpressionType()
  }

  def deactivate(): Unit = {
    clearExprTypeTimeout()
    disposables.dispose()
    stickCommand.foreach(_.dispose())
    unstickCommand.foreach(_.dispose())
    domListener.foreach(_.destroy())
  }

  // helper function to hide tooltip and stop timeout
  def clearExprTypeTimeout(): Unit = {
    exprTypeTimeout.foreach(timeout =>
      Timers.clearTimeout(timeout)
    )
    exprTypeTimeout = js.undefined
    hideExpressionType()
  }

  def hideExpressionType(): Unit = {
    if(locked || marker.isEmpty)
      return ()
    else
    marker.foreach(_.destroy())
    marker = js.undefined
    openerDisposable.foreach(_.dispose())
  }

}
