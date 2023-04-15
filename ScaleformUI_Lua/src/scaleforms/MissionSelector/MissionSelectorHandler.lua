MissionSelectorHandler = setmetatable({}, MissionSelectorHandler)
MissionSelectorHandler.__index = MissionSelectorHandler
MissionSelectorHandler.__call = function()
    return "MissionSelectorHandler"
end

---@class MissionSelectorHandler

function MissionSelectorHandler.New()
    local data = {
        _sc = nil,
        _start = 0,
        _timer = 0,
        enabled = false,
        alreadyVoted = false,
        Votes = { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        VotedFor = -1,
        MaxVotes = 0,
        SelectedCard = 1,
        VotesColor = Colours.HUD_COLOUR_BLUE,
        JobTitle = {
            Title = "",
            Label = "",
            Votes = "",
        },
        Cards = {},
        Buttons = {},
    }
    return setmetatable(data, MissionSelectorHandler)
end

function MissionSelectorHandler:SetTitle(title)
    self.JobTitle.Title = title
end

function MissionSelectorHandler:SetVotes(actual, label)
    local tot = actual .. " / " .. self.MaxVotes
    if not string.IsNullOrEmpty(label) then
        self.JobTitle.Label = label
    end
    self.JobTitle.Votes = tot .. " " .. self.JobTitle.Label
end

function MissionSelectorHandler:AddCard(card)
    if #self.Cards < 9 then
        self.Cards[#self.Cards + 1] = card
    end
end

function MissionSelectorHandler:AddButton(button)
    if #self.Buttons < 3 then
        self.Buttons[#self.Buttons + 1] = button
    end
end

function MissionSelectorHandler:Enabled(bool)
    if bool == nil then
        return self.enabled
    else
        if bool then
            self:BuildMenu()
        else
            self:Dispose()
        end
        self.enabled = bool
    end
end

function MissionSelectorHandler:AlreadyVoted()
    return self.alreadyVoted
end

function MissionSelectorHandler:Dispose()
    self._sc:Dispose()
    self._sc = nil
end

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

function MissionSelectorHandler:UpdateOwnVote(idx, oldidx, showCheckMark, flashBG)
    if showCheckMark == nil then showCheckMark = false end
    if flashBG == nil then flashBG = false end
    if idx == oldidx then return end
    for i = 1, 9 do
        self._sc:CallFunction("SET_GRID_ITEM_VOTE", false, i - 1, self.Votes[i], self.VotesColor, showCheckMark, flashBG)
    end
    local votes = 0
    for k, v in ipairs(self.Votes) do
        if v > 0 then votes = votes + v end
    end
    self:SetVotes(votes)
    self:_SetTitle(self.JobTitle.Title, self.JobTitle.Votes)
end

function MissionSelectorHandler:ShowPlayerVote(idx, playerName, color, showCheckMark, flashBG)
    self.Votes[idx] = self.Votes[idx] + 1
    if showCheckMark == nil then showCheckMark = false end
    if flashBG == nil then flashBG = false end

    local r, g, b, a = GetHudColour(color)
    self._sc:CallFunction("SHOW_PLAYER_VOTE", false, idx - 1, playerName, r, g, b)
    local votes = 0
    for k, v in ipairs(self.Votes) do
        if v > 0 then votes = votes + v end
    end
    self:SetVotes(votes)
    self:_SetTitle(self.JobTitle.Title, self.JobTitle.Votes)
    self._sc:CallFunction("SET_GRID_ITEM_VOTE", false, idx - 1, self.Votes[idx], self.VotesColor, showCheckMark, flashBG)
end

function MissionSelectorHandler:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("MP_NEXT_JOB_SELECTION")
    local timeout = 1000
    local start = GetGameTimer()
    while not self._sc:IsLoaded() and GetGameTimer() - start < timeout do Citizen.Wait(0) end
end

local success, event_type, context, item_id

function MissionSelectorHandler:Update()
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
                        if self.alreadyVoted then
                            local old = self.VotedFor
                            self.Votes[self.VotedFor] = self.Votes[self.VotedFor] - 1
                            if (old ~= self.SelectedCard) then
                                self.VotedFor = self.SelectedCard
                                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                            end
                            self:UpdateOwnVote(self.VotedFor, old)
                        else
                            self.alreadyVoted = true
                            self.VotedFor = self.SelectedCard
                            self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                            self:UpdateOwnVote(self.VotedFor, -1)
                        end
                    else
                        local btn = self.Buttons[self.SelectedCard - 6]
                        if btn.Selectable then
                            if self.alreadyVoted then
                                local old = self.VotedFor
                                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] - 1
                                if (old ~= self.SelectedCard) then
                                    self.VotedFor = self.SelectedCard
                                    self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
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
            if self.alreadyVoted then
                local old = self.VotedFor
                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] - 1
                if (old ~= self.SelectedCard) then
                    self.VotedFor = self.SelectedCard
                    self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                end
                self:UpdateOwnVote(self.VotedFor, old)
            else
                self.alreadyVoted = true
                self.VotedFor = self.SelectedCard
                self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
                self:UpdateOwnVote(self.VotedFor, -1)
            end
        else
            local btn = self.Buttons[self.SelectedCard - 6]
            if btn.Selectable then
                if self.alreadyVoted then
                    local old = self.VotedFor
                    self.Votes[self.VotedFor] = self.Votes[self.VotedFor] - 1
                    if (old ~= self.SelectedCard) then
                        self.VotedFor = self.SelectedCard
                        self.Votes[self.VotedFor] = self.Votes[self.VotedFor] + 1
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

function MissionSelectorHandler:_SetTitle(left, votes)
    self._sc:CallFunction("SET_TITLE", false, left, votes);
end

function MissionSelectorHandler:SetGridItem(id, title, txd, txn, loadtype, verified_type, icon, check, rp_multiplier,
                                            cash_multiplier,
                                            disabled, iconColor, ap_multiplier)
    self._sc:CallFunction("SET_GRID_ITEM", false, id, title, txd, txn, loadtype, verified_type, icon, check,
        rp_multiplier, cash_multiplier, disabled, iconColor, ap_multiplier);
end

function MissionSelectorHandler:SetButtonItem(id, title)
    self._sc:CallFunction("SET_GRID_ITEM", false, id + 6, title, "", "", -1, -1, -1, false, -1, -1, false, -1, -1);
end

function MissionSelectorHandler:SetSelection(index, title, description, hideHighlight)
    if hideHighlight == nil then hideHighlight = false end
    self._sc:CallFunction("SET_SELECTION", false, index, title, description, hideHighlight);
end

function MissionSelectorHandler:SetDetailsItem(id, menu_id, unique_id, type, initial_index, is_selectable, lText, rText,
                                               icon, iconColor, tick)
    if iconColor == nil then iconColor = Colours.HUD_COLOUR_WHITE end
    if tick == nil then tick = false end
    self._sc:CallFunction("SET_DETAILS_ITEM", false, id, menu_id, unique_id, type, initial_index, is_selectable, lText,
        rText, icon, iconColor, tick)
end
