using Dapper;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL
{
    public class Channel_Repositories : MainRepository<Channel>
    {
        public IEnumerable<Channel> SearchFor(object param)
        {
            return base.SearchForEntity<Channel>(param);
        }
        public IEnumerable<Channel> GetAll()
        {
            return base.GetAll<Channel>();
        }
    }

    public class BMS_Schedule_Import_Config_Repositories : MainRepository<BMS_Schedule_Import_Config>
    {
        public IEnumerable<BMS_Schedule_Import_Config> SearchFor(object param)
        {
            return base.SearchForEntity<BMS_Schedule_Import_Config>(param);
        }
        public IEnumerable<BMS_Schedule_Import_Config> GetAll()
        {
            return base.GetAll<BMS_Schedule_Import_Config>();
        }        
    }

    public class BMSUploadData_Repositories : MainRepository<int>
    {        
        public int BMSUploadData(DataTable dt, string FileType, int ChannelCode)
        {
            Int32 BMS_Upload_Code = 0;
            var param = new DynamicParameters();
            param.Add("@UDT", dt.AsTableValuedParameter());
            param.Add("@FileType", FileType);
            param.Add("@ChannelCode", ChannelCode);
            var identity = base.ExecuteScalar("USP_BMS_Upload_Data", param);
            BMS_Upload_Code = Convert.ToInt32(identity);
            return BMS_Upload_Code;
        }
    }

}
