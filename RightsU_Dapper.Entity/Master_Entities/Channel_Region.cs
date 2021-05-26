using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("Channel_Region")]
    public partial class Channel_Region
    {
        public Channel_Region()
        {
            this.Channel_Region_Mapping = new HashSet<Channel_Region_Mapping>();
        }
        [PrimaryKey]
        public int? Channel_Region_Code { get; set; }
        public string Channel_Region_Name { get; set; }
        public string Business_Unit_Code { get; set; }
        [OneToMany]
        public virtual ICollection<Channel_Region_Mapping> Channel_Region_Mapping { get; set; }
    }
}
