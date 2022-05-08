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
        public LeftItemType ItemType { get; internal set; }
        public string Label { get; set; }
        public HudColor MainColor { get; set; }
        public HudColor HighlightColor { get; set; }
        public bool Enabled { get; set; }
        public bool Hovered { get; internal set; }
        public bool Selected { get; internal set; }
        public int ItemIndex { get; internal set; }
        public List<BasicTabItem> ItemList = new List<BasicTabItem>();
        public string TextTitle { get; set; }
        public string KeymapRightLabel_1 { get; set; }
        public string KeymapRightLabel_2 { get; set; }

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
