using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;


namespace RightsU_Plus.Controllers
{
    public class PartyCategoryController : BaseController
    {
        private List<RightsU_Entities.Party_Category> lstPartyCategory
        {
            get
            {
                if (Session["lstPartyCategory"] == null)
                    Session["lstPartyCategory"] = new List<RightsU_Entities.Party_Category>();
                return (List<RightsU_Entities.Party_Category>)Session["lstPartyCategory"];
            }
            set { Session["lstPartyCategory"] = value; }
        }
        private List<RightsU_Entities.Party_Category> lstPartyCategory_Searched
        {
            get
            {
                if (Session["lstPartyCategory_Searched"] == null)
                    Session["lstPartyCategory_Searched"] = new List<RightsU_Entities.Party_Category>();
                return (List<RightsU_Entities.Party_Category>)Session["lstPartyCategory_Searched"];
            }
            set { Session["lstPartyCategory_Searched"] = value; }
        }
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForPartyCategory);
            string moduleCode = GlobalParams.ModuleCodeForPartyCategory.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstPartyCategory_Searched = lstPartyCategory = new Party_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/PartyCategory/Index.cshtml");
        }
        public  PartialViewResult BindPartyCategoryList(int pageNo, int recordPerPage, int partyCategoryCode, string CommandName, string SortType)
        {
            ViewBag.PartyCategoryCode = partyCategoryCode;
            ViewBag.CommandName = CommandName;
            List<RightsU_Entities.Party_Category> lst = new List<RightsU_Entities.Party_Category>();
            int RecordCount = 0;
            RecordCount = lstPartyCategory_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (SortType == "T")
                    lst = lstPartyCategory_Searched.OrderByDescending(o => o.Last_Updated_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (SortType == "NA")
                    lst = lstPartyCategory_Searched.OrderBy(o => o.Party_Category_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstPartyCategory_Searched.OrderByDescending(o => o.Party_Category_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/PartyCategory/_PartyCategoryList.cshtml",lst);
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForPartyCategory), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        public JsonResult CheckRecordLock(int partyCategoryCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (partyCategoryCode > 0)
            {
                isLocked = DBUtil.Lock_Record(partyCategoryCode, GlobalParams.ModuleCodeForPartyCategory, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
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
        public JsonResult SearchPartyCategory(string searchText)
        {
            Party_Category_Service objService = new Party_Category_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                lstPartyCategory_Searched = lstPartyCategory.Where(w => w.Party_Category_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstPartyCategory_Searched = lstPartyCategory;


            var obj = new
            {
                Record_Count = lstPartyCategory_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactivePartyCategory(int partyCategoryCode, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(partyCategoryCode, GlobalParams.ModuleCodeForPartyCategory, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                Party_Category_Service objService = new Party_Category_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Party_Category objPartyCategory = objService.GetById(partyCategoryCode);
                objPartyCategory.Is_Active = doActive;
                objPartyCategory.EntityState = State.Modified;
                dynamic resultSet;

                bool isValid = objService.Save(objPartyCategory, out resultSet);
                if (isValid)
                {
                    lstPartyCategory.Where(w => w.Party_Category_Code == partyCategoryCode).First().Is_Active = doActive;
                    lstPartyCategory_Searched.Where(w => w.Party_Category_Code == partyCategoryCode).First().Is_Active = doActive;
                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
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
        public JsonResult SavePartyCategory(int PartyCategoryCode, string PartyCategoryName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (PartyCategoryCode > 0)
            {
                message = objMessageKey.Recordupdatedsuccessfully;
            }
            Party_Category_Service objService = new Party_Category_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Party_Category objPartyCategory = null;

            if (PartyCategoryCode > 0)
            {
                objPartyCategory = objService.GetById(PartyCategoryCode);
                objPartyCategory.EntityState = State.Modified;
            }
            else
            {
                objPartyCategory = new RightsU_Entities.Party_Category();              
                objPartyCategory.EntityState = State.Added;
                objPartyCategory.Inserted_By = objLoginUser.Users_Code;
                objPartyCategory.Inserted_On = DateTime.Now;
            }
            objPartyCategory.Party_Category_Name = PartyCategoryName;
            objPartyCategory.Is_Active = "Y";
            objPartyCategory.Last_Updated_On = DateTime.Now;
            objPartyCategory.Last_Updated_By = objLoginUser.Users_Code;
            dynamic resultSet;

            bool isValid = objService.Save(objPartyCategory, out resultSet);
            if (isValid)
            {
                lstPartyCategory_Searched = lstPartyCategory = objService.SearchFor(w => true).OrderByDescending(x => x.Last_Updated_On).ToList();
            }
            else
            {
                status = "E";
                message = resultSet;
            }   
                    
            int recordLockingCode = Convert.ToInt32(Record_Code);
            DBUtil.Release_Record(recordLockingCode);
            var obj = new
            {
                RecordCount = lstPartyCategory_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        
    }
}
