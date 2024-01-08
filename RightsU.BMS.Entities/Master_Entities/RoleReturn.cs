using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class RoleReturn : ListReturn
    {
        public RoleReturn()
        {
            assets = new List<Role>();
            paging = new paging();
        }

        /// <summary>
        /// Role Details
        /// </summary>
        public override object assets { get; set; }
    }
 
    //public class roles
    //{
    //    public int id { get; set; }
    //    public string RoleName { get; set; }
    //    public string RoleType { get; set; }
    //    public string DealType { get; set; }

    //}
}
