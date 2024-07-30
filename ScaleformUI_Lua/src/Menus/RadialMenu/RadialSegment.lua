RadialSegment = setmetatable({}, RadialSegment)
RadialSegment.__index = RadialSegment
RadialSegment.__call = function()
    return "RadialSegment"
end

function RadialSegment.New(idx, _parent)
    local _seg = {
        Index = idx or -1,
        Items = {},
        Parent = _parent or nil,
        _selected = false,
        currentSelection = 1,
        OnIndexChanged = function(index)
        end
    }
    return setmetatable(_seg, RadialSegment)
end

function RadialSegment:CurrentSelection()
    return self.currentSelection or 1
end

function RadialSegment:AddItem(item)
    item.Parent = self
    table.insert(self.Items, item)
    if self.Parent ~= nil and self.Parent:Visible() then
        ScaleformUI.Scaleforms._radialMenu:CallFunction("ADD_ITEM", self.Index - 1, item:Label(), item:Description(), item:TextureDict(), item:TextureName(), item:TextureWidth(), item:TextureHeight(), item:Color(), item.qtty, item.max)
    end
end

function RadialSegment:RemoveItem(item)
    if item == "number" then
        table.remove(self.Items, item)
    elseif item == "table" then
        table.remove(self.Items, IndexOf(self.Items, item))
    end
end

function RadialSegment:CycleItems(dir)
    local input = 11
    if dir == -1 then
        input = 10
    end
    self.currentSelection = ScaleformUI.Scaleforms._radialMenu:CallFunctionAsyncReturnInt("SET_INPUT_EVENT", input) + 1

    self.OnIndexChanged(self.currentSelection)
    return self:CurrentSelection()
end
