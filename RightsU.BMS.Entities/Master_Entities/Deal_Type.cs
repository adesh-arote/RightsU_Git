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
    [Table("Deal_Type")]
    public partial class Deal_Type
    {
        public Deal_Type()
        {
            this.roles = new HashSet<Role>();            
            this.programs = new HashSet<Program>();            
        }

        [PrimaryKey]
        [Column("Deal_Type_Code")]
        public int? deal_type_id { get; set; }
        [Column("Deal_Type_Name")]
        public string deal_type_name { get; set; }
        [JsonIgnore]
        public string Is_Default { get; set; }
        [JsonIgnore]
        public string Is_Grid_Required { get; set; }
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
        public string Is_Master_Deal { get; set; }
        [JsonIgnore]
        public Nullable<int> Parent_Code { get; set; }
        [JsonIgnore]
        public string Deal_Or_Title { get; set; }
        [JsonIgnore]
        public Nullable<int> Deal_Title_Mapping_Code { get; set; }
        [SimpleSaveIgnore]        
        [OneToMany]
        [JsonIgnore]
        public virtual ICollection<Role> roles { get; set; }
        
        [SimpleSaveIgnore]
        [OneToMany]
        [JsonIgnore]
        public virtual ICollection<Program> programs { get; set; }        
    }
}
