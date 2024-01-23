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
    [Table("Vendor_Role")]
    public partial class Vendor_Role
    {
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]        
        [JsonProperty(PropertyName = "party_role_id")]
        public int? Vendor_Role_Code { get; set; }

        [ForeignKeyReference(typeof(Party))]        
        [JsonProperty(PropertyName = "party_id")]
        public Nullable<int> Vendor_Code { get; set; }

        [ForeignKeyReference(typeof(Role))]
        [JsonProperty(PropertyName = "role_id")]
        public Nullable<int> Role_Code { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [SimpleSaveIgnore]                
        [ManyToOne]
        [Column("Role_Code")]
        public virtual Role role { get; set; }
    }
}
