using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenus.Elements
{
    public class SubmenuCentralColumn : PM_Column
    {
        internal LeftItemType currentColumnType = LeftItemType.Empty;

        public SubmenuCentralColumn(int position) : base(position)
        {
        }

        public override void SetDataSlot(int index)
        {
            TabLeftItem curItem = (TabLeftItem)Parent.LeftColumn.Items[Parent.LeftColumn.Index];
            switch (curItem.ItemType)
            {
                case LeftItemType.Info:
                    {
                        var _item = Items[index];
                        var labels = _item.Label.SplitLabel;
                        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DATA_SLOT");
                        PushScaleformMovieFunctionParameterInt((int)position);
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
                        StatsTabItem it = (StatsTabItem)Items[index];
                        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DATA_SLOT");
                        PushScaleformMovieFunctionParameterInt((int)position);
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
                        SettingsItem it = (SettingsItem)Items[index];
                        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DATA_SLOT");
                        PushScaleformMovieFunctionParameterInt((int)position);
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
                        SetColumnScroll(Index + 1, Items.Count, VisibleItems, string.Empty, Items.Count < VisibleItems);
                    }
                    break;
                case LeftItemType.Keymap:
                    {
                        var _item = (KeymapItem)Items[index];
                        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DATA_SLOT");
                        PushScaleformMovieFunctionParameterInt((int)position);
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

        public override void UpdateSlot(int index)
        {
            switch (currentColumnType)
            {
                case LeftItemType.Info:
                    {
                        var _item = Items[index];
                        var labels = _item.Label.SplitLabel;
                        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "UPDATE_SLOT");
                        PushScaleformMovieFunctionParameterInt((int)position);
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
                        StatsTabItem it = (StatsTabItem)Items[index];
                        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "UPDATE_SLOT");
                        PushScaleformMovieFunctionParameterInt((int)position);
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
                        SettingsItem it = (SettingsItem)Items[index];
                        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "UPDATE_SLOT");
                        PushScaleformMovieFunctionParameterInt((int)position);
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
                        SetColumnScroll(Index + 1, Items.Count, VisibleItems, string.Empty, Items.Count < VisibleItems);
                    }
                    break;
                case LeftItemType.Keymap:
                    {
                        var _item = (KeymapItem)Items[index];
                        BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "UPDATE_SLOT");
                        PushScaleformMovieFunctionParameterInt((int)position);
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

        public virtual void AddSlot(int index) { }

        public override async void GoUp()
        {
            if (currentColumnType == LeftItemType.Settings)
            {
                ((SettingsItem)Items[Index]).Selected = false;
                do
                {
                    index--;
                    if(index < 0)
                        index = Items.Count - 1;
                    await BaseScript.Delay(0);
                } while (((SettingsItem)Items[Index]).ItemType == SettingsItemType.Empty || ((SettingsItem)Items[Index]).ItemType == SettingsItemType.Separator);
                ((SettingsItem)Items[Index]).Selected = true;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, true, true);
                SetColumnScroll(Index + 1, Items.Count, VisibleItems, string.Empty, Items.Count < VisibleItems);
            }
        }

        public override async void GoDown()
        {
            if (currentColumnType == LeftItemType.Settings)
            {
                ((SettingsItem)Items[Index]).Selected = false;
                do
                {
                    index++;
                    if (index >= Items.Count)
                        index = 0;
                    await BaseScript.Delay(0);
                } while (((SettingsItem)Items[Index]).ItemType == SettingsItemType.Empty || ((SettingsItem)Items[Index]).ItemType == SettingsItemType.Separator);
                ((SettingsItem)Items[Index]).Selected = true;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, true, true);
                SetColumnScroll(Index + 1, Items.Count, VisibleItems, string.Empty, Items.Count < VisibleItems);
            }
        }

        public virtual void GoLeft()
        {
            if (currentColumnType == LeftItemType.Settings)
            {
                var item = (SettingsItem)Items[Index];
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

        public virtual void GoRight() 
        {
            if(currentColumnType == LeftItemType.Settings)
            {
                var item = (SettingsItem)Items[Index];
                switch (item.ItemType)
                {
                    case SettingsItemType.ListItem:
                        (item as SettingsListItem).itemIndex++;
                        (item as SettingsListItem).ListChanged();
                        break;
                    case SettingsItemType.SliderBar: //TODO: UPDATE WITH MULTIPLIER
                        (item as SettingsSliderItem)._value++;
                        (item as SettingsSliderItem).SliderChanged();
                        break;
                    case SettingsItemType.ProgressBar:
                    case SettingsItemType.MaskedProgressBar: //TODO: UPDATE WITH MULTIPLIER
                        (item as SettingsProgressItem)._value++;
                        (item as SettingsProgressItem).ProgressChanged();
                        break;
                }
            }
        }

        public virtual void Select() {
            if (Items[Index] is SettingsItem item)
            {
                if (!item.Enabled)
                {
                    Game.PlaySound(TabView.AUDIO_ERROR, TabView.AUDIO_LIBRARY);
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
                // we always trigger this because all items inherit this except checkbox
                if (item.ItemType != SettingsItemType.CheckBox)
                    item.Activated();
            }

        }

        public override void MouseScroll(int dir)
        {
            //Parent._pause._pause.CallFunction("DELTA_MOUSE_WHEEL", dir);
        }
    }
}
