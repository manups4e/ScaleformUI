using ScaleformUI.Elements;
using ScaleformUI.Menus.Pause_Menus.Elements.Columns;
using ScaleformUI.PauseMenus.Elements.Items;
using ScaleformUI.PauseMenus.Elements.Panels;
using System.Reflection;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.PauseMenu
{
    public enum GalleryState
    {
        EMPTY = 0,
        CORRUPTED = 1,
        QUEUED = 2,
        LOADING = 3,
        LOADED = 4,
        TRANSITION = 5
    }

    public delegate void GalleryModeChanged(GalleryTab tab, GalleryItem item, bool bigPicture);
    public delegate void GalleryIndexChanged(GalleryTab tab, GalleryItem item, int totalIndex, int gridIndex);
    public delegate void GalleryItemSelected(GalleryTab tab, GalleryItem item, int totalIndex, int gridIndex);

    public class GalleryTab : BaseTab
    {
        public event GalleryModeChanged OnGalleryModeChanged;
        public event GalleryIndexChanged OnGalleryIndexChanged;
        public event GalleryItemSelected OnGalleryItemSelected;
        private GalleryColumn column;
        internal bool bigPic = false;

        public GalleryTab(string name, SColor color) : base(name, color)
        {
            _type = 3;
            _identifier = "Page_Gallery";
            column = new GalleryColumn();
            column.Parent = this;
            LeftColumn = column;
            Minimap = new MinimapPanel(this) { HidePedBlip = false };
        }

        public override void Populate()
        {
            column.Index = 0;
            column.currentPageIndex = 0;
            column.Populate();
        }

        public override void GoUp()
        {
            if (!Focused) return;
            LeftColumn.GoUp();
            column.UpdatePage();
            GalleryItem it = column.Items[column.currentPageIndex] as GalleryItem;
            if (bigPic)
            {
                SetTitle(it.TextureDictionary, it.TextureName, GalleryState.LOADED);
            }

            if (it.Blip != null)
            {
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)column.position, "", false);
                Minimap.Enabled = true;
                Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
            }
            else if (!string.IsNullOrEmpty(it.RightPanelDescription.Label))
            {
                Minimap.Enabled = false;
                var labels = it.RightPanelDescription.SplitLabel;
                BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_STATE");
                ScaleformMovieMethodAddParamInt((int)column.position);
                BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                for (var i = 0; i < labels?.Length; i++)
                    AddTextComponentScaleform(labels[i]);
                EndTextCommandScaleformString_2();
                ScaleformMovieMethodAddParamBool(true);
                EndScaleformMovieMethod();
            }
            else
            {
                Minimap.Enabled = false;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)column.position, "", true);
            }
        }

        public override void GoDown()
        {
            if (!Focused) return;
            LeftColumn.GoDown();
            column.UpdatePage();
            GalleryItem it = column.Items[column.currentPageIndex] as GalleryItem;
            if (bigPic)
            {
                SetTitle(it.TextureDictionary, it.TextureName, GalleryState.LOADED);
            }

            if (it.Blip != null)
            {
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)column.position, "", false);
                Minimap.Enabled = true;
                Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
            }
            else if (!string.IsNullOrEmpty(it.RightPanelDescription.Label))
            {
                Minimap.Enabled = false;
                var labels = it.RightPanelDescription.SplitLabel;
                BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_STATE");
                ScaleformMovieMethodAddParamInt((int)column.position);
                BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                for (var i = 0; i < labels?.Length; i++)
                    AddTextComponentScaleform(labels[i]);
                EndTextCommandScaleformString_2();
                ScaleformMovieMethodAddParamBool(true);
                EndScaleformMovieMethod();
            }
            else
            {
                Minimap.Enabled = false;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)column.position, "", true);
            }
        }

        public override void GoLeft()
        {
            if (!Focused) return;
            LeftColumn.GoLeft();
            column.UpdatePage();
            GalleryItem it = column.Items[column.currentPageIndex] as GalleryItem;
            if (bigPic)
            {
                SetTitle(it.TextureDictionary, it.TextureName, GalleryState.LOADED);
            }

            if (it.Blip != null)
            {
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)column.position, "", false);
                Minimap.Enabled = true;
                Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
            }
            else if (!string.IsNullOrEmpty(it.RightPanelDescription.Label))
            {
                Minimap.Enabled = false;
                var labels = it.RightPanelDescription.SplitLabel;
                BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_STATE");
                ScaleformMovieMethodAddParamInt((int)column.position);
                BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                for (var i = 0; i < labels?.Length; i++)
                    AddTextComponentScaleform(labels[i]);
                EndTextCommandScaleformString_2();
                ScaleformMovieMethodAddParamBool(true);
                EndScaleformMovieMethod();
            }
            else
            {
                Minimap.Enabled = false;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)column.position, "", true);
            }
        }

        public override void GoRight()
        {
            if (!Focused) return;
            LeftColumn.GoRight();
            column.UpdatePage();
            GalleryItem it = column.Items[column.currentPageIndex] as GalleryItem;
            if (bigPic)
            {
                SetTitle(it.TextureDictionary, it.TextureName, GalleryState.LOADED);
            }

            if (it.Blip != null)
            {
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)column.position, "", false);
                Minimap.Enabled = true;
                Minimap.RefreshMapPosition(new Vector2(it.Blip.Position.X, it.Blip.Position.Y));
            }
            else if (!string.IsNullOrEmpty(it.RightPanelDescription.Label))
            {
                Minimap.Enabled = false;
                var labels = it.RightPanelDescription.SplitLabel;
                BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_STATE");
                ScaleformMovieMethodAddParamInt((int)column.position);
                BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                for (var i = 0; i < labels?.Length; i++)
                    AddTextComponentScaleform(labels[i]);
                EndTextCommandScaleformString_2();
                ScaleformMovieMethodAddParamBool(true);
                EndScaleformMovieMethod();
            }
            else
            {
                Minimap.Enabled = false;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)column.position, "", true);
            }
        }

        public override void GoBack()
        {
            if (!Focused) return;
            LeftColumn.GoBack();
            CurrentColumnIndex = 0;
        }

        public override void Select()
        {
            if (!Focused) return;
            CurrentColumnIndex = 1;
            LeftColumn.Select();
        }

        public override void ShowColumns()
        {
            LeftColumn.ShowColumn();
        }

        public override void Focus()
        {
            base.Focus();
            if ((LeftColumn.Items[LeftColumn.Index] as GalleryItem).Blip != null)
            {
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)LeftColumn.position, "", false);
                Minimap.Enabled = true;
                Minimap.RefreshMapPosition(new Vector2((LeftColumn.Items[LeftColumn.Index] as GalleryItem).Blip.Position.X, (LeftColumn.Items[LeftColumn.Index] as GalleryItem).Blip.Position.Y));
            }
            else if (!string.IsNullOrEmpty((LeftColumn.Items[LeftColumn.Index] as GalleryItem).RightPanelDescription.Label))
            {
                Minimap.Enabled = false;
                var labels = (LeftColumn.Items[LeftColumn.Index] as GalleryItem).RightPanelDescription.SplitLabel;
                BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_STATE");
                ScaleformMovieMethodAddParamInt((int)LeftColumn.position);
                BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                for (var i = 0; i < labels?.Length; i++)
                    AddTextComponentScaleform(labels[i]);
                EndTextCommandScaleformString_2();
                ScaleformMovieMethodAddParamBool(true);
                EndScaleformMovieMethod();
            }
            else
            {
                Minimap.Enabled = false;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)LeftColumn.position, "", true);
            }
        }

        public override void UnFocus()
        {
            base.UnFocus();
            Minimap.Enabled = false;
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)LeftColumn.position, "", true);
        }


        internal void SetTitle(string txd, string txn, GalleryState state)
        {
            column.SetTitle(txd, txn, state);
        }

        public void SetDescriptionLabels(string title, string date, string location, string track, bool visible)
        {
            column.titleLabel = title;
            column.dateLabel = date;
            column.locationLabel = location;
            column.trackLabel = track;
            column.labelsVisible = visible;
            Main.PauseMenu._pause.CallFunction("SET_DESCRIPTION", (int)column.position, LeftColumn.VisibleItems, title, date, location, track, visible);
        }

        public void AddItem(GalleryItem item)
        {
            LeftColumn.AddItem(item);
            if (item.Blip != null)
                Minimap.MinimapBlips.Add(item.Blip);
            if (Parent != null && Parent.Visible && Visible)
            {
                if (column.Items.Count < 12)
                {
                    column.Populate();
                }
            }
        }

        public override void MouseEvent(int eventType, int context, int index)
        {
            if(Focused) return;
            switch (eventType)
            {
                case 5:
                    if(index != column.Index)
                    {
                        column.Items[column.Index].Selected = false;
                        column.Index = index;
                        column.Items[column.Index].Selected = true;
                        break;
                    }
                    column.Select();
                    CurrentColumnIndex = 1;
                    break;
                case 8:
                    break;
                case 9:
                    break;
                case 10:
                case 11:
                    column.MouseScroll(eventType == 10 ? -1 : 1);
                    break;
            }
        }


        internal void ModeChanged()
        {
            OnGalleryModeChanged?.Invoke(this, (column.Items[column.Index] as GalleryItem), bigPic);
        }

        internal void IndexChanged()
        {
            OnGalleryIndexChanged?.Invoke(this, (column.Items[column.Index] as GalleryItem), column.Index, column.currentPageIndex);
        }

        internal void ItemSelected()
        {
            OnGalleryItemSelected?.Invoke(this, (column.Items[column.Index] as GalleryItem), column.Index, column.currentPageIndex);
        }
    }
}
