RankbarHandler = {}

local m = {}
m = setmetatable({}, m)

m.__call = function()
    return true
end
m.__index = m

local HUD_COMPONENT_ID = 19
local _rankBarColor = 116

function RankbarHandler.New()
    local data = { }
    return setmetatable(data, m)
end

function m:Load()
    local p = promise.new()

    if HasScaleformScriptHudMovieLoaded(HUD_COMPONENT_ID) then 
        p:resolve()
        return p
    end

    RequestScaleformScriptHudMovie(HUD_COMPONENT_ID)
    local timeout = 1000
    local start = GetGameTimer()
    while not HasScaleformScriptHudMovieLoaded(HUD_COMPONENT_ID) and GetGameTimer() - start < timeout do Citizen.Wait(0) end

    if HasScaleformScriptHudMovieLoaded(HUD_COMPONENT_ID) then
        p:resolve()
    else
        p:reject()
    end

    return p
end

function m:SetScores(limitStart, limitEnd, previousValue, currentValue, currentRank)
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
    end)
    
end

function m:SetColour(rankBarColor)
    _rankBarColor = rankBarColor
end

function m:Remove()
    if HasScaleformScriptHudMovieLoaded(HUD_COMPONENT_ID) then
        BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "REMOVE");
        EndScaleformMovieMethod();
    end
end

function m:OverrideAnimationSpeed(speed)
    self:Load():next(function()
        BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "OVERRIDE_ANIMATION_SPEED");
        ScaleformMovieMethodAddParamInt(speed);
        EndScaleformMovieMethod();
    end)
end

function m:OverrideOnscreenDuration(duration)
    self:Load():next(function()
        BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "OVERRIDE_ONSCREEN_DURATION");
        ScaleformMovieMethodAddParamInt(duration);
        EndScaleformMovieMethod();
    end)
end