PaginationHandler = setmetatable({}, PaginationHandler)
PaginationHandler.__index = PaginationHandler
PaginationHandler.__call = function()
    return "PaginationHandler"
end

function PaginationHandler.New()
    local _pagination = {
        _currentPageIndex = 1,
        _currentMenuIndex = 1,
        currentPage = 1,
        itemsPerPage = 0,
        minItem = 1,
        maxItem = 1,
        totalItems = 0,
        scaleformIndex = 0,
    }
    return setmetatable(_pagination, PaginationHandler)
end

function PaginationHandler:CurrentPage(val)
    if val then
        self.currentPage = val
    else
        return self.currentPage
    end
end

function PaginationHandler:ItemsPerPage(val)
    if val then
        self.itemsPerPage = val
    else
        return self.itemsPerPage
    end
end

function PaginationHandler:TotalItems(val)
    if val then
        self.totalItems = val
    else
        return self.totalItems
    end
end

function PaginationHandler:TotalPages()
    return math.floor(self.totalItems / self.itemsPerPage) -- maybe math.ceil as items start at index 1?
end

function PaginationHandler:CurrentPageStartIndex()
    return ((self.currentPage-1) * self.itemsPerPage) +1
end

function PaginationHandler:CurrentPageEndIndex()
    if self.totalItems > self.itemsPerPage-1 then
        return self:CurrentPageStartIndex() + self.itemsPerPage-1
    else
        return self:CurrentPageStartIndex() + self.totalItems
    end
end

function PaginationHandler:CurrentPageIndex(val)
    if val then
        self._currentPageIndex = self:GetPageIndexFromMenuIndex(val)
    else
        return self._currentPageIndex
    end
end

function PaginationHandler:CurrentMenuIndex(val)
    if val then
        self._currentMenuIndex = val
    else
        return self._currentMenuIndex
    end
end

function PaginationHandler:MinItem(val)
    if val then
        self.minItem = val
    else
        return self.minItem
    end
end

function PaginationHandler:MaxItem(val)
    if val then
        self.maxItem = val
    else
        return self.maxItem
    end
end

function PaginationHandler:ScaleformIndex(val)
    if val then
        self.scaleformIndex = val
    else
        return self.scaleformIndex
    end
end

function PaginationHandler:IsItemVisible(menuIndex)
    return menuIndex >= self.minItem or (menuIndex <= self.minItem and menuIndex <= self.maxItem) -- >= / <= ?
end

function PaginationHandler:GetScaleformIndex(menuIndex)
    local id = 0
    if self.minItem <= menuIndex then
        id = menuIndex - self.minItem
    elseif self.minItem > menuIndex and self.maxItem >= menuIndex then
        id = (menuIndex - self.maxItem) + (self.itemsPerPage - 1) -- self.itemsPerPage-1?
    end
    return id
end

function PaginationHandler:GetMenuIndexFromScaleformIndex(scaleformIndex)
    local id = 0
    if self.minItem <= scaleformIndex then
        id = scaleformIndex - self.minItem +1
    elseif self.minItem > scaleformIndex and self.maxItem >= scaleformIndex then
        id = self:GetMenuIndexFromPageIndex(1, (self.totalItems - self.minItem) - scaleformIndex)
    end
    return id
end

function PaginationHandler:GetPageIndexFromMenuIndex(menuIndex)
    local page = self:GetPage(menuIndex)
    local startIndex = ((page-1) * self.itemsPerPage) +1
    return menuIndex - startIndex + 1
end

function PaginationHandler:GetMenuIndexFromPageIndex(page, index)
    local initialIndex =  ((page-1) * self.itemsPerPage) +1
    return initialIndex + index -1
end

function PaginationHandler:GetPage(menuIndex)
    return math.ceil(menuIndex / self.itemsPerPage)
end

function PaginationHandler:GoUp()
    self._currentMenuIndex = self._currentMenuIndex - 1
    if self._currentMenuIndex < 1 then
        self._currentMenuIndex = self.totalItems
    end
    self:CurrentPageIndex(self._currentMenuIndex)
    self.scaleformIndex = self.scaleformIndex-1
    self:CurrentPage(self:GetPage(self._currentMenuIndex))
    if self.scaleformIndex < 0 then
        if self.totalItems < self.itemsPerPage then
            self.scaleformIndex = self.totalItems
            return false
        end
        self.minItem = self.minItem-1
        self.maxItem = self.maxItem-1
        if self.minItem < 1 then
            self.minItem = self.totalItems
        end
        if self.maxItem < 1 then
            self.maxItem = self.totalItems
        end
        self.scaleformIndex = 0
        return true
    end
    return false
end

function PaginationHandler:GoDown()
    self._currentMenuIndex = self._currentMenuIndex + 1;
    if self._currentMenuIndex > self.totalItems then
        self._currentMenuIndex = 1;
    end
    self:CurrentPageIndex(self._currentMenuIndex)
    self.scaleformIndex = self.scaleformIndex + 1
    self:CurrentPage(self:GetPage(self._currentMenuIndex))
    if self.scaleformIndex > self.totalItems then
        self.scaleformIndex = 0;
        return false;
    elseif self.scaleformIndex > self.itemsPerPage - 1 then
        self.scaleformIndex = self.itemsPerPage - 1;
        self.minItem = self.minItem+1;
        self.maxItem = self.maxItem+1;
        if self.minItem > self.totalItems then
            self.minItem = 1;
        end
        if self.maxItem > self.totalItems then
            self.maxItem = 1;
        end
        return true;
    end
    return false;
end