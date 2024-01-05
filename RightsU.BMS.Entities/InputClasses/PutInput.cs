using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.InputClasses
{
    public class PutInput
    {
        /// <summary>
        /// Asset id
        /// </summary>
        public Int32 id { get; set; }
        /// <summary>
        /// Active/Deactive Status of Asset , e.g. 'Y' for Activate and 'N' for Deactivate
        /// </summary>
        public string Status { get; set; }
    }
}
