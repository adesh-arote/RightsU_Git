//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class Additional_Expense
    {
        public Additional_Expense()
        {
            this.Acq_Deal_Cost_Additional_Exp = new HashSet<Acq_Deal_Cost_Additional_Exp>();
            this.Syn_Deal_Revenue_Additional_Exp = new HashSet<Syn_Deal_Revenue_Additional_Exp>();
        }
        [JsonIgnore]
        public State EntityState { get; set; }
        public int Additional_Expense_Code { get; set; }
        public string Additional_Expense_Name { get; set; }
        public string SAP_GL_Group_Code { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [NotMapped]
        public string Inserted_By_User { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        public string Last_Action_By_User { get; set; }
        public string Is_Active { get; set; }
        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Cost_Additional_Exp> Acq_Deal_Cost_Additional_Exp { get; set; }
        [JsonIgnore]
        public virtual ICollection<Syn_Deal_Revenue_Additional_Exp> Syn_Deal_Revenue_Additional_Exp { get; set; }
    }
}
