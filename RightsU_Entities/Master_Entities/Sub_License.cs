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
    
    public partial class Sub_License
    {
        public Sub_License()
        {
            this.Acq_Deal_Rights = new HashSet<Acq_Deal_Rights>();
            this.Syn_Deal_Rights = new HashSet<Syn_Deal_Rights>();
        }
    
        public int Sub_License_Code { get; set; }
        public string Sub_License_Name { get; set; }
        public string Is_Active { get; set; }
    
        public virtual ICollection<Acq_Deal_Rights> Acq_Deal_Rights { get; set; }
        public virtual ICollection<Syn_Deal_Rights> Syn_Deal_Rights { get; set; }
    }
}
