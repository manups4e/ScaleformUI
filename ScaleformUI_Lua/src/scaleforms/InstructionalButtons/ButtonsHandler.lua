ButtonsHandler = {}

local handler = {}
handler = setmetatable({}, handler)

handler.__call = function()
    return true
end
handler.__index = handler

function ButtonsHandler.New()
    local data ={
        _sc = 0,
        UseMouseButtons = false,
        _enabled = false,
        IsUsingKeyboard = false,
        _changed = true,
        savingTimer = 0,
        IsSaving = false,
        ControlButtons = {}
    } 
    return setmetatable(data, handler) 
end

function handler:Enabled(bool)
    if bool == nil then
        return self._enabled
    else
        if not bool then
            self._sc:CallFunction("CLEAR_ALL", false)
            self._sc:CallFunction("CLEAR_RENDER", false)
            self._sc:Dispose()
            self._sc=0
        end
        self._enabled = bool
        self._changed = bool
    end
end

function handler:Load()
    if self._sc ~= 0 then return end
    self._sc = Scaleform.Request("INSTRUCTIONAL_BUTTONS")
    local timeout = 1000
    local start = GetGameTimer()
    while not self._sc:IsLoaded() and GetGameTimer() - start < timeout do Citizen.Wait(0) end
end

function handler:SetInstructionalButtons(buttons)
    self.ControlButtons = buttons
    self._changed = true
end

function handler:AddInstructionalButton(button)
    ControlButtons[#ControlButtons + 1] = button
    self._changed = true
end

function handler:RemoveInstructionalButton(button)
    local bt
    for k,v in pairs (self.ControlButtons) do
        if v.Text == button.Text then
            self.ControlButtons[k] = nil
        end
    end
    self._changed = true
end

function handler:ClearButtonList()
    self.ControlButtons = {}
    self._changed = true
end

function handler:ShowBusySpinner(spinnerType, text, time)
    if time == nil or time < 0 then time = 3000 end
    self.IsSaving = true
    self._changed = true
    self.savingTimer = GetGameTimer()

    if text == nil or text == "" then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING")
        AddTextComponentSubstringPlayerName(text)
    end
    EndTextCommandBusyString(spinnerType)
    while GetGameTimer() - self.savingTimer <= time do Citizen.Wait(100) end
    RemoveLoadingPrompt()
    self.IsSaving = false
end

function handler:UpdateButtons()
    if not self._changed then return end
    self._sc:CallFunction("SET_DATA_SLOT_EMPTY", false)
    self._sc:CallFunction("TOGGLE_MOUSE_BUTTONS", false, self.UseMouseButtons)
    local count = 0

    for k, button in pairs (self.ControlButtons) do
        if button:IsUsingController() then
            if button.PadCheck == 0 or button.PadCheck == -1 then
                if ScaleformUI.Scaleforms.Warning:IsShowing() then
                    self._sc:CallFunction("SET_DATA_SLOT", false, count, button:GetButtonId(), button.Text, 0, -1)
                else
                    self._sc:CallFunction("SET_DATA_SLOT", false, count, button:GetButtonId(), button.Text)
                end
            end
        else
            if button.PadCheck == 1 or button.PadCheck == -1 then
                if self.UseMouseButtons then
                    self._sc:CallFunction("SET_DATA_SLOT", false, count, button:GetButtonId(), button.Text, 1, button.KeyboardButton)
                else
                    if ScaleformUI.Scaleforms.Warning:IsShowing() then
                        self._sc:CallFunction("SET_DATA_SLOT", false, count, button:GetButtonId(), button.Text, 0, -1)
                    else
                        self._sc:CallFunction("SET_DATA_SLOT", false, count, button:GetButtonId(), button.Text)
                    end
                end
            end
        end
        count = count + 1
    end
    self._sc:CallFunction("DRAW_INSTRUCTIONAL_BUTTONS", false, -1)
    self._changed = false
end

function handler:Draw()
    self._sc:Render2D()
end

function handler:DrawScreeSpace(x, y)
    self._sc:Render2DNormal(0.5 - x, 0.5 - y, 1, 1)
end

function handler:Update()
    if IsUsingKeyboard(2) then
        if not self.IsUsingKeyboard then
            self.IsUsingKeyboard = true
            self._changed = true
        end
    else
        if self.IsUsingKeyboard then
            self.IsUsingKeyboard = false
            self._changed = true
        end
    end
    self:UpdateButtons()
    if not ScaleformUI.Scaleforms.Warning:IsShowing() then self:Draw() end
    if self.UseMouseButtons then ShowCursorThisFrame() end
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(9)
end