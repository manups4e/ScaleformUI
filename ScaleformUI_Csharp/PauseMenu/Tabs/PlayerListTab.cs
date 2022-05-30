using ScaleformUI.LobbyMenu;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public class PlayerListTab : BaseTab
    {
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
            _type = 2;
            SettingsColumn = new("", HudColor.NONE);
            PlayersColumn = new("", HudColor.NONE);
        }
    }
}
