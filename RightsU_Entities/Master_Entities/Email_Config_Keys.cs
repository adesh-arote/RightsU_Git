using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class Email_Config_Keys
    {
        public State EntityState { get; set; }
        public int Email_Config_Keys_Code { get; set; }
        public Nullable<int> Email_Config_Code { get; set; }
        public Nullable<int> Event_Template_Keys_Code { get; set; }

        public virtual Email_Config Email_Config { get; set; }
        public virtual Event_Template_Keys Event_Template_Keys { get; set; }
    }
}
