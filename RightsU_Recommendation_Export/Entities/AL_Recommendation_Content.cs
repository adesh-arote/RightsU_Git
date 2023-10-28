using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Recommendation_Export.Entities
{
    [Table("AL_Recommendation_Content")]
    public class AL_Recommendation_Content
    {
        [PrimaryKey]
        public int? AL_Recommendation_Content_Code { get; set; }
        [ForeignKeyReference(typeof(AL_Recommendation))]
        public int AL_Recommendation_Code { get; set; }
        public int AL_Vendor_Rule_Code { get; set; }
        public int Title_Code { get; set; }
        public int Title_Content_Code { get; set; }
        public string Content_Type { get; set; }
        public string Content_Status { get; set; }
    }
}
