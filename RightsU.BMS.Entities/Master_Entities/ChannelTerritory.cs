using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Channel_Territory")]
    public partial class ChannelTerritory
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "channel_territory_id")]
        public int? Channel_Territory_Code { get; set; }

        [ForeignKeyReference(typeof(Channel))]
        [JsonProperty(PropertyName = "channel_id")]
        public Nullable<int> Channel_Code { get; set; }

        [ForeignKeyReference(typeof(Country))]
        [JsonProperty(PropertyName = "country_id")]
        public Nullable<int> Country_Code { get; set; }
    }
}
