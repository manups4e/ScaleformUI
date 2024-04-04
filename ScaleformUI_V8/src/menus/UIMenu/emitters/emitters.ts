import { DelegateBuilder, IDelegate } from "helpers/eventemitter";
import { UIMenu } from "../uimenu";
import { UIMenuItem } from "../items/uimenuitem";
import { UIMenuCheckboxItem } from "../items/uimenucheckboxitem";
import { ChangeDirection, UIMenuDynamicListItem } from "../items/uimenudynamiclistitem";
import { UIMenuListItem } from "../items/uimenulistitem";
import { UIMenuProgressItem } from '../items/uimenuprogressitem';
import { UIMenuSliderItem } from "../items/uimenuslideritem";
import { UIMenuStatsItem } from "../items/uimenustatsitem";
import { InstructionalButton } from '../../../scaleforms/instructional-buttons/instructionalbutton';
import { UIMenuColorPanel } from "../panels/uimenucolorpanel";
import { UIVehicleColourPickerPanel } from "../sidepanels/ColorPicker/uivehiclecolourpickerpanel";
import { UIMenuPercentagePanel } from "../panels/uimenupercentagepanel";
import { Vector2 } from "math/vector2";
import { UIMenuGridPanel } from "../panels/uimenugridpanel";

// interfaces
export interface UIMenuItemChangeCallback extends IDelegate {
    (menu: UIMenu, item: UIMenuItem): Promise<void>;
}
export interface UIMenuCheckboxItemChangeCallback extends IDelegate {
    (item: UIMenuCheckboxItem, value: boolean): Promise<void>;
}
export interface UIMenuDynamicListItemChangeCallback extends IDelegate {
    (sender: UIMenuDynamicListItem, direction: ChangeDirection): Promise<string>;
}
export interface UIMenuListItemChangeCallback extends IDelegate {
    (sender: UIMenuListItem, newIndex: number): Promise<void>;
}
export interface ItemSliderProgressCallback extends IDelegate {
    (sender: UIMenuProgressItem, newIndex: number): Promise<void>;
}
export interface ItemSliderCallback extends IDelegate {
    (sender: UIMenuSliderItem, newIndex: number): Promise<void>;
}
export interface ItemStatCallback extends IDelegate {
    (newIndex: number): Promise<void>;
}
export interface IndexChangedEvent {
    (sender: UIMenu, newIndex: number): Promise<void>;
}
export interface ListChangedEvent {
    (sender: UIMenu, listItem: UIMenuListItem, newIndex: number): Promise<void>;
}
export interface SliderChangedEvent {
    (sender: UIMenu, listItem: UIMenuSliderItem, newIndex: number): Promise<void>;
}
export interface ListSelectedEvent {
    (sender: UIMenu, listItem: UIMenuListItem, newIndex: number): Promise<void>;
}
export interface CheckboxChangeEvent {
    (sender: UIMenu, checkboxItem: UIMenuCheckboxItem, checked: boolean): Promise<void>;
}
export interface ItemSelectEvent {
    (sender: UIMenu, selectedItem: UIMenuItem, index: number): Promise<void>;
}
export interface ItemActivatedEvent {
    (sender: UIMenu, selectedItem: UIMenuItem): Promise<void>;
}
export interface OnProgressChanged {
    (menu: UIMenu, item: UIMenuProgressItem, newIndex: number): Promise<void>;
}
export interface OnProgressSelected {
    (menu: UIMenu, item: UIMenuProgressItem, newIndex: number): Promise<void>;
}
export interface StatItemProgressChange {
    (menu: UIMenu, item: UIMenuStatsItem, value: number): Promise<void>;
}
export interface ColorPanelChangedEvent {
    (menuItem: UIMenuItem, panel: UIMenuColorPanel, index: number): Promise<void>;
}
export interface VehicleColorPickerSelectEvent {
    (menuItem: UIMenuItem, panel: UIVehicleColourPickerPanel, index: number): Promise<void>;
}
export interface PercentagePanelChangedEvent {
    (menuItem: UIMenuItem, panel: UIMenuPercentagePanel, value:  number): Promise<void>;
}
export interface GridPanelChangedEvent {
    (menuItem: UIMenuItem, panel: UIMenuGridPanel, value: Vector2): Promise<void>;
}
export interface MenuOpenedEvent {
    (menu: UIMenu, data?: any): Promise<void>;
}
export interface MenuClosedEvent {
    (menu: UIMenu): Promise<void>;
}
export interface InstructionalButtonSelectedEvent{
    (control:InstructionalButton) : Promise<void>
}

//builders
export class ItemChangeCallbackBuilder extends DelegateBuilder {
    add(callback: UIMenuItemChangeCallback): ItemChangeCallbackBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: UIMenuItemChangeCallback): ItemChangeCallbackBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): UIMenuItemChangeCallback {
        return async (menu: UIMenu, item: UIMenuItem) => {
            await super.toDelegate()(menu, item);
        };
    }
}

export class CheckboxItemChangeCallbackBuilder extends DelegateBuilder {
    add(callback: UIMenuCheckboxItemChangeCallback): CheckboxItemChangeCallbackBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: UIMenuCheckboxItemChangeCallback): CheckboxItemChangeCallbackBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): UIMenuCheckboxItemChangeCallback {
        return async (item: UIMenuCheckboxItem, checked: boolean) => {
            await super.toDelegate()(item, checked);
        };
    }
}

export class UIMenuDynamicListItemChangeCallbackBuilder extends DelegateBuilder {
    add(callback: UIMenuDynamicListItemChangeCallback): UIMenuDynamicListItemChangeCallbackBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: UIMenuDynamicListItemChangeCallback): UIMenuDynamicListItemChangeCallbackBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): UIMenuDynamicListItemChangeCallback {
        return async (sender: UIMenuDynamicListItem, direction: ChangeDirection) => {
            return await super.toDelegate()(sender, direction);
        };
    }
}

export class ListItemChangeCallbackBuilder extends DelegateBuilder {
    add(callback: UIMenuListItemChangeCallback): ListItemChangeCallbackBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: UIMenuListItemChangeCallback): ListItemChangeCallbackBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): UIMenuListItemChangeCallback {
        return async (item: UIMenuListItem, newIndex: number) => {
            await super.toDelegate()(item, newIndex);
        };
    }
}

export class ProgressItemCallbackBuilder extends DelegateBuilder {
    add(callback: ItemSliderProgressCallback): ProgressItemCallbackBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: ItemSliderProgressCallback): ProgressItemCallbackBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): ItemSliderProgressCallback {
        return async (item: UIMenuProgressItem, newIndex: number) => {
            await super.toDelegate()(item, newIndex);
        };
    }
}

export class SliderItemCallbackBuilder extends DelegateBuilder {
    add(callback: ItemSliderCallback): SliderItemCallbackBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: ItemSliderCallback): SliderItemCallbackBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): ItemSliderCallback {
        return async (item: UIMenuSliderItem, newIndex: number) => {
            await super.toDelegate()(item, newIndex);
        };
    }
}
export class StatsItemCallbackBuilder extends DelegateBuilder {
    add(callback: ItemStatCallback): StatsItemCallbackBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: ItemStatCallback): StatsItemCallbackBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): ItemStatCallback {
        return async (newIndex: number) => {
            await super.toDelegate()(newIndex);
        };
    }
}

export class IndexChangedEventBuilder extends DelegateBuilder {
    add(callback: IndexChangedEvent): IndexChangedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: IndexChangedEvent): IndexChangedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): IndexChangedEvent {
        return async (menu: UIMenu, newIndex: number) => {
            await super.toDelegate()(menu, newIndex);
        };
    }
}

export class ListChangedEventBuilder extends DelegateBuilder {
    add(callback: ListChangedEvent): ListChangedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: ListChangedEvent): ListChangedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): ListChangedEvent {
        return async (menu: UIMenu, listItem: UIMenuListItem, newIndex: number) => {
            await super.toDelegate()(menu, listItem, newIndex);
        };
    }
}
export class SliderChangedEventBuilder extends DelegateBuilder {
    add(callback: SliderChangedEvent): SliderChangedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: SliderChangedEvent): SliderChangedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): SliderChangedEvent {
        return async (menu: UIMenu, sliderItem:UIMenuSliderItem, newIndex: number) => {
            await super.toDelegate()(menu, sliderItem, newIndex);
        };
    }
}
export class ListSelectedEventBuilder extends DelegateBuilder {
    add(callback: ListSelectedEvent): ListSelectedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: ListSelectedEvent): ListSelectedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): ListSelectedEvent {
        return async (menu: UIMenu, listItem:UIMenuListItem, newIndex: number) => {
            await super.toDelegate()(menu, listItem, newIndex);
        };
    }
}
export class CheckboxChangeEventBuilder extends DelegateBuilder {
    add(callback: CheckboxChangeEvent): CheckboxChangeEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: CheckboxChangeEvent): CheckboxChangeEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): CheckboxChangeEvent {
        return async (menu: UIMenu, checkboxItem:UIMenuCheckboxItem, checked: boolean) => {
            await super.toDelegate()(menu, checkboxItem, checked);
        };
    }
}
export class ItemSelectEventBuilder extends DelegateBuilder {
    add(callback: ItemSelectEvent): ItemSelectEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: ItemSelectEvent): ItemSelectEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): ItemSelectEvent {
        return async (menu: UIMenu, item:UIMenuItem, newIndex: number) => {
            await super.toDelegate()(menu, item, newIndex);
        };
    }
}
export class ItemActivatedEventBuilder extends DelegateBuilder {
    add(callback: ItemActivatedEvent): ItemActivatedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: ItemActivatedEvent): ItemActivatedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): ItemActivatedEvent {
        return async (menu: UIMenu, item:UIMenuItem) => {
            await super.toDelegate()(menu, item);
        };
    }
}
export class OnProgressChangedBuilder extends DelegateBuilder {
    add(callback: OnProgressChanged): OnProgressChangedBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: OnProgressChanged): OnProgressChangedBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): OnProgressChanged {
        return async (menu: UIMenu, item: UIMenuProgressItem, newIndex: number) => {
            await super.toDelegate()(menu, item, newIndex);
        };
    }
}
export class OnProgressSelectedBuilder extends DelegateBuilder {
    add(callback: OnProgressSelected): OnProgressSelectedBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: OnProgressSelected): OnProgressSelectedBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): OnProgressSelected {
        return async (menu: UIMenu, item:UIMenuProgressItem, newIndex: number) => {
            await super.toDelegate()(menu, item, newIndex);
        };
    }
}
export class StatItemProgressChangeBuilder extends DelegateBuilder {
    add(callback: StatItemProgressChange): StatItemProgressChangeBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: StatItemProgressChange): StatItemProgressChangeBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): StatItemProgressChange {
        return async (menu: UIMenu, item:UIMenuStatsItem, newIndex: number) => {
            await super.toDelegate()(menu, item, newIndex);
        };
    }
}
export class ColorPanelChangedEventBuilder extends DelegateBuilder {
    add(callback: ColorPanelChangedEvent): ColorPanelChangedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: ColorPanelChangedEvent): ColorPanelChangedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): ColorPanelChangedEvent {
        return async (item: UIMenuItem, panel:UIMenuColorPanel, newIndex: number) => {
            await super.toDelegate()(item, panel, newIndex);
        };
    }
}
export class VehicleColorPickerSelectEventBuilder extends DelegateBuilder {
    add(callback: VehicleColorPickerSelectEvent): VehicleColorPickerSelectEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: VehicleColorPickerSelectEvent): VehicleColorPickerSelectEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): VehicleColorPickerSelectEvent {
        return async (item: UIMenuItem, panel:UIVehicleColourPickerPanel, newIndex: number) => {
            await super.toDelegate()(item, panel, newIndex);
        };
    }
}
export class PercentagePanelChangedEventBuilder extends DelegateBuilder {
    add(callback: PercentagePanelChangedEvent): PercentagePanelChangedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: PercentagePanelChangedEvent): PercentagePanelChangedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): PercentagePanelChangedEvent {
        return async (item: UIMenuItem, panel:UIMenuPercentagePanel, newIndex: number) => {
            await super.toDelegate()(item, panel, newIndex);
        };
    }
}
export class GridPanelChangedEventBuilder extends DelegateBuilder {
    add(callback: GridPanelChangedEvent): GridPanelChangedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: GridPanelChangedEvent): GridPanelChangedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): GridPanelChangedEvent {
        return async (item: UIMenuItem, panel:UIMenuGridPanel, newIndex: Vector2) => {
            await super.toDelegate()(item, panel, newIndex);
        };
    }
}
export class MenuOpenedEventBuilder extends DelegateBuilder {
    add(callback: MenuOpenedEvent): MenuOpenedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: MenuOpenedEvent): MenuOpenedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): MenuOpenedEvent {
        return async (menu: UIMenu, data:any) => {
            await super.toDelegate()(menu, data);
        };
    }
}
export class MenuClosedEventBuilder extends DelegateBuilder {
    add(callback: MenuClosedEvent): MenuClosedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: MenuClosedEvent): MenuClosedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): MenuClosedEvent {
        return async (menu: UIMenu) => {
            await super.toDelegate()(menu);
        };
    }
}
export class InstructionalButtonSelectedEventBuilder extends DelegateBuilder {
    add(callback: InstructionalButtonSelectedEvent): InstructionalButtonSelectedEventBuilder {
        super.add(callback);
        return this;
    }

    remove(callback: InstructionalButtonSelectedEvent): InstructionalButtonSelectedEventBuilder {
        super.remove(callback);
        return this;
    }

    toDelegate(): InstructionalButtonSelectedEvent {
        return async (button: InstructionalButton) => {
            await super.toDelegate()(button);
        };
    }
}
