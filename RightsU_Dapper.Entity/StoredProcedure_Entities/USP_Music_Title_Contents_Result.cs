using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    public partial class USP_Music_Title_Contents_Result
    {
        public string Content { get; set; }
        public int Episode_No { get; set; }
        public string Title_Name { get; set; }
        public decimal Duration_In_Min { get; set; }
        public Nullable<System.TimeSpan> From { get; set; }
        public Nullable<System.TimeSpan> To { get; set; }
        public Nullable<System.TimeSpan> Duration { get; set; }
        public int From_Frame { get; set; }
        public int To_Frame { get; set; }
    }
}
