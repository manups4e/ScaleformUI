namespace ScaleformUI
{
    internal static class BreadcrumbsHandler
    {
        private static readonly List<UIMenu> breadcrumbs = new List<UIMenu>();
        internal static int Count => breadcrumbs.Count;
        internal static int CurrentDepth => breadcrumbs.Count - 1;
        internal static UIMenu PreviousMenu => breadcrumbs[CurrentDepth - 1];
        internal static bool SwitchInProgress = false;

        internal static void Forward(UIMenu menu)
        {
            breadcrumbs.Add(menu);
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
