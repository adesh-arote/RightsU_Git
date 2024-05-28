using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.DAL
{
    public class ProcRepository
    {
        private readonly DBConnection dbConnection;
        public ProcRepository(string connectionStr)
        {
            this.dbConnection = new DBConnection(connectionStr);
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

    }
}
