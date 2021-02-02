local TERM = "iTerm"

local MOD1 = {"cmd", "ctrl"}
local MOD2 = {"cmd", "ctrl", "alt"}

hs.hotkey.bind(MOD1, '1', nil, function() hs.application.launchOrFocus(TERM) end)
hs.hotkey.bind(MOD1, '2', nil, function() hs.application.launchOrFocus("Firefox") end)
hs.hotkey.bind(MOD1, '3', nil, function() hs.application.launchOrFocus("Slack") end)

hs.hotkey.bind(MOD2, '0', nil, function() hs.application.launchOrFocus("Telegram") end)
hs.hotkey.bind(MOD2, 'k', nil, function() hs.application.launchOrFocus("KeePassXC") end)

-- For some reason F3, F4, F5 work the same way with no extra bindings ¯\_(ツ)_/¯
-- hs.hotkey.bind({}, 'F8', nil, function() hs.eventtap.event.newSystemKeyEvent("PLAY", true):post() end)
-- hs.hotkey.bind({}, 'F7', nil, function() hs.eventtap.event.newSystemKeyEvent("NEXT", true):post() end)
-- hs.hotkey.bind({}, 'F6', nil, function() hs.eventtap.event.newSystemKeyEvent("PREVIOUS", true):post() end)

hs.hotkey.bind(MOD2, "s", nil, function() hs.eventtap.keyStrokes("¯\\_(ツ)_/¯") end)
