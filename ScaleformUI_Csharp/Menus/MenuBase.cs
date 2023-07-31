using ScaleformUI.Menu;

namespace ScaleformUI.Menus
{
    public class MenuBase
    {
        private bool visible;
        public virtual bool Visible
        {
            get => visible;
            set
            {
                visible = value;
                MenuHandler.ableToDraw = value;
            }
        }
        public List<InstructionalButton> InstructionalButtons { get; set; }
        internal virtual void ProcessControl(Keys key = Keys.None)
        {

        }
        internal virtual void ProcessMouse()
        {

        }
        internal virtual void Draw()
        {
        }
    }
}
