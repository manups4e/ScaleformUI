using System.Reflection.Emit;

namespace ScaleformUI.Menu
{
    public class UIMenuStatisticsPanel : UIMenuPanel
    {
        internal readonly List<StatisticsForPanel> Items;

        public UIMenuStatisticsPanel()
        {
            Items = new List<StatisticsForPanel>();
        }

        public void AddStatistics(string Name, float val)
        {
            float _value = val;
            if (_value > 100)
                _value = 100;
            if (_value < 0)
                _value = 0;
            StatisticsForPanel item = new(Name, _value);
            Items.Add(item);
            if (ParentItem != null && ParentItem.Parent != null)
            {
                int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ParentItem.Parent.SendPanelsToItemScaleform(it, true);
            }
        }

        public float GetPercentage(int ItemId)
        {
            return Items[ItemId].Value;
        }

        public void UpdateStatistic(int ItemId, float number)
        {
            Items[ItemId].Value = number;
            if (Items[ItemId].Value > 100)
                Items[ItemId].Value = 100;
            if (Items[ItemId].Value < 0)
                Items[ItemId].Value = 0;
            if (ParentItem != null && ParentItem.Parent != null)
            {
                int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ParentItem.Parent.SendPanelsToItemScaleform(it, true);
            }
        }
    }

    public class StatisticsForPanel
    {
        public string Text { get; set; }
        public float Value { get; set; }

        public StatisticsForPanel(string label, float value)
        {
            Text = label;
            Value = value;
            if (Value > 100)
                Value = 100;
            if (Value < 0)
                Value = 0;
        }

        public override string ToString()
        {
            return $"{Text}:{Value}";
        }
    }
}
