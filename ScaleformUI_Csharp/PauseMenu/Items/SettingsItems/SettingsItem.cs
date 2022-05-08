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

    public delegate void SettingsItemSelected(SettingsItem item);

    public class SettingsItem : BasicTabItem
    {
        private string rightLabel;
        public event SettingsListItemChanged OnListItemChange;
        public event SettingsItemSelected OnActivate;
        public bool Enabled { get; set; }
        public bool Hovered { get; internal set; }
        public bool Selected { get; internal set; }
        public SettingsItemType ItemType { get; set; }

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

        public SettingsItem(string label, string rightLabel) : base(label)
        {
            ItemType = SettingsItemType.Basic;
            Label = label;
            RightLabel = rightLabel;
        }

        internal void Activated()
        {
            if(ItemType != SettingsItemType.Basic)
            {
                OnActivate?.Invoke(this);
            }
        }
    }
}
