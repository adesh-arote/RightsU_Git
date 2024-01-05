using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Country")]
    public partial class Country
    {
        public Country()
        {
            this.Title_Country = new HashSet<Title_Country>();            
        }
        
        [PrimaryKey]
        public int? Country_Code { get; set; }
        public string Country_Name { get; set; }
        public string Is_Domestic_Territory { get; set; }
        public string Is_Theatrical_Territory { get; set; }
        public string Is_Ref_Acq { get; set; }
        public string Is_Ref_Syn { get; set; }
        public Nullable<int> Parent_Country_Code { get; set; }
        public string Applicable_For_Asrun_Schedule { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual ICollection<Title_Country> Title_Country { get; set; }        
    }
}
