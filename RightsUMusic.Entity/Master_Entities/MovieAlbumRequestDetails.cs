using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class MovieAlbumRequestDetails
    {
        public string RequestedMovieAlbumName { get; set; }
        public string ApprovedMovieAlbumName { get; set; }
        public string MovieAlbum { get; set; }
        public string CreateMap { get; set; }
        public string Remarks { get; set; }
        public string IsApprove { get; set; }
    }
}
