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
    
    public partial class Acq_Adv_Ancillary_Report
    {
    	public State EntityState { get; set; }    public int Acq_Adv_Ancillary_Report_Code { get; set; }
    	    public string Agreement_No { get; set; }
    	    public string Title_Codes { get; set; }
    	    public string Platform_Codes { get; set; }
    	    public Nullable<int> Business_Unit_Code { get; set; }
    	    public string IncludeExpired { get; set; }
    	    public string Date_Format { get; set; }
    	    public string DateTime_Format { get; set; }
    	    public string Created_By { get; set; }
    	    public Nullable<int> SysLanguageCode { get; set; }
    	    public string Report_Name { get; set; }
    	    public string Accessibility { get; set; }
    	    public string File_Name { get; set; }
    	    public Nullable<System.DateTime> Process_Start { get; set; }
    	    public Nullable<System.DateTime> Process_End { get; set; }
    	    public string Report_Status { get; set; }
    	    public string Error_Message { get; set; }
    	    public Nullable<int> Generated_By { get; set; }
    	    public Nullable<System.DateTime> Generated_On { get; set; }
    	    public string Ancillary_Type_Codes { get; set; }
    }
}