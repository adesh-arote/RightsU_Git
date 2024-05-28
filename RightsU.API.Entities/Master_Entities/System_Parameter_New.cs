using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("System_Parameter_New")]
    public class System_Parameter_New
    {
        [PrimaryKey]
        public int ID { get; set; }
        public string Parameter_Name { get; set; }
        public string Parameter_Value { get; set; }
    }
}
