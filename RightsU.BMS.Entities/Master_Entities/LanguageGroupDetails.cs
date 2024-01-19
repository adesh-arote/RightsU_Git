using Newtonsoft.Json;
using System;
using Dapper;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Language_Group_Details")]
    public class LanguageGroupDetails
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "language_group_details_code")]
        public int ? Language_Group_Details_Code { get; set; }

        [ForeignKeyReference(typeof(LanguageGroup))]
        [JsonProperty(PropertyName = "language_group_code")]
        public int Language_Group_Code { get; set; }

        [ForeignKeyReference(typeof(Language))]
        [JsonProperty(PropertyName = "language_code")]
        public int Language_Code { get; set; }

        //[SimpleLoadIgnore]
        [Column("Language_Code")]
        [SimpleSaveIgnore]
        [ManyToOne]
        public Language Language { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [OneToOne]
        [JsonIgnore]
        public LanguageGroup LanguageGroup { get; set; }
    }
}
