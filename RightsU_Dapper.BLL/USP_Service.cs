//using EntityFrameworkExtras.EF6;
//using RightsU_DAL;
//using RightsU_Entities;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.DAL.Repository;
using System;
using System.Collections.Generic;
//using System.Data.Entity.Core.Objects;

namespace RightsU_Dapper.BLL.Services
{
    /// <summary>
    /// Calls Stored Procedure _test
    /// </summary>
    /// <param name="Acq_Deal_Code"></param>
    /// <returns></returns>
    public class USP_Service
    {
      USP_Repositories objUSP_Repository = new USP_Repositories();
        public virtual string USP_MODULE_RIGHTS(Nullable<int> module_Code, Nullable<int> security_Group_Code, Nullable<int> users_Code)
        {
            return objUSP_Repository.USP_MODULE_RIGHTS(module_Code, security_Group_Code, users_Code);
        }
        public IEnumerable<string> USP_Validate_Talent_Master(Nullable<int> talent_Code, string selected_Role_Code)
        {
            return objUSP_Repository.USP_Validate_Talent_Master(talent_Code, selected_Role_Code);
        }

    }
}

