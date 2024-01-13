SplashTextInstance = setmetatable({}, SplashTextInstance)
SplashTextInstance.__index = SplashTextInstance
SplashTextInstance.__call = function()
  return "SplashText"
end

function SplashTextInstance.New(posX, posY, width, height)
  local data = {
    _scaleform = nil,
    _posX = posX or 0.5,
    _posY = posY or 0.5,
    _width = width or 1.0,
    _height = height or 1.0
  };
  return setmetatable(data, SplashTextInstance);
end

function SplashTextInstance:SetLabel(label, sColor, transistionIn)
  AddTextEntry("LBL_SPLASH_TEXT", label);

  if not sColor then
    sColor = SColor.White;
  end

  self.SetTextLabel({ type = "label", data = "LBL_SPLASH_TEXT" }, sColor);
  if transistionIn then
    self:TransitionIn(300);
  end
end

function SplashTextInstance:SetTextLabel(label, sColor)
  AddTextEntry("LBL_SPLASH_TEXT", label);

  if not sColor then
    sColor = SColor.White;
  end

  self._scaleform:CallFunction("SPLASH_TEXT_LABEL", { type = "label", data = "LBL_SPLASH_TEXT" }, sColor.R,
    sColor.G, sColor.B, sColor.A);
end

function SplashTextInstance:TransitionIn(duration, managed)
  self._scaleform:CallFunction("SPLASH_TEXT_TRANSITION_IN", duration or 300, managed or false);
end

function SplashTextInstance:TransitionOut(duration, managed)
  self._scaleform:CallFunction("SPLASH_TEXT_TRANSITION_OUT", duration or 300, managed or false);
end

function SplashTextInstance:SetScale(width, height)
  self._width = width;
  self._height = height;
end

function SplashTextInstance:SetPosition(x, y)
  self._posX = x;
  self._posY = y;
end

function SplashTextInstance:Load()
  local prom = promise.new();

  self._scaleform = Scaleform.RequestWidescreen("SPLASH_TEXT");

  while not self._scaleform:IsLoaded() do
    Citizen.Wait(0);
  end

  prom:resolve();
  return prom;
end

function SplashTextInstance:Draw()
  if not self._scaleform then
    return
  end

  self._scaleform:Render2DNormal(self._posX, self._posY, self._width, self._height);
end
