using System;
using System.Collections.Generic;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Deal_Tag")]
    public partial class Deal_Tag
    {
        [PrimaryKey]
        [Column("Business_Unit_Code")]
        public int? business_unit_id { get; set; }

        [Column("Deal_Tag_Description")]
        public string deal_tag_description { get; set; }

        [Column("Deal_Flag")]
        public string deal_flag { get; set; }
    }
}
