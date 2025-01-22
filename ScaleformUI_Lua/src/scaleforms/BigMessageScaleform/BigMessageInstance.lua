BigMessageInstance = setmetatable({
    _sc = nil --[[@type Scaleform]],
    _start = 0,
    _duration = 0,
    _transition = "TRANSITION_OUT", -- TRANSITION_UP, TRANSITION_OUT, TRANSITION_DOWN supported
    _transitionDuration = 0.15,
    _transitionPreventAutoExpansion = false,
    _transitionExecuted = false,
    _manualDispose = false
}, BigMessageInstance)
BigMessageInstance.__index = BigMessageInstance
BigMessageInstance.__call = function()
    return "BigMessageInstance"
end

---@class BigMessageInstance
---@field public _sc Scaleform
---@field private _start number
---@field private _duration number
---@field private _transition string -- TRANSITION_UP, TRANSITION_OUT, TRANSITION_DOWN supported
---@field private _transitionDuration number -- default: 0.4
---@field private _transitionPreventAutoExpansion boolean -- default: false
---@field private _transitionExecuted boolean -- default: false
---@field public New fun():BigMessageInstance
---@field public Load fun():nil
---@field public Dispose fun(self:BigMessageInstance, force:boolean):nil
---@field public ShowMissionPassedMessage fun(self:BigMessageInstance, msg:string, duration:number, manualDispose?:boolean):nil
---@field public ShowColoredShard fun(self:BigMessageInstance, msg:string, desc:string, textColor:number, bgColor:number, duration:number, manualDispose?:boolean):nil
---@field public ShowOldMessage fun(self:BigMessageInstance, msg:string, duration:number, manualDispose?:boolean):nil
---@field public ShowSimpleShard fun(self:BigMessageInstance, msg:string, subtitle:string, duration:number, manualDispose?:boolean):nil
---@field public ShowRankupMessage fun(self:BigMessageInstance, msg:string, subtitle:string, rank:number, duration:number, manualDispose?:boolean):nil
---@field public ShowWeaponPurchasedMessage fun(self:BigMessageInstance, bigMessage:string, weaponName:string, weaponHash:number, duration:number, manualDispose?:boolean):nil
---@field public ShowMpMessageLarge fun(self:BigMessageInstance, msg:string, duration:number, manualDispose?:boolean):nil
---@field public ShowMpWastedMessage fun(self:BigMessageInstance, msg:string, subtitle:string, duration:number, manualDispose?:boolean):nil
---@field public SetTransition fun(self:BigMessageInstance, transition:string, duration:number, preventAutoExpansion:boolean):nil
---@field public Update fun(self:BigMessageInstance):nil

--[[
    SHOW_MISSION_PASSED_MESSAGE - TRANSITION_OUT,
    SHOW_SHARD_CENTERED_MP_MESSAGE - TRANSITION_OUT,
    SHOW_MISSION_PASSED_MESSAGE - TRANSITION_OUT,
    SHOW_SHARD_CREW_RANKUP_MP_MESSAGE - TRANSITION_OUT,
    SHOW_BIG_MP_MESSAGE - TRANSITION_OUT,
    SHOW_WEAPON_PURCHASED - TRANSITION_OUT,
    SHOW_CENTERED_MP_MESSAGE_LARGE - TRANSITION_OUT,
    SHOW_SHARD_WASTED_MP_MESSAGE - TRANSITION_OUT,
]]

---Loads the MP_BIG_MESSAGE_FREEMODE scaleform
---@return nil
function BigMessageInstance:Load()
    if self._sc ~= nil then return end
    self._sc = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end
end

---Disposes the scaleform
function BigMessageInstance:Dispose()
    if self._sc == nil then return end

    if self._manualDispose then
        self._sc:CallFunction(self._transition, false, self._transitionDuration, self
            ._transitionPreventAutoExpansion)

        Wait(((self._transitionDuration * .5) * 1000))

        self._manualDispose = false
        -- Wait for the transition to finish
    end

    self._start = 0
    self._transitionExecuted = false
    self._sc:Dispose()
    self._sc = nil
end

---Runs the SHOW_MISSION_PASSED_MESSAGE method on the scaleform
---@param msg string
---@param duration number
---@param manualDispose? boolean
---@return nil
function BigMessageInstance:ShowMissionPassedMessage(msg, duration, manualDispose)
    if duration == nil then duration = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._manualDispose = manualDispose or false
    self._sc:CallFunction("SHOW_MISSION_PASSED_MESSAGE", msg, "", 100, true, 0, true)
    self._duration = duration
end

---Runs the SHOW_SHARD_CENTERED_MP_MESSAGE message on the scaleform
---@param msg string
---@param desc string
---@param textColor HudColours
---@param bgColor HudColours
---@param duration number
---@param manualDispose? boolean
---@return nil
function BigMessageInstance:ShowColoredShard(msg, desc, textColor, bgColor, duration, manualDispose)
    if duration == nil then duration = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._manualDispose = manualDispose or false
    self._sc:CallFunction("SHOW_SHARD_CENTERED_MP_MESSAGE", msg, desc, textColor, bgColor)
    self._duration = duration
end

---Runs the SHOW_MISSION_PASSED_MESSAGE method on the scaleform
---@param msg string
---@param duration number
---@param manualDispose? boolean
---@return nil
function BigMessageInstance:ShowOldMessage(msg, duration, manualDispose)
    if duration == nil then duration = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._manualDispose = manualDispose or false
    self._sc:CallFunction("SHOW_MISSION_PASSED_MESSAGE", msg)
    self._duration = duration
end

---Runs the SHOW_SHARD_CREW_RANKUP_MP_MESSAGE method on the scaleform
---@param msg string
---@param subtitle string
---@param duration number
---@param manualDispose? boolean
---@return nil
function BigMessageInstance:ShowSimpleShard(msg, subtitle, duration, manualDispose)
    if duration == nil then duration = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._manualDispose = manualDispose or false
    self._sc:CallFunction("SHOW_SHARD_CREW_RANKUP_MP_MESSAGE", msg, subtitle)
    self._duration = duration
end

---Runs the SHOW_BIG_MP_MESSAGE method on the scaleform
---@param msg string
---@param subtitle string
---@param rank number
---@param duration number
---@param manualDispose? boolean
---@return nil
function BigMessageInstance:ShowRankupMessage(msg, subtitle, rank, duration, manualDispose)
    if duration == nil then duration = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._manualDispose = manualDispose or false
    self._sc:CallFunction("SHOW_BIG_MP_MESSAGE", msg, subtitle, rank, "", "")
    self._duration = duration
end

---Runs the SHOW_WEAPON_PURCHASED method on the scaleform
---@param bigMessage string
---@param weaponName string
---@param weaponHash number
---@param duration number
---@param manualDispose? boolean
---@return nil
function BigMessageInstance:ShowWeaponPurchasedMessage(bigMessage, weaponName, weaponHash, duration, manualDispose)
    if duration == nil then duration = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._manualDispose = manualDispose or false
    self._sc:CallFunction("SHOW_WEAPON_PURCHASED", bigMessage, weaponName, weaponHash, "", 100)
    self._duration = duration
end

---Runs the SHOW_CENTERED_MP_MESSAGE_LARGE method on the scaleform
---@param msg string
---@param duration number
---@param manualDispose? boolean
---@return nil
function BigMessageInstance:ShowMpMessageLarge(msg, duration, manualDispose)
    if duration == nil then duration = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._manualDispose = manualDispose or false
    self._sc:CallFunction("SHOW_CENTERED_MP_MESSAGE_LARGE", msg, "", 100, true, 100)
    self._sc:CallFunction("TRANSITION_IN")
    self._duration = duration
end

---Runs the SHOW_SHARD_WASTED_MP_MESSAGE method on the scaleform
---@param msg string
---@param subtitle string
---@param duration number
---@param manualDispose? boolean
---@return nil
function BigMessageInstance:ShowMpWastedMessage(msg, subtitle, duration, manualDispose)
    if duration == nil then duration = 5000 end
    self:Load()
    self._start = GlobalGameTimer
    self._manualDispose = manualDispose or false
    self._sc:CallFunction("SHOW_SHARD_WASTED_MP_MESSAGE", msg, subtitle)
    self._duration = duration
end

---Sets the transition and duration for the scaleform when it is disposed
---@param transition string -- TRANSITION_UP, TRANSITION_OUT, TRANSITION_DOWN supported
---@param duration number? -- default 0.4
---@param preventAutoExpansion boolean? -- default true
---@return nil
function BigMessageInstance:SetTransition(transition, duration, preventAutoExpansion)
    if transition == nil then transition = "TRANSITION_OUT" end

    if transition ~= "TRANSITION_UP" and transition ~= "TRANSITION_OUT" and transition ~= "TRANSITION_DOWN" then
        transition = "TRANSITION_OUT"
    end

    self._transition = transition

    if duration == nil then duration = 0.4 end
    self._transitionDuration = duration + .0

    if preventAutoExpansion == nil then preventAutoExpansion = true end
    self._transitionPreventAutoExpansion = preventAutoExpansion
end

---Renders the scaleform and checks if the timer has expired, if so it will dispose the scaleform
---@return nil
function BigMessageInstance:Update()
    if self._sc == nil or self._sc == 0 then return end
    ScaleformUI.WaitTime = 0
    self._sc:Render2D()

    -- if the user wants to manually dispose the scaleform, don't do it automatically
    if self._manualDispose then return end

    if self._start ~= 0 and (GlobalGameTimer - self._start) > self._duration then
        if not self._transitionExecuted then
            self._sc:CallFunction(self._transition, false, self._transitionDuration, self
                ._transitionPreventAutoExpansion)
            self._transitionExecuted = true
            -- add the transition duration to the scaleform duration so the message is displayed for the full duration of the transition
            -- calculation is based on the scaleform duration for the transition to be executed MP_BIG_MESSAGE_FREEMODE.as line 936
            self._duration = self._duration + ((self._transitionDuration * .5) * 1000)
        else
            self:Dispose()
        end
    end
end
