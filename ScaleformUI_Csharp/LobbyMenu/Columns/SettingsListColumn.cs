using ScaleformUI.PauseMenu;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.LobbyMenu
{
    public class SettingsListColumn : Column
    {
        private int currentSelection;

        public int ParentTab { get; internal set; }
        public event IndexChanged OnIndexChanged;
        public List<UIMenuItem> Items { get; internal set; }
        public PauseMenuBase Parent { get; internal set; }
        public SettingsListColumn(string label, HudColor color) : base(label, color)
        {
            Items = new List<UIMenuItem>();
        }
        public void AddSettings(UIMenuItem item)
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
                if (Parent != null && Parent.Visible)
                {
                    if (Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_SETTINGS_SELECTION", CurrentSelection);
                    else if (Parent is TabView pause)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", ParentTab, CurrentSelection);
                }
            }
        }

        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
