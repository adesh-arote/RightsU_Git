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
    
    public partial class Payment_Terms
    {
        public Payment_Terms()
        {
            this.Acq_Deal_Payment_Terms = new HashSet<Acq_Deal_Payment_Terms>();
            this.Syn_Deal_Payment_Terms = new HashSet<Syn_Deal_Payment_Terms>();
        }

        [JsonIgnore]
        public State EntityState { get; set; }
        public int Payment_Terms_Code { get; set; }
        public string Payment_Terms1 { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
    
        [JsonIgnore]
        public virtual ICollection<Acq_Deal_Payment_Terms> Acq_Deal_Payment_Terms { get; set; }
        [JsonIgnore]
        public virtual ICollection<Syn_Deal_Payment_Terms> Syn_Deal_Payment_Terms { get; set; }
    }
}
