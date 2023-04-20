MidMessageInstance = setmetatable({}, MidMessageInstance)
MidMessageInstance.__index = MidMessageInstance
MidMessageInstance.__call = function()
    return "MidMessageInstance"
end

---@class MidMessageInstance

function MidMessageInstance.New()
    local _sc = nil --[[@type Scaleform]]
    local _start = 0
    local _timer = 0
    local _hasAnimatedOut = false
    local data = { _sc = _sc, _start = _start, _timer = _timer, _hasAnimatedOut = _hasAnimatedOut }
    return setmetatable(data, MidMessageInstance)
end

function MidMessageInstance:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("MIDSIZED_MESSAGE")
    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end
end

function MidMessageInstance:Dispose()
    self._sc:Dispose()
    self._sc = nil
end

function MidMessageInstance:ShowColoredShard(msg, desc, bgColor, useDarkerShard, useCondensedShard, time)
    if time == nil then time = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._sc:CallFunction("SHOW_SHARD_MIDSIZED_MESSAGE", false, msg, desc, bgColor, useDarkerShard, useCondensedShard)
    self._timer = time
    self._hasAnimatedOut = false
end

function MidMessageInstance:Update()
    self._sc:Render2D()
    if self._start ~= 0 and GlobalGameTimer - self._start > self._timer then
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
