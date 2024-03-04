using CitizenFX.Core;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public class FakeBlip
    {
        public int Sprite;
        public Vector3 Position;
        public float Scale = 0;
        public BlipColor Color = BlipColor.White;
        public FakeBlip() { }
        public FakeBlip(int sprite, Vector3 position)
        {
            Sprite = sprite;
            Position = position;
        }
        public FakeBlip(BlipSprite sprite, Vector3 position)
        {
            Sprite = (int)sprite;
            Position = position;
        }
    }
}
