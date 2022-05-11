using CitizenFX.Core;
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
        private bool enabled = true;

        public event SettingsItemSelected OnActivate;
        public bool Enabled
        {
            get => enabled;
            set
            {
                enabled = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Parent != null && Parent.Parent.Parent.Visible)
                {
                    if (Parent.Selected)
                    {
                        var tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                        var it = Parent.Parent.LeftItemList.IndexOf(Parent);
                        var rIt = Parent.ItemList.IndexOf(this);
                        Parent.Parent.Parent._pause._pause.CallFunction("ENABLE_RIGHT_ITEM", tab, it, rIt, enabled);
                    }
                }
            }
        }
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
            if (ItemType == SettingsItemType.Basic)
            {
                OnActivate?.Invoke(this);
            }
        }
    }
}
