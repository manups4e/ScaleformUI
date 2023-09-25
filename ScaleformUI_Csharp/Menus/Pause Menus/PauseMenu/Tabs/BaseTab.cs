using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public class BaseTab
    {
        internal int _type;
        internal SColor TabColor;
        public BaseTab(string name, SColor color)
        {
            Title = name;
            TabColor = color;
        }

        public bool Visible { get; set; }
        public virtual bool Focused { get; set; }
        public string Title { get; set; }
        public bool Active { get; set; }
        public TabView Parent { get; internal set; }

        public List<TabLeftItem> LeftItemList = new List<TabLeftItem>();

        public event EventHandler Activated;
        public event EventHandler DrawInstructionalButtons;

        public void OnActivated()
        {
            Activated?.Invoke(this, EventArgs.Empty);
        }
    }
}