using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public class UIMissionDetailsPanel : UIMenuSidePanel
    {
        private string title;
        public string TextureDict;
        public string TextureName;
        internal SidePanelsTitleType _titleType;
        public string Title
        {
            get => title;
            set
            {
                title = value;
                if(ParentItem is not null)
                {
                    ScaleformUI._ui.CallFunction("UPDATE_SIDE_PANEL_TITLE", ParentItem.Parent.MenuItems.IndexOf(ParentItem), title);
                }
            }
        }
        public HudColor TitleColor;
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
            TitleColor = HudColor.NONE;
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
        public UIMissionDetailsPanel(PanelSide side, string title, HudColor color, string txd = "", string txn = "")
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
            if (ParentItem is not null)
            {
                var wid = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ScaleformUI._ui.CallFunction("UPDATE_MISSION_DETAILS_PANEL_IMG", wid, TextureDict, TextureName);
            }

        }

        /// <summary>
        /// Adds an item to the description of the panel
        /// </summary>
        /// <param name="item">The items to add</param>
        public void AddItem(UIFreemodeDetailsItem item)
        {
            Items.Add(item);
            if (ParentItem is not null)
            {
                var wid = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ScaleformUI._ui.CallFunction("ADD_MISSION_DETAILS_DESC_ITEM", wid, item.Type, item.TextLeft, item.TextRight, (int)item.Icon, (int)item.IconColor, item.Tick);
            }
        }

        /// <summary>
        /// Removes an item from the scription of the panel
        /// </summary>
        /// <param name="idx">item's index</param>
        public void RemoveItem(int idx)
        {
            Items.RemoveAt(idx);
            if (ParentItem is not null)
            {
                var wid = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ScaleformUI._ui.CallFunction("REMOVE_MISSION_DETAILS_DESC_ITEM", wid, TextureDict, TextureName);
            }
        }
    }
}
