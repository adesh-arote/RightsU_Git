using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_LoadSheet_Export_CA.Entities
{
    [Table("AL_Proposal")]
    public class AL_Proposal
    {
        [PrimaryKey]
        public int? AL_Proposal_Code { get; set; }
        public int Vendor_Code { get; set; }
        public Nullable<System.DateTime> Start_Date { get; set; }
        public Nullable<System.DateTime> End_Date { get; set; }
        public string Proposal_No { get; set; }
        public string Version_No { get; set; }
        public int Refresh_Cycle { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public string Last_Action_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public string Lock_Time { get; set; }
        [OneToMany]
        public List<AL_Recommendation> AL_Recommendation { get; set; }

        //[OneToMany]
        //public List<AL_Proposal_Rule> AL_Proposal_Rule { get; set; }
    }
}
