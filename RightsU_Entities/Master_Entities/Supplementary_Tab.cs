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
    
    public partial class Supplementary_Tab
    {
        public Supplementary_Tab()
        {
            this.Supplementary_Config = new HashSet<Supplementary_Config>();
        }

        public State EntityState { get; set; }
        public int Supplementary_Tab_Code { get; set; }
        public string Short_Name { get; set; }
        public string Supplementary_Tab_Description { get; set; }
        public Nullable<int> Order_No { get; set; }
        public string Tab_Type { get; set; }
        public string EditWindowType { get; set; }

        public virtual ICollection<Supplementary_Config> Supplementary_Config { get; set; }
    }
}
