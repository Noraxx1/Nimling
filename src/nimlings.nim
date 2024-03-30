import strformat
import osproc


import std/terminal
import std/os
import std/strutils


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




proc execute_script(script: string, silent: bool, desiredOutput: string): bool =
  var command: string
  if silent:
    command = "nim -d:release c -r --warnings:off --hints:off " & script
  else:
    command = "nim -d:release c -r " & script

  let output = execCmdEx(command)

  if output.output.contains(desiredOutput):
    return output.exitCode == 0
  else:
    return output.exitCode == 1

proc run_script(scriptPath: string, silent: bool) =

  var command: string
  if silent:
    command = "nim -d:release c -r --warnings:off --hints:off " & scriptPath
  else:
    command = "nim -d:release c -r " & scriptPath

  
  echo execProcess(command)

proc clear_flush() =
      stdout.eraseScreen()
      stdout.flushFile() 
      stdout.resetAttributes()

#----MAIN PROCESS----#
# uses :  std/strutils, std/terminal, std/os

proc start_exercise(exercise: string,desiredOutput : string) =
  let full_path = fmt"exercises/{exercise}/"
  let to_fix = fmt"{full_path}/main.nim"
  let explanation = fmt"{full_path}/explanation.nim"
  let hint = fmt"{full_path}/hint.nim"

  var done = false

  while not done:
    var input = stdin.readLine()

    
    if input == "run":

      clear_flush()
      
      if execute_script(to_fix,true,desiredOutput):
      
        stdout.resetAttributes()

        stdout.styledWriteLine(fgWhite, "!------", fgGreen, "THE CODE COMPILES AND PASSES THE TEST", fgWhite, "------!")
        echo "| your code compiles, you can freely goto the next code to fix it |"

        stdout.resetAttributes()

        done = true
      else:
        stdout.styledWriteLine(fgWhite, "!------", fgGreen, "THE CODE DINT COMPILE/OR AND PASSED THE TESTS", fgWhite, "------!")
        echo "| your code dint compile or pass the tests propely heres "
        echo "| down this line theres the script output/error:        |"
        echo "--------------------------------------------------------------------"
        run_script(to_fix,false)

    if input == "explain":
      echo "test"
      run_script(explanation,true)

    if input == "hint":
      run_script(hint,true)


start_exercise("code/base/hello","Hello World!")