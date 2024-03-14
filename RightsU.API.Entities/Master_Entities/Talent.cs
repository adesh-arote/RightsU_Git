using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using RightsU.API.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Talent")]
    public partial class Talent
    {
        public Talent()
        {
            this.Talent_Role = new HashSet<Talent_Role>();
            this.Title_Talent = new HashSet<Title_Talent>();            
        }

        [PrimaryKey]
        //[Column("Talent_Code")]
        [JsonProperty(PropertyName = "talent_id")]
        public int? Talent_Code { get; set; }

        //[Column("Talent_Name")]
        [JsonProperty(PropertyName = "talent_name")]
        public string Talent_Name { get; set; }

        [JsonIgnore]
        public string Gender { get; set; }
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

        [OneToMany]
        [JsonIgnore]
        public virtual ICollection<Talent_Role> Talent_Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public virtual ICollection<Title_Talent> Title_Talent { get; set; }        
    }
    
}
