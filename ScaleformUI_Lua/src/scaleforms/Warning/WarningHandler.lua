WarningInstance = setmetatable({}, WarningInstance)
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

---Creates a new WarningInstance instance
---@return WarningInstance
function WarningInstance.New()
    local data = {
        _sc = nil --[[@type Scaleform]],
        _disableControls = false,
        _buttonList = {},
        OnButtonPressed = function(button)
        end
    }
    return setmetatable(data, WarningInstance)
end

---Returns whether the warning is currently showing
---@return boolean
function WarningInstance:IsShowing()
    return self._sc ~= nil
end

---Loads the warning scaleform
---@return promise
function WarningInstance:Load()
    local p = promise.new()

    if self._sc ~= nil then
        p:resolve()
        return p
    end

    self._sc = Scaleform.Request("POPUP_WARNING")

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
    self._sc:CallFunction("HIDE_POPUP_WARNING", false, 1000)
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
function WarningInstance:ShowWarning(title, subtitle, prompt, errorMsg, warningType)
    self:Load():next(function()
        if warningType == nil then warningType = 0 end
        self._sc:CallFunction("SHOW_POPUP_WARNING", false, 1000, title, subtitle, prompt, true, warningType, errorMsg)
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
function WarningInstance:UpdateWarning(title, subtitle, prompt, errorMsg, warningType)
    self:Load():next(function()
        if warningType == nil then warningType = 0 end
        self._sc:CallFunction("SHOW_POPUP_WARNING", false, 1000, title, subtitle, prompt, true, warningType, errorMsg)
    end, function(value)
        print("Error loading warning: " .. value)
    end)
end

---Shows the warning with the given title, subtitle, prompt, error message, warning type and buttons
---@param title string
---@param subtitle string
---@param prompt string
---@param buttons table<InstructionalButton>
---@param errorMsg string
---@param warningType number
function WarningInstance:ShowWarningWithButtons(title, subtitle, prompt, buttons, errorMsg, warningType)
    self:Load():next(function()
        if warningType == nil then warningType = 0 end
        self._disableControls = true
        self._buttonList = buttons
        if buttons == nil or #buttons == 0 then return end
        ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self._buttonList)
        ScaleformUI.Scaleforms.InstructionalButtons.UseMouseButtons = true
        self._sc:CallFunction("SHOW_POPUP_WARNING", false, 1000, title, subtitle, prompt, true, warningType, errorMsg)
        ScaleformUI.Scaleforms.InstructionalButtons:Enabled(true)
    end, function(value)
        print("Error loading warning: " .. value)
    end)
end

---Draws the warning
function WarningInstance:Update()
    if self._sc == nil then return end
    if not self._sc:IsLoaded() then return end

    self._sc:Render2D()
    if self._disableControls then
        ScaleformUI.Scaleforms.InstructionalButtons:Draw()
        for k, v in pairs(self._buttonList) do
            if IsControlJustPressed(1, v.GamepadButton) or IsControlJustPressed(1, v.KeyboardButton) then
                self.OnButtonPressed(v)
                self:Dispose()
                ScaleformUI.Scaleforms.InstructionalButtons:Enabled(false)
                ScaleformUI.Scaleforms.InstructionalButtons.UseMouseButtons = false
            end
        end
    end
end
