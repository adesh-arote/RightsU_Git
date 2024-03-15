
using Dapper;
using RightsU_ScheduleProcess.Entities;
using RightsU_ScheduleProcess.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_ScheduleProcess.Repository
{
    public class ChannelRepositories : MainRepository<Channel>
    {
        public IEnumerable<Channel> SearchFor(object param)
        {
            return base.SearchForEntity<Channel>(param);
        }
    }

    public class Upload_FilesRepositories : MainRepository<Upload_Files>
    {
        public Upload_Files GetUpload_FilesById(int Id)
        {
            var obj = new { File_Code = Id };

            return base.GetById<Upload_Files>(obj);
        }

        public IEnumerable<Upload_Files> SearchFor(object param)
        {
            return base.SearchForEntity<Upload_Files>(param);
        }

        public void Update(Upload_Files entity)
        {
            Upload_Files oldObj = GetUpload_FilesById(entity.File_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

    }

    public class USP_BMS_Schedule_Neo_ValidateRepositories : MainRepository<dynamic>
    {
        public void USP_BMS_Schedule_Neo_Validate(int File_Code, string Channel_Code, string IsReprocess, string BV_Episode_ID)
        {
            var param = new DynamicParameters();
            param.Add("@File_Code", File_Code);
            param.Add("@Channel_Code", Channel_Code);
            param.Add("@IsReprocess", IsReprocess);
            param.Add("BV_Episode_ID", BV_Episode_ID);
            base.ExecuteSQLProcedure<dynamic>("USP_BMS_Schedule_Neo_Validate", param);
        }
    }

    public class USP_Music_ScheduleRepositories : MainRepository<dynamic>
    {
        public void USP_Music_Schedule()
        {
            var param = new DynamicParameters();
            base.ExecuteSQLProcedure<dynamic>("USP_Music_Schedule", param);
        }
    }

    public class USP_BMS_Schedule_Neo_NotificationRepositories : MainRepository<dynamic>
    {
        public void USP_BMS_Schedule_Neo_Notification()
        {
            var param = new DynamicParameters();
            base.ExecuteSQLProcedure<dynamic>("USP_BMS_Schedule_Neo_Notification", param);
        }
    }
}
