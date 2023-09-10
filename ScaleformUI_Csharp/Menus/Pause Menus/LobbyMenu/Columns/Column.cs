using ScaleformUI.PauseMenus;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.LobbyMenu
{
    public delegate void IndexChanged(int index);
    public class Column
    {
        public int ParentTab { get; internal set; }
        public PauseMenuBase Parent { get; internal set; }
        public string Label { get; internal set; }
        public HudColor Color { get; internal set; }
        public int Order { get; internal set; }
        public string Type { get; internal set; }

        public Column(string label, HudColor color)
        {
            Label = label;
            Color = color;
        }
    }
}
