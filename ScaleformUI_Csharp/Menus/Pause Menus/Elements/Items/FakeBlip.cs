using CitizenFX.Core;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public class FakeBlip
    {
        public int Sprite;
        public Vector3 Position;
        public FakeBlip() { }
        public FakeBlip(int sprite, Vector3 position)
        {
            Sprite = sprite;
            Position = position;
        }
    }
}
