
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Payment_Terms")]
    public partial class Syn_Deal_Payment_Terms
    {
        [PrimaryKey]
        public int? Syn_Deal_Payment_Terms_Code { get; set; }
        [ForeignKeyReference(typeof(Syn_Deal))]
        public int Syn_Deal_Code { get; set; }
        public Nullable<int> Days_After { get; set; }
        public Nullable<System.DateTime> Due_Date { get; set; }
        public Nullable<int> Cost_Type_Code { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<int> Payment_Terms_Code { get; set; }
        public Nullable<decimal> Percentage { get; set; }
        public Nullable<decimal> Amount { get; set; }

        public virtual Cost_Type Cost_Type { get; set; }
        public virtual Syn_Deal Syn_Deal { get; set; }
      //  public virtual Payment_Terms Payment_Terms { get; set; }

    }
}

