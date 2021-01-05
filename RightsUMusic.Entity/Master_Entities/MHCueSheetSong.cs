using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("MHCueSheetSong")]
    public partial class MHCueSheetSong
    {
        [PrimaryKey]
        public long? MHCueSheetSongCode { get; set; }
        [ForeignKeyReference(typeof(MHCueSheet))]
        public int MHCueSheetCode { get; set; }
        public string TitleName { get; set; }
        public int EpisodeNo { get; set; }
        public string MusicTrackName { get; set; }
        public TimeSpan FromTime { get; set; }
        public int FromFrame { get; set; }
        public TimeSpan ToTime { get; set; }
        public int ToFrame { get; set; }
        public TimeSpan DurationTime { get; set; }
        public int DurationFrame { get; set; }
        public int ExcelLineNo { get; set; }
        public string RecordStatus { get; set; }
        public string ErrorMessage { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public int TitleCode { get; set; }
       // public int TitleContentCode { get; set; }
        public int MusicTitleCode { get; set; }
        public string IsApprove { get; set; }
        public string SongType { get; set; }
        [ForeignKeyReference(typeof(MHRequest))]
        public long? MHRequestCode { get; set; }
        public int MHMusicSongTypeCode { get; set; }
        public string MovieAlbum { get; set; }
    }
}
