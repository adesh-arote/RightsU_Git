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
    [Table("Vendor_Contacts")]
    public partial class Vendor_Contacts
    {        
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "party_contacts_id")]
        public int? Vendor_Contacts_Code { get; set; }

        [ForeignKeyReference(typeof(Party))]
        [JsonProperty(PropertyName = "party_id")]
        public Nullable<int> Vendor_Code { get; set; }

        [JsonProperty(PropertyName = "contact_name")]
        public string Contact_Name { get; set; }

        [JsonProperty(PropertyName = "phone_no")]
        public string Phone_No { get; set; }

        [JsonProperty(PropertyName = "email")]
        public string Email { get; set; }

        [JsonProperty(PropertyName = "department")]
        public string Department { get; set; }
    }
}
