TextTimerBar = setmetatable({}, TextTimerBar)
TextTimerBar.__index = TextTimerBar
TextTimerBar.__call = function()
    return "TimerBarBase", "TextTimerBar"
end

function TextTimerBar.New(label, text, captionColor)
    if captionColor == nil then captionColor = {R = 240, G = 240, B = 240, A = 255} end
    local _data = {
        _label = label or "",
        _caption = text or "",
        _captionColor = captionColor,
        _enabled = true,
    }
    return setmetatable(_data, TextTimerBar)
end

function TextTimerBar:Label(label)
    if label == nil then
        return self._label
    else
        self._label = label
    end
end
function TextTimerBar:Caption(caption)
    if caption == nil then
        return self._caption
    else
        self._caption = caption
    end
end
function TextTimerBar:Label(color)
    if color == nil then
        return self._captionColor
    else
        self._captionColor = color
    end
end
function TextTimerBar:Enabled(bool)
    if bool == nil then
        return self._enabled
    else
        self._enabled = bool
    end
end

function TextTimerBar:Draw(interval)
    if not self._enabled then return end
    local resx, resy = self:ResolutionMaintainRatio()
    local safex, safey = self:SafezoneBounds()

    UIResText.New(self._label, resx - safex - 180, resy - safey - (30 + (4 * interval)), 0.3, 240, 240, 240, 255, 0, 2):Draw()
    Sprite.New("timerbars", "all_black_bg", resx - safex - 298, resy - safey - (40 + (4 * interval)), 300, 37, 0.0, 255, 255, 255, 180):Draw()
    UIResText.New(self._caption, resx - safex - 10, resy - safey - (42 + (4 * interval)), 0.5, self._captionColor.R, self._captionColor.G, self._captionColor.B, self._captionColor.A, 0, 2):Draw()

    HideHudComponentThisFrame(6);
    HideHudComponentThisFrame(7);
    HideHudComponentThisFrame(9);
end

function TextTimerBar:ResolutionMaintainRatio()
    local screenw,screenh = GetActiveScreenResolution()
    local ratio = screenw / screenh
    local width = 1080 * ratio
    return width, 1080
end

function TextTimerBar:SafezoneBounds()
    local t = GetSafeZoneSize();
    local  g = math.round(t, 2);
    g = (g * 100) - 90;
    g = 10 - g;

    local screenw = 720 * GetScreenAspectRatio(false)
    local screenh = 720
    local ratio = screenw / screenh;
    local wmp = ratio * 5.4

    return math.round(g * wmp), math.round(g * 5.4)
end