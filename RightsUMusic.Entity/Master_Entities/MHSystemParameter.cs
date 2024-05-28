using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("System_Parameter_New")]
    public class MHSystemParameter
    {
        [PrimaryKey]
        public int ID { get; set; }
        public string Parameter_Name { get; set; }
        public string Parameter_Value { get; set; }
        public string IsActive { get; set; }
        //public string Remarks { get; set; }
    }
}
