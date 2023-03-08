PlayerListScoreboard = setmetatable({}, PlayerListScoreboard)
PlayerListScoreboard.__index = PlayerListScoreboard

function PlayerListScoreboard.New()
    local data = {
        _uptime = 8000,
        _start = 0,
        _timer = 0,
        _sc = nil,
        Enabled = false,
        Index = 0,
        MaxPages = 1,
        currentPage = 0,
        PlayerRows = {},
        TitleLeftText = "",
        TitleRightText = "",
        TitleIcon = 0,
        X = 0.122,
        Y = 0.3
    }
    return setmetatable(data, PlayerListScoreboard)
end

function PlayerListScoreboard:CurrentPage(_c)
    if _c == nil then
        return self.currentPage
    else
        if #self.PlayerRows == 0 then
            self.currentPage = 0
            return
        end
        self.currentPage = _c
        if self.currentPage > 0 then
            self.Enabled = true
            self:NextPage()
        end
    end
end

function PlayerListScoreboard:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("MP_MM_CARD_FREEMODE")
    local timeout = 1000
    local start = GetGameTimer()
    while not self._sc:IsLoaded() and GetGameTimer() - start < timeout do Citizen.Wait(0) end
end

function PlayerListScoreboard:Dispose()
    if self._sc == nil then return end
    self.Enabled = false
    self.Index = 0
    self.MaxPages = 1
    self:CurrentPage(0)
    self.TitleLeftText = ""
    self.TitleRightText = ""
    self.TitleIcon = 0
    self._sc:CallFunction("SET_DATA_SLOT_EMPTY")
    self._sc:Dispose()
    self._sc = nil
    for i = 0, 1024 do -- cleaning up in case of a reload, this frees up all ped headshot handles :)
        UnregisterPedheadshot(i)
    end
end

function PlayerListScoreboard:SetTitle(title, label, icon)
    self.TitleLeftText = title or ""
    self.TitleRightText = label or ""
    self.TitleIcon = icon or 0
end

function PlayerListScoreboard:SetPosition(x, y)
    self.X = x
    self.Y = y
end

function PlayerListScoreboard:SetTimer(upTime)
    self.uptime = upTime
end

function PlayerListScoreboard:AddRow(row)
    self.PlayerRows[#self.PlayerRows + 1] = row
end

function PlayerListScoreboard:RemoveRow(id)
    table.remove(self.PlayerRows, id)
end

function PlayerListScoreboard:IsSupposedToShow(row_id)
    if self:CurrentPage() == 0 then return false end
    local max = self:CurrentPage() * 16
    local min = self:CurrentPage() * 16 - 15
    return row_id >= min and row_id <= max
end

function PlayerListScoreboard:UpdateMaxPages()
    self.MaxPages = math.ceil(#self.PlayerRows / 16.0)
end

function PlayerListScoreboard:Update()
    self._sc:Render2DNormal(self.X, self.Y, 0.28, 0.6)
    if self._start ~= 0 and GetGameTimer() - self._start > self._timer then
        self:CurrentPage(0)
        self.Enabled = false
        self._start = 0
        self:Dispose()
    end
end

function PlayerListScoreboard:NextPage()
    self:UpdateMaxPages()
    self._start = GetGameTimer()
    self._timer = self._uptime or 8000
    self:BuildMenu()
    if self:CurrentPage() > self.MaxPages then
        self:CurrentPage(0)
        self.Enabled = false
        self._start = 0
        self:Dispose()
    end
end

function PlayerListScoreboard:Highlight(idx)
    self._sc:CallFunction("SET_HIGHLIGHT", false, idx - 1)
end

function PlayerListScoreboard:ShowMic(idx, show)
    self._sc:CallFunction("DISPLAY_MIC", false, idx - 1, show)
end

function PlayerListScoreboard:UpdateSlot(id, row)
    if row.CrewLabelText ~= "" then
        self._sc:CallFunction("UPDATE_SLOT", false, id - 1, row.RightText, row.Name, row.Color, row.RightIcon,
            row.IconOverlayText, row.JobPointsText, "..+" .. row.CrewLabelText, row.JobPointsDisplayType,
            row.TextureString,
            row.TextureString, row.FriendType)
    else
        self._sc:CallFunction("UPDATE_SLOT", false, id - 1, row.RightText, row.Name, row.Color, row.RightIcon,
            row.IconOverlayText, row.JobPointsText, "", row.JobPointsDisplayType, row.TextureString, row.TextureString,
            row.FriendType)
    end
end

function PlayerListScoreboard:RefreshAll()
    Citizen.CreateThread(function()
        for index, row in pairs(self.PlayerRows) do
            if row.CrewLabelText ~= "" then
                self._sc:CallFunction("UPDATE_SLOT", false, index - 1, row.RightText, row.Name, row.Color, row.RightIcon,
                    row.IconOverlayText, row.JobPointsText, "..+" .. row.CrewLabelText, row.JobPointsDisplayType,
                    row.TextureString, row.TextureString, row.FriendType)
            else
                self._sc:CallFunction("UPDATE_SLOT", false, index - 1, row.RightText, row.Name, row.Color, row.RightIcon,
                    row.IconOverlayText, row.JobPointsText, "", row.JobPointsDisplayType, row.TextureString,
                    row.TextureString, row.FriendType)
            end
        end
    end)
end

function PlayerListScoreboard:SetIcon(idx, icon, txt)
    local row = self.PlayerRows[idx]
    if row ~= nil then
        self._sc:CallFunction("SET_ICON", idx - 1, icon, txt)
    end
end

function PlayerListScoreboard:BuildMenu()
    if self._sc == nil then self:Load() end
    while self._sc == nil or not self._sc:IsLoaded() do Citizen.Wait(0) end
    local rows = {}
    self._sc:CallFunction("SET_DATA_SLOT_EMPTY", false)
    self._sc:CallFunction("SET_TITLE", false, self.TitleLeftText, self.TitleRightText, self.TitleIcon)
    for k, v in pairs(self.PlayerRows) do
        if self:IsSupposedToShow(k) then
            rows[#rows + 1] = v
        end
    end
    self.Index = 0
    for k, row in pairs(rows) do
        if string.IsNullOrEmpty(row.CrewLabelText) then
            self._sc:CallFunction("SET_DATA_SLOT", false, self.Index, row.RightText, row.Name, row.Color, row.RightIcon,
                row.IconOverlayText, row.JobPointsText, "", row.JobPointsDisplayType, row.TextureString,
                row.TextureString,
                row.FriendType)
        else
            self._sc:CallFunction("SET_DATA_SLOT", false, self.Index, row.RightText, row.Name, row.Color, row.RightIcon,
                row.IconOverlayText, row.JobPointsText, "..+" .. row.CrewLabelText, row.JobPointsDisplayType,
                row.TextureString, row.TextureString, row.FriendType)
        end
        self.Index = self.Index + 1
    end
    self._sc:CallFunction("DISPLAY_VIEW", false)
end
