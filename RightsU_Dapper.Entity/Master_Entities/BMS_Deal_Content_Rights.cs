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

    [Table("BMS_Deal_Content_Rights")]
    public partial class BMS_Deal_Content_Rights
    {
        [PrimaryKey]
        public int? BMS_Deal_Content_Rights_Code { get; set; }
        [ForeignKeyReference(typeof(BMS_Deal_Content))]
        public Nullable<int> BMS_Deal_Content_Code { get; set; }
        public Nullable<decimal> BMS_Deal_Content_Ref_Key { get; set; }
        public Nullable<int> RU_Channel_Code { get; set; }
        public Nullable<decimal> BMS_Deal_Content_Rights_Ref_Key { get; set; }
        public Nullable<int> BMS_Station_Code { get; set; }
        public Nullable<int> RU_Right_Rule_Code { get; set; }
        public Nullable<decimal> BMS_Right_Rule_Ref_Key { get; set; }
        [ForeignKeyReference(typeof(SAP_WBS))]
        public Nullable<int> SAP_WBS_Code { get; set; }
        public Nullable<decimal> SAP_WBS_Ref_Key { get; set; }
        [ForeignKeyReference(typeof(Vendor))]
        public Nullable<int> BMS_Asset_Code { get; set; }
        public Nullable<decimal> BMS_Asset_Ref_Key { get; set; }
        public string Asset_Type { get; set; }
        public string Title { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public int Episode_No { get; set; }
        public Nullable<decimal> License_Fees { get; set; }
        public Nullable<int> Total_Runs { get; set; }
        public Nullable<int> Utilised_Run { get; set; }
        public Nullable<System.DateTime> Start_Date { get; set; }
        public Nullable<System.DateTime> End_Date { get; set; }
        public Nullable<System.DateTime> Blackout_From_1 { get; set; }
        public Nullable<System.DateTime> Blackout_To_1 { get; set; }
        public Nullable<System.DateTime> Blackout_From_2 { get; set; }
        public Nullable<System.DateTime> Blackout_To_2 { get; set; }
        public Nullable<System.DateTime> Blackout_From_3 { get; set; }
        public Nullable<System.DateTime> Blackout_To_3 { get; set; }
        public Nullable<System.DateTime> Request_Time { get; set; }
        public Nullable<System.DateTime> Response_Time { get; set; }
        public string Record_Status { get; set; }
        public string Error_Description { get; set; }
        public string Is_Archived { get; set; }
        public Nullable<int> YearWise_No { get; set; }
        public Nullable<int> Min_Runs { get; set; }
        public Nullable<int> Max_Runs { get; set; }
        public Nullable<int> Acq_Deal_Rights_Code { get; set; }
        public Nullable<int> Acq_Deal_Run_Code { get; set; }
        public Nullable<int> Acq_Deal_Run_Channel_Code { get; set; }
        public Nullable<int> Acq_Deal_Run_YearWise_Run_Code { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual BMS_Deal_Content BMS_Deal_Content { get; set; }
    }
}
