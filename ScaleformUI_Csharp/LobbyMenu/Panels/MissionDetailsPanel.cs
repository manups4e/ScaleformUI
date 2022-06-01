using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.LobbyMenu
{
    public class MissionDetailsPanel : Column
    {
        private string title = "";
        public string TextureDict = "";
        public string TextureName = "";
        public MainView Parent { get; internal set; }
        public string Title
        {
            get => title;
            set
            {
                title = value;
                if (Parent != null && Parent.Visible)
                {
                    ScaleformUI.PauseMenu._lobby.CallFunction("SET_MISSION_PANEL_TITLE", title);
                }
            }
        }

        public List<UIFreemodeDetailsItem> Items {get; private set;}
        public MissionDetailsPanel(string label, HudColor color) : base(label, color)
        {
            Items = new List<UIFreemodeDetailsItem>();
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
            if (Parent != null && Parent.Visible)
            {
                ScaleformUI.PauseMenu._lobby.CallFunction("ADD_MISSION_PANEL_PICTURE", TextureDict, TextureName);
            }

        }

        /// <summary>
        /// Adds an item to the description of the panel
        /// </summary>
        /// <param name="item">The items to add</param>
        public void AddItem(UIFreemodeDetailsItem item)
        {
            Items.Add(item);
            if (Parent != null && Parent.Visible)
            {
                ScaleformUI.PauseMenu._lobby.CallFunction("ADD_MISSION_PANEL_ITEM", item.Type, item.TextLeft, item.TextRight, (int)item.Icon, (int)item.IconColor, item.Tick);
            }
        }

        /// <summary>
        /// Removes an item from the scription of the panel
        /// </summary>
        /// <param name="idx">item's index</param>
        public void RemoveItem(int idx)
        {
            Items.RemoveAt(idx);
            if (Parent != null && Parent.Visible)
            {
                ScaleformUI.PauseMenu._lobby.CallFunction("REMOVE_MISSION_PANEL_ITEM", idx);
            }
        }
    }
}
