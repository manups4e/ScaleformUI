BigFeedInstance = setmetatable({}, BigFeedInstance)
BigFeedInstance.__index = BigFeedInstance
BigFeedInstance.__call = function()
    return "BigFeedInstance"
end

function BigFeedInstance.New()
    local data = {
        _sc = nil --[[@type Scaleform]],
        _title = "",
        _subtitle = "",
        _bodyText = "",
        _txn = "",
        _txd = "",
        _enabled = false,
        _rightAligned = false,
        _disabledNotifications = false,
    }
    return setmetatable(data, BigFeedInstance)
end

function BigFeedInstance:Title(title)
    if title then
        self._title = tostring(title)
        if self._enabled then
            self:UpdateInfo()
        end
    else
        return self._title
    end
end

function BigFeedInstance:Subtitle(subtitle)
    if subtitle then
        self._subtitle = tostring(subtitle)
        if self._enabled then
            self:UpdateInfo()
        end
    else
        return self._subtitle
    end
end

function BigFeedInstance:BodyText(body)
    if body then
        self._bodyText = tostring(body)
        if self._enabled then
            self:UpdateInfo()
        end
    else
        return self._bodyText
    end
end

function BigFeedInstance:Texture(txn, txd)
    if txn and txd then
        self._txn = txn
        self._txd = txd
        if self._enabled then
            self._sc:CallFunction("SET_BIGFEED_IMAGE", false, txd, txn)
            self:UpdateInfo()
        end
    else
        return {txd = self._txd, txn = self._txn}
    end
end

function BigFeedInstance:Enabled(enabled)
    if enabled ~= nil then
        self._enabled = ToBool(enabled)
        if enabled == true then
            self._sc:CallFunction("SETUP_BIGFEED", false, self._rightAligned)
            self._sc:CallFunction("HIDE_ONLINE_LOGO", false)
            self._sc:CallFunction("FADE_IN_BIGFEED", false)
            if self:DisabledNotifications() then
                ThefeedCommentTeleportPoolOn()
            end
            self:UpdateInfo()
        else
            self._sc:CallFunction("END_BIGFEED", false)
            if self:DisabledNotifications() then
                ThefeedCommentTeleportPoolOff()
            end
        end
    else
        return self._enabled
    end
end

function BigFeedInstance:UpdateInfo()
    if not self._enabled then return end
    AddTextEntry("scaleform_ui_bigFeed", self._bodyText)
    BeginScaleformMovieMethod(self._sc.handle, "SET_BIGFEED_INFO")
    PushScaleformMovieFunctionParameterString("")
    BeginTextCommandScaleformString("scaleform_ui_bigFeed")
    EndTextCommandScaleformString_2()
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterString(self._txn)
    PushScaleformMovieFunctionParameterString(self._txd)
    PushScaleformMovieFunctionParameterString(self._subtitle)
    PushScaleformMovieFunctionParameterString("")
    PushScaleformMovieFunctionParameterString(self._title)
    PushScaleformMovieFunctionParameterInt(0)
    EndScaleformMovieMethod()
end

function BigFeedInstance:Update()
    self._sc:Render2D()
end

function BigFeedInstance:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("GTAV_ONLINE")
    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end
    self._sc:CallFunction("HIDE_ONLINE_LOGO", false)
end

function BigFeedInstance:Dispose()
    self._sc:Dispose()
    self._sc = nil
end