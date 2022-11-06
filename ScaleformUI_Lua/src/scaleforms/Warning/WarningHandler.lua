WarningInstance = {}

local warn = {}
warn = setmetatable({}, warn)

warn.__call = function()
    return true
end
warn.__index = warn

function WarningInstance.New()
    local data = {
        _sc = 0,
        _disableControls = false,
        _buttonList = {},
        OnButtonPressed = function(button)
        end
    }
    return setmetatable(data, warn)
end

function warn:IsShowing()
    return self._sc ~= 0
end

function warn:Load()
    if self._sc ~= 0 then return end
    self._sc = Scaleform.Request("POPUP_WARNING")
    local timeout = 1000
    local start = GetGameTimer()
    while not self._sc:IsLoaded() and GetGameTimer() - start < timeout do Citizen.Wait(0) end
end

function warn:Dispose()
    if self._sc == 0 then return end
    self._sc:CallFunction("HIDE_POPUP_WARNING", false, 1000)
    self._sc:Dispose()
    self._sc = 0
    self._disableControls = false
end

function warn:ShowWarning(title, subtitle, prompt, errorMsg, warningType)
    self:Load()
    self._sc:CallFunction("SHOW_POPUP_WARNING", false, 1000, title, subtitle, prompt, true, warningType, errorMsg)
end

function warn:UpdateWarning(title, subtitle, prompt, errorMsg, warningType)
    self._sc:CallFunction("SHOW_POPUP_WARNING", false, 1000, title, subtitle, prompt, true, warningType, errorMsg)
end

function warn:ShowWarningWithButtons(title, subtitle, prompt, buttons, errorMsg, warningType)
    self:Load()
    self._disableControls = true
    self._buttonList = buttons
    if buttons == nil or #buttons == 0 then return end
    ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self._buttonList)
    ScaleformUI.Scaleforms.InstructionalButtons.UseMouseButtons = true
    self._sc:CallFunction("SHOW_POPUP_WARNING", false, 1000, title, subtitle, prompt, true, warningType, errorMsg)
    ScaleformUI.Scaleforms.InstructionalButtons:Enabled(true)
end

function warn:Update()
    self._sc:Render2D()
    if self._disableControls then
        ScaleformUI.Scaleforms.InstructionalButtons:Draw()
        for k,v in pairs(self._buttonList) do
            if IsControlJustPressed(1, v.GamepadButton) or IsControlJustPressed(1, v.KeyboardButton) then
                self.OnButtonPressed(v)
                self:Dispose()
                ScaleformUI.Scaleforms.InstructionalButtons:Enabled(false)
                ScaleformUI.Scaleforms.InstructionalButtons.UseMouseButtons = false
            end
        end
    end
end