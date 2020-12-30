using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class USPMHGetCueSheetSongDetails
    {
        public string ShowName { get; set; }
        public int Episode { get; set; }
        public string MusicTrack { get; set; }
        public string MovieAlbum { get; set; }
        public string SongType { get; set; }
        public Nullable<System.TimeSpan> TCIn { get; set; }
        public int TCInFrame { get; set; }
        public Nullable<System.TimeSpan> TCOut { get; set; }
        public int TCOutFrame { get; set; }
        public Nullable<System.TimeSpan> Duration { get; set; }
        public int DurationFrame { get; set; }
        public string ErrorMessage { get; set; }
    }
}
