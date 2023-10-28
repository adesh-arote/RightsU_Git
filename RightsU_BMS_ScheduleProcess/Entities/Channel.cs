﻿using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BMS_ScheduleProcess.Entities
{
    [Table("Channel")]
    public class Channel
    {
        [PrimaryKey]
        public int Channel_Code { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Order_For_schedule { get; set; }
    }
}