using ScaleformUI.Elements;

namespace ScaleformUI.Radial
{
    public class SegmentItem
    {
        private string label;
        private string description;
        private SColor color;
        private int textureHeight;
        private int textureWidth;
        private string textureName;
        private string textureDict;
        internal RadialSegment Parent;
        internal int qtty = 0;
        internal int max = 0;

        public string Label
        {
            get => label;
            set
            {
                label = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color, qtty, max);
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
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color, qtty, max);
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
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color, qtty, max);
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
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color, qtty, max);
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
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color, qtty, max);
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
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color, qtty, max);
                }
            }
        }
        public SColor Color
        {
            get => color;
            set
            {
                color = value;
                if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
                {
                    Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color, qtty, max);
                }
            }
        }

        /// <summary>
        /// Set the quantity of this item, if max == 0 then the quantity will be centered
        /// </summary>
        /// <param name="qtty"></param>
        /// <param name="max"></param>
        public void SetQuantity(int qtty, int max = 0)
        {
            this.qtty = qtty;
            this.max = max;
            if (Parent != null && Parent.Parent != null && Parent.Parent.Visible)
            {
                Main.radialMenu.CallFunction("UPDATE_SUBITEM", Parent.index, Parent.Items.IndexOf(this), label, description, textureName, textureDict, textureHeight, textureWidth, color, qtty, max);
            }
        }

        public SegmentItem(string label, string desc, string txd, string txn, int txwidth, int txheight, SColor color)
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
