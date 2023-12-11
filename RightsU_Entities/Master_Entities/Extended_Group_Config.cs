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
        public int Extended_Group_Config_Code { get; set; }
        public Nullable<int> Extended_Group_Code { get; set; }
        [JsonIgnore]
        public Nullable<int> Columns_Code { get; set; }
        [NotMapped]
        public string Columns_Name { get; set; }
        public Nullable<int> Group_Control_Order { get; set; }
        public string Validations { get; set; }
        public string Additional_Condition { get; set; }
        public string Inter_Group_Name { get; set; }
        public string Display_Name { get; set; }
        public string Allow_Import { get; set; }
        public string Is_Active { get; set; }
        public string Target_Table { get; set; }
        public string Target_Column { get; set; }
        public string Default_Value { get; set; }

        [JsonIgnore]
        public virtual Extended_Columns Extended_Columns { get; set; }
        [JsonIgnore]
        public virtual Extended_Group Extended_Group { get; set; }
    }
}
