Sprite = setmetatable({}, Sprite)
Sprite.__index = Sprite
Sprite.__call = function() return "Sprite" end

---@class Sprite
---@field TxtDictionary string
---@field TxtName string
---@field X number
---@field Y number
---@field Width number
---@field Height number
---@field Heading number
---@field _Colour table
---@field _Colour.R number
---@field _Colour.G number
---@field _Colour.B number
---@field _Colour.A number
---@field Position function
---@field Size function

---New
---@param TxtDictionary string
---@param TxtName string
---@param X number|0
---@param Y number|0
---@param Width number|0
---@param Height number|0
---@param Heading number|0
---@param R number|255
---@param G number|255
---@param B number|255
---@param A number|255
function Sprite.New(TxtDictionary, TxtName, X, Y, Width, Height, Heading, R, G, B, A)
    local _Sprite = {
        TxtDictionary = tostring(TxtDictionary),
        TxtName = tostring(TxtName),
        X = tonumber(X) or 0,
        Y = tonumber(Y) or 0,
        Width = tonumber(Width) or 0,
        Height = tonumber(Height) or 0,
        Heading = tonumber(Heading) or 0,
        _Colour = { R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255 },
    }
    return setmetatable(_Sprite, Sprite)
end

---Sets the position of the sprite
---@param X number?
---@param Y number?
function Sprite:Position(X, Y)
    if tonumber(X) and tonumber(Y) then
        self.X = tonumber(X)
        self.Y = tonumber(Y)
    else
        return { X = self.X, Y = self.Y }
    end
end

---Sets the size of the sprite
---@param Width number?
---@param Height number?
function Sprite:Size(Width, Height)
    if tonumber(Width) and tonumber(Width) then
        self.Width = tonumber(Width)
        self.Height = tonumber(Height)
    else
        return { Width = self.Width, Height = self.Height }
    end
end

---Sets the Colour of the sprite
---@param R number?
---@param G number?
---@param B number?
---@param A number?
function Sprite:Colour(R, G, B, A)
    if tonumber(R) or tonumber(G) or tonumber(B) or tonumber(A) then
        self._Colour.R = tonumber(R) or 255
        self._Colour.B = tonumber(B) or 255
        self._Colour.G = tonumber(G) or 255
        self._Colour.A = tonumber(A) or 255
    else
        return self._Colour
    end
end

---Draws the sprite to the screen
function Sprite:Draw()
    if not HasStreamedTextureDictLoaded(self.TxtDictionary) then
        RequestStreamedTextureDict(self.TxtDictionary, true)
    end
    local Position = self:Position()
    local Size = self:Size()
    Size.Width, Size.Height = FormatXWYH(Size.Width, Size.Height)
    Position.X, Position.Y = FormatXWYH(Position.X, Position.Y)
    DrawSprite(self.TxtDictionary, self.TxtName, Position.X + Size.Width * 0.5, Position.Y + Size.Height * 0.5,
        Size.Width, Size.Height, self.Heading, self._Colour.R, self._Colour.G, self._Colour.B, self._Colour.A)
end
