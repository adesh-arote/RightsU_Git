using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class ConsumptionRequestDetails
    {
        public int MusicTitleCode { get; set; }
        public  string RequestedMusicTitle  { get; set; }
        public  string IsValid              { get; set; }
        public  string LabelName            { get; set; }
        public  string MusicMovieAlbum      { get; set; }
        public  string IsApprove            { get; set; }
        public  string Remarks              { get; set; }
        public long MHRequestCode { get; set; } 
        public int TitleCode { get; set; }
        public string Title_Name { get; set; }
        public int EpisodeFrom { get; set; }
        public int EpisodeTo { get; set; }
        public string SpecialInstruction { get; set; }
        public string ProductionHouseRemarks { get; set; }
    }
}
