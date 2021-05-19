
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Cost_Costtype")]
    public partial class Acq_Deal_Cost_Costtype
    {
        public Acq_Deal_Cost_Costtype()
        {
            //this.Acq_Deal_Cost_Costtype_Episode = new HashSet<Acq_Deal_Cost_Costtype_Episode>();
        }
        [PrimaryKey]
        public int? Acq_Deal_Cost_Costtype_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal_Cost))]
        public Nullable<int> Acq_Deal_Cost_Code { get; set; }
        [ForeignKeyReference(typeof(Cost_Type))]
        public Nullable<int> Cost_Type_Code { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public Nullable<decimal> Consumed_Amount { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        public virtual Acq_Deal_Cost Acq_Deal_Cost { get; set; }
        //public virtual ICollection<Acq_Deal_Cost_Costtype_Episode> Acq_Deal_Cost_Costtype_Episode { get; set; }
        public virtual Cost_Type Cost_Type { get; set; }
    }
}


