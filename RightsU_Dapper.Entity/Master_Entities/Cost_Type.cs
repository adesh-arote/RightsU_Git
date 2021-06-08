
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Cost_Type")]
    public partial class Cost_Type
    {
        public Cost_Type()
        {
            this.Syn_Deal_Payment_Terms = new HashSet<Syn_Deal_Payment_Terms>();
            this.Acq_Deal_Cost_Commission = new HashSet<Acq_Deal_Cost_Commission>();
            this.Acq_Deal_Cost_Costtype = new HashSet<Acq_Deal_Cost_Costtype>();
            this.Acq_Deal_Payment_Terms = new HashSet<Acq_Deal_Payment_Terms>();
            this.Syn_Deal_Revenue_Commission = new HashSet<Syn_Deal_Revenue_Commission>();
            this.Syn_Deal_Revenue_Costtype = new HashSet<Syn_Deal_Revenue_Costtype>();
        }
        [PrimaryKey]
        public int? Cost_Type_Code { get; set; }
        public string Cost_Type_Name { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Is_System_Generated { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Payment_Terms> Syn_Deal_Payment_Terms { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Cost_Commission> Acq_Deal_Cost_Commission { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Cost_Costtype> Acq_Deal_Cost_Costtype { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal_Payment_Terms> Acq_Deal_Payment_Terms { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Revenue_Commission> Syn_Deal_Revenue_Commission { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal_Revenue_Costtype> Syn_Deal_Revenue_Costtype { get; set; }
    }
}

