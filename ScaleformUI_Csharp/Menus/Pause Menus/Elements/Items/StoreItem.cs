using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Columns;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public delegate void ImageColumnActivated(PlayerListTab tab, StoreListColumn column, int index);

    public class StoreItem
    {
        internal string textureName;
        internal string textureDictionary;
        internal string description = string.Empty;
        public event ImageColumnActivated ImageActivated;
        public StoreListColumn ParentColumn { get; internal set; }
        public string TextureDictionary { get => textureDictionary; }
        public string TextureName { get => textureName; }
        public string Description { get => description; }
        public bool Selected { get; internal set; }
        public bool Enabled { get; internal set; }
        public bool Hovered { get; internal set; }

        public StoreItem(string textureDictionary, string textureName)
        {
            this.textureName = textureName;
            this.textureDictionary = textureDictionary;
        }
        public StoreItem(string textureDictionary, string textureName, string description)
        {
            this.textureName = textureName;
            this.textureDictionary = textureDictionary;
            this.description = description;
        }

        internal void ActivateImage(PlayerListTab tab)
        {
            this.ImageActivated?.Invoke(tab, ParentColumn, ParentColumn.Items.IndexOf(this));
        }
    }
}
