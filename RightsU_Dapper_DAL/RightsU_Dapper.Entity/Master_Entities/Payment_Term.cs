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

    [Table("Payment_Terms")]
    public partial class Payment_Term
    {
        public Payment_Term()
        {
            this.Acq_Deal_Payment_Terms = new HashSet<Acq_Deal_Payment_Terms>();
            this.Syn_Deal_Payment_Terms = new HashSet<Syn_Deal_Payment_Terms>();
        }

        [PrimaryKey]
        public int? Payment_Terms_Code { get; set; }
        public string Payment_Terms { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Payment_Terms> Acq_Deal_Payment_Terms { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Payment_Terms> Syn_Deal_Payment_Terms { get; set; }
    }
}
