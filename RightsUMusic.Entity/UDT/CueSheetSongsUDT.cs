using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    
    public class CueSheetSongsUDT
    {
        public int ExcelLineNo          { get; set; }
        public string TitleName         { get; set; }
        public string EpisodeNo         { get; set; }
        public string MusicTitleName    { get; set; }
        public string MovieAlbum        { get; set; }
        public string SongType          { get; set; }
        public string TCIN              { get; set; }
        public string TCINFrame         { get; set; }
        public string TCOUT             { get; set; }
        public string TCOUTFrame        { get; set; }
        public string Duration          { get; set; }
        public string DurationFrame     { get; set; }
        
    }
}
