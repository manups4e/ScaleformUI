using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.LobbyMenu
{
    public class MissionDetailsPanel : Column
    {
        private string title = "";
        public string TextureDict = "";
        public string TextureName = "";
        public string Title
        {
            get => title;
            set
            {
                title = value;
                if (Parent != null && Parent.Visible)
                {
                    if (Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_MISSION_PANEL_TITLE", title);
                    else if (Parent is TabView pause)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSION_PANEL_TITLE", ParentTab, title);
                }
            }
        }

        public List<UIFreemodeDetailsItem> Items { get; private set; }
        public MissionDetailsPanel(string label, HudColor color) : base(label, color)
        {
            Items = new List<UIFreemodeDetailsItem>();
            Type = "panel";
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
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("ADD_MISSION_PANEL_PICTURE", TextureDict, TextureName);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_PICTURE", ParentTab, TextureDict, TextureName);
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
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("ADD_MISSION_PANEL_ITEM", item.Type, item.TextLeft, item.TextRight, (int)item.Icon, (int)item.IconColor, item.Tick);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_ITEM", ParentTab, item.Type, item.TextLeft, item.TextRight, (int)item.Icon, (int)item.IconColor, item.Tick);
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
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("REMOVE_MISSION_PANEL_ITEM", idx);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("REMOVE_PLAYERS_TAB_MISSION_PANEL_ITEM", ParentTab, idx);
            }
        }

        public void Clear()
        {
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_MISSION_PANEL_ITEMS");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_MISSION_PANEL_ITEMS", ParentTab);
        }
    }
}
