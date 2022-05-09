using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public enum LeftItemType
    {
        Empty,
        Info,
        Statistics,
        Settings,
        Keymap
    }

    public delegate void IndexChangeEvent(SettingsItem item, int index);
    public delegate void ActivatedEvent(TabLeftItem item, int index);

    public class TabLeftItem
    {
        private bool enabled = true;
        private string label;
        private HudColor mainColor;
        private HudColor highlightColor;
        private string textTitle;
        private string keymapRightLabel_1;
        private string keymapRightLabel_2;
        public LeftItemType ItemType { get; internal set; }
        public string Label
        {
            get => label;
            set
            {
                label = value;
                if(Parent != null && Parent.Visible)
                {
                    var tab = Parent.Parent.Tabs.IndexOf(Parent);
                    var it = Parent.LeftItemList.IndexOf(this);
                    Parent.Parent._pause._pause.CallFunction("UPDATE_LEFT_ITEM_LABEL", tab, it, label);
                }
            }
        }
        public HudColor MainColor { get => mainColor; set => mainColor = value; }
        public HudColor HighlightColor { get => highlightColor; set => highlightColor = value; }
        public bool Enabled
        {
            get => enabled;
            set
            {
                enabled = value;
                if (Parent != null && Parent.Visible)
                {
                    var tab = Parent.Parent.Tabs.IndexOf(Parent);
                    var it = Parent.LeftItemList.IndexOf(this);
                    Parent.Parent._pause._pause.CallFunction("ENABLE_LEFT_ITEM", tab, it, enabled);
                }
            }
        }

        public bool Hovered { get; internal set; }
        public bool Selected { get; internal set; }
        public int ItemIndex { get; internal set; }
        public List<BasicTabItem> ItemList = new List<BasicTabItem>();

        public string TextTitle
        {
            get => textTitle;
            set
            {
                textTitle = value;
                if (Parent != null && Parent.Visible)
                {
                    var tab = Parent.Parent.Tabs.IndexOf(Parent);
                    var it = Parent.LeftItemList.IndexOf(this);
                    Parent.Parent._pause._pause.CallFunction("UPDATE_LEFT_ITEM_LABEL", tab, it, textTitle, KeymapRightLabel_1, KeymapRightLabel_2);
                }
            }
        }
        public string KeymapRightLabel_1
        {
            get => keymapRightLabel_1;
            set
            {
                keymapRightLabel_1 = value;
                if (Parent != null && Parent.Visible)
                {
                    var tab = Parent.Parent.Tabs.IndexOf(Parent);
                    var it = Parent.LeftItemList.IndexOf(this);
                    Parent.Parent._pause._pause.CallFunction("UPDATE_LEFT_ITEM_LABEL", tab, it, TextTitle, keymapRightLabel_1, KeymapRightLabel_2);
                }
            }
        }
        public string KeymapRightLabel_2
        {
            get => keymapRightLabel_2;
            set
            {
                keymapRightLabel_2 = value;
                if (Parent != null && Parent.Visible)
                {
                    var tab = Parent.Parent.Tabs.IndexOf(Parent);
                    var it = Parent.LeftItemList.IndexOf(this);
                    Parent.Parent._pause._pause.CallFunction("UPDATE_LEFT_ITEM_LABEL", tab, it, TextTitle, KeymapRightLabel_1, keymapRightLabel_2);
                }
            }
        }

        public event IndexChangeEvent OnIndexChanged;
        public event ActivatedEvent OnActivated;
        public BaseTab Parent { get; set; }

        public TabLeftItem(string label, LeftItemType type, HudColor mainColor = HudColor.NONE, HudColor highlightColor = HudColor.NONE)
        {
            Label = label;
            ItemType = type;
            MainColor = mainColor;
            HighlightColor = highlightColor;
        }

        public void AddItem(BasicTabItem item)
        {
            item.Parent = this;
            ItemList.Add(item);
        }

        internal void IndexChanged()
        {
            OnIndexChanged?.Invoke(ItemList[ItemIndex] as SettingsItem, ItemIndex);
        }

        internal void Activated()
        {
            OnActivated?.Invoke(this, Parent.LeftItemList.IndexOf(this));
        }
    }
}
