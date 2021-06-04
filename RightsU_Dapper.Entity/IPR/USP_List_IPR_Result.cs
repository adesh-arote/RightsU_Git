using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    public partial class USP_List_IPR_Result
    {
        public int IPR_Rep_Code { get; set; }
        public string Trademark_No { get; set; }
        public string Type { get; set; }
        public string Application_No { get; set; }
        public Nullable<System.DateTime> Application_Date { get; set; }
        public string Country { get; set; }
        public System.DateTime Date_of_Use { get; set; }
        public string App_Status { get; set; }
        public string Entity { get; set; }
        public string Trademark_Attorney { get; set; }
        public string Workflow_Status_Flag { get; set; }
        public string Workflow_Status { get; set; }
        public string Version { get; set; }
        public string Trademark { get; set; }
        public string Class_Description { get; set; }
        public string International_Trademark_Attorney { get; set; }
        public string Show_Hide_Buttons { get; set; }
        public string Business_Unit { get; set; }
        public string Channel_Name { get; set; }
    }
}
