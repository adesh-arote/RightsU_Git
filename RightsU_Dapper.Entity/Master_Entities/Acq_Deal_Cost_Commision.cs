
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Cost_Commission")]
    public partial class Acq_Deal_Cost_Commission
    {
        [PrimaryKey]
        public int? Acq_Deal_Cost_Commission_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal_Cost))]
        public Nullable<int> Acq_Deal_Cost_Code { get; set; }
        [ForeignKeyReference(typeof(Cost_Type))]
        public Nullable<int> Cost_Type_Code { get; set; }
        public Nullable<int> Royalty_Commission_Code { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public string Type { get; set; }
        public string Commission_Type { get; set; }
        public Nullable<decimal> Percentage { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public Nullable<int> Entity_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Acq_Deal_Cost Acq_Deal_Cost { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Cost_Type Cost_Type { get; set; }
        //public virtual Royalty_Commission Royalty_Commission { get; set; }
        //public virtual Vendor Vendor { get; set; }
       // public virtual Entity Entity { get; set; }
    }
}


