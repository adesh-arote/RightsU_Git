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
    
    public partial class Title_Promotion
    {
    	public State EntityState { get; set; }    public int Title_Promotion_Code { get; set; }
    	    public Nullable<int> External_Title_Code { get; set; }
    	    public Nullable<System.DateTime> Effective_Start_Date { get; set; }
    	    public Nullable<System.DateTime> Effective_End_Date { get; set; }
    	    public string Is_Promotion { get; set; }
    	    public System.DateTime Inserted_On { get; set; }
    	    public int Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    }
}
