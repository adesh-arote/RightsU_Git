using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Program")]
    public partial class Program
    {
        [PrimaryKey]
        //[Column("Program_Code")]
        [JsonProperty(PropertyName = "program_id")]
        public int? Program_Code { get; set; }

        //[Column("Program_Name")]
        [JsonProperty(PropertyName = "program_name")]
        public string Program_Name { get; set; }

        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Deal_Type_Code { get; set; }
        [JsonIgnore]        
        public Nullable<int> Genres_Code { get; set; }
        [JsonIgnore]
        public string Is_Active { get; set; }        
    }
    
}
