MissionSelectorHandler = setmetatable({
    _sc = nil,
    _start = 0,
    _timer = 0,
    enabled = false,
    alreadyVoted = false,
    Votes = { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    VotedFor = -1,
    MaxVotes = 0,
    SelectedCard = 1,
    VotesColor = HudColours.HUD_COLOUR_BLUE,
    JobTitle = {
        Title = "",
        Label = "",
        Votes = "",
    },
    Cards = {},
    Buttons = {},
}, MissionSelectorHandler)
MissionSelectorHandler.__index = MissionSelectorHandler
MissionSelectorHandler.__call = function()
    return "MissionSelectorHandler"
end

---@class MissionSelectorHandler
---@field public _sc Scaleform
---@field public _start number
---@field public _timer number
---@field public enabled boolean
---@field public alreadyVoted boolean
---@field public Votes table<number, number>
---@field public VotedFor number
---@field public MaxVotes number
---@field public SelectedCard number
---@field public VotesColor number
---@field public JobTitle table<string, string>
---@field public Cards table<number, JobSelectionCard>
---@field public Buttons table<number, JobSelectionButton>
---@field public SetTitle fun(self:MissionSelectorHandler, title:string):nil
---@field public SetVotes fun(self:MissionSelectorHandler, actual:number, label:string):nil
---@field public AddCard fun(self:MissionSelectorHandler, card:JobSelectionCard):nil
---@field public AddButton fun(self:MissionSelectorHandler, button:JobSelectionButton):nil
---@field public Enabled fun(self:MissionSelectorHandler, bool:boolean?):boolean
---@field public AlreadyVoted fun(self:MissionSelectorHandler):boolean
---@field public BuildMenu fun(self:MissionSelectorHandler):nil
---@field public Dispose fun(self:MissionSelectorHandler):nil
---@field public SelectCard fun(self:MissionSelectorHandler, card:number):nil
---@field public UpdateOwnVote fun(self:MissionSelectorHandler, card:number, oldCard:number, showCheckmark:boolean, flashBackground:boolean):nil
---@field public ShowPlayerVote fun(self:MissionSelectorHandler, card:number, playerName:string, colour:HudColours, showCheckmark:boolean, flashBackground:boolean):nil
---@field public RemovePlayerVote fun(self:MissionSelectorHandler, card:number):nil
---@field public Load fun(self:MissionSelectorHandler):nil
---@field public Update fun(self:MissionSelectorHandler):nil

---Sets the title of the mission selector
---@param title string
function MissionSelectorHandler:SetTitle(title)
    self.JobTitle.Title = title
end

---Sets the votes of the mission selector
---@param actual number
---@param label string?
function MissionSelectorHandler:SetVotes(actual, label)
    local tot = actual .. " / " .. self.MaxVotes
    if not string.IsNullOrEmpty(label or "") then
        self.JobTitle.Label = label
    end
    self.JobTitle.Votes = tot .. " " .. self.JobTitle.Label
end

---Adds a card to the mission selector grid menu (max 9)
---@param card JobSelectionCard
function MissionSelectorHandler:AddCard(card)
    if #self.Cards < 9 then
        self.Cards[#self.Cards + 1] = card
    end
end

---Adds a button to the mission selector grid menu (max 3)
---@param button JobSelectionButton
function MissionSelectorHandler:AddButton(button)
    if #self.Buttons < 3 then
        self.Buttons[#self.Buttons + 1] = button
    end
end

---Toggles the mission selector on or off
---@param bool boolean?
function MissionSelectorHandler:Enabled(bool)
    if bool ~= nil then
        if bool then
            self:BuildMenu()
        else
            self:Dispose()
        end
        self.enabled = bool
    end
    return self.enabled
end

---Returns true if the player has already voted
function MissionSelectorHandler:AlreadyVoted()
    return self.alreadyVoted
end

---Disposes the mission selector
function MissionSelectorHandler:Dispose()
    self._sc:Dispose()
    self._sc = nil
end

---Builds the mission selector menu
function MissionSelectorHandler:BuildMenu()
    self:Load()
    while self._sc == nil or not self._sc:IsLoaded() do Citizen.Wait(0) end
    self:_SetTitle(self.JobTitle.Title, self.JobTitle.Votes)
    for i, card in ipairs(self.Cards) do
        if not string.IsNullOrEmpty(card.Txd) then
            while not HasStreamedTextureDictLoaded(card.Txd) do
                Citizen.Wait(0)
                RequestStreamedTextureDict(card.Txd, true)
            end
        end
        self:SetGridItem(i - 1, card.Title, card.Txd, card.Txn, 1, 0, card.Icon, false, card.RpMultiplier,
            card.CashMultiplier, false, card.IconColor, card.ApMultiplier)
        SetStreamedTextureDictAsNoLongerNeeded(card.Txd)
    end

    for i, button in ipairs(self.Buttons) do
        self:SetButtonItem(i - 1, button.Text)
    end
    self:SetSelection(0, self.Cards[1].Title, self.Cards[1].Description)
    for i, detail in ipairs(self.Cards[1].Details) do
        self:SetDetailsItem(i - 1, 0, i - 1, detail.Type, 0, 0, detail.TextLeft, detail.TextRight, detail.Icon,
            detail.IconColor, detail.Tick)
    end
end

---Selects a card in the mission selector
function MissionSelectorHandler:SelectCard(idx)
    if idx <= 6 then
        self:SetSelection(idx - 1, self.Cards[idx].Title, self.Cards[idx].Description)
        for i, detail in pairs(self.Cards[idx].Details) do
            self:SetDetailsItem(i - 1, idx, i - 1, detail.Type, 0, 0, detail.TextLeft, detail.TextRight, detail.Icon,
                detail.IconColor, detail.Tick)
        end
    else
        self:SetSelection(idx - 1, self.Buttons[idx - 6].Text, self.Buttons[idx - 6].Description)
        for i, detail in pairs(self.Buttons[idx - 6].Details) do
            self:SetDetailsItem(i - 1, idx, i - 1, detail.Type, 0, 0, detail.TextLeft, detail.TextRight, detail.Icon,
                detail.IconColor, detail.Tick)
        end
    end
end

---Updates own vote on a card in the mission selector
function MissionSelectorHandler:UpdateOwnVote(idx, oldidx, showCheckMark, flashBG)
    if showCheckMark == nil then showCheckMark = false end
    if flashBG == nil then flashBG = false end
    if idx == oldidx then return end
    for i = 1, 9 do
        self._sc:CallFunction("SET_GRID_ITEM_VOTE", i - 1, self.Votes[i], self.VotesColor, showCheckMark, flashBG)
    end
    local votes = 0
    for k, v in ipairs(self.Votes) do
        if v > 0 then votes = votes + v end
    end
    self:SetVotes(votes)
    self:_SetTitle(self.JobTitle.Title, self.JobTitle.Votes)
end

-- Removes a player's vote on a card in the mission selector
function MissionSelectorHandler:RemovePlayerVote(idx)
    if idx <= 0 or idx > 9 then return end
    if self.Votes[idx] <= 0 then return end
    self.Votes[idx] = self.Votes[idx] - 1
    local votes = 0
    for k, v in ipairs(self.Votes) do
        if v > 0 then votes = votes + v end
    end
    self:SetVotes(votes)
    self:_SetTitle(self.JobTitle.Title, self.JobTitle.Votes)
    self._sc:CallFunction("SET_GRID_ITEM_VOTE", false, idx - 1, self.Votes[idx], self.VotesColor, false, false)
end

---Shows a player's vote on a card in the mission selector
function MissionSelectorHandler:ShowPlayerVote(idx, playerName, color, showCheckMark, flashBG)
    self.Votes[idx] = self.Votes[idx] + 1
    if showCheckMark == nil then showCheckMark = false end
    if flashBG == nil then flashBG = false end

    local r, g, b, a = GetHudColour(color)
    self._sc:CallFunction("SHOW_PLAYER_VOTE", idx - 1, playerName, r, g, b)
    local votes = 0
    for k, v in ipairs(self.Votes) do
        if v > 0 then votes = votes + v end
    end
    self:SetVotes(votes)
    self:_SetTitle(self.JobTitle.Title, self.JobTitle.Votes)
    self._sc:CallFunction("SET_GRID_ITEM_VOTE", idx - 1, self.Votes[idx], self.VotesColor, showCheckMark, flashBG)
end

---Loads the mission selector scaleform
function MissionSelectorHandler:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("MP_NEXT_JOB_SELECTION")
    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end
end

local success, event_type, context, item_id

---Updates the mission selector
function MissionSelectorHandler:Update()
    if self._sc == nil or not self.enabled then return end
    ScaleformUI.WaitTime = 0
    self._sc:Render2D()
    DisableAllControlActions(0)
    DisableAllControlActions(1)
    DisableAllControlActions(2)

    if IsUsingKeyboard(2) then
        SetMouseCursorActiveThisFrame();
        SetInputExclusive(2, 239);
        SetInputExclusive(2, 240);
        SetInputExclusive(2, 237);
        SetInputExclusive(2, 238);

        success, event_type, context, item_id = GetScaleformMovieCursorSelection(self._sc.handle)
        if success then
            if event_type == 5 then
                if self.SelectedCard ~= context + 1 then
                    self.SelectedCard = context + 1
                    self:SelectCard(self.SelectedCard)
                    return
                else
                    if self.SelectedCard <= 6 then
                        local card = self.Cards[self.SelectedCard]
                        if self.alreadyVoted then
                            local old = self.VotedFor
                            self.Votes[self.VotedFor] = self.Votes[self.VotedFor] - 1
                            if (old ~= self.SelectedCard) then
                                self.VotedFor = self.SelectedCard
                                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                            else
                                self.alreadyVoted = false
                                self.VotedFor = -1
                            end
                            self:UpdateOwnVote(self.VotedFor, old)
                        else
                            self.alreadyVoted = true
                            self.VotedFor = self.SelectedCard
                            self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                            self:UpdateOwnVote(self.VotedFor, -1)
                        end
                        card.OnCardPressed()
                    else
                        local btn = self.Buttons[self.SelectedCard - 6]
                        if btn.Selectable then
                            if self.alreadyVoted then
                                local old = self.VotedFor
                                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] - 1
                                if (old ~= self.SelectedCard) then
                                    self.VotedFor = self.SelectedCard
                                    self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                                else
                                    self.alreadyVoted = false
                                    self.VotedFor = -1
                                end
                                self:UpdateOwnVote(self.VotedFor, old)
                            else
                                self.alreadyVoted = true
                                self.VotedFor = self.SelectedCard
                                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                                self:UpdateOwnVote(self.VotedFor, -1)
                            end
                        end
                        btn.OnButtonPressed()
                    end
                end
            end
        end
    end

    if IsDisabledControlJustPressed(2, 188) then
        if self.SelectedCard - 3 >= 1 and self.SelectedCard - 3 <= 9 then
            self.SelectedCard = self.SelectedCard - 3
            self:SelectCard(self.SelectedCard)
        end
    elseif IsDisabledControlJustPressed(2, 187) then
        if self.SelectedCard + 3 >= 1 and self.SelectedCard + 3 <= 9 then
            self.SelectedCard = self.SelectedCard + 3
            self:SelectCard(self.SelectedCard)
        end
    elseif IsDisabledControlJustPressed(2, 189) then
        if self.SelectedCard - 1 >= 1 and self.SelectedCard - 1 <= 9 then
            self.SelectedCard = self.SelectedCard - 1
            self:SelectCard(self.SelectedCard)
        end
    elseif IsDisabledControlJustPressed(2, 190) then
        if self.SelectedCard + 1 >= 1 and self.SelectedCard + 1 <= 9 then
            self.SelectedCard = self.SelectedCard + 1
            self:SelectCard(self.SelectedCard)
        end
    elseif IsDisabledControlJustPressed(2, 201) then
        if self.SelectedCard <= 6 then
            local card = self.Cards[self.SelectedCard]
            if self.alreadyVoted then
                local old = self.VotedFor
                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] - 1
                if (old ~= self.SelectedCard) then
                    self.VotedFor = self.SelectedCard
                    self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                else
                    self.alreadyVoted = false
                    self.VotedFor = -1
                end
                self:UpdateOwnVote(self.VotedFor, old)
            else
                self.alreadyVoted = true
                self.VotedFor = self.SelectedCard
                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                self:UpdateOwnVote(self.VotedFor, -1)
            end
            card.OnCardPressed()
        else
            local btn = self.Buttons[self.SelectedCard - 6]
            if btn.Selectable then
                if self.alreadyVoted then
                    local old = self.VotedFor
                    self.Votes[self.VotedFor] = self.Votes[self.VotedFor] - 1
                    if (old ~= self.SelectedCard) then
                        self.VotedFor = self.SelectedCard
                        self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                    else
                        self.alreadyVoted = false
                        self.VotedFor = -1
                    end
                    self:UpdateOwnVote(self.VotedFor, old)
                else
                    self.alreadyVoted = true
                    self.VotedFor = self.SelectedCard
                    self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                    self:UpdateOwnVote(self.VotedFor, -1)
                end
            end
            btn.OnButtonPressed()
        end
    end
end

-- These all don't make much sense based on their names, there is some cross over with naming conventions

function MissionSelectorHandler:_SetTitle(left, votes)
    self._sc:CallFunction("SET_TITLE", left, votes);
end

function MissionSelectorHandler:SetGridItem(id, title, txd, txn, loadtype, verified_type, icon, check, rp_multiplier,
                                            cash_multiplier,
                                            disabled, iconColor, ap_multiplier)
    self._sc:CallFunction("SET_GRID_ITEM", id, title, txd, txn, loadtype, verified_type, icon, check,
        rp_multiplier, cash_multiplier, disabled, iconColor, ap_multiplier);
end

function MissionSelectorHandler:SetButtonItem(id, title)
    self._sc:CallFunction("SET_GRID_ITEM", id + 6, title, "", "", -1, -1, -1, false, -1, -1, false, -1, -1);
end

function MissionSelectorHandler:SetSelection(index, title, description, hideHighlight)
    if hideHighlight == nil then hideHighlight = false end
    self._sc:CallFunction("SET_SELECTION", index, title, description, hideHighlight);
end

function MissionSelectorHandler:SetDetailsItem(id, menu_id, unique_id, type, initial_index, is_selectable, lText, rText,
                                               icon, iconColor, tick)
    if iconColor == nil then iconColor = HudColours.HUD_COLOUR_WHITE end
    if tick == nil then tick = false end
    self._sc:CallFunction("SET_DETAILS_ITEM", id, menu_id, unique_id, type, initial_index, is_selectable, lText,
        rText, icon, iconColor, tick)
end
