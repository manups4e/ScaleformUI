using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus;
using ScaleformUI.PauseMenus.Elements;
using ScaleformUI.PauseMenus.Elements.Columns;
using ScaleformUI.PauseMenus.Elements.Items;
using ScaleformUI.PauseMenus.Elements.Panels;
using ScaleformUI.Scaleforms;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.LobbyMenu
{
    public delegate void LobbyMenuOpenEvent(MainView menu);
    public delegate void LobbyMenuCloseEvent(MainView menu);

    public class MainView : TabView
    {
        public event LobbyMenuOpenEvent OnLobbyMenuOpen;
        public event LobbyMenuCloseEvent OnLobbyMenuClose;
        public MinimapPanel Minimap => coronaTab.Minimap;

        public new int Index;

        public MainView(string title) : base(title)
        {
            IsCorona = true;
            coronaTab = new PlayerListTab("corona for mainview", SColor.HUD_None);
            AddTab(coronaTab);
            InstructionalButtons = new()
            {
                new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
                new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
            };
        }
        public MainView(string title, string subtitle) : base(title, subtitle)
        {
            IsCorona = true;
            coronaTab = new PlayerListTab("corona for mainview", SColor.HUD_None);
            AddTab(coronaTab);
            InstructionalButtons = new()
            {
                new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
                new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
            };
        }

        public MainView(string title, string subtitle, string sideTop, string sideMid, string sideBot) : base(title, subtitle, sideTop, sideMid, sideBot)
        {
            IsCorona = true;
            coronaTab = new PlayerListTab("corona for mainview", SColor.HUD_None);
            AddTab(coronaTab);
            InstructionalButtons = new()
            {
                new InstructionalButton(Control.PhoneSelect, UIMenu._selectTextLocalized),
                new InstructionalButton(Control.PhoneCancel, UIMenu._backTextLocalized),
            };
        }

        public void SelectColumn(int column) => coronaTab.SwitchColumn(column);
        public void SelectColumn(PM_COLUMNS column) => coronaTab.SwitchColumn(column);
        public void SetupLeftColumn(PM_Column column) => coronaTab.SetupLeftColumn(column);
        public void SetupCenterColumn(PM_Column column) => coronaTab.SetupCenterColumn(column);
        public void SetupRightColumn(PM_Column column) => coronaTab.SetupRightColumn(column);

        internal new void SendPauseMenuOpen()
        {
            OnLobbyMenuOpen?.Invoke(this);
        }

        internal new void SendPauseMenuClose()
        {
            OnLobbyMenuClose?.Invoke(this);
        }
    }
}