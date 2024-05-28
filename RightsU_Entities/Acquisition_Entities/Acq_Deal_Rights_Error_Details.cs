using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Acq_Deal_Rights_Error_Details
    {
        public State EntityState { get; set; }
        public int Acq_Deal_Rights_Error_Details_Code { get; set; }
        public Nullable<int> Acq_Deal_Rights_Code { get; set; }
        public string Title_Name { get; set; }
        public string Platform_Name { get; set; }
        public Nullable<System.DateTime> Right_Start_Date { get; set; }
        public Nullable<System.DateTime> Right_End_Date { get; set; }
        public string Right_Type { get; set; }
        public string Is_Sub_License { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public string Country_Name { get; set; }
        public string Subtitling_Language { get; set; }
        public string Dubbing_Language { get; set; }
        public string Agreement_No { get; set; }
        public string ErrorMSG { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }
        public string Is_Updated { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
    }
}
