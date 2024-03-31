import strformat
import osproc


import terminal
import std/os
import std/strutils



proc run_script(scriptPath: string, silent: bool) =
  var command: string
  if silent:
    command = "nim e --warnings:off --hints:off " & scriptPath
  else:
    command = "nim e " & scriptPath

  let output = execProcess(command)
  echo output

run_script("test2.nim",false)