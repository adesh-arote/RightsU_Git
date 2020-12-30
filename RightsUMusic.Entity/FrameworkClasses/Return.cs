using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public class Return
    {
        public string Message { get; set; }
        public bool IsSuccess { get; set; }
        //public int Code { get; set; }
        //public int UserCode { get; set; }
        public string Token { get; set; }
        public Nullable<int> SecurityGroupCode { get; set; }
        public string UserName { get; set; }
        public string IsSystemPassword { get; set; }

    }
}
