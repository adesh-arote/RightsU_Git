using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using RightsUMusic.DAL.Repository;
using RightsUMusic.Entity;

namespace RightsUMusic.BLL.Services
{
    public class DashboardManagementServices
    {
        private readonly USPMHGetPieChartDataRepositories objUSPMHGetPieChartDataRepositories = new USPMHGetPieChartDataRepositories();
        private readonly USPMHGetBarChartDataRepositories objUSPMHGetBarChartDataRepositories = new USPMHGetBarChartDataRepositories();
        private readonly USPMHGetLabelWiseUsageRepositories objUSPMHGetLabelWiseUsageRepositories = new USPMHGetLabelWiseUsageRepositories();

        public IEnumerable<USPMHGetPieChartData> GetPieChartData(int UsersCode,int NoOfMonths)
        {
            var lstPieChartData = objUSPMHGetPieChartDataRepositories.GetPieChartData(UsersCode,NoOfMonths);
            return lstPieChartData;
        }

        public IEnumerable<USPMHGetBarChartData> GetBarChartData(int UsersCode,int NoOfMonths)
        {
            var lstBarChartData = objUSPMHGetBarChartDataRepositories.GetBarChartData(UsersCode,NoOfMonths);
            return lstBarChartData;
        }

        public IEnumerable<USPMHGetLabelWiseUsage> GetLabelWiseUsage(int UsersCode,string LabelName,string ShowName,int NoOfMonths)
        {
            var lstLabelWiseUsageData = objUSPMHGetLabelWiseUsageRepositories.GetLabelWiseUsage(UsersCode, LabelName, ShowName, NoOfMonths);
            return lstLabelWiseUsageData;
        }

    }
}
