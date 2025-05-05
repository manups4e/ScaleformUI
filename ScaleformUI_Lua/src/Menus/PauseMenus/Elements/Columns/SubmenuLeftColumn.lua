SubmenuLeftColumn = {}
SubmenuLeftColumn.__index = SubmenuLeftColumn
setmetatable(SubmenuLeftColumn, { __index = PM_Column })
SubmenuLeftColumn.__call = function() return "SubmenuLeftColumn" end

function SubmenuLeftColumn.New(pos)
    local col = PM_Column.New(pos)
    col.VisibleItems = 10
    return setmetatable(col, SubmenuLeftColumn)
end

function SubmenuLeftColumn:currentItemType()
    return self.Items[self:Index()].ItemType
end

function SubmenuLeftColumn:CurrentItem()
    return self.Items[self:Index()]
end

function SubmenuLeftColumn:AddItem(item)
    item.ParentColumn = self
    table.insert(self.Items, item)
end

function SubmenuLeftColumn:SetDataSlot(index)
    if index > #self.Items then return end
    local item = self.Items[index]
    BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(self.position)
    PushScaleformMovieFunctionParameterInt(index - 1)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterBool(item:Enabled())
    BeginTextCommandScaleformString("CELL_EMAIL_BCON")
    AddTextComponentScaleform(item:Label())
    EndTextCommandScaleformString_2()
    PushScaleformMovieFunctionParameterBool(false)
    PushScaleformMovieFunctionParameterInt(item.MainColor:ToArgb())
    PushScaleformMovieFunctionParameterInt(item.HighlightColor:ToArgb())
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieMethodParameterString(ScaleformFonts.CHALET_LONDON_NINETEENSIXTY.FontName)
    PushScaleformMovieMethodParameterString(ScaleformFonts.CHALET_LONDON_NINETEENSIXTY.FontName)
    EndScaleformMovieMethod()
end

function SubmenuLeftColumn:UpdateSlot(index)
    if index > #self.Items then return end
    local item = self.Items[index]
    BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "UPDATE_SLOT")
    PushScaleformMovieFunctionParameterInt(self.position)
    PushScaleformMovieFunctionParameterInt(index - 1)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterBool(item:Enabled())
    BeginTextCommandScaleformString("CELL_EMAIL_BCON")
    AddTextComponentScaleform(item:Label())
    EndTextCommandScaleformString_2()
    PushScaleformMovieFunctionParameterBool(false)
    PushScaleformMovieFunctionParameterInt(item.MainColor:ToArgb())
    PushScaleformMovieFunctionParameterInt(item.HighlightColor:ToArgb())
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieMethodParameterString(ScaleformFonts.CHALET_LONDON_NINETEENSIXTY.FontName)
    PushScaleformMovieMethodParameterString(ScaleformFonts.CHALET_LONDON_NINETEENSIXTY.FontName)
    EndScaleformMovieMethod()
end

function SubmenuLeftColumn:GoUp()
    self.Items[self:Index()]:Selected(false)
    self.index = self.index-1
    if self.index < 1 then
        self.index = #self.Items
    end
    self.Items[self:Index()]:Selected(true)
    self.Parent.CenterColumn:Clear()
    if self:currentItemType() ~= LeftItemType.Empty then
        for k,v in ipairs(self.Items[self:Index()].ItemList) do
            self.Parent.CenterColumn:AddItem(v)
        end
    end
    if self.Parent ~= null and self.Parent.Visible and self.Parent.Parent ~= null and self.Parent.Parent:Visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("MENU_STATE", currentItemType);
    end
end

function SubmenuLeftColumn:GoDown()
    self.Items[self:Index()]:Selected(false)
    self.index = self.index+1
    if self.index > #self.Items then
        self.index = 1
    end
    self.Items[self:Index()]:Selected(true)
    self.Parent.CenterColumn:Clear()
    if self:currentItemType() ~= LeftItemType.Empty then
        for k,v in ipairs(self.Items[self:Index()].ItemList) do
            self.Parent.CenterColumn:AddItem(v)
        end
    end
    if self.Parent ~= null and self.Parent.Visible and self.Parent.Parent ~= null and self.Parent.Parent:Visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("MENU_STATE", currentItemType);
    end
end