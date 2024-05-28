using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Web.Mail;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using System.Configuration;
using Newtonsoft.Json;

namespace RightsU_Plus.Controllers
{
    public class UserController : BaseController
    {
        #region --- Properties ---
        private List<RightsU_Entities.User> lstUser
        {
            get
            {
                if (Session["lstUser"] == null)
                    Session["lstUser"] = new List<RightsU_Entities.User>();
                return (List<RightsU_Entities.User>)Session["lstUser"];
            }
            set { Session["lstUser"] = value; }
        }

        private List<RightsU_Entities.Security_Group> lstSecurityGroup
        {
            get
            {
                if (Session["lstSecurityGroup"] == null)
                    Session["lstSecurityGroup"] = new List<RightsU_Entities.Security_Group>();
                return (List<RightsU_Entities.Security_Group>)Session["lstSecurityGroup"];
            }
            set { Session["lstSecurityGroup"] = value; }
        }

        private List<RightsU_Entities.User> lstUser_Searched
        {
            get
            {
                if (Session["lstUser_Searched"] == null)
                    Session["lstUser_Searched"] = new List<RightsU_Entities.User>();
                return (List<RightsU_Entities.User>)Session["lstUser_Searched"];
            }
            set { Session["lstUser_Searched"] = value; }
        }

        #endregion

        public ViewResult Index()
        {
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForUsers.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstUser_Searched = lstUser = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForUsers);
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();

            List<SelectListItem> lstStatus = new List<SelectListItem>();
            lstStatus.Add(new SelectListItem { Text = objMessageKey.Active, Value = "Y" });
            lstStatus.Add(new SelectListItem { Text = objMessageKey.Deactive, Value = "N" });
            ViewBag.Status = lstStatus;

            var SecurityGroupCodes = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(x => x.Security_Group_Code).ToArray();
            var lstSecurityGroup = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => (SecurityGroupCodes.Contains(x.Security_Group_Code))).ToList();
            ViewBag.SecGroup = new SelectList(lstSecurityGroup, "Security_Group_Code", "Security_Group_Name");

            var lstProductionRoleVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y"
                && s.Vendor_Role.Where(x => x.Role_Code == 9).Count() > 0).ToList();
            // int? Vendor_Code = objLoginUser.MHUsers.Select(s => s.Vendor_Code).FirstOrDefault();
            ViewBag.Vendor = new SelectList(lstProductionRoleVendor, "Vendor_Code", "Vendor_Name");
            Session["VendorData"] = lstProductionRoleVendor;


            string AllowUSer = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
            ViewBag.AllowUSer = AllowUSer;
            FetchData();
            return View("~/Views/User/Index.cshtml");
        }

        public ActionResult ViewProfile(FormCollection objFormCollection)
        {
            int UserCode = Convert.ToInt32(objFormCollection["userCode"]);
            RightsU_Entities.User objUser = FillUser(UserCode);
            ViewBag.FullName = objUser.Full_Name;
            return View("~/Views/User/ViewProfile.cshtml", objUser);
        }
        public ActionResult ViewUserProfiles()
        {
            int UserCode = objLoginUser.Users_Code;
            RightsU_Entities.User objUser = FillUser(UserCode);
            ViewBag.FullName = objUser.Full_Name;
            return View("~/Views/User/ViewProfile.cshtml", objUser);
        }

        public User FillUser(int userCode)
        {
            RightsU_Entities.User objUser = new User_Service(objLoginEntity.ConnectionStringName).GetById(userCode);
            string fullName = objUser.First_Name;
            if (!string.IsNullOrEmpty(objUser.Middle_Name))
                fullName += " " + objUser.Middle_Name;
            if (!string.IsNullOrEmpty(objUser.Last_Name))
                fullName += " " + objUser.Last_Name;
            string businessUnitName = string.Join(", ", objUser.Users_Business_Unit.Select(s => s.Business_Unit.Business_Unit_Name.ToString()).ToList());
            objUser.Business_Unit_Names = businessUnitName;
            return objUser;
        }
        public ActionResult UpdateProfilePicture(int hdnUserCode)
        {
            HttpPostedFileBase file = Request.Files["uploadFile"];
            User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.User objUse = objService.GetById(hdnUserCode);
            string filename = DateTime.Now.Ticks.ToString() + "_";
            filename += file.FileName;
            if (filename != "" && file.FileName != "")
            {
                file.SaveAs(Server.MapPath(System.Configuration.ConfigurationManager.AppSettings["TitleImagePath"] + filename));
                objUse.User_Image = filename;
            }
            objUse.EntityState = State.Modified;
            objService.Save(objUse);

            RightsU_Entities.User objUser = FillUser(hdnUserCode);
            ViewBag.FullName = objUser.Full_Name;
            return View("~/Views/User/ViewProfile.cshtml", objUser);
        }

        public PartialViewResult BindUserList(int pageNo, int recordPerPage, string sortType, string searchIsLDAPUser = "", int vendorCode = 0)
        {
            List<RightsU_Entities.User> lst = new List<RightsU_Entities.User>();
            int RecordCount = 0;

            string AllowUSer = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
            ViewBag.AllowUSer = AllowUSer;

            if (ViewBag.AllowUser == "Y")
            {
                lstUser_Searched = lstUser_Searched.Where(o => o.IsLDAPUser == searchIsLDAPUser).ToList();
            }
            else
            {
                lstUser_Searched = lstUser_Searched;

            }
            if (vendorCode > 0)
            {
                lstUser_Searched = lstUser_Searched.Where(x => x.MHUsers.Where(o => o.Vendor_Code == vendorCode).Count() > 0).ToList();
            }

            RecordCount = lstUser_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstUser_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstUser_Searched.OrderBy(o => o.Login_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstUser_Searched.OrderByDescending(o => o.Login_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();

            return PartialView("~/Views/User/_UserList.cshtml", lst);
        }
        public PartialViewResult BindUserConfiguration(int UserCode, string TabName)
        {
            ViewBag.isProdHouse = GetUserModuleRights().Contains(GlobalParams.RightCodeForProductionHouseUser.ToString());
            var paramValue = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Is_Allow_Multilanguage").Select(x => x.Parameter_Value).SingleOrDefault();
            ViewBag.parmValue = paramValue;
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.User objUser = null;

            if (UserCode > 0)
            {
                objUser = objUser_Service.GetById(UserCode);
            }
            else
                objUser = new RightsU_Entities.User();

            ViewBag.SecurityGroup = new SelectList(new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Security_Group_Code", "Security_Group_Name", objUser.Security_Group_Code);
            List<System_Language> lstSystemLanguage = new System_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList();
            int systemLanguageCode = (lstSystemLanguage.Where(w => w.Is_Default == "Y").First() ?? new System_Language()).System_Language_Code;
            if (UserCode > 0)
            {
                systemLanguageCode = (objUser.System_Language_Code ?? systemLanguageCode);
            }
            else
            {
                systemLanguageCode = 0;
            }
            ViewBag.Language = new SelectList(lstSystemLanguage, "System_Language_Code", "Language_Name", systemLanguageCode);

            List<Business_Unit> lstBusinessUnit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).Where(x=>x.Is_Active == "Y").OrderBy(o => o.Business_Unit_Name).ToList();
            var businessUnitCodes = objUser.Users_Business_Unit.Select(s => s.Business_Unit_Code).ToArray();
            ViewBag.BusinessUnitList = new MultiSelectList(lstBusinessUnit, "Business_Unit_Code", "Business_Unit_Name", businessUnitCodes);

            var Is_ROP_Accessible = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Is_ROP_Accessible").Select(x => x.Parameter_Value).SingleOrDefault();
            ViewBag.Is_ROP_Accessible = Is_ROP_Accessible;

            List<Attrib_Group> lstBusinessLayer = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).Where(x => x.Attrib_Type == "BL").OrderBy(o => o.Attrib_Group_Name).ToList();
            var businessLayerCodes = objUser.Users_Detail.Select(x => x.Attrib_Group_Code).ToArray();
            ViewBag.BusinessLayerList = new MultiSelectList(lstBusinessLayer, "Attrib_Group_Code", "Attrib_Group_Name", businessLayerCodes);

            List<Attrib_Group> lstBusinessVertical = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).Where(x => x.Attrib_Type == "BV").OrderBy(o => o.Attrib_Group_Name).ToList();
            var businessVerticalCodes = objUser.Users_Detail.Select(x => x.Attrib_Group_Code).ToArray();
            ViewBag.BusinessVerticalList = new MultiSelectList(lstBusinessVertical, "Attrib_Group_Code", "Attrib_Group_Name", businessVerticalCodes);

            List<Attrib_Group> lstDepartment = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).Where(x => x.Attrib_Type == "DP").OrderBy(o => o.Attrib_Group_Name).ToList();
            var DepartmentCodes = objUser.Users_Detail.Select(x => x.Attrib_Group_Code).ToArray();
            ViewBag.DepartmentList = new MultiSelectList(lstDepartment, "Attrib_Group_Code", "Attrib_Group_Name", DepartmentCodes);

            List<RightsU_Entities.Vendor> lstProductionRoleVendor = (List<RightsU_Entities.Vendor>)Session["VendorData"];
            int? Vendor_Code = objUser.MHUsers.Select(s => s.Vendor_Code).FirstOrDefault();
            ViewBag.Vendor = new SelectList(lstProductionRoleVendor, "Vendor_Code", "Vendor_Name", Vendor_Code);
            ViewBag.Vendor_Code = Vendor_Code;

            string AllowUSer = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
            ViewBag.AllowUSer = AllowUSer;
            ViewBag.TabName = TabName;

            List<System_Parameter_New> lstsys = new List<System_Parameter_New>();
            lstsys = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Type == "U").OrderBy(o => o.Parameter_Name).ToList();
            List<Email_Config> lstEmailConfig = new List<Email_Config>();
            lstEmailConfig = new Email_Config_Detail_User_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.User_Codes.Contains(objUser.Users_Code.ToString()) || w.CC_Users.Contains(objUser.Users_Code.ToString())
                || w.BCC_Users.Contains(objUser.Users_Code.ToString()) || w.ToUser_MailID.Contains(objUser.Email_Id) || w.CCUser_MailID.Contains(objUser.Email_Id) || w.BCCUser_MailID.Contains(objUser.Email_Id))
                .Select(s => s.Email_Config_Detail.Email_Config).Distinct().ToList();
            ViewBag.SystemParamList = lstsys;
            ViewBag.EmailConfigList = lstEmailConfig;
            return PartialView("~/Views/User/_UserGeneralInfo.cshtml", objUser);
        }
        public PartialViewResult BindUSerSecurityGroup(int? SecurityGroupCode, int UsersCode)
        {
            string[] strUserModule_Right_Code = new Users_Exclusion_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == UsersCode).ToList().Select(s => s.Module_Right_Code.ToString()).ToArray();

            string[] strModule_right_Code = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Security_Group_Code == SecurityGroupCode).ToList().Select(x => Convert.ToString(x.System_Module_Rights_Code)).ToArray();
            string Module_right_Code = string.Join(",", new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Security_Group_Code == SecurityGroupCode).ToList().Select(x => Convert.ToString(x.System_Module_Rights_Code)));
            var strExceptRightsCode = strModule_right_Code.Except(strUserModule_Right_Code);
            string strUserExceptionRights = string.Join(",", strExceptRightsCode);
            User_Security_Tree_View objST = new User_Security_Tree_View(objLoginEntity.ConnectionStringName);
            if (strUserExceptionRights != "")
                objST.SecurityCodes_Selected = strUserExceptionRights.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //objST.SecurityCodes_Selected = strExceptRightsCode;
            else
                objST.SecurityCodes_Selected = Module_right_Code.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            objST.SecurityCodes_Display = Module_right_Code;
            ViewBag.TV_Platform = objST.PopulateTreeNode("Y");
            ViewBag.TreeId = "Rights_Security";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }

        #region  --- Other Methods ---
        private int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }
        private void FetchData()
        {
            lstUser_Searched = lstUser = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();

        }
        #endregion

        public JsonResult SearchUser(string searchText, string searchIsLDAPUser = "", int vendorCode = 0, string status = "", int secGroupCode = 0)
        {
            string AllowUSer = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
            ViewBag.AllowUSer = AllowUSer;

            if (ViewBag.AllowUSer == "Y")
            {
                lstUser_Searched = lstUser.Where(w => w.IsLDAPUser == searchIsLDAPUser).ToList();
            }
            else
            {
                lstUser_Searched = lstUser;
            }
            if (!string.IsNullOrEmpty(status))
            {
                lstUser_Searched = lstUser_Searched.Where(x => x.Is_Active == status).ToList();
            }
            if (secGroupCode > 0)
            {
                lstUser_Searched = lstUser_Searched.Where(x => x.Security_Group_Code == secGroupCode).ToList();
            }
            if (!string.IsNullOrEmpty(searchText) && vendorCode == 0)
            {
                lstUser_Searched = lstUser_Searched.Where(w => (w.First_Name.ToUpper().Contains(searchText.ToUpper())
                 || w.Last_Name.ToUpper().Contains(searchText.ToUpper()))
                 ).ToList();
            }
            else if (!string.IsNullOrEmpty(searchText) && vendorCode > 0)
            {
                lstUser_Searched = lstUser_Searched.Where(w =>
                    (w.First_Name.ToUpper().Contains(searchText.ToUpper()) || w.Last_Name.ToUpper().Contains(searchText.ToUpper()))
                    && w.MHUsers.Where(x => x.Vendor_Code == vendorCode).Count() > 0).ToList();
            }
            else if (string.IsNullOrEmpty(searchText) && vendorCode > 0)
            {
                lstUser_Searched = lstUser_Searched.Where(w => w.MHUsers.Where(x => x.Vendor_Code == vendorCode).Count() > 0
                    ).ToList();
            }
            else if (string.IsNullOrEmpty(searchText) && vendorCode == 0)
            {
                lstUser_Searched = lstUser_Searched;
            }
            else
                lstUser_Searched = lstUser;

            var obj = new
            {
                Record_Count = lstUser_Searched.Count
            };

            return Json(obj);
        }

        public JsonResult ActiveDeactiveUser(int userCode, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "", Action = Convert.ToString(ActionType.A); // A = "Active";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(userCode, GlobalParams.ModuleCodeForUsers, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);

            if (isLocked)
            {                
                User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.User objUser = objService.GetById(userCode);
                objUser.Is_Active = doActive;
                objUser.Last_Updated_Time = DateTime.Now;
                objUser.Last_Action_By = objLoginUser.Users_Code;
                objUser.Validate_Email = false;
                objUser.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objUser, out resultSet);
                if (isValid)
                {
                    lstUser.Where(w => w.Users_Code == userCode).First().Is_Active = doActive;
                    lstUser_Searched.Where(w => w.Users_Code == userCode).First().Is_Active = doActive;

                    if (doActive == "Y")
                    {
                        message = objMessageKey.Recordactivatedsuccessfully;
                        //message = message.Replace("{ACTION}", "Activated");
                    }
                    else
                    {
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                        //message = message.Replace("{ACTION}", "Deactivated");
                        Action = Convert.ToString(ActionType.D); // D = "Deactive";
                    }

                    try
                    {
                        objUser.Created_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objUser.Created_By));
                        objUser.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objUser.Last_Action_By));
                        objUser.Default_Entity_Name = new Entity_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Entity_Code == objUser.Default_Entity_Code).Select(x => x.Entity_Name).FirstOrDefault();
                        objUser.Security_Group_Name = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Security_Group_Code == objUser.Security_Group_Code).Select(x => x.Security_Group_Name).FirstOrDefault();
                        objUser.Users_Business_Unit.ToList().ForEach(f => f.Business_Unit_name = new Business_Unit_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Business_Unit_Code)).Business_Unit_Name);
                        objUser.Users_Detail.ToList().ForEach(f => f.Attrib_Group_name = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Attrib_Group_Code)).Attrib_Group_Name);

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objUser);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForUsers), Convert.ToInt32(objUser.Users_Code), LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeForUsers;
                        objAuditLog.intCode = objUser.Users_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objUser.Last_Updated_Time));
                        objAuditLog.actionType = Action;
                        var strCheck = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().PostAuditLogAPI(objAuditLog, "");

                        var LogDetail = JsonConvert.DeserializeObject<JsonData>(strCheck);
                        if (Convert.ToString(LogDetail.ErrorMessage) == "Error")
                        {

                        }
                    }
                    catch (Exception ex)
                    {

                    }
                }
                else
                {
                    message = resultSet;
                }
                objCommonUtil.Release_Record(RLCode, objLoginEntity.ConnectionStringName);                
            }
            else
            {
                status = "E";
                message = strMessage;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        /*Added By Aditya*/
        //public JsonResult ActiveDeactiveUser(int userCode, int doActive)
        //{
        //    string status = "S", message = "Record {ACTION} successfully", strMessage = "";
        //    int RLCode = 0;
        //    bool isLocked = CommonUtil.Lock_Record(userCode, GlobalParams.ModuleCodeForUsers, objLoginUser.Users_Code, out RLCode, out strMessage);

        //    if (isLocked)
        //    {
        //        User_Service objService = new User_Service();
        //        RightsU_Entities.User objUser = objService.GetById(userCode);
        //        objUser.Is_Active = doActive.ToString();
        //        objUser.Validate_Email = false;
        //        objUser.EntityState = State.Modified;
        //        dynamic resultSet;
        //        bool isValid = objService.Save(objUser, out resultSet);
        //        if (isValid)
        //        {
        //            lstUser.Where(w => w.Users_Code == userCode).First().Is_Active = doActive.ToString();
        //            lstUser_Searched.Where(w => w.Users_Code == userCode).First().Is_Active = doActive.ToString();

        //            if (doActive.ToString() == "N")
        //                message = message.Replace("{ACTION}", "Activated");
        //            else
        //                message = message.Replace("{ACTION}", "Deactivated");
        //        }
        //        else
        //        {
        //            message = resultSet;
        //        }
        //        CommonUtil.Release_Record(RLCode);
        //    }
        //    else
        //    {
        //        status = "E";
        //        message = strMessage;
        //    }
        //    var obj = new
        //    {
        //        Status = status,
        //        Message = message
        //    };
        //    return Json(obj);
        //}
        /*End*/

        public JsonResult UnlockUser(int userCode)
        {
            string status = "S", message = "", Action = Convert.ToString(ActionType.U); // U = "Update";
            User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.User objUser = objService.GetById(userCode);
            objUser.Password_Fail_Count = 0;
            objUser.Last_Updated_Time = DateTime.Now;
            objUser.Last_Action_By = objLoginUser.Users_Code;
            objUser.Validate_Email = false;
            objUser.EntityState = State.Modified;

            dynamic resultSet;
            bool isvalid = objService.Save(objUser, out resultSet);
            if (isvalid)
            {
                FetchData();
                message = objMessageKey.UserUnlockedSuccessfully;

                objUser.Created_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objUser.Created_By));
                objUser.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objUser.Last_Action_By));
                objUser.Default_Entity_Name = new Entity_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Entity_Code == objUser.Default_Entity_Code).Select(x => x.Entity_Name).FirstOrDefault();
                objUser.Security_Group_Name = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Security_Group_Code == objUser.Security_Group_Code).Select(x => x.Security_Group_Name).FirstOrDefault();
                objUser.Users_Business_Unit.ToList().ForEach(f => f.Business_Unit_name = new Business_Unit_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Business_Unit_Code)).Business_Unit_Name);
                objUser.Users_Detail.ToList().ForEach(f => f.Attrib_Group_name = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Attrib_Group_Code)).Attrib_Group_Name);

                string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objUser);
                //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForUsers), Convert.ToInt32(objUser.Users_Code), LogData, Action, objLoginUser.Users_Code);

                MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                objAuditLog.moduleCode = GlobalParams.ModuleCodeForUsers;
                objAuditLog.intCode = objUser.Users_Code;
                objAuditLog.logData = LogData;
                objAuditLog.actionBy = objLoginUser.Login_Name;
                objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objUser.Last_Updated_Time));
                objAuditLog.actionType = Action;
                var strCheck = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().PostAuditLogAPI(objAuditLog, "");

                var LogDetail = JsonConvert.DeserializeObject<JsonData>(strCheck);
                if (Convert.ToString(LogDetail.ErrorMessage) == "Error")
                {

                }
            }
            else
            {
                message = resultSet;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult CheckRecordLock(int UserCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (UserCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(UserCode, GlobalParams.ModuleCodeForUsers, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public PartialViewResult AddEditUser(int UserCode)
        {
            //ViewBag.isProdHouse = GetUserModuleRights().Contains(GlobalParams.RightCodeForProductionHouseUser.ToString());
            //var paramValue = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Is_Allow_Multilanguage").Select(x => x.Parameter_Value).SingleOrDefault();
            //ViewBag.parmValue = paramValue;
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.User objUser = null;

            if (UserCode > 0)
            {
                objUser = objUser_Service.GetById(UserCode);
            }
            else
                objUser = new RightsU_Entities.User();

            ViewBag.SecurityGroup = new SelectList(new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Security_Group_Code", "Security_Group_Name");

            /*************************************Code Added For Configuration of language in the dropdown*************************************************/

            //var TotalModuleMessages = new System_Module_Message_Service().SearchFor(x => true).Count();
            //var LstSystem_Language_Code = new System_Language_Message_Service().SearchFor(x => true).Select(x => x.System_Language_Code).Distinct().ToList();
            //List<int> temp = new List<int>();
            //foreach (var item in LstSystem_Language_Code)
            //{
            //    var count_System_Message_Language = new System_Language_Message_Service().SearchFor(x => true).Where(x => x.System_Language_Code == item).Count();
            //    if (Convert.ToInt32(TotalModuleMessages) == Convert.ToInt32(count_System_Message_Language))
            //    {
            //        temp.Add(Convert.ToInt32(item));
            //    }
            //}
            //List<System_Language> lstSystemLanguage = new System_Language_Service().SearchFor(s => s.Is_Active == "Y").Where(x => temp.Contains(x.System_Language_Code)).ToList();

            /******************************************END**********************************************************************************************/
            //List<System_Language> lstSystemLanguage = new System_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList();
            //int systemLanguageCode = (lstSystemLanguage.Where(w => w.Is_Default == "Y").First() ?? new System_Language()).System_Language_Code;
            //if (UserCode > 0)
            //{
            //    systemLanguageCode = (objUser.System_Language_Code ?? systemLanguageCode);
            //}
            //else
            //{
            //    systemLanguageCode = 0;
            //}
            //ViewBag.Language = new SelectList(lstSystemLanguage, "System_Language_Code", "Language_Name", systemLanguageCode);

            //List<Business_Unit> lstBusinessUnit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).OrderBy(o => o.Business_Unit_Name).ToList();
            //var businessUnitCodes = objUser.Users_Business_Unit.Select(s => s.Business_Unit_Code).ToArray();
            //ViewBag.BusinessUnitList = new MultiSelectList(lstBusinessUnit, "Business_Unit_Code", "Business_Unit_Name", businessUnitCodes);

            //List<RightsU_Entities.Vendor> lstProductionRoleVendor = (List<RightsU_Entities.Vendor>)Session["VendorData"];
            //int? Vendor_Code = objUser.MHUsers.Select(s => s.Vendor_Code).FirstOrDefault();
            //ViewBag.Vendor = new SelectList(lstProductionRoleVendor, "Vendor_Code", "Vendor_Name", Vendor_Code);
            //ViewBag.Vendor_Code = Vendor_Code;

            //string AllowUSer = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
            //ViewBag.AllowUSer = AllowUSer;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/User/_AddEditUser.cshtml", objUser);
        }

        public JsonResult ResetPassword(int UserCode)
        {
            User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.User objUser = objService.GetById(UserCode);
            string pwd = "", Message = "", Action = Convert.ToString(ActionType.U); // U = "Update";
            pwd = generatePwd(objUser.First_Name, objUser.Last_Name);
            objUser.Password = getDatabaseEncryptedpassword(pwd);
            objUser.EntityState = State.Modified;
            objUser.Last_Updated_Time = DateTime.Now;
            objUser.Last_Action_By = objLoginUser.Users_Code;
            objUser.Is_System_Password = "Y";
            objUser.Password_Fail_Count = 0;
            dynamic resultSet;
            bool isValid = objService.Save(objUser, out resultSet);

            if (isValid)
            {
                Message = objMessageKey.PasswordResetsSuccessfully;

                objUser.Created_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objUser.Created_By));
                objUser.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objUser.Last_Action_By));
                objUser.Default_Entity_Name = new Entity_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Entity_Code == objUser.Default_Entity_Code).Select(x => x.Entity_Name).FirstOrDefault();
                objUser.Security_Group_Name = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Security_Group_Code == objUser.Security_Group_Code).Select(x => x.Security_Group_Name).FirstOrDefault();
                objUser.Users_Business_Unit.ToList().ForEach(f => f.Business_Unit_name = new Business_Unit_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Business_Unit_Code)).Business_Unit_Name);
                objUser.Users_Detail.ToList().ForEach(f => f.Attrib_Group_name = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Attrib_Group_Code)).Attrib_Group_Name);

                string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objUser);
                //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForUsers), Convert.ToInt32(objUser.Users_Code), LogData, Action, objLoginUser.Users_Code);

                MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                objAuditLog.moduleCode = GlobalParams.ModuleCodeForUsers;
                objAuditLog.intCode = objUser.Users_Code;
                objAuditLog.logData = LogData;
                objAuditLog.actionBy = objLoginUser.Login_Name;
                objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objUser.Last_Updated_Time));
                objAuditLog.actionType = Action;
                var strCheck = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().PostAuditLogAPI(objAuditLog, "");

                var LogDetail = JsonConvert.DeserializeObject<JsonData>(strCheck);
                if (Convert.ToString(LogDetail.ErrorMessage) == "Error")
                {

                }
            }
            else
            {
                Message = resultSet;
            }
            var obj = new
            {
                Message = Message,
                Password = pwd
            };
            return Json(obj);
        }

        [HttpPost]
        public ActionResult SaveUser(RightsU_Entities.User objUser_MVC, FormCollection objFormCollection)
        {

            User objU = new User();
            User_Service ObjUserService = new User_Service(objLoginEntity.ConnectionStringName);
            if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) > 0)
            {
                objU = ObjUserService.GetById(Convert.ToInt32(objFormCollection["hdnUsers_Code"]));
                objU.EntityState = State.Modified;
            }
            else
            {
                string password = "";
                //password = generatePwd(objUser_MVC.Login_Name);
                password = generatePwd(objUser_MVC.First_Name, objUser_MVC.Last_Name);
                objU.Password = getDatabaseEncryptedpassword(password);
                objU.EntityState = State.Added;
                objU.Is_Active = "Y";
                objU.Is_System_Password = "Y";
                objU.Password_Fail_Count = 0;
                objU.Created_By = objLoginUser.Users_Code;
                objU.Created_On = DateTime.Now;
            }
            objU.Security_Group_Code = objUser_MVC.Security_Group_Code;
            objU.Login_Name = objUser_MVC.Login_Name;
            objU.First_Name = objUser_MVC.First_Name;
            objU.Last_Name = objUser_MVC.Last_Name;
            objU.Middle_Name = objUser_MVC.Middle_Name;
            if (objUser_MVC.System_Language_Code == null)
                objU.System_Language_Code = new System_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Is_Default == "Y").Select(x => x.System_Language_Code).SingleOrDefault();
            else
                objU.System_Language_Code = objUser_MVC.System_Language_Code;
            objU.Validate_Email = true;
            objU.Email_Id = objUser_MVC.Email_Id;
            objU.Last_Updated_Time = DateTime.Now;
            objU.Last_Action_By = objLoginUser.Users_Code;
            objU.Default_Entity_Code = objLoginUser.Default_Entity_Code;
            string AllowUSer = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
            ViewBag.AllowUSer = AllowUSer;

            if (ViewBag.AllowUSer == "Y")
            {
                objU.IsLDAPUser = objFormCollection["IsLDAPUser"];
            }
            else
            {
                objU.IsLDAPUser = "N";
            }

            bool isProd = objFormCollection["ProductionHouseUser"] == null ? false : Convert.ToBoolean(objFormCollection["ProductionHouseUser"].Split(',')[0]);
            if (isProd == true)
            {
                objU.IsProductionHouseUser = "Y";
            }
            else
            {
                objU.IsProductionHouseUser = "N";
            }
            //objU.Created_By = objLoginUser.Users_Code;

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully", Action = Convert.ToString(ActionType.C); // C = "Create";

            ICollection<Users_Business_Unit> BuisnessUnitList = new HashSet<Users_Business_Unit>();
            if (objFormCollection["ddlBusinessUnit"] != null)
            {
                string[] arrBuisnessCode = objFormCollection["ddlBusinessUnit"].Split(',');
                foreach (string BuisnessUnitCode in arrBuisnessCode)
                {
                    Users_Business_Unit objTR = new Users_Business_Unit();
                    objTR.EntityState = State.Added;
                    objTR.Business_Unit_Code = Convert.ToInt32(BuisnessUnitCode);
                    BuisnessUnitList.Add(objTR);
                }
            }

            IEqualityComparer<Users_Business_Unit> comparerBuisness_Unit = new LambdaComparer<Users_Business_Unit>((x, y) => x.Business_Unit_Code == y.Business_Unit_Code && x.EntityState != State.Deleted);
            var Deleted_Users_Business_Unit = new List<Users_Business_Unit>();
            var Updated_Users_Business_Unit = new List<Users_Business_Unit>();
            var Added_Users_Business_Unit = CompareLists<Users_Business_Unit>(BuisnessUnitList.ToList<Users_Business_Unit>(), objU.Users_Business_Unit.ToList<Users_Business_Unit>(), comparerBuisness_Unit, ref Deleted_Users_Business_Unit, ref Updated_Users_Business_Unit);
            Added_Users_Business_Unit.ToList<Users_Business_Unit>().ForEach(t => objU.Users_Business_Unit.Add(t));
            Deleted_Users_Business_Unit.ToList<Users_Business_Unit>().ForEach(t => t.EntityState = State.Deleted);

            ICollection<Users_Detail> users_DetailsList = new HashSet<Users_Detail>();
            if (objFormCollection["ddlDepartment"] != null)
            {
                string[] arrBuisnessCode = objFormCollection["ddlDepartment"].Split(',');
                foreach (string BuisnessUnitCode in arrBuisnessCode)
                {
                    Users_Detail objTR = new Users_Detail();
                    objTR.EntityState = State.Added;
                    objTR.Attrib_Group_Code = Convert.ToInt32(BuisnessUnitCode);
                    objTR.Attrib_Type = "DP";
                    users_DetailsList.Add(objTR);
                }
            }

            if (objFormCollection["ddlBusinessLayer"] != null)
            {
                string[] arrBusinessLayer = objFormCollection["ddlBusinessLayer"].Split(',');
                foreach (var BusinessLayerCodes in arrBusinessLayer)
                {
                    Users_Detail objTR = new Users_Detail();
                    objTR.EntityState = State.Added;
                    objTR.Attrib_Group_Code = Convert.ToInt32(BusinessLayerCodes);
                    objTR.Attrib_Type = "BL";
                    users_DetailsList.Add(objTR);
                }
            }

            if (objFormCollection["ddlBusinessVertical"] != null)
            {
                string[] arrBusinessVertical = objFormCollection["ddlBusinessVertical"].Split(',');
                foreach (var BusinessLayerCodes in arrBusinessVertical)
                {
                    Users_Detail objTR = new Users_Detail();
                    objTR.EntityState = State.Added;
                    objTR.Attrib_Group_Code = Convert.ToInt32(BusinessLayerCodes);
                    objTR.Attrib_Type = "BV";
                    users_DetailsList.Add(objTR);
                }
            }

            IEqualityComparer<Users_Detail> compareUsers_Detail = new LambdaComparer<Users_Detail>((x, y) => x.Attrib_Group_Code == y.Attrib_Group_Code && x.EntityState != State.Deleted);
            var Deleted_Users_Detail = new List<Users_Detail>();
            var Updated_Users_Detail = new List<Users_Detail>();
            var Added_Users_Detail = CompareLists<Users_Detail>(users_DetailsList.ToList<Users_Detail>(), objU.Users_Detail.ToList<Users_Detail>(), compareUsers_Detail, ref Deleted_Users_Detail, ref Updated_Users_Detail);
            Added_Users_Detail.ToList<Users_Detail>().ForEach(t => objU.Users_Detail.Add(t));
            Deleted_Users_Detail.ToList<Users_Detail>().ForEach(t => t.EntityState = State.Deleted);

            ICollection<MHUser> MHUser = new HashSet<MHUser>();
            if (objFormCollection["ddlVendors"] != null)
            {
                string Vendor_Code = objFormCollection["ddlVendors"];
                MHUser objMHUSer = new MHUser();
                objMHUSer.Vendor_Code = Convert.ToInt32(Vendor_Code);
                objMHUSer.EntityState = State.Added;
                MHUser.Add(objMHUSer);
            }

            IEqualityComparer<MHUser> compareMHUSer = new LambdaComparer<MHUser>((x, y) => x.Vendor_Code == y.Vendor_Code && x.EntityState != State.Deleted);
            var Deleted_MHUser = new List<MHUser>();
            var Updated_MHUser = new List<MHUser>();
            var Added_MHUSer = CompareLists<MHUser>(MHUser.ToList<MHUser>(), objU.MHUsers.ToList<MHUser>(), compareMHUSer, ref Deleted_MHUser, ref Updated_MHUser);
            Added_MHUSer.ToList<MHUser>().ForEach(t => objU.MHUsers.Add(t));
            Deleted_MHUser.ToList<MHUser>().ForEach(t => t.EntityState = State.Deleted);

            #region Removed Users Exclution Rights Functionality by JD

            //ICollection<Users_Exclusion_Rights> ExclusionRightsList = new HashSet<Users_Exclusion_Rights>();
            //if (objFormCollection["hdnTvCodes"] != null)
            //{
            //    string[] arrUsersSystemRights = objFormCollection["hdnTvCodes"].Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //    string strModule_right_Code = string.Join(",", new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Security_Group_Code == objU.Security_Group_Code).ToList().Select(x => Convert.ToString(x.System_Module_Rights_Code)));
            //    string[] arrSystemRights = strModule_right_Code.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //    var ExceptsystemRights = arrSystemRights.Except(arrUsersSystemRights);
            //    foreach (string SystemRightsCode in ExceptsystemRights)
            //    {
            //        if (SystemRightsCode != "0")
            //        {
            //            Users_Exclusion_Rights objTR = new Users_Exclusion_Rights();
            //            objTR.EntityState = State.Added;
            //            objTR.Module_Right_Code = Convert.ToInt32(SystemRightsCode);
            //            ExclusionRightsList.Add(objTR);
            //        }
            //    }
            //}
            //IEqualityComparer<Users_Exclusion_Rights> comparerExclusion_Rights = new LambdaComparer<Users_Exclusion_Rights>((x, y) => x.Module_Right_Code == y.Module_Right_Code && x.EntityState != State.Deleted);
            //var Deleted_Users_Exclusion_Rights = new List<Users_Exclusion_Rights>();
            //var Updated_Users_Exclusion_Rights = new List<Users_Exclusion_Rights>();
            //var Added_Users_Exclusion_Rights = CompareLists<Users_Exclusion_Rights>(ExclusionRightsList.ToList<Users_Exclusion_Rights>(), objU.Users_Exclusion_Rights.ToList<Users_Exclusion_Rights>(), comparerExclusion_Rights, ref Deleted_Users_Exclusion_Rights, ref Updated_Users_Exclusion_Rights);
            //Added_Users_Exclusion_Rights.ToList<Users_Exclusion_Rights>().ForEach(t => objU.Users_Exclusion_Rights.Add(t));
            //Deleted_Users_Exclusion_Rights.ToList<Users_Exclusion_Rights>().ForEach(t => t.EntityState = State.Deleted);

            #endregion

            ICollection<Users_Configuration> UsersConfigurationList = new HashSet<Users_Configuration>();
            int Count = 0;
            foreach (var item in objFormCollection.AllKeys.ToList())
            {
                if (item.Contains("hdnDashboardConfigKey_"))
                {
                    Count = Count + 1;
                    Users_Configuration objUC = new Users_Configuration();
                    objUC.Dashboard_Key = objFormCollection["hdnDashboardConfigKey_" + Count];
                    objUC.Dashboard_Value = Convert.ToInt32(objFormCollection["txtDashboardValue_" + Count]);
                    objUC.EntityState = State.Added;
                    UsersConfigurationList.Add(objUC);
                }
            }
            IEqualityComparer<Users_Configuration> comparerUsersConfiguration = new LambdaComparer<Users_Configuration>((x, y) => x.Dashboard_Key == y.Dashboard_Key && x.Dashboard_Value == y.Dashboard_Value && x.EntityState != State.Deleted);
            var Deleted_Users_Configuration = new List<Users_Configuration>();
            var Updated_Users_Configuration = new List<Users_Configuration>();
            var Added_Users_Configuration = CompareLists<Users_Configuration>(UsersConfigurationList.ToList<Users_Configuration>(), objU.Users_Configuration.ToList<Users_Configuration>(), comparerUsersConfiguration, ref Deleted_Users_Configuration, ref Updated_Users_Configuration);
            Added_Users_Configuration.ToList<Users_Configuration>().ForEach(t => objU.Users_Configuration.Add(t));
            Deleted_Users_Configuration.ToList<Users_Configuration>().ForEach(t => t.EntityState = State.Deleted);

            bool valid = ObjUserService.Save(objU, out resultSet);
            if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) == 0 && valid)
            {
                #region -- Save password entry in user password details----------------------------
                Users_Password_Detail UPD = new Users_Password_Detail();
                UPD.EntityState = State.Added;
                UPD.Users_Code = objU.Users_Code;
                UPD.Users_Passwords = objU.Password;
                UPD.Password_Change_Date = DateTime.Now;
                new Users_Password_Detail_Service(objLoginEntity.ConnectionStringName).Save(UPD, out resultSet);

                #endregion

            }
            if (valid)
            {
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) > 0)
                {
                    Action = Convert.ToString(ActionType.U); // U = "Update";
                    message = objMessageKey.Recordupdatedsuccessfully;
                    //message = message.Replace("{ACTION}", "updated");
                }
                else
                {
                    //message = message.Replace("{ACTION}", "added");
                    message = objMessageKey.RecordAddedSuccessfully;
                    string IsLDAPAuthReq = ConfigurationManager.AppSettings["isLDAPAuthReqd"].ToString().Trim().ToUpper();
                    if (IsLDAPAuthReq == "N")
                    {
                        Mail(objU);
                    }
                    else
                    {
                        if (objU.IsProductionHouseUser == "Y")
                        {
                            Mail(objU);
                        }
                    }
                }
                FetchData();

                try
                {
                    objU.Created_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objU.Created_By));
                    objU.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objU.Last_Action_By));
                    objU.Default_Entity_Name = new Entity_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Entity_Code == objU.Default_Entity_Code).Select(x => x.Entity_Name).FirstOrDefault();
                    objU.Security_Group_Name = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Security_Group_Code == objU.Security_Group_Code).Select(x => x.Security_Group_Name).FirstOrDefault();
                    objU.Users_Business_Unit.ToList().ForEach(f => f.Business_Unit_name = new Business_Unit_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Business_Unit_Code)).Business_Unit_Name);
                    objU.Users_Detail.ToList().ForEach(f => f.Attrib_Group_name = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Attrib_Group_Code)).Attrib_Group_Name);

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objU);
                    //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForUsers), Convert.ToInt32(objU.Users_Code), LogData, Action, objLoginUser.Users_Code);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeForUsers;
                    objAuditLog.intCode = objU.Users_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objU.Last_Updated_Time));
                    objAuditLog.actionType = Action;
                    var strCheck = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().PostAuditLogAPI(objAuditLog, "");

                    var LogDetail = JsonConvert.DeserializeObject<JsonData>(strCheck);
                    if (Convert.ToString(LogDetail.ErrorMessage) == "Error")
                    {

                    }
                }
                catch (Exception ex)
                {

                }
            }
            else
            {
                status = "E";
                if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) > 0)
                    message = message.Replace("Record {ACTION} successfully", resultSet);
                else
                    message = message.Replace("Record {ACTION} successfully", resultSet);
            };

            var obj = new
            {
                RecordCount = lstUser.Count(),
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult, ref List<T> UPResult) where T : class
        {
            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);
            var UpdateResult = FirstList.Except(DeleteResult, comparer);
            var Modified_Result = UpdateResult.Except(AddResult);

            DelResult = DeleteResult.ToList<T>();
            UPResult = Modified_Result.ToList<T>();

            return AddResult.ToList<T>();
        }
        //public string generatePwd(string LoginName)
        //{
        //    string pwd = getEncrptedPass(LoginName).Trim();
        //    return pwd;
        //}
        public string generatePwd(string FirstName, string LastName)
        {
            string pwd = getEncrptedPass(FirstName, LastName).Trim();
            return pwd;
        }
        public static string getEncrptedPass(string FirstName, string LastName)
        {
            //long currentTime = Convert.ToInt64(GetDateComparisionNumber(DateTime.Now.ToString("s")));
            //string date = currentTime.ToString().Substring(8, 4);

            //if (Convert.ToInt32(date) % 2 == 0)
            //{
            //    date = ((date[0]) + date);
            //    date += date[2];
            //}
            //else
            //{
            //    date = ((date[1]) + date);
            //    date += date[3];
            //}

            //if (LoginName.Length < 2)
            //    LoginName = LoginName + '#';

            //string str = LoginName.Substring(0, 2).Trim() + date;

            //return str;
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
        public string getDatabaseEncryptedpassword(string normalStr = "")
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

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForUsers), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        public void Mail(RightsU_Entities.User objUser)
        {
            try
            {
                objUser.Password = generatePwd(objUser.First_Name, objUser.Last_Name);
                int IsMailSend = new USP_Service(objLoginEntity.ConnectionStringName).usp_GetUserEMail_Body(objUser.Login_Name, objUser.First_Name, objUser.Last_Name, objUser.Password, ConfigurationManager.AppSettings["isLDAPAuthReqd"].ToString().ToUpper(), ConfigurationManager.AppSettings["SiteAddress"].ToString(), ConfigurationManager.AppSettings["SystemName"].ToString(), "NP", objUser.Email_Id.Trim());
                //SendMail objModelMail = new SendMail();
                //objModelMail.ToEmailId = objUser.Email_Id;
                //objModelMail.FromEmailId = objLoginUser.Email_Id;
                //objModelMail.setMailAdd(objLoginUser.Email_Id, objUser.Email_Id);
                //objModelMail.MailSubject = "New User Created";

                //objModelMail.MailText = "Dear " + objUser.First_Name + " your User Name is " + objUser.Login_Name + " your password is " + objUser.Password;
                //objModelMail.FromEmailId = objLoginUser.Email_Id;
                //SmtpClient smtp = new SmtpClient();
                //smtp.Host = "smtp.gmail.com";
                //smtp.EnableSsl = true;
                //NetworkCredential networkCredential = new NetworkCredential(System.Configuration.ConfigurationManager.AppSettings["MailUid"], System.Configuration.ConfigurationManager.AppSettings["MailPwd"]);
                //smtp.Host = "localhost";
                //objModelMail.send();
            }
            catch (Exception e)
            {

            }


        }

    }
}

