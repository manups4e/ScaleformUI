PM_Column = {}

function PM_Column.New(pos)
    local data = {
        position = pos or -1,
        index = 1,
        type = -1, -- used in PlayerListTab :3
        columnVisible = true,
        Items = {},
        VisibleItems = 16, -- defaults
        Focused = false,
        CaptionLeft = "",
        CaptionRight = "",
        Label = "",
        Color = SColor.HUD_Freemode,
        Parent = nil -- BaseTab inherited tabs
    }
    return setmetatable(data, PM_Column)
end

function PM_Column:visible()
    return self.Parent ~= nil and self.Parent.Visible and self.Parent.Parent ~= nil and self.Parent.Parent:Visible()
end

function PM_Column:CurrentItem()
    return self.Items[self.index]
end

function PM_Column:Index(idx)
    if idx == nil then
        return self.index
    else
        if #self.Items == 0 then return end
        self.Items[self.index]:Selected(false)
        if idx > #self.Items then
            idx = 1
        elseif idx < 1 then
            idx = #self.Items
        end
        self.index = idx
        self.Items[self.index]:Selected(true)
        if self:visible() and self.Parent.CurrentColumnIndex == self.position then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position, self.index - 1, false, false)
        end
    end
end

function PM_Column:ColumnVisible(bool)
    if bool == nil then
        return self.columnVisible
    else
        self.columnVisible = bool
        if self:visible() then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SHOW_COLUMN", self.position, self.columnVisible)
        end
    end
end

function PM_Column:AddItem(item)
    table.insert(self.Items, item)
end

function PM_Column:Clear()
    self:ClearColumn()
end

function PM_Column:ClearColumn()
    self.Items = {}
    self.index = 1
    if self:visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", self.position)
    end
end

function PM_Column:Populate() end

function PM_Column:SetDataSlot(index) end

function PM_Column:UpdateSlot(index) end

function PM_Column:AddSlot(index) end

function PM_Column:RemoveSlot(idx)
    if idx > #self.Items then return end
    self.Items[idx]:Selected(false)
    local curItem = self.index
    table.remove(self.Items, idx)
    if self:visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("REMOVE_SLOT", self.position, idx - 1)
    end
    if #self.Items > 0 then
        if idx == self.index then
            if idx > #self.Items then
                self.index = #self.Items
            elseif idx > 1 and idx <= #self.Items then
                self.index = idx
            else
                self.index = 1
            end
        else
            if curItem <= #self.Items then
                self.index = curItem
            else
                self.index = #self.Items
            end
        end
        self.Items[self.index]:Selected(true)
        if self:visible() and self.Parent.CurrentColumnIndex == self.position then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.index - 1, false, false)
        end
    end
end

function PM_Column:GoUp() end

function PM_Column:GoDown() end

function PM_Column:GoLeft() end

function PM_Column:GoRight() end

function PM_Column:Select() end

function PM_Column:GoBack() end

function PM_Column:MouseScroll(dir) end

function PM_Column:HighlightColumn(highlighted, moveFocus, prevHighlight)
    if highlighted == nil then highlighted = false end
    if moveFocus == nil then moveFocus = false end
    if prevHighlight == nil then prevHighlight = false end
    if self:visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", self.position, highlighted, moveFocus,
            prevHighlight)
    end
end

function PM_Column:ShowColumn()
    if self:visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("DISPLAY_DATA_SLOT", self.position)
    end
end

function PM_Column:InitColumnScroll(visible, columns, scrollType, arrowPosition, override, xColOffset)
    if override == nil then override = false end
    if xColOffset == nil then xColOffset = 0.0 end
    if self:visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("INIT_COLUMN_SCROLL", self.position, visible, columns,
            scrollType, arrowPosition, override, xColOffset)
    end
end

function PM_Column:SetColumnScroll(...)
    if not self:visible() then return end
    if select(1, ...) ~= nil and select(2, ...) ~= nil and select(3, ...) ~= nil and select(4, ...) ~= nil and select(5, ...) ~= nil then
        local currentPosition, maxPosition, maxVisible, caption, forceInvisible, captionR = ...
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_SCROLL", self.position, currentPosition,
            maxPosition, maxVisible, caption, forceInvisible, captionR or "")
            return
    elseif select(1, ...) ~= nil and type(select(1, ...)) == "number" and select(2, ...) ~= nil and type(select(2, ...)) == "number" and select(3, ...) ~= nil and type(select(3, ...)) == "number" then
        local currentPosition, maxPosition, maxVisible = ...
        maxVisible = maxVisible or -1
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_SCROLL", self.position, currentPosition, maxPosition, maxVisible)
        return
    elseif select(1, ...) ~= nil and type(select(1, ...)) == "string" and select(2, ...) ~= nil and type(select(2, ...)) == "string" then
        local caption, rightC = select(1, ...), select(2, ...)
        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_SCROLL")
        ScaleformMovieMethodAddParamInt(position)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        BeginTextCommandScaleformString("CELL_EMAIL_BCON")
        AddTextComponentSubstringPlayerName(caption)
        EndTextCommandScaleformString_2()
        ScaleformMovieMethodAddParamBool(false)
        ScaleformMovieMethodAddParamPlayerNameString(rightC)
        EndScaleformMovieMethod()
        return
    else
        local caption = select(1, ...)
        if type(caption) == "string" then
            BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_COLUMN_SCROLL")
            ScaleformMovieMethodAddParamInt(position)
            ScaleformMovieMethodAddParamInt(0)
            ScaleformMovieMethodAddParamInt(0)
            ScaleformMovieMethodAddParamInt(0)
            BeginTextCommandScaleformString(caption)
            
            -- Process remaining arguments
            local args = {...}
            for i = 2, #args do
                local arg = args[i]
                local argType = type(arg)
                if argType == "number" then
                    if math.type(arg) == "integer" then
                        AddTextComponentInteger(arg)
                    else
                        AddTextComponentFloat(arg, 2)
                    end
                elseif argType == "string" then
                    AddTextComponentSubstringPlayerName(arg)
                end
            end
            
            EndTextCommandScaleformString_2()
            EndScaleformMovieMethod()
        end
    end
end