namespace ScaleformUI.PauseMenu
{
    public delegate void SettingsListItemChanged(SettingsListItem item, int value, string listItem);
    public delegate void SettingsListItemSelected(SettingsListItem item, int value, string listItem);
    public class SettingsListItem : SettingsItem
    {
        internal int itemIndex;
        public List<dynamic> ListItems { get; set; }
        public event SettingsListItemChanged OnListItemChanged;
        public event SettingsListItemSelected OnListItemSelected;
        public int ItemIndex
        {
            get => itemIndex;
            set
            {
                itemIndex = value;
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.UpdateSlot(ParentColumn.Items.IndexOf(this));
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
