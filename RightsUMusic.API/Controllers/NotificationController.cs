using RightsUMusic.BLL.Services;
using RightsUMusic.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace RightsUMusic.API.Controllers
{
    public class NotificationController : ApiController
    {
        private readonly NotificationManagementServices obj = new NotificationManagementServices();

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetNotificationRequestList(NotficationListInput objNotficationListInput)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();
            int RecordCount = 0;

            MHRequest objMHRequest = new MHRequest();
            objMHRequest.MHRequestTypeCode = 1;
            objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            // objMHRequest.UsersCode = Convert.ToInt32(UserCode);
            IEnumerable<USPMHNotificationList> lstNotificationList = new List<USPMHNotificationList>();
            Return _objRet = new Return();
            try
            {
                lstNotificationList = obj.GetNotificationList(objNotficationListInput.RecordFor, Convert.ToInt32(UserCode), out RecordCount);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, NotifiactionList = lstNotificationList, UnReadCount = RecordCount }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage ReadNotification(MHNotificationLog objMHNotificationLog)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");

            objMHNotificationLog = obj.GetByIdMHNotification(objMHNotificationLog.MHNotificationLogCode ?? 0);

            objMHNotificationLog.Is_Read = "Y";

            try
            {
                objMHNotificationLog = obj.ReadNotification(objMHNotificationLog);
                var UserName = obj.GetUserName("Select Login_Name From Users where Users_Code = " + objMHNotificationLog.User_Code).FirstOrDefault();
                _objRet.Message = "Notification marked as read.";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, NotificationDetail = objMHNotificationLog, UserName = UserName.Login_Name }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

       //Commented by Rahul

    }

    public class NotficationListInput
    {
        public string RecordFor { get; set; }
    }
}
