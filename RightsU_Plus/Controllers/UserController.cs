using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Dapper.Entity;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Web.Mail;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using System.Configuration;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity;

namespace RightsU_Plus.Controllers
{
    public class UserController : BaseController
    {
        private readonly Security_Group_Service objSecurityGroupService = new Security_Group_Service();
        private readonly Security_Group_Rel_Service objSecurityGroupRelService = new Security_Group_Rel_Service();
        private readonly User_Service objUserService = new User_Service();
        private readonly Users_Exclusive_Rights_Service objUsersExclusiveRightsService = new Users_Exclusive_Rights_Service();
        private readonly Vendor_Service objVendorService = new Vendor_Service();
        private readonly System_Parameter_NewService objSPNService = new System_Parameter_NewService();
        private readonly Business_Unit_Service objBUService = new Business_Unit_Service();
        private readonly Users_Password_Detail_Service objUsersPasswordDetailService = new Users_Password_Detail_Service();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();



        #region --- Properties ---
        private List<RightsU_Dapper.Entity.User> lstUser
        {
            get
            {
                if (Session["lstUser"] == null)
                    Session["lstUser"] = new List<RightsU_Dapper.Entity.User>();
                return (List<RightsU_Dapper.Entity.User>)Session["lstUser"];
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

        private List<RightsU_Dapper.Entity.User> lstUser_Searched
        {
            get
            {
                if (Session["lstUser_Searched"] == null)
                    Session["lstUser_Searched"] = new List<RightsU_Dapper.Entity.User>();
                return (List<RightsU_Dapper.Entity.User>)Session["lstUser_Searched"];
            }
            set { Session["lstUser_Searched"] = value; }
        }
        Type[] RelationList = new Type[] { typeof(Users_Channel),
                        typeof(Users_Configuration),
                        typeof(Users_Detail),
                        typeof(Users_Entity),
                        typeof(Users_Password_Detail),
                        typeof(Users_Business_Unit)
                       
            };
        #endregion

        public ViewResult Index()
        {
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForUsers.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            //lstUser_Searched = lstUser = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
            lstUser_Searched = lstUser = objUserService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();
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

            //var SecurityGroupCodes = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(x => x.Security_Group_Code).ToArray();
            var SecurityGroupCodes = objUserService.GetAll().Select(x => x.Security_Group_Code).ToArray();

           // var lstSecurityGroup = new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => (SecurityGroupCodes.Contains(x.Security_Group_Code))).ToList();
            var lstSecurityGroup = objSecurityGroupService.GetList().Where(x => (SecurityGroupCodes.Contains(x.Security_Group_Code))).ToList();
            ViewBag.SecGroup = new SelectList(lstSecurityGroup, "Security_Group_Code", "Security_Group_Name");

            //var lstProductionRoleVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y"
            //    && s.Vendor_Role.Where(x => x.Role_Code == 9).Count() > 0).ToList();
            var lstProductionRoleVendor = objVendorService.GetAll().Where(s => s.Is_Active == "Y"
                && s.Vendor_Role.Where(x => x.Role_Code == 9).Count() > 0).ToList();
            // int? Vendor_Code = objLoginUser.MHUsers.Select(s => s.Vendor_Code).FirstOrDefault();
            ViewBag.Vendor = new SelectList(lstProductionRoleVendor, "Vendor_Code", "Vendor_Name");
            Session["VendorData"] = lstProductionRoleVendor;


            string AllowUSer = objSPNService.GetList().Where(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
            ViewBag.AllowUSer = AllowUSer;
            FetchData();
            return View("~/Views/User/Index.cshtml");
        }

        public ActionResult ViewProfile(FormCollection objFormCollection)
        {
            int UserCode = Convert.ToInt32(objFormCollection["userCode"]);
            RightsU_Dapper.Entity.User objUser = FillUser(UserCode);
            ViewBag.FullName = objUser.Full_Name;
            return View("~/Views/User/ViewProfile.cshtml", objUser);
        }
        public ActionResult ViewUserProfiles()
        {
            int UserCode = objLoginUser.Users_Code;
            RightsU_Dapper.Entity.User objUser = FillUser(UserCode);
            ViewBag.FullName = objUser.Full_Name;
            return View("~/Views/User/ViewProfile.cshtml", objUser);
        }

        public User FillUser(int userCode)
        {
            RightsU_Dapper.Entity.User objUser = objUserService.GetByID(userCode, RelationList);
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
            //User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.User objUse = objUserService.GetByID(hdnUserCode, RelationList);
            string filename = DateTime.Now.Ticks.ToString() + "_";
            filename += file.FileName;
            if (filename != "" && file.FileName != "")
            {
                file.SaveAs(Server.MapPath(System.Configuration.ConfigurationManager.AppSettings["TitleImagePath"] + filename));
                objUse.User_Image = filename;
            }
            //objUse.EntityState = State.Modified;
            //objService.Save(objUse);
            objUserService.AddEntity(objUse);
            RightsU_Dapper.Entity.User objUser = FillUser(hdnUserCode);
            ViewBag.FullName = objUser.Full_Name;
            return View("~/Views/User/ViewProfile.cshtml", objUser);
        }

        public PartialViewResult BindUserList(int pageNo, int recordPerPage, string sortType, string searchIsLDAPUser = "", int vendorCode = 0)
        {
            List<RightsU_Dapper.Entity.User> lst = new List<RightsU_Dapper.Entity.User>();
            int RecordCount = 0;

            string AllowUSer = objSPNService.GetList().Where(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
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
            var paramValue = objSPNService.GetList().Where(s => s.Parameter_Name == "Is_Allow_Multilanguage").Select(x => x.Parameter_Value).SingleOrDefault();
            ViewBag.parmValue = paramValue;
            //User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.User objUser = null;

            if (UserCode > 0)
            {
                objUser = objUserService.GetByID(UserCode, RelationList);
            }
            else
                objUser = new RightsU_Dapper.Entity.User();

            //ViewBag.SecurityGroup = new SelectList(new Security_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Security_Group_Code", "Security_Group_Name", objUser.Security_Group_Code);
            ViewBag.SecurityGroup = new SelectList(objSecurityGroupService.GetList(), "Security_Group_Code", "Security_Group_Name", objUser.Security_Group_Code);

            List<RightsU_Entities.System_Language> lstSystemLanguage = new RightsU_BLL.System_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList();
            int systemLanguageCode = (lstSystemLanguage.Where(w => w.Is_Default == "Y").First() ?? new RightsU_Entities.System_Language()).System_Language_Code;
            if (UserCode > 0)
            {
                systemLanguageCode = (objUser.System_Language_Code ?? systemLanguageCode);
            }
            else
            {
                systemLanguageCode = 0;
            }
            ViewBag.Language = new SelectList(lstSystemLanguage, "System_Language_Code", "Language_Name", systemLanguageCode);

            //List<Business_Unit> lstBusinessUnit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).OrderBy(o => o.Business_Unit_Name).ToList();
            List<Business_Unit> lstBusinessUnit = objBUService.GetAll().OrderBy(o => o.Business_Unit_Name).ToList();
            var businessUnitCodes = objUser.Users_Business_Unit.Select(s => s.Business_Unit_Code).ToArray();
            ViewBag.BusinessUnitList = new MultiSelectList(lstBusinessUnit, "Business_Unit_Code", "Business_Unit_Name", businessUnitCodes);

            List<RightsU_Dapper.Entity.Vendor> lstProductionRoleVendor = (List<RightsU_Dapper.Entity.Vendor>)Session["VendorData"];
            int? Vendor_Code = objUser.MHUsers.Select(s => s.Vendor_Code).FirstOrDefault();
            ViewBag.Vendor = new SelectList(lstProductionRoleVendor, "Vendor_Code", "Vendor_Name", Vendor_Code);
            ViewBag.Vendor_Code = Vendor_Code;

            string AllowUSer = objSPNService.GetList().Where(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
            ViewBag.AllowUSer = AllowUSer;
            ViewBag.TabName = TabName;

            List<RightsU_Dapper.Entity.System_Parameter_New> lstsys = new List<RightsU_Dapper.Entity.System_Parameter_New>();
            lstsys = objSPNService.GetList().Where(w => w.Type == "U").OrderBy(o => o.Parameter_Name).ToList();
            List<RightsU_Entities.Email_Config> lstEmailConfig = new List<RightsU_Entities.Email_Config>();
            lstEmailConfig = new RightsU_BLL.Email_Config_Detail_User_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.User_Codes.Contains(objUser.Users_Code.ToString()) || w.CC_Users.Contains(objUser.Users_Code.ToString())
                || w.BCC_Users.Contains(objUser.Users_Code.ToString()) || w.ToUser_MailID.Contains(objUser.Email_Id) || w.CCUser_MailID.Contains(objUser.Email_Id) || w.BCCUser_MailID.Contains(objUser.Email_Id))
                .Select(s => s.Email_Config_Detail.Email_Config).Distinct().ToList();
            ViewBag.SystemParamList = lstsys;
            ViewBag.EmailConfigList = lstEmailConfig;
            objUser.Users_Code = UserCode;
            return PartialView("~/Views/User/_UserGeneralInfo.cshtml", objUser);
        }
        public PartialViewResult BindUSerSecurityGroup(int? SecurityGroupCode, int UsersCode)
        {
            //string[] strUserModule_Right_Code = new Users_Exclusion_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == UsersCode).ToList().Select(s => s.Module_Right_Code.ToString()).ToArray();
            string[] strUserModule_Right_Code = objUsersExclusiveRightsService.GetAll().Where(w => w.Users_Code == UsersCode).ToList().Select(s => s.Module_Right_Code.ToString()).ToArray();

            string[] strModule_right_Code = objSecurityGroupRelService.GetAll().Where(x => x.Security_Group_Code == SecurityGroupCode).ToList().Select(x => Convert.ToString(x.System_Module_Rights_Code)).ToArray();
            string Module_right_Code = string.Join(",", objSecurityGroupRelService.GetAll().Where(x => x.Security_Group_Code == SecurityGroupCode).ToList().Select(x => Convert.ToString(x.System_Module_Rights_Code)));
            var strExceptRightsCode = strModule_right_Code.Except(strUserModule_Right_Code);
            string strUserExceptionRights = string.Join(",", strExceptRightsCode);
           RightsU_BLL.User_Security_Tree_View objST = new RightsU_BLL.User_Security_Tree_View(objLoginEntity.ConnectionStringName);
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
            lstUser_Searched = lstUser = objUserService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();

        }
        #endregion

        public JsonResult SearchUser(string searchText, string searchIsLDAPUser = "", int vendorCode = 0, string status = "", int secGroupCode = 0)
        {
            string AllowUSer = objSPNService.GetList().Where(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
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
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(userCode, GlobalParams.ModuleCodeForUsers, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);

            if (isLocked)
            {
                //User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.User objUser = objUserService.GetByID(userCode, RelationList);
                objUser.Is_Active = doActive;
                objUser.Validate_Email = false;
                //objUser.EntityState = State.Modified;
                dynamic resultSet;
                objUserService.AddEntity(objUser);
                bool isValid = true;// objService.Save(objUser, out resultSet);
                if (isValid)
                {
                    lstUser.Where(w => w.Users_Code == userCode).First().Is_Active = doActive;
                    lstUser_Searched.Where(w => w.Users_Code == userCode).First().Is_Active = doActive;

                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Activated");
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Deactivated");
                }
                else
                {
                    message = "";
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
        //        RightsU_Dapper.Entity.User objUser = objService.GetById(userCode);
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
            string status = "S", message = "";
            //User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.User objUser = objUserService.GetByID(userCode, RelationList);
            objUser.Password_Fail_Count = 0;
            objUser.Last_Updated_Time = DateTime.Now;
            objUser.Last_Action_By = objLoginUser.Users_Code;
            objUser.Validate_Email = false;
            //objUser.EntityState = State.Modified;

            dynamic resultSet;
            objUserService.AddEntity(objUser);
            bool isvalid = true;// objService.Save(objUser, out resultSet);
            if (isvalid)
            {
                FetchData();
                message = objMessageKey.UserUnlockedSuccessfully;
            }
            else
            {
                message = "";
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
           // User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.User objUser = null;

            if (UserCode > 0)
            {
                objUser = objUserService.GetByID(UserCode, RelationList);
            }
            else
                objUser = new RightsU_Dapper.Entity.User();
            objUser.Users_Code = UserCode;
            ViewBag.SecurityGroup = new SelectList(objSecurityGroupService.GetList(), "Security_Group_Code", "Security_Group_Name");

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

            //List<RightsU_Dapper.Entity.Vendor> lstProductionRoleVendor = (List<RightsU_Dapper.Entity.Vendor>)Session["VendorData"];
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
           // User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.User objUser = objUserService.GetByID(UserCode, RelationList);
            string pwd = "", Message = "";
            pwd = generatePwd(objUser.First_Name, objUser.Last_Name);
            objUser.Password = getDatabaseEncryptedpassword(pwd);
            //objUser.EntityState = State.Modified;
            objUser.Is_System_Password = "Y";
            objUser.Password_Fail_Count = 0;
            dynamic resultSet;
            objUserService.AddEntity(objUser);
            bool isValid = true;// objService.Save(objUser, out resultSet);

            if (isValid)
            {
                Message = objMessageKey.PasswordResetsSuccessfully;
            }
            else
            {
                Message = "";
            }
            var obj = new
            {
                Message = Message,
                Password = pwd
            };
            return Json(obj);
        }

        [HttpPost]
        public ActionResult SaveUser(RightsU_Dapper.Entity.User objUser_MVC, FormCollection objFormCollection)
        {

            User objU = new User();
            //User_Service ObjUserService = new User_Service(objLoginEntity.ConnectionStringName);
            if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) > 0)
            {
                objU = objUserService.GetByID(Convert.ToInt32(objFormCollection["hdnUsers_Code"]), RelationList);
                objU.Last_Action_By = objLoginUser.Users_Code;
                //objU.EntityState = State.Modified;
            }
            else
            {
                string password = "";
                //password = generatePwd(objUser_MVC.Login_Name);
                password = generatePwd(objUser_MVC.First_Name, objUser_MVC.Last_Name);
                objU.Password = getDatabaseEncryptedpassword(password);
               // objU.EntityState = State.Added;
                objU.Is_Active = "Y";
                objU.Is_System_Password = "Y";
                objU.Password_Fail_Count = 0;
            }
            objU.Security_Group_Code = objUser_MVC.Security_Group_Code;
            objU.Login_Name = objUser_MVC.Login_Name;
            objU.First_Name = objUser_MVC.First_Name;
            objU.Last_Name = objUser_MVC.Last_Name;
            objU.Middle_Name = objUser_MVC.Middle_Name;
            if (objUser_MVC.System_Language_Code == null)
                objU.System_Language_Code = new RightsU_BLL.System_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Is_Default == "Y").Select(x => x.System_Language_Code).SingleOrDefault();
            else
                objU.System_Language_Code = objUser_MVC.System_Language_Code;
            objU.Validate_Email = true;
            objU.Email_Id = objUser_MVC.Email_Id;
            objU.Last_Updated_Time = DateTime.Now;
            objU.Default_Entity_Code = objLoginUser.Default_Entity_Code;
            string AllowUSer = objSPNService.GetList().Where(s => s.Parameter_Name == "allow_domain_nondomain").Select(s => s.Parameter_Value).FirstOrDefault();
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
            objU.Created_By = objLoginUser.Users_Code;

            string resultSet;
            string status = "S", message = "Record {ACTION} successfully";

            ICollection<Users_Business_Unit> BuisnessUnitList = new HashSet<Users_Business_Unit>();
            if (objFormCollection["ddlBusinessUnit"] != null)
            {
                string[] arrBuisnessCode = objFormCollection["ddlBusinessUnit"].Split(',');
                foreach (string BuisnessUnitCode in arrBuisnessCode)
                {
                    Users_Business_Unit objTR = new Users_Business_Unit();
                    //objTR.EntityState = State.Added;
                    objTR.Business_Unit_Code = Convert.ToInt32(BuisnessUnitCode);
                    BuisnessUnitList.Add(objTR);
                }
            }

            IEqualityComparer<Users_Business_Unit> comparerBuisness_Unit = new RightsU_BLL.LambdaComparer<Users_Business_Unit>((x, y) => x.Business_Unit_Code == y.Business_Unit_Code);
            var Deleted_Users_Business_Unit = new List<Users_Business_Unit>();
            var Updated_Users_Business_Unit = new List<Users_Business_Unit>();
            var Added_Users_Business_Unit = CompareLists<Users_Business_Unit>(BuisnessUnitList.ToList<Users_Business_Unit>(), objU.Users_Business_Unit.ToList<Users_Business_Unit>(), comparerBuisness_Unit, ref Deleted_Users_Business_Unit, ref Updated_Users_Business_Unit);
            Added_Users_Business_Unit.ToList<Users_Business_Unit>().ForEach(t => objU.Users_Business_Unit.Add(t));
            Deleted_Users_Business_Unit.ToList<Users_Business_Unit>().ForEach(t => objU.Users_Business_Unit.Remove(t));

            ICollection<RightsU_Entities.MHUser> MHUser = new HashSet<RightsU_Entities.MHUser>();
            if (objFormCollection["ddlVendors"] != null)
            {
                string Vendor_Code = objFormCollection["ddlVendors"];
                RightsU_Entities.MHUser objMHUSer = new RightsU_Entities.MHUser();
                objMHUSer.Vendor_Code = Convert.ToInt32(Vendor_Code);
                //objMHUSer.EntityState = State.Added;
                MHUser.Add(objMHUSer);
            }

            IEqualityComparer<RightsU_Entities.MHUser> compareMHUSer = new RightsU_BLL.LambdaComparer<RightsU_Entities.MHUser>((x, y) => x.Vendor_Code == y.Vendor_Code );
            var Deleted_MHUser = new List<RightsU_Entities.MHUser>();
            var Updated_MHUser = new List<RightsU_Entities.MHUser>();
            var Added_MHUSer = CompareLists<RightsU_Entities.MHUser>(MHUser.ToList<RightsU_Entities.MHUser>(), objU.MHUsers.ToList<RightsU_Entities.MHUser>(), compareMHUSer, ref Deleted_MHUser, ref Updated_MHUser);
            Added_MHUSer.ToList<RightsU_Entities.MHUser>().ForEach(t => objU.MHUsers.Add(t));
            Deleted_MHUser.ToList<RightsU_Entities.MHUser>().ForEach(t => objU.MHUsers.Remove(t));

            ICollection<Users_Exclusion_Rights> ExclusionRightsList = new HashSet<Users_Exclusion_Rights>();
            if (objFormCollection["hdnTvCodes"] != null)
            {
                string[] arrUsersSystemRights = objFormCollection["hdnTvCodes"].Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                string strModule_right_Code = string.Join(",",objSecurityGroupRelService.GetAll().Where(x => x.Security_Group_Code == objU.Security_Group_Code).ToList().Select(x => Convert.ToString(x.System_Module_Rights_Code)));
                string[] arrSystemRights = strModule_right_Code.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                var ExceptsystemRights = arrSystemRights.Except(arrUsersSystemRights);
                foreach (string SystemRightsCode in ExceptsystemRights)
                {
                    if (SystemRightsCode != "0")
                    {
                        Users_Exclusion_Rights objTR = new Users_Exclusion_Rights();
                        //objTR.EntityState = State.Added;
                        objTR.Module_Right_Code = Convert.ToInt32(SystemRightsCode);
                        ExclusionRightsList.Add(objTR);
                    }
                }
            }
            IEqualityComparer<Users_Exclusion_Rights> comparerExclusion_Rights = new RightsU_BLL.LambdaComparer<Users_Exclusion_Rights>((x, y) => x.Module_Right_Code == y.Module_Right_Code);
            var Deleted_Users_Exclusion_Rights = new List<Users_Exclusion_Rights>();
            var Updated_Users_Exclusion_Rights = new List<Users_Exclusion_Rights>();
            var Added_Users_Exclusion_Rights = CompareLists<Users_Exclusion_Rights>(ExclusionRightsList.ToList<Users_Exclusion_Rights>(), objU.Users_Exclusion_Rights.ToList<Users_Exclusion_Rights>(), comparerExclusion_Rights, ref Deleted_Users_Exclusion_Rights, ref Updated_Users_Exclusion_Rights);
            Added_Users_Exclusion_Rights.ToList<Users_Exclusion_Rights>().ForEach(t => objU.Users_Exclusion_Rights.Add(t));
            Deleted_Users_Exclusion_Rights.ToList<Users_Exclusion_Rights>().ForEach(t => objU.Users_Exclusion_Rights.Remove(t));

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
                    //objUC.EntityState = State.Added;
                    UsersConfigurationList.Add(objUC);
                }
            }
            IEqualityComparer<Users_Configuration> comparerUsersConfiguration = new RightsU_BLL.LambdaComparer<Users_Configuration>((x, y) => x.Dashboard_Key == y.Dashboard_Key && x.Dashboard_Value == y.Dashboard_Value);
            var Deleted_Users_Configuration = new List<Users_Configuration>();
            var Updated_Users_Configuration = new List<Users_Configuration>();
            var Added_Users_Configuration = CompareLists<Users_Configuration>(UsersConfigurationList.ToList<Users_Configuration>(), objU.Users_Configuration.ToList<Users_Configuration>(), comparerUsersConfiguration, ref Deleted_Users_Configuration, ref Updated_Users_Configuration);
            Added_Users_Configuration.ToList<Users_Configuration>().ForEach(t => objU.Users_Configuration.Add(t));
            Deleted_Users_Configuration.ToList<Users_Configuration>().ForEach(t => objU.Users_Configuration.Remove(t));
            
            bool isDuplicate = objUserService.Validate(objU, out resultSet);
            if (isDuplicate)
            {
                objUserService.AddEntity(objU);
                if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) > 0)
                    message = objMessageKey.Recordupdatedsuccessfully;
                else
                    message = objMessageKey.RecordAddedSuccessfully;

                }
            else
            {
                status = "E";
                message = resultSet;
            }
            
            bool valid = true;//ObjUserService.Save(objU, out resultSet);
            if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) == 0 && valid)
            {
                #region -- Save password entry in user password details----------------------------
                Users_Password_Detail UPD = new Users_Password_Detail();
                //UPD.EntityState = State.Added;
                UPD.Users_Code = objU.Users_Code;
                UPD.Users_Passwords = objU.Password;
                UPD.Password_Change_Date = DateTime.Now;
                objUsersPasswordDetailService.AddEntity(UPD);
                //new Users_Password_Detail_Service(objLoginEntity.ConnectionStringName).Save(UPD, out resultSet);

                #endregion

            }
            if (valid)
            {
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                //if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) > 0)
                //{
                //    message = objMessageKey.Recordupdatedsuccessfully;
                //    //message = message.Replace("{ACTION}", "updated");
                //}
                if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) <= 0)
                {
                    //message = message.Replace("{ACTION}", "added");
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
            }
            else
            {
                status = "E";
                if (Convert.ToInt32(objFormCollection["hdnUsers_Code"]) > 0)
                    message = message.Replace("Record {ACTION} successfully", "");
                else
                    message = message.Replace("Record {ACTION} successfully", "");
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
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForUsers), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public void Mail(RightsU_Dapper.Entity.User objUser)
        {
            try
            {
                objUser.Password = generatePwd(objUser.First_Name, objUser.Last_Name);
                int IsMailSend = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName).usp_GetUserEMail_Body(objUser.Login_Name, objUser.First_Name, objUser.Last_Name, objUser.Password, ConfigurationManager.AppSettings["isLDAPAuthReqd"].ToString().ToUpper(), ConfigurationManager.AppSettings["SiteAddress"].ToString(), ConfigurationManager.AppSettings["SystemName"].ToString(), "NP", objUser.Email_Id.Trim());
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

