namespace ScaleformUI.PauseMenus.Elements.Items
{
    public enum PlayerCardType
    {
        VEHICLE_ITEM = 0,
        PLAYER_BET_ITEM,
        PLAYER_ITEM
    }
    public enum PlayerCardTeam
    {
        GENERIC,
        FRIEND,
        FOE
    }

    public class MMPLayerItem : LobbyItem
    {
        public MMPLayerItem(string label, PlayerCardType type, PlayerCardTeam team) : base()
        {

        }
    }
}
