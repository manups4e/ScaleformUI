MissionDetailsPanel = {}
MissionDetailsPanel.__index = MissionDetailsPanel
setmetatable(MissionDetailsPanel, { __index = PM_Column })
MissionDetailsPanel.__call = function() return "MissionDetailsPanel" end

---@class MissionDetailsPanel
---@field private _title string
---@field private _label string
---@field private _color SColor
---@field public Parent MissionDetailsPanel
---@field public Items table<MissionDetailsItem>
---@field public TextureDict string
---@field public TextureName string
---@field public Title fun(self: MissionDetailsPanel, label: string): string
---@field public UpdatePanelPicture fun(self: MissionDetailsPanel, txd: string, txn: string)
---@field public AddItem fun(self: MissionDetailsPanel, item: MissionDetailsItem)
---@field public OnIndexChanged fun(index: number)

function MissionDetailsPanel.New(label, color)
    local base = PM_Column.New(2)
    base.Label = label
    base.type = PLT_COLUMNS.MISSION_DETAILS
    base._title = ""
    base.TextureDict = ""
    base.TextureName = ""
    return setmetatable(base, MissionDetailsPanel)
end

function MissionDetailsPanel:Title(label)
    if label == nil then
        return self._title
    else
        self._title = label
        if self:visible() then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_TITLE", self.position, self._title,
                self.TextureDict, self.TextureName)
        end
    end
end

function MissionDetailsPanel:UpdatePanelPicture(txd, txn)
    self.TextureDict = txd
    self.TextureName = txn
    if self:visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_TITLE", self.position, self._title,
            self.TextureDict, self.TextureName)
    end
end

function MissionDetailsPanel:Populate()
    if not self:visible() then return end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", self.position)
    for i = 1, #self.Items, 1 do
        self:SetDataSlot(i)
    end
end

function MissionDetailsPanel:ShowColumn()
    if not self:visible() then return end
    PM_Column.ShowColumn(self)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_TITLE", self.position, self._title,
        self.TextureDict, self.TextureName)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", self.position, self.Focused, false, false)
end

function MissionDetailsPanel:SetDataSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index)
    end
end

function MissionDetailsPanel:UpdateSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index, true)
    end
end

function MissionDetailsPanel:AddSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index, false, false, true)
    end
end

function MissionDetailsPanel:AddItem(item)
    self.Items[#self.Items + 1] = item
    if self:visible() and #self.Items < self.VisibleItems then
        local idx = #self.Items
        self:AddSlot(idx)
    end
end

function MissionDetailsPanel:SendItemToScaleform(i, update, newItem, isSlot)
    if i > #self.Items then return end
    local item = self.Items[i]
    local str = "SET_DATA_SLOT"
    if update then str = "UPDATE_SLOT" end
    if newItem then str = "SET_DATA_SLOT_SPLICE" end
    if isSlot then str = "ADD_SLOT" end
    BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, str);
    PushScaleformMovieFunctionParameterInt(self.position);
    PushScaleformMovieFunctionParameterInt(i);
    PushScaleformMovieFunctionParameterInt(0);
    PushScaleformMovieFunctionParameterInt(0);
    PushScaleformMovieFunctionParameterInt(item.Type);
    PushScaleformMovieFunctionParameterInt(0);
    PushScaleformMovieFunctionParameterBool(false);
    local labels = item.label:SplitLabel()
    BeginTextCommandScaleformString("CELL_EMAIL_BCON");
    for k, v in pairs(labels) do
        AddTextComponentScaleform(v)
    end
    EndTextCommandScaleformString_2();
    PushScaleformMovieFunctionParameterString(item.TextRight);
    if item.Type == 2 then
        PushScaleformMovieFunctionParameterInt(item.Icon);
        PushScaleformMovieFunctionParameterInt(item.IconColor:ToArgb());
        PushScaleformMovieFunctionParameterBool(item.Tick);
    elseif item.Type == 3 then
        PushScaleformMovieFunctionParameterString(item.CrewTag.TAG);
        PushScaleformMovieFunctionParameterBool(false);
    end
    PushScaleformMovieFunctionParameterString(item.LabelFont.FontName);
    PushScaleformMovieFunctionParameterString(item._rightLabelFont.FontName);
    EndScaleformMovieMethod();
end

function MissionDetailsPanel:RemoveItem(idx)
    table.remove(self.Items, idx)
    if self:visible() then
        -- TODO: HANDLE
    end
end
