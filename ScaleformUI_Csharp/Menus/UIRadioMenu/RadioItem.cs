namespace ScaleformUI.Radio
{
    public class RadioItem
    {
        public UIRadioMenu Parent { get; internal set; }
        public string TextureDictionary { get; set; }
        public string TextureName { get; set; }
        public string StationName { get; set; }
        public string Artist { get; set; }
        public string Track { get; set; }

        public bool Selected { get; internal set; }

        public RadioItem(string station, string artist, string track, string txd, string txn)
        {
            TextureDictionary = txd;
            TextureName = txn;
            StationName = station;
            Artist = artist;
            Track = track;
        }
    }
}