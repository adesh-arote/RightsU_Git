using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class USPMHMovieAlbumMusicList
    {
        public string RequestID     { get; set;}
        public int RequestCode { get; set; }
        public int CountRequest  { get; set;}
        public string Status        { get; set;}
        public string RequestedBy   { get; set;}
        public Nullable<System.DateTime> RequestDate { get; set; }

    }
}
