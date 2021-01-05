using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public class USPValidateMHRequestConsumption
    {
        public int MHRequestDetailsCode { get; set; }
        public string IsValid { get; set; }
        public string Message { get; set; }
    }
}
