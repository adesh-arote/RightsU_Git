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

    public partial class Currency
    {
        public Currency()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Currency_Exchange_Rate = new HashSet<Currency_Exchange_Rate>();
            this.Material_Order_Details = new HashSet<Material_Order_Details>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
            this.Acq_Deal_Cost = new HashSet<Acq_Deal_Cost>();
            this.Syn_Deal_Revenue = new HashSet<Syn_Deal_Revenue>();
        }

        [JsonIgnore]
        public State EntityState { get; set; }
        public int Currency_Code { get; set; }
        public string Currency_Name { get; set; }
        public string Currency_Sign { get; set; }
        public System.DateTime Inserted_On { get; set; }
        [JsonIgnore]
        public int Inserted_By { get; set; }
        [NotMapped]
        public string Inserted_By_User { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        public string Last_Action_By_User { get; set; }
        public string Is_Active { get; set; }
        public string Is_Base_Currency { get; set; }

        [JsonIgnore]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        public virtual ICollection<Currency_Exchange_Rate> Currency_Exchange_Rate { get; set; }
        [JsonIgnore]
        public virtual ICollection<Material_Order_Details> Material_Order_Details { get; set; }
        [JsonIgnore]
        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Cost> Acq_Deal_Cost { get; set; }
        [JsonIgnore]
        public virtual ICollection<Syn_Deal_Revenue> Syn_Deal_Revenue { get; set; }    

    }
}
