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
    using RightsU_Entities;

    [Table("SAP_WBS")]
    public partial class SAP_WBS
    {
        public SAP_WBS()
        {
            this.Acq_Deal_Budget = new HashSet<Acq_Deal_Budget>();
            this.BV_WBS = new HashSet<BV_WBS>();
        }
        [PrimaryKey]
        public int? SAP_WBS_Code { get; set; }
        public string WBS_Code { get; set; }
        public string WBS_Description { get; set; }
        public string Studio_Vendor { get; set; }
        public string Original_Dubbed { get; set; }
        public string Status { get; set; }
        public string Sport_Type { get; set; }
        public Nullable<System.DateTime> Insert_On { get; set; }
        public Nullable<int> File_Code { get; set; }
        public string Short_ID { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Budget> Acq_Deal_Budget { get; set; }
        [OneToMany]
        public virtual ICollection<BV_WBS> BV_WBS { get; set; }
    }
}
