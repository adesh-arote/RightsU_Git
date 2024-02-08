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
    [Table("Country")]
    public partial class Country
    {
        public Country()
        {
            this.country_language = new HashSet<CountryLanguage>();
        } 

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]        
        [JsonProperty(PropertyName = "country_id")]
        public int? Country_Code { get; set; }
                
        [JsonProperty(PropertyName = "country_name")]
        public string Country_Name { get; set; }

        [JsonProperty(PropertyName = "is_domestic_territory")]
        public string Is_Domestic_Territory { get; set; }

        [JsonProperty(PropertyName = "is_theatrical_territory")]
        public string Is_Theatrical_Territory { get; set; }
        [JsonIgnore]
        public string Is_Ref_Acq { get; set; }
        [JsonIgnore]
        public string Is_Ref_Syn { get; set; }

        [JsonProperty(PropertyName = "parent_country_id")]
        public Nullable<int> Parent_Country_Code { get; set; }

        [JsonIgnore]
        public string Applicable_For_Asrun_Schedule { get; set; }
        [JsonIgnore]
        public System.DateTime Inserted_On { get; set; }
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


        [OneToMany]
        public ICollection<CountryLanguage> country_language { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Country parent_country { get; set; }
    }
}
