using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_LoadSheet_Export.Entities
{
    [Table("AL_Booking_Sheet")]
    public partial class AL_Booking_Sheet
    {
        [PrimaryKey]
        public int AL_Booking_Sheet_Code { get; set; }
        public Nullable<int> AL_Recommendation_Code { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public string Booking_Sheet_No { get; set; }
        public Nullable<int> Version_No { get; set; }
        public Nullable<int> Movie_Content_Count { get; set; }
        public Nullable<int> Show_Content_Count { get; set; }
        public string Remarks { get; set; }
        public string Record_Status { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public string Excel_File { get; set; }
        [OneToMany]
        public virtual ICollection<AL_Booking_Sheet_Details> AL_Booking_Sheet_Details { get; set; }
        public virtual AL_Recommendation AL_Recommendation { get; set; }
        public virtual ICollection<AL_Load_Sheet_Details> AL_Load_Sheet_Details { get; set; }
    }
}
