import strformat
import osproc
import terminal
import json

import std/rdstdin
import std/os
import std/strutils

#----GLOBAL VARIABLES DECLARATION----#

var exercise_number = 0
var total_exercises = 0




#----HELPERS----#
# section uses : std/strutils, std/terminal, std/os,json


proc  print_progress(ammount: int,exercise: string) =

    stdout.styledWriteLine(
        if ammount < 30: fgRed
        elif ammount < 70: fgYellow
        else: fgGreen,"[", exercise, "]")

    stdout.styledWriteLine(
        fgRed, "[0 ",
        if ammount < 30: fgRed
        elif ammount < 70: fgYellow
        else: fgGreen, '='.repeat(ammount),
        " ", fgGreen, $ammount, "/", fgGreen, $total_exercises, "]")


proc done(filename: string): bool =
  let file = open(filename)

  if file != nil:
    var line = file.readLine()
    close(file)

    if line != "":
      if line.contains("NOT") and line.contains("DONE"):
        return false
      else:
        return true
    else:
      return true
  else:
    return false


proc run_script_and_check(script: string, silent: bool, desired_output: string): bool =
  var command: string
  if silent:
    command = "nim e --warnings:off --hints:off " & script
  else:
    command = "nim e " & script

  let output = execCmdEx(command)
  if desired_output == "":
    return output.exitCode == 0
  else:
    let trimmedOutput = output.output.strip().toLowerAscii()
    let normalizeddesired_output = desired_output.toLowerAscii()
    return trimmedOutput.contains(normalizeddesired_output) and output.exitCode == 0

proc run_script(scriptPath: string, silent: bool) =
  var command: string
  if silent:
    command = "nim e --warnings:off --hints:off " & scriptPath
  else:
    command = "nim e --hints:off " & scriptPath

  let output = execProcess(command)
  echo output

proc clear_terminal() =
  setCursorPos(0, 0)
  stdout.eraseScreen()
  stdout.flushFile()

  # stdout.resetAttributes()

type
 json_data = object
   hint: string
   explanation: string
   desired_output: string

proc fetch_json(fileName: string): json_data =
 let jsonData = parseFile(fileName)
 result.hint = jsonData["hint"].getStr()
 result.explanation = jsonData["explanation"].getStr()
 result.desired_output = jsonData["desired_output"].getStr()


#----MAIN PROCESS----#
# uses :  std/strutils, std/terminal, std/os, json

proc start_exercise(exercise: string) =
  let full_path = fmt"exercises/{exercise}/"
  let to_fix = fmt"{full_path}/main.nim"

  let exercise_data = fetch_json(fmt"{full_path}/data.json")

  var explanation = exercise_data.explanation
  var hint = exercise_data.hint
  var desired_output = exercise_data.desired_output

  if explanation == "None":
    explanation = "Sorry theres no explanation for this exercise."
  if hint == "None":
    hint = "Sorry theres no hint for this exercise."


  var done = false

  while not done:

    # clear_terminal()
     print_progress(exercise_number,exercise)
     var input = stdin.readLine()

     if input == "run":

      clear_terminal()

      if run_script_and_check(to_fix,true,desired_output):


        if done(to_fix):
          exercise_number += 1
          done = true

        else:
          clear_terminal()
          stdout.styledWriteLine(fgWhite, "!---------", fgGreen, "THE CODE COMPILES AND PASSES THE TEST", fgWhite, "---------!")
          echo "| your code compiled and passed the test,you can now pr- |"
          echo "| oceed to the next exercise by removing `# NOT DONE` f- |"
          echo "| rom the start of the first line,after type `run` again |"
          echo "| inside the nimlings console to proceed.                |"


          discard readLineFromStdin("Press enter to proceed..")
          stdout.resetAttributes()



      else:
        stdout.styledWriteLine(fgWhite, "!-------", fgRed, "THE CODE DINT COMPILE/OR AND PASSED THE TESTS", fgWhite, "--------!")
        echo "| your code dint compile or pass the tests propely down ther |"
        echo "| e theres the script output/error needed for debugging:     |"
        echo "--------------------------------------------------------------"

        run_script(to_fix,false)
        if desired_output != "":
          stdout.styledWriteLine(fgRed,"^^^^^^^")
          echo "[Nimlings] Output should contain/be: " & desired_output
          echo ""
#a
          discard readLineFromStdin("Press enter to proceed..")


     if input == "help":
      clear_terminal()

      echo "POSSIBLE COMMANDS ARE"
      echo "clear : clears the terminal"
      echo "run : runs the current exercise"
      echo "explain : explains the task and how it works"
      echo "hint : gives you a hint on how to do the code"
      echo "exit : exit nimlings"
      echo ""
      discard readLineFromStdin("Press enter to proceed..")

     if input == "explain":
      clear_terminal()
      echo explanation

     discard readLineFromStdin("Press enter to proceed..")

     if input == "hint":
      clear_terminal()
      echo hint

      discard readLineFromStdin("Press enter to proceed..")

     if input == "clear":
      clear_terminal()

     if input == "exit":
      clear_terminal()
      echo "Bye"
      quit()
     else:
      clear_terminal()

     if input == "path":
       clear_terminal()
       echo full_path
       discard readLineFromStdin("Press enter to proceed..")



#-----PATH----#
# section uses : system/nimscript, std/os
if getCurrentDir() != getAppDir():
    echo "Nimlings requires to be runned in its working directory,please move in to nimlings before trying again."
    quit()
else:
  clear_terminal()

