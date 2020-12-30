using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class USPMHConsumptionRequestList
    {
        public string RequestID { get; set; }
        public string MusicLabel { get; set; }
        public int RequestCode { get; set; }
        public int TitleCode { get; set; }
        public string Title_Name { get; set; }
        public Nullable<int> EpisodeFrom { get; set; }
        public Nullable<int> EpisodeTo { get; set; }
        public Nullable<System.DateTime> TelecastFrom { get; set; }
        public Nullable<System.DateTime> TelecastTo { get; set; }
        public int CountRequest { get; set; }
        public int ApprovedRequest { get; set; }
        public string Status { get; set; }
        public string Login_Name { get; set; }
        public Nullable<System.DateTime> RequestDate { get; set; }
        public string ChannelName { get; set; }
    }
}
