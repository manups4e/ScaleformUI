using CitizenFX.Core;
using ScaleformUI.PauseMenu;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.LobbyMenu
{
    public class PlayerListColumn : Column
    {
        private int currentSelection;
        public event IndexChanged OnIndexChanged;
        public int ParentTab { get; internal set; }
        public List<LobbyItem> Items { get; private set; }
        public PlayerListColumn(string label, HudColor color) : base(label, color)
        {
            Items = new List<LobbyItem>();
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
                        var fi = (FriendItem)item;
                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("ADD_PLAYER_ITEM", 1, 1, fi.Label, (int)fi.ItemColor, fi.ColoredTag, fi.iconL, fi.boolL, fi.iconR, fi.boolR, fi.Status, (int)fi.StatusColor, fi.Rank, fi.CrewTag);
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_PLAYER_ITEM", ParentTab, 1, 1, fi.Label, (int)fi.ItemColor, fi.ColoredTag, fi.iconL, fi.boolL, fi.iconR, fi.boolR, fi.Status, (int)fi.StatusColor, fi.Rank, fi.CrewTag);
                        break;
                }
                if (item.Panel != null)
                    item.Panel.UpdatePanel(true);
            }
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
                if (Items.Count == 0) currentSelection = 0;
                Items[CurrentSelection].Selected = false;
                currentSelection = value < 0 ? 0 : value >= Items.Count ? Items.Count - 1 : 1000000 - (1000000 % Items.Count) + value;
                Items[CurrentSelection].Selected = true;
                if (Parent != null && Parent.Visible)
                {
                    if (Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_PLAYERS_SELECTION", CurrentSelection);
                    else if (Parent is TabView pause)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_PLAYERS_SELECTION", ParentTab, CurrentSelection);
                }
            }
        }

        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
