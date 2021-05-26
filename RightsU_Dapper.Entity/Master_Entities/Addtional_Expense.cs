using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using RightsU_Entities;
    using System;
    using System.Collections.Generic;

    [Table("Additional_Expense")]
    public partial class Additional_Expense
    {
        public Additional_Expense()
        {
            this.Acq_Deal_Cost_Additional_Exp = new HashSet<Acq_Deal_Cost_Additional_Exp>();
            this.Syn_Deal_Revenue_Additional_Exp = new HashSet<Syn_Deal_Revenue_Additional_Exp>();
        }
        [PrimaryKey]
        public int? Additional_Expense_Code { get; set; }
        public string Additional_Expense_Name { get; set; }
        public string SAP_GL_Group_Code { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Cost_Additional_Exp> Acq_Deal_Cost_Additional_Exp { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Revenue_Additional_Exp> Syn_Deal_Revenue_Additional_Exp { get; set; }
    }
}
