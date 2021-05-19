
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Revenue_Costtype")]
    public partial class Syn_Deal_Revenue_Costtype
    {
        public Syn_Deal_Revenue_Costtype()
        {
            //this.Syn_Deal_Revenue_Costtype_Episode = new HashSet<Syn_Deal_Revenue_Costtype_Episode>();
        }
        [PrimaryKey]
        public int? Syn_Deal_Revenue_Costtype_Code { get; set; }
        [ForeignKeyReference(typeof(Syn_Deal_Revenue))]
        public Nullable<int> Syn_Deal_Revenue_Code { get; set; }
        [ForeignKeyReference(typeof(Cost_Type))]
        public Nullable<int> Cost_Type_Code { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public Nullable<decimal> Consumed_Amount { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        public virtual Cost_Type Cost_Type { get; set; }
        public virtual Syn_Deal_Revenue Syn_Deal_Revenue { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Costtype_Episode> Syn_Deal_Revenue_Costtype_Episode { get; set; }
    }
}


