import           Control.Applicative ((<$>))
import qualified Data.Map as M
import           System.Exit         (exitWith, ExitCode(..))

import           XMonad
import qualified XMonad.StackSet as W
import           XMonad.Util.Run

import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.UrgencyHook

import           XMonad.Actions.CycleWS
import           XMonad.Actions.GridSelect

import           XMonad.Layout.LayoutModifier
import           XMonad.Layout.Maximize
import           XMonad.Layout.Monitor
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.Tabbed

import           XMonad.Util.NamedScratchpad
import           XMonad.Util.Paste
import           XMonad.Util.SpawnOnce


main = do
    xmonad
      $ withUrgencyHook NoUrgencyHook
      $ myConfig

-- Settings {{{
myTerminal           = "urxvt"
myModMask            = mod4Mask
myFocusFollowsMouse  = True
myBorderWidth        = 1
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"
myWorkspaces         = map show [1..9] ++ ["0", "-", "="]
myUrgencyHook        = dzenUrgencyHook { args = myDzenUrgencyArgs }
myUrgencyConfig      = urgencyConfig { remindWhen = Every $ 10 }
myDzenUrgencyArgs    = [
    "-xs", "1"
  , "-p",  "2"
  , "-bg", "darkgreen"
  , "-fn", "-*-fixed-medium-r-*-*-10-*-*-*-*-*-*-*"
  ]

myConfig = defaultConfig {
    terminal           = myTerminal
  , modMask            = myModMask
  , workspaces         = myWorkspaces
  , manageHook         = myManageHook
  , layoutHook         = myLayout
  -- , logHook            = myXmobarLogHook bar
  , startupHook        = myStartupHook

  , keys               = myKeys
  , mouseBindings      = myMouseBindings
  , focusFollowsMouse  = myFocusFollowsMouse

  , borderWidth        = myBorderWidth
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
}
-- }}}

-- Startup Hook {{{
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "xautolock"
    -- spawnOnce "xbindkeys -f /home/dmedvinsky/.config/xbindkeys/rc"
    -- spawnOnce "urxvtd -q -o -f"
    -- spawnOnce "stalonetray"
    spawnOnce "workrave"
-- }}}

-- Window rules {{{
scratchpads = [
    NS "keepassx" "keepassx" (className =? "Keepassx") defaultFloating
  , NS "deadbeef" "deadbeef" (className =? "Deadbeef") defaultFloating
  ]

trayMonitor = monitor {
    prop = ClassName "stalonetray"
  , rect = Rectangle (1920-96) (1080-16) 96 16
  , persistent = True
}

keepMaster :: (a -> Bool) -> Query a -> ManageHook
keepMaster f g = assertSlave <+> assertMaster
  where
    assertSlave = fmap (not . f) g --> doF W.swapDown
    assertMaster = fmap f g --> doF W.swapMaster

myManageHookRules = composeAll
  [
    isFullscreen --> doFullFloat
  , role =? "GtkFileChooserDialog" --> doCenterFloat
  , role =? "GtkFileChooserDialog" --> doF W.swapMaster
  , className =? "Workrave" --> doIgnore
  -- , className =? "stalonetray" --> doIgnore
  , className =? "Skype" --> doShift "="
  , className =? "feh" --> doFullFloat
  , currentWs =? "2" --> keepMaster ("Firefox" ==) className
  ]
  where
    role = stringProperty "WM_WINDOW_ROLE"
myManageHook = myManageHookRules
               <+> namedScratchpadManageHook scratchpads
               <+> manageMonitor trayMonitor
-- }}}

-- Layouts {{{
myLayout = onWorkspace "1" (myFull ||| myTiled)
         $ onWorkspace "2" (biggerMaster ||| myFull)
         $ myTiled ||| myFull ||| myTabbed
  where
    mkTiled nmaster delta ratio = smartBorders $ maximize $ Tall nmaster delta ratio
    myFull = noBorders Full
    myTiled = mkTiled 1 (3/100) (1/2)
    biggerMaster = mkTiled 1 (3/100) (2/3)
    myTabbed = tabbed shrinkText myTabConfig
      where
        myTabConfig = defaultTheme { inactiveBorderColor = "#BFBFBF"
                                   , activeTextColor = "#FFFFFF"
                                   }
-- }}}

-- Mouse bindings and options {{{
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    , ((modMask, button4), (\w -> focus w >> windows W.swapUp))
    , ((modMask, button5), (\w -> focus w >> windows W.swapDown))
    ]
-- }}}

-- Key bindings {{{
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((m .|. s, xK_q), io (exitWith ExitSuccess))
    , ((m, xK_q), restart "xmonad" True)

    , ((m, xK_Return), spawn $ XMonad.terminal conf)
    , ((m, xK_r), spawn $ "dmenu_run")

    , ((m, xK_space), sendMessage NextLayout)
    , ((m .|. s, xK_space), setLayout $ XMonad.layoutHook conf)

    , ((m .|. s, xK_Return), windows W.focusMaster)
    , ((m .|. c,  xK_Return), windows W.swapMaster)
    , ((m, xK_comma ), sendMessage (IncMasterN 1))
    , ((m, xK_period), sendMessage (IncMasterN (-1)))

    , ((m, xK_c), kill)
    , ((m, xK_BackSpace), withFocused (sendMessage . maximizeRestore))
    , ((m, xK_j), windows W.focusDown)
    , ((m, xK_k), windows W.focusUp)
    , ((m .|. s, xK_j), windows W.swapDown)
    , ((m .|. s, xK_k), windows W.swapUp)
    , ((m, xK_h), sendMessage Shrink)
    , ((m, xK_l), sendMessage Expand)

    , ((m, xK_t), withFocused $ windows . W.sink)
    , ((m, xK_u), focusUrgent)
    , ((m, xK_Tab), toggleWS)
    , ((m, xK_p), pasteSelection)
    , ((m, xK_slash), goToSelected defaultGSConfig)

    , ((m, xK_F1), spawn "toggle_tray.sh")
    , ((m, xK_F2), spawn "firefox")
    , ((m, xK_F3), spawn "skype")
    , ((m, xK_F9), spawn "mpctl prev")
    , ((m, xK_F10), spawn "mpctl toggle")
    , ((m, xK_F11), spawn "mpctl next")
    , ((m, xK_F12), spawn "lock")
    , ((m, xK_a), namedScratchpadAction scratchpads "keepassx")
    , ((m, xK_m), namedScratchpadAction scratchpads "deadbeef")
    ]

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    ++
    [((mod .|. modMask, key), windows $ f i)
        | (i, key) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0, xK_minus, xK_equal])
        , (f, mod) <- [(W.view, 0), (W.shift, shiftMask)]]

    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    ++
    [((mod .|. modMask, key), screenWorkspace screen >>= flip whenJust (windows . f))
        | (key, screen) <- zip [xK_e, xK_w] [0..]
        , (f, mod) <- [(W.view, 0), (W.shift, shiftMask)]]

    -- ++
    -- [
    -- -- keycode 180 (keysym 0x1008ff18, XF86HomePage)
    --   ((0, 0x1008ff18), spawn "")
    -- -- keycode 225 (keysym 0x1008ff1b, XF86Search)
    -- , ((0, 0x1008ff1b), spawn "")
    -- -- keycode 163 (keysym 0x1008ff19, XF86Mail)
    -- , ((0, 0x1008ff19), spawn "")
    -- -- keycode 148 (keysym 0x1008ff1d, XF86Calculator)
    -- , ((0, 0x1008ff1d), spawn "")
    -- -- keycode 164 (keysym 0x1008ff30, XF86Favorites)
    -- , ((0, 0x1008FF30), spawn $ myBin "toggle_tray.sh")

    -- -- keycode 192 (keysym 0x1008ff45, XF86Launch5)
    -- , ((0, 0x1008FF45), spawn "")
    -- -- keycode 193 (keysym 0x1008ff46, XF86Launch6)
    -- , ((0, 0x1008FF46), spawn "")
    -- -- keycode 194 (keysym 0x1008ff47, XF86Launch7)
    -- , ((0, 0x1008FF47), spawn "")
    -- -- keycode 195 (keysym 0x1008ff48, XF86Launch8)
    -- , ((0, 0x1008FF48), spawn "")
    -- -- keycode 196 (keysym 0x1008ff49, XF86Launch9)
    -- , ((0, 0x1008FF49), spawn "")

    -- -- (keysym 0x1008ff12, XF86AudioMute)
    -- , ((0, 0x1008ff12), spawn "amixer -q set Master toggle")
    -- -- (keysym 0x1008ff11, XF86AudioLowerVolume)
    -- , ((0, 0x1008ff11), spawn "amixer -q set Master 1- unmute")
    -- -- (keysym 0x1008ff13, XF86AudioRaiseVolume)
    -- , ((0, 0x1008ff13), spawn "amixer -q set Master 1+ unmute")
    -- -- keycode 172 (keysym 0x1008ff14, XF86AudioPlay)
    -- , ((0, 0x1008ff14), spawn "mpctl toggle")
    -- ]
    where
        m = modMask
        c = controlMask
        s = shiftMask
-- }}}

-- vim: fdm=marker
