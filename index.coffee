Leap = require 'leapjs'
_ = require 'lodash'
robot = require 'robotjs'

AffineTranansformation = require './AffineTranansformation.coffee'

calibration = {}
calibrationMode = false
calibrationTime = 2000
calibrationDelay = 500
transformation = false
sampleRate = 3;
loopIndex = 0;

Leap.loop (frame) ->
  # console.log frame.fingers[0]?.positions[3]
  if calibrationMode
    if frame.fingers[0]?
      calibration[calibrationMode].push frame.fingers[0]?.positions[3]

  if loopIndex % sampleRate == 0
    if transformation && frame.fingers[0]?
      point = transformation.deriveMappingCoords([
        frame.fingers[0].positions[3][0]
        frame.fingers[0].positions[3][1]
      ])
      robot.moveMouse(point.x * 1920, point.y * 1200);

  loopIndex++

calibratePoint = (point, callback) ->
  calibration[point] = []
  console.log "About to calibrate #{point} in 3"
  setTimeout ->
    console.log "2"
    setTimeout ->
      console.log "1"
      setTimeout ->
        console.log "Hold still"
        calibrationMode = point
        setTimeout ->
          calibrationMode = false
          console.log "Done, got #{calibration[point].length} points of data"
          callback()
        ,calibrationTime
      , calibrationDelay
    , calibrationDelay
  , calibrationDelay

getPointAverage = (data, index) ->
  console.log "getting average for #{index}"
  a = _.map(data, (datum) -> datum[index])
  return _.sum(a) / a.length

processCalibratedData = (callback) ->
  for point in ["top-left", "top-right", "bottom-right", "bottom-left"]
    console.log "processing for #{point}"
    o = {}
    o.x = getPointAverage(calibration[point], 0)
    o.y = getPointAverage(calibration[point], 1)
    o.z = getPointAverage(calibration[point], 2)
    calibration[point] = o
  callback()

restoreCalibration = ->
  console.log "Restoring calibration"
  calibration = {
    'top-left': {
      x: -232.5107536764707,
      y: 392.5985036764703,
      z: 37.0422911764706
    },
    'top-right': {
      x: 250.85372426470605,
      y: 383.8343970588232,
      z: 23.221223161764698
    },
    'bottom-right': {
      x: 275.2926770642202,
      y: 141.4656330275229,
      z: -23.898109067889905
    },
    'bottom-left': {
      x: -193.46154311926625,
      y: 94.0273889908257,
      z: -18.111922427522938
    }
  }
  start()

start = ->
  console.log "Starting"
  transformation = new AffineTranansformation(
    calibration["top-left"],
    calibration["top-right"],
    calibration["bottom-right"],
    calibration["bottom-left"]
  )

calibrate = ->
  calibratePoint "top-left", ->
    calibratePoint "top-right", ->
      calibratePoint "bottom-right", ->
        calibratePoint "bottom-left", ->
          processCalibratedData ->
            console.log calibration
            start()

setTimeout ->
  calibrate()
  # restoreCalibration()
, calibrationTime

