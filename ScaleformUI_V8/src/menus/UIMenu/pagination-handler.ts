import { MenuScrollingType } from "elements/scrolling-type"

export class PaginationHandler {
    _currentPageIndex: number;
    _currentMenuIndex: number;
    currentPage: number;
    itemsPerPage: number;
    minItem: number;
    maxItem: number;
    totalItems: number;
    scaleformIndex: number;
    scrollType: MenuScrollingType;

    constructor() {
        this._currentPageIndex = 0
        this._currentMenuIndex = 0
        this.currentPage = 0
        this.itemsPerPage = 0
        this.minItem = 0
        this.maxItem = 0
        this.totalItems = 0
        this.scaleformIndex = 0
        this.scrollType = MenuScrollingType.CLASSIC
    }

    set CurrentPage(_val: number) {
        this.currentPage = _val;
    }
    get CurrentPage(): number {
        return this.currentPage;
    }

    set ItemsPerPage(val: number) {
        this.itemsPerPage = val;
    }
    get ItemsPerPage(): number {
        return this.itemsPerPage;
    }

    set TotalItems(val: number) {
        this.totalItems = val;
    }
    get TotalItems(): number {
        return this.totalItems;
    }

    get TotalPages(): number {
        return Math.ceil(this.totalItems / (this.itemsPerPage))
    }

    get CurrentPageStartIndex(): number {
        return this.currentPage * this.itemsPerPage
    }

    get CurrentPageEndIndex(): number {
        let index: number = this.CurrentPageStartIndex + this.itemsPerPage - 1
        if (index >= this.totalItems)
            index = this.totalItems - 1
        return index
    }

    set CurrentPageIndex(_val: number) {
        this._currentPageIndex = this.GetPageIndexFromMenuIndex(_val)
    }
    get CurrentPageIndex(): number {
        return this._currentPageIndex
    }

    set CurrentMenuIndex(val: number) {
        this._currentMenuIndex = val;
    }
    get CurrentMenuIndex(): number {
        return this._currentMenuIndex;
    }

    set MinItem(val: number) {
        this.minItem = val;
    }
    get MinItem(): number {
        return this.minItem;
    }

    set MaxItem(val: number) {
        this.maxItem = val;
    }
    get MaxItem(): number {
        return this.maxItem;
    }

    set ScaleformIndex(val: number) {
        this.scaleformIndex = val;
    }
    get ScaleformIndex(): number {
        return this.scaleformIndex;
    }

    IsItemVisible(menuIndex: number): boolean {
        return menuIndex >= this.minItem || menuIndex <= this.minItem && menuIndex <= this.maxItem
    }

    GetScaleformIndex(menuIndex: number): number {
        let id: number = 0
        if (this.minItem <= menuIndex)
            id = menuIndex - this.minItem
        else if (this.minItem > menuIndex && this.maxItem >= menuIndex)
            id = (menuIndex - this.minItem) + (this.itemsPerPage - 1)
        return id;
    }

    GetMenuIndexFromScaleformIndex(scaleformIndex: number): number {
        let tmpIndex: number = this.minItem + scaleformIndex
        if (tmpIndex >= this.totalItems)
            tmpIndex = this.totalItems - 1
        return tmpIndex
    }

    GetPageIndexFromScaleformIndex(scaleformIndex: number): number {
        let menuIndex: number = this.GetMenuIndexFromScaleformIndex(scaleformIndex)
        return this.GetPageIndexFromMenuIndex(menuIndex)
    }

    GetPageIndexFromMenuIndex(menuIndex: number): number {
        let page: number = this.GetPage(menuIndex)
        let startIndex = page * this.itemsPerPage
        return menuIndex - startIndex
    }

    GetPageFromScaleformIndex(scaleformIndex: number): number {
        let menuIndex: number = this.GetMenuIndexFromScaleformIndex(scaleformIndex)
        return this.GetPage(menuIndex)
    }

    GetPage(menuIndex: number): number {
        return Math.floor(menuIndex / this.itemsPerPage)
    }

    GetPageItemsCount(page: number): number {
        let minItem: number = page * this.itemsPerPage;
        let maxItem: number = minItem + this.itemsPerPage - 1;
        if (maxItem >= this.totalItems)
            maxItem = this.totalItems - 1;
        return (maxItem - minItem) + 1;
    }

    GetMenuIndexFromPageIndex(page:number, index:number){
        let initialIndex = page * this.itemsPerPage;
        return initialIndex + index;
    }

    GetMissingItems(): number {
        let count: number = this.GetPageItemsCount(this.currentPage)
        return this.itemsPerPage - count
    }

    Reset() {
        this._currentPageIndex = 0;
        this._currentMenuIndex = 0;
        this.currentPage = 0;
        this.minItem = 0;
        this.maxItem = 0;
        this.totalItems = 0;
        this.scaleformIndex = 0;
    }

    GoUp(): boolean {
        let overflow: boolean = false;
        this.CurrentMenuIndex--
        if (this.CurrentMenuIndex < 0) {
            this.CurrentMenuIndex = this.TotalItems - 1;
            overflow = this.TotalPages > 1;
        }
        this.CurrentPageIndex = this.CurrentMenuIndex;
        this.ScaleformIndex--;
        this.CurrentPage = this.GetPage(this.CurrentMenuIndex);
        if (this.ScaleformIndex < 0) {
            if (this.TotalItems <= this.itemsPerPage) {
                this.ScaleformIndex = this.TotalItems - 1;
                return false;
            }
            if (this.scrollType == MenuScrollingType.ENDLESS || (this.scrollType == MenuScrollingType.CLASSIC && !overflow)) {
                this.minItem--;
                this.maxItem--;
                if (this.minItem < 0)
                    this.minItem = this.TotalItems - 1;
                if (this.maxItem < 0)
                    this.maxItem = this.TotalItems - 1;
                this.ScaleformIndex = 0;
                return true;
            }
            else if (this.scrollType == MenuScrollingType.PAGINATED || (this.scrollType == MenuScrollingType.CLASSIC && overflow)) {
                this.minItem = this.CurrentPageStartIndex;
                this.maxItem = this.CurrentPageEndIndex;
                this.ScaleformIndex = this.GetPageIndexFromMenuIndex(this.CurrentPageEndIndex);
                if (this.scrollType == MenuScrollingType.CLASSIC) {
                    let missingItems: number = this.GetMissingItems();
                    if (missingItems > 0) {
                        this.ScaleformIndex = this.GetPageIndexFromMenuIndex(this.CurrentPageEndIndex) + missingItems;
                        this.minItem = this.CurrentPageStartIndex - missingItems;
                    }
                }
                return true;
            }
        }
        return false;
    }

    GoDown(): boolean {
        let overflow: boolean = false;
        this.CurrentMenuIndex++;
        if (this.CurrentMenuIndex >= this.TotalItems) {
            this.CurrentMenuIndex = 0;
            overflow = this.TotalPages > 1;
        }
        this.CurrentPageIndex = this.CurrentMenuIndex;
        this.ScaleformIndex++;
        if (this.ScaleformIndex >= this.totalItems) {
            this.ScaleformIndex = 0;
            this.CurrentPage = this.GetPage(this.CurrentMenuIndex);
            return false;
        }
        else if (this.scaleformIndex > this.itemsPerPage - 1) {
            if (this.scrollType == MenuScrollingType.ENDLESS || (this.scrollType == MenuScrollingType.CLASSIC && !overflow)) {
                this.CurrentPage = this.GetPage(this.CurrentMenuIndex);
                this.ScaleformIndex = this.itemsPerPage - 1;
                this.minItem++;
                this.maxItem++;
                if (this.minItem >= this.totalItems)
                    this.minItem = 0;
                if (this.maxItem >= this.totalItems)
                    this.maxItem = 0;
                return true;
            }
            else if (this.scrollType == MenuScrollingType.PAGINATED || (this.scrollType == MenuScrollingType.CLASSIC && overflow)) {
                this.CurrentPage = this.GetPage(this.CurrentMenuIndex);
                this.minItem = this.CurrentPageStartIndex;
                this.maxItem = this.CurrentPageEndIndex;
                this.ScaleformIndex = 0;
                return true;
            }
        }
        else if (this.scrollType == MenuScrollingType.PAGINATED && this.scaleformIndex > this.GetPageIndexFromMenuIndex(this.CurrentPageEndIndex)) {
            this.CurrentPage = this.GetPage(this.CurrentMenuIndex);
            this.minItem = this.CurrentPageStartIndex;
            this.maxItem = this.CurrentPageEndIndex;
            this.ScaleformIndex = 0;
            return true;
        }
        this.CurrentPage = this.GetPage(this.CurrentMenuIndex);
        return false;

    }
}