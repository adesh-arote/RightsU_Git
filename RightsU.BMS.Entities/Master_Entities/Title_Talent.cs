using Dapper.Contrib.Extensions;
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
    [Dapper.SimpleSave.Table("Title_Talent")]
    public partial class Title_Talent
    {
        [PrimaryKey]
        //[Column("Title_Talent_Code")]
        [JsonProperty(PropertyName = "title_talent_id")]
        public int? Title_Talent_Code { get; set; }

        [ForeignKeyReference(typeof(Title))]
        //[Column("Title_Code")]
        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Title_Code { get; set; }

        [ForeignKeyReference(typeof(Talent))]
        //[Column("Talent_Code")]
        [JsonProperty(PropertyName = "talent_id")]
        public Nullable<int> Talent_Code { get; set; }

        [ForeignKeyReference(typeof(Role))]
        //[Column("Role_Code")]
        [JsonProperty(PropertyName = "role_id")]
        public Nullable<int> Role_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talent talent { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Role role { get; set; }
        
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
    }
}
