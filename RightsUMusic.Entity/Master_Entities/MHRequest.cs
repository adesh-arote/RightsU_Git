using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("MHRequest")]
    public partial class MHRequest
    {
        public MHRequest()
        {
            this.MHRequestDetails = new HashSet<MHRequestDetail>();
            
        }
        [PrimaryKey]
        public long? MHRequestCode { get; set; }
        public Nullable<int> MHRequestTypeCode { get; set; }
        public string RequestID { get; set; }
        public Nullable<int> VendorCode { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> TitleCode { get; set; }
        public Nullable<int> EpisodeFrom { get; set; }
        public Nullable<int> EpisodeTo { get; set; }
        public Nullable<System.DateTime> TelecastFrom { get; set; }
        public Nullable<System.DateTime> TelecastTo { get; set; }
        public Nullable<int> UsersCode { get; set; }
        public string Remarks { get; set; }
        public Nullable<System.DateTime> RequestedDate { get; set; }
        public string SpecialInstruction { get; set; }
        public Nullable<int> MHRequestStatusCode { get; set; }
        public Nullable<System.DateTime> ApprovedOn { get; set; }
        public Nullable<int> ApprovedBy { get; set; }
        public Nullable<int> ChannelCode { get; set; }

        //public virtual MHRequestStatu MHRequestStatu { get; set; }
        //public virtual MHRequestType MHRequestType { get; set; }
        //public virtual Vendor Vendor { get; set; }
        [OneToMany]
        public virtual ICollection<MHRequestDetail> MHRequestDetails { get; set; }
    }
}
