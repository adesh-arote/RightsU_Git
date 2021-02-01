using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public class USPMHMovieAlbumMusicDetailsList
    {
        public string RequestID { get; set; }
        public string RequestedMusicTitleName { get; set; }
        public string ApprovedMusicTitleName { get; set; }
        public string MusicLabelName { get; set; }
        public string MusicAlbum { get; set; }
        public string MovieAlbum { get; set; }
        public string CreateMap { get; set; }
        public string Status { get; set; }
        public string RequestedBy { get; set; }
        public Nullable<System.DateTime> RequestDate { get; set; }
        public string Remarks { get; set; }
    }
}
