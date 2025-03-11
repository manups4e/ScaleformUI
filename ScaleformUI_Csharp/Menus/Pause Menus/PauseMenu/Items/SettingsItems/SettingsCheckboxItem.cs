using ScaleformUI.Menu;

namespace ScaleformUI.PauseMenu
{
    public delegate void SettingsCheckboxChanged(SettingsItem item, bool value);
    public class SettingsCheckboxItem : SettingsItem
    {
        private bool isChecked;
        public event SettingsCheckboxChanged OnCheckboxChange;
        public UIMenuCheckboxStyle CheckBoxStyle { get; set; }
        public bool IsChecked
        {
            get => isChecked;
            set
            {
                isChecked = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible && Parent.Parent.Parent != null && Parent.Parent.Parent.Visible && Parent.Parent.CenterColumn.Items.Contains(this))
                    Parent?.Parent?.UpdateSlot(Menus.PM_COLUMNS.MIDDLE, Parent.Parent.CenterColumn.Items.IndexOf(this));
                CheckboxChanged();
            }
        }
        public SettingsCheckboxItem(string label, UIMenuCheckboxStyle style, bool @checked) : base(label, "")
        {
            ItemType = SettingsItemType.CheckBox;
            Label = label;
            CheckBoxStyle = style;
            IsChecked = @checked;
        }

        public void CheckboxChanged()
        {
            OnCheckboxChange?.Invoke(this, isChecked);
        }
    }
}
