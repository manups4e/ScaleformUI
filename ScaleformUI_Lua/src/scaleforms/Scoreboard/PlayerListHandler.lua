PlayerListScoreboard = setmetatable({
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
}, PlayerListScoreboard)
PlayerListScoreboard.__index = PlayerListScoreboard
PlayerListScoreboard.__call = function()
    return "PlayerListScoreboard"
end

---@class PlayerListScoreboard
---@field _uptime number
---@field _start number
---@field _timer number
---@field _sc Scaleform
---@field public Enabled boolean
---@field public Index number
---@field public MaxPages number
---@field public currentPage number
---@field public PlayerRows table<number, SCPlayerItem>
---@field public TitleLeftText string
---@field public TitleRightText string
---@field public TitleIcon number
---@field public X number
---@field public Y number
---@field public Update fun(self:PlayerListScoreboard):nil
---@field public NextPage fun(self:PlayerListScoreboard):nil
---@field public AddRow fun(self:PlayerListScoreboard, row:SCPlayerItem):nil
---@field public RemoveRow fun(self:PlayerListScoreboard, index:number):nil
---@field public CurrentPage fun(self:PlayerListScoreboard, _c:number?):number
---@field public Dispose fun(self:PlayerListScoreboard):nil
---@field public Load fun(self:PlayerListScoreboard):nil
---@field public SetTitle fun(self:PlayerListScoreboard, title:string, label:string, icon:number):nil
---@field public SetPosition fun(self:PlayerListScoreboard, x:number, y:number):nil

---Current page of the scoreboard
---@param _c number?
---@return number
function PlayerListScoreboard:CurrentPage(_c)
    if _c ~= nil then
        if #self.PlayerRows == 0 then
            self.currentPage = 0
            return self.currentPage
        end
        self.currentPage = _c
        if self.currentPage > 0 then
            self.Enabled = true
            self:NextPage()
        end
    end
    return self.currentPage
end

---Load the scoreboard scaleform
function PlayerListScoreboard:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("MP_MM_CARD_FREEMODE")
    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end
end

---Dispose the scoreboard scaleform
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
    self.PlayerRows = {}
end

---Set the title of the scoreboard
---@param title string
---@param label string
---@param icon number
function PlayerListScoreboard:SetTitle(title, label, icon)
    self.TitleLeftText = title or ""
    self.TitleRightText = label or ""
    self.TitleIcon = icon or ""
end

---Set the position of the scoreboard
---@param x number
---@param y number
function PlayerListScoreboard:SetPosition(x, y)
    self.X = x
    self.Y = y
end

---Set the duration the scoreboard should be visible
function PlayerListScoreboard:SetTimer(upTime)
    self.uptime = upTime
end

---Add a new row to the scoreboard
---@param player SCPlayerItem
function PlayerListScoreboard:AddRow(player)
    self.PlayerRows[#self.PlayerRows + 1] = player
end

---Remove a row from the scoreboard
---@param index number
function PlayerListScoreboard:RemoveRow(index)
    table.remove(self.PlayerRows, index)
end

---Get if a row_id should be displayed on the current page
---@param row_id number
function PlayerListScoreboard:IsSupposedToShow(row_id)
    if self:CurrentPage() == 0 then return false end
    local max = self:CurrentPage() * 16
    local min = self:CurrentPage() * 16 - 15
    return row_id >= min and row_id <= max
end

---Update max pages displayed on the scoreboard
function PlayerListScoreboard:UpdateMaxPages()
    self.MaxPages = math.ceil(#self.PlayerRows / 16.0)
end

---Draw the scoreboard on the screen
function PlayerListScoreboard:Update()
    if self._sc == nil or not self.Enabled then return end
    ScaleformUI.WaitTime = 0
    self._sc:Render2DNormal(self.X, self.Y, 0.28, 0.6)
    if self._start ~= 0 and GlobalGameTimer - self._start > self._timer then
        self:CurrentPage(0)
        self.Enabled = false
        self._start = 0
        self:Dispose()
    end
end

---Change the page of the scoreboard
function PlayerListScoreboard:NextPage()
    self:UpdateMaxPages()
    self._start = GlobalGameTimer
    self._timer = self._uptime or 8000
    self:BuildMenu()
    if self:CurrentPage() > self.MaxPages then
        self:CurrentPage(0)
        self.Enabled = false
        self._start = 0
        self:Dispose()
    end
end

---Highlight a row on the scoreboard
---@param idx number
function PlayerListScoreboard:Highlight(idx)
    self._sc:CallFunction("SET_HIGHLIGHT", idx - 1)
end

---Show microphone icon on a row
---@param idx number
---@param show boolean
function PlayerListScoreboard:ShowMic(idx, show)
    self._sc:CallFunction("DISPLAY_MIC", idx - 1, show)
end

---Update a slot on the scoreboard
---@param id number
---@param row SCPlayerItem
function PlayerListScoreboard:UpdateSlot(id, row)
    if row.CrewLabelText ~= "" then
        self._sc:CallFunction("UPDATE_SLOT", id - 1, row.RightText, row.Name, row.Color, row.RightIcon,
            row.IconOverlayText, row.JobPointsText, "..+" .. row.CrewLabelText, row.JobPointsDisplayType,
            row.TextureString,
            row.TextureString, row.FriendType)
    else
        self._sc:CallFunction("UPDATE_SLOT", id - 1, row.RightText, row.Name, row.Color, row.RightIcon,
            row.IconOverlayText, row.JobPointsText, "", row.JobPointsDisplayType, row.TextureString, row.TextureString,
            row.FriendType)
    end
end

---Refresh all slots on the scoreboard
function PlayerListScoreboard:RefreshAll()
    Citizen.CreateThread(function()
        for index, row in pairs(self.PlayerRows) do
            if row.CrewLabelText ~= "" then
                self._sc:CallFunction("UPDATE_SLOT", index - 1, row.RightText, row.Name, row.Color, row.RightIcon,
                    row.IconOverlayText, row.JobPointsText, "..+" .. row.CrewLabelText, row.JobPointsDisplayType,
                    row.TextureString, row.TextureString, row.FriendType)
            else
                self._sc:CallFunction("UPDATE_SLOT", index - 1, row.RightText, row.Name, row.Color, row.RightIcon,
                    row.IconOverlayText, row.JobPointsText, "", row.JobPointsDisplayType, row.TextureString,
                    row.TextureString, row.FriendType)
            end
        end
    end)
end

---Set the icon of a row
---@param idx number
---@param icon number
---@param txt string
function PlayerListScoreboard:SetIcon(idx, icon, txt)
    local row = self.PlayerRows[idx]
    if row ~= nil then
        self._sc:CallFunction("SET_ICON", idx - 1, icon, txt)
    end
end

---Build the scoreboard
function PlayerListScoreboard:BuildMenu()
    if self._sc == nil then self:Load() end
    while self._sc == nil or not self._sc:IsLoaded() do Citizen.Wait(0) end
    local rows = {}
    self._sc:CallFunction("SET_DATA_SLOT_EMPTY")
    self._sc:CallFunction("SET_TITLE", self.TitleLeftText, self.TitleRightText, self.TitleIcon)
    for k, v in pairs(self.PlayerRows) do
        if self:IsSupposedToShow(k) then
            rows[#rows + 1] = v
        end
    end
    self.Index = 0
    for k, row in pairs(rows) do
        if string.IsNullOrEmpty(row.CrewLabelText) then
            self._sc:CallFunction("SET_DATA_SLOT", self.Index, row.RightText, row.Name, row.Color, row.RightIcon,
                row.IconOverlayText, row.JobPointsText, "", row.JobPointsDisplayType, row.TextureString,
                row.TextureString,
                row.FriendType)
        else
            self._sc:CallFunction("SET_DATA_SLOT", self.Index, row.RightText, row.Name, row.Color, row.RightIcon,
                row.IconOverlayText, row.JobPointsText, "..+" .. row.CrewLabelText, row.JobPointsDisplayType,
                row.TextureString, row.TextureString, row.FriendType)
        end
        self.Index = self.Index + 1
    end
    self._sc:CallFunction("DISPLAY_VIEW")
end
