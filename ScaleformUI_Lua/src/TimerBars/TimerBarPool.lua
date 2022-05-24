TimerBarPool = setmetatable({}, TimerBarPool)
TimerBarPool.__index = TimerBarPool

function TimerBarPool.New()
    local _data = {
        Bars = {}
    }
    return setmetatable(_data, TimerBarPool)
end

function TimerBarPool:AddBar(timerBar)
    table.insert(self.Bars, timerBar)
end

function TimerBarPool:RemoveBar(id)
    table.remove(self.Bars, id)
end

function TimerBarPool:Draw()
    local offset = 0
    if ScaleformUI.Scaleforms.InstructionalButtons:Enabled() or ScaleformUI.Scaleforms.InstructionalButtons.IsSaving then
        offset = 9
    end
    for k,v in pairs(self.Bars) do
        v:Draw((k*10)+offset)
    end
end