using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Collections;
using System.Net.Mail;

namespace UTOFrameWork.FrameworkClasses {
    /// <summary>
    /// Summary description for SendMail
    /// </summary>
    public class SendMail {
        string _FromEmailId, _ToEmailId, _MailSubject, _MailText;
        string _ccEmailList = "", _bccEmailList = "";
        ArrayList _attachFileNames;
        public SendMail()
        {
        }
        public void setMailAdd(string strFromEmailID, string strToEmailID)
        {
            _FromEmailId = strFromEmailID;
            _ToEmailId = strToEmailID;
        }

        public ArrayList attachFileNames
        {
            get { return _attachFileNames; }
            set { _attachFileNames = value; }
        }
        public string ccEmailID
        {
            get
            {
                return _ccEmailList;
            }
            set
            {
                _ccEmailList = value;
            }
        }
        public string ToEmailId
        {
            get
            {
                return _ToEmailId;
            }
            set
            {
                _ToEmailId = value;
            }
        }
        public string FromEmailId
        {
            get
            {
                return _FromEmailId;
            }
            set
            {
                _FromEmailId = value;
            }
        }
        public string bccEmailID
        {
            get
            {
                return _bccEmailList;
            }
            set
            {
                _bccEmailList = value;
            }
        }
        public string MailSubject
        {
            get
            {
                return _MailSubject;
            }
            set
            {
                _MailSubject = value;
            }
        }
        public string MailText
        {
            get
            {
                return _MailText;
            }
            set
            {
                _MailText = value;
            }
        }

        public void send()
        {
            string uname = ConfigurationSettings.AppSettings["MailUid"];
            //string pwd = ConfigurationManager.AppSettings["MailPwd"];
            string pwd = System.Configuration.ConfigurationSettings.AppSettings["MailPwd"];
            int port = Convert.ToInt32(ConfigurationSettings.AppSettings["MailPort"].ToString());
            System.Net.Mail.MailMessage appmail = new System.Net.Mail.MailMessage();
            string[] temp = _ToEmailId.Split(';');
            for (int i = 0; i < temp.Length; i++)
                appmail.To.Add(temp[i]);
            appmail.From = new MailAddress(_FromEmailId);
            appmail.Subject = _MailSubject;
            appmail.Body = _MailText;
            if (_ccEmailList != "")
            {
                temp = _ccEmailList.Split(';');
                for (int i = 0; i < temp.Length; i++)
                    appmail.CC.Add(temp[i]);
            }
            if (_attachFileNames != null && _attachFileNames.Count > 0)
            {
                for (int i = 0; i < _attachFileNames.Count; i++)
                {
                    /* Create the email attachment with the uploaded file */
                    //MailAttachment attach = new MailAttachment(_attachFileNames[i].ToString());
                    Attachment attach = new Attachment(_attachFileNames[i].ToString());
                    /* Attach the newly created email attachment */
                    appmail.Attachments.Add(attach);
                }
            }

            appmail.IsBodyHtml = true;
            appmail.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
            System.Net.Mail.SmtpClient client = new SmtpClient(ConfigurationSettings.AppSettings["SMTPServer"].ToString());
            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["UseDefaultCredentials"].ToString().ToLower()))
            {
                client.UseDefaultCredentials = true;
            }
            else
            {
                client.UseDefaultCredentials = false;
                client.Port = port;
                client.Credentials = new System.Net.NetworkCredential(uname, pwd);
            }
            client.Send(appmail);
            appmail.Dispose();

        }

        public string getBody(string FileName)
        {
            // string path = HttpContext.Current.Server.MapPath("../MailFiles/" + FileName);// ConfigurationManager.AppSettings["MailFolder"] + FileName;
            // StreamReader filestream;
            // filestream = File.OpenText(path);
            string readcontents = "";
            // readcontents = filestream.ReadToEnd();
            return readcontents;
        }

        public void send(string uname, string pwd, string server)
        {
            System.Web.Mail.MailMessage appmail = new System.Web.Mail.MailMessage();
            appmail.To = _ToEmailId;
            appmail.From = _FromEmailId;
            appmail.Subject = _MailSubject;
            appmail.Body = _MailText;
            appmail.BodyFormat = System.Web.Mail.MailFormat.Html;
            appmail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate", "1");
            appmail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendusername", uname);
            appmail.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendpassword", pwd);
            System.Web.Mail.SmtpMail.SmtpServer = server;
            System.Web.Mail.SmtpMail.Send(appmail);
        }
    }
}