namespace ScaleformUI
{
    internal class PaginationHandler
    {
        private int _currentPageIndex;
        private int _currentMenuIndex;
        private int currentPage;
        private int itemsPerPage;
        private int totalItems;

        internal int CurrentPage { get => currentPage; set => currentPage = value; }
        internal int ItemsPerPage { get => itemsPerPage; set => itemsPerPage = value; }
        internal int TotalItems { get => totalItems; set => totalItems = value; }
        internal int TotalPages => (int)Math.Floor(totalItems / (float)itemsPerPage);
        internal int CurrentPageStartIndex => CurrentPage * itemsPerPage;
        internal int CurrentPageEndIndex => CurrentPageStartIndex + itemsPerPage - 1;
        internal int CurrentPageIndex { get => _currentPageIndex; set => _currentPageIndex = GetPageIndex(value); }
        internal int CurrentMenuIndex { get => _currentMenuIndex; set => _currentMenuIndex = value; }
        internal int ScaleformIndex;

        internal int GetPageIndex(int menuIndex)
        {
            int page = GetPage(menuIndex);
            int startIndex = page * itemsPerPage;
            return menuIndex - startIndex;
        }
        // se la pagina ha meno di 7 elementi? cosa restituiamo? (elementi infiniti.. quindi si dovrebbe ripartire da 0)
        internal int GetMenuIndex(int page, int index)
        {
            int initialIndex = page * itemsPerPage;
            int endIndex = initialIndex + itemsPerPage - 1;
            return initialIndex + index;
        }

        internal int GetPage(int menuIndex)
        {
            return (int)Math.Floor(menuIndex / (float)itemsPerPage);
        }

        internal bool GoUp()
        {
            CurrentMenuIndex--;
            if (CurrentMenuIndex < 0)
                CurrentMenuIndex = TotalItems - 1;
            CurrentPageIndex = CurrentMenuIndex;
            ScaleformIndex--;
            CurrentPage = GetPage(CurrentMenuIndex);
            if (ScaleformIndex < 0)
            {
                if (TotalItems < itemsPerPage)
                {
                    ScaleformIndex = TotalItems - 1;
                    return false;
                }
                ScaleformIndex = 0;
                return true;
            }
            return false;
        }

        internal bool GoDown()
        {
            CurrentMenuIndex++;
            if (CurrentMenuIndex >= TotalItems)
                CurrentMenuIndex = 0;
            CurrentPageIndex = CurrentMenuIndex;
            ScaleformIndex++;
            CurrentPage = GetPage(CurrentMenuIndex);
            if (ScaleformIndex >= totalItems)
            {
                ScaleformIndex = 0;
                return false;
            }
            else if (ScaleformIndex >= itemsPerPage)
            {
                ScaleformIndex = itemsPerPage - 1;
                return true;
            }
            return false;
        }
    }
}
