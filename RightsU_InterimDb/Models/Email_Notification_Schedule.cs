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
    
    public partial class Email_Notification_Schedule
    {
    	public State EntityState { get; set; }    public decimal Email_Notification_Schedule_Code { get; set; }
    	    public Nullable<decimal> BV_Schedule_Transaction_Code { get; set; }
    	    public string Program_Episode_Title { get; set; }
    	    public string Program_Episode_Number { get; set; }
    	    public string Program_Title { get; set; }
    	    public string Program_Category { get; set; }
    	    public string Schedule_Item_Log_Date { get; set; }
    	    public string Schedule_Item_Log_Time { get; set; }
    	    public string Schedule_Item_Duration { get; set; }
    	    public string Scheduled_Version_House_Number_List { get; set; }
    	    public Nullable<long> File_Code { get; set; }
    	    public Nullable<int> Channel_Code { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<decimal> Deal_Movie_Code { get; set; }
    	    public Nullable<decimal> Deal_Movie_Rights_Code { get; set; }
    	    public string Email_Notification_Msg { get; set; }
    	    public string IsMailSent { get; set; }
    	    public string IsRunCountCalculate { get; set; }
    	    public Nullable<int> Title_Code { get; set; }
    	    public string Title_Name { get; set; }
    	    public Nullable<System.DateTime> Right_Start_Date { get; set; }
    	    public Nullable<System.DateTime> Right_End_Date { get; set; }
    	    public string No_Of_Runs_Across_Beams { get; set; }
    	    public string Available_Channels { get; set; }
    	    public string Count_Of_Schedule { get; set; }
    	    public string Channel_Name { get; set; }
    	    public string IsPrimeException { get; set; }
    	    public string IS_DATA_REPROCESS { get; set; }
    }
}
