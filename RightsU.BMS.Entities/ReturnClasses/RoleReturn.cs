using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class RoleReturn : ListReturn
    {
        public RoleReturn()
        {
            content = new List<Role>();
            paging = new paging();
        }

        /// <summary>
        /// Role Details
        /// </summary>
        public override object content { get; set; }
    }
}
