namespace ScaleformUI.PauseMenu
{
    public class KeymapItem : BasicTabItem
    {
        public string PrimaryKeyboard;
        public string PrimaryGamepad;
        public string SecondaryKeyboard;
        public string SecondaryGamepad;
        public KeymapItem(string title, string primaryKeyboard) : this(title, primaryKeyboard, "") { }
        public KeymapItem(string title, string primaryKeyboard, string secondaryKeyboard) : base(title)
        {
            PrimaryKeyboard = primaryKeyboard;
            PrimaryGamepad = primaryKeyboard;
            SecondaryKeyboard = secondaryKeyboard;
            SecondaryGamepad = secondaryKeyboard;
        }
        public KeymapItem(string title, string primaryKeyboard, string primaryGamepad, string secondaryKeyboard, string secondaryGamepad) : base(title)
        {
            PrimaryKeyboard = primaryKeyboard;
            PrimaryGamepad = primaryGamepad;
            SecondaryKeyboard = secondaryKeyboard;
            SecondaryGamepad = secondaryGamepad;
        }
    }
}
