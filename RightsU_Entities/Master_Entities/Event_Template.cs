using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class Event_Template
    {
        [JsonIgnore]
        public State EntityState { get; set; }
        public int Event_Template_Code { get; set; }
        public string Event_Template_Name { get; set; }
        public string Event_Template_Type { get; set; }
        [JsonIgnore]
        public Nullable<int> Event_Platform_Code { get; set; }
        [NotMapped]
        public string Event_Platform_Name { get; set; }
        public string Template { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [NotMapped]
        public string Inserted_By_User { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        public string Last_Action_By_User { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public string Subject { get; set; }
        [JsonIgnore]
        public string Table_Type { get; set; }
    }
}
