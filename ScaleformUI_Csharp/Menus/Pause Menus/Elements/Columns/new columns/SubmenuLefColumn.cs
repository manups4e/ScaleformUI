using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenus.Elements
{
    public class SubmenuLefColumn : PM_Column
    {
        internal LeftItemType currentItemType => ((TabLeftItem)Items[Index]).ItemType;
        public int CurrentSelection { get => Index; set => Index = value; }
        public TabLeftItem CurrentItem => (TabLeftItem)Items[CurrentSelection];

        public SubmenuLefColumn(PM_COLUMNS position) : base(position)
        {
            VisibleItems = 10;
        }

        public void AddItem(TabLeftItem item)
        {
            Items.Add(item);
            if (Parent != null && Parent.Visible && Parent.Parent != null && Parent.Parent.Visible)
            {

            }
        }

        public override void SetDataSlot(int index)
        {
            if (index >= Items.Count)
                return;
            TabLeftItem item = (TabLeftItem)Items[index];
            BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DATA_SLOT");
            PushScaleformMovieFunctionParameterInt((int)position);
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

        public override void UpdateSlot(int index)
        {
            if (index >= Items.Count)
                return;
            TabLeftItem item = (TabLeftItem)Items[index];
            BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "UPDATE_SLOT");
            PushScaleformMovieFunctionParameterInt((int)position);
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

        public override void GoUp()
        {
            ((TabLeftItem)Items[Index]).Selected = false;
            Index--;
            ((TabLeftItem)Items[Index]).Selected = true;
            Parent.CenterColumn.Items.Clear();
            if (currentItemType != LeftItemType.Empty)
                Parent.CenterColumn.Items.AddRange(((TabLeftItem)Items[Index]).ItemList);
            if (Parent != null && Parent.Visible && Parent.Parent != null && Parent.Parent.Visible)
            {
                Parent.Parent._pause._pause.CallFunction("MENU_STATE", (int)currentItemType);
            }
        }

        public override void GoDown()
        {
            ((TabLeftItem)Items[Index]).Selected = false;
            Index++;
            ((TabLeftItem)Items[Index]).Selected = true;
            Parent.CenterColumn.Items.Clear();
            if (currentItemType != LeftItemType.Empty)
                Parent.CenterColumn.Items.AddRange(((TabLeftItem)Items[Index]).ItemList);
            if (Parent != null && Parent.Visible && Parent.Parent != null && Parent.Parent.Visible)
            {
                Parent.Parent._pause._pause.CallFunction("MENU_STATE", (int)currentItemType);
            }
        }
    }
}
