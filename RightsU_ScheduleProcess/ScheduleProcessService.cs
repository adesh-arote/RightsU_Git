using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using RightsU_ScheduleProcess.Entities;
using RightsU_ScheduleProcess.Repository;

namespace RightsU_ScheduleProcess
{
    public partial class ScheduleProcessService : ServiceBase
    {
        public System.Timers.Timer timer = new System.Timers.Timer();
        public ScheduleProcessService()
        {
            InitializeComponent();
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);
        }

        protected override void OnStart(string[] args)
        {
            timer.Interval = Convert.ToInt32(ConfigurationSettings.AppSettings["Timer"]);
            timer.Elapsed += new System.Timers.ElapsedEventHandler(this.OnTimer);
            timer.Start();
        }

        protected override void OnStop()
        {
            Error.WriteLog("Service Stoped", includeTime: true, addSeperater: true);
            // TODO: Add code here to perform any tear-down necessary to stop your service.
        }

        public void OnTimer(object sender, System.Timers.ElapsedEventArgs args)
        {
            timer.Stop();
            Error.WriteLog("EXE Started", includeTime: true, addSeperater: true);
            try
            {
                Process_Channel_Schedule();
            }
            catch (Exception ex)
            {
                StringBuilder sb = new StringBuilder("Found Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                    sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                }

                Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
            }
            finally
            {
                Error.WriteLog("EXE Ended", includeTime: true, addSeperater: true);
                timer.Start();
            }
        }

        private void Process_Channel_Schedule()
        {
            ChannelRepositories objChannelRepositories = new ChannelRepositories();
            Upload_FilesRepositories objUpload_FilesRepositories = new Upload_FilesRepositories();
            USP_BMS_Schedule_Neo_ValidateRepositories objUSP_BMS_Schedule_Neo_Validate = new USP_BMS_Schedule_Neo_ValidateRepositories();
            USP_BMS_Schedule_Neo_NotificationRepositories objUSP_BMS_Schedule_Neo_Notification = new USP_BMS_Schedule_Neo_NotificationRepositories();
            USP_Music_ScheduleRepositories objUSP_Music_ScheduleRepositories = new USP_Music_ScheduleRepositories();

            var objSrch = new
            {
                Is_Active = "Y",
                IsUseForAsRun = "Y"
            };

            Error.WriteLog_Conditional("STEP 1.1  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Fetching Channel List.");
            List<Channel> lstChannel = new List<Channel>();
            lstChannel = objChannelRepositories.SearchFor(objSrch).OrderBy(o => o.Order_For_schedule).ToList();
            Error.WriteLog_Conditional("STEP 1.2  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Channel List Count:" + lstChannel.Count());

            foreach (var channel in lstChannel)
            {
                try
                {
                    Error.WriteLog_Conditional("STEP 1.3  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Channel Name:" + channel.Channel_Name);
                    List<Upload_Files> lstUpload_Files = new List<Upload_Files>();

                    var objSrchUploadFiles_Schedule = new
                    {
                        Upload_Type = "S",
                        ChannelCode = channel.Channel_Code,
                        Record_Status = "P"
                    };

                    lstUpload_Files = objUpload_FilesRepositories.SearchFor(objSrchUploadFiles_Schedule).OrderBy(o => o.StartDate).ToList();
                    Error.WriteLog_Conditional("STEP 1.4  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : File Count for " + lstUpload_Files.Count + " for channel " + channel.Channel_Name);

                    foreach (var upload_Files in lstUpload_Files)
                    {
                        Error.WriteLog_Conditional("STEP 1.4.1  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Update wait state for File Code " + upload_Files.File_Code.ToString());
                        upload_Files.Record_Status = "W";
                        objUpload_FilesRepositories.Update(upload_Files);

                        Error.WriteLog_Conditional("STEP 1.4.2  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Execute USP_BMS_Schedule_Neo_Validate & Process for File Code " + upload_Files.File_Code.ToString());
                        objUSP_BMS_Schedule_Neo_Validate.USP_BMS_Schedule_Neo_Validate(upload_Files.File_Code.Value, Convert.ToString(upload_Files.ChannelCode), null, null);

                        Error.WriteLog_Conditional("STEP 1.4.3  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Process completed and update status Done for File Code " + upload_Files.File_Code.ToString());
                        upload_Files.Record_Status = "D";
                        objUpload_FilesRepositories.Update(upload_Files);
                    }

                    Error.WriteLog_Conditional("STEP 1.5  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Schedule Processing Completed for Channel - " + channel.Channel_Name);
                }
                catch (Exception ex)
                {
                    Error.WriteLog_Conditional("STEP 1.6  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Exception - " + ex.InnerException);
                }
            }

            Error.WriteLog_Conditional("STEP 1.7  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Calling USP_Music_Schedule Proc");
            objUSP_Music_ScheduleRepositories.USP_Music_Schedule();

            Error.WriteLog_Conditional("STEP 1.8  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Calling objUSP_BMS_Schedule_Neo_Notification Proc");
            objUSP_BMS_Schedule_Neo_Notification.USP_BMS_Schedule_Neo_Notification();
        }
    }
}
