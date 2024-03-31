import strformat
import osproc


import terminal
import std/os
import std/strutils

#----GLOBAL VARIABLES----#

var exercise_number = 1

#-----PATH----#
# section uses : system/nimscript, std/os
if getCurrentDir() != getAppDir():
    echo "Nimlings requires to be runned in its working directory,please move in to nimlings before trying again."
    quit()



#----HELPERS----#
# section uses : std/strutils, std/terminal, std/os

proc promt(text: string) : string =
    echo text
    return stdin.readLine()


proc print_bar(ammount: int,exercise: string) =


    stdout.styledWriteLine(
        if ammount < 30: fgRed
        elif ammount < 70: fgYellow
        else: fgGreen,"[", exercise, "]")

    stdout.styledWriteLine(
        fgRed, "[0 ",
        if ammount < 30: fgRed
        elif ammount < 70: fgYellow
        else: fgGreen, '='.repeat(ammount),
        " ", fgGreen, $ammount, "/", fgGreen, "96]")


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


proc execute_script(script: string, silent: bool, desiredOutput: string): bool =
  var command: string
  if silent:
    command = "nim c -r --warnings:off --hints:off " & script
  else:
    command = "nim c -r " & script

  let output = execCmdEx(command)

  if output.output.contains(desiredOutput):
    return output.exitCode == 0
  else:
    return output.exitCode == 1

proc run_script(scriptPath: string, silent: bool) =

  var command: string
  if silent:
    command = "nim c -r --warnings:off --hints:off " & scriptPath
  else:
    command = "nim c -r " & scriptPath

  
  stdout.styledWriteLine(execProcess(command))

proc clear_flush() =
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

    # clear_flush()
    print_bar(exercise_number,exercise)
    var input = stdin.readLine()

    if input == "run":

      clear_flush()
      
      if execute_script(to_fix,true,desiredOutput):
      

        if done(to_fix):
          exercise_number += 1
          done = true
        else:
          clear_flush()
          stdout.styledWriteLine(fgWhite, "!------", fgGreen, "THE CODE COMPILES AND PASSES THE TEST", fgWhite, "------!")
          echo "| your code compiles, Remove the first line to go to the next code |"
          discard stdin.readLine()
          stdout.resetAttributes()



      else:
        stdout.styledWriteLine(fgWhite, "!-------", fgRed, "THE CODE DINT COMPILE/OR AND PASSED THE TESTS", fgWhite, "--------!")
        echo "| your code dint compile or pass the tests propely down ther |"
        echo "| e theres the script output/error needed for debugging:     |"
        echo "--------------------------------------------------------------"

        run_script(to_fix,false)
        stdout.styledWriteLine(fgRed,"^^^^^^^")
        echo "[Nimlings]Output should exactly be: " & desiredOutput
        echo ""
        echo "Enter to exit.."
        discard stdin.readLine()


    if input == "help":
      clear_flush()

      echo "POSSIBLE COMMANDS ARE"
      echo "clear : clears the terminal"
      echo "run : runs the current exercise"
      echo "explain : explains the task and how it works"
      echo "hint : gives you a hint on how to do the code"
      echo "exit : exit nimlings"
      echo "Enter to exit.."
      discard stdin.readLine()

    if input == "explain":
      clear_flush()
      run_script(explanation,true)
      discard stdin.readLine()

    if input == "hint":
      clear_flush()
      run_script(hint,true)
    
    if input == "clear":
      clear_flush()
    
    if input == "exit":
      clear_flush()
      echo "Bye"
      quit()
    else:
      clear_flush()
    
  if done == true:
    done = false
    # break

start_exercise("code/base/hello","Hello World!")
start_exercise("code/base/syntax","")