import strformat
import osproc
import terminal
import json

import std/random
import std/rdstdin
import std/os
import std/strutils
randomize()

#----GLOBAL VARIABLES DECLARATION----#

var exercise_number = 0
var total_exercises = 0
var done2 = false



#----HELPERS----#
# section uses : std/strutils, std/terminal, std/os,json

# [■□□□□□□□□□] 10%
proc print_progress(ammount: int, exercise: string) =
  let percentage = ammount
  stdout.styledWriteLine(
    fgRed, "[",
    if ammount < 30: fgRed
    elif ammount < 70: fgYellow
    else: fgGreen,
    "■".repeat(int(ammount / 10)),
    "□".repeat(int((100 - ammount) / 10)),
    "] ", $percentage, "% ", exercise)





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
 stdout.resetAttributes()
 setCursorPos(0, 0)
 stdout.eraseScreen()
 stdout.flushFile()



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



proc compiler(script: string, expected: string): bool =
 if run_script_and_check(script, true, expected):
       if done(script):
         exercise_number += 1
         done2 = true

       else:
         clear_terminal()
         stdout.styledWriteLine(fgWhite, "!---------", fgGreen, "Your code just passed the tests and compiled!", fgWhite, "---------!")
         echo "Good job,you just ended another exercise keep going!"
         echo "[NOTE]: to continue remove the #NOT DONE on line 0/1"


         discard readLineFromStdin("Press enter to proceed..")
         clear_terminal()
         return true

 else:



   if expected != "":

     echo ""

     echo execProcess(fmt"nim e --warnings:off --hints:off {script}")
     stdout.styledWriteLine(fgRed,"^^^^^^^")
     echo "[NOTE] Output should contain/be: " & expected
     echo ""


   stdout.styledWriteLine(fgWhite, "!-------", fgRed, "Oh no! your code dint compile or pass the tests!", fgWhite, "--------!")
   echo "Dont be sad,failing helps you learning things better!"
   echo ""
   discard readLineFromStdin("Press enter to proceed..")
   return false



# uses :  std/strutils, std/terminal, std/os, json


proc start_exercise(exercise: string) =
 let full_path = fmt"exercises/{exercise}/"
 let to_fix = fmt"{full_path}/main.nim"

 let exercise_data = fetch_json(fmt"{full_path}data.json")
 var explanation = exercise_data.explanation
 var hint = exercise_data.hint
 var desired_output = exercise_data.desired_output

 if explanation == "None":
   explanation = "Sorry theres no explanation for this exercise."
 if hint == "None":
   hint = "Sorry theres no hint for this exercise."

 while not done2:

    print_progress(exercise_number,exercise)

    var input = stdin.readLine()

    if input == "run":

     clear_terminal()

     if compiler(to_fix,desired_output):
       break


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
     discard readLineFromStdin("Press enter to proceed")
     clear_terminal()

    if input == "hint":
     clear_terminal()
     echo hint


    if input == "clear":
     clear_terminal()

    if input == "exit":
     clear_terminal()
     echo "Bye"
     quit()

    if input == "path":
      clear_terminal()
      echo full_path
      discard readLineFromStdin("Press enter to proceed..")
      clear_terminal()
    else:
       clear_terminal()




#-----PATH----#
# section uses : system/nimscript, std/os
if getCurrentDir() != getAppDir():
   echo "Nimlings requires to be runned in its working directory,please move in to nimlings before trying again."
   quit()
else:
 clear_terminal()