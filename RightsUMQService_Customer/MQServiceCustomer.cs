using RightsUMQService;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMQService_Customer
{
    partial class MQServiceCustomer : ServiceBase
    {
        //public System.Timers.Timer timeDelay;
        //int count;
        public System.Timers.Timer timer = new System.Timers.Timer();
        public MQServiceCustomer()
        {
            InitializeComponent();
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);
            //timeDelay = new System.Timers.Timer();
            //timeDelay.Elapsed += new System.Timers.ElapsedEventHandler(WorkProcess);
        }
        //public void WorkProcess(object sender, System.Timers.ElapsedEventArgs e)
        //{
        //    string process = "Timer Tick " + count;
        //    LogService(process);
        //    count++;
        //}
        protected override void OnStart(string[] args)
        {
            timer.Interval = Convert.ToInt32(ConfigurationSettings.AppSettings["Timer"]);
            timer.Elapsed += new System.Timers.ElapsedEventHandler(this.OnTimer);
            timer.Start();
        }
        protected override void OnStop()
        {
            Error.WriteLog("Service Stoped", includeTime: true, addSeperater: true);
            // LogService("Service Stoped" + System.DateTime.Now);
            // timeDelay.Enabled = false;
        }
        public void OnTimer(object sender, System.Timers.ElapsedEventArgs args)
        {
            // LogService("this is testing timer has started" + System.DateTime.Now);
            timer.Stop();
            Error.WriteLog("EXE Started", includeTime: true, addSeperater: true);
            try
            {
                Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connecting to database");
                using (var context = new RightsU_PlusEntities())
                {
                    Error.WriteLog_Conditional("STEP 1 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connected to database", addSeperater: true);
                    Error.WriteLog_Conditional("STEP 2 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Fetching MQ Config Data");
                    List<MQ_Config> lst = context.MQ_Config.Where(x => x.Config_Type == "CUS").OrderBy(x => x.Execution_Order).ToList();
                    Error.WriteLog_Conditional("STEP 2 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Fetched MQ Config Data");
                    if (lst.Count > 0)
                    {
                        Error.WriteLog_Conditional("STEP 3 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Found MQ Config Data", addSeperater: true);
                        foreach (MQ_Config item in lst)
                        {
                            if (item.Config_For == "I" && item.Config_Type == "CUS")
                                Process_Customer_Data(item);
                        }
                    }
                    else
                    {
                        Error.WriteLog_Conditional("STEP 3 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : No record found in MQ Config", addSeperater: true);
                    }
                }
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
        private void LogService(string content)
        {
            FileStream fs = new FileStream(@"d:\TestServiceLog.txt", FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter sw = new StreamWriter(fs);
            sw.BaseStream.Seek(0, SeekOrigin.End);
            sw.WriteLine(content);
            sw.Flush();
            sw.Close();
        }
        public static void Process_Customer_Data(MQ_Config mq_Config)
        {
            using (var context = new RightsU_PlusEntities())
            {
                string strQueueManagerName, strQueueName, strChannelInfo, strReturnMessage, strRead, strWrite, response_Text;
                MQTest myMQ_Read = new MQTest();

                strQueueManagerName = mq_Config.MQ_Manager;
                strQueueName = mq_Config.MQ_Name;
                strChannelInfo = mq_Config.MQ_Channel;

                Error.WriteLog_Conditional("STEP 4 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connection Parameters 'MQ_Manager : " + strQueueManagerName
                    + "', 'MQ_Name : " + strQueueName + "', 'MQ_Channel : " + strChannelInfo + "'");

                Error.WriteLog_Conditional("STEP 4 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connecting to MQ");
                strReturnMessage = myMQ_Read.ConnectMQ(strQueueManagerName, strQueueName, strChannelInfo);
                Error.WriteLog_Conditional("STEP 4 C : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connection Status : " + strReturnMessage, addSeperater: true);

                if (!strReturnMessage.Substring(0, 9).ToUpper().Equals("EXCEPTION"))
                {
                    Error.WriteLog_Conditional("STEP 5 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Executing ReadMsg() method of MQ");
                    strRead = myMQ_Read.ReadMsg();
                    Error.WriteLog_Conditional("STEP 5 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Executed ReadMsg() method of MQ");
                    Error.WriteLog_Conditional("STEP 5 C : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Message from Queue : " + strRead, addSeperater: true);

                    if (!strRead.Substring(0, 9).ToUpper().Equals("EXCEPTION"))
                    {
                        Error.WriteLog_Conditional("STEP 6 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Executing USP_MQ_Vendor_CRUD");
                        var MQ_RU_Response = context.USP_MQ_Customer_CRUD(strRead, mq_Config.MQ_Config_Code);

                        Error.WriteLog_Conditional("STEP 6 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Executed USP_MQ_Vendor_CRUD");
                        try
                        {
                            strQueueManagerName = strQueueName = strChannelInfo = string.Empty;
                            response_Text = MQ_RU_Response.ElementAt(0);
                            Error.WriteLog_Conditional("STEP 6 C : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Response Text : " + response_Text, addSeperater: true);
                            Error.WriteLog_Conditional("STEP 7 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Fetching MQ Config Data");

                            var Input = context.MQ_Config.Where(x => x.Config_For == "O" && x.Config_Type == "CUS").FirstOrDefault();
                            Error.WriteLog_Conditional("STEP 7 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Fetched MQ Config Data", addSeperater: true);
                            MQTest myMQ_Write = new MQTest();
                            strQueueManagerName = Input.MQ_Manager;
                            strQueueName = Input.MQ_Name;
                            strChannelInfo = Input.MQ_Channel;

                            Error.WriteLog_Conditional("STEP 8 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connection Parameters 'MQ_Manager : " + strQueueManagerName
                                + "', 'MQ_Name : " + strQueueName + "', 'MQ_Channel : " + strChannelInfo + "'");

                            strReturnMessage = string.Empty;

                            Error.WriteLog_Conditional("STEP 8 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connecting to MQ");
                            strReturnMessage = myMQ_Write.ConnectMQ(strQueueManagerName, strQueueName, strChannelInfo);
                            Error.WriteLog_Conditional("STEP 8 C : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connection Status : " + strReturnMessage, addSeperater: true);

                            if (!strReturnMessage.Substring(0, 9).ToUpper().Equals("EXCEPTION"))
                            {
                                Error.WriteLog_Conditional("STEP 9 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Executing WriteMsg() method of MQ");
                                strWrite = myMQ_Write.WriteMsg(response_Text);
                                Error.WriteLog_Conditional("STEP 9 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Executed WriteMsg() method of MQ");
                                Error.WriteLog_Conditional("STEP 9 C : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Write Output : " + strWrite, addSeperater: true);
                            }
                        }
                        catch (Exception ex)
                        {
                            StringBuilder sb = new StringBuilder("Found Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            while (ex.InnerException != null)
                            {
                                ex = ex.InnerException;
                                sb.Append(" || Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            }

                            Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
                        }
                    }
                }
            }
        }
    }
}
