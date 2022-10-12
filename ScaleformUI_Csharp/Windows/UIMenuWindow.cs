namespace ScaleformUI
{
    public class UIMenuWindow
    {
        public UIMenu ParentMenu { get; set; }
        internal int id;

        internal virtual void UpdateParent()
        {
        }
        internal virtual void Draw()
        {
        }

        public void SetParentMenu(UIMenu Menu)
        {
            ParentMenu = Menu;
        }

    }
}
