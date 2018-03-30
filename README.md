Gamepad - a World of Warcraft (1.12.1) AddOn
===================================================

Installation:

Put "Gamepad" folder into ".../World of Warcraft/Interface/AddOns/".
Create AddOns folder if necessary

After Installation directory tree should look like the following

<pre>
World of Warcraft
  `- Interface
     `- AddOns
    	`- Gamepad
           |-- Bindings.xml
           |-- Gamepad.toc
           |-- Global.lua
           |-- Main.lua
           |-- README.md
           |-- UI.lua
           `-- locale
               |-- Locale.lua
               |-- LocaleTable.lua
               `-- enUS.lua

</pre>

Features:
- Simplifies using abilities when using gamepad
- Adds 3 hotkeys (Previous, Use, Next)

To-Do:
- make configuration easier than editing `Main.lua` file

Requirements:
- You must map your controller first to keyboard keys (you can use [JoyToKey](https://joytokey.net/en/) for this).
