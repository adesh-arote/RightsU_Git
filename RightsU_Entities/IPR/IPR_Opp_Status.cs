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
    using System;
    using System.Collections.Generic;

    public partial class IPR_Opp_Status
    {
        public IPR_Opp_Status()
        {
            this.IPR_Opp = new HashSet<IPR_Opp>();
        }

        public State EntityState { get; set; }    public int IPR_Opp_Status_Code { get; set; }
        public string Opp_Status { get; set; }
        public string Is_Active { get; set; }

        public virtual ICollection<IPR_Opp> IPR_Opp { get; set; }
    }
}
