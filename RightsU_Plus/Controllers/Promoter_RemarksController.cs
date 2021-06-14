//using RightsU_BLL;
//using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Promoter_RemarksController : BaseController
    {
        private readonly Promoter_Remarks_Service objPromoter_Remarks_Service = new Promoter_Remarks_Service();
        private readonly USP_Service objProcedureService = new USP_Service();
        #region --Properties--
        private List<RightsU_Dapper.Entity.Promoter_Remarks> lstPromoter_Remarks
        {
            get
            {
                if (Session["lstPromoter_Remarks"] == null)
                    Session["lstPromoter_Remarks"] = new List<RightsU_Dapper.Entity.Promoter_Remarks>();
                return (List<RightsU_Dapper.Entity.Promoter_Remarks>)Session["lstPromoter_Remarks"];
            }
            set { Session["lstPromoter_Remarks"] = value; }
        }

        private List<RightsU_Dapper.Entity.Promoter_Remarks> lstPromoter_Remarks_Searched
        {
            get
            {
                if (Session["lstPromoter_Remarks_Searched"] == null)
                    Session["lstPromoter_Remarks_Searched"] = new List<RightsU_Dapper.Entity.Promoter_Remarks>();
                return (List<RightsU_Dapper.Entity.Promoter_Remarks>)Session["lstPromoter_Remarks_Searched"];
            }
            set { Session["lstPromoter_Remarks_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForPromoterRemarks);
            string moduleCode = GlobalParams.ModuleCodeForPromoterRemarks.ToString();
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.Code = moduleCode;
            lstPromoter_Remarks_Searched = lstPromoter_Remarks = (List<RightsU_Dapper.Entity.Promoter_Remarks>)objPromoter_Remarks_Service.GetList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
             ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Promoter_Remarks/Index.cshtml");
        }
        public PartialViewResult BindPromoter_RemarksList(int pageNo, int recordPerPage, int Promoter_Remarks_Code, string commandName, string sortType)
        {
            ViewBag.Promoter_Remarks_Code = Promoter_Remarks_Code;
            ViewBag.CommandName = commandName;
            List<RightsU_Dapper.Entity.Promoter_Remarks> lst = new List<RightsU_Dapper.Entity.Promoter_Remarks>();
            int RecordCount = 0;
            RecordCount = lstPromoter_Remarks_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstPromoter_Remarks_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstPromoter_Remarks_Searched.OrderBy(o => o.Promoter_Remark_Desc).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstPromoter_Remarks_Searched.OrderByDescending(o => o.Promoter_Remark_Desc).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Promoter_Remarks/_Promoter_RemarksList.cshtml", lst);
        }
        public JsonResult SearchPromoter_Remarks(string searchText)
        {
            //Promoter_Remarks_Service objService = new Promoter_Remarks_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                lstPromoter_Remarks_Searched = lstPromoter_Remarks.Where(w => w.Promoter_Remark_Desc.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstPromoter_Remarks_Searched = lstPromoter_Remarks;


            var obj = new
            {
                Record_Count = lstPromoter_Remarks_Searched.Count
            };
            return Json(obj);
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
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForPromoterRemarks), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        #endregion
        public JsonResult CheckRecordLock(int Promoter_Remarks_Code, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Promoter_Remarks_Code > 0)
            {
                isLocked = DBUtil.Lock_Record(Promoter_Remarks_Code, GlobalParams.ModuleCodeForPromoterRemarks, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult ActiveDeactivePromoter_Remarks(int Promoter_Remarks_Code, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(Promoter_Remarks_Code, GlobalParams.ModuleCodeForPromoterRemarks, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                //Promoter_Remarks_Service objService = new Promoter_Remarks_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Promoter_Remarks objPR = objPromoter_Remarks_Service.GetPromoterRemarkByID(Promoter_Remarks_Code);
                objPR.Is_Active = doActive;
                //objPR.EntityState = State.Modified;
                dynamic resultSet;

                //bool isValid = objService.Save(objPR, out resultSet);

                bool isValid = true;
                if (isValid)
                {
                    lstPromoter_Remarks.Where(w => w.Promoter_Remarks_Code == Promoter_Remarks_Code).First().Is_Active = doActive;
                    lstPromoter_Remarks_Searched.Where(w => w.Promoter_Remarks_Code == Promoter_Remarks_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                }
                else
                {
                    status = "E";
                    message = "";
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
        public JsonResult SavePromoter_Remarks(int Promoter_Remarks_Code, string Promoter_Remarks, int Record_Code)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (Promoter_Remarks_Code > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            //Promoter_Remarks_Service objService = new Promoter_Remarks_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Promoter_Remarks objPR = null;

            if (Promoter_Remarks_Code > 0)
            {
                objPR = objPromoter_Remarks_Service.GetPromoterRemarkByID(Promoter_Remarks_Code);
                //objPR.EntityState = State.Modified;
            }
            else
            {
                objPR = new RightsU_Dapper.Entity.Promoter_Remarks();
               // objPR.EntityState = State.Added;
                objPR.Inserted_On = DateTime.Now;
                objPR.Inserted_By = objLoginUser.Users_Code;
            }

            objPR.Last_Updated_Time = DateTime.Now;
            objPR.Last_Action_By = objLoginUser.Users_Code;
            objPR.Is_Active = "Y";
            objPR.Promoter_Remark_Desc = Promoter_Remarks;
            string resultSet;
            bool isDuplicate = objPromoter_Remarks_Service.Validate(objPR, out resultSet);
            //bool isValid = objService.Save(objPR, out resultSet);
            if (isDuplicate)
            {
                if (Promoter_Remarks_Code == 0)
                    objPromoter_Remarks_Service.AddEntity(objPR);
                else
                    objPromoter_Remarks_Service.UpdateMusic_Deal(objPR);
            }
            else
            {
                status = "";
                message = resultSet;
            }
            bool isValid = true;

            if (isValid)
            {
                lstPromoter_Remarks_Searched = lstPromoter_Remarks = objPromoter_Remarks_Service.GetList().OrderByDescending(x => x.Last_Updated_Time).ToList();
            }
            else
            {
                status = "E";
                message = "";
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            DBUtil.Release_Record(recordLockingCode);
            var obj = new
            {
                RecordCount = lstPromoter_Remarks_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}
