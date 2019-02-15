local TERM = "iTerm"
-- local TERM = "Alacritty"

local MOD1 = {"cmd", "ctrl"}
local MOD2 = {"cmd", "ctrl", "alt"}

hs.hotkey.bind(MOD1, '0', nil, function() hs.application.launchOrFocus("Finder") end)
hs.hotkey.bind(MOD1, '1', nil, function() hs.application.launchOrFocus(TERM) end)
hs.hotkey.bind(MOD1, '2', nil, function() hs.application.launchOrFocus("Firefox") end)
hs.hotkey.bind(MOD1, '3', nil, function() hs.application.launchOrFocus("Telegram") end)
hs.hotkey.bind(MOD2, 'k', nil, function() hs.application.launchOrFocus("KeePassXC") end)
hs.hotkey.bind(MOD2, 'm', nil, function() hs.application.launchOrFocus("YAM") end)

local yamusicKey = function(key)
  -- local frontmostApp = hs.application.frontmostApplication()
  hs.application.launchOrFocus("Safari")
  hs.eventtap.keyStroke({}, key)
  -- doesn't work for some reason :-(
  -- frontmostApp.activate()
  hs.eventtap.keyStroke({"cmd"}, "h")
end

-- hs.hotkey.bind({}, 'F8', nil, function() yamusicKey("Space") end)
-- hs.hotkey.bind({}, 'F7', nil, function() yamusicKey("j") end)
-- hs.hotkey.bind({}, 'F6', nil, function() yamusicKey("k") end)

hs.hotkey.bind({}, 'F8', nil, function() hs.eventtap.event.newSystemKeyEvent("PLAY", true):post() end)
hs.hotkey.bind({}, 'F7', nil, function() hs.eventtap.event.newSystemKeyEvent("NEXT", true):post() end)
hs.hotkey.bind({}, 'F6', nil, function() hs.eventtap.event.newSystemKeyEvent("PREVIOUS", true):post() end)

hs.hotkey.bind(MOD2, "s", nil, function() hs.eventtap.keyStrokes("¯\\_(ツ)_/¯") end)
