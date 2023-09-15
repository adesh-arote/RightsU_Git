using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_LoadSheet_Export.Entities
{
    [Table("AL_Booking_Sheet_Details")]
    public partial class AL_Booking_Sheet_Details
    {
        [PrimaryKey]
        public int AL_Booking_Sheet_Details_Code { get; set; }
        [ForeignKeyReference(typeof(AL_Booking_Sheet))]
        public Nullable<int> AL_Booking_Sheet_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Title_Content_Code { get; set; }
        public Nullable<int> Extended_Group_Code { get; set; }
        public Nullable<int> Columns_Code { get; set; }
        public Nullable<int> Group_Control_Order { get; set; }
        public string Validations { get; set; }
        public string Additional_Condition { get; set; }
        public string Display_Name { get; set; }
        public string Allow_Import { get; set; }
        public string Columns_Value { get; set; }
        public string Cell_Status { get; set; }
        public Nullable<int> Action_By { get; set; }
        public Nullable<System.DateTime> Action_Date { get; set; }
    }
}
