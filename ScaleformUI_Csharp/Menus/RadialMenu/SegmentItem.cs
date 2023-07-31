namespace ScaleformUI.Radial
{
    public class SegmentItem
    {
        private string label;
        private string description;
        private HudColor color;
        private int textureHeight;
        private int textureWidth;
        private string textureName;
        private string textureDict;
        internal RadialSegment Parent;

        public string Label
        {
            get => label;
            set
            {
                label = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color);
                }
            }
        }
        public string Description
        {
            get => description;
            set
            {
                description = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color);
                }
            }
        }
        public string TextureDict
        {
            get => textureDict;
            set
            {
                textureDict = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color);
                }
            }
        }
        public string TextureName
        {
            get => textureName;
            set
            {
                textureName = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color);
                }
            }
        }
        public int TextureWidth
        {
            get => textureWidth;
            set
            {
                textureWidth = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color);
                }
            }
        }
        public int TextureHeight
        {
            get => textureHeight;
            set
            {
                textureHeight = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color);
                }
            }
        }
        public HudColor Color
        {
            get => color;
            set
            {
                color = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color);
                }
            }
        }

        public SegmentItem(string label, string desc, string txd, string txn, int txwidth, int txheight, HudColor color)
        {
            Label = label;
            Description = desc;
            TextureDict = txd;
            TextureName = txn;
            TextureWidth = txwidth;
            TextureHeight = txheight;
            Color = color;
        }
    }
}
