InstructionalButton = setmetatable({}, InstructionalButton)
InstructionalButton.__index = InstructionalButton
InstructionalButton.__call = function()
    return "InstructionalButton"
end

---@class InstructionalButton
---@field public Text string
---@field public GamepadButtons number[]
---@field public GamepadButton number
---@field public KeyboardButtons number[]
---@field public KeyboardButton number
---@field public PadCheck number

---Creates a new InstructionalButton object
---@param text string
---@param padcheck number?
---@param gamepadControls number
---@param keyboardControls number
---@param inputGroup string|number?
---@return table
function InstructionalButton.New(text, padcheck, gamepadControls, keyboardControls, inputGroup)
    local _instructionalButton = {
        Text = text or "",
        GamepadButtons = nil,
        GamepadButton = -1,
        KeyboardButtons = nil,
        KeyboardButton = -1,
        PadCheck = padcheck or -1,
        OnControlSelected = function(button) end
    }

    if type(gamepadControls) == "table" then
        if padcheck == 0 or padcheck == -1 then
            _instructionalButton.GamepadButtons = gamepadControls
        end
    else
        if padcheck == 0 or padcheck == -1 then
            _instructionalButton.GamepadButton = gamepadControls
        else
            _instructionalButton.GamepadButton = -1
        end
    end
    if type(keyboardControls) == "table" then
        if padcheck == 1 or padcheck == -1 then
            _instructionalButton.KeyboardButtons = keyboardControls
        end
    else
        if padcheck == 1 or padcheck == -1 then
            _instructionalButton.KeyboardButton = keyboardControls
        else
            _instructionalButton.KeyboardButton = -1
        end
    end
    _instructionalButton.InputGroupButton = inputGroup or -1

    return setmetatable(_instructionalButton, InstructionalButton)
end

---Checks if the player is using a controller
---@return boolean
function InstructionalButton:IsUsingController()
    return not IsUsingKeyboard(2)
end

---Gets the button id for the instructional button
function InstructionalButton:GetButtonId()
    if self.KeyboardButtons ~= nil or self.GamepadButtons ~= nil then
        local retVal = ""
        if self:IsUsingController() then
            if self.GamepadButtons ~= nil then
                for i = #self.GamepadButtons, 1, -1 do
                    if i == 1 then
                        retVal = retVal .. GetControlInstructionalButton(2, self.GamepadButtons[i], true)
                    else
                        retVal = retVal .. GetControlInstructionalButton(2, self.GamepadButtons[i], true) .. "%"
                    end
                end
            end
        else
            if self.KeyboardButtons ~= nil then
                for i = #self.KeyboardButtons, 1, -1 do
                    if i == 1 then
                        retVal = retVal .. GetControlInstructionalButton(2, self.KeyboardButtons[i], true)
                    else
                        retVal = retVal .. GetControlInstructionalButton(2, self.KeyboardButtons[i], true) .. "%"
                    end
                end
            end
        end
        return retVal
    elseif self.InputGroupButton ~= -1 then
        return "~" .. self.InputGroupButton .. "~"
    end
    if self:IsUsingController() then
        return GetControlInstructionalButton(2, self.GamepadButton, true)
    else
        return GetControlInstructionalButton(2, self.KeyboardButton, true)
    end
end
