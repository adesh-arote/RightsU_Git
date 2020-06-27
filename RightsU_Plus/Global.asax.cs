using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Optimization;
using System.Web.Mail;
using System.Net.Mail;
using System.Net;
using RightsU_Entities;
using RightsU_BLL;

namespace RightsU_Plus
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            ViewEngines.Engines.Clear();
            IViewEngine razorEngine = new RazorViewEngine() { FileExtensions = new string[] { "cshtml" } };
            ViewEngines.Engines.Add(razorEngine);
            ViewEngines.Engines.Add(new WebFormViewEngine());

            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            var httpContext = ((MvcApplication)sender).Context;
            var currentController = " ";
            var currentAction = " ";
            var currentID = " ";
            string Error_Desc = "";
            string IP_Add = "";
            string Error_Type = ex is HttpException ? ((HttpException)ex).GetHttpCode().ToString() : "500";
            var currentRouteData = RouteTable.Routes.GetRouteData(new HttpContextWrapper(httpContext));
            if (currentRouteData != null)
            {
                if (currentRouteData.Values["controller"] != null && !String.IsNullOrEmpty(currentRouteData.Values["controller"].ToString()))
                {
                    currentController = currentRouteData.Values["controller"].ToString();
                }
                if (currentRouteData.Values["action"] != null && !String.IsNullOrEmpty(currentRouteData.Values["action"].ToString()))
                {
                    currentAction = currentRouteData.Values["action"].ToString();
                }
                if (currentRouteData.Values["id"] != null && !String.IsNullOrEmpty(currentRouteData.Values["id"].ToString()))
                {
                    currentID = currentRouteData.Values["id"].ToString();
                }
            }
            if (ex.InnerException != null)
                Error_Desc = ex.InnerException.ToString();
            else
                Error_Desc = ex.Message;
            if (ex.StackTrace != null && ex.StackTrace != "")
                Error_Desc = Error_Desc + " <b>StackTrace:</b> " + ex.StackTrace;
            if (ex.TargetSite != null)
                Error_Desc = Error_Desc + " <b>TargetSite: </b>" + ex.TargetSite;
            //var routedata = new HandleErrorInfo(ex, currentController, currentAction);
            User objUsers = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;
            string SiteAddress = System.Configuration.ConfigurationManager.AppSettings["SiteAddress"];

            string FromMailId = System.Configuration.ConfigurationManager.AppSettings["FromMailId"];
            string ToMailId = System.Configuration.ConfigurationManager.AppSettings["ToMailId"];
            string Entity_Type = "";
            string ConnectionStringName = "";
            if (Session[RightsU_Session.CurrentLoginEntity] != null)
            {
                Entity_Type = ((LoginEntity)Session[RightsU_Session.CurrentLoginEntity]).FullName;
                ConnectionStringName = ((LoginEntity)HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity]).ConnectionStringName;
            }
            if (Error_Type != "404")
            {
                new USP_Service(ConnectionStringName).USP_SendMail_Page_Crashed(objUsers.Login_Name + " / " + objUsers.Security_Group.Security_Group_Name, SiteAddress, Entity_Type, currentController, currentAction, "", Error_Desc, Error_Type, IP_Add, FromMailId, ToMailId);
            }
            
        }
        protected void Application_EndRequest(object sender, EventArgs e)
        {
            if (Request.IsSecureConnection == true && HttpContext.Current.Request.Url.Scheme == "https")
            {
                Request.Cookies["ASP.NET_SessionID"].Secure = true;
                if (Request.Cookies.Count > 0)
                {
                    foreach (string s in Request.Cookies.AllKeys)
                    {
                        Request.Cookies[s].Secure = true;
                    }
                }

                Response.Cookies["ASP.NET_SessionID"].Secure = true;
                if (Response.Cookies.Count > 0)
                {
                    foreach (string s in Response.Cookies.AllKeys)
                    {
                        Response.Cookies[s].Secure = true;
                    }
                }
            }
        }
    }
}