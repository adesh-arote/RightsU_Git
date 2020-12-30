using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class USPMHGetLabelWiseUsage
    {
        public int MusicTitleCode { get; set; }
        public string RequestID { get; set; }
        public string ShowName { get; set; }
        public string MusicTrackName { get; set; }
        public string Movie_Album { get; set; }
        public string Music_Tag { get; set; }
        public string MusicLanguage { get; set; }
        public string YearOfRelease { get; set; }

    }
}
