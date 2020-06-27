using System;
using System.Xml;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Xml.Linq;
using System.IO;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Net.Mail;
using RightsU_Entities;
using RightsU_BLL;

namespace RightsU_WebApp.WebServices
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]

    public class RightsU_SAP_Integration : System.Web.Services.WebService
    {
        [WebMethod(EnableSession = true)]
        //public RU_SapWbsData[] RU_SAP_WBS()
        public RU_SapWbsData[] RU_SAP_WBS(ref RU_SapWbsData[] arrRU_SapWbsData)
        {
            //  RU_SapWbsData[] arrRU_SapWbsData = RecriveDataFromSAP();
            Session["Entity_Type"] = ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper();
            string strRow_Delimed = "";
            string Error_Msg = "", Err_Codes = "";

            int rowNo = 0;
            bool lengthInValid = false, isEmpty = false;
            //List<RightsU_Entities.SAP_WBS> listSAP_WBS = new List<RightsU_Entities.SAP_WBS>();
            //List<RightsU_Entities.Upload_Err_Detail> listUpload_Err_Detail = new List<RightsU_Entities.Upload_Err_Detail>();

            List<SAP_WBS_DATA_UDT> lst_SAP_WBS_DATA_UDT = new List<SAP_WBS_DATA_UDT>();
            List<Upload_File_Data_UDT> lst_Upload_File_Data_UDT = new List<Upload_File_Data_UDT>();

            string Err_filename = ""; //HttpContext.Current.Server.MapPath("~/WebPage_Log.txt");
            CommonUtil.WriteErrorLog("Called RU_SAP_WBS method on " + DateTime.Now.ToString(), Err_filename);

            foreach (RU_SapWbsData obj in arrRU_SapWbsData)
            {
                Error_Msg = "";
                if (string.IsNullOrEmpty(obj.WBS_Code))
                    obj.WBS_Code = "";
                if (string.IsNullOrEmpty(obj.WBS_Description))
                    obj.WBS_Description = "";
                if (string.IsNullOrEmpty(obj.Studio_Vendor))
                    obj.Studio_Vendor = "";
                if (string.IsNullOrEmpty(obj.Original_Dubbed))
                    obj.Original_Dubbed = "";
                if (string.IsNullOrEmpty(obj.Status))
                    obj.Status = "";
                if (string.IsNullOrEmpty(obj.Short_ID))
                    obj.Short_ID = "";
                if (string.IsNullOrEmpty(obj.Sport_Type))
                    obj.Sport_Type = "";
                if (string.IsNullOrEmpty(obj.Acknowledgement_Status))
                    obj.Acknowledgement_Status = "";
                if (string.IsNullOrEmpty(obj.Error_Details))
                    obj.Error_Details = "";

                lengthInValid = isEmpty = false;
                Err_Codes = strRow_Delimed = "";
                rowNo++;

                strRow_Delimed = obj.WBS_Code;
                if (obj.WBS_Code.Length > 24)
                {
                    lengthInValid = true;
                    Err_Codes += "~LP_WBS_C";
                    Error_Msg = "WBS Code";
                }

                strRow_Delimed += "~" + obj.WBS_Description;
                if (obj.WBS_Description.Length > 40)
                {
                    lengthInValid = true;
                    Err_Codes += "~LP_WBS_DES";
                    Error_Msg += ", WBS Description";
                }


                strRow_Delimed += "~" + obj.Studio_Vendor;
                if (obj.Studio_Vendor.Length > 105)
                {
                    lengthInValid = true;
                    Err_Codes += "~LP_SV";
                    Error_Msg += ", Studio/Vendor";
                }

                strRow_Delimed += "~" + obj.Original_Dubbed;
                if (obj.Original_Dubbed.Length > 15)
                {
                    lengthInValid = true;
                    Err_Codes += "~LP_OD";
                    Error_Msg += ", Original/Dubbed";
                }

                strRow_Delimed += "~" + obj.Short_ID;
                if (obj.Short_ID.Length > 16)
                {
                    lengthInValid = true;
                    Err_Codes += "~LP_S_ID";
                    Error_Msg += ", Short ID";
                }

                strRow_Delimed += "~" + obj.Status;
                if (obj.Status.Length > 5)
                {
                    lengthInValid = true;
                    Err_Codes += "~LP_ST";
                    Error_Msg += ", Status";
                }

                strRow_Delimed += "~" + obj.Sport_Type;
                if (obj.Sport_Type.Length > 15)
                {
                    lengthInValid = true;
                    Err_Codes += "~LP_TOS";
                    Error_Msg += ", Type of Sport";
                }

                if (lengthInValid)
                {
                    Error_Msg = Error_Msg.Trim().Trim(',').Trim();
                    Error_Msg += " Length Problem";
                }

                if (obj.WBS_Code == "")
                {
                    isEmpty = true;
                    Err_Codes += "~E_WBS_C";
                    Error_Msg += ", WBS Code";
                }
                if (obj.WBS_Description == "")
                {
                    isEmpty = true;
                    Err_Codes += "~E_WBS_DES";
                    Error_Msg += ", WBS Description";
                }
                if (obj.Studio_Vendor == "")
                {
                    isEmpty = true;
                    Err_Codes += "~E_SV";
                    Error_Msg += ", Studio/Vendor";
                }
                //As Per Discusion with prathesh sir Original_Dubbed is not mandatory field
                /*
                if (obj.Original_Dubbed == "")
                {
                    isEmpty = true;
                    Err_Codes += "~E_OD";
                    Error_Msg += ", Original/Dubbed";
                }
                  */
                if (obj.Status == "")
                {
                    isEmpty = true;
                    Err_Codes += "~E_ST";
                    Error_Msg += ", Status";
                }

                string strLineItem = "Line Item " + rowNo + " => WBS_Code: " + obj.WBS_Code + ", ";
                strLineItem += "WBS_Description: " + obj.WBS_Description + ", ";
                strLineItem += "Studio_Vendor: " + obj.Studio_Vendor + ", ";
                strLineItem += "Original_Dubbed: " + obj.Original_Dubbed + ", ";
                strLineItem += "Status: " + obj.Status + ", ";
                strLineItem += "Short_ID: " + obj.Short_ID + ", ";
                strLineItem += "Sport_Type: " + obj.Sport_Type + ", ";

                if (isEmpty || lengthInValid)
                {
                    Error_Msg = Error_Msg.Trim().Trim(',').Trim();

                    if (isEmpty)
                        Error_Msg += " Empty";

                    obj.Acknowledgement_Status = "ERR";
                    obj.Error_Details = Error_Msg;
                    strLineItem += "Acknowledgement_Status: ERR, ";
                    strLineItem += "Error_Details: " + Error_Msg + ";";
                }
                else
                {
                    obj.Acknowledgement_Status = "UPD";
                    obj.Error_Details = "";

                    strLineItem += "Acknowledgement_Status: UPD, Error_Details:";

                    //RightsU_Entities.SAP_WBS objSAP_WBS = new RightsU_Entities.SAP_WBS();
                    //objSAP_WBS.WBS_Code = obj.WBS_Code;
                    //objSAP_WBS.WBS_Description = obj.WBS_Description;
                    //objSAP_WBS.Studio_Vendor = obj.Studio_Vendor;
                    //objSAP_WBS.Original_Dubbed = obj.Original_Dubbed;
                    //objSAP_WBS.Status = obj.Status;
                    //objSAP_WBS.Short_ID = obj.Short_ID;
                    //objSAP_WBS.Sport_Type = obj.Sport_Type;

                    //RightsU_Entities.SAP_WBS objTemp = new SAP_WBS_Service().SearchFor(s => s.WBS_Code.Equals(obj.WBS_Code)).FirstOrDefault();
                    //if (objTemp != null)
                    //{
                    //    objSAP_WBS.SAP_WBS_Code = objTemp.SAP_WBS_Code;
                    //    objSAP_WBS.EntityState = State.Modified;

                    //    if (objTemp.BMS_Key != null)
                    //        objSAP_WBS.BMS_Key = objTemp.BMS_Key;
                    //}
                    //else
                    //{
                    //    objSAP_WBS.EntityState = State.Added;
                    //}

                    SAP_WBS_DATA_UDT objSAP_WBS_UDT = new SAP_WBS_DATA_UDT();
                    objSAP_WBS_UDT.WBS_Code = obj.WBS_Code;
                    objSAP_WBS_UDT.WBS_Description = obj.WBS_Description;
                    objSAP_WBS_UDT.Studio_Vendor = obj.Studio_Vendor;
                    objSAP_WBS_UDT.Original_Dubbed = obj.Original_Dubbed;
                    objSAP_WBS_UDT.Status = obj.Status;
                    objSAP_WBS_UDT.Short_ID = obj.Short_ID;
                    objSAP_WBS_UDT.Sport_Type = obj.Sport_Type;

                    lst_SAP_WBS_DATA_UDT.Add(objSAP_WBS_UDT);

                    //RightsU_Entities.SAP_WBS objTemp = new SAP_WBS_Service().SearchFor(s => s.WBS_Code.Equals(obj.WBS_Code)).FirstOrDefault();
                    //if (objTemp != null)
                    //{
                    // //   objSAP_WBS.SAP_WBS_Code = objTemp.SAP_WBS_Code;
                    //    objSAP_WBS.EntityState = State.Modified;

                    //    if (objTemp.BMS_Key != null)
                    //        objSAP_WBS.BMS_Key = objTemp.BMS_Key;
                    //}
                    //else
                    //{
                    //    objSAP_WBS.EntityState = State.Added;
                    //}
                    //listSAP_WBS.Add(objSAP_WBS);
                }

                //RightsU_Entities.Upload_Err_Detail objUpload_Err_Detail = new RightsU_Entities.Upload_Err_Detail();
                //objUpload_Err_Detail.Row_Num = rowNo;
                //objUpload_Err_Detail.Row_Delimed = strRow_Delimed;
                //objUpload_Err_Detail.Err_Cols = Err_Codes.Trim().Trim('~').Trim();
                //objUpload_Err_Detail.Upload_Type = "SAP_IMP";
                //objUpload_Err_Detail.EntityState = State.Added;
                //listUpload_Err_Detail.Add(objUpload_Err_Detail);

                Upload_File_Data_UDT objUpload_Err_Detail_UDT = new Upload_File_Data_UDT();
                objUpload_Err_Detail_UDT.Row_Num = rowNo;
                objUpload_Err_Detail_UDT.Row_Delimed = strRow_Delimed;
                objUpload_Err_Detail_UDT.Err_Cols = Err_Codes.Trim().Trim('~').Trim();
                objUpload_Err_Detail_UDT.Upload_Type = "SAP_IMP";
                //objUpload_Err_Detail_UDT.EntityState = State.Added;

                //                listUpload_Err_Detail.Add(objUpload_Err_Detail);
                lst_Upload_File_Data_UDT.Add(objUpload_Err_Detail_UDT);
                CommonUtil.WriteErrorLog(strLineItem, Err_filename);
            }

            string isError = "N";
            if (!Err_Codes.Equals(""))
                isError = "Y";

            //RightsU_Entities.Upload_Files objUpload_Files = new RightsU_Entities.Upload_Files();
            //objUpload_Files.EntityState = RightsU_Entities.State.Added;
            //objUpload_Files.File_Name = DateTime.Now.Ticks + "~" + DateTime.Now.ToString();
            //objUpload_Files.Err_YN = isError;
            //objUpload_Files.Upload_Date = DateTime.Now;
            //objUpload_Files.Uploaded_By = 143;
            //objUpload_Files.Upload_Type = "SAP_IMP";
            //objUpload_Files.Upload_Record_Count = arrRU_SapWbsData.Count();

            //CommonUtil.WriteErrorLog("Inserting record in Upload_Files table on " + DateTime.Now.ToString(), Err_filename);
            //new Upload_Files_Service().Save(objUpload_Files);
            //CommonUtil.WriteErrorLog("Inserted record in Upload_Files table on " + DateTime.Now.ToString(), Err_filename);

            //CommonUtil.WriteErrorLog("Inserting records in Upload_Err_Detail table on " + DateTime.Now.ToString(), Err_filename);
            //Upload_Err_Detail_Service objUpload_Err_Detail_Service = new Upload_Err_Detail_Service();
            //foreach (RightsU_Entities.Upload_Err_Detail objUED in listUpload_Err_Detail)
            //{
            //    objUED.File_Code = objUpload_Files.File_Code;
            //    objUpload_Err_Detail_Service.Save(objUED);
            //}
            //CommonUtil.WriteErrorLog("Inserted records in Upload_Err_Detail table on " + DateTime.Now.ToString(), Err_filename);
            //CommonUtil.WriteErrorLog("Inserting/Updating records in SAP_WBS table on " + DateTime.Now.ToString(), Err_filename);
            //string WBS_Codes = "";
            //    SAP_WBS_Service objSAP_WBS_Service = new SAP_WBS_Service();
            string strConString = ConfigurationManager.AppSettings["ConnectionStringName"].ToString();
            USP_Service objUS = new USP_Service(strConString);
            //foreach (RightsU_Entities.SAP_WBS objSW in listSAP_WBS)
            //{
            //    string Is_Archive = "Y";
            //    if (objSW.Status == "REL")
            //        Is_Archive = "N";
            //    if (objSW.Status == "TECO" || objSW.Status == "CLSD" || objSW.Status == "LKD")
            //        WBS_Codes += objSW.WBS_Code + ",";
            //    objSW.File_Code = (int)objUpload_Files.File_Code;
            //    objSW.Insert_On = DateTime.Now;
            //    objSAP_WBS_Service.Save(objSW);
            //    objUS.USP_BMS_WBS_Insert(objSW.SAP_WBS_Code, objSW.WBS_Code, objSW.WBS_Description, objSW.Short_ID, Is_Archive, "", "", "P", null, objSW.BMS_Key);
            //}
            CommonUtil.WriteErrorLog("Start Call USP USP_INSERT_SAP_WBS_UDT" + DateTime.Now.ToString(), Err_filename);
            objUS.USP_INSERT_SAP_WBS_UDT(lst_SAP_WBS_DATA_UDT, lst_Upload_File_Data_UDT, isError);
            CommonUtil.WriteErrorLog("Inserted/Updated records in SAP_WBS table on " + DateTime.Now.ToString(), Err_filename);
            //WBS_Codes = WBS_Codes.Trim().Trim(',').Trim();
            //if (!string.IsNullOrEmpty(WBS_Codes))
            //{
            //    CommonUtil.WriteErrorLog("Calling USP_Send_Mail_WBS_Linked_Titles for '" + WBS_Codes + "' on " + DateTime.Now.ToString(), Err_filename);
            //    new USP_Service().USP_Send_Mail_WBS_Linked_Titles(WBS_Codes);
            //}
            return arrRU_SapWbsData;
        }

        private RU_SapWbsData[] RecriveDataFromSAP()
        {
            List<RU_SapWbsData> lstRU_SapWbsData = new List<RU_SapWbsData>();
            for (int i = 0; i <= 600; i++)
            {
                lstRU_SapWbsData.Add(new RU_SapWbsData
                {
                    WBS_Code = "T/LIC-00001." + i.ToString(),
                    WBS_Description = "DDLJ R",
                    Studio_Vendor = "Yash Raj Films loop",
                    // Original_Dubbed = "Original",
                    Short_ID = "",
                    Status = "TECO",
                    Sport_Type = ""
                });
            }
            //lstRU_SapWbsData.Add(new RU_SapWbsData
            //{
            //    WBS_Code = "F/LIC-0000001.01",
            //    WBS_Description = "DDLJ R",
            //    Studio_Vendor = "Yash Raj Films",
            //    Original_Dubbed = "Original",
            //    Short_ID = "",
            //    Status = "TECO",
            //    Sport_Type = ""
            //});
            //lstRU_SapWbsData.Add(new RU_SapWbsData
            //{
            //    WBS_Code = "F/LIC-0000001.02",
            //    WBS_Description = "DDLJ R1",
            //    Studio_Vendor = "Yash Raj Films",
            //    Original_Dubbed = "Original",
            //    Short_ID = "",
            //    Status = "TECO",
            //    Sport_Type = ""
            //});
            //lstRU_SapWbsData.Add(new RU_SapWbsData
            //{
            //    WBS_Code = "F/LIC-0000001.03",
            //    WBS_Description = "Dilwale Dulunhinya Le Jaayenge D",
            //    Studio_Vendor = "Yash Raj Films",
            //    Original_Dubbed = "Original",
            //    Short_ID = "",
            //    Status = "TECO",
            //    Sport_Type = ""
            //});
            //lstRU_SapWbsData.Add(new RU_SapWbsData
            //{
            //    WBS_Code = "T/ABU-1234567.89",
            //    WBS_Description = "Abhay",
            //    Studio_Vendor = "Yash Raj Films",
            //    Original_Dubbed = "Original",
            //    Short_ID = "",
            //    Status = "REL",
            //    Sport_Type = ""
            //});
            //lstRU_SapWbsData.Add(new RU_SapWbsData
            //{
            //    WBS_Code = "R/RAJ-0000001.89",
            //    WBS_Description = "Rajesh",
            //    Studio_Vendor = "Yash Raj Films",
            //    Original_Dubbed = "Original",
            //    Short_ID = "",
            //    Status = "REL",
            //    Sport_Type = ""
            //});
            //lstRU_SapWbsData.Add(new RU_SapWbsData
            //{
            //    WBS_Code = "J/JAT-9876543.21",
            //    WBS_Description = "Jatin",
            //    Studio_Vendor = "Yash Raj Films",
            //    Original_Dubbed = "Original",
            //    Short_ID = "",
            //    Status = "REL",
            //    Sport_Type = ""
            //});
            return lstRU_SapWbsData.ToArray();
        }
    }
    public class RU_SapWbsData
    {
        public string WBS_Code { get; set; }
        public string WBS_Description { get; set; }
        public string Studio_Vendor { get; set; }
        public string Original_Dubbed { get; set; }
        public string Status { get; set; }
        public string Short_ID { get; set; }
        public string Sport_Type { get; set; }
        public string Acknowledgement_Status { get; set; }
        public string Error_Details { get; set; }
    }
}