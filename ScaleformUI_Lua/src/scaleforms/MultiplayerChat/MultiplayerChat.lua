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
    messages = {} --[[@type table<string, string, string, boolean, Colours>]],
    _start = 0
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
---@param scope? ChatScope
---@param text? string
function MultiplayerChat:SetFocus(visibleState, scope, text)
  if visibleState == ChatVisible.Hidden then
    self._start = 0
  else
    self._start = GlobalGameTimer
  end

  if text ~= nil then
    self._sc:CallFunction("SET_FOCUS", false, visibleState, scope, text)
    return
  end

  if scope ~= nil then
    self._sc:CallFunction("SET_FOCUS", false, visibleState, scope)
    return
  end

  self._sc:CallFunction("SET_FOCUS", false, visibleState)
end

---Scroll the chat up
function MultiplayerChat:PageUp()
  self._sc:CallFunction("PAGE_UP")
end

---Scroll the chat down
function MultiplayerChat:PageDown()
  self._sc:CallFunction("PAGE_DOWN")
end

---Set the typing state as completed
function MultiplayerChat:SetTypingDone()
  self._sc:CallFunction("SET_TYPING_DONE")
end

---Add a message with player name to the chat
---@param playerName string
---@param message string
function MultiplayerChat:AddMessage(playerName, message)
  self:SetFocus(ChatVisible.Default, 1)
  self._sc:CallFunction("ADD_MESSAGE", false, playerName, message)
end

---Add a text message to the chat
---@param message string
function MultiplayerChat:AddText(message)
  self._sc:CallFunction("ADD_TEXT", false, message)
end

---Close the chat
function MultiplayerChat:Close()
  self:SetFocus(ChatVisible.Hidden, ChatScope.Global, "")
end

---Update is called every frame to render the MULTIPLAYER_CHAT scaleform to the screen by mainScaleform.lua
function MultiplayerChat:Update()
  if self._sc == nil then return end
  self._sc:Render2D()

  if GlobalGameTimer - self._start > 10000 then
    self:Close()
  end
end

---Dispose the MULTIPLAYER_CHAT scaleform
function MultiplayerChat:Dispose()
  self._sc:Dispose()
  self._sc = nil
end
