using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class Banner
    {
        [JsonIgnore]
        public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Banner_Code { get; set; }
        [JsonProperty(Order = 1)]
        public string Banner_Name { get; set; }
        [JsonProperty(Order = 2)]
        public string Banner_Short_Name { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 3)]
        public string Inserted_By_User { get; set; }
        [JsonProperty(Order = 4)]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonProperty(Order = 5)]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 6)]
        public string Last_Action_By_User { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
    }
}
