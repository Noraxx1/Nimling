include core

proc init() =
  exercise_number = 0
  total_exercises = 8
  start_exercise("base/firstprogram")
  start_exercise("base/variables/declaration")
  start_exercise("base/variables/immutable/let")
  start_exercise("base/variables/immutable/const")
  start_exercise("base/variables/datatypes1")
  start_exercise("base/variables/floats")
  start_exercise("base/variables/transmutation")
  start_exercise("base/quiz/pipe")

init()