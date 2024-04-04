import { BaseMenu } from "./menu.base";

export class BreadcrumbsHandler {
    static breadcrumbs: [BaseMenu, any][] = [];
    public static SwitchInProgress: boolean = false

    static get Count(): number {
        return this.breadcrumbs.length;
    }

    static get CurrentDepth(): number {
        return this.breadcrumbs.length - 1;
    }

    public static  get PreviousMenu(): BaseMenu {
        return this.breadcrumbs[this.CurrentDepth - 1][0];
    }

    static Forward(menu: BaseMenu, data: any) {
        this.breadcrumbs.push([menu, data]);
    }

    static Clear() {
        this.breadcrumbs.length = 0;
    }

    static Backwards() {
        this.breadcrumbs.pop();
    }
}