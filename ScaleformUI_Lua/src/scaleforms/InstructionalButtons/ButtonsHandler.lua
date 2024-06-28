ButtonsHandler = setmetatable({
    _sc = nil --[[@type Scaleform]],
    UseMouseButtons = false,
    IsUsingKeyboard = false,
    _changed = true,
    savingTimer = 0,
    IsSaving = false,
    ControlButtons = {}
}, ButtonsHandler)
ButtonsHandler.__index = ButtonsHandler
ButtonsHandler.__call = function()
    return "ButtonsHandler"
end

---@class ButtonsHandler
---@field public _sc Scaleform
---@field public UseMouseButtons boolean
---@field public _enabled boolean
---@field public IsUsingKeyboard boolean
---@field private _changed boolean
---@field private savingTimer number
---@field public IsSaving boolean
---@field public ControlButtons table<string, InstructionalButton>
---@field public Enabled fun(self: table, bool: boolean?): boolean
---@field public Load fun(self: table):nil
---@field public SetInstructionalButtons fun(self: table, buttons: table<InstructionalButton>):nil
---@field public AddInstructionalButton fun(self: table, button: InstructionalButton):nil
---@field public RemoveInstructionalButton fun(self: table, button: InstructionalButton):nil
---@field public ClearButtonList fun(self: table):nil
---@field public Refresh fun(self: table):nil
---@field public ShowBusySpinner fun(self: table, spinnerType: number, text: string, time: number, manualDispose?: boolean):nil
---@field public HideBusySpinner fun(self: table):nil
---@field public UpdateButtons fun(self: table):nil
---@field public Draw fun(self: table):nil
---@field public DrawScreenSpace fun(self: table, x: number, y: number):nil
---@field public DrawScreeSpace fun(self: table, x: number, y: number):nil
---@field public Update fun(self: table):nil

---Loads the instructional buttons
function ButtonsHandler:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("INSTRUCTIONAL_BUTTONS")
    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end
    local width, height = GetActiveScreenResolution()
    self._sc:CallFunction("SET_DISPLAY_CONFIG", 1280, 720, 0.05, 0.95, 0.05, 0.95, true, false, false, width, height)
end

---Sets the instructional buttons
---@param buttons table<InstructionalButton>
function ButtonsHandler:SetInstructionalButtons(buttons)
    self.ControlButtons = buttons
    self._changed = true
end

---Adds a new instructional button
---@param button InstructionalButton
function ButtonsHandler:AddInstructionalButton(button)
    self.ControlButtons[#self.ControlButtons + 1] = button
    self._changed = true
end

---Removes an instructional button
---@param button InstructionalButton
function ButtonsHandler:RemoveInstructionalButton(button)
    local bt
    for k, v in pairs(self.ControlButtons) do
        if v.Text == button.Text then
            self.ControlButtons[k] = nil
        end
    end
    self._changed = true
end

---Removes all instructional buttons
function ButtonsHandler:ClearButtonList()
    self.ControlButtons = {}
    self._changed = true
end

function ButtonsHandler:Refresh()
    self._changed = true
end

---Shows a busy spinner
---@param spinnerType number
---@param text string
---@param time number
function ButtonsHandler:ShowBusySpinner(spinnerType, text, time, manualDispose)
    if time == nil or time < 0 then time = 3000 end
    self.IsSaving = true
    self._changed = true
    self._manualDispose = manualDispose or false
    self.savingTimer = GlobalGameTimer

    if text == nil or text == "" then
        BeginTextCommandBusyspinnerOn("PM_WAIT")
    else
        BeginTextCommandBusyspinnerOn("STRING")
        AddTextComponentSubstringPlayerName(text)
    end
    EndTextCommandBusyspinnerOn(spinnerType)
    if self._manualDispose then return end
    while GlobalGameTimer - self.savingTimer <= time do Citizen.Wait(100) end
    BusyspinnerOff()
    self.IsSaving = false
end

---Hide Busy Spinner
function ButtonsHandler:HideBusySpinner()
    BusyspinnerOff()
    self.IsSaving = false
end

---Updates the instructional buttons
function ButtonsHandler:UpdateButtons()
    if not self._changed then return end
    if self._sc == nil or self.ControlButtons == nil or #self.ControlButtons == 0 then return end

    self._sc:CallFunction("SET_DATA_SLOT_EMPTY")
    self._sc:CallFunction("TOGGLE_MOUSE_BUTTONS", self.UseMouseButtons)
    local count = 0

    for k, button in pairs(self.ControlButtons) do
        if not IsUsingKeyboard(2) then
            if button.PadCheck == 0 or button.PadCheck == -1 then
                if ScaleformUI.Scaleforms.Warning:IsShowing() then
                    self._sc:CallFunction("SET_DATA_SLOT", count, button:GetButtonId(), button.Text, 0, -1)
                else
                    self._sc:CallFunction("SET_DATA_SLOT", count, button:GetButtonId(), button.Text)
                end
            end
        else
            if button.PadCheck == 1 or button.PadCheck == -1 then
                if self.UseMouseButtons then
                    self._sc:CallFunction("SET_DATA_SLOT", count, button:GetButtonId(), button.Text, 1,
                        button.KeyboardButton)
                else
                    if ScaleformUI.Scaleforms.Warning:IsShowing() then
                        self._sc:CallFunction("SET_DATA_SLOT", count, button:GetButtonId(), button.Text, 0,
                            -1)
                    else
                        self._sc:CallFunction("SET_DATA_SLOT", count, button:GetButtonId(), button.Text)
                    end
                end
            end
        end
        count = count + 1
    end
    self._sc:CallFunction("DRAW_INSTRUCTIONAL_BUTTONS", -1)
    self._changed = false
end

---Draws the instructional buttons on the screen
function ButtonsHandler:Draw()
    if self._sc == nil or self.ControlButtons == nil or #self.ControlButtons == 0 then return end
    SetScriptGfxDrawBehindPausemenu(true)
    self._sc:Render2D()
end

---Draws the instructional buttons on the screen with a custom position
function ButtonsHandler:DrawScreenSpace(x, y)
    if self._sc == nil or self.ControlButtons == nil or #self.ControlButtons == 0 then return end
    self._sc:Render2DNormal(0.5 - x, 0.5 - y, 1, 1)
end

---Draws the instructional buttons on the screen with a custom position
---@deprecated Use DrawScreenSpace() instead
function ButtonsHandler:DrawScreeSpace(x, y)
    if self._sc == nil or self.ControlButtons == nil or #self.ControlButtons == 0 then return end
    self._sc:Render2DNormal(0.5 - x, 0.5 - y, 1, 1)
end

---Update tick for the instructional buttons
function ButtonsHandler:Update()
    if (self.ControlButtons == nil or #self.ControlButtons == 0) and not self.IsSaving then return end
    if self._sc == nil then self:Load() end
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
    if self.UseMouseButtons then SetMouseCursorActiveThisFrame() end
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(9)

    for k, v in pairs(self.ControlButtons) do
        if IsUsingKeyboard(2) then
            if IsControlJustPressed(0, v.KeyboardButton) or IsDisabledControlJustPressed(0, v.KeyboardButton) then
                v.OnControlSelected(v)
            end
            if v.KeyboardButtons ~= nil and #v.KeyboardButtons > 0 then
                for i, j in pairs(v.KeyboardButtons) do
                    if IsControlJustPressed(0, j) or IsDisabledControlJustPressed(0, j) then
                        v.OnControlSelected(v)
                    end
                end
            end
        else
            if IsControlJustPressed(0, v.GamepadButton) or IsDisabledControlJustPressed(0, v.GamepadButton) then
                v.OnControlSelected(v)
            end
            if v.GamepadButtons ~= nil and #v.GamepadButtons > 0 then
                for i, j in pairs(v.GamepadButtons) do
                    if IsControlJustPressed(0, j) or IsDisabledControlJustPressed(0, j) then
                        v.OnControlSelected(v)
                    end
                end
            end
        end
    end
end
