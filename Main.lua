local _G = getfenv()
local Gamepad = _G.Gamepad
local L = Gamepad.Locales[_G.GetLocale()].Strings

_G.BINDING_HEADER_GAMEPAD_HEADER = L['Gamepad']
_G.BINDING_NAME_GAMEPAD_BUTTON1 = L['Use Action']
_G.BINDING_NAME_GAMEPAD_BUTTON2 = L['Previous Action']
_G.BINDING_NAME_GAMEPAD_BUTTON3 = L['Next Action']

Gamepad.actions = {
	{
		['shapeshiftID'] = {[1] = 76}, -- cheap shot
		['defaultActionID'] = 4, -- kidney shot
	}, 28, 29, 30,
	31, 33, 25, 
	43, 47
}
--[[
/script ChatFrame1:AddMessage(GetBonusBarOffset())
/run local l = 0;for l = 1, 120 do local t = GetActionText(l);local x = GetActionTexture(l);if x then local m = "Slot " .. l .. ": [" .. x .. "]";if t then m = m .. " \"" .. t .. "\"";end DEFAULT_CHAT_FRAME:AddMessage(m);end end
]]
Gamepad.currentAction = nil
Gamepad.currentActionID = nil
Gamepad.actionsLength = getn(Gamepad.actions)

function Gamepad.UpdateActionID()
	if type(Gamepad.actions[Gamepad.currentAction]) == 'table' then
		for shapeshiftID, actionID in ipairs(Gamepad.actions[Gamepad.currentAction].shapeshiftID) do
			if Gamepad.shapeshift[shapeshiftID] then
				Gamepad.currentActionID = actionID
				return
			end
		end
		Gamepad.currentActionID = Gamepad.actions[Gamepad.currentAction].defaultActionID
	else
		Gamepad.currentActionID = Gamepad.actions[Gamepad.currentAction]
	end
end

Gamepad.shapeshiftNum = GetNumShapeshiftForms()
Gamepad.shapeshift = {}

function Gamepad.UpdateShapeshift()
	Gamepad.shapeshift = {}
	local icon, name, active
	for i = 1, Gamepad.shapeshiftNum, 1 do
		icon, name, active = GetShapeshiftFormInfo(i)
		Gamepad.shapeshift[i] = active
	end
end

local frame = CreateFrame('Frame')
Gamepad.frame = frame

frame:SetScript('OnEvent', function()
	this[event](this)
end)

frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('ACTIONBAR_SLOT_CHANGED')
frame:RegisterEvent('ACTIONBAR_PAGE_CHANGED')
frame:RegisterEvent('UPDATE_BONUS_ACTIONBAR')
frame:RegisterEvent('PLAYER_TARGET_CHANGED')
frame:RegisterEvent('PLAYER_AURAS_CHANGED')
frame:RegisterEvent('PLAYER_ENTER_COMBAT')
frame:RegisterEvent('PLAYER_LEAVE_COMBAT')
frame:RegisterEvent('START_AUTOREPEAT_SPELL')
frame:RegisterEvent('STOP_AUTOREPEAT_SPELL')
frame:RegisterEvent('ACTIONBAR_UPDATE_USABLE')
frame:RegisterEvent('UPDATE_INVENTORY_ALERTS')
frame:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
frame:RegisterEvent('ACTIONBAR_UPDATE_STATE')

frame:RegisterEvent('CRAFT_SHOW')
frame:RegisterEvent('CRAFT_CLOSE')
frame:RegisterEvent('TRADE_SKILL_SHOW')
frame:RegisterEvent('TRADE_SKILL_CLOSE')

function frame:ADDON_LOADED()
	if arg1 ~= 'Gamepad' then
		return
	end
	
	Gamepad.UpdateShapeshift()
	Gamepad.UI.Load()
end

function frame:ACTIONBAR_SLOT_CHANGED()
	Gamepad.UI.UpdateActionButton()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:ACTIONBAR_PAGE_CHANGED()
	Gamepad.UI.UpdateActionButton()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:UPDATE_BONUS_ACTIONBAR()
	Gamepad.UI.UpdateActionButton()
	Gamepad.UI.UpdateActionButtonState()
end

function frame:PLAYER_TARGET_CHANGED()
	Gamepad.UI.UpdateActionButtoUsable()
end
function frame:PLAYER_AURAS_CHANGED()
	Gamepad.UpdateShapeshift()
	Gamepad.UpdateActionID()
	Gamepad.UI.UpdateActionButtoUsable()
end


function frame:ACTIONBAR_UPDATE_USABLE()
	Gamepad.UI.UpdateActionButtoUsable()
	Gamepad.UI.UpdateActionButtonCooldown()
end
function frame:UPDATE_INVENTORY_ALERTS()
	Gamepad.UI.UpdateActionButtoUsable()
	Gamepad.UI.UpdateActionButtonCooldown()
end
function frame:ACTIONBAR_UPDATE_COOLDOWN()
	Gamepad.UI.UpdateActionButtoUsable()
	Gamepad.UI.UpdateActionButtonCooldown()
end

function frame:ACTIONBAR_UPDATE_STATE()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:CRAFT_SHOW()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:CRAFT_CLOSE()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:TRADE_SKILL_SHOW()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:TRADE_SKILL_CLOSE()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:PLAYER_ENTER_COMBAT()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:PLAYER_LEAVE_COMBAT()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:START_AUTOREPEAT_SPELL()
	Gamepad.UI.UpdateActionButtonState()
end
function frame:STOP_AUTOREPEAT_SPELL()
	Gamepad.UI.UpdateActionButtonState()
end
