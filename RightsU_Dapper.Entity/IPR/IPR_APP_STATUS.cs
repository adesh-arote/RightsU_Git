using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using RightsU_Entities;
namespace RightsU_Dapper.Entity
{
    [Table("IPR_APP_STATUS")]
    public partial class IPR_APP_STATUS
    {
        public IPR_APP_STATUS()
        {
            this.IPR_REP = new HashSet<IPR_REP>();
            this.IPR_Opp = new HashSet<IPR_Opp>();
        }

        [PrimaryKey]
        public int? IPR_App_Status_Code { get; set; }
        public string App_Status { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<IPR_REP> IPR_REP { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_Opp> IPR_Opp { get; set; }
    }
}
