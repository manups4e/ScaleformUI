GalleryColumn = {}
GalleryColumn.__index = GalleryColumn
setmetatable(GalleryColumn, { __index = PM_Column })
GalleryColumn.__call = function() return "GalleryColumn" end

function GalleryColumn.New()
    local base = PM_Column.New(0)
    base.VisibleItems = 12
    base.txd = ""
    base.txn = ""
    base.state = 0
    base.titleLabel = ""
    base.dateLabel = ""
    base.locationLabel = ""
    base.trackLabel = ""
    base.labelsVisible = false
    base.CurPage = 1
    base.currentPageIndex = 1
    return setmetatable(base, GalleryColumn)
end

function GalleryColumn:MaxPages()
    return math.ceil(#self.Items / self.VisibleItems)
end

function GalleryColumn:GridIndexFromItemIndex(index)
    return index % 12
end

function GalleryColumn:ShouldNavigateToNewPage(index)
    if #self.Items <= 12 or self:MaxPages() <= 1 then
        return false
    end

    return (self.currentPageIndex == 1 and index == 1) or
        (self.currentPageIndex == 5 and index == 5) or
        (self.currentPageIndex == 9 and index == 9) or
        (self.currentPageIndex == 4 and index == 4) or
        (self.currentPageIndex == 8 and index == 8) or
        (self.currentPageIndex == 12 and index == 12)
end

function GalleryColumn:ShowColumn()
    PM_Column.ShowColumn(self)
    self:InitColumnScroll(true, 2, ScrollType.ALL, ScrollArrowsPosition.RIGHT)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", self.position, self.Focused, false, false)
    self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
        self.labelsVisible)
    self:UpdatePage()
end

function GalleryColumn:AddItem(item)
    table.insert(self.Items, item)
end

function GalleryColumn:Populate()
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", self.position)
    for i = 1, 12 do
        local index = i + ((self.CurPage - 1) * self.VisibleItems)
        if index < #self.Items then
            local item = self.Items[index]
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT", self.position, i - 1, i - 1, 33, 4, 0,
                1, item.Label1, item.Label2, item.TextureDictionary, item.TextureName, 1, false, item.Label3, item
                .Label4)
            if item.Blip ~= nil then
                table.insert(self.Parent.Minimap.MinimapBlips, item.Blip)
            end
        else
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT", self.position, i - 1, i - 1, 33, 0, 0,
                1, "", "", "", "", 1, false, "", "")
        end
    end
    self:ShowColumn()
end

function GalleryColumn:GoUp()
    if self.Parent.Parent:FocusLevel() == 1 then
        local iPotentialIndex = self:Index()
        local iPotentialIndexPerPage = self.currentPageIndex

        if (iPotentialIndexPerPage > 4) then
            iPotentialIndex = iPotentialIndex - 4
            iPotentialIndexPerPage = iPotentialIndexPerPage - 4
        else
            iPotentialIndex = iPotentialIndex + 8
            iPotentialIndexPerPage = iPotentialIndexPerPage + 8
        end

        if (iPotentialIndex > #self.Items) then return end

        self.index = iPotentialIndex
        self.currentPageIndex = iPotentialIndexPerPage

        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
            self.currentPageIndex - 1, true,
            true)
        self.Parent.OnGalleryIndexChanged(self.Parent, self.Items[self.index], self.index, self.currentPageIndex)
    end
end

function GalleryColumn:GoDown()
    if self.Parent.Parent:FocusLevel() == 1 then
        local iPotentialIndex = self:Index()
        local iPotentialIndexPerPage = self.currentPageIndex

        if (iPotentialIndexPerPage < 9) then
            iPotentialIndex = iPotentialIndex + 4
            iPotentialIndexPerPage = iPotentialIndexPerPage + 4
        else
            iPotentialIndex = iPotentialIndex - 8
            iPotentialIndexPerPage = iPotentialIndexPerPage - 8
        end

        if (iPotentialIndex > #self.Items) then return end

        self.index = iPotentialIndex
        self.currentPageIndex = iPotentialIndexPerPage

        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
            self.currentPageIndex - 1, true,
            true)
        self.Parent.OnGalleryIndexChanged(self.Parent, self.Items[self.index], self.index, self.currentPageIndex)
    end
end

function GalleryColumn:GoLeft()
    local iPotentialIndex = self:Index()
    local iPotentialIndexPerPage = self.currentPageIndex
    if iPotentialIndex == 1 then
        self.index = #self.Items
        self.currentPageIndex = self.index % 12 - 1
        self.CurPage = self:MaxPages()
        if self:MaxPages() > 1 then
            self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
                self.labelsVisible)
            self:Populate()
        end
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
            self.currentPageIndex - 1, true,
            true)
    else
        if (self.currentPageIndex - 1) % 4 > 0 or self:MaxPages() <= 1 or (self.Parent.bigPic and self.index > 0) then
            iPotentialIndex = iPotentialIndex - 1
            iPotentialIndexPerPage = iPotentialIndexPerPage - 1
        end

        if self:ShouldNavigateToNewPage(iPotentialIndexPerPage) then
            if self.CurPage > 1 then
                self.CurPage = self.CurPage - 1
            else
                self.CurPage = self:MaxPages()
            end

            self.index = (((self.CurPage - 1) * self.VisibleItems) + 1) + 3
            self.currentPageIndex = iPotentialIndexPerPage + 3
            if self.index >= #self.Items or self.CurPage == self:MaxPages() then
                self.index = #self.Items
                self.currentPageIndex = self.index % 12 - 1
            end

            self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
                self.labelsVisible)
            self:Populate()
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
                self.currentPageIndex - 1, true,
                true)
        else
            self.index = iPotentialIndex
            self.currentPageIndex = iPotentialIndexPerPage
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
                self.currentPageIndex - 1, true,
                true)
        end
    end
end

function GalleryColumn:GoRight()
    local iPotentialIndex = self:Index()
    local iPotentialIndexPerPage = self.currentPageIndex
    if iPotentialIndex == #self.Items then
        self.index = 1
        self.currentPageIndex = 1
        self.CurPage = 1
        if self:MaxPages() > 1 then
            self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
                self.labelsVisible)
            self:Populate()
        end
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
            self.currentPageIndex - 1, true,
            true)
    else
        if (self.currentPageIndex - 1) % 4 < 3 or self:MaxPages() <= 1 or (self.Parent.bigPic and self.index < 12) then
            iPotentialIndex = iPotentialIndex + 1
            iPotentialIndexPerPage = iPotentialIndexPerPage + 1
        end

        if self:ShouldNavigateToNewPage(iPotentialIndexPerPage) then
            if self.CurPage == self:MaxPages() then
                self.CurPage = 1
            else
                self.CurPage = self.CurPage + 1
            end

            self.index = (((self.CurPage - 1) * self.VisibleItems) + 1) + iPotentialIndexPerPage - 3
            self.currentPageIndex = iPotentialIndexPerPage - 3

            if self.index > #self.Items then
                self.index = #self.Items
                self.currentPageIndex = ((self.index - 1) % 12)
            end

            self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
                self.labelsVisible)
            self:Populate()
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
                self.currentPageIndex - 1, true,
                true)
        else
            self.index = iPotentialIndex
            self.currentPageIndex = iPotentialIndexPerPage
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
                self.currentPageIndex - 1, true,
                true)
        end
    end
end

function GalleryColumn:Select()
    if not self.Parent.bigPic then
        local it = self.Items[self.index]
        self:SetTitle(it.TextureDictionary, it.TextureName, 4)
        self.Parent.bigPic = true
        if it.Blip ~= nil then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.position, "", false)
            self.Parent.Minimap:Enabled(true)
            self.Parent.Minimap:RefreshMapPosition(vector2(it.Blip.Position.x, it.Blip.Position.y))
        elseif not it.RightPanelDescription:IsNullOrEmpty() then
            self.Parent.Minimap:Enabled(false)
            local labels = it.RightPanelDescription:SplitLabel()
            BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_COLUMN_STATE")
            ScaleformMovieMethodAddParamInt(self.position)
            BeginTextCommandScaleformString("CELL_EMAIL_BCON")
            for i = 1, #labels, 1 do
                AddTextComponentScaleform(labels[i])
            end
            EndTextCommandScaleformString_2()
            ScaleformMovieMethodAddParamBool(true)
            EndScaleformMovieMethod()
        else
            self.Parent.Minimap:Enabled(false)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.position, "", true)
        end
        self.Parent.OnGalleryModeChanged(self.Parent, it, self.Parent.bigPic)
    else
        item.Activated(self.Parent, it, self.index, self.currentPageIndex)
        self.Parent.OnGalleryItemSelected(self.Parent, self.Items[self.index], self.index, self.currentPageIndex)
    end
end

function GalleryColumn:GoBack()
    if self.Parent.bigPic then
        self:SetTitle("", "", 0)
        self.Parent.bigPic = false
        local it = self.Items[self.index]
        if it.Blip ~= nil then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.position, "", false)
            self.Parent.Minimap:Enabled(true)
            self.Parent.Minimap:RefreshMapPosition(vector2(it.Blip.Position.x, it.Blip.Position.y))
        elseif not it.RightPanelDescription:IsNullOrEmpty() then
            self.Parent.Minimap:Enabled(false)
            local labels = it.RightPanelDescription:SplitLabel()
            BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_COLUMN_STATE")
            ScaleformMovieMethodAddParamInt(self.position)
            BeginTextCommandScaleformString("CELL_EMAIL_BCON")
            for i = 1, #labels, 1 do
                AddTextComponentScaleform(labels[i])
            end
            EndTextCommandScaleformString_2()
            ScaleformMovieMethodAddParamBool(true)
            EndScaleformMovieMethod()
        else
            self.Parent.Minimap:Enabled(false)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.position, "", true)
        end
        self.Parent.OnGalleryModeChanged(self.Parent, it, self.Parent.bigPic)
    else
        self.Parent.Minimap:Enabled(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", self.position, "", true)
    end
end

function GalleryColumn:MouseScroll(dir)
    if self.Parent.bigPic or self.Parent.CurrentColumnIndex == 1 then
        if dir == 1 then
            self:GoRight()
        else
            self:GoLeft()
        end
        return
    end

    local iPotentialIndex = self:Index()
    local iPotentialIndexPerPage = self.currentPageIndex
    if iPotentialIndex == 1 and dir == -1 then
        self.index = #self.Items
        self.currentPageIndex = self.index % 12 - 1
        self.CurPage = self:MaxPages()
        if self:MaxPages() > 1 then
            self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
                self.labelsVisible)
            self:Populate()
        end
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
            self.currentPageIndex - 1, true,
            true)
    elseif iPotentialIndex == #self.Items and dir == 1 then
        self.index = 1
        self.currentPageIndex = 1
        self.CurPage = 1
        if self:MaxPages() > 1 then
            self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
                self.labelsVisible)
            self:Populate()
        end
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
            self.currentPageIndex - 1, true,
            true)
    else
        if dir == -1 then
            if self.currentPageIndex ~= 1 or self:MaxPages() <= 1 then
                iPotentialIndex = iPotentialIndex - 1
                iPotentialIndexPerPage = iPotentialIndexPerPage - 1
            end
            if self:ShouldNavigateToNewPage(iPotentialIndexPerPage) then
                if self.CurPage > 1 then
                    self.CurPage = self.CurPage - 1
                else
                    self.CurPage = self:MaxPages()
                end

                self.index = self.CurPage * self.VisibleItems
                self.currentPageIndex = 1
                self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
                    self.labelsVisible)
                self:Populate()
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
                    self.currentPageIndex - 1,
                    true, true)
            else
                self.index = iPotentialIndex
                self.currentPageIndex = iPotentialIndexPerPage
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
                    self.currentPageIndex - 1,
                    true, true)
            end
        elseif dir == 1 then
            if self.currentPageIndex < 12 or self:MaxPages() <= 1 then
                iPotentialIndex = iPotentialIndex + 1
                iPotentialIndexPerPage = iPotentialIndexPerPage + 1
            end
            if self:ShouldNavigateToNewPage(iPotentialIndexPerPage) then
                if self.CurPage == self:MaxPages() then
                    self.CurPage = 1
                else
                    self.CurPage = self.CurPage + 1
                end
                self.index = self.CurPage * self.VisibleItems
                self.currentPageIndex = 1
                self.Parent:SetDescriptionLabels(self.titleLabel, self.dateLabel, self.locationLabel, self.trackLabel,
                    self.labelsVisible)
                self:Populate()
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
                    self.currentPageIndex - 1,
                    true, true)
            else
                self.index = iPotentialIndex
                self.currentPageIndex = iPotentialIndexPerPage
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position,
                    self.currentPageIndex - 1,
                    true, true)
            end
        end
    end
end

function GalleryColumn:UpdatePage()
    if not self.Parent.bigPic then
        self:SetColumnScroll("GAL_NUM_PAGES", self.CurPage, self:MaxPages())
    else
        self:SetColumnScroll(self.index, #self.Items, self.VisibleItems)
    end
end

function GalleryColumn:SetTitle(txd, txn, state)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_TITLE", self.position, txd, txn, state)
    self.Parent.bigPic = state ~= 0
    self:UpdatePage()
end
