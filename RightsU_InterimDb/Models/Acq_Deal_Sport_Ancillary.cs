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
    
    public partial class Acq_Deal_Sport_Ancillary
    {
        public Acq_Deal_Sport_Ancillary()
        {
            this.Acq_Deal_Sport_Ancillary_Broadcast = new HashSet<Acq_Deal_Sport_Ancillary_Broadcast>();
            this.Acq_Deal_Sport_Ancillary_Source = new HashSet<Acq_Deal_Sport_Ancillary_Source>();
            this.Acq_Deal_Sport_Ancillary_Title = new HashSet<Acq_Deal_Sport_Ancillary_Title>();
        }
    
    	public State EntityState { get; set; }    public int Acq_Deal_Sport_Ancillary_Code { get; set; }
    	    public Nullable<int> Acq_Deal_Code { get; set; }
    	    public string Ancillary_For { get; set; }
    	    public Nullable<int> Sport_Ancillary_Type_Code { get; set; }
    	    public string Obligation_Broadcast { get; set; }
    	    public Nullable<int> Broadcast_Window { get; set; }
    	    public Nullable<int> Broadcast_Periodicity_Code { get; set; }
    	    public Nullable<int> Sport_Ancillary_Periodicity_Code { get; set; }
    	    public Nullable<System.TimeSpan> Duration { get; set; }
    	    public Nullable<int> No_Of_Promos { get; set; }
    	    public Nullable<System.TimeSpan> Prime_Start_Time { get; set; }
    	    public Nullable<System.TimeSpan> Prime_End_Time { get; set; }
    	    public Nullable<System.TimeSpan> Prime_Durartion { get; set; }
    	    public Nullable<int> Prime_No_of_Promos { get; set; }
    	    public Nullable<System.TimeSpan> Off_Prime_Start_Time { get; set; }
    	    public Nullable<System.TimeSpan> Off_Prime_End_Time { get; set; }
    	    public Nullable<System.TimeSpan> Off_Prime_Durartion { get; set; }
    	    public Nullable<int> Off_Prime_No_of_Promos { get; set; }
    	    public string Remarks { get; set; }
    
        public virtual Acq_Deal Acq_Deal { get; set; }
        public virtual ICollection<Acq_Deal_Sport_Ancillary_Broadcast> Acq_Deal_Sport_Ancillary_Broadcast { get; set; }
        public virtual ICollection<Acq_Deal_Sport_Ancillary_Source> Acq_Deal_Sport_Ancillary_Source { get; set; }
        public virtual Sport_Ancillary_Periodicity Sport_Ancillary_Periodicity { get; set; }
        public virtual Sport_Ancillary_Periodicity Sport_Ancillary_Periodicity1 { get; set; }
        public virtual Sport_Ancillary_Type Sport_Ancillary_Type { get; set; }
        public virtual ICollection<Acq_Deal_Sport_Ancillary_Title> Acq_Deal_Sport_Ancillary_Title { get; set; }
    }
}
