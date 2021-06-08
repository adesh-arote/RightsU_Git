using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
//using RightsU_Entities;
//using RightsU_BLL;
using System.Data.Entity.Core.Objects;
using System.Configuration;
using System.Collections;
using System.Globalization;
using UTOFrameWork.FrameworkClasses;
namespace RightsU_Plus.Controllers
{
    public class Email_ConfigController : BaseController
    {
        private readonly USP_Service objProcedureService = new USP_Service();
        private readonly Security_Group_Service objSecurity_GroupService = new Security_Group_Service();
        private readonly Email_Config_Service objEmail_ConfigService = new Email_Config_Service();
        private readonly Business_Unit_Service objBusiness_UnitService = new Business_Unit_Service();
        private readonly Channel_Service objChannelService = new Channel_Service();
        private readonly User_Service objUserService = new User_Service();
        private readonly Email_Config_Detail_Service objEmail_Config_DetailService = new Email_Config_Detail_Service();
        private readonly Users_Business_Unit_Service objUsers_Business_UnitService = new Users_Business_Unit_Service();

        public JsonResult CheckRecordLock(int Email_Config_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Email_Config_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Email_Config_Code, GlobalParams.ModuleCodeForEmailConfig, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        private Email_Config_Detail objECD
        {
            get
            {
                if (Session["objECD"] == null)
                    Session["objECD"] = new Email_Config_Detail();
                return (Email_Config_Detail)Session["objECD"];
            }
            set
            {
                Session["objECD"] = value;
            }
        }
        private Email_Config_Detail_Service objECDService
        {
            get
            {
                if (Session["objECDService"] == null)
                    Session["objECDService"] = new Email_Config_Detail_Service();
                return (Email_Config_Detail_Service)Session["objECDService"];
            }
            set
            {
                Session["objECDService"] = value;
            }
        }
        public List<SelectListItem> selectedCcBcclist
        {
            get
            {
                if (Session["selectedCcBcclist"] == null)
                    Session["selectedCcBcclist"] = new List<SelectListItem>();
                return (List<SelectListItem>)Session["selectedCcBcclist"];
            }
            set
            {
                Session["selectedCcBcclist"] = value;
            }
        }
        public string selectedCcSession
        {
            get
            {
                if (Session["selectedCcSession"] == null)
                    Session["selectedCcSession"] = "";
                return (string)Session["selectedCcSession"];
            }
            set
            {
                Session["selectedCcSession"] = value;
            }
        }
        public string selectedBccSession
        {
            get
            {
                if (Session["selectedBccSession"] == null)
                    Session["selectedBccSession"] = "";
                return (string)Session["selectedBccSession"];
            }
            set
            {
                Session["selectedBccSession"] = value;
            }
        }
        Type[] RelationList = new Type[] { typeof(Email_Config_Detail), typeof(Email_Config_Detail_User) };
        public ActionResult Index()
        {
            objECD = null;
            objECDService = null;
            return View();
        }
        public PartialViewResult BindGrid()
        {
            ViewBag.Show_Hide_Buttons = GetUserModuleRights();//objProcedureService.USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForEmailConfig, objLoginUser.Security_Group_Code, objLoginUser.Users_Code).FirstOrDefault();
            List<Email_Config> lstEC = objEmail_ConfigService.GetList(RelationList).ToList();

            lstEC.ForEach(f =>
            {
                f.User_Count = (f.Email_Config_Detail.FirstOrDefault() ?? new Email_Config_Detail()).Email_Config_Detail_User.Select(s => new
                { Count = s.User_Type == "U" ? s.User_Codes.Trim().Trim(',').Trim().Split(',').Count() : 1 }).Sum(s => s.Count).ToString();
            });

            return PartialView("~/Views/Email_Config/_Email_Config_List.cshtml", lstEC);
        }
        private string GetUserModuleRights()
        {
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTerritoryGroup), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public PartialViewResult AddEditConfigure(int EmailConfigCode)
        {
            objECDService = null;
            ViewBag.Show_Hide_Buttons = GetUserModuleRights();//objProcedureService.USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForEmailConfig, objLoginUser.Security_Group_Code, objLoginUser.Users_Code).FirstOrDefault();
            objECD = objECDService.GetList().Where(x => x.Email_Config_Code == EmailConfigCode).FirstOrDefault();
            if (objECD.Email_Config_Code == 0 || objECD.Email_Config_Detail_Code == 0)
            {
                Email_Config objEC = objEmail_ConfigService.GetEmail_ConfigByID(EmailConfigCode);
                objECD.Email_Config = objEC;
                objECD.Email_Config_Code = EmailConfigCode;
            }
            string Notification_Frequency = "N";
            int Notification_Days = 0;
            if (objECD != null)
            {
                Notification_Frequency = objECD.Notification_Frequency;
                Notification_Days = Convert.ToInt32(objECD.Notification_Days == null ? 0 : objECD.Notification_Days);
                objECD.Email_Config_Detail_User.ToList().ForEach(f => { FillCommaSeparateName(f); });
            }
            ViewBag.ddlEmailFreq = GetEmail_Freq_List(Notification_Frequency);
            ViewBag.ddlEmailFreqDays = GetEmail_Freq_Days_List(Notification_Days);

            if (!string.IsNullOrEmpty(objECD.Email_Config.Days_Freq) || objECD.Email_Config.Days_Freq != "N")
            {
                List<string> lstDaysFreq = objECD.Email_Config.Days_Freq.Trim().Trim(',').Trim().Split(',').Where(x => x != "").Select(x => x).ToList();
                ViewBag.Days_Freq = lstDaysFreq.Select(s => s.Contains("<") ? s.Replace("<", "From Today to ") + " Days" : (s.Contains(">") ? s.Replace(">", ">=") + " Days" : "On " + s + "th Day"));
            }
            else
                ViewBag.Days_Freq = null;

            return PartialView("~/Views/Email_Config/_Email_Config_Detail.cshtml", objECD.Email_Config);
        }
        public PartialViewResult BindUserGrid(string CommandName, string DummyGuid)
        {
            ViewBag.Show_Hide_Buttons = GetUserModuleRights();//objProcedureService.USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForEmailConfig, objLoginUser.Security_Group_Code, objLoginUser.Users_Code).FirstOrDefault();
            if (CommandName == "EDIT")
            {
                ViewBag.CodeForEdit = DummyGuid;
                Email_Config_Detail_User objECUD = objECD.Email_Config_Detail_User.Where(x => x.Dummy_Guid == DummyGuid).FirstOrDefault();
                if (objECUD == null)
                    objECUD = new Email_Config_Detail_User();
                ViewBag.lstBU = new MultiSelectList(objBusiness_UnitService.GetAll().Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name", objECUD.Business_Unit_Codes.Split(',')).OrderBy(x => x.Text).ToList();
                if (objECD.Email_Config.IsChannel == "Y")
                    ViewBag.lstChannel = new MultiSelectList(objChannelService.GetList().Where(x => x.Is_Active == "Y"), "Channel_Code", "Channel_Name", objECUD.Channel_Codes.Split(',')).OrderBy(x => x.Text).ToList();
            }
            if (CommandName == "ADD")
            {
                if (objECD.Email_Config.IsBusinessUnit == "Y")
                    ViewBag.lstBU = new MultiSelectList(objBusiness_UnitService.GetAll().Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name").OrderBy(x => x.Text).ToList();
                if (objECD.Email_Config.IsChannel == "Y")
                    ViewBag.lstChannel = new MultiSelectList(objChannelService.GetList().Where(x => x.Is_Active == "Y"), "Channel_Code", "Channel_Name").OrderBy(x => x.Text).ToList();
                if (objECD.Email_Config.IsBusinessUnit == "N")
                    ViewBag.lstUsers = new MultiSelectList(objUserService.GetAll().Where(x => x.Is_Active == "Y"), "Users_Code", "First_Name").OrderBy(x => x.Text).ToList();
            }
            ViewBag.IsChannel = objECD.Email_Config.IsChannel;
            ViewBag.IsBusinessUnit = objECD.Email_Config.IsBusinessUnit;
            ViewBag.CommandName = CommandName;
            ViewBag.DummyGuid = DummyGuid;
            selectedCcSession = null;
            selectedBccSession = null;
            List<Email_Config_Detail_User> list = objECD.Email_Config_Detail_User.Reverse().ToList();
            return PartialView("~/Views/Email_Config/_Email_Config_User.cshtml", list);
        }
        public PartialViewResult ShowUserPopup(int Email_Config_Code)
        {
            objECD = objEmail_Config_DetailService.GetList().Where(x => x.Email_Config_Code == Email_Config_Code).FirstOrDefault();
            List<Email_Config_Detail_User> list = objECD.Email_Config_Detail_User.Reverse().ToList();
            list.ForEach(f => { FillCommaSeparateName(f); });
            ViewBag.IsChannel = objECD.Email_Config.IsChannel;
            ViewBag.IsBusinessUnit = objECD.Email_Config.IsBusinessUnit;
            ViewBag.CommandName = "VIEW";
            return PartialView("~/Views/Email_Config/_Email_Config_User.cshtml", list);
        }

        public JsonResult PopulateUsers(string[] BUCodes, string DummyGuid, string[] CcCodes, string[] BccCodes, string Type = "G")
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            dynamic lst, lstG;
            string selectedUsers = objECD.Email_Config_Detail_User.Where(e => e.Dummy_Guid == DummyGuid).Select(e => e.User_Codes).FirstOrDefault();
            if (selectedUsers == null)
                selectedUsers = "";
            string selectedCcCode = objECD.Email_Config_Detail_User.Where(e => e.Dummy_Guid == DummyGuid).Select(e => e.CC_Users).FirstOrDefault();
            string selectedBccCode = objECD.Email_Config_Detail_User.Where(e => e.Dummy_Guid == DummyGuid).Select(e => e.BCC_Users).FirstOrDefault();

            if (DummyGuid == null)
            {
                if (CcCodes != null)
                {
                    selectedCcCode = string.Join(", ", CcCodes);
                }
                if (BccCodes != null)
                {
                    selectedBccCode = string.Join(", ", BccCodes);
                }
            }
            if (!string.IsNullOrWhiteSpace(selectedCcCode))
            {
                obj.Add("selectedCc", selectedCcCode.Split(','));
            }
            else
            {
                obj.Add("selectedCc", selectedCcSession.Split(','));
            }
            if (!string.IsNullOrWhiteSpace(selectedBccCode))
            {
                obj.Add("selectedBcc", selectedBccCode.Split(','));
            }
            else
            {
                obj.Add("selectedBcc", selectedBccSession.Split(','));
            }
            if (BUCodes != null)
            {
                List<User> lstU = new List<User>();
                var newList = objUsers_Business_UnitService.GetAll().Where(u => BUCodes.Contains(u.Business_Unit_Code.ToString())).
                    GroupBy(s => new { s.Users_Code }).Where(s => s.Count() == BUCodes.Count() && s.Key != null)
                    .Select(s => s.Key).ToArray();
                foreach (var a in newList)
                {
                    if (a.Users_Code != null)
                    {
                        string c = a.Users_Code.ToString();
                        int b = Convert.ToInt32(a.Users_Code);
                        User objUser = objUserService.GetAll().Where(u => u.Users_Code == b && u.Is_Active == "Y").FirstOrDefault();

                        if (objUser != null)
                            lstU.Add(objUser);
                    }
                }
                lstU = lstU.Union(objUserService.GetAll().Where(u => selectedUsers.Contains(u.Users_Code.ToString())).ToList()).ToList();
                lst = new SelectList(lstU.Select(x => new { Display_Value = x.Users_Code, Display_Text = x.First_Name + " " + x.Last_Name }).Distinct()
               , "Display_Value", "Display_Text", selectedUsers.Split(',')).OrderBy(x => x.Text).ToList();
                selectedCcBcclist = lst;
            }
            else
                lst = null;
            if (Type == "G")
            {
                int selectedGroup = 0;
                if (!string.IsNullOrEmpty(DummyGuid))
                    selectedGroup = (int)objECD.Email_Config_Detail_User.Where(x => x.Dummy_Guid == DummyGuid).Select(x => x.Security_Group_Code).FirstOrDefault();

                if (BUCodes != null)
                {
                    var arr = BUCodes;
                    List<Security_Group> lstSG = new List<Security_Group>();
                    lstSG = objSecurity_GroupService.GetList().Where(s =>
                    s.Users.Where(u => u.Users_Business_Unit.Where(b => BUCodes.Contains(b.Business_Unit_Code.ToString()))
                    .ToList().Count > 0 && u.Is_Active == "Y").ToList().Count > 0 && s.Is_Active == "Y").ToList();
                    Security_Group a = objSecurity_GroupService.GetList().Where(x => x.Security_Group_Code == selectedGroup).FirstOrDefault();
                    if (a != null)
                        lstSG.Add(a);
                    lstG = new SelectList(lstSG.
                        Select(x => new { Display_Value = x.Security_Group_Code, Display_Text = x.Security_Group_Name }).Distinct()
                        , "Display_Value", "Display_Text", selectedGroup).OrderBy(x => x.Text).ToList();
                }
                else
                {
                    lstG = new SelectList(objSecurity_GroupService.GetList().Where(s => s.Is_Active == "Y"
                    && s.Users.Where(y => y.Is_Active == "Y").ToList().Count() > 0)
                        .Select(x => new { Display_Value = x.Security_Group_Code, Display_Text = x.Security_Group_Name }).Distinct()
                   , "Display_Value", "Display_Text", selectedGroup).OrderBy(x => x.Text).ToList();
                }
                obj.Add("selectedGroup", selectedGroup);
                obj.Add("lstG", lstG);
            }
            else
            {
                if (BUCodes == null)
                {
                    lst = new MultiSelectList(objUserService.GetAll().Where(x => x.Is_Active == "Y")
                  .Select(x => new { Display_Value = x.Users_Code, Display_Text = x.First_Name + " " + x.Last_Name }).Distinct()
                 , "Display_Value", "Display_Text", selectedUsers.Split(',')).OrderBy(x => x.Text).ToList();
                    selectedCcBcclist = lst;

                }
                obj.Add("selectedUsers", selectedUsers.Split(','));
            }
            obj.Add("lst", lst);
            obj.Add("selectedCcBcclist", selectedCcBcclist);
            return Json(obj);
        }
        public JsonResult UserSave(string Type, string[] BuCodes, string[] UsersCodes, string[] CcCodes, string[] BccCodes, string[] ChannelCodes, string DummyGuid, string[] UserEmails, string[] CcuserEmails, string[] BccuserEmails)
        {
            string status = "S", messsage = "Data Saved Successfully", BuCode = "", ChannelCode = "", UserEmail = "", CcuserEmail = "", BccuserEmail = "";
            if (!string.IsNullOrEmpty(DummyGuid))
                messsage = "Data Updated Successfully";

            if (BuCodes != null)
                BuCode = string.Join(",", BuCodes);
            if (ChannelCodes != null)
                ChannelCode = string.Join(",", ChannelCodes);

            int SecurityGroupCode = 0;
            string UsersCode = "";
            string CcCode = "";
            string BccCode = "";
            if (Type == "G")
            {
                SecurityGroupCode = Convert.ToInt32(UsersCodes[0]);
                UsersCodes = objUserService.GetAll().Where(x => x.Security_Group_Code == SecurityGroupCode && x.Is_Active == "Y").Select(x => x.Users_Code.ToString()).ToArray();
            }
            else if (Type == "U")
            {
                if (UsersCode != null)
                    UsersCode = string.Join(",", UsersCodes);
            }
            if (CcCodes != null)
                CcCode = string.Join(",", CcCodes);
            if (BccCodes != null)
                BccCode = string.Join(",", BccCodes);
            if (UserEmails != null)
                UserEmail = string.Join(";", UserEmails.Where(x => !string.IsNullOrWhiteSpace(x)));
            if (CcuserEmails != null)
                CcuserEmail = string.Join(";", CcuserEmails.Where(x => !string.IsNullOrWhiteSpace(x)));
            if (BccuserEmails != null)
                BccuserEmail = string.Join(";", BccuserEmails.Where(x => !string.IsNullOrWhiteSpace(x)));

            bool IsValid = true;
            if (Type != "E")
            {
                IsValid = ValidateUser(Type, BuCodes, UsersCodes, ChannelCodes, DummyGuid, SecurityGroupCode);
            }

            if (IsValid)
            {
                Email_Config_Detail_User objECUD = objECD.Email_Config_Detail_User.Where(x => x.Dummy_Guid == DummyGuid).FirstOrDefault();
                if (objECUD == null)
                {
                    objECUD = new Email_Config_Detail_User();
                    objECD.Email_Config_Detail_User.Add(objECUD);
                }
                objECUD.Business_Unit_Codes = BuCode;
                if (Type == "G")
                {
                    objECUD.Security_Group_Code = SecurityGroupCode;
                    objECUD.User_Codes = "";
                    objECUD.ToUser_MailID = null;
                    objECUD.CCUser_MailID = null;
                    objECUD.BCCUser_MailID = null;
                }
                else if (Type == "U")
                {
                    objECUD.User_Codes = UsersCode;
                    objECUD.Security_Group_Code = null;
                    objECUD.ToUser_MailID = null;
                    objECUD.CCUser_MailID = null;
                    objECUD.BCCUser_MailID = null;
                }
                else
                {
                    objECUD.User_Codes = "";
                    objECUD.Security_Group_Code = null;
                    objECUD.ToUser_MailID = UserEmail;
                    objECUD.CCUser_MailID = CcuserEmail;
                    objECUD.BCCUser_MailID = BccuserEmail;
                }
                objECUD.CC_Users = CcCode;
                objECUD.BCC_Users = BccCode;
                objECUD.CC_User_Names = null;
                objECUD.BCC_User_Names = null;
                objECUD.Channel_Codes = ChannelCode;
                objECUD.User_Type = Type;
                FillCommaSeparateName(objECUD);
            }
            else
            {
                status = "E";
                messsage = "Duplicate Combination not allowed";
            }
            Dictionary<string, object> objdic = new Dictionary<string, object>();
            objdic.Add("Status", status);
            objdic.Add("Message", messsage);
            return Json(objdic);
        }
        public JsonResult UserDelete(string DummyGuid)
        {
            Email_Config_Detail_User objECUD = objECD.Email_Config_Detail_User.Where(x => x.Dummy_Guid == DummyGuid).FirstOrDefault();
            if (objECUD != null)
            {
                if (objECUD.Email_Config_Detail_User_Code == 0)
                    objECD.Email_Config_Detail_User.Remove(objECUD);
                //else
                //    objECUD.EntityState = State.Deleted;
            }
            Dictionary<string, object> objdic = new Dictionary<string, object>();
            objdic.Add("Message", "Data Saved");
            return Json(objdic);
        }
        public JsonResult Save(string DisplayOnScreen = null, string EmailFrequency = null, string NotificationDays = null, string NotificationTime = "")
        {
            dynamic resultSet;
            //if (objECD.Email_Config_Detail_Code > 0)
                //objECD.EntityState = State.Modified;
            //else
            //    objECD.EntityState = State.Added;

            if (!string.IsNullOrEmpty(NotificationDays))
                objECD.Notification_Days = Convert.ToInt32(NotificationDays);
            if (!string.IsNullOrEmpty(NotificationTime))
                objECD.Notification_Time = Convert.ToDateTime(NotificationTime).TimeOfDay;
            else
                objECD.Notification_Time = null;

            objECD.Notification_Frequency = EmailFrequency;
            objECD.OnScreen_Notification = DisplayOnScreen;
            if (objECD.Email_Config.Days_Config == "Y")
            {
                var lstDays_Freq = objECD.Email_Config.Days_Freq.Split(',').Where(x => x != "").Select(x => x).ToList();
                objECD.Email_Config_Detail_Alert.ToList().ForEach(t => objECD.Email_Config_Detail_Alert.Remove(t)); //t => objTalent.Talent_Role.Remove(t)
                lstDays_Freq.ForEach(f =>
                {
                    Email_Config_Detail_Alert objECDA = new Email_Config_Detail_Alert();
                    objECDA.Email_Config_Detail_Code = objECD.Email_Config_Detail_Code;
                    if (f.Contains("<"))
                    {
                        objECDA.Mail_Alert_Days = Convert.ToInt32(f.Replace("<", "").Trim());
                        objECDA.Allow_Less_Than = "Y";
                    }
                    else if (f.Contains(">"))
                    {
                        objECDA.Mail_Alert_Days = Convert.ToInt32(f.Replace(">", "").Trim());
                        objECDA.Allow_Less_Than = "N";
                    }
                    else
                    {
                        objECDA.Mail_Alert_Days = Convert.ToInt32(f.Trim());
                        objECDA.Allow_Less_Than = "N";
                    }
                    //objECDA.EntityState = State.Added;
                    objECD.Email_Config_Detail_Alert.Add(objECDA);
                });
            }
            //if (objECD.Email_Config_Detail_Code > 0)
            //    //objECD.EntityState = State.Modified;
            //else
            //{
            //    //objECD.EntityState = State.Added;
            //    objECD.Email_Config = null;
            //}
            if (objECD.Email_Config_Detail_Code > 0)
                objECDService.UpdateEmail_Config_Detail_Movie(objECD);
            else
                objECDService.AddEntity(objECD);
            //objECDService.Save(objECD, out resultSet);
            Dictionary<string, object> objdic = new Dictionary<string, object>();
            objdic.Add("Message", "Data Saved Successfully");
            objECD = null;
            objECDService = null;
            return Json(objdic);
        }

        #region --- Private Methods ---
        private bool ValidateUser(string Type, string[] BuCodes, string[] UsersCodes, string[] ChannelCodes, string DummyGuid, int SecurityGroupCode)
        {
            bool IsValid = true;
            var newRecord = from t1 in BuCodes
                            from t2 in UsersCodes
                            from t3 in ChannelCodes
                            select new { BuCode = t1, UsersCode = t2, ChannelCode = t3, SecurityGroupCode = SecurityGroupCode };
            List<Email_Config_Detail_User> lst = objECD.Email_Config_Detail_User.Where(x => x.Dummy_Guid != DummyGuid).Select(x => x).ToList();

            if (lst.Count > 0)
            {

                //existRecord
                var existRecord = from obj in lst
                                  from t1 in obj.Business_Unit_Codes.Split(',')
                                  from t2 in obj.User_Codes.Split(',')
                                  from t3 in obj.Channel_Codes.Split(',')
                                  select new { Business_Unit_Code = t1, User_Code = t2, Channel_Code = t3, Security_Group_Code = obj.Security_Group_Code };

                var existRecordNew = from x in existRecord
                                     from y in objUserService.GetAll().Where(u => u.Is_Active == "Y")
                   .Where(y => y.Security_Group_Code == x.Security_Group_Code)
                                     select new
                                     {
                                         Business_Unit_Code = x.Business_Unit_Code,
                                         User_Code = y.Users_Code,
                                         Channel_Code = x.Channel_Code
                                     };
                var DuplicateRecord = from x in newRecord
                                      from y in existRecord
                    .Where(y => y.Business_Unit_Code == x.BuCode && y.Channel_Code == x.ChannelCode && y.User_Code == x.UsersCode)
                                      select new
                                      {
                                          Business_Unit_Code = y.Business_Unit_Code,
                                          User_Code = y.User_Code,
                                          Channel_Code = y.Channel_Code
                                      };
                IsValid = DuplicateRecord.Count() == 0;
                if (IsValid)
                {
                    var DuplicateRecord1 = from x in newRecord
                                           from y in existRecordNew
                      .Where(y => y.Business_Unit_Code == x.BuCode && y.Channel_Code == x.ChannelCode
                      && Convert.ToString(y.User_Code) == x.UsersCode)
                                           select new
                                           {
                                               Business_Unit_Code = y.Business_Unit_Code,
                                               User_Code = y.User_Code,
                                               Channel_Code = y.Channel_Code
                                           };
                    IsValid = DuplicateRecord1.Count() == 0;
                }
            }
            return IsValid;
        }
        private void FillCommaSeparateName(Email_Config_Detail_User objECDU)
        {

            string[] arrBUCodes = objECDU.Business_Unit_Codes.Split(',');
            string[] arrChannelCodes = objECDU.Channel_Codes.Split(',');

            if (objECDU.CC_Users != "" && objECDU.CC_Users != null)
            {
                string[] arrCcCodes = objECDU.CC_Users.Split(',');
                objECDU.CC_User_Names = string.Join(", ", (objUserService.GetAll().Where(x => arrCcCodes.Contains(x.Users_Code.ToString())
               ).Select(x => x.First_Name).ToList()));
            }
            if (objECDU.BCC_Users != "" && objECDU.BCC_Users != null)
            {
                string[] arrBccCodes = objECDU.BCC_Users.Split(',');
                objECDU.BCC_User_Names = string.Join(", ", (objUserService.GetAll().Where(x => arrBccCodes.Contains(x.Users_Code.ToString())
                ).Select(x => x.First_Name).ToList()));
            }
            if (objECDU.User_Codes != "" && objECDU.User_Codes != null)
            {
                string[] arrUserCodes = objECDU.User_Codes.Split(',');
                objECDU.User_Names = string.Join(", ", (objUserService.GetAll().Where(x => arrUserCodes.Contains(x.Users_Code.ToString())
               ).Select(x => x.First_Name).ToList()));
            }
            if (objECDU.Business_Unit_Codes != "")
            {
                objECDU.Business_Unit_Names = string.Join(", ", (objBusiness_UnitService.GetAll().Where(x => arrBUCodes
                .Contains(x.Business_Unit_Code.ToString())

                ).Select(x => x.Business_Unit_Name).ToList()));
            }
            if (objECDU.Channel_Codes != "")
            {
                objECDU.Channel_Names = string.Join(", ", (objChannelService.GetList().Where(x => arrChannelCodes.Contains(x.Channel_Code.ToString())
               ).Select(x => x.Channel_Name).ToList()));
            }
            if (objECDU.Security_Group_Code != 0 && objECDU.Security_Group_Code != null)
            {
                objECDU.Security_Group_Names = objSecurity_GroupService.GetList().Where(x => x.Security_Group_Code == objECDU.Security_Group_Code
                && x.Is_Active == "Y").Select(x => x.Security_Group_Name).FirstOrDefault();

                objECDU.User_Names = string.Join(", ", (objUserService.GetAll().Where(x => x.Security_Group_Code == objECDU.Security_Group_Code
               && x.Is_Active == "Y"
               && ((x.Users_Business_Unit.Where(y => arrBUCodes.Contains(y.Business_Unit_Code.ToString())).FirstOrDefault().Users_Code == x.Users_Code && objECDU.Business_Unit_Codes != "0") || objECDU.Business_Unit_Codes == "0")
               ).Select(x => x.First_Name).ToList()));
            }
        }
        private List<SelectListItem> GetEmail_Freq_List(string selectedValue = "N")
        {
            List<SelectListItem> lst_EmailFreq = new List<SelectListItem>();
            lst_EmailFreq.Insert(0, new SelectListItem() { Value = "N", Text = "NA" });
            lst_EmailFreq.Insert(1, new SelectListItem() { Value = "M", Text = "Monthly" });
            lst_EmailFreq.Insert(2, new SelectListItem() { Value = "D", Text = "Daily" });
            lst_EmailFreq.Insert(3, new SelectListItem() { Value = "H", Text = "Hourly" });
            lst_EmailFreq = new SelectList(lst_EmailFreq, "Value", "Text", selectedValue).ToList();
            return lst_EmailFreq;
        }
        private List<SelectListItem> GetEmail_Freq_Days_List(int selectedValue = 0)
        {
            List<SelectListItem> lst_EmailFreqDays = new List<SelectListItem>();
            for (int i = 1; i <= 31; i++)
            {
                lst_EmailFreqDays.Add(new SelectListItem() { Value = i.ToString(), Text = i.ToString() });
            }
            lst_EmailFreqDays = new SelectList(lst_EmailFreqDays, "Value", "Text", selectedValue.ToString()).ToList();
            return lst_EmailFreqDays;
        }
        #endregion
    }
}
