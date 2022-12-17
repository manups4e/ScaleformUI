MidMessageInstance = {}

local m = {}
m = setmetatable({}, m)

m.__call = function()
    return true
end
m.__index = m

function MidMessageInstance.New()
    local _sc = 0
    local _start = 0
    local _timer = 0
    local _hasAnimatedOut = false
    local data = {_sc = _sc, _start = _start, _timer = _timer, _hasAnimatedOut = _hasAnimatedOut}
    return setmetatable(data, m)
end

function m:Load()
    if self._sc ~= 0 then return end
    self._sc = Scaleform.Request("MIDSIZED_MESSAGE")
    local timeout = 1000
    local start = GetGameTimer()
    while not self._sc:IsLoaded() and GetGameTimer() - start < timeout do Citizen.Wait(0) end
end

function m:Dispose()
    self._sc:Dispose()
    self._sc = 0
end

function m:ShowColoredShard(msg, desc, bgColor, useDarkerShard, useCondensedShard, time)
    if time == nil then  time = 5000 end
    self:Load()
    self._start = GetGameTimer()
    self._sc:CallFunction("SHOW_SHARD_MIDSIZED_MESSAGE", false, msg, desc, bgColor, useDarkerShard, useCondensedShard)
    self._timer = time
    self._hasAnimatedOut = false
end

function m:Update()
    self._sc:Render2D()
    if self._start ~= 0 and GetGameTimer() - self._start > self._timer then
        if not self._hasAnimatedOut then
            self._sc:CallFunction("SHARD_ANIM_OUT", false, 21, 750)
            self._hasAnimatedOut = true
            self._timer = self._timer + 750
        else
            PlaySoundFrontend(-1, "Shard_Disappear", "GTAO_FM_Events_Soundset", true)
            self._start = 0
            self:Dispose()
        end
    end
end