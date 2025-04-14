using ScaleformUI.Elements;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenus.Elements;
using ScaleformUI.PauseMenus.Elements.Panels;

namespace ScaleformUI.PauseMenu
{
    public enum ScrollType {
        ALL = 0,
        UP_DOWN = 1,
        LEFT_RIGHT = 2,
        NONE = 3,
    }

    public enum ScrollArrowsPosition {
        LEFT = 0,
        CENTER = 1,
        RIGHT = 2,
    }

    public class BaseTab
    {
        internal int _type;
        internal string _identifier;
        internal SColor TabColor;
        public MinimapPanel Minimap { get; internal set; }
        public BaseTab(string name, SColor color)
        {
            Title = name;
            TabColor = color;
        }

        public virtual PM_Column LeftColumn { get; internal set; }
        public virtual PM_Column CenterColumn { get; internal set; }
        public virtual PM_Column RightColumn { get; internal set; }
        public bool Visible { get; set; }
        public virtual bool Focused { get; set; }
        public string Title { get; set; }
        public bool Active { get; set; }
        public TabView Parent { get; internal set; }
        public int CurrentColumnIndex { get; internal set; }
        public PM_Column CurrentColumn => CurrentColumnIndex switch
        {
            1 => CenterColumn,
            2 => RightColumn,
            _ => LeftColumn,
        };

        public event EventHandler Activated;
        public event EventHandler DrawInstructionalButtons;

        public void OnActivated()
        {
            Activated?.Invoke(this, EventArgs.Empty);
        }

        #region Virtual methods
        public virtual void Populate() { }
        public virtual void Refresh(bool highlightOldIndex) { }
        public virtual void ShowColumns() { }

        public virtual void SetDataSlot(PM_COLUMNS slot, int index) { }
        
        public virtual void UpdateSlot(PM_COLUMNS slot, int index) { }
        
        public virtual void AddSlot(PM_COLUMNS slot, int index) { }
        
        public virtual void Focus() { Focused = true; }
        public virtual void UnFocus() { Focused = false; }

        public virtual void GoUp() { }
        public virtual void GoDown() { }
        public virtual void GoLeft() { }
        public virtual void GoRight() { }
        public virtual void Select() { }
        public virtual void GoBack() { }
        public virtual void Selected() { }

        public virtual void MouseEvent(int eventType, int context, int index) { }

        public virtual void StateChange(int state) { }
        #endregion

        internal PM_Column GetColumnAtPosition(int position)
        {
            return GetColumnAtPosition((PM_COLUMNS)position);
        }
        internal virtual PM_Column GetColumnAtPosition(PM_COLUMNS position) 
        {
            return position switch
            {
                PM_COLUMNS.LEFT => LeftColumn,
                PM_COLUMNS.MIDDLE => CenterColumn,
                PM_COLUMNS.RIGHT => RightColumn,
                _ => null,
            };
        }
    }
}