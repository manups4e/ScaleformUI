using CitizenFX.Core.UI;
using System.Collections.Generic;

namespace ScaleformUI
{
    public class TimerBarPool
    {
        private static List<TimerBarBase> _bars = new List<TimerBarBase>();

        public TimerBarPool()
        {
            _bars = new List<TimerBarBase>();
        }

        public List<TimerBarBase> ToList()
        {
            return _bars;
        }

        public void Add(TimerBarBase timer)
        {
            _bars.Add(timer);
        }

        public void Remove(TimerBarBase timer)
        {
            _bars.Remove(timer);
        }

        public void Draw()
        {
            var off = ScaleformUI.InstructionalButtons.Enabled || ScaleformUI.InstructionalButtons.IsSaving ? 9 : 0;
            for (int i = 0; i < _bars.Count; i++)
            {
                _bars[i].Draw((i * 10)+off);
            }
        }
    }
}
