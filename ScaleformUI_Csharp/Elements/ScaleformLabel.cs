namespace ScaleformUI.Elements
{
    public class ScaleformLabel
    {
        private string _label;

        public ScaleformLabel(string label)
        {
            _label = label;
        }

        public string Label
        {
            get
            {
                return _label;
            }
        }

        public static implicit operator ScaleformLabel(string label)
        {
            return new ScaleformLabel(label);
        }

        public static bool operator ==(ScaleformLabel a, ScaleformLabel b)
        {
            return a.Label == b.Label;
        }

        public static bool operator !=(ScaleformLabel a, ScaleformLabel b)
        {
            return a.Label != b.Label;
        }

        public override bool Equals(object obj)
        {
            return obj is ScaleformLabel && this == (ScaleformLabel)obj;
        }

        public override int GetHashCode()
        {
            return Label.GetHashCode();
        }
    }
}
