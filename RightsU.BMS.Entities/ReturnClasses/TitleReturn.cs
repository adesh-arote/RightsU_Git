﻿using Newtonsoft.Json;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class TitleReturn : ListReturn
    {
        public TitleReturn()
        {
            content = new List<Title>();
            paging = new paging();
        }

        /// <summary>
        /// Title Details
        /// </summary>
        public override object content { get; set; }
    }
}