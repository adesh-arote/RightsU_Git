using System;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;


namespace RightsU_Plus.Controllers
{
    public class Custom_Error : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            Exception ex = filterContext.Exception;
           
            var httpContext = filterContext;
            var currentController = filterContext.RouteData.Values["Controller"].ToString();
            var currentAction = filterContext.RouteData.Values["Action"].ToString();
            string IP_Add = "";
            string Error_Desc = "";
            string Error_Type = ex is HttpException ? ((HttpException)ex).GetHttpCode().ToString() : "500";
            if (ex.InnerException != null)
                Error_Desc = ex.InnerException.ToString();
            else
                Error_Desc = ex.Message;
            if (ex.StackTrace != null && ex.StackTrace != "")
                Error_Desc = Error_Desc + " <b>StackTrace:</b> " + ex.StackTrace;
            if (ex.TargetSite != null)
                Error_Desc = Error_Desc + " <b>TargetSite: </b>" + ex.TargetSite;
            User objUsers = ((RightsU_Session)HttpContext.Current.Session[RightsU_Session.SESS_KEY]).Objuser;
            string SiteAddress = System.Configuration.ConfigurationManager.AppSettings["SiteAddress"];
            string FromMailId = System.Configuration.ConfigurationManager.AppSettings["FromMailId"];
            string ToMailId = System.Configuration.ConfigurationManager.AppSettings["ToMailId"];
            string Entity_Type = "";
            string ConnectionStringName = "";

            if (HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity] != null)
            {
                Entity_Type = ((LoginEntity)HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity]).FullName;
                ConnectionStringName = ((LoginEntity)HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity]).ConnectionStringName;
            }
            if (Error_Type != "404")
            {
                new USP_Service(ConnectionStringName).USP_SendMail_Page_Crashed(objUsers.Login_Name + " / " + objUsers.Security_Group.Security_Group_Name, SiteAddress, Entity_Type, currentController, currentAction, "", Error_Desc, Error_Type, IP_Add, FromMailId, ToMailId);
            }           
            filterContext.ExceptionHandled = true;
            var model = new HandleErrorInfo(filterContext.Exception, "Controllers", "Action");
            filterContext.Result = new ViewResult()
            {
                ViewName = "~/Views/Shared/Error.cshtml",
                ViewData = new ViewDataDictionary(model)
            };
        }
    }
}
