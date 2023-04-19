BigMessageInstance = setmetatable({}, BigMessageInstance)
BigMessageInstance.__index = BigMessageInstance
BigMessageInstance.__call = function()
    return "BigMessageInstance"
end

---@class BigMessageInstance
---@field public _sc Scaleform
---@field private _start number
---@field private _timer number
---@field private _transition string -- TRANSITION_UP, TRANSITION_OUT, TRANSITION_DOWN supported
---@field private _transitionDuration number -- default: 0.4
---@field private _transitionPreventAutoExpansion boolean -- default: false
---@field public New fun():BigMessageInstance
---@field public Load fun():nil
---@field public Dispose fun(self:BigMessageInstance, force:boolean):nil
---@field public ShowMissionPassedMessage fun(self:BigMessageInstance, msg:string, time:number):nil
---@field public ShowColoredShard fun(self:BigMessageInstance, msg:string, desc:string, textColor:number, bgColor:number, time:number):nil
---@field public ShowOldMessage fun(self:BigMessageInstance, msg:string, time:number):nil
---@field public ShowSimpleShard fun(self:BigMessageInstance, msg:string, subtitle:string, time:number):nil
---@field public ShowRankupMessage fun(self:BigMessageInstance, msg:string, subtitle:string, rank:number, time:number):nil
---@field public ShowWeaponPurchasedMessage fun(self:BigMessageInstance, bigMessage:string, weaponName:string, weaponHash:number, time:number):nil
---@field public ShowMpMessageLarge fun(self:BigMessageInstance, msg:string, time:number):nil
---@field public ShowMpWastedMessage fun(self:BigMessageInstance, msg:string, time:number):nil
---@field public SetTransition fun(self:BigMessageInstance, transition:string, duration:number):nil
---@field public Update fun(self:BigMessageInstance):nil

---Creates a new BigMessageInstance
---@return BigMessageInstance
function BigMessageInstance.New()
    local data = {
        _sc = nil --[[@type Scaleform]],
        _start = 0,
        _timer = 0,
        _transition = "TRANSITION_OUT", -- TRANSITION_UP, TRANSITION_OUT, TRANSITION_DOWN supported
        _transitionDuration = 0.4,
        _transitionPreventAutoExpansion = false
    }
    return setmetatable(data, BigMessageInstance)
end

---Loads the MP_BIG_MESSAGE_FREEMODE scaleform
---@return nil
function BigMessageInstance:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
    local timeout = 1000
    local start = GetGameTimer()
    while not self._sc:IsLoaded() and GetGameTimer() - start < timeout do Citizen.Wait(0) end
end

---Disposes the scaleform
function BigMessageInstance:Dispose()
    self._sc:Dispose()
    self._sc = nil
end

---Runs the SHOW_MISSION_PASSED_MESSAGE method on the scaleform
---@param msg string
---@param time number
---@return nil
function BigMessageInstance:ShowMissionPassedMessage(msg, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_MISSION_PASSED_MESSAGE", false, msg, "", 100, true, 0, true)
    self._timer = time
end

---Runs the SHOW_SHARD_CENTERED_MP_MESSAGE message on the scaleform
---@param msg string
---@param desc string
---@param textColor Colours
---@param bgColor Colours
---@param time number
---@return nil
function BigMessageInstance:ShowColoredShard(msg, desc, textColor, bgColor, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_SHARD_CENTERED_MP_MESSAGE", false, msg, desc, bgColor, textColor)
    self._timer = time
end

---Runs the SHOW_MISSION_PASSED_MESSAGE method on the scaleform
---@param msg string
---@param time number
---@return nil
function BigMessageInstance:ShowOldMessage(msg, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_MISSION_PASSED_MESSAGE", false, msg)
    self._timer = time
end

---Runs the SHOW_SHARD_CREW_RANKUP_MP_MESSAGE method on the scaleform
---@param msg string
---@param subtitle string
---@param time number
---@return nil
function BigMessageInstance:ShowSimpleShard(msg, subtitle, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_SHARD_CREW_RANKUP_MP_MESSAGE", false, msg, subtitle)
    self._timer = time
end

---Runs the SHOW_BIG_MP_MESSAGE method on the scaleform
---@param msg string
---@param subtitle string
---@param rank number
---@param time number
---@return nil
function BigMessageInstance:ShowRankupMessage(msg, subtitle, rank, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_BIG_MP_MESSAGE", false, msg, subtitle, rank, "", "")
    self._timer = time
end

---Runs the SHOW_WEAPON_PURCHASED method on the scaleform
---@param bigMessage string
---@param weaponName string
---@param weaponHash number
---@param time number
---@return nil
function BigMessageInstance:ShowWeaponPurchasedMessage(bigMessage, weaponName, weaponHash, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_WEAPON_PURCHASED", false, bigMessage, weaponName, weaponHash, "", 100)
    self._timer = time
end

---Runs the SHOW_CENTERED_MP_MESSAGE_LARGE method on the scaleform
---@param msg string
---@param time number
---@return nil
function BigMessageInstance:ShowMpMessageLarge(msg, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_CENTERED_MP_MESSAGE_LARGE", false, msg, "", 100, true, 100)
    self._sc:CallFunction("TRANSITION_IN", false)
    self._timer = time
end

---Runs the SHOW_SHARD_WASTED_MP_MESSAGE method on the scaleform
---@param msg string
---@param subtitle string
---@param time number
---@return nil
function BigMessageInstance:ShowMpWastedMessage(msg, subtitle, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_SHARD_WASTED_MP_MESSAGE", false, msg, subtitle)
    self._timer = time
end

---Sets the transition and duration for the scaleform when it is disposed
---@param transition string -- TRANSITION_UP, TRANSITION_OUT, TRANSITION_DOWN supported
---@param duration number|nil -- default 0.4
---@param preventAutoExpansion boolean|nil -- default false
---@return nil
function BigMessageInstance:SetTransition(transition, duration, preventAutoExpansion)
    if transition == nil then transition = "TRANSITION_OUT" end

    if transition ~= "TRANSITION_UP" and transition ~= "TRANSITION_OUT" and transition ~= "TRANSITION_DOWN" then
        transition = "TRANSITION_OUT"
    end

    self._transition = transition

    if duration == nil then duration = 0.4 end
    self._transitionDuration = duration + .0

    if preventAutoExpansion == nil then preventAutoExpansion = false end
    self._transitionPreventAutoExpansion = preventAutoExpansion
end

---Renders the scaleform and checks if the timer has expired
---@return nil
function BigMessageInstance:Update()
    self._sc:Render2D()
    if self._start ~= 0 and GetGameTimer() - self._start > self._timer then
        self._sc:CallFunction(self._transition, false, self._transitionDuration, self._transitionPreventAutoExpansion)
        self._start = 0
        self:Dispose()
    end
end
