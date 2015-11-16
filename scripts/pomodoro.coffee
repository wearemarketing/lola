# Description:
#   Hubot's pomodoro timer by WAM
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands
#   hubot start pomodoro - start a new pomodoro
#
# Author:
#   MarioAraque

defaultBreak = 5
longBreak = 15
pomodoroLength = 25
pomodoroStarted = null
pomodoroCurrentLength = 0
pomodoroBreakCurrentLength = 0
pomodoroCount = 0;
pomodoroInterval = null
pomodoroCountToBreak = 4
pomodoroBreak = false
breakTime = 0

module.exports = (robot) ->
  robot.respond /start pomodoro/i, (msg) ->
    if pomodoroStarted?
      msg.send "Pomodoro already started."
      return

    startPomodoro msg

  robot.respond /pomodoro?/i, (msg) ->
    if not pomodoroStarted
      msg.send "The team are not in Pomodoro."
      return

    if not pomodoroBreak
      msg.send "There are still #{(pomodoroLength - pomodoroCurrentLength)} in this Pomodoro."
      return

    if breakTime == defaultBreak
      msg.send "There are still #{breakTime - pomodoroBreakCurrentLength} of short break."

    if breakTime == longBreak
      msg.send "There are still #{breakTime - pomodoroBreakCurrentLength} of long break."

startPomodoro = (msg) ->
  pomodoroStarted = true
  pomodoroBreak = false
  pomodoroCurrentLength = 0
  clearInterval pomodoroInterval

  msg.send "Pomodoro started."
  checkPomodoroCurrentLength msg

checkPomodoroCurrentLength = (msg) ->
  pomodoroInterval = setInterval (->
    pomodoroCurrentLength++

    if pomodoroCurrentLength == pomodoroLength - 5
      msg.send "5 minutes to break."

    if pomodoroCurrentLength == pomodoroLength
      pomodoroCount++
      msg.send "Pomodoro Completed!"
      startBreak msg
  ), 60 * 1000


startBreak = (msg) ->
  breakTime = defaultBreak
  breakTimeMsg = 'Short break started.'
  pomodoroBreak = true

  if pomodoroCount % pomodoroCountToBreak == 0
    breakTime = longBreak
    breakTimeMsg = 'Long break started.'

  msg.send breakTimeMsg
  pomodoroInterval = setInterval ( ->
    pomodoroBreakCurrentLength++
    if pomodoroBreakCurrentLength == breakTime
      msg.send "Break finished."
      startPomodoro msg
  ), 60 * 1000
