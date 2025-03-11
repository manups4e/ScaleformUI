using ScaleformUI.Elements;
using ScaleformUI.Menus;
using System.Linq;
using System.Reflection.Emit;
using static CitizenFX.Core.UI.Screen;

namespace ScaleformUI.PauseMenu
{
    public class SubmenuTab : BaseTab
    {
        private bool _focused;
        public SubmenuTab(string name, SColor color) : base(name, color)
        {
            _type = 1;
            _identifier = "Page_Info";
            LeftColumn = new PM_Column(0);
            CenterColumn =  new PM_Column(1);
        }

        public override bool Focused
        {
            get { return _focused; }
            set
            {
                _focused = value;
                //if (!value) Items[Index].Focused = false;
            }
        }

        public void AddLeftItem(TabLeftItem item)
        {
            item.Parent = this;
            LeftColumn.AddItem(item);
        }

        public override void HighlightColumn(PM_COLUMNS col, int index)
        {
            Parent._pause._pause.CallFunction("SET_COLUMN_FOCUS", (int)col, true, false, true);
        }

        public override void GoUp()
        {
            if (Parent.FocusLevel == 0) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 8);
            switch (CurrentColumnIndex)
            {
                case 0:
                    ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).Selected = false;
                    LeftColumn.Index--;
                    ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).Selected = true;
                    Parent._pause._pause.CallFunction("MENU_STATE", (int)((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType);
                    Refresh(false);
                    break;
                case 1:
                    if (((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType == LeftItemType.Settings)
                    {
                        var item = (SettingsItem)CenterColumn.Items[CenterColumn.Index];
                        item.Selected = false;
                        CenterColumn.Index--;
                        item.Selected = true;
                    }
                    break;
            }
        }

        public override void GoDown()
        {
            if (Parent.FocusLevel == 0) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 9);
            switch (CurrentColumnIndex)
            {
                case 0:
                    ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).Selected = false;
                    LeftColumn.Index++;
                    ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).Selected = true;
                    Parent._pause._pause.CallFunction("MENU_STATE", (int)((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType);
                    Refresh(false);
                    break;
                case 1:
                    if (((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType == LeftItemType.Settings)
                    {
                        var item = (SettingsItem)CenterColumn.Items[CenterColumn.Index];
                        item.Selected = false;
                        CenterColumn.Index++;
                        item.Selected = true;
                    }
                    break;
            }
        }

        public override void GoLeft()
        {
            if(Parent.FocusLevel == 0) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 10);
            if (CurrentColumnIndex == 1 && ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType == LeftItemType.Settings)
            {
                var item = (SettingsItem)CenterColumn.Items[CenterColumn.Index];
                switch (item.ItemType)
                {
                    case SettingsItemType.ListItem:
                        (item as SettingsListItem).itemIndex--;
                        (item as SettingsListItem).ListChanged();
                        break;
                    case SettingsItemType.SliderBar: //TODO: UPDATE WITH MULTIPLIER
                        (item as SettingsSliderItem)._value--;
                        (item as SettingsSliderItem).SliderChanged();
                        break;
                    case SettingsItemType.ProgressBar:
                    case SettingsItemType.MaskedProgressBar: //TODO: UPDATE WITH MULTIPLIER
                        (item as SettingsProgressItem)._value--;
                        (item as SettingsProgressItem).ProgressChanged();
                        break;
                }
            }
        }
        public override void GoRight()
        {
            if (Parent.FocusLevel == 0) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 11);
            if (CurrentColumnIndex == 1 && ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType == LeftItemType.Settings)
            {
                var item = (SettingsItem)CenterColumn.Items[CenterColumn.Index];
                switch (item.ItemType)
                {
                    case SettingsItemType.ListItem:
                        (item as SettingsListItem).ItemIndex++;
                        (item as SettingsListItem).ListChanged();
                        break;
                    case SettingsItemType.SliderBar: //TODO: UPDATE WITH MULTIPLIER
                        (item as SettingsSliderItem).Value++;
                        (item as SettingsSliderItem).SliderChanged();
                        break;
                    case SettingsItemType.ProgressBar:
                    case SettingsItemType.MaskedProgressBar: //TODO: UPDATE WITH MULTIPLIER
                        (item as SettingsProgressItem).Value++;
                        (item as SettingsProgressItem).ProgressChanged();
                        break;
                }
            }
        }

        public override async void Select()
        {
            switch (CurrentColumnIndex)
            {
                case 0 when ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType == LeftItemType.Settings:
                    TabLeftItem leftItem = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
                    if (!leftItem.Enabled)
                    {
                        Game.PlaySound(Parent.AUDIO_ERROR, Parent.AUDIO_LIBRARY);
                        return;
                    }
                    CurrentColumnIndex++;
                    if (leftItem.ItemList.All(x => !(x as SettingsItem).Enabled)) break;
                    while (!(CenterColumn.Items[CenterColumn.Index] as SettingsItem).Enabled)
                    {
                        await BaseScript.Delay(0);
                        CenterColumn.Index++;
                    }
                    Parent.FocusLevel++;
                    Parent.SendPauseMenuLeftItemSelect();
                    break;
                case 1:
                    if (CenterColumn.Items[CenterColumn.Index] is SettingsItem item)
                    {
                        if (!item.Enabled)
                        {
                            Game.PlaySound(Parent.AUDIO_ERROR, Parent.AUDIO_LIBRARY);
                            return;
                        }
                        switch (item.ItemType)
                        {
                            case SettingsItemType.ListItem:
                                (item as SettingsListItem).ListSelected();
                                break;
                            case SettingsItemType.CheckBox:
                                (item as SettingsCheckboxItem).IsChecked = !(item as SettingsCheckboxItem).IsChecked;
                                break;
                            case SettingsItemType.MaskedProgressBar:
                            case SettingsItemType.ProgressBar:
                                (item as SettingsProgressItem).ProgressSelected();
                                break;
                            case SettingsItemType.SliderBar:
                                (item as SettingsSliderItem).SliderSelected();
                                break;
                        }
                        // we always trigger this because all items inherit this
                        item.Activated();
                    }
                    break;
            }
        }

        public override void GoBack()
        {
            if (CurrentColumnIndex == 1)
            {
                CurrentColumnIndex--;
                Parent.FocusLevel--;
            }
        }

        public override void Focus()
        {
            Parent._pause._pause.CallFunction("SET_COLUMN_HIGHLIGHT", 0, LeftColumn.Index, false, false);
        }

        public override void Refresh(bool highlightOldIndex)
        {
            Parent._pause._pause.CallFunction("ALLOW_CLICK_FROM_COLUMN", 0, true);
            Parent._pause._pause.CallFunction("SET_DATA_SLOT_EMPTY", 1);
            for (int i = 0; i < CenterColumn.Items.Count; i++)
            {
                SetDataSlot(CenterColumn.position, i);
            }
            switch (((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType)
            {
                case LeftItemType.Keymap:
                    Parent._pause._pause.CallFunction("SET_COLUMN_TITLE", 1, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).RightTitle, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).KeymapRightLabel_1, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).KeymapRightLabel_2);
                    Parent._pause._pause.CallFunction("SET_COLUMN_FOCUS", 1, false, false, false);
                    break;
                case LeftItemType.Settings:
                    if (highlightOldIndex)
                        Parent._pause._pause.CallFunction("SET_COLUMN_HIGHLIGHT", 1, CenterColumn.Index, true, true);
                        //Parent._pause._pause.CallFunction("SET_COLUMN_STATE", 3);
                        ////Parent._pause._pause.CallFunction("SET_CONTROL_IMAGE", "pause_menu_pages_settings_pc", "controller");
                        ////Parent._pause._pause.CallFunction("SET_CONTROL_LABELS", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "SUPER TITLE");

                        ////Parent._pause._pause.CallFunction("SET_VIDEO_MEMORY_BAR", true, "ScaleformUI Pause Menu Awesomeness", 70, 116);
                        //Parent._pause._pause.CallFunction("SET_DESCRIPTION", 1, "~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "scaleformui", "pauseinfobg", 0, 0, 578, 160);
                        break;
            }
            ShowColumn(PM_COLUMNS.MIDDLE);
        }

        public override void Populate()
        {
            TabLeftItem item = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
            item.Selected = true;
            Parent._pause._pause.CallFunction("SET_MENU_LEVEL", 1);
            Parent._pause._pause.CallFunction("MENU_STATE", (int)((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType);
            Parent._pause._pause.CallFunction("SET_MENU_LEVEL", 0);
            for (int i = 0; i < LeftColumn.Items.Count; i++)
            {
                SetDataSlot(LeftColumn.position, i);
            }
            for (int i = 0; i < CenterColumn.Items.Count; i++)
            {
                SetDataSlot(CenterColumn.position, i);
            }
        }

        public override void ShowColumns()
        {
            //Parent._pause._pause.CallFunction("MOUSE_COLUMN_SHIFT", 0);
            //Parent._pause._pause.CallFunction("SET_COLUMN_HIGHLIGHT", 0, 0, false, false);
            ShowColumn(PM_COLUMNS.LEFT);
            ShowColumn(PM_COLUMNS.MIDDLE);
            if (((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemType == LeftItemType.Settings)
            {
                Parent._pause._pause.CallFunction("SET_COLUMN_STATE", 1, 1);
            }
            Parent._pause._pause.CallFunction("SET_COLUMN_FOCUS", 0, false, false, false);
            InitColumnScroll(LeftColumn.position, true, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT);
            SetColumnScroll(LeftColumn.position, LeftColumn.Index, LeftColumn.Items.Count, 16, "", LeftColumn.Items.Count < 16);
        }

        public override void SetDataSlot(PM_COLUMNS slot, int index)
        {
            if (slot == PM_COLUMNS.LEFT)
            {
                if (index >= LeftColumn.Items.Count)
                    return;
                TabLeftItem item = (TabLeftItem)LeftColumn.Items[index];
                BeginScaleformMovieMethod(Parent._pause._pause.Handle, "SET_DATA_SLOT");
                PushScaleformMovieFunctionParameterInt((int)slot);
                PushScaleformMovieFunctionParameterInt(index);
                PushScaleformMovieFunctionParameterInt(0);
                PushScaleformMovieFunctionParameterInt(0);
                PushScaleformMovieMethodParameterString(item._formatLeftLabel);
                PushScaleformMovieFunctionParameterBool(item.Enabled);
                PushScaleformMovieFunctionParameterBool(false);
                PushScaleformMovieFunctionParameterInt(item.MainColor.ArgbValue);
                PushScaleformMovieFunctionParameterInt(item.HighlightColor.ArgbValue);
                PushScaleformMovieMethodParameterString(item._internalItem._formatRightLabel);
                PushScaleformMovieFunctionParameterInt((int)item._internalItem.LeftBadge);
                PushScaleformMovieMethodParameterString(item._internalItem.customLeftBadge.Key);
                PushScaleformMovieMethodParameterString(item._internalItem.customLeftBadge.Value);
                PushScaleformMovieFunctionParameterInt((int)item._internalItem.RightBadge);
                PushScaleformMovieMethodParameterString(item._internalItem.customRightBadge.Key);
                PushScaleformMovieMethodParameterString(item._internalItem.customRightBadge.Value);
                PushScaleformMovieMethodParameterString(item._internalItem.labelFont.FontName);
                PushScaleformMovieMethodParameterString(item._internalItem.rightLabelFont.FontName);
                EndScaleformMovieMethod();
            }
            else if (slot == PM_COLUMNS.MIDDLE)
            {
                TabLeftItem curItem = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
                switch (curItem.ItemType)
                {
                    case LeftItemType.Info:
                        {
                            var _item = CenterColumn.Items[index];
                            var labels = _item.Label.SplitLabel;
                            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "SET_DATA_SLOT");
                            PushScaleformMovieFunctionParameterInt((int)slot);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterBool(true);
                            BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                            for (var i = 0; i < labels?.Length; i++)
                                AddTextComponentScaleform(labels[i]);
                            EndTextCommandScaleformString_2();
                            EndScaleformMovieMethod();
                        }
                        break;
                    case LeftItemType.Statistics:
                        {
                            StatsTabItem it = (StatsTabItem)CenterColumn.Items[index];
                            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "SET_DATA_SLOT");
                            PushScaleformMovieFunctionParameterInt((int)slot);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt((int)it.Type);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterBool(true);
                            PushScaleformMovieFunctionParameterString(it.Label.Label);
                            switch (it.Type)
                            {
                                case StatItemType.Basic:
                                    PushScaleformMovieFunctionParameterString(it.RightLabel);
                                    break;
                                case StatItemType.ColoredBar:
                                    PushScaleformMovieMethodParameterInt(it.Value);
                                    PushScaleformMovieMethodParameterInt(it.ColoredBarColor.ArgbValue);
                                    break;
                            }
                            EndScaleformMovieMethod();
                        }
                        break;
                    case LeftItemType.Settings:
                        {
                            SettingsItem it = (SettingsItem)CenterColumn.Items[index];
                            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "SET_DATA_SLOT");
                            PushScaleformMovieFunctionParameterInt((int)slot);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt((int)it.ItemType);
                            switch (it.ItemType)
                            {
                                case SettingsItemType.ListItem:
                                    PushScaleformMovieFunctionParameterInt(((SettingsListItem)it).ItemIndex);
                                    break;
                                case SettingsItemType.SliderBar:
                                    PushScaleformMovieFunctionParameterInt(((SettingsSliderItem)it).Value);
                                    break;
                                case SettingsItemType.MaskedProgressBar:
                                case SettingsItemType.ProgressBar:
                                    PushScaleformMovieFunctionParameterInt(((SettingsProgressItem)it).Value);
                                    break;
                                default:
                                    PushScaleformMovieFunctionParameterInt(0);
                                    break;
                            }
                            PushScaleformMovieFunctionParameterBool(true);
                            if (it.ItemType == SettingsItemType.BlipType)
                            {
                                BeginTextCommandScaleformString("STRING");
                                AddTextComponentScaleform(it.Label.Label);
                                EndTextCommandScaleformString_2();
                            }
                            else
                            {
                                PushScaleformMovieFunctionParameterString(it.Label.Label);
                            }
                            switch (it.ItemType)
                            {
                                case SettingsItemType.Basic:
                                    PushScaleformMovieFunctionParameterString(it.RightLabel);
                                    break;
                                case SettingsItemType.ListItem:
                                    PushScaleformMovieFunctionParameterString(string.Join(",", ((SettingsListItem)it).ListItems));
                                    break;
                                case SettingsItemType.CheckBox:
                                    PushScaleformMovieFunctionParameterInt((int)((SettingsCheckboxItem)it).CheckBoxStyle);
                                    PushScaleformMovieFunctionParameterBool(((SettingsCheckboxItem)it).IsChecked);
                                    break;
                                case SettingsItemType.MaskedProgressBar:
                                case SettingsItemType.ProgressBar:
                                    PushScaleformMovieMethodParameterInt(((SettingsProgressItem)it).MaxValue);
                                    PushScaleformMovieMethodParameterInt(((SettingsProgressItem)it).ColoredBarColor.ArgbValue);
                                    break;
                                case SettingsItemType.SliderBar:
                                    PushScaleformMovieMethodParameterInt(((SettingsSliderItem)it).MaxValue);
                                    PushScaleformMovieMethodParameterInt(((SettingsSliderItem)it).ColoredBarColor.ArgbValue);
                                    break;
                                case SettingsItemType.BlipType:
                                    PushScaleformMovieFunctionParameterString(it.RightLabel);
                                    break;
                            }
                            EndScaleformMovieMethod();
                        }
                        break;
                    case LeftItemType.Keymap:
                        {
                            var _item = (KeymapItem)CenterColumn.Items[index];
                            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "SET_DATA_SLOT");
                            PushScaleformMovieFunctionParameterInt((int)slot);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterBool(true);
                            BeginTextCommandScaleformString("STRING");
                            AddTextComponentScaleform(_item.Label.Label);
                            EndTextCommandScaleformString_2();
                            BeginTextCommandScaleformString("STRING");
                            AddTextComponentScaleform(Game.CurrentInputMode == InputMode.MouseAndKeyboard ? _item.PrimaryKeyboard : _item.PrimaryGamepad);
                            EndTextCommandScaleformString_2();
                            BeginTextCommandScaleformString("STRING");
                            AddTextComponentScaleform(Game.CurrentInputMode == InputMode.MouseAndKeyboard ? _item.SecondaryKeyboard : _item.SecondaryGamepad);
                            EndTextCommandScaleformString_2();
                            EndScaleformMovieMethod();
                        }
                        break;
                }
            }
        }

        public override void UpdateSlot(PM_COLUMNS slot, int index)
        {
            if (slot == PM_COLUMNS.LEFT)
            {
                if (index >= LeftColumn.Items.Count)
                    return;
                TabLeftItem item = (TabLeftItem)LeftColumn.Items[index];
                BeginScaleformMovieMethod(Parent._pause._pause.Handle, "UPDATE_SLOT");
                PushScaleformMovieFunctionParameterInt((int)slot);
                PushScaleformMovieFunctionParameterInt(index);
                PushScaleformMovieFunctionParameterInt(0);
                PushScaleformMovieFunctionParameterInt(0);
                PushScaleformMovieMethodParameterString(item._formatLeftLabel);
                PushScaleformMovieFunctionParameterBool(item.Enabled);
                PushScaleformMovieFunctionParameterBool(false);
                PushScaleformMovieFunctionParameterInt(item.MainColor.ArgbValue);
                PushScaleformMovieFunctionParameterInt(item.HighlightColor.ArgbValue);
                PushScaleformMovieMethodParameterString(item._internalItem._formatRightLabel);
                PushScaleformMovieFunctionParameterInt((int)item._internalItem.LeftBadge);
                PushScaleformMovieMethodParameterString(item._internalItem.customLeftBadge.Key);
                PushScaleformMovieMethodParameterString(item._internalItem.customLeftBadge.Value);
                PushScaleformMovieFunctionParameterInt((int)item._internalItem.RightBadge);
                PushScaleformMovieMethodParameterString(item._internalItem.customRightBadge.Key);
                PushScaleformMovieMethodParameterString(item._internalItem.customRightBadge.Value);
                PushScaleformMovieMethodParameterString(item._internalItem.labelFont.FontName);
                PushScaleformMovieMethodParameterString(item._internalItem.rightLabelFont.FontName);
                EndScaleformMovieMethod();
            }
            else if (slot == PM_COLUMNS.MIDDLE)
            {
                TabLeftItem curItem = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
                switch (curItem.ItemType)
                {
                    case LeftItemType.Info:
                        {
                            var _item = CenterColumn.Items[index];
                            var labels = _item.Label.SplitLabel;
                            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "UPDATE_SLOT");
                            PushScaleformMovieFunctionParameterInt((int)slot);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterBool(true);
                            BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                            for (var i = 0; i < labels?.Length; i++)
                                AddTextComponentScaleform(labels[i]);
                            EndTextCommandScaleformString_2();
                            EndScaleformMovieMethod();
                        }
                        break;
                    case LeftItemType.Statistics:
                        {
                            StatsTabItem it = (StatsTabItem)CenterColumn.Items[index];
                            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "UPDATE_SLOT");
                            PushScaleformMovieFunctionParameterInt((int)slot);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt((int)it.Type);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterBool(true);
                            PushScaleformMovieFunctionParameterString(it.Label.Label);
                            switch (it.Type)
                            {
                                case StatItemType.Basic:
                                    PushScaleformMovieFunctionParameterString(it.RightLabel);
                                    break;
                                case StatItemType.ColoredBar:
                                    PushScaleformMovieMethodParameterInt(it.Value);
                                    PushScaleformMovieMethodParameterInt(it.ColoredBarColor.ArgbValue);
                                    break;
                            }
                            EndScaleformMovieMethod();
                        }
                        break;
                    case LeftItemType.Settings:
                        {
                            SettingsItem it = (SettingsItem)CenterColumn.Items[index];
                            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "UPDATE_SLOT");
                            PushScaleformMovieFunctionParameterInt((int)slot);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt((int)it.ItemType);
                            switch (it.ItemType)
                            {
                                case SettingsItemType.ListItem:
                                    PushScaleformMovieFunctionParameterInt(((SettingsListItem)it).ItemIndex);
                                    break;
                                case SettingsItemType.SliderBar:
                                    PushScaleformMovieFunctionParameterInt(((SettingsSliderItem)it).Value);
                                    break;
                                case SettingsItemType.MaskedProgressBar:
                                case SettingsItemType.ProgressBar:
                                    PushScaleformMovieFunctionParameterInt(((SettingsProgressItem)it).Value);
                                    break;
                                default:
                                    PushScaleformMovieFunctionParameterInt(0);
                                    break;
                            }
                            PushScaleformMovieFunctionParameterBool(true);
                            if (it.ItemType == SettingsItemType.BlipType)
                            {
                                BeginTextCommandScaleformString("STRING");
                                AddTextComponentScaleform(it.Label.Label);
                                EndTextCommandScaleformString_2();
                            }
                            else
                            {
                                PushScaleformMovieFunctionParameterString(it.Label.Label);
                            }
                            switch (it.ItemType)
                            {
                                case SettingsItemType.Basic:
                                    PushScaleformMovieFunctionParameterString(it.RightLabel);
                                    break;
                                case SettingsItemType.ListItem:
                                    PushScaleformMovieFunctionParameterString(string.Join(",", ((SettingsListItem)it).ListItems));
                                    break;
                                case SettingsItemType.CheckBox:
                                    PushScaleformMovieFunctionParameterInt((int)((SettingsCheckboxItem)it).CheckBoxStyle);
                                    PushScaleformMovieFunctionParameterBool(((SettingsCheckboxItem)it).IsChecked);
                                    break;
                                case SettingsItemType.MaskedProgressBar:
                                case SettingsItemType.ProgressBar:
                                    PushScaleformMovieMethodParameterInt(((SettingsProgressItem)it).MaxValue);
                                    PushScaleformMovieMethodParameterInt(((SettingsProgressItem)it).ColoredBarColor.ArgbValue);
                                    break;
                                case SettingsItemType.SliderBar:
                                    PushScaleformMovieMethodParameterInt(((SettingsSliderItem)it).MaxValue);
                                    PushScaleformMovieMethodParameterInt(((SettingsSliderItem)it).ColoredBarColor.ArgbValue);
                                    break;
                                case SettingsItemType.BlipType:
                                    PushScaleformMovieFunctionParameterString(it.RightLabel);
                                    break;
                            }
                            EndScaleformMovieMethod();
                        }
                        break;
                    case LeftItemType.Keymap:
                        {
                            var _item = (KeymapItem)CenterColumn.Items[index];
                            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "UPDATE_SLOT");
                            PushScaleformMovieFunctionParameterInt((int)slot);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(index);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterInt(0);
                            PushScaleformMovieFunctionParameterBool(true);
                            BeginTextCommandScaleformString("STRING");
                            AddTextComponentScaleform(_item.Label.Label);
                            EndTextCommandScaleformString_2();
                            BeginTextCommandScaleformString("STRING");
                            AddTextComponentScaleform(Game.CurrentInputMode == InputMode.MouseAndKeyboard ? _item.PrimaryKeyboard : _item.PrimaryGamepad);
                            EndTextCommandScaleformString_2();
                            BeginTextCommandScaleformString("STRING");
                            AddTextComponentScaleform(Game.CurrentInputMode == InputMode.MouseAndKeyboard ? _item.SecondaryKeyboard : _item.SecondaryGamepad);
                            EndTextCommandScaleformString_2();
                            EndScaleformMovieMethod();
                        }
                        break;
                }
            }
        }
    }
}