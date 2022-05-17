BigMessageInstance = {}

local m = {}
m = setmetatable({}, m)

m.__call = function()
    return true
end
m.__index = m

function BigMessageInstance.New()
    local _sc = 0
    local _start = 0
    local _timer = 0
    local data = {_sc = _sc, _start = _start, _timer = _timer}
    return setmetatable(data, m)
end

function m:Load()
    if self._sc ~= 0 then return end
    self._sc = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
    local timeout = 1000
    local start = GetGameTimer()
    while not self._sc:IsLoaded() and GetGameTimer() - start < timeout do Citizen.Wait(0) end
end

function m:Dispose()
    self._sc:Dispose()
    self._sc = 0
end

function m:ShowMissionPassedMessage(msg, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_MISSION_PASSED_MESSAGE", false, msg, "", 100, true, 0, true)
    self._timer = time
end

function m:ShowColoredShard(msg, desc, textColor, bgColor, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_SHARD_CENTERED_MP_MESSAGE", false, msg, desc, bgColor, textColor)
    self._timer = time
end

function m:ShowOldMessage(msg, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_MISSION_PASSED_MESSAGE", false, msg)
    self._timer = time
end

function m:ShowSimpleShard(msg, subtitle, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_SHARD_CREW_RANKUP_MP_MESSAGE", false, subtitle)
    self._timer = time
end

function m:ShowRankupMessage(msg, subtitle, rank, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_BIG_MP_MESSAGE", false, msg, subtitle, rank, "", "")
    self._timer = time
end

function m:ShowWeaponPurchasedMessage(bigMessage, weaponName, weaponHash, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_WEAPON_PURCHASED", false, bigMessage, weaponName, weaponHash, "", 100)
    self._timer = time
end

function m:ShowMpMessageLarge(msg, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_CENTERED_MP_MESSAGE_LARGE", false, msg, "", 100, true, 100)
    self._sc:CallFunction("TRANSITION_IN", false)
    self._timer = time
end

function m:ShowMpWastedMessage(msg, subtitle, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_SHARD_WASTED_MP_MESSAGE", false, msg, subtitle)
    self._timer = time
end

function m:Update()
    if self._sc == 0 or IsPauseMenuActive() then return end
    self._sc:Render2D()
    if self._start ~= 0 and GetGameTimer() - self._start > self._timer then
        self._sc:CallFunction("TRANSITION_OUT", false)
        self._start = 0
        self:Dispose()
    end
end