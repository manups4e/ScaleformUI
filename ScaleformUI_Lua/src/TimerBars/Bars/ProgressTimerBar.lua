---@diagnostic disable: missing-parameter -- false positive

ProgressTimerBar = setmetatable({}, ProgressTimerBar)
ProgressTimerBar.__index = ProgressTimerBar
ProgressTimerBar.__call = function()
    return "TimerBarBase", "ProgressTimerBar"
end

function ProgressTimerBar.New(label, backgroundColor, foregroundColor, percentage, time)
    if backgroundColor == nil then backgroundColor = { R = 112, G = 25, B = 25, A = 255 } end
    if foregroundColor == nil then foregroundColor = { R = 224, G = 50, B = 50, A = 255 } end
    if percentage == nil then percentage = 0 end
    if percentage > 1 then percentage = 1 end
    if percentage < 0 then percentage = 0 end
    if time == nil then time = 0 end
    if time < 0 then time = 0 end
    local _data = {
        _label = label or "",
        _percentage = percentage or 0,
        _maxTime = time or 0,
        _time = GetGameTimer(),
        _backgroundColor = backgroundColor or { R = 112, G = 25, B = 25, A = 255 }, --darkred
        _foregroundColor = foregroundColor or { R = 224, G = 50, B = 50, A = 255 }, -- red
        _backgroundRect = UIResRectangle.New(0, 0, 150, 15, backgroundColor.R or 112, backgroundColor.G or 25,
            backgroundColor.B or 25, backgroundColor.A or 255),
        _foregroundRect = UIResRectangle.New(0, 0, 0, 15, foregroundColor.R or 224, foregroundColor.G or 50,
            foregroundColor.B or 50, foregroundColor.A or 255),
        _enabled = true,
        _labelFont = Font.CHALET_LONDON,
        Handle = nil,
    }
    return setmetatable(_data, ProgressTimerBar)
end

function ProgressTimerBar:Label(label)
    if label == nil then
        return self._label
    else
        self._label = label
    end
end

function ProgressTimerBar:LabelFont(font)
    if font == nil then
        return self._labelFont
    else
        self._labelFont = font
    end
end

function ProgressTimerBar:BackgroundColor(color)
    if color == nil then
        return self._backgroundColor
    else
        self._backgroundColor = color
    end
end

function ProgressTimerBar:ForegroundColor(color)
    if color == nil then
        return self._foregroundColor
    else
        self._foregroundColor = color
    end
end

function ProgressTimerBar:Percentage(val)
    if val == nil then
        return self._percentage
    else
        self._percentage = val
        if self._maxTime > 0 then
            self._time = (self._maxTime / 1.0) * val
        end
    end
end

function ProgressTimerBar:Time()
    return self._time
end

function ProgressTimerBar:Enabled(bool)
    if bool == nil then
        return self._enabled
    else
        if bool then
            self._time = GetGameTimer()
        end
        self._enabled = bool
    end
end

function ProgressTimerBar:Draw(interval)
    if not self._enabled then return end
    local resx, resy = ResolutionMaintainRatio()
    local safex, safey = SafezoneBounds()

    if self._percentage > 0 and self._maxTime > 0 then
        local t = GetGameTimer() - self._time
        self._percentage = 1.0 - (t / (self._maxTime / 1.0))
        if self._percentage < 0 then self._percentage = 0 end
    end

    UIResText.New(self:Label(), resx - safex - 180, resy - safey - (30 + (4 * interval)), 0.3, 240, 240, 240, 255,
        self._labelFont, 2):Draw()

    Sprite.New("timerbars", "all_black_bg", resx - safex - 298, resy - safey - (40 + (4 * interval)), 300, 37, 0.0, 255,
        255, 255, 180):Draw()

    local startx, starty = resx - safex - 160, resy - safey - (28 + (4 * interval))
    self._backgroundRect:Position(startx, starty)
    self._foregroundRect:Position(startx, starty)
    self._foregroundRect:Size(150 * self._percentage, 15)

    -- in case someone decides to change color on the fly..
    self._backgroundRect:Colour(self._backgroundColor.R, self._backgroundColor.G, self._backgroundColor.B,
        self._backgroundColor.A)
    self._foregroundRect:Colour(self._foregroundColor.R, self._foregroundColor.G, self._foregroundColor.B,
        self._foregroundColor.A)

    self._backgroundRect:Draw()
    self._foregroundRect:Draw()

    HideHudComponentThisFrame(6);
    HideHudComponentThisFrame(7);
    HideHudComponentThisFrame(9);
end
