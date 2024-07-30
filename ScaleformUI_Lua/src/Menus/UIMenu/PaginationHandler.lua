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
        scrollType = MenuScrollingType.CLASSIC
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
    return math.ceil(self.totalItems / self.itemsPerPage) -- maybe math.ceil as items start at index 1?
end

function PaginationHandler:CurrentPageStartIndex()
    return ((self.currentPage - 1) * self.itemsPerPage) + 1
end

function PaginationHandler:CurrentPageEndIndex()
    local idx = self:CurrentPageStartIndex() + self.itemsPerPage - 1
    if idx > self.totalItems then
        idx = self.totalItems
    end
    return idx
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
    if self.minItem > self.maxItem then
        return menuIndex <= self.minItem and menuIndex <= self.maxItem
    end
    return menuIndex >= self.minItem and menuIndex <= self.maxItem
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
    local diff = 0
    if self.totalItems >= self.itemsPerPage then
        diff = self.itemsPerPage - (scaleformIndex + 1)
    else
        diff = self.totalItems - (scaleformIndex + 1)
    end
    local result = self:MaxItem() - diff
    if result < 1 then
        result = self.totalItems + result
    end
    return result
end

function PaginationHandler:GetPageIndexFromScaleformIndex(scaleformIndex)
    local menuIdx = self:MinItem() + (scaleformIndex + 1)
    return self:GetPageIndexFromMenuIndex(menuIdx)
end

function PaginationHandler:GetPageFromScaleformIndex(scaleformIndex)
    local menuIdx = self:MinItem() + (scaleformIndex + 1)
    return self:GetPage(menuIdx)
end

function PaginationHandler:GetPageIndexFromMenuIndex(menuIndex)
    local page = self:GetPage(menuIndex)
    local startIndex = ((page - 1) * self.itemsPerPage) + 1
    return menuIndex - startIndex + 1
end

function PaginationHandler:GetMenuIndexFromPageIndex(page, index)
    local initialIndex = ((page - 1) * self.itemsPerPage) + 1
    return initialIndex + index - 1
end

function PaginationHandler:GetPage(menuIndex)
    return math.ceil(menuIndex / self.itemsPerPage)
end

function PaginationHandler:GetPageItemsCount(page)
    local startIndex = ((page - 1) * self.itemsPerPage) + 1
    local endIndex = startIndex + self.itemsPerPage - 1
    if (endIndex > self.totalItems) then
        endIndex = self.totalItems
    end
    return (endIndex - startIndex) + 1
end

function PaginationHandler:GetMissingItems()
    local count = self:GetPageItemsCount(self.currentPage)
    return self.itemsPerPage - count
end

function PaginationHandler:GoUp()
    local overflow = false
    self._currentMenuIndex = self._currentMenuIndex - 1
    if self._currentMenuIndex < 1 then
        self._currentMenuIndex = self.totalItems
        overflow = self:TotalPages() > 1
    end
    self:CurrentPageIndex(self._currentMenuIndex)
    self.scaleformIndex = self.scaleformIndex - 1
    self:CurrentPage(self:GetPage(self._currentMenuIndex))
    if self.scaleformIndex < 0 then
        if self.totalItems <= self.itemsPerPage then
            self.scaleformIndex = self.totalItems - 1
            return false
        end
        if self.scrollType == MenuScrollingType.ENDLESS or (self.scrollType == MenuScrollingType.CLASSIC and not overflow) then
            self.minItem = self.minItem - 1
            self.maxItem = self.maxItem - 1
            if self.minItem < 1 then
                self.minItem = self.totalItems
            end
            if self.maxItem < 1 then
                self.maxItem = self.totalItems
            end
            self.scaleformIndex = 0
            return true
        elseif self.scrollType == MenuScrollingType.PAGINATED or (self.scrollType == MenuScrollingType.CLASSIC and overflow) then
            self.minItem = self:CurrentPageStartIndex()
            self.maxItem = self:CurrentPageEndIndex()
            self:ScaleformIndex(self:GetPageIndexFromMenuIndex(self:CurrentPageEndIndex()) - 1)

            if self.scrollType == MenuScrollingType.CLASSIC then
                local missingItems = self:GetMissingItems()
                if missingItems > 0 then
                    self:ScaleformIndex(self:GetPageIndexFromMenuIndex(self:CurrentPageEndIndex()) + missingItems - 1)
                    self.minItem = self:CurrentPageStartIndex() - missingItems
                end
            end
            return true
        end
    end
    return false
end

function PaginationHandler:GoDown()
    local overflow = false
    self._currentMenuIndex = self._currentMenuIndex + 1
    if self._currentMenuIndex > self.totalItems then
        self._currentMenuIndex = 1
        overflow = self:TotalPages() > 1
    end
    self:CurrentPageIndex(self._currentMenuIndex)
    self.scaleformIndex = self.scaleformIndex + 1
    if self.scaleformIndex > self.totalItems - 1 then
        self:CurrentPage(self:GetPage(self._currentMenuIndex))
        self.scaleformIndex = 0
        return false
    elseif self.scaleformIndex > self.itemsPerPage - 1 then
        if self.scrollType == MenuScrollingType.ENDLESS or (self.scrollType == MenuScrollingType.CLASSIC and not overflow) then
            self:CurrentPage(self:GetPage(self._currentMenuIndex))
            self.scaleformIndex = self.itemsPerPage - 1
            self.minItem = self.minItem + 1
            self.maxItem = self.maxItem + 1
            if self.minItem > self.totalItems then
                self.minItem = 1
            end
            if self.maxItem > self.totalItems then
                self.maxItem = 1
            end
            return true
        elseif self.scrollType == MenuScrollingType.PAGINATED or (self.scrollType == MenuScrollingType.CLASSIC and overflow) then
            self:CurrentPage(self:GetPage(self._currentMenuIndex))
            self.minItem = self:CurrentPageStartIndex()
            self.maxItem = self:CurrentPageEndIndex()
            self.scaleformIndex = 0
            return true
        end
    elseif self.scrollType == MenuScrollingType.PAGINATED and self.scaleformIndex + 1 > self:GetPageIndexFromMenuIndex(self:CurrentPageEndIndex()) then
        self:CurrentPage(self:GetPage(self._currentMenuIndex))
        self.minItem = self:CurrentPageStartIndex()
        self.maxItem = self:CurrentPageEndIndex()
        self.scaleformIndex = 0
        return true
    end
    self:CurrentPage(self:GetPage(self._currentMenuIndex))
    return false
end

function PaginationHandler:Reset()
    self._currentPageIndex = 1
    self._currentMenuIndex = 1
    self.currentPage = 1
    self.minItem = 1
    self.maxItem = 1
    self.totalItems = 0
    self.scaleformIndex = 0
end

function PaginationHandler:ToString()
    local str = ""
    str = str .. "self._currentMenuIndex: " .. self._currentMenuIndex .. ", "
    str = str .. "self._currentPageIndex: " .. self._currentPageIndex .. ", "
    str = str .. "CurrentPageStartIndex: " + self:CurrentPageStartIndex() + ", ";
    str = str .. "CurrentPageEndIndex: " + self:CurrentPageEndIndex() + ", ";
    str = str .. "self.currentPage: " .. self.currentPage .. ", "
    str = str .. "self.itemsPerPage: " .. self.itemsPerPage .. ", "
    str = str .. "self.minItem: " .. self.minItem .. ", "
    str = str .. "self.maxItem: " .. self.maxItem .. ", "
    str = str .. "self.totalItems: " .. self.totalItems .. ", "
    str = str .. "self.scaleformIndex: " .. self.scaleformIndex .. ", "
end
