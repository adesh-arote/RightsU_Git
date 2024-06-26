﻿//------------------------------------------------------------------------------
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

    public partial class Acq_Rights_Template
    {
        public State EntityState { get; set; }
        public int Acq_Rights_Template_Code { get; set; }
        public string Template_Name { get; set; }
        public string Is_Exclusive { get; set; }
        public string Is_Title_Language { get; set; }
        public string Is_Theatrical { get; set; }
        public string Is_Sublicense { get; set; }
        public Nullable<int> SubLicense_Code { get; set; }
        public string Right_Type { get; set; }
        public string Term { get; set; }
        public Nullable<System.DateTime> Right_Start_Date { get; set; }
        public Nullable<System.DateTime> Right_End_Date { get; set; }
        public Nullable<int> Milestone_Type_Code { get; set; }
        public Nullable<int> Milestone_No_Of_Unit { get; set; }
        public Nullable<int> Milestone_Unit_Type { get; set; }
        public Nullable<int> ROFRDays { get; set; }
        public string Region_Type { get; set; }
        public string Region_Codes { get; set; }
        public string Platform_Codes { get; set; }
        public string Subtitling_Type { get; set; }
        public string Subtitling_Codes { get; set; }
        public string Dubbing_Type { get; set; }
        public string Dubbing_Codes { get; set; }
        public string Type { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Is_Tentative { get; set; }
    }
}
