using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;

    public partial class USPMHRequistionTrackList_Result
    {
        public int MHRequestDetailsCode { get; set; }
        public int MusicTitleCode { get; set; }
        public int MusicLabelCode { get; set; }
        public int MusicAlbumCode { get; set; }
        public string RequestedMusicTitleName { get; set; }
        public string MusicLabelName { get; set; }
        public string MusicMovieAlbumName { get; set; }
        public string Singers { get; set; }
        public string StarCasts { get; set; }
        public string ApprovedMusicTitleName { get; set; }
        public string CreateMap { get; set; }
        public string IsApprove { get; set; }
        public string Remarks { get; set; }
        public int MHRequestStatusCode { get; set; }
    }
}
