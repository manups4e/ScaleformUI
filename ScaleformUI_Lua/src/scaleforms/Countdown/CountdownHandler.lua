CountdownHandler = setmetatable({}, CountdownHandler)
CountdownHandler.__index = CountdownHandler
CountdownHandler.__call = function()
    return "CountdownHandler"
end

---@class CountdownHandler

local _r;
local _g;
local _b;
local _a;

function CountdownHandler.New()
    local _sc = 0
    local _start = 0
    local _timer = 0
    local data = { _sc = _sc, _start = _start, _timer = _timer }
    return setmetatable(data, CountdownHandler)
end

function CountdownHandler:Load()
    local p = promise.new()

    if self._sc ~= 0 then
        p:resolve()
        return p
    end

    RequestScriptAudioBank("HUD_321_GO", false);

    self._sc = Scaleform.Request("COUNTDOWN")
    local timeout = 1000
    local start = GetGameTimer()
    while not self._sc:IsLoaded() and GetGameTimer() - start < timeout do Citizen.Wait(0) end

    if self._sc:IsLoaded() then
        p:resolve()
    else
        p:reject()
    end

    return p
end

function CountdownHandler:Dispose(force)
    self._sc:Dispose()
    self._sc = 0
end

function CountdownHandler:Update()
    self._sc:Render2D()
end

function CountdownHandler:ShowMessage(message)
    self._sc:CallFunction("SET_MESSAGE", false, message, _r, _g, _b, true);
    self._sc:CallFunction("FADE_MP", false, message, _r, _g, _b);
end

function CountdownHandler:Start(number, hudColour, countdownAudioName, countdownAudioRef, goAudioName, goAudioRef)
    local p = promise.new()

    if number == nil then number = 3 end
    if hudColour == nil then hudColour = 18 end
    if countdownAudioName == nil then countdownAudioName = "321" end
    if countdownAudioRef == nil then countdownAudioRef = "Car_Club_Races_Pursuit_Series_Sounds" end
    if goAudioName == nil then goAudioName = "Go" end
    if goAudioRef == nil then goAudioRef = "Car_Club_Races_Pursuit_Series_Sounds" end

    self:Load():next(function()
        _r, _g, _b, _a = GetHudColour(hudColour)

        local gameTime = GetGameTimer()

        while number >= 0 do
            Wait(0)

            if GetGameTimer() - gameTime > 1000 then
                PlaySoundFrontend(-1, countdownAudioName, countdownAudioRef, true);
                self:ShowMessage(number)
                number = number - 1
                gameTime = GetGameTimer()
            end
        end

        PlaySoundFrontend(-1, goAudioName, goAudioRef, true);
        self:ShowMessage("CNTDWN_GO")
        p:resolve()

        if GetGameTimer() - gameTime > 1000 then
            self:Dispose()
        end
    end, function()
        error("Failed to load countdown scaleform")
        p:reject()
    end)

    return p
end
