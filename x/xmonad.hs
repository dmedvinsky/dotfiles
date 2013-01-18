import           Control.Applicative ((<$>))
import           Control.Monad       (liftM)
import           Data.List           (isInfixOf)
import           Data.Ratio          ((%))
import qualified Data.Map as M
import           System.Exit         (exitWith, ExitCode(..))
import           System.Posix.Unistd (nodeName, getSystemID)

import           XMonad
import qualified XMonad.StackSet as W
import           XMonad.Util.Run

import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.UrgencyHook

import           XMonad.Actions.CycleWS
import           XMonad.Layout.Circle
import           XMonad.Layout.Combo
import           XMonad.Layout.ComboP
import           XMonad.Layout.DragPane
import           XMonad.Layout.Grid
import           XMonad.Layout.Maximize
import           XMonad.Layout.Minimize
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.Tabbed
import           XMonad.Layout.TwoPane


main = do
    barproc <- spawnPipe myBar
    xmonad $ withUrgencyHook NoUrgencyHook
           $ myConfig barproc


-- Settings {{{
myTerminal           = "urxvtc"
myBar                = "xmobar ~/.xmonad/xmobarrc"
myModMask            = mod4Mask
myFocusFollowsMouse  = True
myBorderWidth        = 1
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"
myWorkspaces         = map show [1..9] ++ ["0", "-", "="]
ctrlMask             = controlMask

myConfig bar = defaultConfig {
    terminal           = myTerminal
  , modMask            = myModMask
  , workspaces         = myWorkspaces
  , manageHook         = myManageHook
  , layoutHook         = myLayout
  , logHook            = myXmobarLogHook bar
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
    spawn "xautolock"
-- }}}

-- Window rules {{{
keepMaster :: (a -> Bool) -> Query a -> ManageHook
keepMaster f g = assertSlave <+> assertMaster
  where
    assertSlave = fmap (not . f) g --> doF W.swapDown
    assertMaster = fmap f g --> doF W.swapMaster

myManageHook = composeAll
  [
    isFullscreen --> doFullFloat

  , className =? "stalonetray"    --> doIgnore
  , className =? "Workrave"       --> doIgnore

  , className =? "Firefox"        --> doShift "2"
  , className =? "Firefox" <&&> isInfixOf "Downloads" <$> title
                                  --> doCenterFloat
  , className =? "Firefox" <&&> isInfixOf "Firebug" <$> title
                                  --> doShift "-"
                                  <+> doFullFloat

  , className =? "Skype"          --> doShift "=" <+> doFloat
  , className =? "Keepassx"       --> doFloat
  , className =? "feh"            --> doCenterFloat
  , className =? "MPlayer"        --> doCenterFloat

  -- , currentWs =? "="              --> keepMaster ("dmitry.medvinsky" `isInfixOf`) title
  ]
-- }}}

-- Status bars and logging {{{
myXmobarLogHook xmproc = dynamicLogWithPP $ xmobarPP {
    ppCurrent         = xmobarColor "#00FF00" "" . wrap "<" ">"
  , ppVisible         = xmobarColor "#00AA00" "" . wrap "<" ">"
  , ppHidden          = xmobarColor "#AAAAAA" ""
  , ppHiddenNoWindows = const ""
  , ppUrgent          = xmobarColor "#FFFFFF" "#FF0000" . wrap "[" "]" . xmobarStrip
  , ppWsSep           = " "
  , ppSep             = xmobarColor "#FFFFFF" "" " | "
  , ppLayout          = xmobarColor "#AAAAAA" ""  . shorten 80
  , ppTitle           = xmobarColor "#CCCCCC" ""
  , ppOutput          = hPutStrLn xmproc
}
-- }}}

-- Layouts {{{
myLayout = avoidStruts $
           onWorkspace "1" (myFull ||| myTiled) $
           onWorkspace "-" (myGrid ||| myDragPaneV) $
           onWorkspace "=" (myTabbed ||| Circle ||| myGrid) $
           minimize $ myTiled
           ||| myFull
           ||| myTabbed
           ||| myGrid
           ||| termCombo
  where
    myTiled = smartBorders tiled
    myFull = noBorders Full
    myGrid = smartBorders Grid
    myDragPaneV = dragPane Vertical 0 0.5

    tiled = maximize $ Tall nmaster delta ratio
      where
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100

    myTabbed = tabbed shrinkText myTabConfig
      where
        myTabConfig = defaultTheme { inactiveBorderColor = "#BFBFBF"
                                   , activeTextColor = "#FFFFFF"}

    termCombo = maximize $ combineTwoP comboLayout comboPane1 comboPane2 comboCondition
      where
        comboLayout = TwoPane 0.03 0.5
        comboPane1  = myTabbed
        comboPane2  = myTabbed
        comboCondition = ClassName "URxvt"
-- }}}

-- Mouse bindings and options {{{
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    --, ((modMask, button4), ())
    --, ((modMask, button5), ())
    ]
-- }}}


-- Key bindings {{{
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modMask,               xK_q     ), restart "xmonad" True)

    , ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask,               xK_p     ), spawn $ "dmenu_run")
    , ((modMask,               xK_b     ), sendMessage ToggleStruts)

    , ((modMask,               xK_space ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    , ((modMask .|. shiftMask, xK_c     ), kill)
    , ((modMask,            xK_BackSpace), withFocused (sendMessage . maximizeRestore))
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask,               xK_k     ), windows W.focusUp)
    , ((modMask,               xK_Return), windows W.focusMaster)
    , ((modMask .|. ctrlMask,  xK_Return), windows W.swapMaster)
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown)
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp)
    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
    , ((modMask,               xK_u     ), focusUrgent)

    , ((modMask,               xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask,               xK_period), sendMessage (IncMasterN (-1)))

    , ((modMask,               xK_Tab   ), toggleWS)
    ]

    ++

    [
    -- keycode 180 (keysym 0x1008ff18, XF86HomePage)
      ((0, 0x1008ff18), spawn "luakit")
    , ((modMask, 0x1008ff18), spawn "firefox")
    -- keycode 225 (keysym 0x1008ff1b, XF86Search)
    -- , ((0, 0x1008ff1b), spawn "")
    -- keycode 163 (keysym 0x1008ff19, XF86Mail)
    , ((0, 0x1008ff19), spawn $ termCmd "mail")

    -- keycode 192 (keysym 0x1008ff45, XF86Launch5)
    , ((0, 0x1008FF45), spawn "skype")
    -- keycode 193 (keysym 0x1008ff46, XF86Launch6)
    , ((0, 0x1008FF46), spawn $ termCmdWithName (myBin "mcabber") "jabber")
    -- keycode 194 (keysym 0x1008ff47, XF86Launch7)
    , ((0, 0x1008FF47), spawn "keepassx")
    -- keycode 195 (keysym 0x1008ff48, XF86Launch8)
    -- , ((0, 0x1008FF48), spawn "")
    -- keycode 196 (keysym 0x1008ff49, XF86Launch9)
    -- , ((0, 0x1008FF49), spawn "")

    -- (keysym 0x1008ff12, XF86AudioMute)
    , ((0, 0x1008ff12), spawn "amixer -q set Master toggle")
    -- (keysym 0x1008ff11, XF86AudioLowerVolume)
    , ((0, 0x1008ff11), spawn "amixer -q set Master 1- unmute")
    -- (keysym 0x1008ff13, XF86AudioRaiseVolume)
    , ((0, 0x1008ff13), spawn "amixer -q set Master 1+ unmute")
    -- keycode 172 (keysym 0x1008ff14, XF86AudioPlay)
    , ((0, 0x1008ff14), spawn "cmus-remote --pause")
    , ((ctrlMask, 0x1008ff14), spawn "cmus-remote --stop")
    , ((modMask, 0x1008ff14), spawn $ termCmd $ "cmus")

    -- keycode 148 (keysym 0x1008ff1d, XF86Calculator)
    -- , ((0, 0x1008ff1d), spawn "")

    -- keycode 164 (keysym 0x1008ff30, XF86Favorites)
    , ((0, 0x1008FF30), spawn $ myBin "toggle_tray.sh")

    , ((modMask,               xK_F12     ), spawn $ myBin "lock")
    , ((modMask .|. ctrlMask,  xK_F12     ), spawn $ myBin "lock" ++ " 1")

    -- control mouse from keyboard
    , ((modMask             ,  xK_Left    ), spawn $ "xdotool mousemove_relative -- -30 0")
    , ((modMask             ,  xK_Right   ), spawn $ "xdotool mousemove_relative -- 30 0")
    , ((modMask             ,  xK_Up      ), spawn $ "xdotool mousemove_relative -- 0 -30")
    , ((modMask             ,  xK_Down    ), spawn $ "xdotool mousemove_relative -- 0 30")
    , ((modMask .|. ctrlMask,  xK_Left    ), spawn $ "xdotool mousemove_relative -- -3 0")
    , ((modMask .|. ctrlMask,  xK_Right   ), spawn $ "xdotool mousemove_relative -- 3 0")
    , ((modMask .|. ctrlMask,  xK_Up      ), spawn $ "xdotool mousemove_relative -- 0 -3")
    , ((modMask .|. ctrlMask,  xK_Down    ), spawn $ "xdotool mousemove_relative -- 0 3")
    , ((modMask             ,  xK_KP_Enter), spawn $ "xdotool click -- 1")
    , ((modMask .|. ctrlMask,  xK_KP_Enter), spawn $ "xdotool click -- 3")
    ]

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    ++
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0, xK_minus, xK_equal])
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    ++
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_e, xK_w] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
-- }}}

-- Utility functions {{{
data Host = Work | Home | Other
  deriving (Eq, Read, Show)

getHost :: IO Host
getHost = do
  hostName <- nodeName `fmap` getSystemID
  return $ case hostName of
    "zeus" -> Work
    "home" -> Home
    _      -> Other

termCmdWithName cmd name =
    myTerminal ++ " -name " ++ name ++ " -e " ++ cmd

termCmd cmd = termCmdWithName cmd cmd

myBinDir = "/home/dmedvinsky/bin/"
myBin = (++) myBinDir
-- }}}

-- vim: fdm=marker
