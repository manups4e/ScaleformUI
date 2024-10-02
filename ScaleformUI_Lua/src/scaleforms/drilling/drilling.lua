DrillingInstance = setmetatable({}, DrillingInstance)
DrillingInstance.__index = DrillingInstance
DrillingInstance.__call = function()
  return "DrillingInstance"
end

---@class DrillingInstance
---@field private _scaleform Scaleform
---@field private _drillSound number
---@field private active boolean
---@field private success boolean
---@field private pinsData table
---@field private drillPosition number
---@field private currentDepth number
---@field private drillSpeed number
---@field private temperature number
---@field private SetSpeed fun(self: DrillingInstance, value: number):nil Sets the speed of the drill (private as it's only used internally)
---@field private SetDrillPosition fun(self: DrillingInstance, value: number):nil Sets the position of the drill (private as it's only used internally)
---@field private SetTemperature fun(self: DrillingInstance, value: number):nil Sets the temperature of the drill (private as it's only used internally)
---@field private Process fun(self: DrillingInstance):nil Processes the drill (private as it's only used internally)
---@field public Start fun(self: DrillingInstance, callback: fun(success: boolean):nil):nil Starts the drill asynchronously
---@field public StartSync fun(self: DrillingInstance):boolean Starts the drill synchronously
---@field public Cancel fun(self: DrillingInstance):nil Cancels the drill
---@field private Draw fun(self: DrillingInstance):nil Draws the drill (private as it's only used internally)
---@field private Load fun(self: DrillingInstance):nil Loads the drill (private as it's only used internally)
---@field private Dispose fun(self: DrillingInstance):nil Disposes the drill (private as it's only used internally)
---@field public New fun():DrillingInstance Creates a new instance of DrillingInstance

function DrillingInstance.New()
    local _data = {
        _scaleform = nil,
        _drillSound = nil,
        active = false,
        success = false,
        pinsData = { 0.325, 0.475, 0.625, 0.775 },
        drillPosition = 0.0,
        currentDepth = 0.0,
        drillSpeed = 0.0,
        temperature = 0.0,
    }
    return setmetatable(_data, DrillingInstance)
end

function DrillingInstance:SetSpeed(value)
    if not self._scaleform then return end
    if value > 0.0 and not self._drillSound then
        self._drillSound = GetSoundId()
        PlaySoundFromEntity(self._drillSound, "Drill", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 0, 0)
    elseif value == 0.0 and self._drillSound then
        StopSound(self._drillSound)
        self._drillSound = nil
    end
    self._scaleform:CallFunction("SET_SPEED", value)
end

function DrillingInstance:SetDrillPosition(value)
    if not self._scaleform then return end
    self._scaleform:CallFunction("SET_DRILL_POSITION", value)
end

function DrillingInstance:SetTemperature(value)
    if not self._scaleform then return end
    self._scaleform:CallFunction("SET_TEMPERATURE", value)
end

function DrillingInstance:Process()
    -- Position handling
    local cachedPosition = self.drillPosition

    if IsControlJustPressed(0, 172) then
        self.drillPosition = math.min(1.0, self.drillPosition + 0.01)
    elseif IsControlPressed(0, 172) then
        self.drillPosition = math.min(1.0, self.drillPosition + (0.1 * GetFrameTime() / (math.max(0.1,self.temperature) * 10)))
    elseif IsControlJustPressed(0, 173) then
        self.drillPosition = math.max(0.0, self.drillPosition - 0.01)
    elseif IsControlPressed(0, 173) then
        self.drillPosition = math.max(0.0, self.drillPosition - (0.1 * GetFrameTime()))
    end

    local cachedSpeed = self.drillSpeed

    if IsControlJustPressed(0,175) then
        self.drillSpeed = math.min(1.0,self.drillSpeed + 0.05)
    elseif IsControlPressed(0,175) then
        self.drillSpeed = math.min(1.0,self.drillSpeed + (0.5 * GetFrameTime()))
    elseif IsControlJustPressed(0,174) then
        self.drillSpeed = math.max(0.0,self.drillSpeed - 0.05)
    elseif IsControlPressed(0,174) then
        self.drillSpeed = math.max(0.0,self.drillSpeed - (0.5 * GetFrameTime()))
    end

    if cachedSpeed ~= self.drillSpeed then
        self:SetSpeed(self.drillSpeed)
    end

    local cachedTemperature = self.temperature

    if self.drillPosition > self.currentDepth then
        if self.drillSpeed > 0.1 then
            -- Don't update temperature until first pins is reached
            if self.drillPosition >= self.pinsData[1] then
                self.temperature = math.min(1.0, self.temperature + ((1.0 * GetFrameTime()) * self.drillSpeed))
            end

            for i = 1, #self.pinsData do
                if self.currentDepth < self.pinsData[i] and self.drillPosition >= self.pinsData[i] then
                    PlaySoundFrontend(-1 , "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", true)
                    break
                end
            end
            self.currentDepth = self.drillPosition
        else
            self.drillPosition = self.currentDepth
        end
    else
        self.temperature = math.max(0.0, self.temperature - (1.0 * GetFrameTime()))
    end

    if self.drillPosition ~= cachedPosition then
        self:SetDrillPosition(self.drillPosition)
    end

    if cachedTemperature ~= self.temperature then
        self:SetTemperature(self.temperature)
    end

    if self.temperature >= 1.0 then
        self.success = false
        self.active = false
    elseif self.drillPosition >= 1.0 then
        self.success = true
        self.active = false
    end
end

function DrillingInstance:Start(callback)
    if not self._scaleform then
        self:Load()
    end
    self.active = true
    self:SetSpeed(0.0)
    self:SetDrillPosition(0.0)
    self:SetTemperature(0.0)

    self.drillPosition = 0.0
    self.currentDepth = 0.0
    self.drillSpeed = 0.0
    self.temperature = 0.0

    while self.active do
        self:Draw()
        self:Process()
        Citizen.Wait(0)
    end
    StopSound(self._drillSound)
    ReleaseNamedScriptAudioBank("DLC_HEIST_FLEECA_SOUNDSET")
    ReleaseNamedScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL")
    ReleaseNamedScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2")
    if not self.success then
        PlaySoundFrontend(-1, "Drill_Jam", "DLC_HEIST_FLEECA_SOUNDSET", true)
    end
    self:Dispose()
    callback(self.success)
end

function DrillingInstance:StartSync()
    local prom = promise.new()
    self:Start(function(success)
        prom:resolve(success)
    end)
    return Citizen.Await(prom)
end

function DrillingInstance:Cancel()
    self.active = false
end


function DrillingInstance:Draw()
    if not self._scaleform then return end

    self._scaleform:Render2D()
end

function DrillingInstance:Load()
    local prom = promise.new()

    RequestScriptAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
    RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
    RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
    self._scaleform = Scaleform.RequestWidescreen("DRILLING")

    while not self._scaleform:IsLoaded() do
      Citizen.Wait(0)
    end

    prom:resolve()
    return prom
end

function DrillingInstance:Dispose()
    if self._scaleform then
        self._scaleform:Dispose()
        self._scaleform = nil
    end
end
