using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Role")]
    public partial class Role
    {
        public Role()
        {
            this.Talent_Role = new HashSet<Talent_Role>();
            this.Title_Talent = new HashSet<Title_Talent>();            
        }

        [PrimaryKey]
        public int Role_Code { get; set; }
        public string Role_Name { get; set; }
        public string Role_Type { get; set; }
        public string Is_Rate_Card { get; set; }
        public Nullable<System.DateTime> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [ForeignKeyReference(typeof(Deal_Type))]
        public Nullable<int> Deal_Type_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Deal_Type Deal_Type { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual ICollection<Talent_Role> Talent_Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual ICollection<Title_Talent> Title_Talent { get; set; }        
    }
}
