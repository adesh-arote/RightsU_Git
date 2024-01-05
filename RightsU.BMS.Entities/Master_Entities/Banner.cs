using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Banner")]
    public partial class Banner
    {
        [JsonIgnore]
        public State EntityState { get; set; }     
        [PrimaryKey]
        public int? Banner_Code { get; set; }        
        public string Banner_Name { get; set; }
        public string Banner_Short_Name { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public string Inserted_By_User { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Last_Action_By_User { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
    }
}
