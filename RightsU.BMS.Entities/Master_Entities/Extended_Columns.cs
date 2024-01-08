using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Extended_Columns")]
    public partial class Extended_Columns
    {
        public Extended_Columns()
        {
            this.Extended_Group_Config = new HashSet<Extended_Group_Config>();            
        }
                
        [PrimaryKey]
        [Column("Columns_Code")]
        public int? columns_id { get; set; }

        [Column("Columns_Name")]
        public string columns_name { get; set; }

        [JsonIgnore]
        public string Control_Type { get; set; }
        [JsonIgnore]
        public string Is_Ref { get; set; }
        [JsonIgnore]
        public string Is_Defined_Values { get; set; }
        [JsonIgnore]
        public string Is_Multiple_Select { get; set; }
        [JsonIgnore]
        public string Ref_Table { get; set; }
        [JsonIgnore]
        public string Ref_Display_Field { get; set; }
        [JsonIgnore]
        public string Ref_Value_Field { get; set; }
        [JsonIgnore]
        public string Additional_Condition { get; set; }
        [JsonIgnore]
        public string Is_Add_OnScreen { get; set; }

        [JsonIgnore]
        [OneToMany]
        [SimpleSaveIgnore]
        public virtual ICollection<Extended_Group_Config> Extended_Group_Config { get; set; }        
    }
}
