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

    public partial class IPR_CLASS
    {
        public IPR_CLASS()
        {
            this.IPR_REP_CLASS = new HashSet<IPR_REP_CLASS>();
            this.IPR_Opp = new HashSet<IPR_Opp>();
        }

        public State EntityState { get; set; }
        public int IPR_Class_Code { get; set; }
        public string Description { get; set; }
        public Nullable<int> Parent_Class_Code { get; set; }
        public string Is_Last_Level { get; set; }
        public string Position { get; set; }
        public string Is_Active { get; set; }

        public virtual ICollection<IPR_REP_CLASS> IPR_REP_CLASS { get; set; }
        public virtual ICollection<IPR_Opp> IPR_Opp { get; set; }
    }
}
