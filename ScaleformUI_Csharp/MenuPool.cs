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

        public static UIMenu CurrentMenu
        {
            get => currentMenu;
            private set => currentMenu = value;
        }

        public static PauseMenuBase CurrentPauseMenu
        {
            get => currentBase;
            private set => currentBase = value;
        }

        /// <summary>
        /// Called when user either opens or closes the main menu, clicks on a binded button, goes back to a parent menu.
        /// </summary>
        public static event MenuStateChangeEvent OnMenuStateChanged;


        public static void SwitchTo(this UIMenu currentMenu, UIMenu newMenu, int newMenuCurrentSelection = 0, bool inheritOldMenuParams = false)
        {
            if (currentMenu == null)
                throw new ArgumentNullException("The menu you're switching from cannot be null.");
            if (currentMenu != MenuPool.currentMenu)
                throw new Exception("The menu you're switching from must be opened.");
            if (newMenu == null)
                throw new ArgumentNullException("The menu you're switching to cannot be null.");
            if (newMenu == currentMenu)
                throw new Exception("You cannot switch a menu to itself.");

            if (inheritOldMenuParams)
            {
                if (currentMenu._customTexture.Key != null && currentMenu._customTexture.Value != null)
                    newMenu.SetBannerType(currentMenu._customTexture);
                newMenu.Offset = currentMenu.Offset;
                newMenu.MouseEdgeEnabled = currentMenu.MouseEdgeEnabled;
                newMenu.MouseWheelControlEnabled = currentMenu.MouseWheelControlEnabled;
                newMenu.MouseControlsEnabled = currentMenu.MouseControlsEnabled;
                newMenu.MaxItemsOnScreen = currentMenu.MaxItemsOnScreen;
                newMenu.AnimationType = currentMenu.AnimationType;
                newMenu.BuildingAnimation = currentMenu.BuildingAnimation;
            }
            newMenu.CurrentSelection = newMenuCurrentSelection != 0 ? newMenuCurrentSelection : 0;
            currentMenu.Visible = false;
            newMenu.Visible = true;
            BreadcrumbsHandler.Forward(newMenu);
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
        public static async void ProcessMenus()
        {
            ProcessControl();
            ProcessMouse();
            Draw();
        }

        /// <summary>
        /// Closes any opened ScaleformUI menu or PauseMenu menu.
        /// </summary>
        public static void CloseAndClearHistory()
        {
            currentMenu!.Visible = false;
            currentBase!.Visible = false;
            BreadcrumbsHandler.Clear();
        }

        public static void MenuChangeEv(UIMenu oldmenu, UIMenu newmenu, MenuState state)
        {
            OnMenuStateChanged?.Invoke(oldmenu, newmenu, state);
        }
    }
}
