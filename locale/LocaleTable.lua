local _G = getfenv();
local Gamepad = _G.Gamepad;

local LocaleTable = {};

function LocaleTable:new(defaultLocale)
    local localeTable = {
        DEFAULT = defaultLocale,
    };

    setmetatable(localeTable, {
        __index = function (self, key)
            return self.DEFAULT;
        end,
    });

    return localeTable;
end

Gamepad.LocaleTable = LocaleTable;