using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class Event_Template
    {
        public State EntityState { get; set; }
        public int Event_Template_Code { get; set; }
        public Nullable<int> Event_Template_Name { get; set; }
        public string Event_Template_Type { get; set; }
        public Nullable<int> Event_Platform_Code { get; set; }
        public string Template { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
    }
}
