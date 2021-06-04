
using RightsU_Dapper.BLL.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Dapper.Entity;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class IPR_CountryController : BaseController
    {
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();
        private readonly IPR_Country_Service objIPRCountryService = new IPR_Country_Service();

        #region --- Properties ---
        private List<RightsU_Dapper.Entity.IPR_Country> lstIPR_Country
        {
            get
            {
                if (Session["lstIPR_Country"] == null)
                    Session["lstIPR_Country"] = new List<RightsU_Dapper.Entity.IPR_Country>();
                return (List<RightsU_Dapper.Entity.IPR_Country>)Session["lstIPR_Country"];
            }
            set { Session["lstIPR_Country"] = value; }
        }

        private List<RightsU_Dapper.Entity.IPR_Country> lstIPR_Country_Searched
        {
            get
            {
                if (Session["lstIPR_Country_Searched"] == null)
                    Session["lstIPR_Country_Searched"] = new List<RightsU_Dapper.Entity.IPR_Country>();
                return (List<RightsU_Dapper.Entity.IPR_Country>)Session["lstIPR_Country_Searched"];
            }
            set { Session["lstIPR_Country_Searched"] = value; }
        }

        #endregion

        public ViewResult Index()
        {
            lstIPR_Country_Searched = lstIPR_Country = objIPRCountryService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/IPR_Country/Index.cshtml");
        }

        public PartialViewResult BindIPR_CountryList(int pageNo, int recordPerPage)
        {
            List<RightsU_Dapper.Entity.IPR_Country> lst = new List<RightsU_Dapper.Entity.IPR_Country>();
            int RecordCount = 0;
            RecordCount = lstIPR_Country_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstIPR_Country_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/IPR_Country/_IPR_CountryList.cshtml", lst);
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
        private string GetUserModuleRights()
        {
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeFor_IPR_Country), objLoginUser.Security_Group_Code,objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        #endregion

        public JsonResult CheckRecordLock(int IPR_CountryCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (IPR_CountryCode > 0)
            {
                isLocked = DBUtil.Lock_Record(IPR_CountryCode, GlobalParams.ModuleCodeFor_IPR_Country, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }


        public JsonResult SearchIPR_Country(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstIPR_Country_Searched = lstIPR_Country.Where(w => w.IPR_Country_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstIPR_Country_Searched = lstIPR_Country;

            var obj = new
            {
                Record_Count = lstIPR_Country_Searched.Count
            };
            return Json(obj);
        }

        #region --- CRUD Method ---

        public JsonResult ActiveDeactiveIPR_Country(int IPR_CountryCode, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(IPR_CountryCode, GlobalParams.ModuleCodeFor_IPR_Country, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {

                //IPR_Country_Service objService = new IPR_Country_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.IPR_Country objIPR_Country = objIPRCountryService.GetByID(IPR_CountryCode);
                objIPR_Country.Is_Active = doActive;
                //objIPR_Country.EntityState = State.Modified;
                dynamic resultSet;
                objIPRCountryService.AddEntity(objIPR_Country);
                bool isValid = true;// objService.Save(objIPR_Country, out resultSet);
                if (isValid)
                {
                    lstIPR_Country.Where(w => w.IPR_Country_Code == IPR_CountryCode).First().Is_Active = doActive;
                    lstIPR_Country_Searched.Where(w => w.IPR_Country_Code == IPR_CountryCode).First().Is_Active = doActive;
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }
                if (doActive == "Y")
                    message = message.Replace("{ACTION}", "Activated");
                else
                    message = message.Replace("{ACTION}", "Deactivated");

                DBUtil.Release_Record(RLCode);
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

        public JsonResult AddEditIPR_CountryList(int IPR_CountryCode, string commandName)
        {
            string status = "S", message = "Record {ACTION} successfully";
            if (commandName == "ADD")
            {
                TempData["Action"] = "AddIPR_Country";
            }
            else if (commandName == "EDIT")
            {
                //IPR_Country_Service objService = new IPR_Country_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.IPR_Country objIPR_Country = objIPRCountryService.GetByID(IPR_CountryCode);
                TempData["Action"] = "EditIPR_Country";
                TempData["idIPR_Country"] = objIPR_Country.IPR_Country_Code;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveUpdateIPR_CountryList(FormCollection objFormCollection)
        {
            int IPR_CountryCode = Convert.ToInt32(objFormCollection["IPR_CountryCode"]);
            string status = "S", message = "Record {ACTION} successfully";
            //IPR_Country_Service objService = new IPR_Country_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.IPR_Country objIPR_Country = new RightsU_Dapper.Entity.IPR_Country();
            if (IPR_CountryCode != 0)
            {
                string str_IPR_Country_Name = objFormCollection["IPR_Country_Name"].ToString().Trim();
                objIPR_Country = objIPRCountryService.GetByID(IPR_CountryCode);
                objIPR_Country.IPR_Country_Name = str_IPR_Country_Name;
                objIPR_Country.Last_Action_By = objLoginUser.Users_Code;
                //objIPR_Country.EntityState = State.Modified;
            }
            else
            {
                string str_IPR_Country_Name = objFormCollection["IPR_Country_Name"].ToString().Trim();
                objIPR_Country = new RightsU_Dapper.Entity.IPR_Country();
                objIPR_Country.Is_Active = "Y";
                objIPR_Country.IPR_Country_Name = str_IPR_Country_Name;
                objIPR_Country.Inserted_By = objLoginUser.Users_Code;
                objIPR_Country.Inserted_On = System.DateTime.Now;
               // objIPR_Country.EntityState = State.Added;
            }
            objIPR_Country.Last_Updated_Time = System.DateTime.Now;
            string resultSet;
            bool isDuplicate = objIPRCountryService.Validate(objIPR_Country, out resultSet);
            
            if (isDuplicate)
            {
                objIPRCountryService.AddEntity(objIPR_Country);
                bool isValid = true;// objService.Save(objIPR_Country, out resultSet);
                if (isValid)
                {
                    lstIPR_Country_Searched = lstIPR_Country = objIPRCountryService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();
                    if (IPR_CountryCode > 0)
                        message = message.Replace("{ACTION}", "updated");
                    else
                        message = message.Replace("{ACTION}", "added");

                    //if (objIPR_Country.EntityState == State.Modified)
                    //{
                         int Record_Code =  Convert.ToInt32(objFormCollection["Record_Code"]);
                         if (Record_Code > 0)
                         {
                             int recordLockingCode = Convert.ToInt32(Record_Code);
                             DBUtil.Release_Record(recordLockingCode);
                         }
                    //}  
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion
    }
}
