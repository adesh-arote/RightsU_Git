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

    public partial class Acq_Deal_Supplementary
    {
        public Acq_Deal_Supplementary()
        {
            this.Acq_Deal_Supplementary_detail = new HashSet<Acq_Deal_Supplementary_detail>();
        }

        public State EntityState { get; set; }
        public int Acq_Deal_Supplementary_Code { get; set; }
        public Nullable<int> Acq_Deal_Code { get; set; }
        public Nullable<int> Title_code { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }
        public string Remarks { get; set; }
        public virtual ICollection<Acq_Deal_Supplementary_detail> Acq_Deal_Supplementary_detail { get; set; }
    }
}
