using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.DAL.Infrastructure
{
    public class ProcRepository
    {
        private readonly DBConnection dbConnection;
        public ProcRepository()
        {
            this.dbConnection = new DBConnection();
        }
        public IEnumerable<T> ExecuteSQLStmt<T>(string query)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                int queryTimeoutInSeconds = 120;
                var list = SqlMapper.Query<T>(connection, query, null, commandTimeout: queryTimeoutInSeconds, commandType: CommandType.Text);
                connection.Close();
                return (IEnumerable<T>)list.ToList();
            }
        }
        public IEnumerable<T> ExecuteSQLProcedure<T>(string query, DynamicParameters param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                int queryTimeoutInSeconds = 120;
                var list = SqlMapper.Query<T>(connection, query, param, commandTimeout: queryTimeoutInSeconds, commandType: CommandType.StoredProcedure);
                connection.Close();
                return (IEnumerable<T>)list.ToList();
            }
        }
        public string ExecuteScalar(string query, DynamicParameters param)
        {
            using (var connection = dbConnection.Connection())
            {
                connection.Open();
                int queryTimeoutInSeconds = 120;
                var result = SqlMapper.ExecuteScalar(connection, query, param, commandTimeout: queryTimeoutInSeconds, commandType: CommandType.StoredProcedure);
                connection.Close();
                return result.ToString();
            }
        }

        //public string ExecuteSqlInlineFunction()
        //{
        //    using (var connection = dbConnection.Connection())
        //    {
        //        connection.Open();
        //        int queryTimeoutInSeconds = 120;
        //        var param = new DynamicParameters();
        //        param.Add("@Prefix", "A");
        //        param.Add("@date", System.DateTime.Now);
        //        param.Add("@MasterDealCode", 0);
        //        string query = "UFN_Auto_Genrate_Agreement_No";
        //        var result = connection.Query<string>("Select [dbo].[UFN_Auto_Genrate_Agreement_No](@Prefix, @date, @MasterDealCode)"
        //            , param, commandType: CommandType.Text).FirstOrDefault();
        //        //var result = SqlMapper.ExecuteScalar(connection, query, param, commandTimeout: queryTimeoutInSeconds, commandType: CommandType.StoredProcedure);
        //        connection.Close();
        //        return result.ToString();
        //    }
        //}
    }
}
