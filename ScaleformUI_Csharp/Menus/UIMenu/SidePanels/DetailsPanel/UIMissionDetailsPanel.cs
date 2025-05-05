using ScaleformUI.Elements;
using System.Drawing;

namespace ScaleformUI.Menu
{
    public class UIMissionDetailsPanel : UIMenuSidePanel
    {
        private string title;
        public string TextureDict { get; private set; }
        public string TextureName { get; private set; }
        internal SidePanelsTitleType _titleType;
        public string Title
        {
            get => title;
            set
            {
                title = value;
                if (ParentItem is not null && ParentItem.Parent != null && ParentItem.Parent.Visible)
                {
                    int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                    ParentItem.Parent.SendSidePanelToScaleform(it, true);
                }
            }
        }
        public SColor TitleColor;
        public List<UIFreemodeDetailsItem> Items = new();

        /// <summary>
        /// Adds a Mission Details panel as side menu panel
        /// </summary>
        /// <param name="side">Left or Right?</param>
        /// <param name="title">Panel's title</param>
        /// <param name="inside">if true the title will be within the panel itself else will be the same as the menu.</param>
        /// <param name="txd">Texture dictionary for the picture</param>
        /// <param name="txn">Texture name for the picture</param>
        public UIMissionDetailsPanel(PanelSide side, string title, bool inside, string txd = "", string txn = "")
        {
            PanelSide = side;
            if (inside)
                _titleType = SidePanelsTitleType.Classic;
            else
                _titleType = SidePanelsTitleType.Big;
            Title = title;
            TitleColor = SColor.HUD_None;
            TextureDict = txd;
            TextureName = txn;
        }

        /// <summary>
        /// Adds a Mission Details panel as side menu panel
        /// </summary>
        /// <param name="side">Left or Right?</param>
        /// <param name="title">Panel's title</param>
        /// <param name="color">Background color for the panel title</param>
        /// <param name="txd">Texture dictionary for the picture</param>
        /// <param name="txn">Texture name for the picture</param>
        public UIMissionDetailsPanel(PanelSide side, string title, SColor color, string txd = "", string txn = "")
        {
            PanelSide = side;
            _titleType = SidePanelsTitleType.Small;
            Title = title;
            TitleColor = color;
            TextureDict = txd;
            TextureName = txn;
        }

        /// <summary>
        /// To change panel's picture
        /// </summary>
        /// <param name="txd">Texture dictionary for the picture</param>
        /// <param name="txn">Texture name for the picture</param>
        public void UpdatePanelPicture(string txd, string txn)
        {
            TextureDict = txd;
            TextureName = txn;
            if (ParentItem is not null && ParentItem.Parent != null && ParentItem.Parent.Visible)
            {
                int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ParentItem.Parent.SendSidePanelToScaleform(it, true);
            }

        }

        /// <summary>
        /// Adds an item to the description of the panel
        /// </summary>
        /// <param name="item">The items to add</param>
        public void AddItem(UIFreemodeDetailsItem item)
        {
            Items.Add(item);
            if (ParentItem is not null && ParentItem.Parent != null && ParentItem.Parent.Visible)
            {
                int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ParentItem.Parent.SendSidePanelToScaleform(it, true);
            }
        }

        public void Clear()
        {
            Title = "";
            TextureDict = "";
            TextureName = "";
            Items.Clear();
            if (ParentItem is not null && ParentItem.Parent != null && ParentItem.Parent.Visible)
            {
                Main.scaleformUI.CallFunction("SET_PANEL_DATA_SLOT_EMPTY");
            }
        }

        public void Refresh()
        {
            if (ParentItem is not null && ParentItem.Parent != null && ParentItem.Parent.Visible)
            {
                int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ParentItem.Parent.SendSidePanelToScaleform(it);
            }
        }

        /// <summary>
        /// Removes an item from the scription of the panel
        /// </summary>
        /// <param name="idx">item's index</param>
        public void RemoveItem(int idx)
        {
            Items.RemoveAt(idx);
            if (ParentItem is not null && ParentItem.Parent != null && ParentItem.Parent.Visible)
            {
                int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ParentItem.Parent.SendSidePanelToScaleform(it, true);
            }
        }
    }
}
