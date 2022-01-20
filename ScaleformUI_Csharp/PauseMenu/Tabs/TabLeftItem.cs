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
        Settings
    }

    public delegate void IndexChangeEvent(SettingsTabItem item, int index);
    public delegate void ActivatedEvent(TabLeftItem item, int index);

    public class TabLeftItem
    {
        public bool Highlighted { get; set; }
        public LeftItemType ItemType { get; set; }
        public string Label { get; set; }
        public HudColor MainColor { get; set; }
        public HudColor HighlightColor { get; set; }

        public int ItemIndex { get; set; }
        public List<BasicTabItem> ItemList = new List<BasicTabItem>();
        public string TextTitle { get; set; }

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
            OnIndexChanged?.Invoke(ItemList[ItemIndex] as SettingsTabItem, ItemIndex);
        }

        internal void Activated()
        {
            OnActivated?.Invoke(this, Parent.LeftItemList.IndexOf(this));
        }
    }
}
