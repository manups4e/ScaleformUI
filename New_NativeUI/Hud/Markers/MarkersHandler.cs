using CitizenFX.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static CitizenFX.Core.Native.API;

namespace NativeUI
{
	public class MarkersHandler : BaseScript
	{

		private static List<Marker> _markerList = new List<Marker>();

		public MarkersHandler()
		{
			Tick += MainHandler;
		}

		public async Task MainHandler()
		{
			if (_markerList.Count == 0) return;

			for(int i=0; i<FilterMarkers().Count; i++)
				FilterMarkers()[i].Draw();
			await Task.FromResult(0);
		}

		private List<Marker> FilterMarkers() => _markerList.Where(x => MenuPool.PlayerPed.IsInRangeOf(x.Position, x.Distance)).ToList();

		/// <summary>
		/// Adds a marker to the list
		/// </summary>
		/// <param name="marker"></param>
		public static void AddMarker(Marker marker)
		{
			if (!_markerList.Contains(marker))
				_markerList.Add(marker);
		}

		/// <summary>
		/// Removes the marker from the list
		/// </summary>
		/// <param name="marker"></param>
		public static void RemoveMarker(Marker marker)
		{
			if (_markerList.Contains(marker))
				_markerList.Remove(marker);
		}
	}
}
