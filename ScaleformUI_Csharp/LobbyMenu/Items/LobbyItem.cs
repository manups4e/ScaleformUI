using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.LobbyMenu;
using ScaleformUI.PauseMenu;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public class LobbyItem
    {
        internal int _type;
        private bool _enabled = true;
        private bool _selected;
        private Ped clonePed;

        /// <summary>
        /// Whether this item is currently selected.
        /// </summary>
        public virtual bool Selected
        {
            get => _selected;
            set
            {
                _selected = value;
            }
        }
        public Ped ClonePed
        {
            get => clonePed;
            set
            {
                clonePed = value;
                CreateClonedPed(clonePed);
            }
        }

        internal void CreateClonedPed(Ped ped)
        {
            if (ped == null) API.ClearPedInPauseMenu();
            else
            {
                if (ParentColumn != null && ParentColumn.Parent != null && ParentColumn.Parent.Visible)
                {
                    if (Panel != null)
                    {
                        Panel.UpdatePanel();
                    }
                    if (ParentColumn.Parent is MainView lobby)
                    {
                        if (lobby.PlayersColumn.Items[lobby.PlayersColumn.CurrentSelection] == this)
                        {
                            UpdateClone();
                        }
                    }
                    else if (ParentColumn.Parent is TabView pause)
                    {
                        if (pause.Tabs[pause.Index] is PlayerListTab tab)
                        {
                            if (tab.PlayersColumn.Items[tab.PlayersColumn.CurrentSelection] == this)
                            {
                                UpdateClone();
                            }
                        }
                    }
                }
            }
        }

        private async void UpdateClone()
        {
            var ped = new Ped(API.ClonePed(ClonePed.Handle, 0, true, true));
            API.GivePedToPauseMenu(ped.Handle, 2);
            API.SetPauseMenuPedSleepState(true);
            API.SetPauseMenuPedLighting(ParentColumn.Parent is not TabView || (ParentColumn.Parent as TabView).FocusLevel != 0);
        }


        /// <summary>
        /// Whether this item is currently being hovered on with a mouse.
        /// </summary>
        public virtual bool Hovered { get; set; }

        /// <summary>
        /// Whether this item is enabled or disabled (text is greyed out and you cannot select it).
        /// </summary>
        public virtual bool Enabled
        {
            get => _enabled;
            set
            {
                _enabled = value;
                if (ParentColumn != null)
                {
                    var it = ParentColumn.Items.IndexOf(this);
                    //ParentColumn.Parent._pause._lobby.CallFunction("ENABLE_ITEM", it, _enabled);
                }
            }
        }

        /// <summary>
        /// Returns the lobby this item is in.
        /// </summary>
        public PlayerListColumn ParentColumn { get; internal set; }
        public PlayerStatsPanel Panel { get; internal set; }
    }
}
