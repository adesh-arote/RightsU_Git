using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_LoadSheet_Export.Entities
{
    [Table("AL_Load_Sheet_Details")]
    public partial class AL_Load_Sheet_Details
    {
        [PrimaryKey]
        public int? AL_Load_Sheet_Details_Code { get; set; }
        [ForeignKeyReference(typeof(AL_Load_Sheet))]
        public Nullable<int> AL_Load_Sheet_Code { get; set; }
        public Nullable<int> AL_Booking_Sheet_Code { get; set; }

        //public virtual AL_Booking_Sheet AL_Booking_Sheet { get; set; }
        //public virtual AL_Load_Sheet AL_Load_Sheet { get; set; }
    }
}
