using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.LobbyMenu;
using ScaleformUI.PauseMenu;

namespace ScaleformUI
{
    public class LobbyItem
    {
        internal int _type;
        private bool _enabled = true;
        private bool _selected;
        private Ped clonePed;
        private int _clonePedHandle;
        private bool _clonePedAsleep = true;
        private bool _clonePedLighting = false;

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

        public bool ClonePedAsleep
        {
            get => _clonePedAsleep;
            set
            {
                _clonePedAsleep = value;
                // Don't ask me why its in reverse, it just is.
                // They should have called it SetPauseMenuPedAwakeState
                API.SetPauseMenuPedSleepState(!_clonePedAsleep);
            }
        }

        public bool ClonePedLighting
        {
            get => _clonePedLighting;
            set
            {
                _clonePedLighting = value;
                API.SetPauseMenuPedLighting(_clonePedLighting);
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
            if (API.DoesEntityExist(_clonePedHandle))
            {
                API.DeleteEntity(ref _clonePedHandle);
            }

            _clonePedHandle = API.ClonePed(ClonePed.Handle, 0, false, true);
            API.GivePedToPauseMenu(_clonePedHandle, 2);
            API.SetPauseMenuPedSleepState(!_clonePedAsleep);
            API.SetPauseMenuPedLighting(_clonePedLighting);
            API.SetEntityVisible(_clonePedHandle, true, false);
            API.FreezeEntityPosition(_clonePedHandle, true);
            API.SetEntityInvincible(_clonePedHandle, true);
            API.SetEntityCollision(_clonePedHandle, false, false);
            Vector3 pos = ClonePed.Position + new Vector3(0, 0, -10f);
            API.SetEntityCoords(_clonePedHandle, pos.X, pos.Y, pos.Z, true, false, false, false);
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
