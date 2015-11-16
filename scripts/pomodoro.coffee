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
pomodoroCount = 0;
pomodoroInterval = null
pomodoroCountToBreak = 4

module.exports = (robot) ->
  robot.respond /start pomodoro/i, (msg) ->
    if pomodoroStarted?
      msg.send "Pomodoro already started."
      return

    startPomodoro msg

startPomodoro = (msg) ->
  pomodoroStarted = true
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

  if pomodoroCount % pomodoroCountToBreak == 0
    breakTime = longBreak
    breakTimeMsg = 'Long break started.'

  msg.send breakTimeMsg
  setTimeout ( ->
    msg.send "Break finished."
    startPomodoro msg
  ), breakTime * 60 * 1000
