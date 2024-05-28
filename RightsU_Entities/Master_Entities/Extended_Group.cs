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

    public partial class Extended_Group
    {
        public Extended_Group()
        {
            this.Extended_Group_Config = new HashSet<Extended_Group_Config>();
            this.AL_Vendor_Details = new HashSet<AL_Vendor_Details>();
            this.AL_Booking_Sheet_Details = new HashSet<AL_Booking_Sheet_Details>();
        }
        [JsonIgnore]
        public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Extended_Group_Code { get; set; }
        [JsonProperty(Order = 1)]
        public string Group_Name { get; set; }
        [JsonProperty(Order = 2)]
        public string Short_Name { get; set; }
        [JsonProperty(Order = 3)]
        public Nullable<int> Group_Order { get; set; }
        [JsonProperty(Order = 4)]
        public string Add_Edit_Type { get; set; }
        [JsonProperty(Order = 5)]
        public Nullable<int> Module_Code { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 6)]
        public string Inserted_By_User { get; set; }
        [JsonProperty(Order = 7)]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonProperty(Order = 8)]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 9)]
        public string Last_Action_By_User { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonProperty(Order = 10)]
        public string IsActive { get; set; }

        [JsonProperty(Order = 11)]
        public virtual ICollection<Extended_Group_Config> Extended_Group_Config { get; set; }
        [JsonIgnore]
        public virtual ICollection<AL_Vendor_Details> AL_Vendor_Details { get; set; }
        [JsonIgnore]
        public virtual ICollection<AL_Booking_Sheet_Details> AL_Booking_Sheet_Details { get; set; }
    }
}
