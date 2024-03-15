using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace RightsU.API.Entities
{
    [Table("Language_Group")]
    public partial class LanguageGroup
    {
        public LanguageGroup()
        {
            this.languagegroup_details = new HashSet<LanguageGroupDetails>();
        }
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "language_group_id")]
        public int ? Language_Group_Code { get; set; }

        [JsonProperty(PropertyName = "language_group_name")]
        public string Language_Group_Name { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        //[SimpleSaveIgnore]
        [OneToMany]
        public ICollection< LanguageGroupDetails> languagegroup_details { get; set; }

    }
}
