local _G = getfenv()
local Gamepad = _G.Gamepad
local enUS = Gamepad.Locale:new()
local L = enUS.Strings

Gamepad.Locales = Gamepad.Locales or Gamepad.LocaleTable:new(enUS)
Gamepad.Locales['enUS'] = enUS

L['String'] = 'Translation'
