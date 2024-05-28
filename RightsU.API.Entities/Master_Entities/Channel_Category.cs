using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;

namespace RightsU.API.Entities
{
    [Table("Channel_Category")]
    public class  Channel_Category
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "channel_category_id")]
        public int? Channel_Category_Code { get; set; }

        [JsonProperty(PropertyName = "channel_category_name")]
        public string Channel_Category_Name { get; set; }

        [JsonProperty(PropertyName = "type")]
        public string Type { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }

        [JsonIgnore]
         public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
    }
}
