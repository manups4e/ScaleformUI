BaseTab = setmetatable({}, BaseTab)
BaseTab.__index = BaseTab
BaseTab.__call = function()
    return "BaseTab"
end

---@class BaseTab
---@field public Title string
---@field public Type number
---@field public Visible boolean
---@field public Focused boolean
---@field public Active boolean
---@field public Parent BaseTab
---@field public LeftItemList PauseMenuItem[]
---@field public Activated fun(item: BaseTab)
---@field public _identifier string
---@field public LeftColumn PM_Column 
---@field public CenterColumn PM_Column 
---@field public RightColumn PM_Column 
---@field public CurrentColumnIndex integer


---Creates a new BaseTab.
---@param title string
---@param color SColor
---@return BaseTab
function BaseTab.New(title, color)
    local data = {
        Title = title or "",
        Type = type or 0,
        Visible = false,
        Focused = false,
        Active = false,
        TabColor = color or SColor.HUD_Freemode,
        Parent = nil,
        _identifier = "",
        LeftColumn = nil,
        CenterColumn = nil,
        RightColumn = nil,
        Minimap = nil,
        CurrentColumnIndex = 0,
        Activated = function(item)
        end
    }
    return setmetatable(data, BaseTab)
end

function BaseTab:Populate() end
function BaseTab:Refresh(highlightOldIndex) end
function BaseTab:ShowColumns() end
function BaseTab:SetDataSlot(slot, index) end
function BaseTab:UpdateSlot(slot, index) end
function BaseTab:AddSlot(slot, index) end
function BaseTab:Focus() self.Focused = true end
function BaseTab:UnFocus() self.Focused = false end
function BaseTab:GoUp() end
function BaseTab:GoDown() end
function BaseTab:GoLeft() end
function BaseTab:GoRight() end
function BaseTab:Select() end
function BaseTab:GoBack() end
function BaseTab:Selected() end
function BaseTab:MouseEvent(eventType, context, index) end
function BaseTab:StateChange(state) end

function BaseTab:CurrentColumn()
    if self.CurrentColumnIndex == 0 then
        return self.LeftColumn
    elseif self.CurrentColumnIndex == 1 then
        return self.CenterColumn
    elseif self.CurrentColumnIndex == 2 then
        return self.RightColumn
    end
end

function BaseTab:GetColumnAtPosition(pos)
    if pos == 0 then
        return self.LeftColumn
    elseif pos == 1 then
        return self.CenterColumn
    elseif pos == 2 then
        return self.RightColumn
    end
end