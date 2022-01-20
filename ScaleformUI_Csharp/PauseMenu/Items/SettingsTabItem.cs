using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public enum SettingsItemType
    {
        Basic,
        ListItem,
        ProgressBar,
        MaskedProgressBar,
        CheckBox,
        SliderBar
    }

    public delegate void SettingsBarChanged(SettingsTabItem item, int value);
    public delegate void SettingsCheckboxChanged(SettingsTabItem item, bool value);
    public delegate void SettingsListItemChanged(SettingsTabItem item, int value, string listItem);
    public delegate void SettingsItemSelected(SettingsTabItem item);

    public class SettingsTabItem : BasicTabItem
    {
        private int _value;
        private int itemIndex;
        private string rightLabel;
        private bool isChecked;
        private HudColor coloredBarColor;

        public event SettingsBarChanged OnBarChanged;
        public event SettingsCheckboxChanged OnCheckboxChange;
        public event SettingsListItemChanged OnListItemChange;
        public event SettingsItemSelected OnActivate;

        public bool Highlighted { get; set; }
        public SettingsItemType ItemType { get; set; }
        public UIMenuCheckboxStyle CheckBoxStyle { get; set; }
        public int MaxValue { get; set; } = 100;
        public int Value
        {
            get => _value;
            set
            {
                _value = value;
                if (Parent != null)
                {
                    int tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.SetRightSettingsItemValue(tab, leftItem, rightIndex, _value);
                }
                OnBarChanged?.Invoke(this, _value);
            }
        }
        public int ItemIndex
        {
            get => itemIndex;
            set
            {
                itemIndex = value;
                if (Parent != null)
                {
                    int tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.SetRightSettingsItemIndex(tab, leftItem, rightIndex, itemIndex);
                }
                OnListItemChange?.Invoke(this, itemIndex, ""+ListItems[itemIndex]);
            }
        }
        public List<dynamic> ListItems { get; set; }
        public string RightLabel
        {
            get => rightLabel;
            set
            {
                rightLabel = value;
                if (Parent != null)
                {
                    int tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.UpdateItemRightLabel(tab, leftItem, rightIndex, rightLabel);
                }
            }
        }
        public bool IsChecked
        {
            get => isChecked;
            set
            {
                isChecked = value;
                if (Parent != null)
                {
                    int tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.SetRightSettingsItemBool(tab, leftItem, rightIndex, isChecked);
                }
                OnCheckboxChange?.Invoke(this, isChecked);
            }
        }
        public HudColor ColoredBarColor
        {
            get => coloredBarColor;
            set
            {
                coloredBarColor = value;
                if (Parent != null)
                {
                    int tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.UpdateItemColoredBar(tab, leftItem, rightIndex, coloredBarColor);
                }
            }
        }
        public SettingsTabItem(string label, string rightLabel) : base(label)
        {
            ItemType = SettingsItemType.Basic;
            Label = label;
            RightLabel = rightLabel;
        }

        public SettingsTabItem(string label, List<dynamic> items, int startIndex) : base(label)
        {
            ItemType = SettingsItemType.ListItem;
            Label = label;
            ListItems = items;
            ItemIndex = startIndex;
        }

        public SettingsTabItem(string label, int max, int startIndex, bool masked, HudColor barColor = HudColor.HUD_COLOUR_FREEMODE) : base(label)
        {
            if (masked)
                ItemType = SettingsItemType.MaskedProgressBar;
            else
                ItemType = SettingsItemType.ProgressBar;
            Label = label;
            MaxValue = max;
            Value = startIndex;
            ColoredBarColor = barColor;
        }
        public SettingsTabItem(string label, UIMenuCheckboxStyle style, bool @checked) : base(label)
        {
            ItemType = SettingsItemType.CheckBox;
            Label = label;
            CheckBoxStyle = style;
            IsChecked = @checked;
        }
        public SettingsTabItem(string label, int max, int startIndex, HudColor barColor = HudColor.HUD_COLOUR_FREEMODE) : base(label)
        {
            ItemType = SettingsItemType.SliderBar;
            Label = label;
            MaxValue = max;
            Value = startIndex;
            ColoredBarColor = barColor;
        }

        internal void Activate()
        {
            if(ItemType == SettingsItemType.Basic)
            {
                OnActivate?.Invoke(this);
            }
        }
    }
}
