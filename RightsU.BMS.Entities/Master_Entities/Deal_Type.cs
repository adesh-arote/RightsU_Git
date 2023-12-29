using Dapper.SimpleLoad;
using Dapper.SimpleSave;
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
            this.Roles = new HashSet<Role>();
            this.Titles = new HashSet<Title>();
            this.Programs = new HashSet<Program>();            
        }

        [PrimaryKey]
        public int Deal_Type_Code { get; set; }
        public string Deal_Type_Name { get; set; }
        public string Is_Default { get; set; }
        public string Is_Grid_Required { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Is_Master_Deal { get; set; }
        public Nullable<int> Parent_Code { get; set; }
        public string Deal_Or_Title { get; set; }
        public Nullable<int> Deal_Title_Mapping_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual ICollection<Role> Roles { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual ICollection<Title> Titles { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual ICollection<Program> Programs { get; set; }        
    }
}
