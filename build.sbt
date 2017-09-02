enablePlugins(ScalaJSPlugin)

// project name/version
name := "ensimesjs"
version := "0.1.0"

// what version of scala to use
scalaVersion := "2.12.3"

// libraries
libraryDependencies ++= Seq(
  "org.scala-js" %%% "scalajs-dom" % "0.9.1"
)

resourceDirectory := baseDirectory.value / "lib"

// write files to to lib
artifactPath in (Compile, fastOptJS) := resourceDirectory.value / s"${name.value}.js"
artifactPath in (Compile, fullOptJS) := resourceDirectory.value / "js" / s"${name.value}.js"

// do not emit source maps in production
emitSourceMaps in fullOptJS := false

scalaJSModuleKind := ModuleKind.CommonJSModule
