using CitizenFX.Core;
using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.Scaleforms;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.LobbyMenu
{
    public class SettingsListColumn : Column
    {
        internal bool isBuilding = false;
        private bool cleared = false;
        public event IndexChanged OnIndexChanged;
        public List<UIMenuItem> Items { get; internal set; }
        public ScrollingType ScrollingType { get => Pagination.scrollType; set => Pagination.scrollType = value; }
        public SettingsListColumn(string label, HudColor color, ScrollingType scrollType = ScrollingType.CLASSIC) : base(label, color)
        {
            Items = new List<UIMenuItem>();
            Type = "settings";
            Pagination = new PaginationHandler
            {
                ItemsPerPage = 12,
                scrollType = scrollType
            };
        }
        public async void AddSettings(UIMenuItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            Pagination.TotalItems = Items.Count;
            if (Parent != null && Parent.Visible)
            {
                if (Pagination.TotalItems < Pagination.ItemsPerPage)
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
            int scaleformIndex = Pagination.GetScaleformIndex(menuIndex);

            UIMenuItem item = Items[menuIndex];

            if (Parent is MainView lobby)
            {
                AddTextEntry($"menu_lobby_desc_{menuIndex}", item.Description);
                BeginScaleformMovieMethod(lobby._pause._lobby.Handle, "ADD_LEFT_ITEM");
                PushScaleformMovieFunctionParameterBool(before);
                PushScaleformMovieFunctionParameterInt(menuIndex);
                PushScaleformMovieFunctionParameterInt(item._itemId);
                PushScaleformMovieMethodParameterString(item._formatLeftLabel);
                if (item.DescriptionHash != 0 && string.IsNullOrWhiteSpace(item.Description))
                {
                    BeginTextCommandScaleformString("STRTNM1");
                    AddTextComponentSubstringTextLabelHashKey(item.DescriptionHash);
                    EndTextCommandScaleformString_2();
                }
                else
                {
                    BeginTextCommandScaleformString($"menu_lobby_desc_{menuIndex}");
                    EndTextCommandScaleformString_2();
                }
                PushScaleformMovieFunctionParameterBool(item.Enabled);
                PushScaleformMovieFunctionParameterBool(item.BlinkDescription);
                switch (item)
                {
                    case UIMenuListItem:
                        UIMenuListItem it = (UIMenuListItem)item;
                        AddTextEntry($"listitem_lobby_{menuIndex}_list", string.Join(",", it.Items));
                        BeginTextCommandScaleformString($"listitem_lobby_{menuIndex}_list");
                        EndTextCommandScaleformString();
                        PushScaleformMovieFunctionParameterInt(it.Index);
                        PushScaleformMovieFunctionParameterInt((int)it.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)it.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)it.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)it.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuCheckboxItem:
                        UIMenuCheckboxItem check = (UIMenuCheckboxItem)item;
                        PushScaleformMovieFunctionParameterInt((int)check.Style);
                        PushScaleformMovieMethodParameterBool(check.Checked);
                        PushScaleformMovieFunctionParameterInt((int)check.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)check.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)check.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)check.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuSliderItem:
                        UIMenuSliderItem prItem = (UIMenuSliderItem)item;
                        PushScaleformMovieFunctionParameterInt(prItem._max);
                        PushScaleformMovieFunctionParameterInt(prItem._multiplier);
                        PushScaleformMovieFunctionParameterInt(prItem.Value);
                        PushScaleformMovieFunctionParameterInt((int)prItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.HighlightedTextColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.SliderColor);
                        PushScaleformMovieFunctionParameterBool(prItem._heritage);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuProgressItem:
                        UIMenuProgressItem slItem = (UIMenuProgressItem)item;
                        PushScaleformMovieFunctionParameterInt(slItem._max);
                        PushScaleformMovieFunctionParameterInt(slItem._multiplier);
                        PushScaleformMovieFunctionParameterInt(slItem.Value);
                        PushScaleformMovieFunctionParameterInt((int)slItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.HighlightedTextColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.SliderColor);
                        EndScaleformMovieMethod();
                        break;
                    default:
                        PushScaleformMovieFunctionParameterInt((int)item.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)item.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", scaleformIndex, item._formatRightLabel);
                        if (item.RightBadge != BadgeIcon.NONE)
                        {
                            lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", scaleformIndex, (int)item.RightBadge);
                        }
                        break;
                }
                lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", scaleformIndex, item.labelFont.FontName, item.labelFont.FontID);
                lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_RIGHT_LABEL_FONT", scaleformIndex, item.rightLabelFont.FontName, item.rightLabelFont.FontID);
                if (item.LeftBadge != BadgeIcon.NONE)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", scaleformIndex, (int)item.LeftBadge);
            }
            else if (Parent is TabView pause)
            {
                AddTextEntry($"menu_pause_playerTab[{ParentTab}]_desc_{menuIndex}", item.Description);
                BeginScaleformMovieMethod(pause._pause._pause.Handle, "ADD_PLAYERS_TAB_SETTINGS_ITEM");
                PushScaleformMovieFunctionParameterInt(ParentTab);
                PushScaleformMovieFunctionParameterBool(before);
                PushScaleformMovieFunctionParameterInt(menuIndex);
                PushScaleformMovieFunctionParameterInt(item._itemId);
                PushScaleformMovieMethodParameterString(item._formatLeftLabel);
                if (item.DescriptionHash != 0 && string.IsNullOrWhiteSpace(item.Description))
                {
                    BeginTextCommandScaleformString("STRTNM1");
                    AddTextComponentSubstringTextLabelHashKey(item.DescriptionHash);
                    EndTextCommandScaleformString_2();
                }
                else
                {
                    BeginTextCommandScaleformString($"menu_pause_playerTab[{ParentTab}]_desc_{menuIndex}");
                    EndTextCommandScaleformString_2();
                }
                PushScaleformMovieFunctionParameterBool(item.Enabled);
                PushScaleformMovieFunctionParameterBool(item.BlinkDescription);
                switch (item)
                {
                    case UIMenuListItem:
                        UIMenuListItem it = (UIMenuListItem)item;
                        AddTextEntry($"listitem_menu_pause_playerTab[{ParentTab}]_{menuIndex}_list", string.Join(",", it.Items));
                        BeginTextCommandScaleformString($"listitem_menu_pause_playerTab[{ParentTab}]_{menuIndex}_list");
                        EndTextCommandScaleformString();
                        PushScaleformMovieFunctionParameterInt(it.Index);
                        PushScaleformMovieFunctionParameterInt((int)it.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)it.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)it.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)it.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuCheckboxItem:
                        UIMenuCheckboxItem check = (UIMenuCheckboxItem)item;
                        PushScaleformMovieFunctionParameterInt((int)check.Style);
                        PushScaleformMovieMethodParameterBool(check.Checked);
                        PushScaleformMovieFunctionParameterInt((int)check.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)check.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)check.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)check.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuSliderItem:
                        UIMenuSliderItem prItem = (UIMenuSliderItem)item;
                        PushScaleformMovieFunctionParameterInt(prItem._max);
                        PushScaleformMovieFunctionParameterInt(prItem._multiplier);
                        PushScaleformMovieFunctionParameterInt(prItem.Value);
                        PushScaleformMovieFunctionParameterInt((int)prItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.HighlightedTextColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.SliderColor);
                        PushScaleformMovieFunctionParameterBool(prItem._heritage);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuProgressItem:
                        UIMenuProgressItem slItem = (UIMenuProgressItem)item;
                        PushScaleformMovieFunctionParameterInt(slItem._max);
                        PushScaleformMovieFunctionParameterInt(slItem._multiplier);
                        PushScaleformMovieFunctionParameterInt(slItem.Value);
                        PushScaleformMovieFunctionParameterInt((int)slItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.HighlightedTextColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.SliderColor);
                        EndScaleformMovieMethod();
                        break;
                    default:
                        PushScaleformMovieFunctionParameterInt((int)item.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)item.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", ParentTab, scaleformIndex, item._formatRightLabel);
                        if (item.RightBadge != BadgeIcon.NONE)
                        {
                            pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", ParentTab, scaleformIndex, (int)item.RightBadge);
                        }
                        break;
                }
                pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", ParentTab, scaleformIndex, item.labelFont.FontName, item.labelFont.FontID);
                pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", ParentTab, scaleformIndex, item.rightLabelFont.FontName, item.rightLabelFont.FontID);
                if (item.LeftBadge != BadgeIcon.NONE)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", ParentTab, scaleformIndex, (int)item.LeftBadge);

            }
        }

        internal async void GoUp()
        {
            try
            {
                Items[CurrentSelection].Selected = false;
                bool overflow = CurrentSelection == 0 && Pagination.TotalPages > 1;
                if (Pagination.GoUp())
                {
                    if (Pagination.scrollType == ScrollingType.ENDLESS || (Pagination.scrollType == ScrollingType.CLASSIC && !overflow))
                    {
                        _itemCreation(Pagination.GetPage(CurrentSelection), Pagination.CurrentPageIndex, true);
                        if (Parent is MainView lobby)
                            await lobby._pause._lobby.CallFunctionReturnValueInt("SET_INPUT_EVENT", 8, 100);
                        else if (Parent is TabView pause)
                            await pause._pause._pause.CallFunctionReturnValueInt("SET_INPUT_EVENT", 8, 100);
                    }
                    else if (Pagination.scrollType == ScrollingType.PAGINATED || (Pagination.scrollType == ScrollingType.CLASSIC && overflow))
                    {
                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("CLEAR_SETTINGS_COLUMN");
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN", ParentTab);
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
                    _lobby._pause._lobby.CallFunction("SET_SETTINGS_SELECTION", Pagination.ScaleformIndex);
                    _lobby._pause._lobby.CallFunction("SET_SETTINGS_QTTY", CurrentSelection + 1, Items.Count);
                }
                else if (Parent is TabView _pause)
                {
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", ParentTab, Pagination.ScaleformIndex);
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
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
                bool overflow = CurrentSelection == Items.Count - 1 && Pagination.TotalPages > 1;
                if (Pagination.GoDown())
                {
                    if (Pagination.scrollType == ScrollingType.ENDLESS || (Pagination.scrollType == ScrollingType.CLASSIC && !overflow))
                    {
                        _itemCreation(Pagination.GetPage(CurrentSelection), Pagination.CurrentPageIndex, false);

                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("SET_INPUT_EVENT", 9, 100);
                        else if (Parent is TabView pause)
                            await pause._pause._pause.CallFunctionReturnValueInt("SET_INPUT_EVENT", 9, 100);
                    }
                    else if (Pagination.scrollType == ScrollingType.PAGINATED || (Pagination.scrollType == ScrollingType.CLASSIC && overflow))
                    {
                        if (Parent is MainView lobby)
                            lobby._pause._lobby.CallFunction("CLEAR_SETTINGS_COLUMN");
                        else if (Parent is TabView pause)
                            pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN", ParentTab);
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
                    _lobby._pause._lobby.CallFunction("SET_SETTINGS_SELECTION", Pagination.ScaleformIndex);
                    _lobby._pause._lobby.CallFunction("SET_SETTINGS_QTTY", CurrentSelection + 1, Items.Count);
                }
                else if (Parent is TabView _pause)
                {
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", ParentTab, Pagination.ScaleformIndex);
                    _pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
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
                        lobby._pause._lobby.CallFunction("SET_SETTINGS_SELECTION", Pagination.GetScaleformIndex(Pagination.CurrentMenuIndex));
                        lobby._pause._lobby.CallFunction("SET_SETTINGS_QTTY", CurrentSelection + 1, Items.Count);
                    }
                    else if (Parent is TabView pause)
                    {
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", ParentTab, Pagination.GetScaleformIndex(Pagination.CurrentMenuIndex));
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", ParentTab, CurrentSelection + 1, Items.Count);
                    }
                }
                Items[CurrentSelection].Selected = true;
            }
        }

        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }

        public void UpdateItemLabels(int index, string leftLabel, string rightLabel)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABELS", Pagination.GetScaleformIndex(index), leftLabel, rightLabel);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", ParentTab, Pagination.GetScaleformIndex(index), leftLabel, rightLabel);
            }
        }

        public void UpdateItemBlinkDescription(int index, bool blink)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_BLINK_DESC", Pagination.GetScaleformIndex(index), blink);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_BLINK_DESC", ParentTab, Pagination.GetScaleformIndex(index), blink);
            }
        }

        public void UpdateItemLabel(int index, string label)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABEL", Pagination.GetScaleformIndex(index), label);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL", ParentTab, Pagination.GetScaleformIndex(index), label);
            }
        }

        public void UpdateItemRightLabel(int index, string label)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", Pagination.GetScaleformIndex(index), label);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", ParentTab, Pagination.GetScaleformIndex(index), label);
            }
        }

        public void UpdateItemLeftBadge(int index, BadgeIcon badge)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", Pagination.GetScaleformIndex(index), (int)badge);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", ParentTab, Pagination.GetScaleformIndex(index), (int)badge);
            }
        }

        public void UpdateItemRightBadge(int index, BadgeIcon badge)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", Pagination.GetScaleformIndex(index), (int)badge);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", ParentTab, Pagination.GetScaleformIndex(index), (int)badge);
            }
        }

        public void EnableItem(int index, bool enable)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("ENABLE_SETTINGS_ITEM", Pagination.GetScaleformIndex(index), enable);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("ENABLE_PLAYERS_TAB_SETTINGS_ITEM", ParentTab, Pagination.GetScaleformIndex(index), enable);
            }
        }

        public void Clear()
        {
            Pagination.CurrentMenuIndex = 0;
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_SETTINGS_COLUMN");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN", ParentTab);
            Items.Clear();
            Pagination.TotalItems = Items.Count;
            cleared = true;
        }
    }
}
