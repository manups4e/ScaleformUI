RadialMenu = setmetatable({}, RadialMenu)
RadialMenu.__index = RadialMenu
RadialMenu.__call = function()
    return "RadialMenu"
end

---@class RadialMenu: Scaleform
---@field public Segments table
---@field public InstructionalButtons table
---@field public OnMenuOpen fun(menu:RadialMenu, data:any)
---@field public OnMenuClose fun(menu:RadialMenu)
---@field public OnSegmentHighlight fun(segment:SegmentItem)
---@field public OnSegmentIndexChange fun(segment:SegmentItem, index:number)
---@field public OnSegmentSelect fun(segment:SegmentItem)
---@field public currentSelection number
---@field public oldAngle number
---@field public changed boolean
---@field public enable3D boolean
---@field public offset table
---@field public AddInstructionButton fun(button:InstructionalButton)
---@field public RemoveInstructionButton fun(button:table)
---@field public Enable3D fun(enable:boolean)
---@field public CurrentSelection fun(index:number)
---@field public Visible fun(bool:boolean)
---@field public BuildMenu fun()
---@field public ProcessMouse fun()
---@field public ProcessControl fun()
---@field public SwitchTo fun(newMenu:RadialMenu, newMenuCurrentSelection:number, inheritOldMenuParams:boolean)
---@field public GoBack fun()
---@field public Select fun()
---@field public Draw fun()
---@field public New fun(x:number, y:number):RadialMenu

---New
---@param x number
---@param y number
---@return RadialMenu
function RadialMenu.New(x, y)
    local X, Y = tonumber(x) or 0, tonumber(y) or 0
    local _rad = {
        _visible = false,
        currentSelection = 1,
        oldAngle = 0,
        changed = false,
        enable3D = true,
        offset = { x = X, y = Y },
        Segments = {
            RadialSegment.New(1),
            RadialSegment.New(2),
            RadialSegment.New(3),
            RadialSegment.New(4),
            RadialSegment.New(5),
            RadialSegment.New(6),
            RadialSegment.New(7),
            RadialSegment.New(8),
        },
        InstructionalButtons = {
            InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 176, 176, -1),
            InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 177, 177, -1)
        },
        OnMenuOpen = function(menu, data)
        end,
        OnMenuClose = function(menu)
        end,
        OnSegmentHighlight = function(segment)
        end,
        OnSegmentIndexChange = function(segment, index)
        end,
        OnSegmentSelect = function(segment)
        end
    }
    local meta = setmetatable(_rad, RadialMenu)
    meta.Segments[1].Parent = meta
    meta.Segments[2].Parent = meta
    meta.Segments[3].Parent = meta
    meta.Segments[4].Parent = meta
    meta.Segments[5].Parent = meta
    meta.Segments[6].Parent = meta
    meta.Segments[7].Parent = meta
    meta.Segments[8].Parent = meta
    return meta
end

---AddInstructionButton
---@param button InstructionalButton
function RadialMenu:AddInstructionButton(button)
    if type(button) == "table" then
        self.InstructionalButtons[#self.InstructionalButtons + 1] = button
        if self:Visible() and not ScaleformUI.Scaleforms.Warning:IsShowing() then
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
        end
    end
end

---RemoveInstructionButton
---@param button table
function RadialMenu:RemoveInstructionButton(button)
    if type(button) == "table" then
        for i = 1, #self.InstructionalButtons do
            if button == self.InstructionalButtons[i] then
                table.remove(self.InstructionalButtons, i)
                break
            end
        end
    else
        if tonumber(button) then
            if self.InstructionalButtons[tonumber(button)] then
                table.remove(self.InstructionalButtons, tonumber(button))
            end
        end
    end
    if self:Visible() and not ScaleformUI.Scaleforms.Warning:IsShowing() then
        ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
    end
end

function RadialMenu:Enable3D(enable)
    if enable ~= nil then
        self.enable3D = enable
        if self:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("ENABLE_3D", enable)
        end
    else
        return self.enable3D
    end
end

function RadialMenu:CurrentSelection(index)
    if index ~= nil then
        self.currentSelection = index
        if self:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("SET_POINTER", (index - 1), true)
        end
    else
        return self.currentSelection or 1
    end
end

function RadialMenu:Visible(bool)
    if bool ~= nil then
        self._visible = bool
        if bool then
            self:BuildMenu()
            MenuHandler._currentMenu = self
            MenuHandler.ableToDraw = true
            self.OnMenuOpen(self)
            if BreadcrumbsHandler:Count() == 0 then
                BreadcrumbsHandler:Forward(self)
            end
        else
            ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
            self.OnMenuClose(self)
            ScaleformUI.Scaleforms._radialMenu:CallFunction("CLEAR_ALL")
            MenuHandler.ableToDraw = false
        end
    else
        return self._visible
    end
end

function RadialMenu:BuildMenu()
    ScaleformUI.Scaleforms._radialMenu:CallFunction("CREATE_MENU", self:Enable3D(), (1280 / 2) + self.offset.x, ((720 / 2) - 60) + self.offset.y)
    for i = 1, 8 do
        local seg = self.Segments[i]
        for j = 1, #seg.Items do
            local item = seg.Items[j]
            ScaleformUI.Scaleforms._radialMenu:CallFunction("ADD_ITEM", i - 1, item:Label(), item:Description(), item:TextureDict(), item:TextureName(), item:TextureWidth(), item:TextureHeight(), item:Color(), item.qtty, item.max)
        end
    end
    ScaleformUI.Scaleforms._radialMenu:CallFunction("LOAD_MENU", self.currentSelection - 1, self.Segments[1]:CurrentSelection() - 1, self.Segments[2]:CurrentSelection() - 1, self.Segments[3]:CurrentSelection() - 1, self.Segments[4]:CurrentSelection() - 1, self.Segments[5]:CurrentSelection() - 1, self.Segments[6]:CurrentSelection() - 1, self.Segments[7]:CurrentSelection() - 1, self.Segments[8]:CurrentSelection() - 1)
end

function RadialMenu:ProcessMouse()
end

function RadialMenu:ProcessControl()
    if not self:Visible() then
        return
    end
    if UpdateOnscreenKeyboard() == 0 or IsWarningMessageActive() or ScaleformUI.Scaleforms.Warning:IsShowing() or BreadcrumbsHandler.SwitchInProgress then return end

    Controls:ToggleAll(false)
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)

    local x = math.floor(GetDisabledControlNormal(2, 13) * 1000)
    local y = math.floor(GetDisabledControlNormal(2, 12) * 1000)

    if x > 0 and y == 0 then y = 1 end
    local angle = 0
    local normalized_angle = 0
    local finalizedAngle = -1
    if x > 400 or y > 400 or x < -400 or y < -400 then
        angle = math.atan(y, x) * (180 / math.pi)
        if angle == 0 then
            normalized_angle = 0
        else
            normalized_angle = (angle + 450) % 360
        end
        if angle == 0 then
            finalizedAngle = -1
        else
            finalizedAngle = math.floor(normalized_angle / 45)
        end

        if self.currentSelection ~= finalizedAngle + 1 and finalizedAngle ~= -1 and (normalized_angle > self.oldAngle + 45 or normalized_angle < self.oldAngle - 45) then
            if not self.changed then
                self.Segments[self.currentSelection].Selected = false
                self.currentSelection = finalizedAngle + 1
                self.oldAngle = normalized_angle
                self.changed = true
            end
        end

        if self.changed then
            self.Segments[self.currentSelection].Selected = true
            self.OnSegmentHighlight(self.Segments[self.currentSelection])
            ScaleformUI.Scaleforms._radialMenu:CallFunction("SET_POINTER", finalizedAngle, true)
            self.changed = false
        end
    end

    if IsDisabledControlJustPressed(0, 15) then
        Citizen.CreateThread(function()
            local sel = self.Segments[self.currentSelection]:CycleItems(-1)
            self.OnSegmentIndexChange(self.Segments[self.currentSelection], sel)
        end)
    end

    if IsDisabledControlJustPressed(0, 14) then
        Citizen.CreateThread(function()
            local sel = self.Segments[self.currentSelection]:CycleItems(1)
            self.OnSegmentIndexChange(self.Segments[self.currentSelection], sel)
        end)
    end

    if IsDisabledControlJustPressed(0, 202) then
        self:GoBack()
    end

    if IsDisabledControlJustPressed(0, 201) then
        self:Select()
    end
end

function RadialMenu:SwitchTo(newMenu, newMenuCurrentSelection, inheritOldMenuParams)
    MenuHandler:SwitchTo(self, newMenu, newMenuCurrentSelection, inheritOldMenuParams)
end

function RadialMenu:GoBack()
    if BreadcrumbsHandler:CurrentDepth() == 1 then
        self:Visible(false)
        BreadcrumbsHandler:Clear()
    else
        BreadcrumbsHandler.SwitchInProgress = true
        local prevMenu = BreadcrumbsHandler:PreviousMenu()
        BreadcrumbsHandler:Backwards()
        self:Visible(false)
        prevMenu.menu:Visible(true)
        BreadcrumbsHandler.SwitchInProgress = false
    end
end

function RadialMenu:Select()
    self.OnSegmentSelect(self.Segments[self.currentSelection])
end

function RadialMenu:Draw()
    HideHudComponentThisFrame(19)
    ScaleformUI.Scaleforms._radialMenu:Render2D()
end
