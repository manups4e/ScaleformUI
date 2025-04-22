using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;

namespace ScaleformUI.Menus.Pause_Menus.Elements.Columns
{
    public class GalleryColumn : PM_Column
    {
        internal string txd = "";
        internal string txn = "";
        internal GalleryState state;
        internal string titleLabel = "";
        internal string dateLabel = "";
        internal string locationLabel = "";
        internal string trackLabel = "";
        internal bool labelsVisible = false;
        internal int CurPage = 0;
        internal int currentPageIndex = 0;
        public int MaxPages => (int)(Items.Count / 12 + 1);

        public GalleryColumn() : base(PM_COLUMNS.LEFT)
        {
            VisibleItems = 12;
        }
        internal bool IsItemVisible(int index)
        {
            int initial = CurPage * VisibleItems;
            return index > initial && index < initial + 11;
        }
        internal int GridIndexFromItemIndex(int index)
        {
            return index % 12;
        }
        internal bool ShouldNavigateToNewPage(int index)
        {
            return (Items.Count <= 12 || MaxPages == 1) ? false :
                (currentPageIndex is 0 && index is 0) || (currentPageIndex is 4 && index is 4) || (currentPageIndex is 8 && index is 8) ||
                (currentPageIndex is 3 && index is 3) || (currentPageIndex is 7 && index is 7) || (currentPageIndex is 11 && index is 11);
        }


        public override void ShowColumn(bool show = true)
        {
            base.ShowColumn(show);
            InitColumnScroll(true, 2, ScrollType.ALL, ScrollArrowsPosition.RIGHT);
            UpdatePage();
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, Focused, false, false);
            ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
        }

        public override void AddItem(PauseMenuItem item)
        {
            GalleryItem galleryItem = item as GalleryItem;
            Items.Add(galleryItem);
        }

        public override void Populate()
        {
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", (int)position);
            for (int i = 0; i < 12; i++)
            {
                int index = i + (CurPage * 12);
                if (index <= Items.Count - 1)
                {
                    GalleryItem item = Items[index] as GalleryItem;
                    Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT", (int)position, i, i, 33, 4, 0, 1, item.Label1, item.Label2, item.TextureDictionary, item.TextureName, 1, false, item.Label3, item.Label4);
                    if (item.Blip != null)
                        ((GalleryTab)Parent).Minimap.MinimapBlips.Add(item.Blip);
                }
                else
                    Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT", (int)position, i, i, 33, 0, 0, 1, "", "", "", "", 1, false);
            }
            base.ShowColumn();
        }

        public override void GoUp()
        {
            if (Parent.Parent.FocusLevel == 1)
            {
                int iPotentialIndex = Index;
                int iPotentialIndexPerPage = currentPageIndex;

                if (iPotentialIndexPerPage > 3)
                {
                    iPotentialIndex -= 4;
                    iPotentialIndexPerPage -= 4;
                }
                else
                {
                    iPotentialIndex += 8;
                    iPotentialIndexPerPage += 8;
                }

                if (iPotentialIndex >= Items.Count)
                    return;

                index = iPotentialIndex;
                currentPageIndex = iPotentialIndexPerPage;

                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, true, true);
                ((GalleryTab)Parent).IndexChanged();
            }
        }

         public override void GoDown()
        {
            int iPotentialIndex = Index;
            int iPotentialIndexPerPage = currentPageIndex;

            if (iPotentialIndexPerPage < 8)
            {
                iPotentialIndex += 4;
                iPotentialIndexPerPage += 4;
            }
            else
            {
                iPotentialIndex -= 8;
                iPotentialIndexPerPage -= 8;
            }

            if (iPotentialIndex >= Items.Count)
                return;

            index = iPotentialIndex;
            currentPageIndex = iPotentialIndexPerPage;

            Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, true, true);
            ((GalleryTab)Parent).IndexChanged();

        }

        public override void GoLeft()
        {
            int iPotentialIndex = Index;
            int iPotentialIndexPerPage = currentPageIndex;
            if (iPotentialIndex == 0)
            {
                index = Items.Count - 1;
                currentPageIndex = index % 12;
                CurPage = MaxPages - 1;
                if (MaxPages > 1)
                {
                    ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
                    Populate();
                }
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
            }
            else
            {

                if (currentPageIndex % 4 > 0 || (MaxPages <= 1) || (((GalleryTab)Parent).bigPic && Index > 0))
                {
                    iPotentialIndex--;
                    iPotentialIndexPerPage--;
                }

                if (ShouldNavigateToNewPage(iPotentialIndexPerPage))
                {
                    CurPage = CurPage <= 0 ? (MaxPages - 1) : CurPage - 1;

                    currentPageIndex = CurPage * VisibleItems + 3;
                    index = iPotentialIndexPerPage + 3;
                    if (index >= Items.Count || CurPage == MaxPages - 1)
                    {
                        index = Items.Count - 1;
                        currentPageIndex = Index % 12;
                    }

                    ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
                    Populate();

                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);

                }
                else
                {
                    index = iPotentialIndex;
                    currentPageIndex = iPotentialIndexPerPage;
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
                }
            }
        }

        public override void GoRight()
        {
            int iPotentialIndex = Index;
            int iPotentialIndexPerPage = currentPageIndex;
            if (iPotentialIndex == Items.Count - 1)
            {
                index = 0;
                currentPageIndex = 0;
                CurPage = 0;
                if (MaxPages > 1)
                {
                    ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
                    Populate();
                }
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
            }
            else
            {
                if ((currentPageIndex % 4 < 4 - 1) || MaxPages <= 1 || (((GalleryTab)Parent).bigPic && Index < 11))
                {
                    iPotentialIndex++;
                    iPotentialIndexPerPage++;
                }

                if (ShouldNavigateToNewPage(iPotentialIndexPerPage))
                {
                    CurPage = CurPage == (MaxPages - 1) ? 0 : CurPage + 1;

                    index = (CurPage * VisibleItems + iPotentialIndexPerPage - 3);
                    currentPageIndex = iPotentialIndexPerPage - 3;
                    if (index >= Items.Count || CurPage == 0)
                    {
                        index = 0;
                        currentPageIndex = 0;
                    }

                    ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
                    Populate();

                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
                }
                else
                {
                    index = iPotentialIndex;
                    currentPageIndex = iPotentialIndexPerPage;
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
                }
            }
        }

        public override void Select()
        {
            if (!((GalleryTab)Parent).bigPic)
            {
                SetTitle((Items[Index] as GalleryItem).TextureDictionary, (Items[Index] as GalleryItem).TextureName, GalleryState.LOADED);
                ((GalleryTab)Parent).bigPic = true;
                if ((Items[Index] as GalleryItem).Blip != null)
                {
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)position, "", false);
                    ((GalleryTab)Parent).Minimap.Enabled = true;
                    ((GalleryTab)Parent).Minimap.RefreshMapPosition(new Vector2((Items[Index] as GalleryItem).Blip.Position.X, (Items[Index] as GalleryItem).Blip.Position.Y));
                }
                else if (!string.IsNullOrEmpty((Items[Index] as GalleryItem).RightPanelDescription.Label))
                {
                    ((GalleryTab)Parent).Minimap.Enabled = false;
                    var labels = (Items[Index] as GalleryItem).RightPanelDescription.SplitLabel;
                    BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_STATE");
                    ScaleformMovieMethodAddParamInt((int)position);
                    BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                    for (var i = 0; i < labels?.Length; i++)
                        AddTextComponentScaleform(labels[i]);
                    EndTextCommandScaleformString_2();
                    ScaleformMovieMethodAddParamBool(true);
                    EndScaleformMovieMethod();
                }
                else
                {
                    ((GalleryTab)Parent).Minimap.Enabled = false;
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)position, "", true);
                }
                ((GalleryTab)Parent).ModeChanged();
            }
            else
            {
                ((GalleryTab)Parent).ItemSelected();
                (Items[Index] as GalleryItem).ItemSelected((GalleryTab)Parent, (Items[Index] as GalleryItem), Index, currentPageIndex);
            }
        }

        public override void GoBack()
        {
            if (((GalleryTab)Parent).bigPic)
            {
                SetTitle("", "", GalleryState.EMPTY);
                ((GalleryTab)Parent).bigPic = false;
                if ((Items[Index] as GalleryItem).Blip != null)
                {
                    ((GalleryTab)Parent).Minimap.Enabled = true;
                    ((GalleryTab)Parent).Minimap.RefreshMapPosition(new Vector2((Items[Index] as GalleryItem).Blip.Position.X, (Items[Index] as GalleryItem).Blip.Position.Y));
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)position, "", false);
                }
                else if (!string.IsNullOrEmpty((Items[Index] as GalleryItem).RightPanelDescription.Label))
                {
                    ((GalleryTab)Parent).Minimap.Enabled = false;
                    var labels = (Items[Index] as GalleryItem).RightPanelDescription.SplitLabel;
                    BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_STATE");
                    ScaleformMovieMethodAddParamInt((int)position);
                    BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                    for (var i = 0; i < labels?.Length; i++)
                        AddTextComponentScaleform(labels[i]);
                    EndTextCommandScaleformString_2();
                    ScaleformMovieMethodAddParamBool(true);
                    EndScaleformMovieMethod();
                }
                else
                {
                    ((GalleryTab)Parent).Minimap.Enabled = false;
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)position, "", true);
                }
                ((GalleryTab)Parent).ModeChanged();
                return;
            }
            else
            {
                //Index = 0;
                //currentPageIndex = 0;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_STATE", (int)position, "", true);
                if (((GalleryTab)Parent).Minimap.enabled)
                    ((GalleryTab)Parent).Minimap.Enabled = false;
            }
        }

        public override void MouseScroll(int dir)
        {
            if (((GalleryTab)Parent).bigPic || Parent.CurrentColumnIndex == 1)
            {
                if (dir == 1)
                    GoRight();
                else
                    GoLeft();
                return;
            }

            int iPotentialIndex = Index;
            int iPotentialIndexPerPage = currentPageIndex;

            if (iPotentialIndex == 0 && dir == -1)
            {
                index = Items.Count - 1;
                currentPageIndex = index % 12;
                CurPage = MaxPages - 1;
                if (MaxPages > 1)
                {
                    ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
                    Populate();
                }
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
            }
            else if (iPotentialIndex == Items.Count - 1 && dir == 1)
            {
                index = 0;
                currentPageIndex = 0;
                CurPage = 0;
                if (MaxPages > 1)
                {
                    ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
                    Populate();
                }
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
            }
            else
            {
                if (dir == -1)
                {
                    if (currentPageIndex != 0 || (MaxPages <= 1))
                    {
                        iPotentialIndex--;
                        iPotentialIndexPerPage--;
                    }
                    if (ShouldNavigateToNewPage(iPotentialIndexPerPage))
                    {
                        CurPage = CurPage <= 0 ? (MaxPages - 1) : CurPage - 1;

                        index = CurPage * 12;
                        currentPageIndex = 0;
                        ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
                        Populate();

                        Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
                    }
                    else
                    {
                        index = iPotentialIndex;
                        currentPageIndex = iPotentialIndexPerPage;
                        Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
                    }
                }
                else if (dir == 1)
                {
                    if ((currentPageIndex < 11) || MaxPages <= 1)
                    {
                        iPotentialIndex++;
                        iPotentialIndexPerPage++;
                    }
                    if (ShouldNavigateToNewPage(iPotentialIndexPerPage))
                    {
                        CurPage = CurPage == (MaxPages - 1) ? 0 : CurPage + 1;

                        index = CurPage * 12;
                        currentPageIndex = 0;
                        ((GalleryTab)Parent).SetDescriptionLabels(titleLabel, dateLabel, locationLabel, trackLabel, labelsVisible);
                        Populate();

                        Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
                    }
                    else
                    {
                        index = iPotentialIndex;
                        currentPageIndex = iPotentialIndexPerPage;
                        Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, currentPageIndex, true, true);
                    }
                }
            }
        }


        internal void UpdatePage()
        {
            if (!((GalleryTab)Parent).bigPic)
            {
                SetColumnScroll("GAL_NUM_PAGES", CurPage + 1, MaxPages);
            }
            else
            {
                SetColumnScroll(Index+1, Items.Count, VisibleItems);
            }
        }

        internal void SetTitle(string txd, string txn, GalleryState state)
        {
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, txd, txn, (int)state);
            ((GalleryTab)Parent).bigPic = state != GalleryState.EMPTY;
            UpdatePage();
        }
    }
}