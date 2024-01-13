CountdownHandler = setmetatable({
    _sc = nil --[[@type Scaleform]],
    _start = 0,
    _timer = 0,
    _colour = { r = 255, g = 255, b = 255, a = 255 }
}, CountdownHandler)
CountdownHandler.__index = CountdownHandler
CountdownHandler.__call = function()
    return "CountdownHandler"
end

---@type boolean
local renderCountdown = false

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
---@field public Start fun(self:CountdownHandler, number:number?, hudColour:number?, countdownAudioName:string?, countdownAudioRef:string?, goAudioName:string?, goAudioRef:string?):promise

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
    -- Wait 1 second before disposing the scaleform
    -- This is to prevent the scaleform from being disposed too early
    -- and to allow promise to be resolved before disposing
    local gameTime = GlobalGameTimer
    while GlobalGameTimer - gameTime < 1000 do
        Wait(0)
    end

    self._sc:Dispose()
    self._sc = nil
end

---Update must be called every frame to render the COUNTDOWN scaleform
function CountdownHandler:Update()
    if self._sc == nil or self._sc == 0 then return end
    self._sc:Render2D()
end

---Starts rendering the COUNTDOWN scaleform
local function StartRenderingCountdown()
    renderCountdown = true
    Citizen.CreateThread(function()
        while renderCountdown do
            Wait(0)
            CountdownHandler:Update()
        end
    end)
end

---Show a message on the COUNTDOWN scaleform
---@param message string
function CountdownHandler:ShowMessage(message)
    self._sc:CallFunction("SET_MESSAGE", message, self._colour.r, self._colour.g, self._colour.b, true);
    self._sc:CallFunction("FADE_MP", message, self._colour.r, self._colour.g, self._colour.b);
end

---Starts the countdown and will return a promise when the countdown is finished
---@param number number? - The number to start the countdown from
---@param hudColour number? - The hud colour to use for the countdown
---@param countdownAudioName string? - The audio name to play for each number
---@param countdownAudioRef string? - The audio ref to play for each number
---@param goAudioName string? - The audio name to play when the countdown is finished
---@param goAudioRef string? - The audio ref to play when the countdown is finished
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
        StartRenderingCountdown();
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

        self:Dispose()
    end, function()
        error("Failed to load countdown scaleform")
        p:reject()
    end)

    renderCountdown = false

    return p
end
