using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Collections;
using System.Configuration;

using System.Web;
using System.Web.Mvc;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.Caching;
using System.Web.SessionState;
using System.IO;


using System.Globalization;
using System.Web.SessionState;
using System.DirectoryServices;
using System.Security.Cryptography;
using System.Text;
using System.Data;
using UTOFrameWork.FrameworkClasses;
using System.Reflection;

namespace RightsU_Plus.Controllers
{
    public class LoginController : Controller
    {

        private List<LoginEntity> lstLoginEntities
        {
            get
            {
                if (Session["lstLoginEntities"] == null)
                    Session["lstLoginEntities"] = new List<LoginEntity>();
                return (List<LoginEntity>)Session["lstLoginEntities"];
            }
            set
            {
                Session["lstLoginEntities"] = value;
            }
        }


        #region --- --- Event Handlers --- ---
        public string RedirectToApproval
        {
            get
            {
                if (Session["RedirectToApproval"] == null)
                    Session["RedirectToApproval"] = "N";
                return Convert.ToString(Session["RedirectToApproval"]);
            }
            set
            {
                Session["RedirectToApproval"] = value;
            }
        }
        public int Login_Details_Code
        {
            get
            {
                if (Session["Login_Details_Code"] == null)
                    Session["Login_Details_Code"] = 0;
                return Convert.ToInt32(Session["Login_Details_Code"]);
            }
            set
            {
                Session["Login_Details_Code"] = value;
            }
        }
        private string logFileName = "Reshma_Log.txt";
        private Login_Details_Service objLDS_Service
        {
            get
            {
                if (Session["objLDS_Service"] == null)
                    Session["objLDS_Service"] = new Login_Details_Service(objLoginEntity.ConnectionStringName);
                return (Login_Details_Service)Session["objLDS_Service"];
            }
            set
            {
                Session["objLDS_Service"] = value;
            }
        }
        private LoginParameters objLoginParam
        {
            get
            {
                if (Session["objLoginParam"] == null)
                    Session["objLoginParam"] = new LoginParameters();
                return (LoginParameters)Session["objLoginParam"];
            }
            set
            {
                Session["objLoginParam"] = value;
            }
        }
        private Users_Password_Detail_Service objUPD_Service
        {
            get
            {
                if (Session["objUPD_Service"] == null)
                    Session["objUPD_Service"] = new Users_Password_Detail_Service(objLoginEntity.ConnectionStringName);
                return (Users_Password_Detail_Service)Session["objUPD_Service"];
            }
            set
            {
                Session["objUPD_Service"] = value;
            }
        }
        public User_Service objUser_Service
        {
            get
            {
                if (Session["User_Service"] == null)
                    Session["User_Service"] = new User_Service(objLoginEntity.ConnectionStringName);
                return (User_Service)Session["User_Service"];
            }
            set { Session["User_Service"] = value; }
        }
        public int UserCode
        {
            get
            {
                if (TempData["UserCode"] == null)
                    TempData["UserCode"] = 0;
                return Convert.ToInt32(TempData["UserCode"]);
            }
            set
            {
                TempData["UserCode"] = value;
            }
        }
        public int ModuleCode
        {
            get
            {
                if (Session["ModuleCode"] == null)
                    Session["ModuleCode"] = 0;
                return Convert.ToInt32(Session["ModuleCode"]);
            }
            set
            {
                Session["ModuleCode"] = value;
            }
        }
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

        DataSet ds = new DataSet();
        public SelectList BindEntity(string code = "")
        {
            /*if (Convert.ToString(ConfigurationManager.AppSettings["VersionFor"]) == "MSM")
            {
                arrEntity.Add(new SelectListItem() { Value = ConfigurationManager.AppSettings["RightsU"].ToString(), Text = "SPN - Broadcaster" });
            }
            else if (Convert.ToString(ConfigurationManager.AppSettings["VersionFor"]) == "V18")
            {
                arrEntity.Add(new SelectListItem() { Value = ConfigurationManager.AppSettings["RightsU_VMPL"].ToString(), Text = "VMP" });
                arrEntity.Add(new SelectListItem() { Value = ConfigurationManager.AppSettings["RightsU"].ToString(), Text = "VIACOM18 Network" });
            }
            else
            {
                arrEntity.Add(new SelectListItem() { Value = ConfigurationManager.AppSettings["RightsU"].ToString(), Text = Convert.ToString(ConfigurationManager.AppSettings["VersionFor"]) });
            }*/

            string filePath = Server.MapPath("~") + "\\EntitiesList.xml";
            System.IO.FileStream fsReadXml = new System.IO.FileStream(filePath, System.IO.FileMode.Open);
            ds.ReadXml(fsReadXml);
            fsReadXml.Close();

            lstLoginEntities.Clear();
            foreach (DataRow dRow in ds.Tables[0].Rows)
            {
                LoginEntity objLE = new LoginEntity();
                objLE.ShortName = dRow["ShortName"].ToString();
                objLE.FullName = dRow["FullName"].ToString();
                objLE.DatabaseName = dRow["DatabaseName"].ToString();
                objLE.ConnectionStringName = dRow["ConnectionStringName"].ToString();
                objLE.ReportingServerFolder = dRow["ReportingServerFolder"].ToString();
                lstLoginEntities.Add(objLE);
            }
            if (Request.Cookies["Entity_Type"] != null)
                code = Request.Cookies["Entity_Type"].Value.ToString();

            objLoginEntity.ConnectionStringName = "RightsU_MotionPicture";
            string SelectedEntity = Convert.ToString(Session["Entity_Type"]);
            return new SelectList(lstLoginEntities, "ShortName", "ShortName", SelectedEntity);
        }
        private void ClearDataFromApp()
        {
            SaveLoginDetails(0, 0, "Logout");
            Hashtable htLoggedUser = new Hashtable();
            HttpApplicationState Application = HttpContext.ApplicationInstance.Application;

            htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];
            User objTemp = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;

            if (htLoggedUser.ContainsKey(objTemp.Login_Name + "#" + Convert.ToString(Session["Entity_Type"])))
            {
                htLoggedUser.Remove(objTemp.Login_Name + "#" + Convert.ToString(Session["Entity_Type"]));
                Application.Lock();
                Application["LOGGEDUSERS"] = htLoggedUser;
                Application.UnLock();
                OnlineVisitorsContainer.Visitors.Remove(this.Session.SessionID);
            }
        }
        #endregion

        public ActionResult Index(string alertMsg = "", string LoggedUserName = "", string strUserName = "", string strPassword = "")
        {
            if (Request.QueryString["Action"] != null)
            {
                string Action = Convert.ToString(Request.QueryString["Action"]);
                string Code = Convert.ToString(Request.QueryString["Code"]);
                string Type = Convert.ToString(Request.QueryString["Type"]);
                string Req = Convert.ToString(Request.QueryString["Req"]);

                objLoginParam.Action = Action;
                objLoginParam.DealCode = Convert.ToInt32(Code); ;
                objLoginParam.ModuleCode = Convert.ToInt32(Type);
                objLoginParam.Req = Req;
            }
            else if (Request.QueryString["ReleaseAC"] == null)
                objLoginParam = null;

            string a = Convert.ToString(System.Web.HttpContext.Current.Session["Entity_Type"]);
            setDefaultProperty(System.Web.HttpContext.Current.Response, System.Web.HttpContext.Current.Request);
            ViewBag.BindEntity = BindEntity("");
            GetSystemVersion();
            TempData["LOGGEDUSER"] = LoggedUserName;
            TempData["STRUSERNAME"] = strUserName;
            TempData["STRPASSWORD"] = strPassword;

            if (ConfigurationManager.AppSettings["isLDAPAuthReqd"].ToString().Trim().ToUpper() == "Y")
                ViewBag.ForgotPwdVisibility = false;
            else
                ViewBag.ForgotPwdVisibility = true;
            HttpApplicationState Application = HttpContext.ApplicationInstance.Application;

            if (Request.QueryString["isReset"] != null && Request.QueryString["isReset"].ToString().ToUpper().Trim() == "Y" && Session[RightsU_Session.SESS_KEY] != null && Application["LOGGEDUSERS"] != null)
            {
                if (Application["LOGGEDUSERS"] != null)
                    ClearDataFromApp();

                Session.Abandon();
            }
            else if (Request.QueryString["ReleaseAC"] != null)
            {
                if (Request.QueryString["ReleaseAC"].ToString().ToUpper().Trim() == "Y")
                {
                    if (Request.QueryString["name"] != null)
                    {
                        Hashtable htLoggedUser = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
                        htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];
                        string[] timeSessionId = new string[2];

                        timeSessionId = getTimeAndSessionId(Convert.ToString(htLoggedUser[Request.QueryString["name"] + "#" + Convert.ToString(Session["Entity_Type"])]));
                        htLoggedUser.Remove(Request.QueryString["name"] + "#" + Convert.ToString(Session["Entity_Type"]));
                        OnlineVisitorsContainer.Visitors.Remove(timeSessionId[1]);
                        Application.Lock();
                        Application["LOGGEDUSERS"] = htLoggedUser;
                        Application.UnLock();
                        TempData["Name"] = Request.QueryString["name"].ToString();
                        TempData["SelectedEntity"] = Convert.ToString(Session["Entity_Type"]);
                        TempData["STRUSERNAME"] = TempData["Name"];
                        alertMsg = "Your earlier session has been cleared, Please re-login";
                    }
                }
            }
            ViewBag.AlertMsg = alertMsg;
            Session["RedirectToApproval"] = null;


            return View("Index");
        }

        public ActionResult Login(string Entitycode = "", string Username = "", string Password = "")
        {
            ViewBag.BindEntity = BindEntity("");
            GetSystemVersion();
            LoginEntity objLoginEntity = lstLoginEntities.Where(w => w.ShortName == Entitycode).FirstOrDefault();
            if (objLoginEntity == null)
                objLoginEntity = new LoginEntity();

            Session[RightsU_Session.CurrentLoginEntity] = objLoginEntity;
            Session["objLoginEntity"] = objLoginEntity;

            Session["Entity_Type"] = Entitycode.Trim();
            string alertMsg = "";
            TempData["FromPage"] = "Login";
            Session["lstEmail_Notification_Log"] = null;
            HttpCookie myCookie = null;
            objUser_Service = null;
            objLDS_Service = null;
            objUPD_Service = null;
            myCookie = new HttpCookie("Entity_Type");
            Response.Cookies.Add(myCookie);
            myCookie.Value = Entitycode;
            myCookie.Expires = DateTime.MaxValue;
            string IsLDAPAuthReq = ConfigurationManager.AppSettings["isLDAPAuthReqd"].ToString().Trim().ToUpper();
            string strRUUsers = Convert.ToString(DBUtil.GetSystemParameterValue("RU_System_Users"));
            string[] arrRUUsers = strRUUsers.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            RightsU_Entities.User objUser = null;
            if (IsLDAPAuthReq == "Y")
            {
                objUser = validateUser(Username.ToString().Trim());
                if (objUser != null)
                    if (arrRUUsers.Contains(objUser.Users_Code.ToString()))
                        objUser = (User)validateUser(Username.ToString().Trim(), Password.ToString().Trim());

            }
            else
                objUser = (User)validateUser(Username, Password);

            bool isValidlogin = true;
            if (objUser != null)
            {
                if (objUser.Is_Active.ToUpper() == "Y")
                {

                    List<USP_Get_Login_Details_Result> lstUSP_Get_Login_Details = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Login_Details("MLA,MLM,DEN,DEL,PVD", objUser.Default_Entity_Code, objUser.Users_Code).ToList();
                    int MaxLoginAttempts = Convert.ToInt32(lstUSP_Get_Login_Details.Where(x => x.Data_For == "MLA").Select(s => s.Parameter_Value).FirstOrDefault());
                    if ((IsLDAPAuthReq != "Y" || arrRUUsers.Contains(objUser.Users_Code.ToString())) && objUser.Password_Fail_Count >= MaxLoginAttempts)
                    {
                        try
                        {
                            DateTime currenTime = DateTime.Now;
                            DateTime lastLoginTime = DateTime.MinValue;

                            if (!objUser.Last_Updated_Time.Equals(null))
                                lastLoginTime = Convert.ToDateTime(objUser.Last_Updated_Time);

                            int time = Convert.ToInt32(currenTime.Subtract(lastLoginTime).TotalMinutes);
                            int MaxLockTimeMinutes = Convert.ToInt32(lstUSP_Get_Login_Details.Where(x => x.Data_For == "MLM").Select(s => s.Parameter_Value).FirstOrDefault());

                            if (time >= MaxLockTimeMinutes)
                            {
                                // Release Lock
                                objUser.Password_Fail_Count = 0;
                                objUser.Last_Updated_Time = DateTime.Now;
                                objUser.EntityState = State.Modified;
                                objUser_Service.Save(objUser);
                            }
                        }
                        catch (Exception)
                        { }
                    }

                    if (objUser.Password_Fail_Count < MaxLoginAttempts || IsLDAPAuthReq == "Y")
                    {
                        HttpSessionState ss = System.Web.HttpContext.Current.Session;
                        string sessionId = ss.SessionID;
                        Session["SessionId"] = sessionId;
                        Hashtable htLoggedUser = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
                        HttpApplicationState Application = HttpContext.ApplicationInstance.Application;

                        if (Application["LOGGEDUSERS"] != null)
                        {
                            htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];

                            if (htLoggedUser.ContainsKey(objUser.Login_Name + "#" + Entitycode))
                            {
                                isValidlogin = false;
                                int maxTime = Session.Timeout;
                                long maxTimeInSec = maxTime * 60;
                                string[] timeSessionId = new string[2];
                                timeSessionId = getTimeAndSessionId(Convert.ToString(htLoggedUser[objUser.Login_Name + "#" + Entitycode]));
                                long loggedTime = Convert.ToInt64(timeSessionId[0]);
                                long currentTime = Convert.ToInt64(getDateComparisionNumber(DateTime.Now.ToString("s")));
                                long totalTimeDiffInSec = currentTime - loggedTime;


                                setDefaultProperty(System.Web.HttpContext.Current.Response, System.Web.HttpContext.Current.Request);
                                ViewBag.BindEntity = BindEntity("");
                                TempData["LOGGEDUSER"] = Username.Trim();
                                TempData["STRUSERNAME"] = Username.Trim();
                                TempData["STRPASSWORD"] = Password.Trim();
                                ViewBag.AlertMsg = alertMsg;
                                return View("Index");
                            }
                        }

                        objUser.Password_Fail_Count = 0;
                        objUser.Last_Updated_Time = DateTime.Now;
                        objUser.EntityState = State.Modified;
                        objUser_Service.Save(objUser);

                        htLoggedUser.Add(objUser.Login_Name + "#" + Entitycode, getDateComparisionNumber(DateTime.Now.ToString("s")) + "#" + sessionId);
                        Application.Lock();
                        Application["LOGGEDUSERS"] = htLoggedUser;
                        Application.UnLock();



                        if (!OnlineVisitorsContainer.Visitors.ContainsKey(System.Web.HttpContext.Current.Session.SessionID))
                        {
                            WebsiteVisitor currentVisitor = new WebsiteVisitor(System.Web.HttpContext.Current, Username, Entitycode);
                            OnlineVisitorsContainer.Visitors.Add(currentVisitor.SessionId, currentVisitor);
                        }

                        if (Convert.ToString(ConfigurationManager.AppSettings["isLDAPAuthReqd"]).Trim() == "Y" && !arrRUUsers.Contains(objUser.Users_Code.ToString()))
                        {
                            alertMsg = LDAPValidation(objUser, Username, Password);
                            if (alertMsg == "LDAPAUTH")
                            {
                                objUser.DefaultEntityName = Convert.ToString(lstUSP_Get_Login_Details.Where(x => x.Data_For == "DEN").Select(s => s.Parameter_Value).FirstOrDefault());
                                objUser.DefaultEntityLogoName = Convert.ToString(lstUSP_Get_Login_Details.Where(x => x.Data_For == "DEL").Select(s => s.Parameter_Value).FirstOrDefault());

                                RightsU_Session objUtoSession = new RightsU_Session();
                                objUtoSession.Objuser = objUser;
                                Session[RightsU_Session.SESS_KEY] = objUtoSession;

                                List<USP_GetMenu_Result> LoadMenuList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetMenu(objUser.Security_Group_Code.ToString(), "Y", objUser.Users_Code).ToList();
                                List<int> lstMenu = LoadMenuList.Select(x => x.Module_Code ?? 0).ToList();

                                if (lstMenu.Count > 0)
                                {
                                    Session["Menu"] = lstMenu;
                                    Session["Is_Approve"] = null;

                                    if (lstMenu.Contains(GlobalParams.ModuleCodeForAcqDeal) || lstMenu.Contains(GlobalParams.ModuleCodeForSynDeal) || lstMenu.Contains(GlobalParams.ModuleCodeForMusicDeal))
                                    {
                                        int ApproveDealCount = getApproveRight(objUser.Security_Group_Code ?? 0);
                                        if (ApproveDealCount > 0)
                                        {
                                            Session["Is_Approve"] = "Yes";
                                            Session["Menu"] = lstMenu;
                                        }
                                    }
                                }
                                else
                                    Session["Menu"] = null;

                                #region-----Email Approval Redirect to deal---
                                if (objLoginParam.Action == "Y" && isValidlogin)
                                {
                                    string ShowAlertAuth = "You are not authorised user for this deal";
                                    int[] arrRights = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objUser.Security_Group_Code
                                    && i.System_Module_Right.Module_Code == objLoginParam.ModuleCode).Select(i => i.System_Module_Right.Right_Code).Distinct().ToArray();

                                    bool hasRight = false;
                                    bool allowViewOnly = false;
                                    if (objLoginParam.Req == "SA")
                                    {
                                        hasRight = arrRights.Contains(GlobalParams.RightCodeForApprove);
                                        if (!hasRight)
                                            allowViewOnly = hasRight = arrRights.Contains(GlobalParams.RightCodeForView);
                                    }
                                    else if (objLoginParam.Req == "A" || objLoginParam.Req == "R")
                                        allowViewOnly = hasRight = arrRights.Contains(GlobalParams.RightCodeForView);

                                    if (hasRight)
                                    {
                                        int dealBUCode = 0;
                                        if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                                            dealBUCode = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;
                                        else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                                            dealBUCode = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;
                                        else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForMusicDeal)
                                            dealBUCode = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;

                                        int[] arrBUCodes = new Users_Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Users_Code == objUser.Users_Code).Select(s => s.Business_Unit_Code ?? 0).ToArray();

                                        hasRight = arrBUCodes.Contains(dealBUCode);
                                    }

                                    if (hasRight)
                                    {
                                        int Record_Locking_Code = 0;
                                        string message = "";
                                        string ShowAlertApp = "Deal is Already Approved";
                                        string ShowAlertRej = "Deal is Already Rejected";
                                        string ShowAlertOpen = "Deal is Open";
                                        CommonUtil objCommonUtil = new CommonUtil();
                                        bool isLocked = objCommonUtil.Lock_Record(objLoginParam.DealCode, objLoginParam.ModuleCode, objUser.Users_Code, out Record_Locking_Code, out message, objLoginEntity.ConnectionStringName);
                                        if (isLocked)
                                        {
                                            GlobalController objGC = new GlobalController();
                                            if (objLoginParam.Req == "SA")
                                            {
                                                string dealWorkflowStatus = "";
                                                if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                                                    dealWorkflowStatus = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;
                                                else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                                                    dealWorkflowStatus = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;
                                                else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForMusicDeal)
                                                    dealWorkflowStatus = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;


                                                if (!string.IsNullOrEmpty(dealWorkflowStatus))
                                                {
                                                    string showAlert = ShowAlertOpen;
                                                    if (dealWorkflowStatus == GlobalParams.dealWorkFlowStatus_Approved)
                                                    {
                                                        TempData["ShowAlert"] = ShowAlertApp;
                                                        return RedirectToAction("Main", "Base");
                                                    }
                                                    else if (dealWorkflowStatus == GlobalParams.dealWorkFlowStatus_Declined)
                                                    {
                                                        TempData["ShowAlert"] = ShowAlertRej;
                                                        return RedirectToAction("Main", "Base");
                                                    }
                                                }
                                            }

                                            Dictionary<string, string> obj = objGC.PreReqForApproval(objLoginParam.DealCode, objLoginParam.ModuleCode, Record_Locking_Code, "Y", objLoginParam.Req);
                                            if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal || objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                                            {
                                                TempData["QueryString"] = obj;
                                                TempData["approval"] = "approvallist";

                                                if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                                                {
                                                    Session[RightsU_Session.SESS_DEAL] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                                                    return RedirectToAction("Index", "Acq_Deal");
                                                }
                                                else
                                                {
                                                    Session[RightsU_Session.SESS_DEAL] = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                                                    return RedirectToAction("Index", "Syn_Deal");
                                                }
                                            }
                                            else
                                            {
                                                TempData["Music_Deal_Code"] = objLoginParam.DealCode;

                                                if (allowViewOnly)
                                                    TempData["Mode"] = GlobalParams.DEAL_MODE_VIEW;
                                                else if (objLoginParam.Req == "SA")
                                                    TempData["Mode"] = GlobalParams.DEAL_MODE_APPROVE;

                                                TempData["RecodLockingCode"] = Record_Locking_Code;

                                                Session[RightsU_Session.SESS_DEAL] = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                                                return RedirectToAction("Index", "Music_Deal");
                                            }
                                        }
                                        else
                                        {
                                            ViewBag.AlertMsg = message;
                                            return View("Index");
                                        }
                                    }
                                    else
                                    {
                                        TempData["ShowAlert"] = ShowAlertAuth;
                                        return RedirectToAction("Main", "Base");
                                    }
                                }
                                else
                                {
                                    return RedirectToAction("Main", "Base");
                                }
                                #endregion-----
                                //return RedirectToAction("Main", "Base");
                            }
                        }
                        else
                        {
                            objUser.DefaultEntityName = Convert.ToString(lstUSP_Get_Login_Details.Where(x => x.Data_For == "DEN").Select(s => s.Parameter_Value).FirstOrDefault());
                            objUser.DefaultEntityLogoName = Convert.ToString(lstUSP_Get_Login_Details.Where(x => x.Data_For == "DEL").Select(s => s.Parameter_Value).FirstOrDefault());

                            RightsU_Session objUtoSession = new RightsU_Session();
                            objUtoSession.Objuser = objUser;
                            Session[RightsU_Session.SESS_KEY] = objUtoSession;
                            List<USP_GetMenu_Result> LoadMenuList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetMenu(objUser.Security_Group_Code.ToString(), "Y", objUser.Users_Code).ToList();
                            List<int> lstMenu = LoadMenuList.Select(x => x.Module_Code ?? 0).ToList();

                            if (lstMenu.Count > 0)
                            {
                                Session["Menu"] = lstMenu;
                                Session["Is_Approve"] = null;

                                if (lstMenu.Contains(GlobalParams.ModuleCodeForAcqDeal) || lstMenu.Contains(GlobalParams.ModuleCodeForSynDeal) || lstMenu.Contains(GlobalParams.ModuleCodeForMusicDeal))
                                {
                                    int ApproveDealCount = getApproveRight(objUser.Security_Group_Code ?? 0);
                                    if (ApproveDealCount > 0)
                                    {
                                        Session["Is_Approve"] = "Yes";
                                        Session["Menu"] = lstMenu;
                                    }
                                }
                            }
                            else
                                Session["Menu"] = null;

                            Boolean PasswordValidDay = Convert.ToBoolean(lstUSP_Get_Login_Details.Where(x => x.Data_For == "PVD").Select(s => s.Parameter_Value).FirstOrDefault());
                            if (PasswordValidDay || (objUser.Is_System_Password == "Y"))
                            {
                                isValidlogin = false;
                                Session["FileName"] = "";
                                Session["FileName"] = "ChangePassword";
                                return View("ChangePassword");
                            }
                            else
                            {
                                SaveLoginDetails(objUser.Users_Code, objUser.Security_Group_Code ?? 0, "Login");
                                #region-----Email Approval Redirect to Deal-----
                                if (objLoginParam.Action == "Y" && isValidlogin)
                                {
                                    string ShowAlertAuth = "You are not authorised user for this deal";
                                    int[] arrRights = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objUser.Security_Group_Code
                                    && i.System_Module_Right.Module_Code == objLoginParam.ModuleCode).Select(i => i.System_Module_Right.Right_Code).Distinct().ToArray();

                                    bool hasRight = false;
                                    bool allowViewOnly = false;
                                    if (objLoginParam.Req == "SA")
                                    {
                                        hasRight = arrRights.Contains(GlobalParams.RightCodeForApprove);
                                        if (!hasRight)
                                            allowViewOnly = hasRight = arrRights.Contains(GlobalParams.RightCodeForView);
                                    }
                                    else if (objLoginParam.Req == "A" || objLoginParam.Req == "R")
                                        allowViewOnly = hasRight = arrRights.Contains(GlobalParams.RightCodeForView);

                                    if (hasRight)
                                    {
                                        int dealBUCode = 0;
                                        if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                                            dealBUCode = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;
                                        else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                                            dealBUCode = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;
                                        else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForMusicDeal)
                                            dealBUCode = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;

                                        int[] arrBUCodes = new Users_Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Users_Code == objUser.Users_Code).Select(s => s.Business_Unit_Code ?? 0).ToArray();

                                        hasRight = arrBUCodes.Contains(dealBUCode);
                                    }

                                    if (hasRight)
                                    {
                                        int Record_Locking_Code = 0;
                                        string message = "";
                                        string ShowAlertApp = "Deal is Already Approved";
                                        string ShowAlertRej = "Deal is Already Rejected";
                                        string ShowAlertOpen = "Deal is Open";

                                        CommonUtil objCommonUtil = new CommonUtil();
                                        bool isLocked = objCommonUtil.Lock_Record(objLoginParam.DealCode, objLoginParam.ModuleCode, objUser.Users_Code, out Record_Locking_Code, out message, objLoginEntity.ConnectionStringName);
                                        if (isLocked)
                                        {
                                            GlobalController objGC = new GlobalController();
                                            if (objLoginParam.Req == "SA")
                                            {
                                                string dealWorkflowStatus = "";
                                                if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                                                    dealWorkflowStatus = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;
                                                else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                                                    dealWorkflowStatus = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;
                                                else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForMusicDeal)
                                                    dealWorkflowStatus = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;


                                                if (!string.IsNullOrEmpty(dealWorkflowStatus))
                                                {
                                                    string showAlert = ShowAlertOpen;
                                                    if (dealWorkflowStatus == GlobalParams.dealWorkFlowStatus_Approved)
                                                    {
                                                        TempData["ShowAlert"] = ShowAlertApp;
                                                        return RedirectToAction("Main", "Base");
                                                    }
                                                    else if (dealWorkflowStatus == GlobalParams.dealWorkFlowStatus_Declined)
                                                    {
                                                        TempData["ShowAlert"] = ShowAlertRej;
                                                        return RedirectToAction("Main", "Base");
                                                    }
                                                }
                                            }

                                            Dictionary<string, string> obj = objGC.PreReqForApproval(objLoginParam.DealCode, objLoginParam.ModuleCode, Record_Locking_Code, "Y", objLoginParam.Req);
                                            if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal || objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                                            {
                                                TempData["QueryString"] = obj;
                                                TempData["approval"] = "approvallist";

                                                if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                                                {
                                                    Session[RightsU_Session.SESS_DEAL] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                                                    return RedirectToAction("Index", "Acq_Deal");
                                                }
                                                else
                                                {
                                                    Session[RightsU_Session.SESS_DEAL] = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                                                    return RedirectToAction("Index", "Syn_Deal");
                                                }
                                            }
                                            else
                                            {
                                                TempData["Music_Deal_Code"] = objLoginParam.DealCode;

                                                if (allowViewOnly)
                                                    TempData["Mode"] = GlobalParams.DEAL_MODE_VIEW;
                                                else if (objLoginParam.Req == "SA")
                                                    TempData["Mode"] = GlobalParams.DEAL_MODE_APPROVE;

                                                TempData["RecodLockingCode"] = Record_Locking_Code;

                                                Session[RightsU_Session.SESS_DEAL] = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                                                return RedirectToAction("Index", "Music_Deal");
                                            }
                                        }
                                        else
                                        {
                                            ViewBag.AlertMsg = message;
                                            return View("Index");
                                        }
                                    }
                                    else
                                    {
                                        TempData["ShowAlert"] = ShowAlertAuth;
                                        return RedirectToAction("Main", "Base");
                                    }
                                }
                                else
                                {
                                    return RedirectToAction("Main", "Base");
                                }
                                #endregion-------
                            }
                        }
                    }
                    else
                    {
                        isValidlogin = false;
                        alertMsg = "Your account is locked. Contact administrator to regain access.";
                        return RedirectToAction("Index", "Login", new { alertMsg = alertMsg });
                    }
                }
                else
                {
                    alertMsg = "Your account is deactivated.";
                    return RedirectToAction("Index", "Login", new { alertMsg = alertMsg });
                }
            }
            else
            {
                isValidlogin = false;
                objUser = validateUser(Username.ToString().Trim());
                if (objUser != null)
                {
                    List<USP_Get_Login_Details_Result> lstUSP_Get_Login_Details = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Login_Details("MLA", objUser.Default_Entity_Code, objUser.Users_Code).ToList();
                    int MaxLoginAttempts = Convert.ToInt32(lstUSP_Get_Login_Details.Where(x => x.Data_For == "MLA").Select(s => s.Parameter_Value).FirstOrDefault());

                    if (IsLDAPAuthReq != "Y" || objUser.Password_Fail_Count < MaxLoginAttempts)
                    {
                        // If user has crossed limit of attempts so no need to update record (specially 'last_update_on' column), the user has been locked for particular amount of time 
                        objUser.Password_Fail_Count++;
                        objUser.Last_Updated_Time = DateTime.Now;
                        objUser.EntityState = State.Modified;
                        objUser_Service.Save(objUser);
                    }

                    if (objUser.Password_Fail_Count < MaxLoginAttempts)
                    {
                        alertMsg = " Invalid Password";
                        TempData["STRUSERNAME"] = Username;
                        TempData["Focus"] = "Password";
                        if (objUser.Password_Fail_Count == 2)
                        {
                            alertMsg = alertMsg + ", You have only three attempts remaining.";
                        }
                        else if (objUser.Password_Fail_Count == 3)
                        {
                            alertMsg = alertMsg + ", You have only two attempts remaining.";
                        }
                        else if (objUser.Password_Fail_Count == 4)
                        {
                            alertMsg = alertMsg + ", You have only one attempts remaining.";
                        }
                    }
                    else if (objUser.Password_Fail_Count >= MaxLoginAttempts)
                    {
                        alertMsg = alertMsg + " Your account is locked. Contact administrator to regain access.";
                    }
                }
                else
                {
                    alertMsg = alertMsg + "Invalid User Name.";
                    TempData["Focus"] = "UserName";
                }
            }
            ViewBag.AlertMsg = alertMsg;
            if (ConfigurationManager.AppSettings["isLDAPAuthReqd"].ToString().Trim().ToUpper() == "Y")
                ViewBag.ForgotPwdVisibility = false;
            else
                ViewBag.ForgotPwdVisibility = true;
            GetSystemVersion();
            #region----Email Approval Redirect to Deal-----
            if (objLoginParam.Action == "Y" && isValidlogin)
            {
                string ShowAlertAuth = "You are not authorised user for this deal";
                int[] arrRights = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objUser.Security_Group_Code
                && i.System_Module_Right.Module_Code == objLoginParam.ModuleCode).Select(i => i.System_Module_Right.Right_Code).Distinct().ToArray();

                bool hasRight = false;
                bool allowViewOnly = false;
                if (objLoginParam.Req == "SA")
                {
                    hasRight = arrRights.Contains(GlobalParams.RightCodeForApprove);
                    if (!hasRight)
                        allowViewOnly = hasRight = arrRights.Contains(GlobalParams.RightCodeForView);
                }
                else if (objLoginParam.Req == "A" || objLoginParam.Req == "R")
                    allowViewOnly = hasRight = arrRights.Contains(GlobalParams.RightCodeForView);

                if (hasRight)
                {
                    int dealBUCode = 0;
                    if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                        dealBUCode = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;
                    else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                        dealBUCode = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;
                    else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForMusicDeal)
                        dealBUCode = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Business_Unit_Code ?? 0;

                    int[] arrBUCodes = new Users_Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Users_Code == objUser.Users_Code).Select(s => s.Business_Unit_Code ?? 0).ToArray();

                    hasRight = arrBUCodes.Contains(dealBUCode);
                }

                if (hasRight)
                {
                    int Record_Locking_Code = 0;
                    string message = "";
                    string ShowAlertApp = "Deal is Already Approved";
                    string ShowAlertRej = "Deal is Already Rejected";
                    string ShowAlertOpen = "Deal is Open";

                    CommonUtil objCommonUtil = new CommonUtil();
                    bool isLocked = objCommonUtil.Lock_Record(objLoginParam.DealCode, objLoginParam.ModuleCode, objUser.Users_Code, out Record_Locking_Code, out message, objLoginEntity.ConnectionStringName);
                    if (isLocked)
                    {
                        GlobalController objGC = new GlobalController();
                        if (objLoginParam.Req == "SA")
                        {
                            string dealWorkflowStatus = "";
                            if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                                dealWorkflowStatus = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;
                            else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                                dealWorkflowStatus = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;
                            else if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForMusicDeal)
                                dealWorkflowStatus = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode).Deal_Workflow_Status;


                            if (!string.IsNullOrEmpty(dealWorkflowStatus))
                            {
                                string showAlert = ShowAlertOpen;
                                if (dealWorkflowStatus == GlobalParams.dealWorkFlowStatus_Approved)
                                {
                                    TempData["ShowAlert"] = ShowAlertApp;
                                    return RedirectToAction("Main", "Base");
                                }
                                else if (dealWorkflowStatus == GlobalParams.dealWorkFlowStatus_Declined)
                                {
                                    TempData["ShowAlert"] = ShowAlertRej;
                                    return RedirectToAction("Main", "Base");
                                }
                            }
                        }

                        Dictionary<string, string> obj = objGC.PreReqForApproval(objLoginParam.DealCode, objLoginParam.ModuleCode, Record_Locking_Code, "Y", objLoginParam.Req);
                        if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal || objLoginParam.ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                        {
                            TempData["QueryString"] = obj;
                            TempData["approval"] = "approvallist";

                            if (objLoginParam.ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                            {
                                Session[RightsU_Session.SESS_DEAL] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                                return RedirectToAction("Index", "Acq_Deal");
                            }
                            else
                            {
                                Session[RightsU_Session.SESS_DEAL] = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                                return RedirectToAction("Index", "Syn_Deal");
                            }
                        }
                        else
                        {
                            TempData["Music_Deal_Code"] = objLoginParam.DealCode;

                            if (allowViewOnly)
                                TempData["Mode"] = GlobalParams.DEAL_MODE_VIEW;
                            else if (objLoginParam.Req == "SA")
                                TempData["Mode"] = GlobalParams.DEAL_MODE_APPROVE;

                            TempData["RecodLockingCode"] = Record_Locking_Code;

                            Session[RightsU_Session.SESS_DEAL] = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objLoginParam.DealCode);
                            return RedirectToAction("Index", "Music_Deal");
                        }
                    }
                    else
                    {
                        ViewBag.AlertMsg = message;
                        return View("Index");
                    }
                }
                else
                {
                    TempData["ShowAlert"] = ShowAlertAuth;
                    return RedirectToAction("Main", "Base");
                }
            }
            #endregion------
            else
            {
                return View("Index");
            }
        }


        public bool LDAPAuthentication(string domain, string username, string password, string ldapPath, out string ErrMsg)
        {
            ErrMsg = "";
            string domainAndUsername = domain + @"\" + username;
            LogErr("LDAP Login", "LDAP Validation", "domainAndUsername:" + domainAndUsername, Server.MapPath("~"));
            LogErr("LDAP Login", "LDAP Validation", "password:" + password, Server.MapPath("~"));
            LogErr("LDAP Login", "LDAP Validation", "Directory Entry Code Started", Server.MapPath("~"));
            DirectoryEntry entry = new DirectoryEntry(ldapPath, domainAndUsername, password);
            LogErr("LDAP Login", "LDAP Validation", "Directory Entry object created", Server.MapPath("~"));
            try
            {
                // Bind to the native AdsObject to force authentication.
                Object obj = entry.NativeObject;
                LogErr("LDAP Login", "LDAP LDAPAuthentication", "Native object created", Server.MapPath("~"));
                DirectorySearcher search = new DirectorySearcher(entry);
                LogErr("LDAP Login", "LDAP Validation", "Directory Search object created", Server.MapPath("~"));
                search.Filter = "(SAMAccountName=" + username + ")";
                LogErr("LDAP Login", "LDAP LDAPAuthentication", "Filter Applied", Server.MapPath("~"));
                search.PropertiesToLoad.Add("cn");
                LogErr("LDAP Login", "LDAP LDAPAuthentication", "Properties Loaded", Server.MapPath("~"));
                SearchResult result = search.FindOne();
                LogErr("LDAP Login", "LDAP LDAPAuthentication", "Result : " + Convert.ToString(result), Server.MapPath("~"));
                if (null == result)
                {
                    return false;
                }
                // Update the new path to the user in the directory
                ldapPath = result.Path;
                string _filterAttribute = (String)result.Properties["cn"][0];
            }
            catch (Exception ex)
            {
                ErrMsg = ex.Message;
                // MessageShow.CreateMessageAlert(this, ErrMsg, "alertKey");
                return false;
                //   throw new Exception("Error authenticating user." + ex.Message);
            }
            return true;
        }

        public string LDAPValidation(User objUser, string Username = "", string Password = "")
        {
            string dominName = string.Empty;
            string adPath = string.Empty;
            string userName = Username.Trim().ToUpper();
            string strError = string.Empty;
            string message = "";
            HttpApplicationState Application = HttpContext.ApplicationInstance.Application;
            try
            {
                dominName = Convert.ToString(ConfigurationManager.AppSettings["LDAP_adDomain"]);  //key.Contains("DirectoryDomain") ? ConfigurationSettings.AppSettings[key] : dominName;
                adPath = Convert.ToString(ConfigurationManager.AppSettings["LDAP_adLdapPath"]);   //key.Contains("DirectoryPath") ? ConfigurationSettings.AppSettings[key] : adPath;
                if (!String.IsNullOrEmpty(dominName) && !String.IsNullOrEmpty(adPath))
                {
                    LogErr("LDAP Login", "LDAP Validation", "dominName:" + dominName, Server.MapPath("~"));
                    LogErr("LDAP Login", "LDAP Validation", "userName:" + userName, Server.MapPath("~"));
                    LogErr("LDAP Login", "LDAP Validation", "pwd:" + Password, Server.MapPath("~"));
                    LogErr("LDAP Login", "LDAP Validation", "DirPath:" + adPath, Server.MapPath("~"));
                    RightsU_Session objUtoSession = new RightsU_Session();
                    objUtoSession.Objuser = objUser;
                    Session[UtoSession.SESS_KEY] = objUtoSession;

                    if (true == LDAPAuthentication(dominName, userName, Password, adPath, out strError))
                    {
                        SaveLoginDetails(objUser.Users_Code, Convert.ToInt32(objUser.Security_Group_Code), "Login");

                        dominName = string.Empty;
                        adPath = string.Empty;

                        return "LDAPAUTH";
                        //RedirectToAction("Main", "Base");
                        //Response.Redirect("Home.aspx", false);
                    }
                    dominName = string.Empty;
                    adPath = string.Empty;
                    //if (String.IsNullOrEmpty(strError)) 
                }
                if (!string.IsNullOrEmpty(strError))
                {
                    if (Application["LOGGEDUSERS"] != null && Session[UtoSession.SESS_KEY] != null)
                        ClearDataFromApp();
                    Session.Abandon();
                    //Username.Focus();
                    LogErr("LDAP Login", "LDAP Validation-1", strError, Server.MapPath("~"));
                    // MessageShow.CreateMessageAlert(this, strError.Replace('\r', ' ').Replace('\n', ' '), "alertKey");
                    message = strError.Replace('\r', ' ').Replace('\n', ' ');
                }
            }
            catch (Exception e)
            {
                if (Application["LOGGEDUSERS"] != null && Session[UtoSession.SESS_KEY] != null)
                    ClearDataFromApp();
                Session.Abandon();
                //MessageShow.CreateMessageAlert(this, strError.Replace('\r', ' ').Replace('\n', ' '), "alertKey");
                message = strError.Replace('\r', ' ').Replace('\n', ' ');
            }
            finally
            {
            }
            return message;
        }
        public static void LogErr(string moduleName, string methodName, string msg, string path)
        {
            StreamWriter sw;
            //if (!File.Exists(System.Windows.Forms.Application.StartupPath + "\\LogErr.txt"))
            if (!System.IO.File.Exists(path + "\\LogErr.txt"))
            {
                sw = System.IO.File.CreateText(path + "\\LogErr.txt");
                //sw.WriteLine(DateTime.Now.ToString("dd-MMM-yyyy"));
                sw.Close();
            }

            sw = System.IO.File.AppendText(path + "\\LogErr.txt");
            sw.WriteLine("");
            sw.WriteLine("-------------------------------------------------");
            sw.WriteLine(DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + "    LDAP ");
            sw.Close();

            sw = System.IO.File.AppendText(path + "\\LogErr.txt");
            sw.WriteLine(moduleName + "    " + methodName);
            sw.WriteLine(msg);
            sw.Close();
            //System.Windows.Forms.MessageBox.Show("Error found:" + msg);
        }

        public ActionResult ForgetPassword(string txtLoginID = "", string hdnEntity = "")
        {

            Session["Entity_Type"] = hdnEntity;
            objUser_Service = null;
            objLDS_Service = null;
            objUPD_Service = null;
            User objUser = null;
            objUser = validateUser(txtLoginID.Trim());
            string alertMsg = "";

            HttpCookie myCookie = null;
            myCookie = new HttpCookie("Entity_Type");
            Response.Cookies.Add(myCookie);
            myCookie.Value = hdnEntity;
            myCookie.Expires = DateTime.MaxValue;

            if (objUser != null)
            {

                string newPassword = getEncrptedPass(objUser.First_Name, objUser.Last_Name).Trim();

                objUser.Password = newPassword;
                objUser.Is_System_Password = "Y";

                string status = Convert.ToString(objUser.Is_Active);

                if (status == "N")
                {
                    alertMsg = alertMsg + "User Account Is Deactivated.";
                    return RedirectToAction("Index", "Login", new { alertMsg = alertMsg });
                }
                else
                {
                    objUser.Password = getEncriptedStr(objUser.Password);
                    objUser.Password_Fail_Count = 0;
                    objUser.Last_Updated_Time = DateTime.Now;
                    objUser.EntityState = State.Modified;
                    objUser_Service.Save(objUser);
                }

                try
                {
                    int IsMailSend = sendNewPasswordMail(objUser, newPassword);
                    alertMsg = alertMsg + "Password has been emailed to you.";
                    return RedirectToAction("Index", "Login", new { alertMsg = alertMsg });
                }
                catch (Exception ex)
                {
                    alertMsg = alertMsg + "Email sending failed, Your new password is '" + newPassword + "'";
                    return RedirectToAction("Index", "Login", new { alertMsg = alertMsg });
                }
            }
            else
            {
                alertMsg = alertMsg + "Invalid User Name.";
                return RedirectToAction("Index", "Login", new { alertMsg = alertMsg });
            }

        }

        public ActionResult ChangePasswordCancel(string FromPage = "")
        {
            GetSystemVersion();
            if (FromPage == "Login")
            {
                User objUsers = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;
                ReleaseUser(objUsers.Login_Name);
                Session.Abandon();
                ViewBag.AlertMsg = "";
                return RedirectToAction("Index", "Login");
            }
            return RedirectToAction("Main", "Base");
        }

        public ActionResult ChangePassword(string OldPassword = "", string NewPassword = "", string ConfirmPassword = "", string FromPage = "")
        {
            string AlertMessage = "";

            TempData["FromPage"] = FromPage;

            User objUser = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;

            if (objUser.Password != getEncriptedStr(OldPassword.Trim()))
            {
                AlertMessage = "Incorrect old password";
                TempData["Focus"] = "OldPassword";
                ViewBag.AlertMsg = AlertMessage;
                Session["FileName"] = "";
                Session["FileName"] = "ChangePassword";
                return View("ChangePassword");
            }

            //Password should not same as old password
            else if (objUser.Password == getEncriptedStr(NewPassword.Trim()))
            {
                AlertMessage = "Please change your password, it should not be same as old Password";
                TempData["Focus"] = "OldPassword";
                ViewBag.AlertMsg = AlertMessage;
                Session["FileName"] = "";
                Session["FileName"] = "ChangePassword";
                return View("ChangePassword");
            }

            // password should not contain login/first/last name        
            else if (NewPassword.Trim().ToLower().Contains(objUser.Login_Name.ToLower())
                 || NewPassword.Trim().ToLower().Contains(objUser.First_Name.ToLower())
                 || (objUser.Last_Name != "" && NewPassword.ToLower().Trim().Contains(objUser.Last_Name.ToLower())))
            {
                AlertMessage = "Please change your password, it should not be same as old Password";
                TempData["Focus"] = "OldPassword";
                ViewBag.AlertMsg = AlertMessage;
                return View("ChangePassword");
            }
            else
            {
                //    objUser_Service = null;

                int Lst5PwdsCnt = CheckLast5Pwds(objUser.Users_Code, NewPassword.Trim());
                if (Lst5PwdsCnt > 0)
                {
                    AlertMessage = "Please enter some other password, it matches your old password history";
                    TempData["Focus"] = "OldPassword";
                    ViewBag.AlertMsg = AlertMessage;
                    Session["FileName"] = "";
                    Session["FileName"] = "ChangePassword";
                    return View("ChangePassword");
                }
                else
                {
                    objUser.Password = getEncriptedStr(NewPassword.Trim());
                    objUser.Is_System_Password = "N";
                    objUser.Password_Fail_Count = 0;
                    objUser.Last_Updated_Time = DateTime.Now;

                    objUser.EntityState = State.Modified;
                    objUser_Service.Save(objUser);
                    Users_Password_Detail ObjUPD = new Users_Password_Detail();
                    ObjUPD.Users_Code = objUser.Users_Code;
                    ObjUPD.Users_Passwords = getEncriptedStr(NewPassword.Trim());
                    ObjUPD.Password_Change_Date = DateTime.Now;

                    ObjUPD.EntityState = State.Added;
                    dynamic resultSet;
                    bool isValid = objUPD_Service.Save(ObjUPD, out resultSet);

                    ReleaseUser(objUser.Login_Name);
                    Session.Abandon();
                    return RedirectToAction("Index", "Login");
                }
            }
        }

        public ActionResult ChangePasswordIndex()
        {
            GetSystemVersion();
            User objUser = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;
            TempData["FromPage"] = "Base";
            if (objUser != null)
            {
                Session["FileName"] = "";
                Session["FileName"] = "ChangePassword";
                return View("ChangePassword");
            }
            else
                return RedirectToAction("Index", "Login");
        }

        #region --- --- Methods --- ---

        private void setDefaultProperty(HttpResponse resp, HttpRequest req)
        {
            DateTime d = DateTime.Now;
            resp.Expires = 0;
            resp.ExpiresAbsolute = d.AddDays(-1);
            resp.AddHeader("pragma", "no-cache");
            resp.CacheControl = "no-cache";
            resp.BufferOutput = true;

            resp.Cache.SetExpires(System.DateTime.Now);
            resp.Cache.SetCacheability(HttpCacheability.NoCache);
            resp.Cache.SetMaxAge(new TimeSpan(0, 0, 0));
        }
        private string[] getTimeAndSessionId(string timeSessionId)
        {
            string[] timeSession = new string[2];
            timeSession = timeSessionId.Split('#');
            return timeSession;
        }
        private string getDateComparisionNumber(string strDate)
        {
            string actualStr = strDate.Trim().Replace("T", "~").Replace(":", "~").Replace("-", "~");
            string[] arrDt = actualStr.Split('~');
            string tmpTimeInSec = arrDt[0].Trim() + arrDt[1].Trim() + arrDt[2].Trim()
                + Convert.ToString(Convert.ToInt64(Convert.ToInt64(arrDt[3].Trim()) * 60 * 60)
                + Convert.ToInt64(Convert.ToInt64(arrDt[4].Trim()) * 60)
                + Convert.ToInt64(arrDt[5].Trim()));
            return tmpTimeInSec;
        }
        private void removeFromAppl()
        {
            Hashtable htLoggedUser = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
            HttpApplicationState Application = HttpContext.ApplicationInstance.Application;
            htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];
            User objUser = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;

            if (htLoggedUser.ContainsKey(objUser.Login_Name + "#" + Convert.ToString(Session["Entity_Type"])))
            {
                htLoggedUser.Remove(objUser.Login_Name + "#" + Convert.ToString(Session["Entity_Type"]));
                Application.Lock();
                Application["LOGGEDUSERS"] = htLoggedUser;
                Application.UnLock();
            }

            Session.Abandon();
        }

        #endregion

        #region ------- New Methods ---------

        private bool isAdAuthenticated(string username, string pwd)
        {
            string ldap = ConfigurationManager.AppSettings["LDAP_adLdapPath"].ToString().Trim();
            string domainAndUsername = ConfigurationManager.AppSettings["LDAP_adDomain"].ToString().Trim() + @"\" + username;

            DirectoryEntry entry = new DirectoryEntry(ldap, domainAndUsername, pwd);
            try
            {
                // Bind to the native AdsObject to force authentication.
                Object obj = entry.NativeObject;
                DirectorySearcher search = new DirectorySearcher(entry);
                search.Filter = "(SAMAccountName=" + username + ")";
                search.PropertiesToLoad.Add("cn");
                SearchResult result = search.FindOne();
                if (null == result)
                {
                    return false;
                }
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        private User validateUser(string strUserName)
        {

            User objUser = objUser_Service.SearchFor(x => x.Login_Name.ToUpper() == strUserName.ToUpper()).FirstOrDefault();
            if (objUser != null)
            {
                return objUser;
            }
            else
            {
                return null;
            }
        }

        private object validateUser(string strUserName, string strPassword)
        {
            //CommonUtil.WriteErrorLog("Before Encription", logFileName);
            string EncryptedPassword = getEncriptedStr(strPassword.Trim());
            //CommonUtil.WriteErrorLog("After Encription, Before Calling Service", logFileName);

            User objUser = objUser_Service.SearchFor(x => x.Login_Name.ToUpper() == strUserName.Trim().ToUpper() && x.Password == EncryptedPassword).FirstOrDefault();
            //CommonUtil.WriteErrorLog("After Calling Service", logFileName);
            return objUser;

        }

        private string getEncriptedStr(string normalStr)
        {
            //MD5CryptoServiceProvider objMD5Hasher = new MD5CryptoServiceProvider();
            //byte[] hashedDataBytes;
            //UTF8Encoding objEncoder = new UTF8Encoding();
            //StringBuilder encriptedStr = new StringBuilder();

            //hashedDataBytes = objMD5Hasher.ComputeHash(objEncoder.GetBytes(normalStr));

            //for (int i = 0; i < hashedDataBytes.Length - 1; i++)
            //{
            //    encriptedStr.Append(hashedDataBytes[i].ToString());
            //}
            //return encriptedStr.ToString().Remove(30);

            string EncryptionKey = "";
            byte[] clearBytes = Encoding.Unicode.GetBytes(normalStr);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    normalStr = Convert.ToBase64String(ms.ToArray());
                }
            }
            return normalStr;

        }

        private string getEncrptedPass(string FirstName, string LastName)
        {
            long currentTime = Convert.ToInt64(GetDateComparisionNumber(DateTime.Now.ToString("s")));
            string date = currentTime.ToString().Substring(8, 4);

            if (Convert.ToInt32(date) % 2 == 0)
            {
                date = ((date[0]) + date);
                date += date[2];
            }
            else
            {
                date = ((date[1]) + date);
                date += date[3];
            }

            if (FirstName.Length < 2)
                FirstName = FirstName + '#';
            if (LastName.Length < 2)
                LastName = LastName + '#';
            string str = FirstName.Substring(0, 2).Trim() + date + LastName.Substring(0, 2).Trim();

            return str;
        }

        private string GetDateComparisionNumber(string strDate)
        {
            string actualStr = strDate.Trim().Replace("T", "~").Replace(":", "~").Replace("-", "~");
            string[] arrDt = actualStr.Split('~');
            string tmpTimeInSec = arrDt[0].Trim() + arrDt[1].Trim() + arrDt[2].Trim() + Convert.ToString(Convert.ToInt64(Convert.ToInt64(arrDt[3].Trim()) * 60 * 60) + Convert.ToInt64(Convert.ToInt64(arrDt[4].Trim()) * 60) + Convert.ToInt64(arrDt[5].Trim()));
            return tmpTimeInSec;
        }

        private int getApproveRight(int SCode)
        {
            List<int> lst_Module_Code = new List<int>();
            lst_Module_Code.Add(GlobalParams.ModuleCodeForAcqDeal);
            lst_Module_Code.Add(GlobalParams.ModuleCodeForSynDeal);
            lst_Module_Code.Add(GlobalParams.ModuleCodeForMusicDeal);

            int rCode = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == SCode
                            && i.System_Module_Rights_Code == i.System_Module_Right.Module_Right_Code
                            && lst_Module_Code.Contains(i.System_Module_Right.Module_Code)
                            && i.System_Module_Right.Right_Code == GlobalParams.RightCodeForApprove)
                .Select(i => i.System_Module_Right.Right_Code).Distinct().Count();

            return rCode;
        }

        public int GetPassLifeTime(int code)
        {
            DateTime Password_Change_Date = DateTime.MinValue;
            int DaysCount = 0;
            Users_Password_Detail ObjUsers_Password_Detail = objUPD_Service.SearchFor(x => x.Users_Code == code).OrderByDescending(x => x.Password_Change_Date).FirstOrDefault();

            if (ObjUsers_Password_Detail != null)
            {
                Password_Change_Date = ObjUsers_Password_Detail.Password_Change_Date ?? DateTime.MinValue;
                DaysCount = Convert.ToInt32(DateTime.Now.Subtract(Password_Change_Date).TotalDays);
            }
            return DaysCount;
        }

        private int CheckLast5Pwds(int UserCode = 0, string NewPassWord = "")
        {
            string EncryptedPassword = getEncriptedStr(NewPassWord);
            List<Users_Password_Detail> Last5PwdsList = objUPD_Service.SearchFor(x => x.Users_Code == UserCode).OrderByDescending(x => x.Password_Change_Date).Take(5).ToList();
            int Lst5PwdsCnt = 0;

            if (Last5PwdsList.Count() > 0)
            {
                Lst5PwdsCnt = Last5PwdsList.Where(x => x.Users_Passwords == EncryptedPassword).Count();
            }

            return Lst5PwdsCnt;
        }

        private void SaveLoginDetails(int UserCode, int SecurityGroupCode, string LogInOrLogOut)
        {
            try
            {
                dynamic resultSet;

                if (LogInOrLogOut == "Login")
                {
                    Login_Details objLD = new Login_Details();
                    objLD.Users_Code = UserCode;
                    objLD.Security_Group_Code = SecurityGroupCode;
                    objLD.Login_Time = DateTime.Now;
                    objLD.Logout_Time = null;
                    objLD.Description = "LogIn";
                    objLD.EntityState = State.Added;
                    bool isValid = objLDS_Service.Save(objLD, out resultSet);
                    Login_Details_Code = objLD.Login_Details_Code;
                }
                else//LogOut
                {
                    if (Login_Details_Code > 0)
                    {
                        Login_Details objLD = objLDS_Service.GetById(Login_Details_Code);
                        objLD.Logout_Time = DateTime.Now;
                        objLD.Description = "LogOut";
                        objLD.EntityState = State.Modified;
                        objLDS_Service.Update(objLD, out resultSet);
                    }
                }
            }
            catch
            { }
        }

        private int sendNewPasswordMail(User objUser, string NewPassword)
        {
            int IsMailSend = new USP_Service(objLoginEntity.ConnectionStringName).usp_GetUserEMail_Body(objUser.Login_Name, objUser.First_Name, objUser.Last_Name, NewPassword, ConfigurationManager.AppSettings["isLDAPAuthReqd"].ToString().ToUpper(), ConfigurationManager.AppSettings["SiteAddress"].ToString(), ConfigurationManager.AppSettings["SystemName"].ToString(), "FP", objUser.Email_Id.Trim());
            return IsMailSend;
        }

        private void ReleaseUser(string loginName)
        {
            HttpApplicationState Application = HttpContext.ApplicationInstance.Application;
            Hashtable htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];

            if (htLoggedUser.ContainsKey(loginName + "#" + Convert.ToString(Session["Entity_Type"])))
            {
                htLoggedUser.Remove(loginName + "#" + Convert.ToString(Session["Entity_Type"]));
                Application.Lock();
                Application["LOGGEDUSERS"] = htLoggedUser;
                Application.UnLock();
            }

        }
        #endregion

        public void GetSystemVersion()
        {
            System_Versions objSysVersion = new System_Versions();
            objSysVersion = new System_Versions_Service(objLoginEntity.ConnectionStringName).SearchFor(p => true).OrderByDescending(x => x.Version_Code).FirstOrDefault();
            Session["VersionDetails"] = objSysVersion;
        }

    }

    public class LoginParameters : Controller
    {
        public int DealCode { get; set; }
        public int ModuleCode { get; set; }
        public string Action { get; set; }
        public string Req { get; set; }

        public LoginParameters()
        {
            DealCode = 0;
            ModuleCode = 0;
            Action = "";
            Req = "";
        }
    }
}
