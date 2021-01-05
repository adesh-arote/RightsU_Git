using RightsUMusic.DAL.Repository;
using RightsUMusic.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.BLL.Services
{
    public  class NotificationManagementServices
    {
            
        private readonly MHNotificationLogRepositories objMHNotificationLogRepositories = new MHNotificationLogRepositories();
        private readonly UserRepositories objUserRepositories = new UserRepositories();
        private readonly USPMHNotificationListRepositories objUSPMHNotificationListRepositories = new USPMHNotificationListRepositories();

        public IEnumerable<USPMHNotificationList> GetNotificationList(string RecordFor,int UserCode, out int _RecordCount)
        {
            return objUSPMHNotificationListRepositories.GetNotificationList(RecordFor, UserCode, out _RecordCount).ToList();
        }
        public MHNotificationLog ReadNotification(MHNotificationLog objMHNotificationLog)
        {
            objMHNotificationLog = objMHNotificationLogRepositories.Update(objMHNotificationLog);
            return objMHNotificationLog;
        }

        public MHNotificationLog GetByIdMHNotification(int MHNotificationLogCode)
        {
            List<MHNotificationLog> lstMHNotificationLog = new List<MHNotificationLog>();
            MHNotificationLog objMHNotificationLog = objMHNotificationLogRepositories.Get(Convert.ToInt32(MHNotificationLogCode));
            return objMHNotificationLog;
        }

        public IEnumerable<User> GetUserName(string strSearch)
        {
            var lstUser = objUserRepositories.GetDataWithSQLStmt(strSearch);
            return lstUser;
        }
    }
}
