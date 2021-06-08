using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;

namespace RightsU_Dapper.Entity
{
    [Table("IPR_TYPE")]
    public partial class IPR_TYPE
    {
        public IPR_TYPE()
        {
            this.IPR_REP = new HashSet<IPR_REP>();
        }
        [PrimaryKey]
        public int? IPR_Type_Code { get; set; }
        public string Type { get; set; }

        [OneToMany]
        public virtual ICollection<IPR_REP> IPR_REP { get; set; }
    }
}
