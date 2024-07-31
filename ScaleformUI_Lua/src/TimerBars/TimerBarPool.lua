TimerBarPool = setmetatable({}, TimerBarPool)
TimerBarPool.__index = TimerBarPool

---@class TimerBarPool
---@field public Bars table
---@field public New fun(self:TimerBarPool)
---@field public AddBar function
---@field public Draw function

function TimerBarPool.New()
    local _data = {
        Bars = {}
    }
    return setmetatable(_data, TimerBarPool)
end

function TimerBarPool:AddBar(timerBar)
    timerBar.Handle = #self.Bars + 1;
    self.Bars[timerBar.Handle] = timerBar
end

function TimerBarPool:RemoveBar(timerBar)    
    self.Bars[timerBar.Handle] = nil
end

function TimerBarPool:Draw()
    local offset = 0
    if #ScaleformUI.Scaleforms.InstructionalButtons.ControlButtons > 0 or ScaleformUI.Scaleforms.InstructionalButtons.IsSaving then
        offset = 9
    end
    for k, v in pairs(self.Bars) do
        v:Draw((k * 10) + offset)
    end
end
