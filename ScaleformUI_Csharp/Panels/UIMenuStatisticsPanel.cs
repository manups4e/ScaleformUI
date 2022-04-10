using System.Collections.Generic;
using System.Drawing;
using System.Threading.Tasks;
using CitizenFX.Core.UI;

namespace ScaleformUI
{
	public class UIMenuStatisticsPanel : UIMenuPanel
	{
		internal readonly List<StatisticsForPanel> Items;

		public UIMenuStatisticsPanel()
		{
			Items = new List<StatisticsForPanel>();
		}

		public void AddStatistics (string Name, float val)
		{
			float _value = val;
			if (_value > 100)
				_value = 100;
			if (_value < 0)
				_value = 0;
			StatisticsForPanel item = new(Name, _value);
			Items.Add(item);
			var it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
			var van = ParentItem.Panels.IndexOf(this);
			ScaleformUI._ui.CallFunction("ADD_STATISTIC_TO_PANEL", it, van, Name, _value);
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
			var it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
			var van = ParentItem.Panels.IndexOf(this);
			ScaleformUI._ui.CallFunction("SET_PANEL_STATS_ITEM_VALUE", it, van, ItemId, Items[ItemId].Value);
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
			if(Value < 0)
				Value = 0;
        }
	}
}
