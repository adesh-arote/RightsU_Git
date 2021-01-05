using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class USPMHSearchMusicTrack
    {
        public int Music_Title_Code { get; set; }
        public int Music_Album_Code { get; set; }
        public string MusicTrack { get; set; }
        public string Movie { get; set; }
        public string Genre { get; set; }
        public string Tag { get; set; }
        public string MusicLabel { get; set; }
        //public string Talent { get; set; }
        public string StarCast { get; set; }
        public string Singers { get; set; }
        public string MusicComposer { get; set; }
        public string MusicLanguage { get; set; }

    }

    public class MusicTrackInput
    {
        public string MusicLabelCode { get; set; }
        public string MusicTrack { get; set; }
        public string MovieName { get; set; }
        public string GenreCode { get; set; }
        public string TalentName { get; set; }
        public string Tag { get; set; }
        public int MHPlayListCode { get; set; }
        public string PagingRequired { get; set; }
        public int PageSize { get; set; }
        public int PageNo { get; set; }
        public int ChannelCode { get; set; }
        public int TitleCode { get; set; }
        public string MusicLanguageCode { get; set; }
    }
}
