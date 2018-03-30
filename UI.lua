local _G = getfenv()
local Gamepad = _G.Gamepad
local L = Gamepad.Locales[_G.GetLocale()].Strings

local UI = CreateFrame('Frame', 'GamepadFrame', _G.UIParent)
Gamepad.UI = UI

UI:SetPoint('CENTER', 0, 0)
UI:SetWidth(64+64+16)
UI:SetHeight(64)
UI:SetBackdrop({
	bgFile=[[Interface\Glues\Common\Glue-Tooltip-Background]],
	edgeFile=[[Interface\Glues\Common\Glue-Tooltip-Border]],
	tile = false,
	tileSize = 64,
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 6, bottom = 8 }
})

UI:SetMovable(true)
UI:SetClampedToScreen(true)
UI:EnableMouse(true)
UI:RegisterForDrag('LeftButton')

UI:SetScript('OnDragStart', function()
	this:StartMoving()
end)
UI:SetScript('OnDragStop', function()
	this:StopMovingOrSizing()
end)

do
	local button_action = CreateFrame('CheckButton', 'GamepadActionButton', UI, 'ActionButtonTemplate')
	UI.button_action = button_action
	button_action:SetPoint('CENTER', 2, 1)
	button_action.icon = _G[button_action:GetName()..'Icon']
	button_action.cooldown = _G[button_action:GetName()..'Cooldown']
	button_action.macroName = _G[button_action:GetName()..'Name']
	button_action.normalTexture = _G[button_action:GetName()..'NormalTexture']
	button_action.hotKey = _G[button_action:GetName()..'HotKey']
	button_action.count = _G[button_action:GetName()..'Count']
	
	button_action:SetScript('OnClick', function()
		UseAction(Gamepad.currentActionID, 0)
	end)	
	button_action:SetScript('OnEnter', function()
		GameTooltip:SetOwner(this, 'ANCHOR_RIGHT')
		GameTooltip:SetAction(Gamepad.currentActionID)
	end)	
	button_action:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)
end

do
	local button_previous = CreateFrame('Button', nil, UI, 'UIPanelButtonTemplate')
	UI.button_previous = button_previous
	button_previous:SetPoint('RIGHT', UI.button_action, 'LEFT', -5, 0)
	button_previous:SetText('<')
	button_previous:SetWidth(36)
	button_previous:SetHeight(36)
	
	button_previous:SetScript('OnClick', function()
		UI.SetActionButton(-1)
	end)
end


do
	local button_next = CreateFrame('Button', nil, UI, 'UIPanelButtonTemplate')
	UI.button_next = button_next
	button_next:SetPoint('LEFT', UI.button_action, 'RIGHT', 5, 0)
	button_next:SetText('>')
	button_next:SetWidth(36)
	button_next:SetHeight(36)
	
	button_next:SetScript('OnClick', function()
		UI.SetActionButton(1)
	end)
end

function UI.Load()
	UI.SetActionButton()
end

function UI.UpdateActionButton()
	local texture = GetActionTexture(Gamepad.currentActionID)
	
	if ( texture ) then
		UI.button_action.icon:SetTexture(texture)
		UI.button_action.icon:Show()
	else
		UI.button_action.icon:Hide()
	end
	
	UI.button_action.macroName:SetText(GetActionText(Gamepad.currentActionID))
	UI.button_action.hotKey:SetText(Gamepad.currentActionID)
end

function UI.UpdateActionButtonState()
	if ( IsCurrentAction(Gamepad.currentActionID) or IsAutoRepeatAction(Gamepad.currentActionID) ) then
		UI.button_action:SetChecked(1)
	else
		UI.button_action:SetChecked(0)
	end
end

function UI.UpdateActionButtonCooldown()
	local start, duration, enable = GetActionCooldown(Gamepad.currentActionID)
	CooldownFrame_SetTimer(UI.button_action.cooldown, start, duration, enable)
end

function UI.UpdateActionButtoUsable()
	local isUsable, notEnoughMana = IsUsableAction(Gamepad.currentActionID)
	
	if isUsable then
		UI.button_action.icon:SetVertexColor(1.0, 1.0, 1.0)
		UI.button_action.normalTexture:SetVertexColor(1.0, 1.0, 1.0)
	elseif notEnoughMana then
		UI.button_action.icon:SetVertexColor(0.5, 0.5, 1.0)
		UI.button_action.normalTexture:SetVertexColor(0.5, 0.5, 1.0)
	else
		UI.button_action.icon:SetVertexColor(0.4, 0.4, 0.4)
		UI.button_action.normalTexture:SetVertexColor(1.0, 1.0, 1.0)
	end
end

function UI.UpdateActionButtoCount()
	if IsConsumableAction(Gamepad.currentActionID) then
		UI.button_action.count:SetText(GetActionCount(ActionButton_GetPagedID(this)))
	else
		UI.button_action.count:SetText('')
	end
end

function UI.SetActionButton(direction)
	if direction == 1 then
		if Gamepad.currentAction == Gamepad.actionsLength then
			Gamepad.currentAction = 1
		else
			Gamepad.currentAction = Gamepad.currentAction + 1
		end
	elseif direction == -1 then
		if Gamepad.currentAction == 1 then
			Gamepad.currentAction = Gamepad.actionsLength
		else
			Gamepad.currentAction = Gamepad.currentAction - 1
		end
	else
		Gamepad.currentAction = 1
	end
	Gamepad.UpdateActionID()
	
	UI.UpdateActionButton()
	UI.UpdateActionButtoCount()
	UI.UpdateActionButtoUsable()
	UI.UpdateActionButtonCooldown()
end