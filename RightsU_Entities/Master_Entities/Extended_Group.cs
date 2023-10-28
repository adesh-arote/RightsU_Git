using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Extended_Group
    {
        public Extended_Group()
        {
            this.Extended_Group_Config = new HashSet<Extended_Group_Config>();
            this.AL_Vendor_Details = new HashSet<AL_Vendor_Details>();
            this.AL_Booking_Sheet_Details = new HashSet<AL_Booking_Sheet_Details>();
        }

        public State EntityState { get; set; }
        public int Extended_Group_Code { get; set; }
        public string Group_Name { get; set; }
        public string Short_Name { get; set; }
        public Nullable<int> Group_Order { get; set; }
        public string Add_Edit_Type { get; set; }
        public Nullable<int> Module_Code { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public string IsActive { get; set; }

        public virtual ICollection<Extended_Group_Config> Extended_Group_Config { get; set; }
        public virtual ICollection<AL_Vendor_Details> AL_Vendor_Details { get; set; }
        public virtual ICollection<AL_Booking_Sheet_Details> AL_Booking_Sheet_Details { get; set; }
    }
}
