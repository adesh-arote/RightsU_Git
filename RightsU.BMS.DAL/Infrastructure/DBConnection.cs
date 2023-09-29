using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace RightsU.BMS.DAL
{
    class DBConnection
    {
        private static string ConnectionName;

        public DBConnection()
        {
            ConnectionName = ConfigurationManager.ConnectionStrings[1].Name; //"DTAppCon";
        }
        public SqlConnection Connection()
        {
            return new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionName].ConnectionString);
        }
    }
}
