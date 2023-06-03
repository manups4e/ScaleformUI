namespace ScaleformUI
{
    internal class PaginationHandler
    {
        private int _currentPageIndex;
        private int _currentMenuIndex;
        private int currentPage;
        private int itemsPerPage;
        private int minItem;
        private int maxItem;
        private int totalItems;
        private int scaleformIndex;

        internal int CurrentPage { get => currentPage; set => currentPage = value; }
        internal int ItemsPerPage { get => itemsPerPage; set => itemsPerPage = value; }
        internal int TotalItems { get => totalItems; set => totalItems = value; }
        internal int TotalPages => (int)Math.Floor(totalItems / (float)itemsPerPage);
        internal int CurrentPageStartIndex => CurrentPage * itemsPerPage;
        internal int CurrentPageEndIndex => CurrentPageStartIndex + (totalItems >= itemsPerPage ? itemsPerPage - 1 : totalItems);
        internal int CurrentPageIndex { get => _currentPageIndex; set => _currentPageIndex = GetPageIndexFromMenuIndex(value); }
        internal int CurrentMenuIndex { get => _currentMenuIndex; set => _currentMenuIndex = value; }
        internal int MinItem { get => minItem; set => minItem = value; }
        internal int MaxItem { get => maxItem; set => maxItem = value; }
        internal int ScaleformIndex { get => scaleformIndex; set => scaleformIndex = value; }

        internal bool IsItemVisible(int menuIndex)
        {
            return menuIndex >= minItem || menuIndex <= minItem && menuIndex <= maxItem;
        }

        internal int GetScaleformIndex(int menuIndex)
        {
            int id = 0;
            if (minItem <= menuIndex)
            {
                id = menuIndex - minItem;
            }
            else if (minItem > menuIndex && maxItem >= menuIndex)
            {
                id = (menuIndex - maxItem) + (itemsPerPage - 1);
            }
            return id;
        }

        internal int GetMenuIndexFromScaleformIndex(int scaleformIndex)
        {
            int id = 0;
            if (minItem <= scaleformIndex)
            {
                id = scaleformIndex + minItem;
            }
            else if (minItem > scaleformIndex && maxItem >= scaleformIndex)
            {
                id = GetMenuIndexFromPageIndex(0, (TotalItems - minItem) - scaleformIndex);
            }
            return id;
        }

        internal int GetPageIndexFromMenuIndex(int menuIndex)
        {
            int page = GetPage(menuIndex);
            int startIndex = page * itemsPerPage;
            return menuIndex - startIndex;
        }

        internal int GetMenuIndexFromPageIndex(int page, int index)
        {
            int initialIndex = page * itemsPerPage;
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
                if (TotalItems <= itemsPerPage)
                {
                    ScaleformIndex = TotalItems - 1;
                    return false;
                }
                minItem--;
                maxItem--;
                if (minItem < 0)
                    minItem = TotalItems - 1;
                if (maxItem < 0)
                    maxItem = TotalItems - 1;
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
                minItem++;
                maxItem++;
                if (minItem >= totalItems)
                    minItem = 0;
                if (maxItem >= totalItems)
                    maxItem = 0;
                return true;
            }
            return false;
        }
    }
}
