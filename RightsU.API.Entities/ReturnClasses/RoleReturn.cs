using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;

namespace RightsU.API.Entities.ReturnClasses
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
