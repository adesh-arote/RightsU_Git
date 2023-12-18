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

    public partial class Extended_Group_Config
    {
        [JsonIgnore]
        public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Extended_Group_Config_Code { get; set; }
        [JsonProperty(Order = 1)]
        public Nullable<int> Extended_Group_Code { get; set; }
        [JsonIgnore]
        public Nullable<int> Columns_Code { get; set; }
        [NotMapped]
        [JsonProperty(Order = 2)]
        public string Columns_Name { get; set; }
        [JsonProperty(Order = 3)]
        public Nullable<int> Group_Control_Order { get; set; }
        [JsonProperty(Order = 4)]
        public string Validations { get; set; }
        [JsonProperty(Order = 5)]
        public string Additional_Condition { get; set; }
        [JsonProperty(Order = 6)]
        public string Inter_Group_Name { get; set; }
        [JsonProperty(Order = 7)]
        public string Display_Name { get; set; }
        [JsonProperty(Order = 8)]
        public string Allow_Import { get; set; }
        [JsonProperty(Order = 9)]
        public string Is_Active { get; set; }
        [JsonProperty(Order = 10)]
        public string Target_Table { get; set; }
        [JsonProperty(Order = 11)]
        public string Target_Column { get; set; }
        [JsonProperty(Order = 12)]
        public string Default_Value { get; set; }

        [JsonIgnore]
        public virtual Extended_Columns Extended_Columns { get; set; }
        [JsonIgnore]
        public virtual Extended_Group Extended_Group { get; set; }
    }
}
