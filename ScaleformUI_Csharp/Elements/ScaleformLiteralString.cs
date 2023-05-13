namespace ScaleformUI.Elements
{
    public struct ScaleformLiteralString
    {
        private readonly string _literalString;

        public ScaleformLiteralString(string literalString)
        {
            _literalString = literalString;
        }

        public string LiteralString
        {
            get
            {
                return _literalString;
            }
        }

        public static implicit operator ScaleformLiteralString(string literalString)
        {
            return new ScaleformLiteralString(literalString);
        }

        public static bool operator ==(ScaleformLiteralString a, ScaleformLiteralString b)
        {
            return a.LiteralString == b.LiteralString;
        }

        public static bool operator !=(ScaleformLiteralString a, ScaleformLiteralString b)
        {
            return a.LiteralString != b.LiteralString;
        }

        public override bool Equals(object obj)
        {
            return obj is ScaleformLiteralString literal && this == literal;
        }

        public override int GetHashCode()
        {
            return LiteralString.GetHashCode();
        }
    }
}
