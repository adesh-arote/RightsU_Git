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
    
    public partial class ErrorOn_AsRun_Schedule
    {
    	public State EntityState { get; set; }    public int Error_Id { get; set; }
    	    public Nullable<decimal> ErrorNumber { get; set; }
    	    public Nullable<decimal> ErrorSeverity { get; set; }
    	    public Nullable<decimal> ErrorState { get; set; }
    	    public string ErrorProcedure { get; set; }
    	    public Nullable<decimal> ErrorLine { get; set; }
    	    public string ErrorMessage { get; set; }
    	    public Nullable<int> FileCode { get; set; }
    	    public Nullable<int> ChannelCode { get; set; }
    	    public string ErrorFor { get; set; }
    	    public Nullable<System.DateTime> ErrorDate { get; set; }
    }
}
