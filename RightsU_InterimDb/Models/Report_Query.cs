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
    
    public partial class Report_Query
    {
    	public State EntityState { get; set; }    public int Query_Code { get; set; }
    	    public string Query_Name { get; set; }
    	    public string View_Name { get; set; }
    	    public string Created_By { get; set; }
    	    public Nullable<System.DateTime> Last_Update_Time { get; set; }
    	    public Nullable<int> Business_Unit_Code { get; set; }
    	    public Nullable<int> Security_Group_Code { get; set; }
    	    public string Visibility { get; set; }
    	    public string Theatrical_Territory { get; set; }
    	    public string Expired_Deals { get; set; }
    	    public string Alternate_Config_Code { get; set; }
    }
}
