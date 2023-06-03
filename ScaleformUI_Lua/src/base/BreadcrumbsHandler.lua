BreadcrumbsHandler = setmetatable({
    breadcrumbs = {}
}, BreadcrumbsHandler)

function BreadcrumbsHandler:Count()
    return #self.breadcrumbs
end

function BreadcrumbsHandler:CurrentDepth()
    return #self.breadcrumbs -- needed? lua handles arrays from 1 not 0.. so..who knows..
end

function BreadcrumbsHandler:PreviousMenu()
    return self.breadcrumbs[#self.breadcrumbs]
end

function BreadcrumbsHandler:Forward(menu)
    table.insert(self.breadcrumbs, menu)
end

function BreadcrumbsHandler:Clear()
    local count = #self.breadcrumbs
    for i=0, count do self.breadcrumbs[i]=nil end
    self.breadcrumbs = {}
end

function BreadcrumbsHandler:Backwards()
    table.remove(self.breadcrumbs, #self.breadcrumbs)
end