using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Language")]
    public partial class Language
    {
        public Language()
        {
            this.Title_Languages = new HashSet<Title>();
            this.Original_Languages = new HashSet<Title>();            
        }

        [PrimaryKey]
        public int Language_Code { get; set; }
        public string Language_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [SimpleSaveIgnore]
        //[SimpleLoadIgnore]
        public virtual ICollection<Title> Title_Languages { get; set; }
        [SimpleSaveIgnore]
        //[SimpleLoadIgnore]
        public virtual ICollection<Title> Original_Languages { get; set; }        
    }
}
