using CitizenFX.Core;
using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;
using System.Linq;

namespace ScaleformUI.PauseMenus.Elements.Columns
{
    public delegate void StoreItemSelected(StoreItem item, int index);
    public class StoreListColumn : PM_Column
    {
        public event IndexChanged OnIndexChanged;
        private List<PauseMenuItem> _unfilteredItems;
        private int _unfilteredSelection = 0;
        public event StoreItemSelected StoreItemActivated;
        public StoreListColumn(string label) : base(-1)
        {
            Label = label;
            VisibleItems = 4;
            type = (int)PLT_COLUMNS.STORE;
        }

        public void AddStoreItem(StoreItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            if (visible && Items.Count <= VisibleItems)
            {
                var idx = Items.Count - 1;
                AddSlot(idx);
                item.Selected = idx == index;
            }
        }

        public override void SetDataSlot(int index)
        {
            this.SendItemToScaleform(index);
        }

        public override void UpdateSlot(int index)
        {
            if (index >= Items.Count) return;
            if (visible)
                SendItemToScaleform(index, true);
        }

        public override void AddSlot(int index)
        {
            if (index >= Items.Count) return;
            if (visible)
                SendItemToScaleform(index, false, false, true);
        }

        public override void Populate()
        {
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", (int)position);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_MAX_ITEMS", (int)position, VisibleItems);
            for (var i = 0; i < Items.Count; i++)
            {
                SetDataSlot(i);
            }
        }

        internal void SendItemToScaleform(int i, bool update = false, bool newItem = false, bool isSlot = false)
        {
            if (i >= Items.Count) return;
            StoreItem item = (StoreItem)Items[i];
            string str = "SET_DATA_SLOT";
            if (update)
                str = "UPDATE_SLOT";
            if (newItem)
                str = "ADD_SLOT";
            if (isSlot)
                str = "SET_SLOT_EMPTY";
            Main.PauseMenu._pause.CallFunction(str, (int)position, i, 0, 0, i, 0, item.Enabled, item.textureDictionary, item.textureName, item.Description);
        }

        public override void ShowColumn(bool show = true)
        {
            base.ShowColumn(show);
            InitColumnScroll(true, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT);
            SetColumnScroll(Index + 1, Items.Count, VisibleItems, CaptionLeft, Items.Count < VisibleItems);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, Focused, false, false);
        }

        public void Clear()
        {
            if (visible)
                ClearColumn();
            Items.Clear();
        }

        public override void GoUp()
        {
            try
            {
                CurrentItem.Selected = false;
                index--;
                if (index < 0)
                    index = Items.Count - 1;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", (int)position, 8);
                CurrentItem.Selected = true;
                IndexChangedEvent();
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }

        public override void GoDown()
        {
            try
            {
                CurrentItem.Selected = false;
                index++;
                if (index >= Items.Count)
                    index = 0;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", (int)position, 9);
                CurrentItem.Selected = true;
                IndexChangedEvent();
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }

        public override void Select()
        {
            SelectItem();
        }

        public override void GoBack()
        {
            Focused = false;
        }

        public override void MouseScroll(int dir)
        {
            CurrentItem.Selected = false;
            index += dir;
            if (index < 0)
                index = Items.Count - 1;
            if (index >= Items.Count)
                index = 0;
            CurrentItem.Selected = true;
            IndexChangedEvent();
        }

        public StoreItem CurrentItem => (StoreItem)Items[CurrentSelection];
        public int CurrentSelection
        {
            get => index;
            set
            {
                CurrentItem.Selected = false;
                index = value;
                if (index < 0)
                    index = Items.Count - 1;
                else if (index >= Items.Count)
                    index = 0;
                CurrentItem.Selected = true;
                if (visible)
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, true, true);
                IndexChangedEvent();
            }
        }

        public void RemoveItem(int id)
        {
            Items.RemoveAt(id);
            if (visible)
            {

            }
        }

        public void SortMissions(Comparison<StoreItem> compare)
        {
            try
            {
                CurrentItem.Selected = false;
                _unfilteredItems = Items.ToList();
                _unfilteredSelection = CurrentSelection;
                Clear();
                List<StoreItem> list = _unfilteredItems.Cast<StoreItem>().ToList();
                list.Sort(compare);
                Items = list.Cast<PauseMenuItem>().ToList();
                if (visible)
                {
                    Populate();
                    ShowColumn();
                }
            }
            catch (Exception ex)
            {
                ResetFilter();
                Debug.WriteLine("ScaleformUI - " + ex.ToString());
            }
        }

        public void FilterMissions(Func<StoreItem, bool> predicate)
        {
            if (predicate == null)
                throw new ArgumentNullException(nameof(predicate));
            try
            {
                _unfilteredItems = Items.ToList();
                _unfilteredSelection = CurrentSelection;
                //_unfilteredTopEdge = topEdge;

                var filteredItems = Items.Cast<StoreItem>().Where(predicate).ToList();

                if (!filteredItems.Any())
                {
                    Debug.WriteLine("^1ScaleformUI - No items were found, resetting the filter");
                    _unfilteredItems.Clear();
                    _unfilteredSelection = 0;
                    return;
                }

                Items[CurrentSelection].Selected = false;
                Clear();

                Items = filteredItems.Cast<PauseMenuItem>().ToList();
                CurrentSelection = 0;

                if (visible)
                {
                    Populate();
                    ShowColumn();
                }
            }
            catch (Exception ex)
            {
                ResetFilter();
                Debug.WriteLine($"^1ScaleformUI - Error filtering menu items: {ex}");
                throw;
            }
        }

        public void ResetFilter()
        {
            try
            {
                if (_unfilteredItems != null && _unfilteredItems.Count > 0)
                {
                    CurrentItem.Selected = false;
                    Clear();
                    Items = _unfilteredItems.ToList();
                    CurrentSelection = _unfilteredSelection;
                    if (visible)
                    {
                        Populate();
                        ShowColumn();
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("ScaleformUI - " + ex.ToString());
            }
        }

        //private void RefreshColumn()
        //{
        //    if (Parent is MainView lobby)
        //        lobby._pause._lobby.CallFunction("CLEAR_STORE_COLUMN");
        //    else if (Parent is TabView pause && ParentTab.Visible)
        //        pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_STORE_COLUMN");
        //    if (Items.Count > 0)
        //    {
        //        isBuilding = true;
        //        int max = Pagination.ItemsPerPage;
        //        if (Items.Count < max)
        //            max = Items.Count;

        //        Pagination.MinItem = Pagination.CurrentPageStartIndex;
        //        if (Pagination.scrollType == ScrollingType.CLASSIC && Pagination.TotalPages > 1)
        //        {
        //            int missingItems = Pagination.GetMissingItems();
        //            if (missingItems > 0)
        //            {
        //                Pagination.ScaleformIndex = Pagination.GetPageIndexFromMenuIndex(Pagination.CurrentPageEndIndex) + missingItems;
        //                Pagination.MinItem = Pagination.CurrentPageStartIndex - missingItems;
        //            }
        //        }
        //        Pagination.MaxItem = Pagination.CurrentPageEndIndex;

        //        for (int i = 0; i < max; i++)
        //        {
        //            if (!Parent.Visible) return;
        //            _itemCreation(Pagination.CurrentPage, i, false, true);
        //        }
        //        Pagination.ScaleformIndex = Pagination.GetScaleformIndex(CurrentSelection);
        //        if (Parent is MainView _lobby)
        //        {
        //            _lobby._pause._lobby.CallFunction("SET_STORE_SELECTION", Pagination.ScaleformIndex);
        //            _lobby._pause._lobby.CallFunction("SET_STORE_QTTY", CurrentSelection + 1, Items.Count);
        //        }
        //        else if (Parent is TabView _pause && ParentTab.Visible)
        //        {
        //            _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_SELECTION", Pagination.ScaleformIndex);
        //            _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_STORE_QTTY", CurrentSelection + 1, Items.Count);
        //        }
        //        isBuilding = false;
        //    }
        //}


        public void SelectItem()
        {
            StoreItemActivated?.Invoke(CurrentItem, CurrentSelection);
        }
        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
