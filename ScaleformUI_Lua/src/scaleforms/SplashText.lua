SplashTextInstance = setmetatable({}, SplashTextInstance)
SplashTextInstance.__index = SplashTextInstance
SplashTextInstance.__call = function()
  return "SplashText"
end

function SplashTextInstance.New()
  local data = {
    _scaleform = nil
  };
  return setmetatable(data, SplashTextInstance);
end

function SplashTextInstance:SetLabel(label, duration, red, green, blue, alpha, transistionIn)
  AddTextEntry("LBL_SPLASH_TEXT", label);

  self._scaleform:CallFunction("SET_SPLASH_TEXT", nil, { type = "label", data = "LBL_SPLASH_TEXT" }, duration or 0,
    red or 255,
    green or 255,
    blue or 255, alpha or 255);

  print(label);
  Wait(0)

  if transistionIn then
    self:TransitionIn(300);
  end
end

function SplashTextInstance:SetTextLabel(label, red, green, blue, alpha)
  AddTextEntry("LBL_SPLASH_TEXT", label);

  self._scaleform:CallFunction("SPLASH_TEXT_LABEL", nil, { type = "label", data = "LBL_SPLASH_TEXT" }, red or 255,
    green or 255, blue or 255, alpha or 255);

  print(label);
end

function SplashTextInstance:TransitionIn(duration, managed)
  self._scaleform:CallFunction("SPLASH_TEXT_TRANSITION_IN", duration or 300, managed or false);
end

function SplashTextInstance:TransitionOut(duration, managed)
  self._scaleform:CallFunction("SPLASH_TEXT_TRANSITION_OUT", duration or 300, managed or false);
end

function SplashTextInstance:Load()
  local prom = promise.new();

  self._scaleform = Scaleform.Request("SPLASH_TEXT");

  while not self._scaleform:IsLoaded() do
    Citizen.Wait(0);
  end

  prom:resolve();
  return prom;
end

function SplashTextInstance:Draw()
  if not self._scaleform then
    return;
  end

  self._scaleform:Render2DNormal(0.5, 0.5, 1.0, 1.0);
end
