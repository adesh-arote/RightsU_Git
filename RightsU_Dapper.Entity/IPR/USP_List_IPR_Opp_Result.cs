﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    public partial class USP_List_IPR_Opp_Result
    {
        public int IPR_Opp_Code { get; set; }
        public string Version { get; set; }
        public string IPR_For { get; set; }
        public string Opp_No { get; set; }
        public string Party_Name { get; set; }
        public string Opposition_Party_Trademark { get; set; }
        public string Trademark { get; set; }
        public string Application_No { get; set; }
        public string IPR_Rep_Application_No { get; set; }
        public Nullable<int> IPR_Class_Code { get; set; }
        public string Class_Name { get; set; }
        public Nullable<int> IPR_App_Status_Code { get; set; }
        public Nullable<System.DateTime> Order_Date { get; set; }
        public string Outcomes { get; set; }
        public string Comments { get; set; }
        public string App_Status { get; set; }
        public string Workflow_Status { get; set; }
        public string Workflow_Status_Flag { get; set; }
        public string Show_Hide_Buttons { get; set; }
        public string Business_Unit { get; set; }
        public string Channel_Name { get; set; }
    }
}
