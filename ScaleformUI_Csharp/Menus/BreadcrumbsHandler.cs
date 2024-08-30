namespace ScaleformUI.Menus
{
    public static class BreadcrumbsHandler
    {
        private static readonly List<Tuple<MenuBase, dynamic>> breadcrumbs = new List<Tuple<MenuBase, dynamic>>();
        internal static int Count => breadcrumbs.Count;
        internal static int CurrentDepth => breadcrumbs.Count == 0 ? 0 : breadcrumbs.Count - 1;
        public static MenuBase PreviousMenu => breadcrumbs[CurrentDepth - 1].Item1;
        public static bool SwitchInProgress = false;

        internal static void Forward(MenuBase menu, dynamic data)
        {
            breadcrumbs.Add(new Tuple<MenuBase, dynamic>(menu, data));
        }

        internal static void Clear()
        {
            breadcrumbs.Clear();
        }

        internal static void Backwards()
        {
            breadcrumbs.RemoveAt(CurrentDepth);
        }
    }
}
