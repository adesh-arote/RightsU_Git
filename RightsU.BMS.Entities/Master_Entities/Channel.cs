using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Channel")]
    public class Channel
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "channel_id")]
        public int? Channel_Code { get; set; }

        [JsonProperty(PropertyName = "channel_name")]
        public string Channel_Name { get; set; }
        public string Channel_Id { get; set; }
        public Nullable<int> Genres_Code { get; set; }
        public Nullable<int> Entity_Code { get; set; }
        public string Entity_Type { get; set; }
        public string Schedule_Source_FilePath { get; set; }
        public Nullable<int> BV_Channel_Code { get; set; }
        public string AsRun_Source_FilePath { get; set; }
        public string HouseID_Prefix { get; set; }
        public int HouseID_Digits_AfterPrefix { get; set; }
        public string HouseIdRange_From { get; set; }
        public string HouseIdRange_To { get; set; }
        public string OffsetTime_Schedule { get; set; }
        public string OffsetTime_AsRun { get; set; }
        public string Schedule_Source_FilePath_Pkg { get; set; }
        public string IsUseForAsRun { get; set; }
        public DateTime? Inserted_On  { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Order_For_schedule { get; set; }
        public Nullable<int> Channel_Group { get; set; }
        public Nullable<int> Channel_Format_Code { get; set; }
        public string Is_Parent_Child { get; set; }
        public Nullable<int> Parent_Channel_Code { get; set; }
        public Nullable<int> Ref_Channel_Key { get; set; }
        public Nullable<int> Ref_Station_Key { get; set; }
        public Nullable<int> Channel_Category_Code { get; set; }
        public string Is_Get { get; set; }
        public string Is_Put { get; set; }
    }
}
