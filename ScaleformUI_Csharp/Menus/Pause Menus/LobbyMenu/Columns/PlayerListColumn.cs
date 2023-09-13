using CitizenFX.Core.Native;
using ScaleformUI.PauseMenu;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.LobbyMenu
{
    public class PlayerListColumn : Column
    {
        private int currentSelection;
        public event IndexChanged OnIndexChanged;
        public List<LobbyItem> Items { get; private set; }
        public PlayerListColumn(string label, HudColor color) : base(label, color)
        {
            Items = new List<LobbyItem>();
            Type = "players";
        }

        public void AddPlayer(LobbyItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            if (Parent != null && Parent.Visible)
            {
                switch (item)
                {
                    case FriendItem:
                        FriendItem fi = (FriendItem)item;
                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("ADD_PLAYER_ITEM", 1, 1, fi.Label, (int)fi.ItemColor, fi.ColoredTag, fi.iconL, fi.boolL, fi.iconR, fi.boolR, fi.Status, (int)fi.StatusColor, fi.Rank, fi.CrewTag, fi.KeepPanelVisible);
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_PLAYER_ITEM", ParentTab, 1, 1, fi.Label, (int)fi.ItemColor, fi.ColoredTag, fi.iconL, fi.boolL, fi.iconR, fi.boolR, fi.Status, (int)fi.StatusColor, fi.Rank, fi.CrewTag, fi.KeepPanelVisible);
                        break;
                }
                item.Panel?.UpdatePanel(true);
            }
        }

        public void Clear()
        {
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_PLAYERS_COLUMN");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_PLAYERS_COLUMN", ParentTab);
        }

        public void RemovePlayer(int id)
        {
            if (Parent != null && Parent.Visible)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("REMOVE_PLAYER_ITEM", id);
                else if (Parent is TabView pause)
                    pause._pause._lobby.CallFunction("REMOVE_PLAYERS_TAB_PLAYER_ITEM", ParentTab, id);
            }
            Items.RemoveAt(id);
        }

        public int CurrentSelection
        {
            get { return Items.Count == 0 ? 0 : currentSelection % Items.Count; }
            set
            {
                API.ClearPedInPauseMenu();
                if (Items.Count == 0) currentSelection = 0;
                Items[CurrentSelection].Selected = false;
                currentSelection = value < 0 ? 0 : value >= Items.Count ? Items.Count - 1 : 1000000 - (1000000 % Items.Count) + value;
                if (Parent != null && Parent.Visible)
                {
                    if (Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYERS_SELECTION", CurrentSelection);
                    else if (Parent is TabView pause)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYERS_SELECTION", ParentTab, CurrentSelection);
                }
                Items[CurrentSelection].Selected = true;
                if (Items[CurrentSelection].ClonePed != null)
                    Items[CurrentSelection].CreateClonedPed();
            }
        }

        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
