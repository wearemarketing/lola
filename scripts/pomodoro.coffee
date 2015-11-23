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
#   hubot stop pomodoro - stop the current pomodoro
#   hubot pomodoro? - get the pomodoro current status
#
# Author:
#   MarioAraque

defaultBreak = 5
longBreak = 15
pomodoroLength = 25
pomodoroStarted = null
pomodoroCurrentLength = 0
pomodoroBreakCurrentLength = 0
pomodoroCount = 0
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
      msg.send "There are still #{(pomodoroLength - pomodoroCurrentLength)} minutes in this Pomodoro."
      return

    if breakTime == defaultBreak
      msg.send "There are still #{breakTime - pomodoroBreakCurrentLength} minutes of short break."

    if breakTime == longBreak
      msg.send "There are still #{breakTime - pomodoroBreakCurrentLength} minutes of long break."

  robot.respond /stop pomodoro/i, (msg) ->
    if not pomodoroStarted
      msg.send "The team are not in Pomodoro."
      return

    stopPomodoro msg

  robot.respond /start (short|long) break/i, (msg) ->
    pomodoroStarted = true
    pomodoroBreakCurrentLength = 0
    pomodoroCount = 0
    startBreak msg, msg.match[1]

startPomodoro = (msg) ->
  pomodoroStarted = true
  pomodoroBreak = false
  pomodoroCurrentLength = 0

  msg.send "Pomodoro started."
  checkPomodoroCurrentLength msg

checkPomodoroCurrentLength = (msg) ->
  clearInterval pomodoroInterval
  pomodoroInterval = setInterval (->
    pomodoroCurrentLength++

    if pomodoroCurrentLength == pomodoroLength - 5
      msg.send "Only 5 minutes to break."

    if pomodoroCurrentLength == pomodoroLength
      pomodoroCount++
      msg.send "Pomodoro Completed!"
      startBreak msg
  ), 60 * 1000

startBreak = (msg, type = '') ->
  pomodoroBreak = true
  clearInterval pomodoroInterval

  if(type == '' or type == 'short')
    breakTime = defaultBreak
    breakTimeMsg = 'Short break started.'

  if (pomodoroCount % pomodoroCountToBreak == 0 and type == '') or (type == 'long')
    breakTime = longBreak
    breakTimeMsg = 'Long break started.'

  msg.send breakTimeMsg
  pomodoroInterval = setInterval ( ->
    pomodoroBreakCurrentLength++
    if pomodoroBreakCurrentLength == breakTime
      msg.send "Break finished."
      startPomodoro msg
  ), 60 * 1000

stopPomodoro = (msg) ->
  pomodoroStarted = null
  pomodoroBreak = false
  clearInterval pomodoroInterval
  pomodoroCurrentLength = 0
  pomodoroCount = 0

  msg.send "Pomodoro stopped."
