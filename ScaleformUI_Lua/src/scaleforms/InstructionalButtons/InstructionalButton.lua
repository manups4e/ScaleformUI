InstructionalButton = {}

local button = {}
button = setmetatable({}, button)

button.__call = function()
    return true
end
button.__index = button

function InstructionalButton.New(text, padcheck, gamepadControls, keyboardControls, inputGroup)
    local _button = {
        Text = text or "",
        GamepadButtons = nil,
        GamepadButton = -1,
        KeyboardButtons = nil,
        KeyboardButton = -1,
        PadCheck = padcheck or -1
    }
    
    if type(gamepadControls) == "table" then
        if padcheck == 0 or padcheck == -1 then
            _button.GamepadButtons = gamepadControls
        end
    else
        if padcheck == 0 or padcheck == -1 then
            _button.GamepadButton = gamepadControls
        else 
            _button.GamepadButton= -1
        end
    end
    if type(keyboardControls) == "table" then
        if padcheck == 1 or padcheck == -1 then
            _button.KeyboardButtons = keyboardControls
        end
    else
        if padcheck == 1 or padcheck == -1 then
            _button.KeyboardButton = keyboardControls 
        else
            _button.KeyboardButton = -1
        end
    end
    _button.InputGroupButton = inputGroup or -1
    
    return setmetatable(_button, button)
end

function button:IsUsingController()
    return not IsUsingKeyboard(2)
end

function button:GetButtonId()
    if self.KeyboardButtons ~= nil or self.GamepadButtons ~= nil then
        local retVal = ""
        if self:IsUsingController() then
            if self.GamepadButtons ~= nil then
                for i=#self.GamepadButtons, 1, -1 do
                    if i == 1 then
                        retVal = retVal .. GetControlInstructionalButton(2, self.GamepadButtons[i], 1)
                    else
                        retVal = retVal .. GetControlInstructionalButton(2, self.GamepadButtons[i], 1) .. "%"
                    end
                end
            end
        else
            if self.KeyboardButtons ~= nil then
                for i=#self.KeyboardButtons, 1, -1 do
                    if i == 1 then
                        retVal = retVal .. GetControlInstructionalButton(2, self.KeyboardButtons[i], 1)
                    else
                        retVal = retVal .. GetControlInstructionalButton(2, self.KeyboardButtons[i], 1) .. "%"
                    end
                end
            end
        end
        return retVal
    elseif self.InputGroupButton ~= -1 then 
        return "~"..self.InputGroupButton.."~"
    end
    if self:IsUsingController() then
        return GetControlInstructionalButton(2, self.GamepadButton, 1)
    else
        return GetControlInstructionalButton(2, self.KeyboardButton, 1)
    end
end

