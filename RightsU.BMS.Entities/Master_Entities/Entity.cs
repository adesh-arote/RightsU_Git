using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Deal_Tag")]

    public partial class Entity
    {
        [PrimaryKey]
        [Column("Entity_Code")]
        public int? entity_id { get; set; }
        [Column("Entity_Name")]

        public string entity_name { get; set; }
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
        [JsonIgnore]
        public string Is_Active { get; set; }
        [JsonIgnore]
        public string Logo_Path { get; set; }
        [JsonIgnore]
        public string Logo_Name { get; set; }
        [Column("ParentEntityCode")]

        public int parentEntityCode { get; set; }

        [Column("Ref_Entity_Key")]
        public int ref_entity_key { get; set; }
    }
}
