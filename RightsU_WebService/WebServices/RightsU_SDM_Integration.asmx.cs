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
using System.Web.Services.Protocols;

namespace RightsU_WebApp.WebServices
{
    /// <summary>
    /// Summary description for RightsU_SDM_Integration
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class RightsU_SDM_Integration : System.Web.Services.WebService
    {
        public WSUsers User;

        //[WebMethod]
        [WebMethod(EnableSession = true)]
        [SoapHeader("User", Required = true)]
        public PostConfirmation GetData(string ModuleName, string DataSince = "")
        {
            string conStrName = ConfigurationManager.AppSettings["ConnectionStringName"].ToString();
            PostConfirmation objPC_Response = new PostConfirmation();
            if (User != null)
            {
                if (User.IsValid())
                {
                    Session["Entity_Type"] = ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper();
                    objPC_Response.Is_Error = "N";
                    try
                    {
                        USP_Integration_SDM_Generate_XML_Result objRequestXML = new USP_Integration_SDM_Generate_XML_Result();
                        if (DataSince != "")
                            objRequestXML = new USP_Service(conStrName).USP_Integration_SDM_Generate_XML(ModuleName, Convert.ToDateTime(DataSince)).FirstOrDefault();
                        else
                            objRequestXML = new USP_Service(conStrName).USP_Integration_SDM_Generate_XML(ModuleName, null).FirstOrDefault();
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
                }
                else
                {
                    objPC_Response.Is_Error = "Y";
                    objPC_Response.Error_Details = "Error in authentication";
                }
            }
            else
            {
                objPC_Response.Is_Error = "Y";
                objPC_Response.Error_Details = "Error in authentication";
            }
            return objPC_Response;
        }

        [WebMethod(EnableSession = true)]
        [SoapHeader("User", Required = true)]
        public PostConfirmation ValidateData(string TitleXMl)
        {
            string conStrName = ConfigurationManager.AppSettings["ConnectionStringName"].ToString();
            PostConfirmation objPC_Response = new PostConfirmation();
            if (User != null)
            {
                if (User.IsValid())
                {
                    Session["Entity_Type"] = ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper();
                    objPC_Response.Is_Error = "N";
                    try
                    {
                        USP_Validate_SDM_Title_Result objRequestXML = new USP_Service(conStrName).USP_Validate_SDM_Title(TitleXMl).FirstOrDefault();
                        objPC_Response.Response_XML = objRequestXML.Response_XML;
                        //if (objPC_Response.Response_XML != objPC_Response.Response_XML)
                        //{
                        //    objPC_Response.Is_Error = "Y";
                        //    objPC_Response.Error_Details = objRequestXML.Error_Desc;
                        //}
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
                }
                else
                {
                    objPC_Response.Is_Error = "Y";
                    objPC_Response.Error_Details = "Error in authentication";
                }
            }
            else
            {
                objPC_Response.Is_Error = "Y";
                objPC_Response.Error_Details = "Error in authentication";
            }
            return objPC_Response;
        }
        //[WebMethod(EnableSession = true)]
        //public PostConfirmation PostData(PostConfirmation objPC)
        //{
        //    Session["Entity_Type"] = ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper();
        //    PostConfirmation objPC_Response = new PostConfirmation();
        //    objPC.Is_Error = "N";
        //    try
        //    {
        //        USP_Integration_Response_Result objResponse = new USP_Service().USP_Integration_Response(objPC.Error_Details, objPC.Is_Error, objPC.Module_Name, objPC.Response_XML).FirstOrDefault();
        //        objPC_Response.Response_XML = objResponse.ResultXML;
        //        if (objResponse.Is_Error == "Y")
        //        {
        //            objPC.Is_Error = "Y";
        //            objPC.Error_Details = objResponse.Error_Details;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        string ErrorDesc = ex.Message;
        //        if (ex.InnerException != null)
        //            ErrorDesc = ErrorDesc + ";InnerException : " + ex.InnerException;
        //        if (ex.StackTrace != null)
        //            ErrorDesc = ErrorDesc + ";StackTrace : " + ex.StackTrace;

        //        objPC_Response.Is_Error = "Y";
        //        objPC_Response.Error_Details = ErrorDesc;
        //    }

        //    return objPC_Response;
        //}

        public class PostConfirmation
        {
            public string Is_Error { get; set; }
            public string Error_Details { get; set; }
            public string Module_Name { get; set; }
            public string Response_XML { get; set; }
        }
    }

    #region ============ Web Service Authentication ============

    public class WSUsers : System.Web.Services.Protocols.SoapHeader
    {
        public string UserName { get; set; }
        public string Password { get; set; }

        public bool IsValid()
        {
            return this.UserName == Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["WSUser"]) && this.Password == Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["WSPwd"]);
        }
    }

    #endregion

}
