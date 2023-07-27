namespace ScaleformUI.Menu
{
    public enum PanelSide
    {
        Left,
        Right
    }
    public enum SidePanelsTitleType
    {
        Big,
        Small,
        Classic
    }

    public class UIMenuSidePanel
    {
        public virtual bool Selected { get; set; }
        public virtual bool Enabled { get; set; }
        public virtual PanelSide PanelSide { get; set; }
        public virtual void UpdateParent()
        {
        }
        public void SetParentItem(UIMenuItem item)
        {
            ParentItem = item;
        }

        public UIMenuItem ParentItem { get; set; }

    }
}
