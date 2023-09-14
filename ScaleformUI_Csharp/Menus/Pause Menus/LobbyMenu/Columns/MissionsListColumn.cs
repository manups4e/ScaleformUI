using CitizenFX.Core;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.LobbyMenu
{
    public class MissionsListColumn : Column
    {
        internal bool isBuilding = false;
        public event IndexChanged OnIndexChanged;
        public List<MissionItem> Items { get; private set; }
        public ScrollingType ScrollingType { get => Pagination.scrollType; set => Pagination.scrollType = value; }
        public MissionsListColumn(string label, HudColor color, ScrollingType scrollType = ScrollingType.CLASSIC) : base(label, color)
        {
            Items = new List<MissionItem>();
            Type = "missions";
            Pagination = new PaginationHandler
            {
                ItemsPerPage = 12,
                scrollType = scrollType
            };
        }

        public async void AddMissionItem(MissionItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            Pagination.TotalItems = Items.Count;
            if (Pagination.TotalItems == 0)
            {
                if (Parent != null && Parent.Visible)
                {
                    int sel = CurrentSelection;
                    if (Parent is MainView lobby) { }
                    else if (Parent is TabView pause)
                    {
                        int i = 0;
                        int max = Pagination.TotalItems >= Pagination.ItemsPerPage ? Pagination.ItemsPerPage : Pagination.TotalItems;
                        while (i < max)
                        {
                            await BaseScript.Delay(0);
                            if (!Parent.Visible) return;
                            _itemCreation(Pagination.CurrentPage, i, false);
                            i++;
                        }
                    }
                    CurrentSelection = sel;
                }
            }
        }

        internal void _itemCreation(int page, int pageIndex, bool before, bool isOverflow = false)
        {
            int menuIndex = Pagination.GetMenuIndexFromPageIndex(page, pageIndex);
            if (!before)
            {
                if (Pagination.GetPageItemsCount(page) < Pagination.ItemsPerPage && Pagination.TotalPages > 1)
                {
                    if (Pagination.scrollType == ScrollingType.ENDLESS)
                    {
                        if (menuIndex > Pagination.TotalItems - 1)
                        {
                            menuIndex -= Pagination.TotalItems;
                            Pagination.MaxItem = menuIndex;
                        }
                    }
                    else if (Pagination.scrollType == ScrollingType.CLASSIC && isOverflow)
                    {
                        int missingItems = Pagination.ItemsPerPage - Pagination.GetPageItemsCount(page);
                        menuIndex -= missingItems;
                    }
                    else if (Pagination.scrollType == ScrollingType.PAGINATED)
                        if (menuIndex >= Items.Count) return;
                }
            }

            MissionItem item = Items[menuIndex];

            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("ADD_MISSIONS_ITEM", before, menuIndex, 0, item.Label, (int)item.MainColor, (int)item.HighlightColor, (int)item.LeftIcon, (int)item.LeftIconColor, (int)item.RightIcon, (int)item.RightIconColor, item.RightIconChecked, item.Enabled);
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_MISSIONS_ITEM", ParentTab, before, menuIndex, 0, item.Label, (int)item.MainColor, (int)item.HighlightColor, (int)item.LeftIcon, (int)item.LeftIconColor, (int)item.RightIcon, (int)item.RightIconColor, item.RightIconChecked, item.Enabled);
        }


        public void Clear()
        {
            Pagination.CurrentMenuIndex = 0;
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_MISSIONS_COLUMN");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN", ParentTab);
            Items.Clear();
            Pagination.TotalItems = 0;
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

        internal async void GoUp()
        {
            try
            {
                Items[CurrentSelection].Selected = false;
                await BaseScript.Delay(0);
                bool overflow = CurrentSelection == 0 && Pagination.TotalPages > 1;
                if (Pagination.GoUp())
                {
                    if (Pagination.scrollType == ScrollingType.ENDLESS || (Pagination.scrollType == ScrollingType.CLASSIC && !overflow))
                    {
                        _itemCreation(Pagination.GetPage(CurrentSelection), Pagination.CurrentPageIndex, true);
                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("SET_INPUT_EVENT", 8, 100);
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("SET_INPUT_EVENT", 8, 100);
                    }
                    else if (Pagination.scrollType == ScrollingType.PAGINATED || (Pagination.scrollType == ScrollingType.CLASSIC && overflow))
                    {
                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("CLEAR_MISSIONS_COLUMN");
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN", ParentTab);
                        int i = 0;
                        int max = Pagination.ItemsPerPage;
                        while (i < max)
                        {
                            await BaseScript.Delay(0);
                            if (!Parent.Visible) return;
                            _itemCreation(Pagination.CurrentPage, i, false, true);
                            i++;
                        }
                    }
                }
                if (Parent is MainView _lobby)
                {
                    _lobby._pause._lobby.CallFunction("SET_MISSIONS_SELECTION", Pagination.ScaleformIndex);
                    _lobby._pause._lobby.CallFunction("SET_MISSIONS_QTTY", CurrentSelection + 1, Items.Count);
                }
                else if (Parent is TabView _pause)
                {
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", ParentTab, Pagination.ScaleformIndex);
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
                }

                Items[CurrentSelection].Selected = true;
                IndexChangedEvent();
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }

        internal async void GoDown()
        {
            try
            {
                Items[CurrentSelection].Selected = false;
                await BaseScript.Delay(0);
                bool overflow = CurrentSelection == Items.Count - 1 && Pagination.TotalPages > 1;
                if (Pagination.GoDown())
                {
                    if (Pagination.scrollType == ScrollingType.ENDLESS || (Pagination.scrollType == ScrollingType.CLASSIC && !overflow))
                    {
                        _itemCreation(Pagination.GetPage(CurrentSelection), Pagination.CurrentPageIndex, false);
                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("SET_INPUT_EVENT", 9, 100);
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("SET_INPUT_EVENT", 9, 100);
                    }
                    else if (Pagination.scrollType == ScrollingType.PAGINATED || (Pagination.scrollType == ScrollingType.CLASSIC && overflow))
                    {
                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("CLEAR_MISSIONS_COLUMN");
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN", ParentTab);
                        int i = 0;
                        int max = Pagination.ItemsPerPage;
                        while (i < max)
                        {
                            await BaseScript.Delay(0);
                            if (!Parent.Visible) return;
                            _itemCreation(Pagination.CurrentPage, i, false);
                            i++;
                        }
                    }
                }
                if (Parent is MainView _lobby)
                {
                    _lobby._pause._lobby.CallFunction("SET_MISSIONS_SELECTION", Pagination.ScaleformIndex);
                    _lobby._pause._lobby.CallFunction("SET_MISSIONS_QTTY", CurrentSelection + 1, Items.Count);
                }
                else if (Parent is TabView _pause)
                {
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", ParentTab, Pagination.ScaleformIndex);
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
                }

                Items[CurrentSelection].Selected = true;
                IndexChangedEvent();
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }

        public int CurrentSelection
        {
            get { return Items.Count == 0 ? 0 : Pagination.CurrentMenuIndex; }
            set
            {
                if (value < 0)
                {
                    Pagination.CurrentMenuIndex = 0;
                }
                else if (value >= Items.Count)
                {
                    Pagination.CurrentMenuIndex = Items.Count - 1;
                }
                Items[CurrentSelection].Selected = false;

                Pagination.CurrentMenuIndex = value;
                Pagination.CurrentPage = Pagination.GetPage(Pagination.CurrentMenuIndex);
                Pagination.CurrentPageIndex = value;
                Pagination.ScaleformIndex = Pagination.GetScaleformIndex(value);

                if (Parent != null && Parent.Visible)
                {
                    if (Parent is MainView lobby)
                    {
                        lobby._pause._lobby.CallFunction("SET_MISSIONS_SELECTION", Pagination.GetScaleformIndex(Pagination.CurrentMenuIndex));
                        lobby._pause._lobby.CallFunction("SET_MISSIONS_QTTY", CurrentSelection + 1, Items.Count);
                    }
                    else if (Parent is TabView pause)
                    {
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", ParentTab, Pagination.GetScaleformIndex(Pagination.CurrentMenuIndex));
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
                    }
                }
                Items[CurrentSelection].Selected = true;
            }
        }

        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
