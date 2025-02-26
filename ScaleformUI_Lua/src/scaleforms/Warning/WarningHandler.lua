WarningInstance = setmetatable({
    _sc = nil --[[@type Scaleform]],
    _disableControls = false,
    _buttonList = {},
    OnButtonPressed = function(button)
    end
}, WarningInstance)
WarningInstance.__index = WarningInstance
WarningInstance.__call = function()
    return "WarningInstance"
end

---@class WarningInstance
---@field _sc Scaleform
---@field _disableControls boolean
---@field _buttonList table<InstructionalButton>
---@field OnButtonPressed fun(button: InstructionalButton)
---@field public Update fun(self:WarningInstance):nil
---@field public IsShowing fun(self:WarningInstance):boolean

---Returns whether the warning is currently showing
---@return boolean
function WarningInstance:IsShowing()
    return self._sc ~= nil
end

function WarningInstance:IsShowingWithButtons()
    return self._disableControls
end

---Loads the warning scaleform
---@return promise
function WarningInstance:Load()
    local p = promise.new()

    if self._sc ~= nil then
        p:resolve()
        return p
    end

    self._sc = Scaleform.RequestWidescreen("POPUP_WARNING")

    if self._sc == nil then
        p:reject("Error requesting warning scaleform.")
        return p
    end

    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end

    if self._sc:IsLoaded() then
        p:resolve()
    else
        p:reject("Error loading warning scaleform.")
    end

    return p
end

---Disposes the warning scaleform
function WarningInstance:Dispose()
    if self._sc == nil then return end
    self._sc:CallFunction("HIDE_POPUP_WARNING", 1000)
    self._sc:Dispose()
    self._sc = nil
    self._disableControls = false
end

---Shows the warning with the given title, subtitle, prompt, error message and warning type
---@param title string
---@param subtitle string
---@param prompt string
---@param errorMsg string
---@param warningType number
function WarningInstance:ShowWarning(title, subtitle, prompt, errorMsg, warningType, showBackground)
    self:Load():next(function()
        if warningType == nil then warningType = 0 end
        if showBackground == nil then showBackground = true end
        self._sc:CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, showBackground, warningType, errorMsg)
    end, function(value)
        print("Error loading warning: " .. value)
    end)
end

---Updates the warning with the given title, subtitle, prompt, error message and warning type
---@param title string
---@param subtitle string
---@param prompt string
---@param errorMsg string
---@param warningType number
function WarningInstance:UpdateWarning(title, subtitle, prompt, errorMsg, warningType, showBackground)
    if not self:IsShowing() then return end
    if warningType == nil then warningType = 0 end
    if showBackground == nil then showBackground = true end
    self._sc:CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, showBackground, warningType, errorMsg)
end

---Shows the warning with the given title, subtitle, prompt, error message, warning type and buttons
---@param title string
---@param subtitle string
---@param prompt string
---@param buttons table<InstructionalButton>
---@param errorMsg string
---@param warningType number
function WarningInstance:ShowWarningWithButtons(title, subtitle, prompt, buttons, errorMsg, warningType, showBackground)
    self:Load():next(function()
        if warningType == nil then warningType = 0 end
        if showBackground == nil then showBackground = true end
        self._disableControls = true
        self._buttonList = buttons
        if buttons == nil or #buttons == 0 then return end
        ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self._buttonList)
        ScaleformUI.Scaleforms.InstructionalButtons.UseMouseButtons = true
        self._sc:CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, showBackground, warningType, errorMsg)
    end, function(value)
        print("Error loading warning: " .. value)
    end)
end

---Draws the warning
function WarningInstance:Update()
    if self._sc == nil or not self._sc:IsLoaded() then return end

    self._sc:Render2D()
    if self._disableControls then
        ScaleformUI.Scaleforms.InstructionalButtons:Draw()
        for k, v in pairs(self._buttonList) do
            if
                IsControlJustPressed(1, v.GamepadButton) or
                IsControlJustPressed(1, v.KeyboardButton) or
                IsDisabledControlJustPressed(1, v.GamepadButton) or
                IsDisabledControlJustPressed(1, v.KeyboardButton)
            then
                self.OnButtonPressed(v)
                self:Dispose()

                ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
                ScaleformUI.Scaleforms.InstructionalButtons.UseMouseButtons = false
                if MenuHandler._currentMenu ~= nil then
                    if #MenuHandler._currentMenu.InstructionalButtons > 0 then
                        ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(MenuHandler._currentMenu.InstructionalButtons)
                    end
                elseif MenuHandler._currentPauseMenu ~= nil then
                    if #MenuHandler._currentPauseMenu.InstructionalButtons > 0 then
                        ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(MenuHandler._currentPauseMenu.InstructionalButtons)
                    end
                end
            end
        end
    end
end
