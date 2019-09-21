-- RIGHT CLICK + MOUSE = SCROLL (MX Ergo)

local deferred = false

overrideRightMouseDown = hs.eventtap.new({ hs.eventtap.event.types.rightMouseDown }, function(e)
    --print("down"))
    deferred = true
    return true
end)

overrideRightMouseUp = hs.eventtap.new({ hs.eventtap.event.types.rightMouseUp }, function(e)
    -- print("up"))
    if (deferred) then
        overrideRightMouseDown:stop()
        overrideRightMouseUp:stop()
        hs.eventtap.rightClick(e:location())
        overrideRightMouseDown:start()
        overrideRightMouseUp:start()
        return true
    end

    return false
end)


local oldmousepos = {}
local scrollmult = -4 -- negative multiplier makes mouse work like traditional scrollwheel
local scrollsensitivity = 0.8 -- default = 1

dragRightToScroll = hs.eventtap.new({ hs.eventtap.event.types.rightMouseDragged }, function(e)
    -- print("scroll");

    deferred = false

    oldmousepos = hs.mouse.getAbsolutePosition()    

    local dx = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
    local dy = e:getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
    local scroll = hs.eventtap.event.newScrollEvent({ scrollsensitivity * dx * scrollmult, scrollsensitivity * dy * scrollmult},{},'pixel')
    
    -- put the mouse back
    hs.mouse.setAbsolutePosition(oldmousepos)

    return true, {scroll}
end)


function currentlyInXcode() 
 local app = hs.application.find('Xcode')

  if(app == null) then
    return false
  end

 if(app) then
   return app:isFrontmost()
 end
end

-- CUSTOM MOUSE BUTTONS (back, forward, screenshot)

customMouseClicks = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown }, function(e)

  local button = e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)

  if (button == 2) then
    -- print screen
    hs.eventtap.keyStroke({"cmd","shift","ctrl"},"4", 10000)
    return true
elseif (button == 4) then
    -- go forward
    if(currentlyInXcode()) then
      hs.eventtap.keyStroke({"cmd", "ctrl"},"right", 10000)
    else 
      hs.eventtap.keyStroke({"cmd"},"]", 10000)
    end
    return true
  elseif (button == 3) then
    -- go back
    if(currentlyInXcode()) then
      hs.eventtap.keyStroke({"cmd", "ctrl"},"left", 10000)
    else 
      hs.eventtap.keyStroke({"cmd"},"[", 10000)
    end
    return true
  end
  
  return false
end)

-- F keys to Media Keys

functionKeyToMedia = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
  local keyCode = e:getKeyCode()
  local f1 = 122
  local f10 = 99
  local f11 = 99
  local f12 = 99
  local f2 = 120
  local f3 = 99
  local f4 = 118
  local f5 = 96
  local f6 = 97
  local f7 = 98
  local f8 = 100
  local f9 = 101
  local f10 = 109
  local f11 = 103
  local f12 = 111

  if (keyCode == f1) then 
    hs.eventtap.event.newSystemKeyEvent('BRIGHTNESS_DOWN', true):post()
    hs.eventtap.event.newSystemKeyEvent('BRIGHTNESS_DOWN', false):post()
    return true
    elseif (keyCode == f2) then
    hs.eventtap.event.newSystemKeyEvent('BRIGHTNESS_UP', true):post()
    hs.eventtap.event.newSystemKeyEvent('BRIGHTNESS_UP', false):post()
    return true
  elseif (keyCode == f3) then
    hs.application.launchOrFocus("Mission Control.app")
    return true
  elseif (keyCode == f4) then
    hs.application.launchOrFocus("Launchpad.app")
    return true
  elseif (keyCode == f5) then
    hs.eventtap.event.newSystemKeyEvent('ILLUMINATION_DOWN', true):post()
    hs.eventtap.event.newSystemKeyEvent('ILLUMINATION_DOWN', false):post()
    return true
  elseif (keyCode == f6) then
    hs.eventtap.event.newSystemKeyEvent('ILLUMINATION_UP', true):post()
    hs.eventtap.event.newSystemKeyEvent('ILLUMINATION_UP', false):post()
    return true
  elseif (keyCode == f7) then
    hs.eventtap.event.newSystemKeyEvent('REWIND', true):post()
    hs.eventtap.event.newSystemKeyEvent('REWIND', false):post()
    return true
  elseif (keyCode == f8) then
    hs.eventtap.event.newSystemKeyEvent('PLAY', true):post()
    hs.eventtap.event.newSystemKeyEvent('PLAY', false):post()
    return true
  elseif (keyCode == f9) then
    hs.eventtap.event.newSystemKeyEvent('FAST', true):post()
    hs.eventtap.event.newSystemKeyEvent('FAST', false):post()
    return true
  elseif (keyCode == f10) then
    hs.eventtap.event.newSystemKeyEvent('MUTE', true):post()
    hs.eventtap.event.newSystemKeyEvent('MUTE', false):post()
    return true
  elseif (keyCode == f11) then
    hs.eventtap.event.newSystemKeyEvent('SOUND_DOWN', true):post()
    hs.eventtap.event.newSystemKeyEvent('SOUND_DOWN', false):post()
    return true
  elseif (keyCode == f12) then
    hs.eventtap.event.newSystemKeyEvent('SOUND_UP', true):post()
    hs.eventtap.event.newSystemKeyEvent('SOUND_UP', false):post()
    return true
  end

  return false
end)

overrideRightMouseDown:start()
overrideRightMouseUp:start()
dragRightToScroll:start()
customMouseClicks:start()
functionKeyToMedia:start()

-- F18 to Hyper Key

-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, 'F17')

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hyper:exit()
  if not hyper.triggered then
    hs.eventtap.keyStroke({}, "ESCAPE", 10000)
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)


--- SHIFT Parenthesis

shift = nil
shiftCount = 0
prevRawFlags = 256
sendShiftActionTimer = nil
tappingTermSeconds = 0.2
shiftActions = {}
shiftActions["left"] = {
  function() hs.eventtap.keyStroke({"shift"}, "9", 10000) end,    -- (
  function() hs.eventtap.keyStroke({"shift"}, "[", 10000) end,    -- {
  function() hs.eventtap.keyStroke({}, "[", 10000) end            -- [    
}
shiftActions["right"] = {
  function() hs.eventtap.keyStroke({"shift"}, "0", 10000) end,    -- )
  function() hs.eventtap.keyStroke({"shift"}, "]", 10000) end,    -- }
  function() hs.eventtap.keyStroke({}, "]", 10000) end            -- ]    
}

shiftListener = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
  local rawFlags = e:getRawEventData().CGEventData.flags
  local leftShift = rawFlags == 131330 and prevRawFlags == 256
  local rightShift = rawFlags == 131332 and prevRawFlags == 256
  local releasedAll = rawFlags == 256
  local pressedShift = leftShift or rightShift or releasedAll
  
  resetClearShiftTimer()

  if(leftShift) then    
      if(shift == 'left') then
        incrementShiftCount()
      else
        startShiftCount("left")
      end
    elseif (rightShift) then
      if(shift == 'right') then
          incrementShiftCount()
        else
          startShiftCount("right")
        end
    else    
  end

  if leftShift or rightShift then
    resetActionTimer()
  end

  prevRawFlags = rawFlags
end)

clearShiftTimer = null

function resetClearShiftTimer() 

  if(clearActionTimer == null) then
    clearActionTimer = hs.timer.doAfter(tappingTermSeconds, clearShift)
    return  
  end

  clearActionTimer:stop()
  clearActionTimer:start()
end

function startShiftCount(shiftVal)
  shift = shiftVal
  shiftCount = 1
end

function incrementShiftCount() 
  shiftCount = shiftCount + 1
  checkMaxShiftCount()
end

function checkMaxShiftCount() 
  maxCount = #shiftActions[shift] == shiftCount
  if(maxCount) then
    sendShiftAction()
  end
end

function sendShiftAction()
  if not(shift) then
    return
  end

  func =  shiftActions[shift][shiftCount]
  if(func) then
    func()
  end
  clearShift()
end

function resetActionTimer()
  if(sendShiftActionTimer == null) then
    sendShiftActionTimer = hs.timer.doAfter(tappingTermSeconds, sendShiftAction)
    return  
  end

  sendShiftActionTimer:stop()
  sendShiftActionTimer:start()
end


function clearShift() 
  if sendShiftActionTimer then sendShiftActionTimer:stop() end
  shift = nil
  shiftCount = 0
end

shiftListener:start()

anyKeyClearShift = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, clearShift)
anyKeyClearShift:start()

clearShiftOnClick = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown, hs.eventtap.event.types.rightMouseDown }, function(e) 
  clearShift()
end)

clearShiftOnClick:start()

-- -- Example to check if app is currently activated
-- function vsCodeActivated() 
--  local app = hs.application.find('com.microsoft.VSCode')
--  if(app) then
--    return app:isFrontmost()
--  end

--  return false
-- end

--- POPUP TRANSLATION

hs.loadSpoon("PopupTranslateSelection")

hyper:bind({}, 'e', function()
  spoon.PopupTranslateSelection:translateSelectionPopup('en')
  hyper.triggered = true
end)

hyper:bind({}, 'j', function()
  spoon.PopupTranslateSelection:translateSelectionPopup('ja')
  hyper.triggered = true
end)

hyper:bind({}, "return", function()
  local win = hs.window.frontmostWindow()
  win:setFullscreen(not win:isFullscreen())
  hyper.triggered = true
end)

--- App Shortcuts

-- Open App

function open(name)
    return function()
        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
    end
end

hyper:bind({}, "T", open("iTerm"))
hyper:bind({}, "W", open("WebStorm"))
hyper:bind({}, "P", open("PhpStorm"))
hyper:bind({}, "C", open("Visual Studio Code"))
hyper:bind({}, "M", open("Postman"))

--- Number to F keys

hyper:bind({}, "`", function()
  hs.eventtap.keyStroke({},"F1", 10000)
end)
hyper:bind({}, "1", function()
  hs.eventtap.keyStroke({},"F2", 10000)
end)
hyper:bind({}, "2", function()
  hs.eventtap.keyStroke({},"F3", 10000)
end)
hyper:bind({}, "3", function()
  hs.eventtap.keyStroke({},"F4", 10000)
end)
hyper:bind({}, "4", function()
  hs.eventtap.keyStroke({},"F5", 10000)
end)
hyper:bind({}, "5", function()
  hs.eventtap.keyStroke({},"F6", 10000)
end)
hyper:bind({}, "5", function()
  hs.eventtap.keyStroke({},"F7", 10000)
end)
hyper:bind({}, "7", function()
  hs.eventtap.keyStroke({},"F8", 10000)
end)
hyper:bind({}, "8", function()
  hs.eventtap.keyStroke({},"F9", 10000)
end)
hyper:bind({}, "9", function()
  hs.eventtap.keyStroke({},"F10", 10000)
end)
hyper:bind({}, "0", function()
  hs.eventtap.keyStroke({},"F11", 10000)
end)
hyper:bind({}, "-", function()
  hs.eventtap.keyStroke({},"F12", 10000)
end)

-- Avoid automatically setting a bluetooth audio input device

lastSetDeviceTime = os.time()
lastInputDevice = nil

function audioDeviceChanged(arg)
    if arg == 'dev#' then
        lastSetDeviceTime = os.time()
    elseif arg == 'dIn ' and os.time() - lastSetDeviceTime < 2 then
        inputDevice = hs.audiodevice.defaultInputDevice()
        if inputDevice:transportType() == 'Bluetooth' then
            internalMic = lastInputDevice or hs.audiodevice.findInputByName('Built-in Microphone')
            internalMic:setDefaultInputDevice()
        end
    end
    if hs.audiodevice.defaultInputDevice():transportType() ~= 'Bluetooth' then
        lastInputDevice = hs.audiodevice.defaultInputDevice()
    end
end

hs.audiodevice.watcher.setCallback(audioDeviceChanged)
hs.audiodevice.watcher.start()

--- Work - Yourmenu Restaurant Server

hyper:bind({}, "y", function()

    hs.osascript.applescript([[
      if application "PhpStorm" is not running then
        activate application "PhpStorm"
      end if
    ]])

    hs.osascript.applescript([[
      tell application "iTerm"
        activate
        create window with default profile
        tell current session of current window
          write text "cd ~/Homestead && vagrant up"
        end tell
        tell current session of current window
          write text "hshh"
        end tell
        tell current session of current window
          write text "cd /home/vagrant/Code/yourmenu/restaurant/server"
        end tell
        tell current window
          create tab with default profile
        end tell
        tell current session of current window
          write text "cd /Users/mike/Code/yourmenu/restaurant/server"
        end tell
      end tell
    ]])
    hyper.triggered = true
end)