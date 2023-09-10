using ScaleformUI.PauseMenu;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.LobbyMenu
{
    public class MissionsListColumn : Column
    {
        private int currentSelection;
        public event IndexChanged OnIndexChanged;
        public List<MissionItem> Items { get; private set; }
        public MissionsListColumn(string label, HudColor color) : base(label, color)
        {
            Items = new List<MissionItem>();
            Type = "missions";
        }

        public void AddMissionItem(MissionItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            if (Parent != null && Parent.Visible)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("ADD_MISSIONS_ITEM", 0, item.Label, (int)item.MainColor, (int)item.HighlightColor, (int)item.LeftIcon, (int)item.LeftIconColor, (int)item.RightIcon, (int)item.RightIconColor, item.RightIconChecked, item.Enabled);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_MISSIONS_ITEM", ParentTab, 0, item.Label, (int)item.MainColor, (int)item.HighlightColor, (int)item.LeftIcon, (int)item.LeftIconColor, (int)item.RightIcon, (int)item.RightIconColor, item.RightIconChecked, item.Enabled);
            }
        }

        public void Clear()
        {
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_MISSIONS_COLUMN");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN", ParentTab);
        }

        public void RemoveItem(int id)
        {
            if (Parent != null && Parent.Visible)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("REMOVE_MISSIONS_ITEM", id);
                else if (Parent is TabView pause)
                    pause._pause._lobby.CallFunction("REMOVE_PLAYERS_TAB_MISSIONS_ITEM", ParentTab, id);
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
                        lobby._pause._lobby.CallFunction("SET_MISSIONS_SELECTION", CurrentSelection);
                    else if (Parent is TabView pause)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", ParentTab, CurrentSelection);
                }
            }
        }

        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
