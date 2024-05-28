
using RightsU_HealthCheckup;
using RightsU_HealthCheckup.Model;
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

namespace RightsU_Health_Checkup
{
    public partial class RightsU_Health_Checkup : ServiceBase
    {
        public static int CS_Count = Convert.ToInt32(ConfigurationSettings.AppSettings["CS_Count"]);
        static string Server = Convert.ToString(ConfigurationSettings.AppSettings["Server"]);

        public System.Timers.Timer timer = new System.Timers.Timer();
        public RightsU_Health_Checkup()
        {
            InitializeComponent();
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);
        }
        protected override void OnStart(string[] args)
        {
            timer.Interval = Convert.ToInt32(ConfigurationSettings.AppSettings["Timer"]);
            timer.Elapsed += new System.Timers.ElapsedEventHandler(this.OnTimer);
            timer.Start();
            // TODO: Add code here to start your service.
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
                List<RightsU_HC> lstRightsU_HC = new List<RightsU_HC>();
                if (Server != "APP")
                {
                    for (int i = 1; i <= CS_Count; i++)
                    {
                        List<RightsU_HC> Temp_HC = System_Machine.USP_StoreProcedure<RightsU_HC>("CS" + i.ToString(), "USP_RightsU_Health_Checkup", i);
                        lstRightsU_HC.AddRange(Temp_HC);
                    }
                }
                Error.WriteLog_Conditional("STEP 2  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : calling  Create_Mail_Body_For_Application");
                Create_Mail_Body_For_Application(lstRightsU_HC);
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
        public static void Create_Mail_Body_For_Application(List<RightsU_HC> lstRightsU_HC)
        {
            string emailHead = System_Mail.EmailHead();
            string emailFooter = System_Mail.EmailFooter();
            //------------------------------------------------------------------------------------------

            string IIS_Service_State = System_Machine.Services(Convert.ToString(ConfigurationSettings.AppSettings["IIS_Service"]));
            string SSRS_Service_State = System_Machine.Services(Convert.ToString(ConfigurationSettings.AppSettings["SSRS_Service"]));
            string SQL_Service_State = System_Machine.Services(Convert.ToString(ConfigurationSettings.AppSettings["SQL_Service"]));
            string SQL_Agent_Service = System_Machine.Services(Convert.ToString(ConfigurationSettings.AppSettings["SQL_Agent_Service"]));
            //------------------------------------------------------------------------------------------

            string WindowsService = Convert.ToString(ConfigurationSettings.AppSettings["WindowsService"]);
            string WindowsService_Display_Name = Convert.ToString(ConfigurationSettings.AppSettings["WindowsService_Display_Name"]);
            //------------------------------------------------------------------------------------------

            Error.WriteLog_Conditional("STEP 3   : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : getting all services");
            emailHead = emailHead + System_Mail.ParagraphTag("Database Services Status");
            emailHead = emailHead + System_Mail.ServiceSection_One(IIS_Service_State, SSRS_Service_State, SQL_Service_State, SQL_Agent_Service, Server);
            Error.WriteLog_Conditional("STEP 4   : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : ServiceSection_One");
            //------------------------------------------------------------------------------------------

            if (WindowsService != "" && WindowsService_Display_Name != "")
            {
                emailHead = emailHead + System_Mail.ParagraphTag("RightsU Windows Services Status");
                emailHead = emailHead + System_Machine.ServiceSection_Two(WindowsService, WindowsService_Display_Name);
                Error.WriteLog_Conditional("STEP 5   : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Windows service name successful");
            }
            //------------------------------------------------------------------------------------------

            List<HardDisk> lstHardDisks = System_Machine.CPU_Utlization();
            emailHead = emailHead + System_Mail.ParagraphTag("Hard Disk");
            string[] arrHD = { "Drive Name", "Total Size", "Available Space", "Used Space" };
            
            foreach (HardDisk item in lstHardDisks)
            {
                Error.WriteLog_Conditional("STEP 5.1   : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : "+ item.TotalFreeSpace +"=="+ item.TotalSize);
                int percentComplete = (int)Math.Round((double)(100 * Convert.ToDouble(item.TotalFreeSpace.TrimEnd('M', 'G', 'B', 'T'))) / Convert.ToDouble(item.TotalSize.TrimEnd('M', 'G', 'B', 'T')));

                if (percentComplete < 70)
                    item.ColorAFS = "1FC600";
                else if (percentComplete > 70)
                    item.ColorAFS = "F8BA00";
                else if (percentComplete >= 90)
                    item.ColorAFS = "red";

            }

            emailHead = emailHead + System_Mail.getHtmlTable<HardDisk>(lstHardDisks, null, arrHD);
            Error.WriteLog_Conditional("STEP 6   : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : System_Machine.CPU_Utlization");
            //------------------------------------------------------------------------------------------
            if (Server != "DB")
            {
                string AppDetails = Convert.ToString(ConfigurationSettings.AppSettings["RightsU_Application"]);
                List<App_Details> lstApp_Details = System_Machine.ApplicationDetails(AppDetails);

                emailHead = emailHead + System_Mail.ParagraphTag("Application Details");
                string[] arrAD = { "Application Name", "Application Size", "Application Path" };

                emailHead = emailHead + System_Mail.getHtmlTable<App_Details>(lstApp_Details, null, arrAD);
            }


            //------------------------------------------------------------------------------------------
            Error.WriteLog_Conditional("STEP 7   : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : getHtmlTable<HardDisk>");
            List<string> lstTypes = lstRightsU_HC.Select(x => x.Type).Distinct().ToList();
            foreach (string item in lstTypes)
            {
                List<RightsU_HC> rightsU_HCs = lstRightsU_HC.Where(x => x.Type == item && x.SrNo != 1).ToList();
                RightsU_HC objRightsU_HC = lstRightsU_HC.Where(x => x.Type == item && x.SrNo == 1).FirstOrDefault();

                string displayName = Convert.ToString(ConfigurationSettings.AppSettings[objRightsU_HC.Type]);

                emailHead = emailHead + System_Mail.ParagraphTag(displayName, rightsU_HCs.Count > 0 ? false : true);

                if (rightsU_HCs.Count > 0)
                    emailHead = emailHead + System_Mail.getHtmlTable<RightsU_HC>(rightsU_HCs, objRightsU_HC);
                else
                    emailHead = emailHead + "No Pending Deals <br></br>";
            }
            Error.WriteLog_Conditional("STEP 8   : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : lstRightsU_HC end of loop");
            //------------------------------------------------------------------------------------------

            string result = emailHead + emailFooter;

            //Error.WriteLog_Conditional(result);

            System_Machine.SendEmail("CS1", result, Convert.ToString(ConfigurationSettings.AppSettings["Subject"]),
               Convert.ToString(ConfigurationSettings.AppSettings["toMailId"]),
               Convert.ToString(ConfigurationSettings.AppSettings["ccMailId"]));

            Error.WriteLog_Conditional("STEP 9   : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : mail sent successfully");
        }
    }
}
