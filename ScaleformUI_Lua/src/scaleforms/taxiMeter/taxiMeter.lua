TaxiMeterInstance = setmetatable({}, TaxiMeterInstance)
TaxiMeterInstance.__index = TaxiMeterInstance
TaxiMeterInstance.__call = function()
  return "TaxiMeter"
end

--[[
  ideals:
    Call Order:
    1. Load
    2. AddDestination
    3. ShowDestination
    4. HighlightDestination
    5. SetPrice
    6. Draw

    -- taxi meter prop: prop_taxi_meter_2
    -- render target name: taxi
    -- bone for taxi meter: Chassis
    -- offset for taxi meter:
        - pos: vector3(-0.01, 0.75, 0.4)
        - rot: vector3(-5.0, 0.0, 0.0)
]]

function TaxiMeterInstance.New(posX, posY, width, height)
  local data = {
    _scaleform = nil,
    _posX = posX or 0.5,
    _posY = posY or 0.5,
    _width = width or 1.0,
    _height = height or 1.0,
    _current = 0,
    _destinations = {}
  };
  return setmetatable(data, TaxiMeterInstance);
end

function TaxiMeterInstance:AddDestination(index, sprite, color, destinationName, destinationZone, streetName)
  -- scaleform param layout:
  -- 1: index (starts at 0)
  -- 2: sprite (any blip sprite)
  -- 3: Color Red (0-255)
  -- 4: Color Green (0-255)
  -- 5: Color Blue (0-255)
  -- 6: Destination Name (usually the name of the blip)
  -- 7: Destination Zone (usually uses `GetNameOfZone`)
  -- 8: Street Name (usually uses `GetStreetNameAtCoord`)

  self._scaleform:CallFunction("ADD_TAXI_DESTINATION", index, sprite, color.r, color.g, color.b, destinationName, destinationZone, streetName)
  self._destinations[index + 1] = {
    index = index,
    sprite = sprite,
    color = color,
    destinationName = destinationName,
    destinationZone = destinationZone,
    streetName = streetName
  }
end

function TaxiMeterInstance:ShowDestination()
  self._scaleform:CallFunction("SHOW_TAXI_DESTINATION");
end

---@param destination integer @index of the destination
function TaxiMeterInstance:HighlightDestination(destination)
  self._scaleform:CallFunction("HIGHLIGHT_DESTINATION", destination)
end

---@param price integer
function TaxiMeterInstance:SetPrice(price)
  self._scaleform:CallFunction("SET_TAXI_PRICE", price)
end

function TaxiMeterInstance:GetCurrentDestination()
  return self._destinations[self._current + 1]
end

function TaxiMeterInstance:Clear()
  self._scaleform:CallFunction("CLEAR_TAXI_DISPLAY")
end

function TaxiMeterInstance:NextDestination()
  local increased = self._current + 1
  self._current = increased > #self._destinations and #self._destinations or increased
  self:HighlightDestination(self._current)
end

function TaxiMeterInstance:PreviousDestination()
  local decreased = self._current - 1
  self._current = decreased < 0 and 0 or decreased
  self:HighlightDestination(self._current)
end

function TaxiMeterInstance:SetScale(width, height)
  self._width = width;
  self._height = height;
end

function TaxiMeterInstance:SetPosition(x, y)
  self._posX = x;
  self._posY = y;
end

function TaxiMeterInstance:Load()
  local prom = promise.new();

  self._scaleform = Scaleform.RequestWidescreen("TAXI_DISPLAY");

  while not self._scaleform:IsLoaded() do
    Citizen.Wait(0);
  end

  prom:resolve();
  return prom;
end

function TaxiMeterInstance:Draw()
  if not self._scaleform then
    return
  end

  self._scaleform:Render2DNormal(self._posX, self._posY, self._width, self._height);
end
