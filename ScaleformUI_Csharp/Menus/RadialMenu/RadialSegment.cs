namespace ScaleformUI.Radial
{
    public class RadialSegment
    {
        public List<SegmentItem> Items { get; private set; }
        public RadialMenu Parent;
        public bool Selected;
        private int currentSelection = 0;
        internal int index;
        public int Index => index;

        public IndexChanged OnIndexChanged;

        public RadialSegment(int idx)
        {
            index = idx;
            Items = new List<SegmentItem>();
        }

        public void AddItem(SegmentItem item)
        {
            item.Parent = this;
            Items.Add(item);
            if (Parent != null && Parent.Visible)
            {
                Main.radialMenu.CallFunction("ADD_ITEM", item.Label, item.Description, item.TextureDict, item.TextureName, item.TextureWidth, item.TextureHeight, item.Color, item.qtty, item.max);
            }
        }

        public void RemoveItemAt(int index)
        {
            Items.RemoveAt(index);
        }
        public void RemoveItem(SegmentItem item)
        {
            if (Items.Contains(item))
            {
                RemoveItemAt(Items.IndexOf(item));
            }
        }

        internal async Task<int> CycleItems(int direction)
        {
            currentSelection = await Main.radialMenu.CallFunctionReturnValueInt("SET_INPUT_EVENT", direction == -1 ? 10 : 11);
            OnIndexChanged?.Invoke(this, currentSelection);
            return currentSelection;
        }

        public int CurrentSelection
        {
            get => currentSelection;
            set
            {
                currentSelection = value;
            }
        }
    }
}
