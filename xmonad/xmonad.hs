-- An example, simple ~/.xmonad/xmonad.hs file.
-- It overrides a few basic settings, reusing all the other defaults.
--

import XMonad

main = xmonad $ def
   { borderWidth        = 2
   , terminal           = "alacritty"
   , normalBorderColor  = "#cccccc"
   , focusedBorderColor = "#cd8b00" }
