using System;
using System.IO;
using System.Net.NetworkInformation;
using System.Web;
using System.Xml.Linq;
using System.Data.SqlClient;
using System.Data;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Net.Mail;

namespace ClassError
{
    public class Common : System.Web.UI.WebControls.WebControl
    {
        #region Variables

        public string Msg;
        public string Subject;
        public string DisplayN;
        public string Path;
        public static int Count;
        public string _UserName;
        private string _EntityID;
        private string _EntityType;
        private string _EntityName;
        private int _SessionId;
        private string _EntityCode;
        private string _ConnectionString;
        private string _SpName;
        private string _ErrorMsg;
        private string _ErrorMsgInfo;



        #endregion

        #region properties

        public string ConnectionString
        {
            get { return _ConnectionString; }
            set { _ConnectionString = value; }
        }
        public string SpName
        {
            get { return _SpName; }
            set { _SpName = value; }
        }
        public string EntityID
        {
            get { return _EntityID; }
            set { _EntityID = value; }
        }
        public string UserName
        {
            get { return _UserName; }
            set { _UserName = value; }
        }
        public string EntityType
        {
            get { return _EntityType; }
            set { _EntityType = value; }
        }
        public string EntityName
        {
            get { return _EntityName; }
            set { _EntityName = value; }
        }
        public int SessionId
        {
            get { return _SessionId; }
            set { _SessionId = value; }
        }
        public string EntityCode
        {
            get { return _EntityCode; }
            set { _EntityCode = value; }
        }
        public string EmailSubject
        {
            get
            {
                return Subject;
            }
            set
            {
                Subject = value;
            }
        }

        public string DisplayName
        {
            get
            {
                return DisplayN;
            }
            set
            {
                DisplayN = value;
            }
        }
        #endregion

        
        public void SendErrorMail(Exception msgError, string UserName, string UserRole, string FromEmailID, string EmailTo,string EmailCc,string borwserInfo, string entityName)
        {
            Path = HttpContext.Current.Request.PhysicalApplicationPath + "XML\\ErrorLog.xml";
            try
            {
                if (string.IsNullOrEmpty(DisplayName))
                    DisplayName = "IT INFO";
                if (string.IsNullOrEmpty(EmailSubject))
                    EmailSubject = "Error";
                
                string FileName = HttpContext.Current.Request.Url.ToString();
                FileName = FileName.Substring(FileName.LastIndexOf("/") + 1);

                string Directoryname = ConfigurationManager.AppSettings["SiteAddress"].ToString();
                //Directoryname = Directoryname.Substring(Directoryname.LastIndexOf("/") + 2);

                System.Net.IPHostEntry ipHostInfo = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName());
                System.Net.IPAddress ipAddress = ipHostInfo.AddressList[0];

                string BackGroundColor = "#f7eaea";

                System.Net.Mail.SmtpClient SmtpMail = new SmtpClient(ConfigurationSettings.AppSettings["SMTPServer"].ToString());
                

                Msg = " <table  width=\"90%\" style=\"border: 1px solid #df4a40; background:" + BackGroundColor + ";\" rules=\"all\">" +
                      "<tr> <td style=\"height: 30px;width:20%;border: 1px solid #df4a40;\"> Error Ocurred in : </td>" +
                      "  <td  style=\"height: 30px;border: 1px solid #df4a40\"\"> " + Directoryname + "</td></tr> <tr>" +
                      "<td style=\"height: 30px;width:20%;border: 1px solid #df4a40;\"> Page Name  : </td><td style=\"height: 30px;border: 1px solid #df4a40\"\">" +
                      " " + FileName + "</td> </tr><tr> <td style=\"height: 30px;width:20%;border: 1px solid #df4a40;\">" +
                      "  LogIn User Name/User NTID :</td><td style=\"height: 30px;border: 1px solid #df4a40\"\">" + UserName + " / " + UserRole + "</td> </tr>" +
                      " <tr> <td style=\"height: 30px;width:20%;border: 1px solid #df4a40;\"> Entity :</td>" +
                      " <td style=\"height: 30px;border: 1px solid #df4a40\"\"> " + entityName + "</td> </tr>" + 
                      " <tr> <td style=\"height: 30px;width:20%;border: 1px solid #df4a40;\"> Error occured on :</td>" +
                       " <td style=\"height: 30px;border: 1px solid #df4a40\"\"> " + Convert.ToDateTime(DBUtil.getServerDate()).ToString("dd-MMM-yyyy hh:mm:ss tt") + "</td> </tr><tr><td style=\"height: 30px;border: 1px solid #df4a40\">" +
                          "Error name : </td>  <td style=\"height: 30px;border: 1px solid #df4a40\">" + msgError.Message + "</td></tr>" +
                          " <tr> <td style=\"height: 30px;border: 1px solid #df4a40\"> Host IP / Browser  : </td> <td style=\"height: 30px;border: 1px solid #df4a40\"\">" +
                          "  " + ipAddress + " / "+ borwserInfo +  " </td> </tr>   <tr> <td valign=\"top\" style=\"height: 30px;border: 1px solid #df4a40\"> Error Info: </td>" +
                          " <td style=\"height: 30px;border: 1px solid #df4a40\"\">  " + msgError.StackTrace + "   </td> </tr>" +
                          "         </table>";

                System.Net.Mail.MailMessage msg = new System.Net.Mail.MailMessage();
                if (EmailCc != "") msg.CC.Add(EmailCc);
                msg.To.Add(EmailTo);
                msg.From = new System.Net.Mail.MailAddress(FromEmailID, DisplayName.ToString()); ;
                msg.Subject = EmailSubject.ToString();
                msg.IsBodyHtml = true;
                msg.Body = Msg;

                SmtpMail.Send(msg);
                Count++;

                XDocument doc;
                if (!File.Exists(Path))
                {
                    doc = new XDocument();
                    doc.Add(new XElement("Root"));
                }
                else
                {
                    doc = XDocument.Load(Path);
                }

                doc.Root.Add(new XElement("data",
                    new XElement("ErrorId", Count),
                   new XElement("ErrorOcurredIn", Directoryname),
                   new XElement("Page", FileName),
                   new XElement("LogIn_UserName_UserRole", UserName + " / " + UserRole),
                    new XElement("ErrorOcurredOn", DateTime.Now.ToString()),
                    new XElement("Errorname", msgError.Message),
                    new XElement("HostIP", ipAddress),
                      new XElement("ErrorInfo", msgError.StackTrace)
                   )
                   );

                doc.Save(Path);

                if (string.IsNullOrEmpty(SpName) && string.IsNullOrEmpty(ConnectionString))
                {

                }
                else
                {
                    _ErrorMsg = msgError.Message.ToString();
                    _ErrorMsgInfo = msgError.StackTrace.ToString();
                }
            }
            catch (Exception e)
            {

            }
        }
              
    }
        
}
