using CitizenFX.Core;
using CitizenFX.Core.Native;

namespace ScaleformUI
{
    // TODO: Add ClearHistory() / CloseAndClearBreadcrumbs() method to handle close and reset.

    public delegate void MenuStateChangeEvent(UIMenu oldMenu, UIMenu newMenu, MenuState state);

    /// <summary>
    /// Helper class that handles all of your Menus. After instatiating it, you will have to add your menu by using the Add method.
    /// </summary>
    public static class MenuPool
    {
        internal static Dictionary<int, UIMenu> breadCrumbs = new Dictionary<int, UIMenu>();
        internal static UIMenu currentMenu;
        internal static PauseMenuBase currentBase;
        internal static bool ableToDraw;
        private static Ped _ped;
        internal static Ped PlayerPed
        {
            get
            {
                int handle = API.PlayerPedId();

                if (_ped is null || handle != _ped.Handle)
                {
                    _ped = new Ped(handle);
                }

                return _ped;
            }
        }

        public static bool MouseEdgeEnabled { set { currentMenu.MouseEdgeEnabled = value; } }

        public static bool ControlDisablingEnabled { set { currentMenu.ControlDisablingEnabled = value; } }

        public static bool ResetCursorOnOpen { set { currentMenu.ResetCursorOnOpen = value; } }

        public static int WidthOffset { set { currentMenu.SetMenuWidthOffset(value); } }

        public static bool DisableInstructionalButtons { set { currentMenu.DisableInstructionalButtons(value); } }

        public static bool BannerInheritance = true;

        public static bool OffsetInheritance = true;
        public static int CurrentDepth
        {
            get
            {
                if (breadCrumbs.Count == 0) return 0;
                return breadCrumbs.Count - 1;
            }
        }

        public static UIMenu CurrentMenu
        {
            get => currentMenu;
            private set => currentMenu = value;
        }

        /// <summary>
        /// Called when user either opens or closes the main menu, clicks on a binded button, goes back to a parent menu.
        /// </summary>
        public static event MenuStateChangeEvent OnMenuStateChanged;


        public static void SwitchTo(this UIMenu menu, UIMenu newMenu, int newMenuCurrentSelection = 0, bool inheritOldMenuParams = false)
        {
            if (menu == null)
                throw new ArgumentNullException("The menu you're switching from cannot be null.");
            if (menu != currentMenu)
                throw new Exception("The menu you're switching from must be opened.");
            if (newMenu == null)
                throw new ArgumentNullException("The menu you're switching to cannot be null.");
            if (newMenu == menu)
                throw new Exception("You cannot switch a menu to itself.");

            if (inheritOldMenuParams)
            {
                if (BannerInheritance && menu._customTexture.Key != null && menu._customTexture.Value != null)
                    newMenu.SetBannerType(menu._customTexture);
                newMenu.MouseEdgeEnabled = menu.MouseEdgeEnabled;
                newMenu.MouseEdgeEnabled = menu.MouseEdgeEnabled;
                newMenu.MouseWheelControlEnabled = menu.MouseWheelControlEnabled;
                newMenu.MouseControlsEnabled = menu.MouseControlsEnabled;
                newMenu.MaxItemsOnScreen = menu.MaxItemsOnScreen;
                newMenu.BuildAsync = menu.BuildAsync;
                newMenu.AnimationType = menu.AnimationType;
                newMenu.BuildingAnimation = menu.BuildingAnimation;
            }
            menu.Visible = false;
            newMenu.Visible = true;
        }

        /// <summary>
        /// Processes all of your visible menus' controls.
        /// </summary>
        public static void ProcessControl()
        {
            currentMenu?.ProcessControl();
            currentBase?.ProcessControls();
        }


        /// <summary>
        /// Processes all of your visible menus' mouses.
        /// </summary>
        public static void ProcessMouse()
        {
            currentMenu?.ProcessMouse();
            currentBase?.ProcessMouse();
        }


        /// <summary>
        /// Draws all visible menus.
        /// </summary>
        public static void Draw()
        {
            currentMenu?.Draw();
            currentBase?.Draw();
        }


        /// <summary>
        /// Checks if any menu is currently visible.
        /// </summary>
        /// <returns>true if one menu is visible, false if not.</returns>
        public static bool IsAnyMenuOpen => currentMenu?.Visible ?? false;

        public static bool IsAnyPauseMenuOpen => currentBase?.Visible ?? false;

        /// <summary>
        /// Process all of your menus' functions. Call this in a tick event.
        /// </summary>
        public static async void ProcessMenus(bool draw)
        {
            ableToDraw = draw;
            while (ableToDraw)
            {
                await BaseScript.Delay(0);
                ProcessControl();
                ProcessMouse();
                Draw();
            }
        }

        /// <summary>
        /// Closes any opened ScaleformUI menu or PauseMenu menu.
        /// </summary>
        public static void CloseAllMenus()
        {
            if (currentMenu != null) currentMenu.Visible = false;
            if (currentBase != null) currentBase.Visible = false;
        }

        public static void MenuChangeEv(UIMenu oldmenu, UIMenu newmenu, MenuState state)
        {
            OnMenuStateChanged?.Invoke(oldmenu, newmenu, state);
        }
    }
}
