using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using RightsU_BLL;
using RightsU_Entities;
using System.Data.Entity.Core.Objects;
using RightsU_Plus.MSM_SAP_WS;
using UTOFrameWork.FrameworkClasses;

public class CommonUtil
{
    public void Send_WBS_Data(int ModuleCode, int DealCode, int User_Code, string connectionstr, string callForMilestone = "N")
    {
        string enabledWBS_WS = new System_Parameter_New_Service(connectionstr).SearchFor(s => s.Parameter_Name == "Enable_SAP_WBS_WebService").Select(s => s.Parameter_Value).FirstOrDefault();
        if (string.IsNullOrEmpty(enabledWBS_WS))
            enabledWBS_WS = "N";
        if (enabledWBS_WS == "Y")
        {
            if (ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
            {
                Acq_Deal objAcq_Deal = new Acq_Deal_Service(connectionstr).GetById(DealCode);
                int version_No = Convert.ToInt32(objAcq_Deal.Version);
                if (objAcq_Deal.Deal_Workflow_Status == GlobalParams.dealWorkFlowStatus_Approved)
                {
                    string Err_filename = "WebPage_Log.txt";
                    WriteErrorLog("Called Send_WBS_Data method from web application on " + DateTime.Now.ToString(), Err_filename);
                    List<USP_Get_Title_WBS_Data_Result> list = new USP_Service(connectionstr).USP_Get_Title_WBS_Data(DealCode, callForMilestone).ToList();
                    WriteErrorLog("Called USP_Get_Title_WBS_Data method from web application on " + DateTime.Now.ToString(), Err_filename);
                    if (list.Count > 0)
                    {
                        WriteErrorLog(list.Count() + " record(s) found", Err_filename);
                        List<ZpsWebWbsDates> lstZpsWebWbsDates = new List<ZpsWebWbsDates>();
                        int lineItem = 1;
                        foreach (USP_Get_Title_WBS_Data_Result objResult in list)
                        {
                            string strLineItem = "Line Item " + lineItem + " => ";
                            try
                            {
                                ZpsWebWbsDates obj = new ZpsWebWbsDates();
                                obj.Posid = objResult.WBS_Code.ToString();
                                strLineItem += "WBS_Code : " + objResult.WBS_Code.ToString() + ", ";
                                if (objResult.WBS_Start_Date != null)
                                {
                                    strLineItem += "WBS_Start_Date : " + objResult.WBS_Start_Date + ", ";
                                    obj.Begda = Convert.ToDateTime(objResult.WBS_Start_Date).ToString("yyyy-MM-dd");
                                }
                                else
                                    strLineItem += "WBS_Start_Date : NULL, ";

                                if (objResult.WBS_End_Date != null)
                                {
                                    strLineItem += "WBS_End_Date : " + objResult.WBS_End_Date + ";";
                                    obj.Endda = Convert.ToDateTime(objResult.WBS_End_Date).ToString("yyyy-MM-dd");
                                }
                                else
                                    strLineItem += "WBS_End_Date : NULL;";

                                WriteErrorLog(strLineItem, Err_filename);
                                lstZpsWebWbsDates.Add(obj);
                                lineItem++;
                            }
                            catch (Exception e)
                            {
                                WriteErrorLog(strLineItem, Err_filename);
                                WriteErrorLog("Execption occured : " + e.Message, Err_filename);
                            }
                        }

                        #region ---
                        ZpsWebWbsDates[] arr = lstZpsWebWbsDates.ToArray();
                        try
                        {
                            string userName = System.Configuration.ConfigurationManager.AppSettings["SAP_WS_UserName"];
                            string password = System.Configuration.ConfigurationManager.AppSettings["SAP_WS_Password"];

                            WriteErrorLog("Connection to ZPS_WEB_SERV_WBS_DATESClient() ", Err_filename);
                            ZPS_WEB_SERV_WBS_DATESClient objClient = new ZPS_WEB_SERV_WBS_DATESClient();
                            objClient.ClientCredentials.UserName.UserName = userName;
                            objClient.ClientCredentials.UserName.Password = password;
                            WriteErrorLog("sending data to SAP by calling ZpsWbsDatesForWebServ() method ", Err_filename);
                            objClient.ZpsWbsDatesForWebServ(ref arr);
                            WriteErrorLog("sent data to SAP by calling ZpsWbsDatesForWebServ() method and received updated data ", Err_filename);
                        }
                        catch (Exception e)
                        {
                            WriteErrorLog("Execption occured : " + e.Message, Err_filename);
                        }


                        List<RightsU_Entities.SAP_Export> listSAP_Export = new List<RightsU_Entities.SAP_Export>();

                        RightsU_Entities.Upload_Files objUpload_File = new RightsU_Entities.Upload_Files();
                        objUpload_File.File_Name = DateTime.Now.Ticks + "~" + DateTime.Now.ToString();
                        objUpload_File.Uploaded_By = 0;
                        objUpload_File.Upload_Type = "SAP_EXP";
                        objUpload_File.Upload_Date = DateTime.Now;
                        objUpload_File.Uploaded_By = User_Code;
                        objUpload_File.Bank_Code = 0;
                        objUpload_File.ChannelCode = 0;
                        objUpload_File.Err_YN = "N";
                        objUpload_File.Upload_Record_Count = arr.Length;
                        objUpload_File.EntityState = State.Added;

                        lineItem = 1;
                        foreach (ZpsWebWbsDates obj in arr)
                        {
                            string strLineItem = "Line Item " + lineItem + " => ";
                            try
                            {
                                RightsU_Entities.SAP_Export objSAP_Export = new RightsU_Entities.SAP_Export();
                                objSAP_Export.WBS_Code = obj.Posid;

                                if (string.IsNullOrEmpty(obj.Begda))
                                    obj.Begda = "";
                                if (string.IsNullOrEmpty(obj.Endda))
                                    obj.Endda = "";
                                if (string.IsNullOrEmpty(obj.ZstatusLd))
                                    obj.ZstatusLd = "";
                                if (string.IsNullOrEmpty(obj.Zerror))
                                    obj.Zerror = "";

                                strLineItem += "SAP Begda : " + obj.Begda + ", ";
                                strLineItem += "SAP Endda : " + obj.Endda + ", ";
                                strLineItem += "SAP Acknowledgement_Status : " + obj.ZstatusLd + ", ";
                                strLineItem += "SAP Acknowledgement_Status : " + obj.Zerror + ";";
                                WriteErrorLog(strLineItem, Err_filename);

                                if (obj.Endda != "0000-00-00" && obj.Begda != "")
                                    objSAP_Export.WBS_Start_Date = Convert.ToDateTime(obj.Begda);

                                if (obj.Endda != "0000-00-00" && obj.Endda != "")
                                    objSAP_Export.WBS_End_Date = Convert.ToDateTime(obj.Endda);

                                objSAP_Export.Acknowledgement_Status = obj.ZstatusLd.Trim().ToUpper();
                                objSAP_Export.Error_Details = obj.Zerror.Trim();
                                objSAP_Export.Acq_Deal_Code = DealCode;
                                objSAP_Export.Version_No = version_No;

                                if (objSAP_Export.Acknowledgement_Status.Equals("ERR"))
                                    objUpload_File.Err_YN = "Y";

                                objSAP_Export.EntityState = State.Added;
                                listSAP_Export.Add(objSAP_Export);
                            }
                            catch (Exception e)
                            {
                                WriteErrorLog(strLineItem, Err_filename);
                                WriteErrorLog("Execption occured : " + e.Message, Err_filename);
                            }
                        }

                        dynamic resultSet;
                        new Upload_Files_Service(connectionstr).Save(objUpload_File, out resultSet); // changed by sayali
                        WriteErrorLog("Inserting data in SAP_Export table", Err_filename);
                        SAP_Export_Service objSAP_Export_Service = new SAP_Export_Service(connectionstr); 
                        foreach (RightsU_Entities.SAP_Export objSE in listSAP_Export)
                        {
                            try
                            {
                                objSE.File_Code = (int)objUpload_File.File_Code;
                                objSAP_Export_Service.Save(objSE, out resultSet); // changed by sayali -- Add Save method in SAP_Export_Service
                            }
                            catch (Exception e)
                            {
                                WriteErrorLog("Execption occured : " + e.Message, Err_filename);
                            }
                        }
                        #endregion
                    }
                    else
                        WriteErrorLog("0 record(s) found", Err_filename);
                }
            }
        }
    }

    public  bool Lock_Record(int record_Code, int module_Code, int user_Code, out int Record_Locking_Code, out string strMessage,string connectionstr)
    {
        Record_Locking_Code = 0;
        strMessage = "";
        string hostName = System.Net.Dns.GetHostName();
        string myIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];

        ObjectParameter objRecordLockingCode = new ObjectParameter("Record_Locking_Code", Record_Locking_Code);
        ObjectParameter objMessage = new ObjectParameter("Message", strMessage);
        new RightsU_BLL.USP_Service(connectionstr).USP_Lock_Refresh_Release_Record(record_Code, module_Code, user_Code, myIP, objRecordLockingCode, objMessage, "LOCK");
        Record_Locking_Code = Convert.ToInt32(objRecordLockingCode.Value);
        strMessage = Convert.ToString(objMessage.Value);

        if (Record_Locking_Code > 0)
            return true;
        else
            return false;
    }

    public  void Release_Record(int record_Locking_Code,string connectionstr)
    {
        ObjectParameter objRecordLockingCode = new ObjectParameter("Record_Locking_Code", record_Locking_Code);
        string strMessage = "";
        ObjectParameter objMessage = new ObjectParameter("Message", strMessage);
        new RightsU_BLL.USP_Service(connectionstr).USP_Lock_Refresh_Release_Record(null, null, null, null, objRecordLockingCode, objMessage, "RELEASE");
    }

    public  void Refresh_Lock(int record_Locking_Code,string connectionstr)
    {
        ObjectParameter objRecordLockingCode = new ObjectParameter("Record_Locking_Code", record_Locking_Code);
        new RightsU_BLL.USP_Service(connectionstr).USP_Lock_Refresh_Release_Record(null, null, null, null, objRecordLockingCode, null, "REFRESH");
    }

    #region --- Write Log File ---
    /*
     * Pass errorFileName with extention e.g. errorLog.txt
     */
    public static void WriteErrorLog(string ex, string errorFileName)
    {
        string fullfileName = System.Web.HttpContext.Current.Server.MapPath("~/" + errorFileName);
        string writeErrLog = System.Configuration.ConfigurationManager.AppSettings["WriteErrLog"];
        if (writeErrLog == "Y")
        {
            try
            {
                StreamWriter w = File.AppendText(fullfileName);
                Log(ex, w);
                w.Close();
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Error writing error log");
                Console.Out.WriteLine(e.Message);
            }
        }
    }
    public static void Log(String logMessage, StreamWriter w)
    {
        try
        {
            w.WriteLine("{0} {1}", DateTime.Now.ToLongDateString(), DateTime.Now.ToLongTimeString());
            //w.WriteLine("  :");
            w.WriteLine("  :{0}", logMessage);
            w.WriteLine("-------------------------------");
            w.Flush();
        }
        catch (Exception e)
        {
            Console.Out.WriteLine("Error writing log");
            Console.Out.WriteLine(e.Message);
        }
    }
    #endregion
}
