﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations.Schema;
    public partial class Event_Template_Keys
    {
        public Event_Template_Keys()
        {
            this.Email_Config_Keys = new HashSet<Email_Config_Keys>();
        }

        public State EntityState { get; set; }
        public int Event_Template_Keys_Code { get; set; }
        public string Key_Name { get; set; }
        public string Is_Active { get; set; }

        public virtual ICollection<Email_Config_Keys> Email_Config_Keys { get; set; }
    }
}