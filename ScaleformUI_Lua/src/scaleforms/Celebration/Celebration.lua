CelebrationInstance = setmetatable({}, CelebrationInstance)
CelebrationInstance.__index = CelebrationInstance
CelebrationInstance.__call = function()
  return "Celebration"
end

---@enum CelebrationTexture
CelebrationTexture = {
  Shard = 1,
  RaceFlag = 3,
  Grid = 6,
  TargetAssault = 8,
  Remix1 = 10,
  Remix2 = 12,
  Remix3 = 14,
  Remix4 = 16,
  Remix5 = 18,
  ArenaWars = 20,
}

---@enum CelebrationType
CelebrationType = {
  Multiplayer = 1,
  Heist1 = 2,
  Heist2 = 3,
}

---@enum CelebrationCustomSounds
CelebrationCustomSounds = {
  Default = "APT_BvS_Soundset",
  Beast = "DLC_GR_PM_Beast_Soundset",
  BeastRemix = "DLC_BTL_TP_Remix_Beast_Soundset"
}

---Get the scaleform names for the celebration type
---@param celebrationType CelebrationType
---@return string, string, string
local function GetCelebrationScaleforms(celebrationType)
  if celebrationType == CelebrationType.Multiplayer then
    return "MP_CELEBRATION", "MP_CELEBRATION_FG", "MP_CELEBRATION_BG"
  elseif celebrationType == CelebrationType.Heist1 then
    return "HEIST_CELEBRATION", "HEIST_CELEBRATION_FG", "HEIST_CELEBRATION_BG"
  elseif celebrationType == CelebrationType.Heist2 then
    return "HEIST2_CELEBRATION", "HEIST2_CELEBRATION_FG", "HEIST2_CELEBRATION_BG"
  end
  return "", "", ""
end

---Create a new celebration wall
function CelebrationInstance.New()
  local data = {
    _duration = 5000,
    _scalformBackground = nil --[[@type Scaleform]],
    _scalformForeground = nil --[[@type Scaleform]],
    _scalformMain = nil --[[@type Scaleform]],
  }
  return setmetatable(data, CelebrationInstance)
end

---Load the celebration wall
---@param celebrationType CelebrationType
---@return promise<nil>
function CelebrationInstance:Load(celebrationType)
  local prom = promise.new()

  local main, foreground, background = GetCelebrationScaleforms(celebrationType)

  self._scalformBackground = Scaleform.Request(background)
  self._scalformForeground = Scaleform.Request(foreground)
  self._scalformMain = Scaleform.Request(main)

  while not self._scalformBackground:IsLoaded() do
    Citizen.Wait(0)
  end

  while not self._scalformForeground:IsLoaded() do
    Citizen.Wait(0)
  end

  while not self._scalformMain:IsLoaded() do
    Citizen.Wait(0)
  end

  prom:resolve()
  return prom
end

---Call a function on all 3 scaleforms
---@param ... any
function CelebrationInstance:CallAllFunction(...)
  self._scalformBackground:CallFunction(...)
  self._scalformForeground:CallFunction(...)
  self._scalformMain:CallFunction(...)
end

---Dispose the celebration wall
function CelebrationInstance:Dispose()
  self._scalformBackground:Dispose()
  self._scalformBackground = nil
  self._scalformForeground:Dispose()
  self._scalformForeground = nil
  self._scalformMain:Dispose()
  self._scalformMain = nil
end

---Display the celebration wall for the duration of its animations, returns a promise that resolves when the animations are finished.
---It is recommended to use this function instead of the manual display function as it will display the wall for the duration of its animations
---and will resolve a promise when completed. Remember to clean up the wall after it is done displaying
---using the Dispose function to prevent memory leaks or use the CleanUp function to clean up a set wall.
---@return promise<nil>
function CelebrationInstance:Display()
  local prom = promise.new()

  local startTime = GlobalGameTimer

  local retHandle = self._scalformMain:CallFunction("GET_TOTAL_WALL_DURATION", true) or 0 --[[ @type number ]]

  while not IsScaleformMovieMethodReturnValueReady(retHandle) do Wait(0) end
  local time = GetScaleformMovieMethodReturnValueInt(retHandle)
  local endTime = startTime + time

  while GlobalGameTimer < endTime do
    self._scalformBackground:Render2DMasked(self._scalformForeground);
    self._scalformMain:Render2D()
    Wait(0)
  end

  prom:resolve()
  return prom
end

---Render the celebration wall manually
function CelebrationInstance:ManualDisplay()
  self._scalformBackground:Render2DMasked(self._scalformForeground);
  self._scalformMain:Render2D()
end

---Clean up the wall and reset it
function CelebrationInstance:CleanUp(wallId)
  self:CallAllFunction("CLEANUP", false, { type = "playerNameComp", data = wallId })
end

---Create a stat wall
---@param wallId string
---@param colour string @Colours
---@param foregroundAlpha string?
---@see Colours
function CelebrationInstance:CreateStatWall(wallId, colour, foregroundAlpha)
  self:CallAllFunction("CREATE_STAT_WALL", false,
    { type = "playerNameComp", data = wallId },
    { type = "playerNameComp", data = colour },
    { type = "playerNameComp", data = foregroundAlpha or "100.0" }
  )
end

---Add an intro to the wall
---@param wallId string
---@param modeLabel string
---@param jobNameLabel string
---@param challengeTextLabel string
---@param challengePartsTextLabel string
---@param targetTypeTextLabel string
---@param targetValue string
---@param delay number
---@param targetValuePrefix string
---@param modeLabelIsStringLiteral boolean
---@param textColourName string
function CelebrationInstance:AddIntroToWall(wallId, modeLabel, jobNameLabel, challengeTextLabel, challengePartsTextLabel,
                                            targetTypeTextLabel, targetValue, delay, targetValuePrefix,
                                            modeLabelIsStringLiteral,
                                            textColourName)
  local modeLabelType = "playerNameComp"
  if modeLabelIsStringLiteral then
    modeLabelType = "literal"
  end

  self:CallAllFunction("ADD_INTRO_TO_WALL", false,
    { type = "playerNameComp", data = wallId },
    { type = modeLabelType, data = modeLabel },
    { type = "label", data = jobNameLabel },
    { type = "playerNameComp", data = challengeTextLabel },
    { type = "label", data = challengePartsTextLabel },
    { type = "playerNameComp", data = targetTypeTextLabel },
    { type = "playerNameComp", data = targetValue },
    delay,
    { type = "playerNameComp", data = targetValuePrefix },
    modeLabelIsStringLiteral,
    { type = "playerNameComp", data = textColourName }
  )
end

---Add a mission result to the wall
---@param wallId string
---@param missionTextLabel string
---@param passFailTextLabel string
---@param missionReasonString string
---@param isReasonRawText boolean
---@param isPassFailRawText boolean
---@param isMissionTextRawText boolean
---@param forcedAlpha number
---@param hudColourId Colours
---@see Colours
function CelebrationInstance:AddMissionResultToWall(wallId, missionTextLabel, passFailTextLabel, missionReasonString,
                                                    isReasonRawText, isPassFailRawText, isMissionTextRawText, forcedAlpha,
                                                    hudColourId)
  self:CallAllFunction("ADD_MISSION_RESULT_TO_WALL", false,
    { type = "playerNameComp", data = wallId },
    { type = "playerNameComp", data = missionTextLabel },
    { type = "playerNameComp", data = passFailTextLabel },
    { type = "playerNameComp", data = missionReasonString },
    isReasonRawText,
    isPassFailRawText,
    isMissionTextRawText,
    forcedAlpha,
    { type = "playerNameComp", data = hudColourId }
  )
end

---Set the background texture of the wall
---@param wallId string
---@param alpha number
---@param texture CelebrationTexture
function CelebrationInstance:AddBackgroundToWall(wallId, alpha, texture)
  self:CallAllFunction("ADD_BACKGROUND_TO_WALL", false, { type = "playerNameComp", data = wallId }, alpha, texture)
end

---Set which wall to show
---@param wallId string
function CelebrationInstance:ShowStatWall(wallId)
  self:CallAllFunction("SHOW_STAT_WALL", false, { type = "playerNameComp", data = wallId })
end

---Set the pause duration
---@param duration? number @Default: 3.0
function CelebrationInstance:SetPauseDuration(duration)
  self:CallAllFunction("SET_PAUSE_DURATION", false, duration or 3.0)
end

function CelebrationInstance:CreateBackgroundStatWall(wallId, colour, alpha)
  self._scalformBackground:CallFunction("CREATE_STAT_WALL", false,
    { type = "playerNameComp", data = wallId },
    { type = "playerNameComp", data = colour },
    { type = "playerNameComp", data = alpha or "100.0" }
  )
end

function CelebrationInstance:CreateForegroundStatWall(wallId, colour, alpha)
  self._scalformForeground:CallFunction("CREATE_STAT_WALL", false,
    { type = "playerNameComp", data = wallId },
    { type = "playerNameComp", data = colour },
    { type = "playerNameComp", data = alpha or "100.0" }
  )
end

function CelebrationInstance:CreateMainStatWall(wallId, colour, alpha)
  self._scalformMain:CallFunction("CREATE_STAT_WALL", false,
    { type = "playerNameComp", data = wallId },
    { type = "playerNameComp", data = colour },
    { type = "playerNameComp", data = alpha or "100.0" }
  )
end

---Set custom sounds for the wall
---@param soundSet CelebrationCustomSounds
---@see CelebrationCustomSounds
function CelebrationInstance:SetCustomSound(soundSet)
  self._scalformMain:CallFunction("SET_CUSTOM_SOUND", false,
    0,
    { type = "literal", data = "Blade_Appear" },
    { type = "literal", data = soundSet }
  )
  self._scalformMain:CallFunction("SET_CUSTOM_SOUND", false,
    7,
    { type = "literal", data = "Blade_Beasts_Fail" },
    { type = "literal", data = soundSet }
  )
  self._scalformMain:CallFunction("SET_CUSTOM_SOUND", false,
    8,
    { type = "literal", data = "Blade_Beasts_Win" },
    { type = "literal", data = soundSet }
  )
end

---Add a winner to the wall
---@param wallId string
---@param winnLoseTextLabel string
---@param gamerName string
---@param crewName string
---@param betAmount number
---@param isInFlow boolean
---@param teamName string
---@param gamerNameIsLabel boolean
function CelebrationInstance:AddWinnerToWall(wallId, winnLoseTextLabel, gamerName, crewName, betAmount, isInFlow,
                                             teamName, gamerNameIsLabel)
  self:CallAllFunction("ADD_WINNER_TO_WALL", false,
    { type = "playerNameComp", data = wallId },
    { type = "playerNameComp", data = winnLoseTextLabel },
    { type = "playerNameComp", data = gamerName },
    { type = "playerNameComp", data = crewName },
    { type = "playerNameComp", data = betAmount },
    isInFlow,
    { type = "playerNameComp", data = teamName },
    gamerNameIsLabel
  )
end

-- TODO: Investigate this function more
---Add time to a wall
---@param wallId string
---@param time number @Time milliseconds
---@param timeTitleLabel string @Time Label CELEB_TIME or CELEB_PERSONAL_BEST
---@param timeDifference number @The time difference milliseconds
function CelebrationInstance:AddTimeToWall(wallId, time, timeTitleLabel, timeDifference)
  self:CallAllFunction("ADD_TIME_TO_WALL", false,
    { type = "playerNameComp", data = wallId },
    time,
    { type = "playerNameString", data = timeTitleLabel },
    timeDifference
  )
end
