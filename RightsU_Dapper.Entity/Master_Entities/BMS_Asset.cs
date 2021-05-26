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

    [Table("BMS_Asset")]
    public partial class BMS_Asset
    {
        [PrimaryKey]
        public int? BMS_Asset_Code { get; set; }
        [ForeignKeyReference(typeof(BMS_Deal))]
        public Nullable<int> BMS_Deal_Code { get; set; }
        public Nullable<decimal> BMS_Asset_Ref_Key { get; set; }
        public Nullable<System.TimeSpan> Duration { get; set; }
        public Nullable<int> RU_Title_Code { get; set; }
        public Nullable<int> Episode_No { get; set; }
        public string Title { get; set; }
        public string Title_Listing { get; set; }
        public Nullable<int> Language_Code { get; set; }
        public Nullable<int> Ref_Language_Key { get; set; }
        public Nullable<int> Ref_BMS_ProgramCategroy { get; set; }
        public string Episode_Title { get; set; }
        public string Episode_Season { get; set; }
        public string Episode_Number { get; set; }
        public string Synopsis { get; set; }
        public Nullable<bool> Is_Archived { get; set; }
        public Nullable<System.DateTime> Request_Time { get; set; }
        public Nullable<System.DateTime> Response_Time { get; set; }
        public string Record_Status { get; set; }
        public string Error_Description { get; set; }
        public Nullable<int> RU_ProgramCategory_Code { get; set; }
        public string IS_Consider { get; set; }
    }
}
