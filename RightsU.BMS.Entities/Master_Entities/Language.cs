using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Language")]
    public partial class Language
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "language_code")]
        public int? Language_Code { get; set; }

        [JsonProperty(PropertyName = "language_name")]
        public string Language_Name { get; set; }

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
        //[JsonIgnore]

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [OneToMany]
        [JsonIgnore]
        public ICollection<LanguageGroupDetails> LanguageGroupDetails { get; set; }

    }
}
