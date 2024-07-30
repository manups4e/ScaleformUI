BreadcrumbsHandler = setmetatable({
    breadcrumbs = {},
    SwitchInProgress = false
}, BreadcrumbsHandler)

function BreadcrumbsHandler:Count()
    return #self.breadcrumbs
end

function BreadcrumbsHandler:CurrentDepth()
    return #self.breadcrumbs -- needed? lua handles arrays from 1 not 0.. so..who knows..
end

function BreadcrumbsHandler:PreviousMenu()
    return self.breadcrumbs[#self.breadcrumbs - 1]
end

function BreadcrumbsHandler:Forward(menu, data)
    table.insert(self.breadcrumbs, { menu = menu, data = data })
end

function BreadcrumbsHandler:Clear()
    self.breadcrumbs = {}
end

function BreadcrumbsHandler:Backwards()
    table.remove(self.breadcrumbs, #self.breadcrumbs)
end
