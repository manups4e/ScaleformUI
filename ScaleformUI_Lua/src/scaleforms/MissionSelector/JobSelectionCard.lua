JobSelectionCard = setmetatable({}, JobSelectionCard)
JobSelectionCard.__index = JobSelectionCard
JobSelectionCard.__call = function()
    return "JobSelectionCard"
end

function JobSelectionCard.New(title, description, txd, txn, rpMult, cashMult, icon, iconColor, apMultiplier,details)
    local data = {
        Title = title,
        Description = description,
        Txd = txd,
        Txn = txn,
        RpMultiplier = rpMult,
        CashMultiplier = cashMult,
        Icon = icon,
        IconColor = iconColor,
        ApMultiplier = apMultiplier,
        Details = details
    }
    return setmetatable(data, JobSelectionCard)
end