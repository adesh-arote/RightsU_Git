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
    
    public partial class Provisional_Deal_Title
    {
        public Provisional_Deal_Title()
        {
            this.Provisional_Deal_Run = new HashSet<Provisional_Deal_Run>();
            this.Title_Content_Mapping = new HashSet<Title_Content_Mapping>();
        }
    
    	public State EntityState { get; set; }    public int Provisional_Deal_Title_Code { get; set; }
    	    public Nullable<int> Provisional_Deal_Code { get; set; }
    	    public Nullable<int> Title_Code { get; set; }
    	    public Nullable<int> Episode_From { get; set; }
    	    public Nullable<int> Episode_To { get; set; }
    	    public Nullable<System.DateTime> Right_Start_Date { get; set; }
    	    public Nullable<System.DateTime> Right_End_Date { get; set; }
    	    public string Term { get; set; }
    	    public Nullable<System.TimeSpan> Prime_Start_Time { get; set; }
    	    public Nullable<System.TimeSpan> Prime_End_Time { get; set; }
    	    public Nullable<System.TimeSpan> Off_Prime_Start_Time { get; set; }
    	    public Nullable<System.TimeSpan> Off_Prime_End_Time { get; set; }
    
        public virtual Provisional_Deal Provisional_Deal { get; set; }
        public virtual ICollection<Provisional_Deal_Run> Provisional_Deal_Run { get; set; }
        public virtual Title Title { get; set; }
        public virtual ICollection<Title_Content_Mapping> Title_Content_Mapping { get; set; }
    }
}
