//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_InterimDb.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Acq_Deal_Rights_Promoter
    {
        public Acq_Deal_Rights_Promoter()
        {
            this.Acq_Deal_Rights_Promoter_Group = new HashSet<Acq_Deal_Rights_Promoter_Group>();
            this.Acq_Deal_Rights_Promoter_Remarks = new HashSet<Acq_Deal_Rights_Promoter_Remarks>();
        }
    
    	public State EntityState { get; set; }    public int Acq_Deal_Rights_Promoter_Code { get; set; }
    	    public Nullable<int> Acq_Deal_Rights_Code { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    
        public virtual Acq_Deal_Rights Acq_Deal_Rights { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Promoter_Group> Acq_Deal_Rights_Promoter_Group { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Promoter_Remarks> Acq_Deal_Rights_Promoter_Remarks { get; set; }
    }
}
