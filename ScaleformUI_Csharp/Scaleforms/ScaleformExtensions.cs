using CitizenFX.Core;
using CitizenFX.Core.Native;
using CitizenFX.Core.UI;
using ScaleformUI.Elements;
using System.Drawing;

namespace ScaleformUI.Scaleforms
{
    public class ScaleformWideScreen : INativeValue, IDisposable
    {
        public ScaleformWideScreen(string scaleformID)
        {
            _handle = API.RequestScaleformMovieInstance(scaleformID);
        }

        ~ScaleformWideScreen()
        {
            Dispose();
        }

        public void Dispose()
        {
            if (IsLoaded)
            {
                API.SetScaleformMovieAsNoLongerNeeded(ref _handle);
            }

            GC.SuppressFinalize(this);
        }


        public int Handle
        {
            get { return _handle; }
        }

        private int _handle;

        public override ulong NativeValue
        {
            get
            {
                return (ulong)Handle;
            }
            set
            {
                _handle = unchecked((int)value);
            }
        }

        public bool IsValid
        {
            get
            {
                return Handle != 0;
            }
        }
        public bool IsLoaded
        {
            get
            {
                return API.HasScaleformMovieLoaded(Handle);
            }
        }

        public void CallFunction(string function, params object[] arguments)
        {
            API.BeginScaleformMovieMethod(Handle, function);
            foreach (object argument in arguments)
            {
                switch (argument)
                {
                    case int argInt:
                        API.PushScaleformMovieMethodParameterInt(argInt);
                        break;
                    case string:
                    case char:
                        if (argument.ToString().StartsWith("b_") || argument.ToString().StartsWith("t_"))
                            API.ScaleformMovieMethodAddParamPlayerNameString(argument.ToString());
                        else
                            API.PushScaleformMovieMethodParameterString(argument.ToString());
                        break;
                    case double:
                    case float:
                        API.PushScaleformMovieMethodParameterFloat((float)argument);
                        break;
                    case bool argBool:
                        API.PushScaleformMovieMethodParameterBool(argBool);
                        break;
                    case ScaleformLabel argLabel:
                        API.BeginTextCommandScaleformString(argLabel.Label);
                        API.EndTextCommandScaleformString();
                        break;
                    case ScaleformLiteralString argLiteral:
                        API.ScaleformMovieMethodAddParamTextureNameString_2(argLiteral.LiteralString);
                        break;
                    case SColor color:
                        if (color == default)
                            API.PushScaleformMovieMethodParameterInt(SColor.HUD_None.ArgbValue);
                        else
                            API.PushScaleformMovieMethodParameterInt(color.ArgbValue);
                        break;
                    default:
                        throw new ArgumentException(string.Format("Unknown argument type '{0}' passed to scaleform with handle {1}...", argument.GetType().Name, Handle), "arguments");
                }
            }
            API.EndScaleformMovieMethod();
        }

        private int CallFunctionReturnInternal(string function, params object[] arguments)
        {
            API.BeginScaleformMovieMethod(Handle, function);
            foreach (object argument in arguments)
            {
                switch (argument)
                {
                    case int argInt:
                        API.PushScaleformMovieMethodParameterInt(argInt);
                        break;
                    case string:
                    case char:
                        API.PushScaleformMovieMethodParameterString(argument.ToString());
                        break;
                    case double:
                    case float:
                        API.PushScaleformMovieMethodParameterFloat((float)argument);
                        break;
                    case bool argBool:
                        API.PushScaleformMovieMethodParameterBool(argBool);
                        break;
                    case ScaleformLabel argLabel:
                        API.BeginTextCommandScaleformString(argLabel.Label);
                        API.EndTextCommandScaleformString();
                        break;
                    case ScaleformLiteralString argLiteral:
                        API.ScaleformMovieMethodAddParamTextureNameString_2(argLiteral.LiteralString);
                        break;
                    default:
                        throw new ArgumentException(string.Format("Unknown argument type '{0}' passed to scaleform with handle {1}...", argument.GetType().Name, Handle), "arguments");
                }
            }
            return API.EndScaleformMovieMethodReturnValue();
        }
        public async Task<int> CallFunctionReturnValueInt(string function, params object[] arguments)
        {
            int ret = CallFunctionReturnInternal(function, arguments);
            while (!API.IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            return API.GetScaleformMovieFunctionReturnInt(ret);
        }
        public async Task<bool> CallFunctionReturnValueBool(string function, params object[] arguments)
        {
            int ret = CallFunctionReturnInternal(function, arguments);
            while (!API.IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            return API.GetScaleformMovieMethodReturnValueBool(ret);
        }
        public async Task<string> CallFunctionReturnValueString(string function, params object[] arguments)
        {
            int ret = CallFunctionReturnInternal(function, arguments);
            while (!API.IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            return API.GetScaleformMovieFunctionReturnString(ret);
        }

        public void Render2D()
        {
            API.DrawScaleformMovieFullscreen(Handle, 255, 255, 255, 255, 0);
        }
        public void Render2DScreenSpace(PointF location, PointF size)
        {
            float x = location.X / Screen.Width;
            float y = location.Y / Screen.Height;
            float width = size.X / Screen.Width;
            float height = size.Y / Screen.Height;

            API.DrawScaleformMovie(Handle, x + (width / 2.0f), y + (height / 2.0f), width, height, 255, 255, 255, 255, 0);
        }
        public void Render3D(Vector3 position, Vector3 rotation, Vector3 scale)
        {
            API.DrawScaleformMovie_3dNonAdditive(Handle, position.X, position.Y, position.Z, rotation.X, rotation.Y, rotation.Z, 2.0f, 2.0f, 1.0f, scale.X, scale.Y, scale.Z, 2);
        }
        public void Render3DAdditive(Vector3 position, Vector3 rotation, Vector3 scale)
        {
            API.DrawScaleformMovie_3d(Handle, position.X, position.Y, position.Z, rotation.X, rotation.Y, rotation.Z, 2.0f, 2.0f, 1.0f, scale.X, scale.Y, scale.Z, 2);
        }
    }

    public static class TypeCache<T>
    {
        static TypeCache()
        {
            Type = typeof(T);
            IsSimpleType = true;
            switch (Type.GetTypeCode(Type))
            {
                case TypeCode.Object:
                case TypeCode.DBNull:
                case TypeCode.Empty:
                case TypeCode.DateTime:
                    IsSimpleType = false;
                    break;
            }
        }

        public static bool IsSimpleType { get; }
        public static Type Type { get; }
    }
}
