MultiplayerChat = setmetatable({}, MultiplayerChat)
MultiplayerChat.__index = MultiplayerChat
MultiplayerChat.__call = function()
  return "MultiplayerChat"
end

---@class MultiplayerChat
---@field public _sc Scaleform

local INITIALIZED = false

---@enum ChatScope
ChatScope = {
  Global = 0,
  Team = 1,
  All = 2,
  Clan = 3
}

---@enum ChatVisible
ChatVisible = {
  Hidden = 0,
  Default = 1,
  Typing = 2
}

---Create a new MultiplayerChat instance
---@return table
function MultiplayerChat.New()
  local data = {
    _sc = nil --[[@type Scaleform]],
    messages = {} --[[@type table<string, string, string, boolean, HudColours>]],
    _start = 0,
    _enabled = false,
    _isTyping = false,
  }
  return setmetatable(data, MultiplayerChat)
end

---Load the MULTIPLAYER_CHAT scaleform
---@return promise
function MultiplayerChat:Load()
  local p = promise.new()

  if self._sc ~= nil then
    p:resolve()
    return p
  end

  self._sc = Scaleform.Request("MULTIPLAYER_CHAT")
  local timeout = 1000
  local start = GlobalGameTimer
  while not self._sc:IsLoaded() and GlobalGameTimer - start < timeout do Citizen.Wait(0) end

  if self._sc:IsLoaded() then
    if not INITIALIZED then
      self._sc:CallFunction("RESET")
      INITIALIZED = true
    end
    p:resolve()
  else
    p:reject()
  end

  return p
end

---Set the focus of the chat
---@param visibleState ChatVisible
---@param scopeType? ChatScope
---@param scopeText? string
---@param playerName? string
---@param colour? HudColours
function MultiplayerChat:SetFocus(visibleState, scopeType, scopeText, playerName, colour)
  if visibleState == ChatVisible.Hidden then
    self._start = 0
  elseif visibleState == ChatVisible.Default then
    self._start = GlobalGameTimer
  elseif visibleState == ChatVisible.Typing then
    self._isTyping = true
  end

  self._sc:CallFunction("SET_FOCUS", visibleState, scopeType, scopeText, playerName, colour)
end

function MultiplayerChat:Show()
  self:SetFocus(ChatVisible.Default)
end

function MultiplayerChat:StartTyping(scopeType, scopeText)
  self:SetFocus(ChatVisible.Typing, scopeType, scopeText, GetPlayerName(PlayerId()), HudColours.HUD_COLOUR_WHITE)
end

---Scroll the chat up
function MultiplayerChat:PageUp()
  self._sc:CallFunction("PAGE_UP")
end

---Scroll the chat down
function MultiplayerChat:PageDown()
  self._sc:CallFunction("PAGE_DOWN")
end

---Delete last character
function MultiplayerChat:DeleteText()
  self._sc:CallFunction("DELETE_TEXT")
end

---Set the typing state as completed
function MultiplayerChat:SetTypingDone()
  self._sc:CallFunction("SET_TYPING_DONE")
  self._isTyping = false
end

---Add a message with player name to the chat
---@param playerName string
---@param message string
---@param scope? ChatScope
---@param teamOnly? boolean
---@param playerColour? HudColours
function MultiplayerChat:AddMessage(playerName, message, scope, teamOnly, playerColour)
  self._sc:CallFunction("ADD_MESSAGE", playerName, message, scope, teamOnly, playerColour)
end

-- As a key is pressed this will add the letter onto the current message in the capture field
-- if the enter key is pressed the word "ENTER" should be sent, this will trigger SET_TYPING_DONE
-- if the backspace key is pressed the word "BACKSPACE" should be sent, this will remove the last letter from the current message
-- if the escape key is pressed whe word "ESCAPE" should be sent, this will clear the current message
---Add a character to the chat
---@param text string -- The character to add, or "ENTER", "BACKSPACE", or "ESCAPE"
function MultiplayerChat:AddText(text)
  self._sc:CallFunction("ADD_TEXT", text)
end

---Close the chat
function MultiplayerChat:Close()
  self:SetFocus(ChatVisible.Hidden, ChatScope.Global, "")
  self._start = 0
  self._enabled = false
  self._isTyping = false
end

---Complete Text -- this will add the current messahe information to the chat locally, its also called by SetTypingDone
function MultiplayerChat:CompleteText()
  self._sc:CallFunction("COMPLETE_TEXT")
end

---Abort Text
function MultiplayerChat:AbortText()
  self._sc:CallFunction("ABORT_TEXT")
end

---Reset Text
function MultiplayerChat:Reset()
  self._sc:CallFunction("RESET")
end

function MultiplayerChat:IsEnabled()
  if self._sc == nil then return false end
  return self._start > 10000 or self._enabled
end

function MultiplayerChat:IsTyping()
  if self._sc == nil then return false end
  return self._isTyping
end

---Update is called every frame to render the MULTIPLAYER_CHAT scaleform to the screen by mainScaleform.lua
function MultiplayerChat:Update()
  if self._sc == nil then return end
  ScaleformUI.WaitTime = 0
  self._sc:Render2D()

  if self._enabled then
    DisableControlAction(0, 200, true);
  end

  if GlobalGameTimer - self._start > 10000 and not self._enabled then
    self:Close()
  end
end

---Dispose the MULTIPLAYER_CHAT scaleform
function MultiplayerChat:Dispose()
  self._sc:Dispose()
  self._sc = nil
end
