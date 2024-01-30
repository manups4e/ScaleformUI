using CitizenFX.Core;
using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;

namespace ScaleformUI.PauseMenus.Elements.Columns
{
    public delegate void StoreItemSelected(StoreItem item, int index);
    public class StoreListColumn : Column
    {
        public event IndexChanged OnIndexChanged;
        public List<StoreItem> Items { get; private set; }
        private List<StoreItem> _unfilteredItems;
        public ScrollingType ScrollingType { get => Pagination.scrollType; set => Pagination.scrollType = value; }
        public event StoreItemSelected ImageColumnItemActivated;
        public StoreListColumn(string label, SColor color, ScrollingType scrollType = ScrollingType.CLASSIC) : base(label, color)
        {
            Items = new();
            Type = "store";
            Pagination = new PaginationHandler
            {
                ItemsPerPage = 4,
                scrollType = scrollType
            };
        }

        public void AddStoreItem(StoreItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            Pagination.TotalItems = Items.Count;
            if (Parent != null && Parent.Visible)
            {
                if (Pagination.TotalItems <= Pagination.ItemsPerPage)
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

            StoreItem item = Items[menuIndex];

            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("ADD_STORE_ITEM", before, menuIndex, 0, item.textureDictionary, item.textureName, item.Description, item.Enabled);
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_STORE_ITEM", ParentTab, before, menuIndex, 0, item.textureDictionary, item.textureName, item.Description, item.Enabled);
        }

        public void Clear()
        {
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_STORE_COLUMN");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_STORE_COLUMN", ParentTab);
            Items.Clear();
            Pagination.Reset();
        }

        public void RemoveItem(int id)
        {
            if (Parent != null && Parent.Visible)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("REMOVE_STORE_ITEM", id);
                else if (Parent is TabView pause)
                    pause._pause._lobby.CallFunction("REMOVE_PLAYERS_TAB_STORE_ITEM", ParentTab, id);
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
                            lobby._pause._lobby.CallFunction("CLEAR_STORE_COLUMN");
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_STORE_COLUMN", ParentTab);
                        int max = Pagination.ItemsPerPage;
                        isBuilding = true;
                        for (int i = 0; i < max; i++)
                        {
                            if (!Parent.Visible) return;
                            _itemCreation(Pagination.CurrentPage, i, false, true);
                        }
                        isBuilding = false;
                    }
                }
                if (Parent is MainView _lobby)
                {
                    _lobby._pause._lobby.CallFunction("SET_STORE_SELECTION", Pagination.ScaleformIndex);
                    _lobby._pause._lobby.CallFunction("SET_STORE_QTTY", CurrentSelection + 1, Items.Count);
                }
                else if (Parent is TabView _pause)
                {
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_SELECTION", ParentTab, Pagination.ScaleformIndex);
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
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
                            lobby._pause._lobby.CallFunction("CLEAR_STORE_COLUMN");
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_STORE_COLUMN", ParentTab);
                        int max = Pagination.ItemsPerPage;
                        isBuilding = true;
                        for (int i = 0; i < max; i++)
                        {
                            if (!Parent.Visible) return;
                            _itemCreation(Pagination.CurrentPage, i, false, true);
                        }
                        isBuilding = false;
                    }
                }
                if (Parent is MainView _lobby)
                {
                    _lobby._pause._lobby.CallFunction("SET_STORE_SELECTION", Pagination.ScaleformIndex);
                    _lobby._pause._lobby.CallFunction("SET_STORE_QTTY", CurrentSelection + 1, Items.Count);
                }
                else if (Parent is TabView _pause)
                {
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_SELECTION", ParentTab, Pagination.ScaleformIndex);
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
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
                    if (value > Pagination.MaxItem || value < Pagination.MinItem)
                    {
                        RefreshColumn();
                    }

                    if (Parent != null && Parent.Visible)
                    {
                        if (Parent is MainView lobby)
                        {
                            lobby._pause._lobby.CallFunction("SET_STORE_SELECTION", Pagination.GetScaleformIndex(Pagination.CurrentMenuIndex));
                            lobby._pause._lobby.CallFunction("SET_STORE_QTTY", CurrentSelection + 1, Items.Count);
                            Items[CurrentSelection].Selected = true;
                        }
                        else if (Parent is TabView pause)
                        {
                            pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_SELECTION", ParentTab, Pagination.GetScaleformIndex(Pagination.CurrentMenuIndex));
                            pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
                            if (pause.Index == pause.Tabs.IndexOf(pause.Tabs[ParentTab]) && pause.FocusLevel == 1)
                                Items[CurrentSelection].Selected = true;
                        }
                    }
                }
            }
        }

        public void SortMissions(Comparison<StoreItem> compare)
        {
            Items[CurrentSelection].Selected = false;
            if (_unfilteredItems == null || _unfilteredItems.Count == 0)
            {
                _unfilteredItems = Items.ToList();
            }
            Clear();
            List<StoreItem> list = _unfilteredItems.ToList();
            list.Sort(compare);
            Items = list.ToList();
            Pagination.TotalItems = Items.Count;
            if (Parent != null && Parent.Visible)
            {
                if (Parent is MainView lobby)
                    lobby.buildMissions();
                else if (Parent is TabView pause)
                    pause.buildMissions(pause.Tabs[ParentTab] as PlayerListTab);
            }
        }

        public void FilterMissions(Func<StoreItem, bool> predicate)
        {
            Items[CurrentSelection].Selected = false;
            if (_unfilteredItems == null || _unfilteredItems.Count == 0)
            {
                _unfilteredItems = Items.ToList();
            }
            Clear();
            Items = _unfilteredItems.Where(predicate.Invoke).ToList();
            Pagination.TotalItems = Items.Count;
            if (Parent != null && Parent.Visible)
            {
                if (Parent is MainView lobby)
                    lobby.buildMissions();
                else if (Parent is TabView pause)
                    pause.buildMissions(pause.Tabs[ParentTab] as PlayerListTab);
            }
        }

        public void ResetFilter()
        {
            if (_unfilteredItems != null && _unfilteredItems.Count > 0)
            {
                Items[CurrentSelection].Selected = false;
                Clear();
                Items = _unfilteredItems.ToList();
                Pagination.TotalItems = Items.Count;
                if (Parent != null && Parent.Visible)
                {
                    if (Parent is MainView lobby)
                        lobby.buildMissions();
                    else if (Parent is TabView pause)
                        pause.buildMissions(pause.Tabs[ParentTab] as PlayerListTab);
                }
            }
        }

        private void RefreshColumn()
        {
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_STORE_COLUMN");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_STORE_COLUMN", ParentTab);
            if (Items.Count > 0)
            {
                isBuilding = true;
                int max = Pagination.ItemsPerPage;
                if (Items.Count < max)
                    max = Items.Count;

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

                for (int i = 0; i < max; i++)
                {
                    if (!Parent.Visible) return;
                    _itemCreation(Pagination.CurrentPage, i, false, true);
                }
                Pagination.ScaleformIndex = Pagination.GetScaleformIndex(CurrentSelection);
                if (Parent is MainView _lobby)
                {
                    _lobby._pause._lobby.CallFunction("SET_STORE_SELECTION", Pagination.ScaleformIndex);
                    _lobby._pause._lobby.CallFunction("SET_STORE_QTTY", CurrentSelection + 1, Items.Count);
                }
                else if (Parent is TabView _pause)
                {
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_SELECTION", ParentTab, Pagination.ScaleformIndex);
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
                }
                isBuilding = false;
            }
        }


        public void SelectItem()
        {
            ImageColumnItemActivated?.Invoke(Items[CurrentSelection], CurrentSelection);
        }
        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
