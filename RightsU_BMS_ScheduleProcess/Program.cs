using RightsU_BMS_ScheduleProcess.Entities;
using RightsUMQService;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static RightsU_BMS_ScheduleProcess.Repository.MasterRepositories;

namespace RightsU_BMS_ScheduleProcess
{

    public class Program
    {
        public static void Main(string[] args)
        {
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);

            ChannelRepositories objChannelRepositories = new ChannelRepositories();
            Upload_FilesRepositories objUpload_FilesRepositories = new Upload_FilesRepositories();
            USP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories objUSP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories = new USP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories();
            USP_Music_ScheduleRepositories objUSP_Music_ScheduleRepositories = new USP_Music_ScheduleRepositories();

            var objSrch = new
            {
                Is_Active = "Y",
                IsUseForAsRun = "Y"
            };

            Error.WriteLog_Conditional("STEP 1.1  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Fetching Channel List.");
            List<Channel> lstChannel = new List<Channel>();
            lstChannel = objChannelRepositories.SearchFor(objSrch).ToList();
            Error.WriteLog_Conditional("STEP 1.2  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Channel List Count:"+ lstChannel.Count());


            foreach (var channel in lstChannel)
            {
                List<Upload_Files> lstUpload_Files = new List<Upload_Files>();

                var objSrchUploadFiles = new
                {
                    Upload_Type = "S",
                    Channel_Code = channel.Channel_Code
                };

                lstUpload_Files = objUpload_FilesRepositories.SearchFor(objSrchUploadFiles).ToList();

                foreach (var upload_Files in lstUpload_Files)
                {
                    objUSP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories.USP_BMS_Schedule1_Validate_Temp_BV_Schedule(upload_Files.File_Code, Convert.ToString(upload_Files.ChannelCode), null, null);
                }
            }

            Error.WriteLog_Conditional("STEP 1.3  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Calling Procedure USP_Music_Schedule");

            objUSP_Music_ScheduleRepositories.USP_Music_Schedule();

        }
    }
}
