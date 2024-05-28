using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_LoadSheet_Export.Entities
{
    [Table("AL_Recommendation")]
    public class AL_Recommendation
    {
        [PrimaryKey]
        public int? AL_Recommendation_Code { get; set; }
        [ForeignKeyReference(typeof(AL_Proposal))]
        public int AL_Proposal_Code { get; set; }
        public Nullable<System.DateTime> Start_Date { get; set; }
        public Nullable<System.DateTime> End_Date { get; set; }
        public int Refresh_Cycle_No { get; set; }
        public int Version_No { get; set; }
        public string Finally_Closed { get; set; }
        public string Remarks { get; set; }
        public string Workflow_status { get; set; }
        public int Workflow_Code { get; set; }
        public string Excel_File { get; set; }
        public string PDF_File { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public int Last_Action_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public string Lock_Time { get; set; }
        [OneToMany]
        public List<AL_Recommendation_Content> AL_Recommendation_Content { get; set; }
    }
}
