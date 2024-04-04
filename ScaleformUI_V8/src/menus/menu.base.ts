export abstract class BaseMenu {
    private accessor visible: boolean = false
    public instructionalButtons: any[] = [] //TODO! type this
    public Items: any[] = [] // no need to type this.. as well.. every menu has its own types...
    abstract processMouse(): void
    abstract processControl(): void
    abstract draw(): void

    public set Visible(state: boolean) {
        this.visible = state
    }
    public get Visible(): boolean {
        return this.visible
    }
}