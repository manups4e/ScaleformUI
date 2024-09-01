UIRadioMenu = setmetatable({}, UIRadioMenu)
UIRadioMenu.__index = UIRadioMenu
UIRadioMenu.__call = function()
    return "UIRadioMenu"
end

---@class UIRadioMenu: Scaleform
---@field public visible boolean
---@field public isAnimating boolean
---@field public currentSelection number
---@field public oldAngle number
---@field public changed boolean
---@field public Stations table
---@field public _AnimDirection number
---@field public _animDuration number
---@field public InstructionalButtons table
---@field public OnMenuOpen fun(menu: UIRadioMenu, data: any)
---@field public OnMenuClose fun(menu: UIRadioMenu)
---@field public OnIndexChange fun(index: number)
---@field public OnStationSelect fun(segment: any, index: number)
---@field public AnimDirection fun(direction: number)
---@field public AnimationDuration fun(time: number)
---@field public AddInstructionButton fun(button: table)
---@field public RemoveInstructionButton fun(button: table)
---@field public CurrentSelection fun(index: number)
---@field public Visible fun(bool: boolean)
---@field public BuildMenu fun()
---@field public AddStation fun(station: table)
---@field public ProcessMouse fun()
---@field public ProcessControl fun()
---@field public SwitchTo fun(newMenu: UIRadioMenu, newMenuCurrentSelection: number, inheritOldMenuParams: boolean)
---@field public GoBack fun()
---@field public Select fun()
---@field public Draw fun()
---@field private _visible boolean
---@field private _animating boolean

---New
---@return UIRadioMenu
function UIRadioMenu.New()
    local data = {
        visible = false,
        isAnimating = false,
        currentSelection = 1,
        oldAngle = 0,
        changed = false,
        Stations = {},
        _AnimDirection = -1,
        _animDuration = 1.0,
        InstructionalButtons = {
            InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 176, 176, -1),
            InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 177, 177, -1)
        },
        OnMenuOpen = function(menu, data)
        end,
        OnMenuClose = function(menu)
        end,
        OnIndexChange = function(index)
        end,
        OnStationSelect = function(segment, index)
        end
    }
    return setmetatable(data, UIRadioMenu)
end

function UIRadioMenu:AnimDirection(direction)
    if direction == nil then
        return self._AnimDirection
    else
        self._AnimDirection = direction
    end
end

function UIRadioMenu:AnimationDuration(time)
    if time == nil then
        return self._animDuration
    else
        self._animDuration = time
    end
end

---AddInstructionButton
---@param button InstructionalButton
function UIRadioMenu:AddInstructionButton(button)
    if type(button) == "table" then
        self.InstructionalButtons[#self.InstructionalButtons + 1] = button
        if self:Visible() and not ScaleformUI.Scaleforms.Warning:IsShowing() then
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
        end
    end
end

---RemoveInstructionButton
---@param button table
function UIRadioMenu:RemoveInstructionButton(button)
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

function UIRadioMenu:CurrentSelection(index)
    if index ~= nil then
        self.currentSelection = index
        if self:Visible() then
            ScaleformUI.Scaleforms._radioMenu:CallFunction("SET_POINTER", (index - 1), true)
        end
    else
        return self.currentSelection or 1
    end
end

function UIRadioMenu:Visible(bool)
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
            ScaleformUI.Scaleforms._radioMenu:CallFunction("CLEAR_ALL")
            MenuHandler.ableToDraw = false
        end
    else
        return self._visible
    end
end

function UIRadioMenu:BuildMenu()
    Citizen.CreateThread(function()
        ScaleformUI.Scaleforms._radioMenu:CallFunction("CREATE_MENU", true, 0, 0)
        for k, v in pairs(self.Stations) do
            ScaleformUI.Scaleforms._radioMenu:CallFunction("ADD_ITEM", v.TextureDictionary, v.TextureName, v.StationName, v.Artist, v.Track)
        end
        ScaleformUI.Scaleforms._radioMenu:CallFunction("LOAD_MENU")
        self:animateIn()
    end)
end

function UIRadioMenu:AddStation(station)
    station.Parent = self
    table.insert(self.Stations, station)
end

function UIRadioMenu:ProcessMouse()
end

function UIRadioMenu:ProcessControl()
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
        local step = 360 / #self.Stations
        angle = math.atan(y, x) * (180 / math.pi)
        if angle == 0 then
            normalized_angle = 0
        else
            normalized_angle = (angle + 450) % 360
        end
        if angle == 0 then
            finalizedAngle = -1
        else
            finalizedAngle = math.floor(normalized_angle / step)
        end

        if self.currentSelection ~= finalizedAngle + 1 and finalizedAngle ~= -1 and (normalized_angle > self.oldAngle + step or normalized_angle < self.oldAngle - step) then
            if not self.changed then
                self.Stations[self.currentSelection].Selected = false
                self.currentSelection = finalizedAngle + 1
                self.oldAngle = normalized_angle
                self.changed = true
            end
        end

        if self.changed then
            self.Stations[self.currentSelection].Selected = true
            self.OnIndexChange(self.currentSelection)
            ScaleformUI.Scaleforms._radioMenu:CallFunction("SET_POINTER", finalizedAngle, true)
            self.changed = false
        end
    end

    if IsDisabledControlJustPressed(0, 202) then
        self:GoBack()
    end

    if IsDisabledControlJustPressed(0, 201) then
        self:Select()
    end
end

function UIRadioMenu:SwitchTo(newMenu, newMenuCurrentSelection, inheritOldMenuParams)
    MenuHandler:SwitchTo(self, newMenu, newMenuCurrentSelection, inheritOldMenuParams)
end

function UIRadioMenu:GoBack()
    Citizen.CreateThread(function()
        self:animateOut()
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
    end)
end

function UIRadioMenu:Select()
    self.OnStationSelect(self.Stations[self.currentSelection], self.currentSelection)
end

function UIRadioMenu:Draw()
    HideHudComponentThisFrame(19)
    ScaleformUI.Scaleforms._radioMenu:Render2D()
end

function UIRadioMenu:animateIn()
    ScaleformUI.Scaleforms._radioMenu:CallFunction("ANIMATE_IN", self._animDuration, self._AnimDirection, "zoom")
    repeat
        Citizen.Wait(0)
        local return_value = ScaleformUI.Scaleforms._radioMenu:CallFunctionAsyncReturnBool("GET_IS_ANIMATING", true) --[[@as number]]
        self.isAnimating = GetScaleformMovieMethodReturnValueBool(return_value)
    until not self.isAnimating
end

function UIRadioMenu:animateOut()
    ScaleformUI.Scaleforms._radioMenu:CallFunction("ANIMATE_OUT", self._animDuration, self._AnimDirection, "zoom")
    repeat
        Citizen.Wait(0)
        local return_value = ScaleformUI.Scaleforms._radioMenu:CallFunctionAsyncReturnBool("GET_IS_ANIMATING", true) --[[@as number]]
        self.isAnimating = GetScaleformMovieMethodReturnValueBool(return_value)
    until not self.isAnimating
end