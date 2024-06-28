Controls = setmetatable({
    NecessaryControlsKeyboard = {
        201, -- FrontendAccept
        195, -- FrontendAxisX
        196, -- FrontendAxisY
        187, -- FrontendDown
        188, -- FrontendUp
        189, -- FrontendLeft
        190, -- FrontendRight
        202, -- FrontendCancel
        217, -- FrontendSelect
        242, -- CursorScrollDown
        241, -- CursorScrollUp
        239, -- CursorX
        240, -- CursorY
        237, -- CursorAccept
        238, -- CursorCancel
        31,  -- MoveUpDown
        30,  -- MoveLeftRight
        21,  -- Sprint
        22,  -- Jump
        23,  -- Enter
        75,  -- VehicleExit
        71,  -- VehicleAccelerate
        72,  -- VehicleBrake
        59,  -- VehicleMoveLeftRight
        89,  -- VehicleFlyYawLeft
        9,   -- FlyLeftRight
        8,   -- FlyUpDown
        90,  -- VehicleFlyYawRight
        76   -- VehicleHandbrake
    },

    NecessaryControlsGamePad = {
        201, -- FrontendAccept
        195, -- FrontendAxisX
        196, -- FrontendAxisY
        187, -- FrontendDown
        188, -- FrontendUp
        189, -- FrontendLeft
        190, -- FrontendRight
        202, -- FrontendCancel
        217, -- FrontendSelect
        242, -- CursorScrollDown
        241, -- CursorScrollUp
        239, -- CursorX
        240, -- CursorY
        237, -- CursorAccept
        238, -- CursorCancel
        31,  -- MoveUpDown
        30,  -- MoveLeftRight
        21,  -- Sprint
        22,  -- Jump
        23,  -- Enter
        75,  -- VehicleExit
        71,  -- VehicleAccelerate
        72,  -- VehicleBrake
        59,  -- VehicleMoveLeftRight
        89,  -- VehicleFlyYawLeft
        9,   -- FlyLeftRight
        8,   -- FlyUpDown
        90,  -- VehicleFlyYawRight
        76,  -- VehicleHandbrake
        2,   -- LookUpDown
        1,   -- LookLeftRight
        25,  -- Aim
        24,  -- Attack
        71,  -- VehicleAccelerate
        72,  -- VehicleBrake
        59,  -- VehicleMoveLeftRight
        31,  -- MoveUpDown
        30,  -- MoveLeftRight
        75,  -- VehicleExit
    }
}, Controls)

---@comment Toggles all controls or only the ones used for the menu
---@param toggle boolean
function Controls:ToggleAll(toggle)
    if toggle then
        EnableAllControlActions(0)
        EnableAllControlActions(1)
        EnableAllControlActions(2)
    else
        DisableAllControlActions(2)

        local list = {}
        if IsUsingKeyboard(2) then
            list = self.NecessaryControlsKeyboard
        else
            list = self.NecessaryControlsGamePad
        end
        for _, control in pairs(list) do
            EnableControlAction(0, control, true)
        end
    end
end
