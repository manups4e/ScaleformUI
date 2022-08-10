UIMenuDetailsWindow = setmetatable({}, UIMenuDetailsWindow)
UIMenuDetailsWindow.__index = UIMenuDetailsWindow
UIMenuDetailsWindow.__call = function() return "UIMenuWindow", "UIMenuDetailsWindow" end

---New
---@param Mom number
---@param Dad number
function UIMenuDetailsWindow.New(...)
    local args = {...}

    if #args == 3 or #args == 4 then
        _UIMenuDetailsWindow = {
            id = 1,
            DetailTop = args[1],
            DetailMid = args[2],
            DetailBottom = args[3],
            StatWheelEnabled = false,
            DetailLeft = args[4] or {
                Txd = "",
                Txn = "",
                Pos = vector2(0, 0),
                Size = vector2(0, 0),
            },
            ParentMenu = nil, -- required
        }
    elseif #args == 5 then
        _UIMenuDetailsWindow = {
            id = 1,
            DetailTop = args[1],
            DetailMid = args[2],
            DetailBottom = args[3],
            StatWheelEnabled = args[4],
            DetailStats = args[5],
            DetailLeft = {
                Txd = "statWheel",
                Txn = "",
                Pos = vector2(0, 0),
                Size = vector2(0, 0),
            },
            ParentMenu = nil, -- required
        }
    end
	return setmetatable(_UIMenuDetailsWindow, UIMenuDetailsWindow)
end

---SetParentMenu
---@param Menu table
function UIMenuDetailsWindow:SetParentMenu(Menu) -- required
	if Menu() == "UIMenu" then
		self.ParentMenu = Menu
	else
		return self.ParentMenu
	end
end

function UIMenuDetailsWindow:UpdateLabels(top, mid, bot, leftDetail)
    self.DetailTop = top
    self.DetailMid = mid
    self.DetailBottom = bot
    self.DetailLeft = leftDetail or {
        Txd = "",
        Txn = "",
        Pos = vector2(0, 0),
        Size = vector2(0, 0),
    }

    if self.ParentMenu ~= nil then
        local wid = IndexOf(self.ParentMenu.Windows, self) - 1
        if self.StatWheelEnabled then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_DETAILS_WINDOW_VALUES", false, wid, self.DetailBottom, self.DetailMid, self.DetailTop, "statWheel")
        else
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_DETAILS_WINDOW_VALUES", false, wid, self.DetailBottom, self.DetailMid, self.DetailTop, self.DetailLeft.Txd, self.DetailLeft.Txn, self.DetailLeft.Pos.x, self.DetailLeft.Pos.y, self.DetailLeft.Size.x, self.DetailLeft.Size.y)
        end
    end
end

function UIMenuDetailsWindow:AddStatsListToWheel(stats)
    if self.StatWheelEnabled then
        self.DetailStats = stats
        if self.ParentMenu ~= nil then
            local wid = IndexOf(self.ParentMenu.Windows, self) - 1
            for key, value in pairs(self.DetailStats) do
                ScaleformUI.Scaleforms._ui:CallFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", false, wid, value.Percentage, value.HudColor)
            end
        end
    end
end

function UIMenuDetailsWindow:AddStatSingleToWheel(stat)
    if self.StatWheelEnabled then
        self.DetailStats[#self.DetailStats + 1] = stat
        if self.ParentMenu ~= nil then
            local wid = IndexOf(self.ParentMenu.Windows, self) - 1
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", false, wid, stat.Percentage, stat.HudColor)
        end
    end
end

function UIMenuDetailsWindow:UpdateStatsToWheel()
    if self.StatWheelEnabled then
        if self.ParentMenu ~= nil then
            local wid = IndexOf(self.ParentMenu.Windows, self) - 1
            for key, value in pairs(self.DetailStats) do
                ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_STATS_DETAILS_WINDOW_STATWHEEL", false, wid, key - 1, value.Percentage, value.HudColor)
            end
        end
    end
end