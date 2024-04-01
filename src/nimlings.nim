import strformat
import osproc
import terminal


import std/rdstdin
import std/os
import std/strutils

#----GLOBAL VARIABLES DECLARATION----#

var exercise_number = 0
var total_exercises = 0




#----HELPERS----#
# section uses : std/strutils, std/terminal, std/os


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


proc run_script_and_check(script: string, silent: bool, desiredOutput: string): bool =
  var command: string
  if silent:
    command = "nim e --warnings:off --hints:off " & script
  else:
    command = "nim e " & script

  let output = execCmdEx(command)
  if desiredOutput == "":
    return output.exitCode == 0
  else:
    let trimmedOutput = output.output.strip().toLowerAscii()
    let normalizedDesiredOutput = desiredOutput.toLowerAscii()
    return trimmedOutput.contains(normalizedDesiredOutput) and output.exitCode == 0

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


#----MAIN PROCESS----#
# uses :  std/strutils, std/terminal, std/os

proc start_exercise(exercise: string,desiredOutput : string) =
  let full_path = fmt"exercises/{exercise}/"
  let to_fix = fmt"{full_path}/main.nim"
  let explanation = fmt"{full_path}/explanation.nim"
  let hint = fmt"{full_path}/hint.nim"

  var done = false

  while not done:

    # clear_terminal()
     print_progress(exercise_number,exercise)
     var input = stdin.readLine()

     if input == "run":

      clear_terminal()
      
      if run_script_and_check(to_fix,true,desiredOutput):
      

        if done(to_fix):
          exercise_number += 1
          done = true

        else:
          clear_terminal()
          stdout.styledWriteLine(fgWhite, "!------", fgGreen, "THE CODE COMPILES AND PASSES THE TEST", fgWhite, "------!")
          echo "| your code compiles and passes the test you can now proceed to t- |"
          echo "| he next code by removing `NOT DONE` from the first line then re- |"
          echo "| run the current exercise to go at the next one.                  |"
        

          discard readLineFromStdin("Press enter to proceed..")
          stdout.resetAttributes()



      else:
        stdout.styledWriteLine(fgWhite, "!-------", fgRed, "THE CODE DINT COMPILE/OR AND PASSED THE TESTS", fgWhite, "--------!")
        echo "| your code dint compile or pass the tests propely down ther |"
        echo "| e theres the script output/error needed for debugging:     |"
        echo "--------------------------------------------------------------"

        run_script(to_fix,false)
        if desiredOutput != "":
          stdout.styledWriteLine(fgRed,"^^^^^^^")
          echo "[Nimlings] Output should contain/be: " & desiredOutput
          echo ""

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
      run_script(explanation,true)
      discard stdin.readLine()

     if input == "hint":
      clear_terminal()
      run_script(hint,true)
      discard stdin.readLine()
    
     if input == "clear":
      clear_terminal()
    
     if input == "exit":
      clear_terminal()
      echo "Bye"
      quit()
     else:
      clear_terminal()
    
  #if done:
    #done = false
    # break

#-----PATH----#
# section uses : system/nimscript, std/os
if getCurrentDir() != getAppDir():
    echo "Nimlings requires to be runned in its working directory,please move in to nimlings before trying again."
    quit()
else:
  clear_terminal()


#----STARTING----#


proc init() =
  exercise_number = 0
  total_exercises = 5


  # NOTE : the path moves already to the exercises folder

  start_exercise("base/firstprogram","Hello World!")

  # VARIABLES #
  start_exercise("base/variables/declaration","Your age is:")
  start_exercise("base/variables/immutable/let","1.59")
  start_exercise("base/variables/immutable/const","hi")
  start_exercise("base/variables/datatypes1","14")

init()