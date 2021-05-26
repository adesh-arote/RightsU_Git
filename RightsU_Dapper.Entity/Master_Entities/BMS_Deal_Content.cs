using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("BMS_Deal_Content")]
    public partial class BMS_Deal_Content
    {
        public BMS_Deal_Content()
        {
            this.BMS_Deal_Content_Rights = new HashSet<BMS_Deal_Content_Rights>();
        }
        [PrimaryKey]
        public int? BMS_Deal_Content_Code { get; set; }
        [ForeignKeyReference(typeof(BMS_Deal))]
        public Nullable<int> BMS_Deal_Code { get; set; }
        public Nullable<decimal> BMS_Deal_Ref_Key { get; set; }
        public Nullable<decimal> BMS_Deal_Content_Ref_Key { get; set; }
        [ForeignKeyReference(typeof(BMS_Asset))]

        public Nullable<int> BMS_Asset_Code { get; set; }
        public Nullable<decimal> BMS_Asset_Ref_Key { get; set; }
        public string Asset_Type { get; set; }
        public string Title { get; set; }
        public Nullable<System.DateTime> Start_Date { get; set; }
        public Nullable<System.DateTime> End_Date { get; set; }
        public Nullable<System.DateTime> Request_Time { get; set; }
        public Nullable<System.DateTime> Response_Time { get; set; }
        public string Record_Status { get; set; }
        public string Error_Description { get; set; }
        public string Is_Archived { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public int Episode_No { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual BMS_Deal BMS_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<BMS_Deal_Content_Rights> BMS_Deal_Content_Rights { get; set; }
    }
}
