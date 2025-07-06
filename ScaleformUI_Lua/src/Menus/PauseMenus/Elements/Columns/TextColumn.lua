TextColumn = {}
TextColumn.__index = TextColumn
setmetatable(TextColumn, { __index = PM_Column })
TextColumn.__call = function() return "TextColumn" end

function TextColumn.New(pos)
    local col = PM_Column.New(pos)
    return setmetatable(col, TextColumn)
end

-- function TextColumn:AddItem(item)
--     PM_Column.AddItem(self, item)
-- end

function TextColumn:SetDataSlot(index)
    if index > #self.Items then return end
    local item = self.Items[index]
    local label = "TXT_COL_LBL"
    BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(index - 1)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(index - 1)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterBool(true)
    AddTextEntry(label, item.label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString_2()
    EndScaleformMovieMethod()
end

function TextColumn:UpdateSlot(index)
    if index > #self.Items then return end
    local item = self.Items[index]
    local label = "TXT_COL_LBL"
    BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "UPDATE_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(index - 1)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(index - 1)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterBool(true)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString_2()
    EndScaleformMovieMethod()
end
