using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Extended_Columns_Value")]
    public partial class Extended_Columns_Value
    {
        [PrimaryKey]
        //[Column("Columns_Value_Code")]
        [JsonProperty(PropertyName = "columns_value_id")]
        public int? Columns_Value_Code { get; set; }

        //[Column("Columns_Code")]
        [JsonProperty(PropertyName = "columns_id")]
        [JsonIgnore]
        public Nullable<int> Columns_Code { get; set; }

        //[Column("Columns_Value")]
        [JsonProperty(PropertyName = "columns_value")]
        public string Columns_Value { get; set; }

    }
}
