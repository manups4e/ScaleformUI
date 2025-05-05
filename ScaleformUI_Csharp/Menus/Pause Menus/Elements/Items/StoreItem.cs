using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Columns;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public delegate void StoreItemActivated(PlayerListTab tab, StoreListColumn column, int index);

    public class StoreItem : PauseMenuItem
    {
        internal string textureName;
        internal string textureDictionary;
        internal string description = string.Empty;
        public event StoreItemActivated Activated;
        public StoreListColumn ParentColumn { get; internal set; }
        public string TextureDictionary { get => textureDictionary; }
        public string TextureName { get => textureName; }
        public string Description { get => description; }
        public bool Enabled { get; internal set; } = true;
        public bool Hovered { get; internal set; }

        public StoreItem(string textureDictionary, string textureName) : this(textureDictionary, textureName, string.Empty) { }

        public StoreItem(string textureDictionary, string textureName, string description) : base("")
        {
            this.textureName = textureName;
            this.textureDictionary = textureDictionary;
            this.description = description;
        }
        public override bool Selected
        {
            get => base.Selected;
            set
            {
                base.Selected = value;
                if (ParentColumn != null && ParentColumn.visible)
                    ParentColumn.UpdateSlot(ParentColumn.Items.IndexOf(this));
            }
        }

        internal void Activate(PlayerListTab tab)
        {
            this.Activated?.Invoke(tab, ParentColumn, ParentColumn.Items.IndexOf(this));
        }
    }
}
