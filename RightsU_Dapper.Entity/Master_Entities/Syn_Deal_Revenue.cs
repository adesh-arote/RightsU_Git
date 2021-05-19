
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Revenue")]
    public partial class Syn_Deal_Revenue
    {
        public Syn_Deal_Revenue()
        {
            //this.Syn_Deal_Revenue_Additional_Exp = new HashSet<Syn_Deal_Revenue_Additional_Exp>();
            //this.Syn_Deal_Revenue_Commission = new HashSet<Syn_Deal_Revenue_Commission>();
            //this.Syn_Deal_Revenue_Costtype = new HashSet<Syn_Deal_Revenue_Costtype>();
            //this.Syn_Deal_Revenue_Variable_Cost = new HashSet<Syn_Deal_Revenue_Variable_Cost>();
            //this.Syn_Deal_Revenue_Title = new HashSet<Syn_Deal_Revenue_Title>();
            //this.Syn_Deal_Revenue_Platform = new HashSet<Syn_Deal_Revenue_Platform>();
        }
        [PrimaryKey]
        public int? Syn_Deal_Revenue_Code { get; set; }
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
        public Nullable<int> Syn_Deal_Code { get; set; }

       // public virtual Cost_Center Cost_Center { get; set; }
        public virtual Currency Currency { get; set; }
        //public virtual Royalty_Recoupment Royalty_Recoupment { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Additional_Exp> Syn_Deal_Revenue_Additional_Exp { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Commission> Syn_Deal_Revenue_Commission { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Costtype> Syn_Deal_Revenue_Costtype { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Variable_Cost> Syn_Deal_Revenue_Variable_Cost { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Title> Syn_Deal_Revenue_Title { get; set; }
        public virtual Syn_Deal Syn_Deal { get; set; }
        //public virtual ICollection<Syn_Deal_Revenue_Platform> Syn_Deal_Revenue_Platform { get; set; }

        #region ========== DUMMY PROPERTIES ==========

        public string StanddardReturnMessage { get; set; }
        public string Message { get; set; }
        public string HeaderLabel { get; set; }
        public string Mode { get; set; }

        #endregion
    }
}


