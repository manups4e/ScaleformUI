RankbarHandler = setmetatable({}, RankbarHandler)
RankbarHandler.__index = RankbarHandler
RankbarHandler.__call = function()
    return "RankbarHandler"
end

---@class RankbarHandler
---@field public Load fun():promise
---@field public SetScores fun(limitStart:number, limitEnd:number, previousValue:number, currentValue:number, currentRank:number):nil
---@field public SetColour fun(rankBarColor:number):nil
---@field public Remove fun():nil
---@field public OverrideAnimationSpeed fun(speed:number):nil
---@field public OverrideOnscreenDuration fun(duration:number):nil

local HUD_COMPONENT_ID = 19
local _rankBarColor = 116

---Loads the rankbar scaleform movie
---@return promise
function RankbarHandler:Load()
    local p = promise.new()

    if HasScaleformScriptHudMovieLoaded(HUD_COMPONENT_ID) then
        p:resolve()
        return p
    end

    RequestScaleformScriptHudMovie(HUD_COMPONENT_ID)
    local timeout = 1000
    local start = GlobalGameTimer
    while not HasScaleformScriptHudMovieLoaded(HUD_COMPONENT_ID) and GlobalGameTimer - start < timeout do Citizen.Wait(0) end

    if HasScaleformScriptHudMovieLoaded(HUD_COMPONENT_ID) then
        p:resolve()
    else
        p:reject()
    end

    return p
end

---Set the scores for the rankbar
---@param limitStart number
---@param limitEnd number
---@param previousValue number
---@param currentValue number
---@param currentRank number
function RankbarHandler:SetScores(limitStart, limitEnd, previousValue, currentValue, currentRank)
    self:Load():next(function()
            BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "SET_COLOUR")
            ScaleformMovieMethodAddParamInt(_rankBarColor)
            EndScaleformMovieMethod()

            BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "SET_RANK_SCORES")
            ScaleformMovieMethodAddParamInt(limitStart)
            ScaleformMovieMethodAddParamInt(limitEnd)
            ScaleformMovieMethodAddParamInt(previousValue)
            ScaleformMovieMethodAddParamInt(currentValue)
            ScaleformMovieMethodAddParamInt(currentRank)
            EndScaleformMovieMethod()
        end,
        function()
            print("RankbarHandler:Load() failed")
        end)
end

---Set the colour of the rankbar
---@param rankBarColor HudColours
function RankbarHandler:SetColour(rankBarColor)
    _rankBarColor = rankBarColor
end

---Remove the rankbar from the screen
function RankbarHandler:Remove()
    if HasScaleformScriptHudMovieLoaded(HUD_COMPONENT_ID) then
        BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "REMOVE");
        EndScaleformMovieMethod();
    end
end

---Override the animation speed of the rankbar
---@param speed number -- milliseconds (default 1000)
function RankbarHandler:OverrideAnimationSpeed(speed)
    self:Load():next(function()
            BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "OVERRIDE_ANIMATION_SPEED");
            ScaleformMovieMethodAddParamInt(speed);
            EndScaleformMovieMethod();
        end,
        function()
            print("RankbarHandler:Load() failed")
        end)
end

---Override the onscreen duration of the rankbar
---@param duration number -- milliseconds (default 4000)
function RankbarHandler:OverrideOnscreenDuration(duration)
    self:Load():next(function()
            BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "OVERRIDE_ONSCREEN_DURATION");
            ScaleformMovieMethodAddParamInt(duration);
            EndScaleformMovieMethod();
        end,
        function()
            print("RankbarHandler:Load() failed")
        end)
end
