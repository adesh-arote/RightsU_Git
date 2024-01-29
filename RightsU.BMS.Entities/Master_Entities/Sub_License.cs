using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Sub_License")]
    public partial class Sub_License
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "sub_license_id")]
        public int? Sub_License_Code { get; set; }
        [JsonProperty(PropertyName = "sub_license_name")]
        public string Sub_License_Name { get; set; }
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
    }
}
