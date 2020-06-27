using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Services;

namespace RightsU_WebApp.WebServices
{
    /// <summary>
    /// Summary description for RightsU_FPC_Integration
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class RightsU_FPC_Integration : System.Web.Services.WebService
    {
        //[WebMethod]
        [WebMethod(EnableSession = true)]
        public PostConfirmation GetData(string foreign_System_Name,string module_Name, int deal_Type_Code, int bU_Code, int title_Lang_Code, string channel_Code)
        {
            string strConString = ConfigurationManager.AppSettings["ConnectionStringName"].ToString();
            Session["Entity_Type"] = ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper();
            PostConfirmation objPC_Response = new PostConfirmation();
            objPC_Response.Is_Error = "N";
            try
            {
                USP_Integration_Generate_XML_Result objRequestXML = new USP_Service(strConString).USP_Integration_Generate_XML(module_Name, deal_Type_Code, bU_Code, title_Lang_Code,
                                                            channel_Code, foreign_System_Name).FirstOrDefault();
                objPC_Response.Response_XML = objRequestXML.XML_Data;
                if (objRequestXML.IS_Error == "Y")
                {
                    objPC_Response.Is_Error = "Y";
                    objPC_Response.Error_Details = objRequestXML.Error_Desc;
                }
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

            return objPC_Response;
        }

        [WebMethod(EnableSession = true)]
        public PostConfirmation PostData(PostConfirmation objPC)
        {
            string strConString = ConfigurationManager.AppSettings["ConnectionStringName"].ToString();
            Session["Entity_Type"] = ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper();
            PostConfirmation objPC_Response = new PostConfirmation();
            objPC.Is_Error = "N";
            try
            {
                USP_Integration_Response_Result objResponse = new USP_Service(strConString).USP_Integration_Response(objPC.Error_Details, objPC.Is_Error, objPC.Module_Name, objPC.Response_XML).FirstOrDefault();
                objPC_Response.Response_XML = objResponse.ResultXML;
                if (objResponse.Is_Error == "Y")
                {
                    objPC.Is_Error = "Y";
                    objPC.Error_Details = objResponse.Error_Details;
                }
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

            return objPC_Response;
        }
    }

    public class PostConfirmation
    {
        public string Is_Error { get; set; }
        public string Error_Details { get; set; }
        public string Module_Name { get; set; }
        public string Response_XML { get; set; }
    }
}
