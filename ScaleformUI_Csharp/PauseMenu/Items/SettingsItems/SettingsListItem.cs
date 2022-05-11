using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public delegate void SettingsListItemChanged(SettingsListItem item, int value, string listItem);
    public delegate void SettingsListItemSelected(SettingsListItem item, int value, string listItem);
    public class SettingsListItem : SettingsItem
    {
        private int itemIndex;
        public List<dynamic> ListItems { get; set; }
        public event SettingsListItemChanged OnListItemChanged;
        public event SettingsListItemSelected OnListItemSelected;
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
                ListChanged();
            }
        }

        public SettingsListItem(string label, List<dynamic> items, int startIndex) : base(label, "")
        {
            ItemType = SettingsItemType.ListItem;
            Label = label;
            ListItems = items;
            ItemIndex = startIndex;
        }

        public string CurrentItem()
        {
            return ListItems[ItemIndex].ToString();
        }

        public void ListSelected()
        {
            OnListItemSelected?.Invoke(this, itemIndex, CurrentItem());
        }

        public void ListChanged()
        {
            OnListItemChanged?.Invoke(this, itemIndex, "" + CurrentItem());
        }
    }
}
