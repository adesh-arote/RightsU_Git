using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Channel")]
    public class Channel
    {
        public Channel()
        {
            this.country_details = new HashSet<ChannelTerritory>();
        }

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "channel_id")]
        public int ? Channel_Code { get; set; }

        [JsonProperty(PropertyName = "channel_name")]
        public string Channel_Name { get; set; }
        [JsonIgnore]
        public string Channel_Id { get; set; }
        [JsonIgnore]
        public Nullable<int> Genres_Code { get; set; }

        [ForeignKeyReference(typeof(Entity))]
        [JsonProperty(PropertyName = "entity_id")]
        public Nullable<int> Entity_Code { get; set; }

        [ForeignKeyReference(typeof(Entity))]
        [ManyToOne]
        [Column("Entity_Code")]
        [SimpleSaveIgnore]
        public virtual Entity entity_details { get; set; }

        [JsonProperty(PropertyName = "entity_type")]
        public string Entity_Type { get; set; }

        [JsonProperty(PropertyName = "schedule_source_filePath")]
        public string Schedule_Source_FilePath { get; set; }

        [JsonProperty(PropertyName = "bv_channel_id")]
        public Nullable<int> BV_Channel_Code { get; set; }

        [JsonIgnore]
        public string AsRun_Source_FilePath { get; set; }

        [JsonIgnore]
        public string HouseID_Prefix { get; set; }

        [JsonIgnore]
        public int HouseID_Digits_AfterPrefix { get; set; }

        [JsonIgnore]
        public string HouseIdRange_From { get; set; }

        [JsonIgnore]
        public string HouseIdRange_To { get; set; }

        [JsonProperty(PropertyName = "offsetTime_schedule")]
        public string OffsetTime_Schedule { get; set; }

        [JsonProperty(PropertyName = "offsetTime_asRun")]
        public string OffsetTime_AsRun { get; set; }

        [JsonProperty(PropertyName = "schedule_source_filePath_pkg")]
        public string Schedule_Source_FilePath_Pkg { get; set; }

        [JsonIgnore]
        public string IsUseForAsRun { get; set; }

        [JsonIgnore]
        public DateTime? Inserted_On  { get; set; }

        [JsonIgnore]
        public int Inserted_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonIgnore]
        public Nullable<int> Order_For_schedule { get; set; }

        [JsonIgnore]
        public Nullable<int> Channel_Group { get; set; }

        [JsonIgnore]
        public Nullable<int> Channel_Format_Code { get; set; }

        [JsonIgnore]
        public string Is_Parent_Child { get; set; }

        [JsonIgnore]
        public Nullable<int> Parent_Channel_Code { get; set; }

        [JsonIgnore]
        public Nullable<int> Ref_Channel_Key { get; set; }

        [JsonIgnore]
        public Nullable<int> Ref_Station_Key { get; set; }

        [JsonIgnore]
        public Nullable<int> Channel_Category_Code { get; set; }

        [JsonIgnore]
        public string Is_Get { get; set; }

        [JsonIgnore]
        public string Is_Put { get; set; }

        [OneToMany]
        public ICollection<ChannelTerritory> country_details { get; set; }
    }
}
