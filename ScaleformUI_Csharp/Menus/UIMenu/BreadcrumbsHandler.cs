namespace ScaleformUI.Menu
{
    internal static class BreadcrumbsHandler
    {
        private static readonly List<Tuple<UIMenu, dynamic>> breadcrumbs = new List<Tuple<UIMenu, dynamic>>();
        internal static int Count => breadcrumbs.Count;
        internal static int CurrentDepth => breadcrumbs.Count - 1;
        internal static UIMenu PreviousMenu => breadcrumbs[CurrentDepth - 1].Item1;
        public static bool SwitchInProgress = false;

        internal static void Forward(UIMenu menu, dynamic data)
        {
            breadcrumbs.Add(new Tuple<UIMenu, dynamic>(menu, data));
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
