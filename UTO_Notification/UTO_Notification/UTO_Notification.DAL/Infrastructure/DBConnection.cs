using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.DAL
{
    class DBConnection
    {
        private static string ConnectionName;

        public DBConnection(string conStr)
        {
            ConnectionName = conStr; //ConfigurationManager.ConnectionStrings[1].Name; //"DTAppCon";
        }
        public SqlConnection Connection()
        {
            return new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionName].ConnectionString);
        }
    }
}
