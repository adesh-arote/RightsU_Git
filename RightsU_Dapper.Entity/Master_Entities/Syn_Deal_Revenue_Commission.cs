
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Revenue_Commission")]
    public partial class Syn_Deal_Revenue_Commission
    {
        [PrimaryKey]
        public int? Syn_Deal_Revenue_Commission_Code { get; set; }
        [ForeignKeyReference(typeof(Syn_Deal_Revenue))]
        public Nullable<int> Syn_Deal_Revenue_Code { get; set; }
        [ForeignKeyReference(typeof(Cost_Type))]
        public Nullable<int> Cost_Type_Code { get; set; }
        public Nullable<int> Royalty_Commission_Code { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public string Type { get; set; }
        public string Commission_Type { get; set; }
        public Nullable<decimal> Percentage { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public Nullable<int> Entity_Code { get; set; }

        public virtual Cost_Type Cost_Type { get; set; }
        //public virtual Royalty_Commission Royalty_Commission { get; set; }
        public virtual Syn_Deal_Revenue Syn_Deal_Revenue { get; set; }
        //public virtual Vendor Vendor { get; set; }
        //public virtual Entity Entity { get; set; }
    }
}


