using ScaleformUI.LobbyMenu;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.PauseMenu
{
    public class PlayerListTab : BaseTab
    {
        private const int V = 2;
        private bool _focused;
        private int focus = 0;

        public override bool Focused
        {
            get { return _focused; }
            set
            {
                _focused = value;
            }
        }
        public int Focus
        {
            get => focus;
            set
            {
                focus = value;
                if (Parent != null && Parent.Visible)
                {
                    Parent._pause._pause.CallFunction("SET_PLAYERS_TAB_FOCUS", Parent.Tabs.IndexOf(this), focus);
                }
            }
        }
        public SettingsListColumn SettingsColumn { get; private set; }
        public PlayerListColumn PlayersColumn { get; private set; }
        public PlayerListTab(string name) : base(name)
        {
            _type = V;
            SettingsColumn = new("", HudColor.NONE);
            PlayersColumn = new("", HudColor.NONE);
        }
    }
}
