using RightsU_BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Objection_TypeController : BaseController
    {
        #region --Properties--
        private List<RightsU_Entities.Title_Objection_Type> lstObjectionType
        {
            get
            {
                if (Session["lstObjectionType"] == null)
                    Session["lstObjectionType"] = new List<RightsU_Entities.Title_Objection_Type>();
                return (List<RightsU_Entities.Title_Objection_Type>)Session["lstObjectionType"];
            }
            set { Session["lstObjectionType"] = value; }
        }

        private List<RightsU_Entities.Title_Objection_Type> lstObjectionType_Searched
        {
            get
            {
                if (Session["lstObjectionType_Searched"] == null)
                    Session["lstObjectionType_Searched"] = new List<RightsU_Entities.Title_Objection_Type>();
                return (List<RightsU_Entities.Title_Objection_Type>)Session["lstObjectionType_Searched"];
            }
            set { Session["lstObjectionType_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForObjectionType);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForObjectionType.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstObjectionType_Searched = lstObjectionType = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Objection Type Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Objection Type Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Title_Objection_Type/Index.cshtml");
        }

        public PartialViewResult BindObjection_TypeList(int pageNo, int recordPerPage, int Objection_TypeCode, string commandName, string sortType)
        {
            ViewBag.Objection_Type_Code = Objection_TypeCode;
            ViewBag.CommandName = commandName;
            List<RightsU_Entities.Title_Objection_Type> lst = new List<RightsU_Entities.Title_Objection_Type>();
            int RecordCount = 0;
            RecordCount = lstObjectionType_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstObjectionType_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstObjectionType_Searched.OrderBy(o => o.Objection_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstObjectionType_Searched.OrderByDescending(o => o.Objection_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Title_Objection_Type/_ObjectionTypeList.cshtml", lst);
        }
        #region --Other Method--
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForObjectionType), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        #endregion
        public JsonResult CheckRecordLock(int Objection_TypeCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Objection_TypeCode > 0)
            {
                isLocked = DBUtil.Lock_Record(Objection_TypeCode, GlobalParams.ModuleCodeForObjectionType, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SearchObjection_TypeCode(string searchText)
        {
            Title_Objection_Type_Service objService = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                lstObjectionType_Searched = lstObjectionType.Where(w => w.Objection_Type_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstObjectionType_Searched = lstObjectionType;


            var obj = new
            {
                Record_Count = lstObjectionType_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactiveObjection_TypeCode(int Objection_Type_Code, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(Objection_Type_Code, GlobalParams.ModuleCodeForObjectionType, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                Title_Objection_Type_Service objService = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Title_Objection_Type objObjectionType = objService.GetById(Objection_Type_Code);
                objObjectionType.Is_Active = doActive;
                objObjectionType.EntityState = State.Modified;
                dynamic resultSet;

                bool isValid = objService.Save(objObjectionType, out resultSet);
                if (isValid)
                {
                    lstObjectionType.Where(w => w.Objection_Type_Code == Objection_Type_Code).First().Is_Active = doActive;
                    lstObjectionType_Searched.Where(w => w.Objection_Type_Code == Objection_Type_Code).First().Is_Active = doActive;
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
        public JsonResult SaveObjectionType(int ObjectionTypeCode, string ObjectionTypeName, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (ObjectionTypeCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            Title_Objection_Type_Service objService = new Title_Objection_Type_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Title_Objection_Type objObjectionType = null;

            if (ObjectionTypeCode > 0)
            {
                objObjectionType = objService.GetById(ObjectionTypeCode);
                objObjectionType.EntityState = State.Modified;
            }
            else
            {
                objObjectionType = new RightsU_Entities.Title_Objection_Type();
                objObjectionType.EntityState = State.Added;
                objObjectionType.Inserted_On = DateTime.Now;
                objObjectionType.Inserted_By = objLoginUser.Users_Code;
            }

            objObjectionType.Last_Updated_Time = DateTime.Now;
            objObjectionType.Last_Action_By = objLoginUser.Users_Code;
            objObjectionType.Is_Active = "Y";
            objObjectionType.Objection_Type_Name = ObjectionTypeName;
            dynamic resultSet;
            bool isValid = objService.Save(objObjectionType, out resultSet);

            if (isValid)
            {
                lstObjectionType_Searched = lstObjectionType = objService.SearchFor(s => true).OrderByDescending(x => x.Last_Updated_Time).ToList();
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
                RecordCount = lstObjectionType_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}


