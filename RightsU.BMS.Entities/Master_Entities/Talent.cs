using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
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
        public int Talent_Code { get; set; }
        public string Talent_Name { get; set; }
        public string Gender { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual ICollection<Talent_Role> Talent_Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual ICollection<Title_Talent> Title_Talent { get; set; }        
    }
}
