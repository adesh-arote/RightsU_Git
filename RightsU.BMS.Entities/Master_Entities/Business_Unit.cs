using System;
using System.Collections.Generic;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Business_Unit")]
    public partial class Business_Unit
    {
        [PrimaryKey]
        [Column("Business_Unit_Code")]
        public int? business_unit_id { get; set; }

        [Column("Business_Unit_Name")]
        public string business_unit_name { get; set; }

        [Column("Is_Active")]
        public string is_active { get; set; }
    }
}
