using ScaleformUI.Menu;
using ScaleformUI.PauseMenu;
using ScaleformUI.Scaleforms;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.LobbyMenu
{
    public class SettingsListColumn : Column
    {
        private int currentSelection;

        public int ParentTab { get; internal set; }
        public event IndexChanged OnIndexChanged;
        public List<UIMenuItem> Items { get; internal set; }
        public SettingsListColumn(string label, HudColor color) : base(label, color)
        {
            Items = new List<UIMenuItem>();
        }
        public void AddSettings(UIMenuItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            if (Parent != null && Parent.Visible)
            {
                if (Parent is MainView lobby)
                {
                    int index = Items.IndexOf(item);
                    AddTextEntry($"menu_lobby_desc_{index}", item.Description);
                    BeginScaleformMovieMethod(lobby._pause._lobby.Handle, "ADD_LEFT_ITEM");
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
                        BeginTextCommandScaleformString($"menu_lobby_desc_{index}");
                        EndTextCommandScaleformString_2();
                    }
                    PushScaleformMovieFunctionParameterBool(item.Enabled);
                    PushScaleformMovieFunctionParameterBool(item.BlinkDescription);
                    switch (item)
                    {
                        case UIMenuListItem:
                            UIMenuListItem it = (UIMenuListItem)item;
                            AddTextEntry($"listitem_lobby_{index}_list", string.Join(",", it.Items));
                            BeginTextCommandScaleformString($"listitem_lobby_{index}_list");
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
                            lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", index, item._formatRightLabel);
                            if (item.RightBadge != BadgeIcon.NONE)
                            {
                                lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", index, (int)item.RightBadge);
                            }
                            break;
                    }
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", index, item.labelFont.FontName, item.labelFont.FontID);
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_RIGHT_LABEL_FONT", index, item.rightLabelFont.FontName, item.rightLabelFont.FontID);
                    if (item.LeftBadge != BadgeIcon.NONE)
                        lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", index, (int)item.LeftBadge);
                }
                else if (Parent is TabView pause)
                {
                    AddTextEntry($"menu_pause_playerTab[{ParentTab}]_desc_{Items.IndexOf(item)}", item.Description);
                    BeginScaleformMovieMethod(pause._pause._pause.Handle, "ADD_PLAYERS_TAB_SETTINGS_ITEM");
                    PushScaleformMovieFunctionParameterInt(ParentTab);
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
                        BeginTextCommandScaleformString($"menu_pause_playerTab[{ParentTab}]_desc_{Items.IndexOf(item)}");
                        EndTextCommandScaleformString_2();
                    }
                    PushScaleformMovieFunctionParameterBool(item.Enabled);
                    PushScaleformMovieFunctionParameterBool(item.BlinkDescription);
                    switch (item)
                    {
                        case UIMenuListItem:
                            UIMenuListItem it = (UIMenuListItem)item;
                            AddTextEntry($"listitem_lobby_{Items.IndexOf(item)}_list", string.Join(",", it.Items));
                            BeginTextCommandScaleformString($"listitem_lobby_{Items.IndexOf(item)}_list");
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
                            pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", ParentTab, Items.IndexOf(item), item._formatRightLabel);
                            if (item.RightBadge != BadgeIcon.NONE)
                            {
                                pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", ParentTab, Items.IndexOf(item), (int)item.RightBadge);
                            }
                            break;
                    }
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", ParentTab, Items.IndexOf(item), item.labelFont.FontName, item.labelFont.FontID);
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", ParentTab, Items.IndexOf(item), item.rightLabelFont.FontName, item.rightLabelFont.FontID);
                    if (item.LeftBadge != BadgeIcon.NONE)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", ParentTab, Items.IndexOf(item), (int)item.LeftBadge);
                }
            }
        }

        public int CurrentSelection
        {
            get { return Items.Count == 0 ? 0 : currentSelection % Items.Count; }
            set
            {
                if (Items.Count == 0) currentSelection = 0;
                Items[CurrentSelection].Selected = false;
                currentSelection = 1000000 - (1000000 % Items.Count) + value;
                if (Parent != null && Parent.Visible)
                {
                    if (Parent is MainView lobby)
                        lobby._pause._lobby.CallFunction("SET_SETTINGS_SELECTION", CurrentSelection);
                    else if (Parent is TabView pause)
                        pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", ParentTab, CurrentSelection);
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
                    lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABELS", index, leftLabel, rightLabel);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", ParentTab, index, leftLabel, rightLabel);
            }
        }

        public void UpdateItemBlinkDescription(int index, bool blink)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_BLINK_DESC", index, blink);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_BLINK_DESC", ParentTab, index, blink);
            }
        }

        public void UpdateItemLabel(int index, string label)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABEL", index, label);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL", ParentTab, index, label);
            }
        }

        public void UpdateItemRightLabel(int index, string label)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", index, label);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", ParentTab, index, label);
            }
        }

        public void UpdateItemLeftBadge(int index, BadgeIcon badge)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", index, (int)badge);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", ParentTab, index, (int)badge);
            }
        }

        public void UpdateItemRightBadge(int index, BadgeIcon badge)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", index, (int)badge);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", ParentTab, index, (int)badge);
            }
        }

        public void EnableItem(int index, bool enable)
        {
            if (Parent != null)
            {
                if (Parent is MainView lobby)
                    lobby._pause._lobby.CallFunction("ENABLE_SETTINGS_ITEM", index, enable);
                else if (Parent is TabView pause)
                    pause._pause._pause.CallFunction("ENABLE_PLAYERS_TAB_SETTINGS_ITEM", ParentTab, index, enable);
            }
        }

        public void Clear()
        {
            if (Parent is MainView lobby)
                lobby._pause._lobby.CallFunction("CLEAR_SETTINGS_COLUMN");
            else if (Parent is TabView pause)
                pause._pause._pause.CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN", ParentTab);
        }

    }
}
