CountdownHandler = setmetatable({}, CountdownHandler)
CountdownHandler.__index = CountdownHandler
CountdownHandler.__call = function()
    return "CountdownHandler"
end

---@class CountdownHandler
---@field public _sc Scaleform
---@field private _start number
---@field private _timer number
---@field private _colour {r:number, g:number, b:number, a:number}
---@field public New fun():CountdownHandler
---@field public Load fun(self:CountdownHandler):promise
---@field public Dispose fun(self:CountdownHandler, force:boolean):nil
---@field public Update fun(self:CountdownHandler):nil
---@field public ShowMessage fun(self:CountdownHandler, message:string):nil
---@field public Start fun(self:CountdownHandler, number:number|nil, hudColour:number|nil, countdownAudioName:string|nil, countdownAudioRef:string|nil, goAudioName:string|nil, goAudioRef:string|nil):promise

---Creates a new CountdownHandler
---@return CountdownHandler
function CountdownHandler.New()
    local data = {
        _sc = nil --[[@type Scaleform]],
        _start = 0,
        _timer = 0,
        _colour = { r = 255, g = 255, b = 255, a = 255 }
    }
    return setmetatable(data, CountdownHandler)
end

---Loads the COUNTDOWN scaleform
---@return promise
function CountdownHandler:Load()
    local p = promise.new()

    if self._sc ~= nil then
        p:resolve()
        return p
    end

    RequestScriptAudioBank("HUD_321_GO", false);

    self._sc = Scaleform.Request("COUNTDOWN")
    local timeout = 1000
    local start = GlobalGameTimer
    while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end

    if self._sc:IsLoaded() then
        p:resolve()
    else
        p:reject()
    end

    return p
end

---Dispose the COUNTDOWN scaleform
function CountdownHandler:Dispose()
    self._sc:Dispose()
    self._sc = nil
end

---Update is called every frame to render the COUNTDOWN scaleform to the screen by mainScaleform.lua
function CountdownHandler:Update()
    self._sc:Render2D()
end

---Show a message on the COUNTDOWN scaleform
---@param message string
function CountdownHandler:ShowMessage(message)
    self._sc:CallFunction("SET_MESSAGE", false, message, self._colour.r, self._colour.g, self._colour.b, true);
    self._sc:CallFunction("FADE_MP", false, message, self._colour.r, self._colour.g, self._colour.b);
end

---Starts the countdown
---@param number number|nil - The number to start the countdown from
---@param hudColour number|nil - The hud colour to use for the countdown
---@param countdownAudioName string|nil - The audio name to play for each number
---@param countdownAudioRef string|nil - The audio ref to play for each number
---@param goAudioName string|nil - The audio name to play when the countdown is finished
---@param goAudioRef string|nil - The audio ref to play when the countdown is finished
---@return promise
function CountdownHandler:Start(number, hudColour, countdownAudioName, countdownAudioRef, goAudioName, goAudioRef)
    local p = promise.new()

    if number == nil then number = 3 end
    if hudColour == nil then hudColour = 18 end
    if countdownAudioName == nil then countdownAudioName = "321" end
    if countdownAudioRef == nil then countdownAudioRef = "Car_Club_Races_Pursuit_Series_Sounds" end
    if goAudioName == nil then goAudioName = "Go" end
    if goAudioRef == nil then goAudioRef = "Car_Club_Races_Pursuit_Series_Sounds" end

    self:Load():next(function()
        self._colour.r, self._colour.g, self._colour.b, self._colour.a = GetHudColour(hudColour)

        local gameTime = GlobalGameTimer

        while number >= 0 do
            Wait(0)

            if GlobalGameTimer - gameTime > 1000 then
                PlaySoundFrontend(-1, countdownAudioName, countdownAudioRef, true);
                self:ShowMessage(string.format(number))
                number = number - 1
                gameTime = GlobalGameTimer
            end
        end

        PlaySoundFrontend(-1, goAudioName, goAudioRef, true);
        self:ShowMessage("CNTDWN_GO")
        p:resolve()

        if GlobalGameTimer - gameTime > 1000 then
            self:Dispose()
        end
    end, function()
        error("Failed to load countdown scaleform")
        p:reject()
    end)

    return p
end
