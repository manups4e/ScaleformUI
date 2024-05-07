using ScaleformUI.Elements;
using ScaleformUI.PauseMenus.Elements.Items;
using ScaleformUI.PauseMenus.Elements.Panels;
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
        internal string txd = "";
        internal string txn = "";
        internal int maxItemsPerPage = 12;
        internal GalleryState state;
        internal string titleLabel = "";
        internal string dateLabel = "";
        internal string locationLabel = "";
        internal string trackLabel = "";
        internal bool labelsVisible = false;
        internal bool bigPic = false;
        internal int CurPage = 0;
        private int currentSelection = 0;
        internal int currentIndex = 0;
        public int MaxPages => (int)Math.Ceiling(GalleryItems.Count / (float)12);

        public event GalleryModeChanged OnGalleryModeChanged;
        public event GalleryIndexChanged OnGalleryIndexChanged;
        public event GalleryItemSelected OnGalleryItemSelected;

        public List<GalleryItem> GalleryItems { get; private set; }
        public MinimapPanel Minimap { get; internal set; }
        public GalleryTab(string name, SColor color) : base(name, color)
        {
            _type = 3;
            Minimap = new MinimapPanel(Parent, this);
            this.GalleryItems = new List<GalleryItem>();
        }

        internal bool ShouldNavigateToNewPage(int index)
        {
            if (GalleryItems.Count <= 12 || MaxPages <= 1)
                return false;

            if (currentSelection is 0 or 4 or 8 && index is 0 or 4 or 8 || currentSelection is 3 or 7 or 11 && index is 3 or 7 or 11)
                return true;
            return false;
        }

        internal bool IsItemVisible(int index)
        {
            int initial = CurPage * maxItemsPerPage;
            return index > initial && index < initial + 11;
        }
        internal int GridIndexFromItemIndex(int index)
        {
            return index % 12;
        }


        public void SetTitle(string txd, string txn, GalleryState state)
        {
            this.txd = txd;
            this.txn = txn;
            this.state = state;
            if (Parent != null && Parent.Visible && Visible)
            {
                bigPic = state != GalleryState.EMPTY;
                Parent._pause._pause.CallFunction("SET_GALLERY_TITLE", txd, txn, (int)state);
                UpdatePage();
            }
        }

        public void SetDescriptionLabels(int maxItems, string title, string date, string location, string track, bool visible)
        {
            this.maxItemsPerPage = maxItems;
            this.titleLabel = title;
            this.dateLabel = date;
            this.locationLabel = location;
            this.trackLabel = track;
            this.labelsVisible = visible;
            if (Parent != null && Parent.Visible && Visible)
            {
                Parent._pause._pause.CallFunction("SET_GALLERY_DESCRIPTION_LABELS", maxItems, title, date, location, track, visible);
            }
        }

        public void AddItem(GalleryItem item)
        {
            item.Parent = this;
            GalleryItems.Add(item);
            if (item.Blip != null)
                Minimap.MinimapBlips.Add(item.Blip);
            if (Parent != null && Parent.Visible && Visible)
            {
                if (GalleryItems.Count < 12)
                {
                    // 0, index, menuId, uniqueID (33 for gallery), type (check GalleryState), initialIndex, isSelectable, [item data after]
                    // item data is: string unknown, txd, txn, string unkown, bookmarkVisible, 
                    Parent._pause._pause.CallFunction("ADD_GALLERY_ITEM", 0, GalleryItems.IndexOf(item), GalleryItems.IndexOf(item), 33, 0, 0, 1, "", item.TextureDictionary, item.TextureName, "", 1, false, item.Label1, item.Label2, item.Label3, item.Label4);
                }
            }
        }

        public int CurrentSelection
        {
            get => currentSelection;
            set
            {
                currentSelection = value;
                if (Parent != null && Parent.Visible && Visible)
                {
                    if (Parent.FocusLevel > 0)
                    {
                        Minimap.Enabled = GalleryItems[currentIndex].Blip != null;
                    }
                    else
                        Minimap.Enabled = false;
                }
            }
        }

        internal void UpdateHighlight()
        {
            Parent._pause._pause.CallFunction("UPDATE_GALLERY_HIGHLIGHT", currentSelection, true);
        }
        internal void UpdatePage()
        {
            if (!bigPic)
            {
                BeginScaleformMovieMethod(Parent._pause._pause.Handle, "SET_GALLERY_SCROLL_LABEL");
                ScaleformMovieMethodAddParamInt(0);
                ScaleformMovieMethodAddParamInt(0);
                ScaleformMovieMethodAddParamInt(0);
                BeginTextCommandScaleformString("GAL_NUM_PAGES");
                AddTextComponentInteger(CurPage + 1);
                AddTextComponentInteger(MaxPages);
                EndTextCommandScaleformString();
                EndScaleformMovieMethod();
            }
            else
            {
                BeginScaleformMovieMethod(Parent._pause._pause.Handle, "SET_GALLERY_SCROLL_LABEL");
                ScaleformMovieMethodAddParamInt(currentIndex);
                ScaleformMovieMethodAddParamInt(GalleryItems.Count);
                ScaleformMovieMethodAddParamInt(maxItemsPerPage);
                EndScaleformMovieMethod();
            }
        }

        internal void ModeChanged()
        {
            OnGalleryModeChanged?.Invoke(this, this.GalleryItems[currentIndex], bigPic);
        }

        internal void IndexChanged()
        {
            OnGalleryIndexChanged?.Invoke(this, this.GalleryItems[currentIndex], currentIndex, currentSelection);
        }

        internal void ItemSelected()
        {
            OnGalleryItemSelected?.Invoke(this, this.GalleryItems[currentIndex], currentIndex, currentSelection);
        }
    }
}
