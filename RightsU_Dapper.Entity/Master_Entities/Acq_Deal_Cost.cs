
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Cost")]
    public partial class Acq_Deal_Cost
    {
        public Acq_Deal_Cost()
        {
            //this.Acq_Deal_Cost_Additional_Exp = new HashSet<Acq_Deal_Cost_Additional_Exp>();
            //this.Acq_Deal_Cost_Commission = new HashSet<Acq_Deal_Cost_Commission>();
            //this.Acq_Deal_Cost_Costtype = new HashSet<Acq_Deal_Cost_Costtype>();
            //this.Acq_Deal_Cost_Variable_Cost = new HashSet<Acq_Deal_Cost_Variable_Cost>();
            //this.Acq_Deal_Cost_Title = new HashSet<Acq_Deal_Cost_Title>();
        }
        [PrimaryKey]
        public int? Acq_Deal_Cost_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal))]
        public Nullable<int> Acq_Deal_Code { get; set; }
        [ForeignKeyReference(typeof(Currency))]
        public Nullable<int> Currency_Code { get; set; }
        public Nullable<decimal> Currency_Exchange_Rate { get; set; }
        public Nullable<decimal> Deal_Cost { get; set; }
        public Nullable<decimal> Deal_Cost_Per_Episode { get; set; }
        public Nullable<int> Cost_Center_Id { get; set; }
        public Nullable<decimal> Additional_Cost { get; set; }
        public Nullable<decimal> Catchup_Cost { get; set; }
        public string Variable_Cost_Type { get; set; }
        public string Variable_Cost_Sharing_Type { get; set; }
        public Nullable<int> Royalty_Recoupment_Code { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Incentive { get; set; }
        public string Remarks { get; set; }

        public virtual Acq_Deal Acq_Deal { get; set; }
        //public virtual ICollection<Acq_Deal_Cost_Additional_Exp> Acq_Deal_Cost_Additional_Exp { get; set; }
        //public virtual ICollection<Acq_Deal_Cost_Commission> Acq_Deal_Cost_Commission { get; set; }
        //public virtual Cost_Center Cost_Center { get; set; }
        //public virtual ICollection<Acq_Deal_Cost_Costtype> Acq_Deal_Cost_Costtype { get; set; }
        public virtual Currency Currency { get; set; }
        //public virtual Royalty_Recoupment Royalty_Recoupment { get; set; }
        //public virtual ICollection<Acq_Deal_Cost_Variable_Cost> Acq_Deal_Cost_Variable_Cost { get; set; }
        //public virtual ICollection<Acq_Deal_Cost_Title> Acq_Deal_Cost_Title { get; set; }

        #region ========== DUMMY PROPERTIES ==========

        public string StanddardReturnMessage { get; set; }
        public string Message { get; set; }
        public string HeaderLabel { get; set; }
        public string Mode { get; set; }

        #endregion
    }
}


