using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleSave;

namespace RightsU_Dapper.Entity
{
    [Table("IPR_Country")]
    public partial class IPR_Country
    {
        public IPR_Country()
        {
            this.IPR_REP = new HashSet<IPR_REP>();
        }
        [PrimaryKey]
        public int? IPR_Country_Code { get; set; }
        public string IPR_Country_Name { get; set; }
        public string Is_Domestic_Territory { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_REP> IPR_REP { get; set; }
    }
}
