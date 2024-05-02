using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations.Schema;
    public partial class Event_Platform
    {
        public State EntityState { get; set; }
        public int Event_Platform_Code { get; set; }
        public string Event_Platform_Name { get; set; }
        public string Short_Code { get; set; }
        public string Credentials { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public string Enable_CC_And_BCC { get; set; }
    }
}
