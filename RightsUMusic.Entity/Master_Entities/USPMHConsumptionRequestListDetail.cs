using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public class USPMHConsumptionRequestListDetail
    {
        public string RequestID { get; set; }
        public string Title_Name { get; set; }
        public Nullable<int> EpisodeFrom { get; set; }
        public Nullable<int> EpisodeTo { get; set; }
        public Nullable<System.DateTime> TelecastFrom { get; set; }
        public Nullable<System.DateTime> TelecastTo { get; set; }
        public string Status { get; set; }
        public string Login_Name { get; set; }
        public string RequestDate { get; set; }
        public string ChannelName { get; set; }
        public string Music_Title { get; set; }
        public string MusicMovieAlbum { get; set; }
        public string LabelName { get; set; }
        public string Remarks { get; set; }
    }
}
