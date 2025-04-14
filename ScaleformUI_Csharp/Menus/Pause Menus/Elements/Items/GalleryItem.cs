using ScaleformUI.Elements;
using ScaleformUI.PauseMenu;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public class GalleryItem : PauseMenuItem
    {
        public string TextureDictionary { get; private set; }
        public string TextureName { get; private set; }
        public string Label1 { get; private set; }
        public string Label2 { get; private set; }
        public string Label3 { get; private set; }
        public string Label4 { get; private set; }
        public ScaleformLabel RightPanelDescription { get; private set; }

        public event GalleryItemSelected Activated;

        public FakeBlip Blip { get; set; }

        public GalleryItem(string textureDictionary, string textureName) : base("")
        {
            TextureDictionary = textureDictionary;
            TextureName = textureName;
        }

        public void SetLabels(string label1, string label2, string label3, string label4)
        {
            Label1 = label1;
            Label2 = label2;
            Label3 = label3;
            Label4 = label4;
            //if (Parent != null && Parent.)
            //{
            //    int gridPosition = Parent.GridIndexFromItemIndex(Parent.GalleryItems.IndexOf(this));
            //    Parent.Parent._pause._pause.CallFunction("UPDATE_GALLERY_ITEM", gridPosition, gridPosition, 33, 4, 0, 1, Label1, Label2, TextureDictionary, TextureName, 1, false, Label3, Label4);
            //}
        }
        public void SetRightDescription(string description)
        {
            RightPanelDescription = description;
            if (Blip != null) return;
            //if (Parent != null && Parent.Visible && Parent.IsItemVisible(Parent.GalleryItems.IndexOf(this)))
            //{
            //    AddTextEntry("gallerytab_desc", RightPanelDescription);
            //    Parent.Parent._pause._pause.CallFunction("SET_GALLERY_PANEL_HIDDEN", false);
            //    BeginScaleformMovieMethod(Parent.Parent._pause._pause.Handle, "SET_GALLERY_PANEL_DESCRIPTION");
            //    BeginTextCommandScaleformString("gallerytab_desc");
            //    EndTextCommandScaleformString_2();
            //    EndScaleformMovieMethod();
            //}
        }

        internal void ItemSelected(GalleryTab tab, GalleryItem item, int totalIndex, int gridIndex)
        {
            Activated?.Invoke(tab, item, totalIndex, gridIndex);
        }
    }
}
