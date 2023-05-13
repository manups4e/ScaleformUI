namespace ScaleformUI.Elements
{
    public class ScaleformLiteralString
    {
        private string _literalString;

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
            return obj is ScaleformLiteralString && this == (ScaleformLiteralString)obj;
        }

        public override int GetHashCode()
        {
            return LiteralString.GetHashCode();
        }
    }
}
