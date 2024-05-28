using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Login_Details")]
    public class Login_Details
    {
        [PrimaryKey]
        public int? Login_Details_Code { get; set; }
        public Nullable<System.DateTime> Login_Time { get; set; }
        public Nullable<System.DateTime> Logout_Time { get; set; }
        public string Description { get; set; }
        public int Users_Code { get; set; }
        public int Security_Group_Code { get; set; }
    }
}
