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
    
    public partial class SAP_WBS
    {
        public SAP_WBS()
        {
            this.Acq_Deal_Budget = new HashSet<Acq_Deal_Budget>();
            this.BV_WBS = new HashSet<BV_WBS>();
        }
    
    	public State EntityState { get; set; }    public int SAP_WBS_Code { get; set; }
    	    public string WBS_Code { get; set; }
    	    public string WBS_Description { get; set; }
    	    public string Studio_Vendor { get; set; }
    	    public string Original_Dubbed { get; set; }
    	    public string Status { get; set; }
    	    public string Sport_Type { get; set; }
    	    public Nullable<System.DateTime> Insert_On { get; set; }
    	    public Nullable<int> File_Code { get; set; }
    	    public string Short_ID { get; set; }
    
        public virtual ICollection<Acq_Deal_Budget> Acq_Deal_Budget { get; set; }
        public virtual ICollection<BV_WBS> BV_WBS { get; set; }
    }
}
