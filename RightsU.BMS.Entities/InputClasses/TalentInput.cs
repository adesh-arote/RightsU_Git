using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.InputClasses
{
    public class TalentInput
    {
        public Int32 id { get; set; }
        public string TalentName { get; set; }
        public string Gender { get; set; }
        public List<Role1> Role { get; set; }
    }
    public class Role1
    {
        public Int32 id { get; set; }
        public Int32 RoleId { get; set; }
    }
}
