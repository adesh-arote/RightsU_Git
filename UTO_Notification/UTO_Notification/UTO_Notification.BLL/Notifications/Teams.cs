using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using UTO_Notification.Entities;

namespace UTO_Notification.BLL.Notifications
{
    public class Teams : Notification
    {
        USPService objUspService = new USPService();
        UTOLog logObj = new UTOLog();

        public override HttpResponses SaveNotification(NotificationInput obj)
        {
            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();

            if (obj.TO != null && obj.TO != "")
            {
                string[] to;
                string Toemails = "";
                if (Convert.ToString(obj.TO).IndexOf(';') > 0)
                    to = obj.TO.Split(';');
                else
                    to = obj.TO.Split(',');

                foreach (string str in to)
                {
                    if (str != "")
                        Toemails = str.Trim();
                    Regex regex = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$");
                    Match match = regex.Match(Toemails);

                    if (match.Success == false)
                    {
                        httpResponses.Message = "Email Id is not valid";
                        httpResponses.Status = false;
                        return httpResponses;
                    }
                }
            }
            else
            {
                httpResponses.Message = "Email Id is mandatory";
                httpResponses.Status = false;
                return httpResponses;
            }

            USPInsertNotification objOutput = objUspService.USPInsertNotification_Teams(obj.EventCategory, obj.NotificationType, obj.TO, obj.CC, obj.BCC, obj.Subject, obj.HTMLMessage, obj.TextMessage, obj.TransType, obj.TransCode, obj.ScheduleDateTime, obj.UserCode, obj.ClientName, obj.ForeignId);

            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objOutput);
            httpResponses.NECode = objOutput.NotificationsCode;

            if (httpResponses.NECode > 0)
            {
                httpResponses.Message = "Request Queued Successfully";
                httpResponses.Status = true;
            }

            return httpResponses;
        }
    }
}
