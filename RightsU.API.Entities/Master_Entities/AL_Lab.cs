using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("AL_Lab")]
    public partial class AL_Lab
    {        
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
        [PrimaryKey]
        [Column("AL_Lab_Code")]
        public int? AL_Lab_id { get; set; }
        public string AL_Lab_Name { get; set; }
        public string AL_Lab_Short_Name { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string Inserted_By_User { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string Last_Action_By_User { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public string Contact_Person { get; set; }        
    }
}
