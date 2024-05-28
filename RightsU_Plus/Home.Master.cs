using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.SessionState;
using System.Web.UI;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using System.Web.UI.WebControls;
using System.Web.Mvc;
using System.Web.UI.HtmlControls;

public partial class Home : System.Web.UI.MasterPage
{
    public User objLoginUser { get; set; }

    protected RightsU_Session objSession;
    public LoginEntity objLoginEntity
    {
        get
        {
            if (Session["objLoginEntity"] == null)
                Session["objLoginEntity"] = new LoginEntity();
            return (LoginEntity)Session["objLoginEntity"];
        }
        set { Session["objLoginEntity"] = value; }
    }
    //protected override void OnLoad(EventArgs e)
    //{
    //    base.OnLoad(e);
    //    Page.Header.DataBind();
    //}

    private string url;
    private List<Email_Notification_Log> lstEmail_Notification_Log
    {
        get
        {
            if (Session["lstEmail_Notification_Log"] == null)
                Session["lstEmail_Notification_Log"] = new List<Email_Notification_Log>();
            return (List<Email_Notification_Log>)Session["lstEmail_Notification_Log"];
        }

        set
        {
            Session["lstEmail_Notification_Log"] = value;
        }
    }
    protected void Page_Init(object sender, EventArgs e)
    {
        string a = Convert.ToString(Session["PageName"]);


        url = ConfigurationManager.AppSettings["DefaultSiteUrl"].ToString().Trim();
        url = HttpRuntime.AppDomainAppVirtualPath + url.Replace("~", "");
        if (Session[RightsU_Session.SESS_KEY] == null)
        {
            //Response.Redirect(url); //need to be uncomment 
            //string JS = "parent.left_frame.location='" + url + "'";
            string JS = "window.open('" + url + "','_top')";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
            Response.Redirect("~\\Login\\Index");
            // base.OnLoad(e);
            return;
        }
        else
        {
            objSession = (RightsU_Session)Session[RightsU_Session.SESS_KEY];
            objLoginUser = (User)objSession.Objuser;
            SessAppTimeOut();
        }
    }
    public void setVal(string title)
    {
        hdnPageName.Value = title;
    }
    protected void Page_Load(object sender, EventArgs e)
    {


        //CheckUser();
        if (!this.IsPostBack)
        {
            System_Versions objSystemVersions = (System_Versions)Session["VersionDetails"];
            lblVersion.Text = objSystemVersions.Version_No;
            lblVersionDate.Text = Convert.ToDateTime(objSystemVersions.Version_Published_Date).ToString("dddd, MMMM dd,yyyy hh:mm tt");
            createHiddenForRights();
            //EntityName();
            lblEntityName.InnerText = objLoginUser.DefaultEntityName;
            if (objLoginUser.User_Image != null)
            {
                Img_ClientLogo.Src = Convert.ToString("Logo/" + objLoginUser.DefaultEntityLogoName);//Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["VersionFor"]) == "MSM" ? "Logo/network.png" : "Logo/vmpl.png";
                lblProfileName.InnerText = Convert.ToString(objLoginUser.First_Name + " "+ objLoginUser.Last_Name.Substring(0, 1));
            }
            else 
            {
                Img_ClientLogo.Src = Convert.ToString("Logo/" + objLoginUser.DefaultEntityLogoName);//Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["VersionFor"]) == "MSM" ? "Logo/network.png" : "Logo/vmpl.png";
                lblProfileName.InnerText = Convert.ToString(objLoginUser.First_Name +" " + objLoginUser.Last_Name.Substring(0, 1));
            }//Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["VersionFor"]) == "MSM" ? "Logo/network.png" : "Logo/vmpl.png";
            Menu();
            MessageKey objMessageKey = new MessageKey();
            objMessageKey = (MessageKey)Session["objMessageKey"];
            hdnDir.Value = objMessageKey.LayoutDirection;

            var paramValue = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Is_Allow_Multilanguage").Select(x => x.Parameter_Value).SingleOrDefault();
          
            List<System_Language> lstSystemLanguage = new System_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList();
            int systemLanguageCode = (lstSystemLanguage.Where(w => w.Is_Default == "Y").First() ?? new System_Language()).System_Language_Code;
            systemLanguageCode = (objLoginUser.System_Language_Code ?? systemLanguageCode);
            foreach (System_Language objsys in lstSystemLanguage)
            {
                HtmlGenericControl ili = new HtmlGenericControl("li");
                slimscroll.Controls.Add(ili); 
                ili.Attributes.Add("onclick", "ChangeLayoutDirection("+(objsys.System_Language_Code)+")");
                HtmlGenericControl ianchor = new HtmlGenericControl("a");
                ianchor.InnerText = Convert.ToString(objsys.Language_Name);
                HtmlGenericControl span1 = new HtmlGenericControl("span");
                span1.Attributes.Add("class", "item-code");
                span1.InnerText = Convert.ToString(objsys.System_Language_Code); 
                span1.Attributes.Add("style", "display:none");
                ianchor.Controls.Add(span1);
                HtmlGenericControl span2 = new HtmlGenericControl("span");
                span2.Attributes.Add("class", "layout-direction");
                span2.InnerText = Convert.ToString(objsys.Layout_Direction);
                span2.Attributes.Add("style", "display:none");
                ianchor.Controls.Add(span2);
                ili.Controls.Add(ianchor);
            }
            string alertDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Email_Alert_Days").Select(x => x.Parameter_Value).FirstOrDefault();
            var dt = DateTime.Today.AddDays(Convert.ToDouble(alertDays));
            int count = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Read == "N" && string.IsNullOrEmpty(x.Email_Body) == false
            && x.User_Code == objLoginUser.Users_Code && x.Created_Time >= dt
            && x.Email_Config.Email_Config_Detail.Select(xe => xe.OnScreen_Notification).FirstOrDefault() == "Y").Select(s => s.Email_Notification_Log_Code).Count();
            if (count > 99) {
                TotalEmailCount.InnerHtml = "99+";
            }
            else
            {
                TotalEmailCount.InnerHtml =Convert.ToString(count);
            }
            hdnTotalEmailCount.Value =Convert.ToString(count);
            List<Email_Config> lstEmailConfig = new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                                    x.Email_Config_Detail.Select(s => s.OnScreen_Notification).FirstOrDefault() == "Y")
                                    .OrderBy(x => x.Email_Type).ToList();
            List<Email_Notification_Log> lstEmail_Notification_Log = (List<Email_Notification_Log>)Session["lstEmail_Notification_Log"];

            var EmailConfig = new List<Email_Config>();
            foreach (Email_Config objEmail in lstEmailConfig)
            {
                  objEmail.TotalCount = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName)
                  .SearchFor(x => x.User_Code == objLoginUser.Users_Code
                   && x.Email_Config_Code == objEmail.Email_Config_Code && x.Created_Time >= dt
                  ).Count();

                  objEmail.Count = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Read == "N"
                   && x.User_Code == objLoginUser.Users_Code && string.IsNullOrEmpty(x.Email_Body) == false
                  && x.Email_Config_Code == objEmail.Email_Config_Code && x.Created_Time >= dt
                 ).Count();
            }
            EmailConfig = lstEmailConfig;

           int NoNotiCount = 0;
            HtmlGenericControl div = new HtmlGenericControl("div");
            EmailPanel.Controls.Add(div);
            div.Attributes.Add("Id", "DivEmailConfig");
            foreach(Email_Config item in EmailConfig)
            {
                if(item.TotalCount > 0)
                {
                    NoNotiCount = 1;
                    HtmlGenericControl liEmail = new HtmlGenericControl("li");
                    liEmail.Attributes.Add("class", "liEmail");
                    liEmail.Attributes.Add("onclick", "EmailPopup('"+item.Email_Config_Code+"','"+ item.Email_Type +"','"+ item.Count +"')");
                    div.Controls.Add(liEmail);
                    HtmlGenericControl ianchor = new HtmlGenericControl("a");
                    ianchor.InnerText = Convert.ToString(item.Email_Type);
                    ianchor.Attributes.Add("href", "#");
                    liEmail.Controls.Add(ianchor);
                    HtmlGenericControl TotalECount = new HtmlGenericControl("span");
                    TotalECount.InnerText = Convert.ToString(item.Count);
                    TotalECount.Attributes.Add("class", "EmailCount");
                    TotalECount.Attributes.Add("title", "Unseen Message");
                    TotalECount.Attributes.Add("Id", "TotalECount_" + item.Email_Config_Code + "");
                    liEmail.Controls.Add(TotalECount);
                }

            }
            if(NoNotiCount == 0)
            {
                HtmlGenericControl liNoEmail = new HtmlGenericControl("li");
                div.Controls.Add(liNoEmail);
                HtmlGenericControl NoECountSpan = new HtmlGenericControl("span");
                NoECountSpan.InnerText = "No new notifications";
                liNoEmail.Controls.Add(NoECountSpan);
            }
            if(NoNotiCount > 0)
            {
                HtmlGenericControl emailPNL = new HtmlGenericControl("li");
                emailPNL.Attributes.Add("class", "emailPNL");
                emailPNL.Attributes.Add("style", "text-align:center");
                EmailPanel.Controls.Add(emailPNL);

                HtmlGenericControl ianchor = new HtmlGenericControl("a");
                ianchor.InnerText = "Mark all as Read";
                ianchor.Attributes.Add("onclick", "MarkAllRead()");
                ianchor.Attributes.Add("Id", "MarkAsRead");
                emailPNL.Controls.Add(ianchor);

            }
        }
    }

    private void createHiddenForRights()
    {
        //this.form1.Controls.Add(hdnRights);

        if (objLoginUser.Security_Group.Security_Group_Code > 0)
        {
            hdnRights.ID = "hdnRights";
            SecurityGroup ObjSecGr = new SecurityGroup();
            ObjSecGr.IntCode = objLoginUser.Security_Group.Security_Group_Code;

            int ModuleCode = (Request.QueryString["moduleCode"] != null ? Convert.ToInt32(Request.QueryString["moduleCode"]) : objLoginUser.moduleCode);
            objLoginUser.moduleCode = ModuleCode;
            string strUserRights = "";

            if (ModuleCode > 0)
                strUserRights = ObjSecGr.getArrUserRightCodesString(ObjSecGr.IntCode, ModuleCode, "");

            hdnRights.Value = strUserRights.Trim();
        }
    }

    public void CheckUser()
    {
        if (Session[RightsU_Session.SESS_KEY] == null)
        {
            Response.Redirect("Login/Index");
        }
        else
        {
            if (((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser != null)
            {
                objLoginUser = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;
            }
        }
    }


    private void SessAppTimeOut()
    {
        HttpSessionState ss = HttpContext.Current.Session;
        string sessionId = ss.SessionID;
        string entityKey = Convert.ToString(HttpContext.Current.Session["Entity_Type"]);
        Hashtable htLoggedUser = new Hashtable();

        if (Application["LOGGEDUSERS"] != null)
        {
            htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];

            if (htLoggedUser.ContainsKey(objLoginUser.Login_Name + "#" + entityKey))
            {
                string[] timeSessionId = new string[2];
                timeSessionId = GetTimeAndSessionId(Convert.ToString(htLoggedUser[objLoginUser.Login_Name + "#" + entityKey]));
                string storedSessionId = timeSessionId[1];

                if (storedSessionId != sessionId)
                {
                    // htLoggedUser.Remove(objLoginUser.Login_Name);
                    Response.Redirect("~\\Login\\Index");
                }
                else
                {
                    int maxTime = Session.Timeout;
                    long maxTimeInSec = maxTime * 60;
                    long loggedTime = Convert.ToInt64(timeSessionId[0]);
                    long currentTime = Convert.ToInt64(GetDateComparisionNumber(DateTime.Now.ToString("s")));
                    long totalTimeDiffInSec = currentTime - loggedTime;

                    if (totalTimeDiffInSec > maxTimeInSec)
                    {
                        htLoggedUser.Remove(objLoginUser.Login_Name + "#" + entityKey);
                        Response.Redirect("~\\Login\\Index");
                    }
                    else
                    {
                        htLoggedUser.Remove(objLoginUser.Login_Name + "#" + entityKey);
                        htLoggedUser.Add(objLoginUser.Login_Name + "#" + entityKey, GetDateComparisionNumber(DateTime.Now.ToString("s")) + "#" + sessionId);
                        Application.Lock();
                        Application["LOGGEDUSERS"] = htLoggedUser;
                        Application.UnLock();
                        //break;
                    }
                }
            }
            else
            {
                Response.Redirect("~\\Login\\Index");
            }
        }
    }

    public string[] GetTimeAndSessionId(string timeSessionId)
    {
        string[] timeSession = new string[2];
        timeSession = timeSessionId.Split('#');
        return timeSession;
    }

    public static string GetDateComparisionNumber(string strDate)
    {
        string actualStr = strDate.Trim().Replace("T", "~").Replace(":", "~").Replace("-", "~");
        string[] arrDt = actualStr.Split('~');
        string tmpTimeInSec = arrDt[0].Trim() + arrDt[1].Trim() + arrDt[2].Trim() + Convert.ToString(Convert.ToInt64(Convert.ToInt64(arrDt[3].Trim()) * 60 * 60) + Convert.ToInt64(Convert.ToInt64(arrDt[4].Trim()) * 60) + Convert.ToInt64(arrDt[5].Trim()));
        //return Convert.ToInt64(tmpTimeInSec);
        return tmpTimeInSec;
    }

    public void Menu()
    {
        List<int> Menulist = (List<int>)Session["Menu"];
        string Is_Approve = "";

        if (Session["Is_Approve"] != null)
            Is_Approve = (string)Session["Is_Approve"];

        if (Menulist.Contains(GlobalParams.ModuleCodeForTitle))
            Li_Titles.Visible = true;
        else
            Li_Titles.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForAcqDeal))
            Li_AcqDeals.Visible = true;
        else
            Li_AcqDeals.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForSynDeal))
            Li_SynDeals.Visible = true;
        else
            Li_SynDeals.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForMusicDeal))
            Li_MusicDeals.Visible = true;
        else
            Li_MusicDeals.Visible = false;

        if (Is_Approve == "Yes")
            Li_ApprovalList.Visible = true;
        else
            Li_ApprovalList.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForMasters))
            Li_Master.Visible = true;
        else
            Li_Master.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForAvail))
            Li_Avail.Visible = true;
        else
            Li_Avail.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForReports))
            Li_Reports.Visible = true;
        else
            Li_Reports.Visible = false;

        //if (Menulist.Contains(GlobalParams.ModuleCodeForUploads))
        //    Li_Upload.Visible = true;
        //else
        //    Li_Upload.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeFor_IPR_Application))
            Li_IPR.Visible = true;
        else
            Li_IPR.Visible = false;
        //Added by akshay
        if (Menulist.Contains(GlobalParams.ModuleCodeForGlossary))
            Li_Glossary.Visible = true;
        else
            Li_Glossary.Visible = false;
       
        if (Menulist.Contains(GlobalParams.ModuleCodeForAskanExpert))
            Li_AskAnExpert.Visible = true;
        else
            Li_AskAnExpert.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForContactInfo))
            Li_ContactInfo.Visible = true;
        else
            Li_ContactInfo.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForFAQ))
            Li_FAQ.Visible = true;
        else
            Li_FAQ.Visible = false;

        //Ended by akshay

        if (Menulist.Contains(GlobalParams.ModuleCodeForContent))
            Li_Content.Visible = true;
        else
            Li_Content.Visible = false;
        if (Menulist.Contains(GlobalParams.ModuleCodeForMusic_Title))
            Li_MusicTitle.Visible = true;
        else
            Li_MusicTitle.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForMusic_Hub))
            Li_MusicHub.Visible = true;
        else
            Li_MusicHub.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForMusic_Title) || Menulist.Contains(GlobalParams.ModuleCodeForContent))
            firstSap.Visible = true;
        else
            firstSap.Visible = false;

        if (Menulist.Contains(GlobalParams.ModuleCodeForAvail) || Menulist.Contains(GlobalParams.ModuleCodeForMasters)
            || Menulist.Contains(GlobalParams.ModuleCodeForReports))
            SecondSap.Visible = true;
        else
            SecondSap.Visible = false;
    }
   

    //public void EntityName()
    //{
    //    string Entity_Type = Convert.ToString(Session["Entity_Type"]);
    //    if (Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["VersionFor"]) == "MSM")
    //    {
    //        lblEntityName.InnerText = "Multi Screen Media Private Limited";
    //    }
    //    else
    //    {
    //        if (System.Configuration.ConfigurationManager.AppSettings["RightsU"].ToString().Trim().ToUpper() == Entity_Type.ToUpper())
    //        {
    //            lblEntityName.InnerText = "Viacom18 Media Pvt Ltd";
    //        }
    //        else if (System.Configuration.ConfigurationManager.AppSettings["RightsU_VMPL"].ToString().Trim().ToUpper() == Entity_Type.ToUpper())
    //        {
    //            lblEntityName.InnerText = "Viacom18 Motion Pictures";
    //        }
    //    }

    //}

}