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
        public virtual void ProcessControls()
        {

        }
        public virtual void ProcessMouse()
        {

        }
        public virtual void Draw()
        {
        }
    }
}
