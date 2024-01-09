using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;

namespace RightsU.BMS.Entities.Master_Entities
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
