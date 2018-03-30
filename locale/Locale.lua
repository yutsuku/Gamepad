local _G = getfenv();
local Gamepad = _G.Gamepad;

local Locale = {};

function Locale:new()
    local locale = {
        Strings = {},
    };

    setmetatable(locale.Strings, {
        __index = function (self, str)
            return str;
        end,
    });

    return locale;
end

Gamepad.Locale = Locale;