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
    
    public partial class Upload_Files
    {
        public State EntityState { get; set; }  
        public long File_Code { get; set; }
        public string File_Name { get; set; }
        public string Err_YN { get; set; }
        public Nullable<System.DateTime> Upload_Date { get; set; }
        public Nullable<int> Uploaded_By { get; set; }
        public string Upload_Type { get; set; }
        public string Pending_Review_YN { get; set; }
        public Nullable<int> Upload_Record_Count { get; set; }
        public Nullable<int> Bank_Code { get; set; }
        public Nullable<int> Records_Inserted { get; set; }
        public Nullable<int> Records_Updated { get; set; }
        public Nullable<int> Total_Errors { get; set; }
        public Nullable<int> ChannelCode { get; set; }
        public Nullable<System.DateTime> StartDate { get; set; }
        public Nullable<System.DateTime> EndDate { get; set; }
    }
}
