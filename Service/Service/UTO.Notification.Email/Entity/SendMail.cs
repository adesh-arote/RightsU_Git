using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;

namespace UTO.Notification.Email
{
    public class SendMail
    {
        //private properties
        public string Ip { get; set; }
        public int Port { get; set; }
        public string FromEmailId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }

        //public properties
        public string To { get; set; }
        public string CC { get; set; }
        public string Bcc { get; set; }
        public bool UseDefaultCredential { get; set; }
        public bool IsBodyHTML { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public bool EnableSsl { get; set; }

        SmtpClient Client;
        MailMessage Email;
        public SendMail()
        {
            //set private properties
            //this.Ip = ConfigurationSettings.AppSettings["SMTPServer"];
            //this.Port = Convert.ToInt32(ConfigurationSettings.AppSettings["SMTPPort"]);
            //this.FromEmailId = ConfigurationSettings.AppSettings["FromEmailId"];
            //this.UserName = ConfigurationSettings.AppSettings["NTUserName"];
            //this.Password = ConfigurationSettings.AppSettings["NTPassword"];
            this.EnableSsl = Convert.ToBoolean(ConfigurationSettings.AppSettings["EnableSsl"]);
            //set public properties
            this.UseDefaultCredential = Convert.ToBoolean(ConfigurationSettings.AppSettings["UseDefaultCredential"]);
            this.IsBodyHTML = true;
          //  this.Bcc = ConfigurationSettings.AppSettings["BCC"];
            //this.CC = "";
        }
        public void Send()
        {
            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["WriteLog"])) { UTO_Notification_Email.LogService("Inside Send"); }

            if (this.Port != 0)
                Client = new SmtpClient(this.Ip, this.Port);
            else
                Client = new SmtpClient(this.Ip);

            if (this.EnableSsl) Client.EnableSsl = true; else Client.EnableSsl = false;
            Client.UseDefaultCredentials = this.UseDefaultCredential;
            if (!Client.UseDefaultCredentials)
                Client.Credentials = new NetworkCredential(this.UserName, this.Password);

            Email = new MailMessage();
            Email.From = new MailAddress(this.FromEmailId);
            Email.To.Add(this.To.Replace(";", ","));
            if (!String.IsNullOrEmpty(this.CC))
                Email.CC.Add(this.CC.Replace(";",","));
            if (!String.IsNullOrEmpty(this.Bcc))
                Email.Bcc.Add(this.Bcc.Replace(";", ","));
            Email.IsBodyHtml = this.IsBodyHTML;
            Email.Body = this.Body;
            Email.Subject = this.Subject;
            Email.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["WriteLog"])) { UTO_Notification_Email.LogService("Before Send Enable SSL:" + this.EnableSsl.ToString()); }
            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["WriteLog"])) { UTO_Notification_Email.LogService("Before Send Use Default Credentials:" + this.UseDefaultCredential.ToString()); }
            Client.Send(Email);
            Email.Dispose();
        }

        public void Attachment(string FileAttachmentPath)
        {
            System.Net.Mail.Attachment attachment;
            attachment = new System.Net.Mail.Attachment(FileAttachmentPath);
            Email.Attachments.Add(attachment);
        }
    }
}