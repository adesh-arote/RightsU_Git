using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class MusicTrackRequestDetails
    {
        public string RequestedMusicTitleName { get; set; }
        public string ApprovedMusicTitleName { get; set; }
        public string MusicLabelName { get; set; }
        public string MusicMovieAlbumName { get; set; }
        public string CreateMap { get; set; }
        public string Remarks { get; set; }
        public string IsApprove { get; set; }
        public string Singers { get; set; }
        public string StarCasts { get; set; }

    }
}
