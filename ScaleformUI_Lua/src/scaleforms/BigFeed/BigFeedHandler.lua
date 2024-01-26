BigFeedInstance = setmetatable({
    _sc = nil --[[@type Scaleform]],
    _title = "",
    _subtitle = "",
    _bodyText = "",
    _txn = "",
    _txd = "",
    _enabled = false,
    _rightAligned = false,
    _disabledNotifications = false,
}, BigFeedInstance)
BigFeedInstance.__index = BigFeedInstance
BigFeedInstance.__call = function()
    return "BigFeedInstance"
end

---@class BigFeedInstance
---@field public _sc Scaleform
---@field private _title string
---@field private _subtitle string
---@field private _bodyText string
---@field private _txn string
---@field private _txd string
---@field public _enabled boolean
---@field private _rightAligned boolean
---@field private _disabledNotifications boolean
---@field public Title fun(self:BigFeedInstance, title:string):string
---@field public Subtitle fun(self:BigFeedInstance, subtitle:string):string
---@field public BodyText fun(self:BigFeedInstance, body:string):string
---@field public Texture fun(self:BigFeedInstance, textureName:string, textureDictionary:string):table<string, string>
---@field public Enabled fun(self:BigFeedInstance, enabled:boolean):boolean
---@field public UpdateInfo fun(self:BigFeedInstance):nil
---@field public Update fun(self:BigFeedInstance):nil
---@field public Load fun(self:BigFeedInstance):nil
---@field public Dispose fun(self:BigFeedInstance):nil


---Sets the title of the BigFeedInstance, if no title is provided it will return the current title
---@param title? string
---@return string
function BigFeedInstance:Title(title)
    if title == nil then return self._title end
    self._title = tostring(title)
    if self._enabled then
        self:UpdateInfo()
    end

    return self._title
end

---Sets the subtitle of the BigFeedInstance, if no subtitle is provided it will return the current subtitle
---@param subtitle? string
---@return string
function BigFeedInstance:Subtitle(subtitle)
    if subtitle == nil then return self._subtitle end
    self._subtitle = tostring(subtitle)
    if self._enabled then
        self:UpdateInfo()
    end
    return self._subtitle
end

---Sets the body text of the BigFeedInstance, if no body text is provided it will return the current body text
---@param body? string
---@return string
function BigFeedInstance:BodyText(body)
    if body == nil then return self._bodyText end
    self._bodyText = tostring(body)
    if self._enabled then
        self:UpdateInfo()
    end
    return self._bodyText
end

---Sets the BigFeedInstance to be right aligned, if no state is provided it will return the current state
---@param rightAligned? boolean
---@return boolean
function BigFeedInstance:RightAligned(rightAligned)
    if rightAligned == nil then return self._rightAligned end
    self._rightAligned = ToBool(rightAligned)
    if self._enabled then
        self._sc:CallFunction("SETUP_BIGFEED", self._rightAligned)
        self:UpdateInfo()
    end
    return self._rightAligned
end

---Sets the texture of the BigFeedInstance, if no texture is provided it will return the current texture
---@param textureName? string
---@param textureDictionary? string
---@return table<string, string>
function BigFeedInstance:Texture(textureName, textureDictionary)
    if textureName == nil and textureDictionary == nil then return { txd = self._txd, txn = self._txn } end
    self._txn = textureName
    self._txd = textureDictionary
    if self._enabled then
        self._sc:CallFunction("SET_BIGFEED_IMAGE", textureDictionary, textureName)
        self:UpdateInfo()
    end
    return { txd = self._txd, txn = self._txn }
end

---Toggles the BigFeedInstance on or off, if a state is not provided it will return the current enabled state
---@param enabled? boolean
---@return boolean
function BigFeedInstance:Enabled(enabled)
    if enabled == nil then return self._enabled end
    self._enabled = ToBool(enabled)
    if enabled == true then
        self:Load()
        self._sc:CallFunction("SETUP_BIGFEED", self._rightAligned)
        self._sc:CallFunction("HIDE_ONLINE_LOGO")
        self._sc:CallFunction("FADE_IN_BIGFEED")
        if self._disabledNotifications then
            ThefeedCommentTeleportPoolOn()
        end
        self:UpdateInfo()
    else
        self._sc:CallFunction("END_BIGFEED")
        if self._disabledNotifications then
            ThefeedCommentTeleportPoolOff()
        end
        self:Dispose()
    end
    return self._enabled
end

function BigFeedInstance:DisableNotifications(bool)
    if bool == nil then
        return self._disabledNotifications
    else
        self._disabledNotifications = bool
    end
end

---Updates the information displayed on the BigFeedInstance
---@return nil
function BigFeedInstance:UpdateInfo()
    if self._sc == nil or not self._enabled then return end
    AddTextEntry("scaleform_ui_bigFeed", self._bodyText)
    BeginScaleformMovieMethod(self._sc.handle, "SET_BIGFEED_INFO")
    ScaleformMovieMethodAddParamTextureNameString("")
    BeginTextCommandScaleformString("scaleform_ui_bigFeed")
    EndTextCommandScaleformString_2()
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamTextureNameString(self._txn)
    ScaleformMovieMethodAddParamTextureNameString(self._txd)
    ScaleformMovieMethodAddParamTextureNameString(self._subtitle)
    ScaleformMovieMethodAddParamTextureNameString("")
    ScaleformMovieMethodAddParamTextureNameString(self._title)
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()
end

---Draws the BigFeedInstance on the screen
---@return nil
function BigFeedInstance:Update()
    if self._sc == nil or self._sc == 0 or not self._enabled then return end
    self._sc:Render2D()
end

---Loads the BigFeedInstance scaleform
---@return nil
function BigFeedInstance:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("GTAV_ONLINE")
    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end
    self._sc:CallFunction("HIDE_ONLINE_LOGO")
end

---Disposes the BigFeedInstance scaleform
function BigFeedInstance:Dispose()
    self._sc:Dispose()
    self._sc = nil
end
