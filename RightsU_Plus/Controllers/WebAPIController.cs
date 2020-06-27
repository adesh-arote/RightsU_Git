using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Web;
using System.Xml;
using System.Text;
using System.Collections;
using System.Configuration;


namespace RightsU_Plus.Controllers
{
    public class PostConfirmation
    {
        public string Is_Error { get; set; }
        public string Error_Details { get; set; }
        public string Module_Name { get; set; }
        public string Response_XML { get; set; }
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

    public class AuthorizationFilter : System.Web.Http.AuthorizeAttribute
    {
        private const string _authorizedToken = "AuthorizedToken";
        public override void OnAuthorization(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            try
            {
                string authHeader = null;
                var auth = actionContext.Request.Headers.Authorization;
                if (auth != null && auth.Scheme == "Basic")
                    authHeader = auth.Parameter;

                if (!string.IsNullOrEmpty(authHeader))
                {
                    //authHeader = Encoding.Default.GetString(Convert.FromBase64String(authHeader));
                    var tokens = authHeader.Split(':');

                    string UserId = "", Password = "", ConfigUserId = "", ConfigPassword = "";
                    UserId = Convert.ToString(tokens[0]);
                    Password = Convert.ToString(tokens[1]);

                    ConfigUserId = Convert.ToString(System.Configuration.ConfigurationSettings.AppSettings["APIUID"]);
                    ConfigPassword = Convert.ToString(System.Configuration.ConfigurationSettings.AppSettings["APIPWD"]);

                    if (UserId == ConfigUserId && Password == ConfigPassword)
                    {
                        HttpContext.Current.Response.AddHeader("UserID", UserId);
                        HttpContext.Current.Response.AddHeader("Password", Password);
                        HttpContext.Current.Response.AddHeader("AuthenticationStatus", "Authorized");
                        return;
                    }
                }
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.ExpectationFailed);
                actionContext.Response.ReasonPhrase = "Invalid Credentials";
            }
            catch (Exception ex)
            {
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.ExpectationFailed);
                actionContext.Response.ReasonPhrase = ex.Message;

            }

        }

    }
   
    public class WebAPIController : ApiController
    {
        [HttpGet]
        [AuthorizationFilter]
        public HttpResponseMessage GetData(string foreign_System_Name, string module_Name, int deal_Type_Code, int bU_Code, int title_Lang_Code, string channel_Code)
        {
            string connectionStringName = ConfigurationManager.AppSettings["ConnectionStringName"].ToUpper();
            try
            {
                USP_Integration_Generate_XML_Result objRequestXML = new USP_Service(connectionStringName).USP_Integration_Generate_XML(module_Name, deal_Type_Code, bU_Code, title_Lang_Code,
                                                            channel_Code, foreign_System_Name).FirstOrDefault();
                var XMLData = objRequestXML.XML_Data;
                if (objRequestXML.IS_Error == "Y")
                {
                    XMLData = objRequestXML.Error_Desc;
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "Internal Server Error in GetData Action Method Try Block and : " + XMLData, Configuration.Formatters.XmlFormatter);
                }
                return new HttpResponseMessage() { Content = new StringContent(XMLData, Encoding.UTF8, "application/xml") };
            }
            catch (Exception ex)
            {
                string ErrorDesc = ex.Message;
                if (ex.InnerException != null)
                    ErrorDesc = ErrorDesc + ";InnerException : " + ex.InnerException;
                if (ex.StackTrace != null)
                    ErrorDesc = ErrorDesc + ";StackTrace : " + ex.StackTrace;
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Catch in Web Api GetData Action Method  : " + ErrorDesc, Configuration.Formatters.XmlFormatter);
            }
        }

        [HttpPost]
        [ActionName("Confirmation")]
        [AuthorizationFilter]
        public HttpResponseMessage Post([FromBody] PostConfirmation objPC)
        //public HttpResponseMessage Post(ArrayList arrList)
        {
            string connectionStringName = ConfigurationManager.AppSettings["ConnectionStringName"].ToUpper();
            //PostConfirmation objPC = (PostConfirmation)arrList[0];
            try
            {
                USP_Integration_Response_Result objResponse = new USP_Service(connectionStringName).USP_Integration_Response(objPC.Error_Details, objPC.Is_Error, objPC.Module_Name, objPC.Response_XML).FirstOrDefault();
                string XMLData = objResponse.ResultXML;
                if (objResponse.Is_Error == "Y")
                {
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "Internal Server Error in Post Action Method Try Block and : " + XMLData, Configuration.Formatters.JsonFormatter);
                }
                return Request.CreateResponse(HttpStatusCode.OK, XMLData, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                string ErrorDesc = ex.Message;
                if (ex.InnerException != null)
                    ErrorDesc = ErrorDesc + ";InnerException : " + ex.InnerException;
                if (ex.StackTrace != null)
                    ErrorDesc = ErrorDesc + ";StackTrace : " + ex.StackTrace;
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Catch in Web Api Post Action Method : " + ErrorDesc, Configuration.Formatters.JsonFormatter);
            }
        }

        [HttpPost]
        [ActionName("RU_SAP_WBS")]
        [AuthorizationFilter]
        public HttpResponseMessage Post(List<RU_SapWbsData> arrRU_SapWbsData)
        {
            string connectionStringName = ConfigurationManager.AppSettings["ConnectionStringName"].ToUpper();
            try
            {
                //Session["Entity_Type"] = ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper();
                string strRow_Delimed = "";
                string Error_Msg = "", Err_Codes = "";

                int rowNo = 0;
                bool lengthInValid = false, isEmpty = false;

                List<SAP_WBS_DATA_UDT> lst_SAP_WBS_DATA_UDT = new List<SAP_WBS_DATA_UDT>();
                List<Upload_File_Data_UDT> lst_Upload_File_Data_UDT = new List<Upload_File_Data_UDT>();

                //string Err_filename = HttpContext.Current.Server.MapPath("~/WebPage_Log.txt");
                //CommonUtil.WriteErrorLog("Called RU_SAP_WBS method on " + DateTime.Now.ToString(), Err_filename);

                //RU_SapWbsData obj = arrRU_SapWbsData;
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

                        SAP_WBS_DATA_UDT objSAP_WBS_UDT = new SAP_WBS_DATA_UDT();
                        objSAP_WBS_UDT.WBS_Code = obj.WBS_Code;
                        objSAP_WBS_UDT.WBS_Description = obj.WBS_Description;
                        objSAP_WBS_UDT.Studio_Vendor = obj.Studio_Vendor;
                        objSAP_WBS_UDT.Original_Dubbed = obj.Original_Dubbed;
                        objSAP_WBS_UDT.Status = obj.Status;
                        objSAP_WBS_UDT.Short_ID = obj.Short_ID;
                        objSAP_WBS_UDT.Sport_Type = obj.Sport_Type;

                        lst_SAP_WBS_DATA_UDT.Add(objSAP_WBS_UDT);
                    }

                    Upload_File_Data_UDT objUpload_Err_Detail_UDT = new Upload_File_Data_UDT();
                    objUpload_Err_Detail_UDT.Row_Num = rowNo;
                    objUpload_Err_Detail_UDT.Row_Delimed = strRow_Delimed;
                    objUpload_Err_Detail_UDT.Err_Cols = Err_Codes.Trim().Trim('~').Trim();
                    objUpload_Err_Detail_UDT.Upload_Type = "SAP_IMP";
                    //objUpload_Err_Detail_UDT.EntityState = State.Added;

                    lst_Upload_File_Data_UDT.Add(objUpload_Err_Detail_UDT);
                   // CommonUtil.WriteErrorLog(strLineItem, Err_filename);
                }

                string isError = "N";
                if (!Err_Codes.Equals(""))
                    isError = "Y";

                USP_Service objUS = new USP_Service(connectionStringName);
                //CommonUtil.WriteErrorLog("Start Call USP USP_INSERT_SAP_WBS_UDT" + DateTime.Now.ToString(), Err_filename);

                objUS.USP_INSERT_SAP_WBS_UDT(lst_SAP_WBS_DATA_UDT, lst_Upload_File_Data_UDT, isError);

                //CommonUtil.WriteErrorLog("Inserted/Updated records in SAP_WBS table on " + DateTime.Now.ToString(), Err_filename);

                return Request.CreateResponse(HttpStatusCode.OK, arrRU_SapWbsData, Configuration.Formatters.XmlFormatter);
            }
            catch (Exception ex)
            {
                string ErrorDesc = ex.Message;
                if (ex.InnerException != null)
                    ErrorDesc = ErrorDesc + ";InnerException : " + ex.InnerException;
                if (ex.StackTrace != null)
                    ErrorDesc = ErrorDesc + ";StackTrace : " + ex.StackTrace;
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Catch in Web Api Post Action Method : " + ErrorDesc, Configuration.Formatters.XmlFormatter);
            }
        }

        [HttpGet]
        [AuthorizationFilter]
        //[ActionName("GetData")]
        public HttpResponseMessage GetData(string ModuleName, string DataSince = "")
        {
            string connectionStringName = ConfigurationManager.AppSettings["ConnectionStringName"].ToUpper();
            try
            {
                PostConfirmation objPC_Response = new PostConfirmation();
                USP_Integration_SDM_Generate_XML_Result objRequestXML = new USP_Integration_SDM_Generate_XML_Result();
                if (DataSince != "")
                    objRequestXML = new USP_Service(connectionStringName).USP_Integration_SDM_Generate_XML(ModuleName, Convert.ToDateTime(DataSince)).FirstOrDefault();
                else
                    objRequestXML = new USP_Service(connectionStringName).USP_Integration_SDM_Generate_XML(ModuleName, null).FirstOrDefault();
                objPC_Response.Response_XML = objRequestXML.XML_Data;
                if (objRequestXML.IS_Error == "Y")
                {
                    objPC_Response.Is_Error = "Y";
                    objPC_Response.Error_Details = objRequestXML.Error_Desc;
                }

                return Request.CreateResponse(HttpStatusCode.OK, objRequestXML);

                //return new HttpResponseMessage() { Content = new StringContent(objRequestXML, Encoding.UTF8, "application/xml") };
            }
            catch (Exception ex)
            {
                string ErrorDesc = ex.Message;
                if (ex.InnerException != null)
                    ErrorDesc = ErrorDesc + ";InnerException : " + ex.InnerException;
                if (ex.StackTrace != null)
                    ErrorDesc = ErrorDesc + ";StackTrace : " + ex.StackTrace;
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Catch in Web Api GetData Action Method  : " + ErrorDesc, Configuration.Formatters.XmlFormatter);
            }
        }

        [HttpPost]
        [ActionName("ValidateData")]
        [AuthorizationFilter]
        public HttpResponseMessage ValidateData([FromBody] string TitleXML)
        {
            string connectionStringName = ConfigurationManager.AppSettings["ConnectionStringName"].ToUpper();
            try
            {
                PostConfirmation objPC_Response = new PostConfirmation();
                objPC_Response.Is_Error = "N";
                try
                {
                    USP_Validate_SDM_Title_Result objRequestXML = new USP_Service(connectionStringName).USP_Validate_SDM_Title(TitleXML).FirstOrDefault();
                    objPC_Response.Response_XML = objRequestXML.Response_XML;
                }
                catch (Exception ex)
                {
                    string ErrorDesc = ex.Message;
                    if (ex.InnerException != null)
                        ErrorDesc = ErrorDesc + ";InnerException : " + ex.InnerException;
                    if (ex.StackTrace != null)
                        ErrorDesc = ErrorDesc + ";StackTrace : " + ex.StackTrace;

                    objPC_Response.Is_Error = "Y";
                    objPC_Response.Error_Details = ErrorDesc;
                }
                return Request.CreateResponse(HttpStatusCode.OK, objPC_Response, Configuration.Formatters.XmlFormatter);
            }
            catch (Exception ex)
            {
                string ErrorDesc = ex.Message;
                if (ex.InnerException != null)
                    ErrorDesc = ErrorDesc + ";InnerException : " + ex.InnerException;
                if (ex.StackTrace != null)
                    ErrorDesc = ErrorDesc + ";StackTrace : " + ex.StackTrace;
                return Request.CreateResponse(HttpStatusCode.InternalServerError, "Catch in Web Api Post Action Method : " + ErrorDesc, Configuration.Formatters.XmlFormatter);
            }
        }
    }
}

