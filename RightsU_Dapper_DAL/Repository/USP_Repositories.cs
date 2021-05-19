using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
using System.Threading.Tasks;
//using RightsU_Entities;
//using System.Data.Entity.Core.Objects;
//using System.Data.Entity.Infrastructure;


namespace RightsU_Dapper.DAL.Repository
{
    /// <summary>
    /// This class creates an instance of DBContext and calls database stored procedures
    /// </summary>
    ///
    public class USP_Repositories : ProcRepository
    {
        //private readonly DBConnection dbConnection;
        //public MainRepository()
        //{
        //    this.dbConnection = new DBConnection();
        //}
        public string USP_MODULE_RIGHTS(Nullable<int> module_Code, Nullable<int> security_Group_Code, Nullable<int> users_Code)
        {
            var param = new DynamicParameters();

            param.Add("@Module_Code", module_Code);
            param.Add("@Security_Group_Code", security_Group_Code);
            param.Add("@Users_Code", users_Code);

            string Result = base.ExecuteScalar("USP_MODULE_RIGHTS", param);
            return Result;

        }
        public IEnumerable<string> USP_Validate_Talent_Master(Nullable<int> talent_Code, string selected_Role_Code)
        {
            var param = new DynamicParameters();

            param.Add("@Talent_Code", talent_Code);
            param.Add("@Selected_Role_Code", selected_Role_Code);
            IEnumerable<string> Result = base.ExecuteSQLProcedure<string>("USP_Validate_Talent_Master", param);
            return Result;
        }
    }
}
