using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Entity")]

    public partial class Entity
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "entity_id")]
        public int? Entity_Code { get; set; }
        [JsonProperty(PropertyName = "entity_name")]
        public string Entity_Name { get; set; }
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
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
        [JsonIgnore]
        public string Logo_Path { get; set; }
        [JsonIgnore]
        public string Logo_Name { get; set; }
        [JsonProperty(PropertyName = "parentEntityCode")]

        public int ParentEntityCode { get; set; }

      
        [JsonProperty(PropertyName = "ref_entity_key")]
        public int Ref_Entity_Key { get; set; }
    }
}
