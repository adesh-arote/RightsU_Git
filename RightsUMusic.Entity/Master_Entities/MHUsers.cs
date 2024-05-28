using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("MHUsers")]
    public partial class MHUsers
    {
        [PrimaryKey]
        public int? MHUsersCode { get; set; }
        public int Users_Code { get; set; }
        public int Vendor_Code { get; set; }
    }
}
