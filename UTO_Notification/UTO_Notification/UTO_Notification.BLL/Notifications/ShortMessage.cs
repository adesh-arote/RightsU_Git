using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using UTO_Notification.Entities;

namespace UTO_Notification.BLL.Notifications
{
    public class ShortMessage : Notification
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
                to = obj.TO.Split(';');
                foreach (string str in to)
                {
                    if (str != "")
                        Toemails = str.Trim();
                    Regex regex = new Regex(@"^(\+?\d{1,4}[\s-])?(?!0+\s+,?$)\d{10}\s*,?$");
                    Match match = regex.Match(Toemails);

                    if (match.Success == false)
                    {
                        httpResponses.Message = "Mobile number is not valid";
                        httpResponses.Status = false;
                        return httpResponses;
                    }
                }
            }
            else
            {
                httpResponses.Message = "Mobile number is mandatory";
                httpResponses.Status = false;
                return httpResponses;
            }

            USPInsertNotification objOutput = objUspService.USPInsertNotification(obj.EventCategory, obj.NotificationType, obj.TO, obj.CC, obj.BCC, obj.Subject, obj.HTMLMessage, obj.TextMessage, obj.TransType, obj.TransCode, obj.ScheduleDateTime, obj.UserCode, obj.ClientName, obj.ForeignId);

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
