using ScaleformUI.LobbyMenu;
using ScaleformUI.Scaleforms;

namespace ScaleformUI.PauseMenu
{
    public class PlayerListTab : BaseTab
    {
        private const int V = 2;
        private bool _focused;
        private int focus = 0;
        internal List<Column> listCol;

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
                switch (listCol[Focus].Type)
                {
                    case "players":
                        PlayersColumn.Items[PlayersColumn.CurrentSelection].Selected = false;
                        break;
                    case "settings":
                        SettingsColumn.Items[SettingsColumn.CurrentSelection].Selected = false;
                        break;
                    case "missions":
                        MissionsColumn.Items[MissionsColumn.CurrentSelection].Selected = false;
                        break;
                }
                focus = value;
                if (focus < 0)
                    focus = 2;
                else if (focus > 2)
                    focus = 0;
                if (Parent != null && Parent.Visible)
                {
                    Parent._pause._pause.CallFunction("SET_PLAYERS_TAB_FOCUS", Parent.Tabs.IndexOf(this), focus);
                }
                switch (listCol[Focus].Type)
                {
                    case "players":
                        PlayersColumn.Items[PlayersColumn.CurrentSelection].Selected = true;
                        break;
                    case "settings":
                        SettingsColumn.Items[SettingsColumn.CurrentSelection].Selected = true;
                        break;
                    case "missions":
                        MissionsColumn.Items[MissionsColumn.CurrentSelection].Selected = true;
                        break;
                }
            }
        }
        public SettingsListColumn SettingsColumn { get; private set; }
        public PlayerListColumn PlayersColumn { get; private set; }
        public MissionsListColumn MissionsColumn { get; private set; }
        public MissionDetailsPanel MissionPanel { get; private set; }
        public PlayerListTab(string name) : base(name)
        {
            _type = V;
            SettingsColumn = new("", HudColor.NONE);
            PlayersColumn = new("", HudColor.NONE);
        }

        public void SetUpColumns(List<Column> columns)
        {
            if (columns.Count != 3)
                throw new Exception("You must have 3 columns!");
            if (columns[2] is PlayerListColumn)
                throw new Exception("For panel designs reasons, you can't have Players list in 3rd column!");

            listCol = columns;
            foreach (Column col in columns)
            {
                switch (col)
                {
                    case SettingsListColumn:
                        SettingsColumn = col as SettingsListColumn;
                        SettingsColumn.Parent = this.Parent;
                        SettingsColumn.Order = columns.IndexOf(col);
                        break;
                    case PlayerListColumn:
                        PlayersColumn = col as PlayerListColumn;
                        PlayersColumn.Parent = this.Parent;
                        PlayersColumn.Order = columns.IndexOf(col);
                        break;
                    case MissionsListColumn:
                        MissionsColumn = col as MissionsListColumn;
                        MissionsColumn.Parent = this.Parent;
                        MissionsColumn.Order = columns.IndexOf(col);
                        break;
                    case MissionDetailsPanel:
                        MissionPanel = col as MissionDetailsPanel;
                        MissionPanel.Parent = this.Parent;
                        MissionPanel.Order = columns.IndexOf(col);
                        break;
                }
            }
        }
    }
}