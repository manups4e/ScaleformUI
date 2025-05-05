namespace ScaleformUI.Elements
{
    public struct ScaleformLabel
    {
        private readonly string _label;

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

        public string[] SplitLabel
        {
            get
            {
                int stringsNeeded = (_label.Length - 1) / 99 + 1; // division with round up

                String[] outputString = new String[stringsNeeded];
                for (int i = 0; i < stringsNeeded; i++)
                {
                    outputString[i] = _label.Substring(i * 99, MathUtil.Clamp(_label.Substring(i * 99).Length, 0, 99));
                }

                return outputString;
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
            return obj is ScaleformLabel label && this == label;
        }

        public override int GetHashCode()
        {
            return Label.GetHashCode();
        }
    }
}
