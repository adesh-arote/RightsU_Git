using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
namespace RightsU_Dapper.Entity
{
    [Table("IPR_ENTITY")]
    public partial class IPR_ENTITY
    {
        public IPR_ENTITY()
        {
            this.IPR_REP = new HashSet<IPR_REP>();
        }
        [PrimaryKey]
        public int? IPR_Entity_Code { get; set; }
        public string Entity { get; set; }
        [OneToMany]
        public virtual ICollection<IPR_REP> IPR_REP { get; set; }
    }
}
