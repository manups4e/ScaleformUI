using CitizenFX.Core;
using ScaleformUI.Elements;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;

namespace ScaleformUI.LobbyMenu
{
    public delegate void MissionItemSelected(MissionItem item, int index);
    public class MissionsListColumn : Column
    {
        internal bool isBuilding = false;
        public event IndexChanged OnIndexChanged;
        public List<MissionItem> Items { get; private set; }
        public ScrollingType ScrollingType { get => Pagination.scrollType; set => Pagination.scrollType = value; }
        public event MissionItemSelected OnMissionItemActivated;
        public MissionsListColumn(string label, SColor color, ScrollingType scrollType = ScrollingType.CLASSIC) : base(label, color)
        {
            Items = new List<MissionItem>();
            Type = "missions";
            Pagination = new PaginationHandler
            {
                ItemsPerPage = 12,
                scrollType = scrollType
            };
        }

        public void AddMissionItem(MissionItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            Pagination.TotalItems = Items.Count;
            if (Parent != null && Parent.Visible)
            {
                if (Pagination.TotalItems < Pagination.ItemsPerPage)
                {
                    int sel = CurrentSelection;
                    Pagination.MinItem = Pagination.CurrentPageStartIndex;
                    if (Pagination.scrollType == ScrollingType.CLASSIC && Pagination.TotalPages > 1)
                    {
                        int missingItems = Pagination.GetMissingItems();
                        if (missingItems > 0)
                        {
                            Pagination.ScaleformIndex = Pagination.GetPageIndexFromMenuIndex(Pagination.CurrentPageEndIndex) + missingItems;
                            Pagination.MinItem = Pagination.CurrentPageStartIndex - missingItems;
                        }
                    }
                    Pagination.MaxItem = Pagination.CurrentPageEndIndex;
                    _itemCreation(Pagination.CurrentPage, Items.Count - 1, false);
                    if (Parent is TabView pause)
                    {
                        if ((pause.Tabs[ParentTab] as PlayerListTab).listCol[(pause.Tabs[ParentTab] as PlayerListTab).Focus] == this)
                            CurrentSelection = sel;
                    }
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
                lobby._pause._lobby.CallFunction("ADD_MISSIONS_ITEM", before, menuIndex, 0, item.Label, item.MainColor, item.HighlightColor, (int)item.LeftIcon, item.LeftIconColor, (int)item.RightIcon, item.RightIconColor, item.RightIconChecked, item.Enabled);
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_MISSIONS_ITEM", ParentTab, before, menuIndex, 0, item.Label, item.MainColor, item.HighlightColor, (int)item.LeftIcon, item.LeftIconColor, (int)item.RightIcon, item.RightIconColor, item.RightIconChecked, item.Enabled);
        }


        public void Clear()
        {
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_MISSIONS_COLUMN");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN", ParentTab);
            Items.Clear();
            Pagination.Reset();
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
                if (Pagination.TotalItems > 0)
                {
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
                            Items[CurrentSelection].Selected = true;
                        }
                        else if (Parent is TabView pause)
                        {
                            pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", ParentTab, Pagination.GetScaleformIndex(Pagination.CurrentMenuIndex));
                            pause._pause._pause.CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
                            if (pause.Index == pause.Tabs.IndexOf(pause.Tabs[ParentTab]) && pause.FocusLevel == 1)
                                Items[CurrentSelection].Selected = true;
                        }
                    }
                }
            }
        }

        public void SelectItem()
        {
            OnMissionItemActivated?.Invoke(Items[CurrentSelection], CurrentSelection);
        }
        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
