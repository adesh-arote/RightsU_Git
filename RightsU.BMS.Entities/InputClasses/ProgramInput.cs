using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.InputClasses
{
    public class ProgramInput
    {
        public Int32 id { get; set; }
        public string ProgramName { get; set; }
        public int? DealTypeCode { get; set; }
        public int? GenresCode { get; set; }
    }
}
