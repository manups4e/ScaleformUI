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
        public IndexChanged OnIndexChanged;
        public MainView Parent { get; internal set; }
        public List<LobbyItem> Items { get; private set; }
        public PlayerListColumn(string label, HudColor color) : base(label, color)
        {
            Items = new List<LobbyItem>();
        }

        public void AddPlayer(LobbyItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
        }

        public int CurrentSelection
        {
            get { return Items.Count == 0 ? 0 : currentSelection % Items.Count; }
            set
            {
                if (Items.Count == 0) currentSelection = 0;
                Items[CurrentSelection].Selected = false;
                currentSelection = 1000000 - (1000000 % Items.Count) + value;
                Items[CurrentSelection].Selected = true;
                if(Parent != null && Parent.Visible)
                    Parent._pause._lobby.CallFunction("SET_PLAYERS_SELECTION", CurrentSelection);
            }
        }

        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
