//using RightsU_BLL;
//using RightsU_Entities;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;


namespace RightsU_Plus.Controllers
{
    public class ProgramController : BaseController
    {
        private readonly Program_Service objProgramService = new Program_Service();
        private readonly Deal_Type_Service objDeal_TypeService = new Deal_Type_Service();
        private readonly Genres_Service objGenresService = new Genres_Service();
        private readonly USP_Service objProcedureService = new USP_Service();
        #region  --Properties--
        private List<RightsU_Dapper.Entity.Program> lstProgram
        {
            get
            {
                if (Session["lstProgram"] == null)
                    Session["lstProgram"] = new List<RightsU_Dapper.Entity.Program>();
                return (List<RightsU_Dapper.Entity.Program>)Session["lstProgram"];
            }
            set { Session["lstProgram"] = value; }
        }
        private List<RightsU_Dapper.Entity.Program> lstProgram_Searched
        {
            get
            {
                if(Session["lstProgram_Searched"] == null)
                    Session["lstProgram_Searched"] = new List<RightsU_Dapper.Entity.Program>();
                return (List<RightsU_Dapper.Entity.Program>)Session["lstProgram_Searched"];
            }
            set { Session["lstProgram_Searched"] = value; }
        }
        #endregion
        Type[] RelationList = new Type[] { typeof(Deal_Type)
                    ,typeof(RightsU_Dapper.Entity.Genres) };
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForProgram);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForProgram.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstProgram_Searched = lstProgram = (List<RightsU_Dapper.Entity.Program>)objProgramService.GetList(RelationList);
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Program/Index.cshtml");
        }

        public PartialViewResult BindProgramList(int pageNo, int recordPerPage, int programCode, string commandName, string sortType)
        {
            ViewBag.Program_Code = programCode;
            ViewBag.CommandName = commandName;
            var DealTypeCode = objProgramService.GetList(RelationList).Where(x => x.Program_Code == programCode).Select(x => x.Deal_Type_Code).FirstOrDefault();
            var GenreCode = objProgramService.GetList(RelationList).Where(x => x.Program_Code == programCode).Select(x => x.Genres_Code).FirstOrDefault();
            ViewBag.DealType = new SelectList(objDeal_TypeService.GetList(RelationList).Where(x => x.Is_Active == "Y").ToList(), "Deal_Type_Code", "Deal_Type_Name", DealTypeCode);
            ViewBag.Genre = new SelectList(objGenresService.GetList(RelationList).Where(x => x.Is_Active == "Y").ToList(), "Genres_Code", "Genres_Name", GenreCode);
            List<RightsU_Dapper.Entity.Program> lst = new List<RightsU_Dapper.Entity.Program>();
            int RecordCount = 0;
            RecordCount = lstProgram_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstProgram_Searched.OrderByDescending(o => o.Last_UpDated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstProgram_Searched.OrderBy(o => o.Program_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstProgram_Searched.OrderByDescending(o => o.Program_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Program/_ProgramList.cshtml", lst);
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
        string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForProgram), objLoginUser.Security_Group_Code,objLoginUser.Users_Code);
        string rights = "";
        if (lstRights != null)
            rights = lstRights;

        return rights;
    }
        #endregion

         public JsonResult CheckRecordLock(int programCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (programCode > 0)
            {
                isLocked = DBUtil.Lock_Record(programCode, GlobalParams.ModuleCodeForProgram, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult Searchprogram(string searchText)
         {
           // Program_Service objService = new Program_Service(objLoginEntity.ConnectionStringName);
             if (!string.IsNullOrEmpty(searchText))
             {
                 lstProgram_Searched = lstProgram.Where(w => w.Program_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
             }
             else
                 lstProgram_Searched = lstProgram;


             var obj = new
             {
                 Record_Count = lstProgram_Searched.Count
             };
             return Json(obj);
         }

         public JsonResult ActiveDeactiveProgram(int Program_Code, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;

            bool isLocked = DBUtil.Lock_Record(Program_Code, GlobalParams.ModuleCodeForProgram, objLoginUser.Users_Code, out RLCode, out strMessage);
            if (isLocked)
            {
                //Program_Service objService = new Program_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Program objProgram = objProgramService.GetProgramGroupByID(Program_Code);
                objProgram.Is_Active = doActive;
                //objProgram.EntityState = State.Modified;
                dynamic resultSet;
                objProgramService.UpdateCategory(objProgram);
                //bool isValid = objService.Save(objProgram, out resultSet);
                bool isValid = true;
                if (isValid)
                {
                    lstProgram.Where(w => w.Program_Code == Program_Code).First().Is_Active = doActive;
                    lstProgram_Searched.Where(w => w.Program_Code == Program_Code).First().Is_Active = doActive;
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

         public JsonResult SaveProgram(int programCode, string programName, int Record_Code, int DealTypeCode, int GenreCode)
         {
             string status = "S", message = objMessageKey.Recordsavedsuccessfully;
             if (programCode > 0)
                 message = objMessageKey.Recordupdatedsuccessfully;

             //Program_Service objService = new Program_Service(objLoginEntity.ConnectionStringName);
             RightsU_Dapper.Entity.Program objProgram = null;

             if (programCode > 0)
             {
                 objProgram = objProgramService.GetProgramGroupByID(programCode);
                 //objProgram.EntityState = State.Modified;
             }
             else
             {
                 objProgram = new RightsU_Dapper.Entity.Program();
                 //objProgram.EntityState = State.Added;
                 objProgram.Inserted_On = DateTime.Now;
                 objProgram.Inserted_By = objLoginUser.Users_Code;
             }
             if (DealTypeCode == 0)
             {
                 objProgram.Deal_Type_Code = null;
             }
             else
             {
                 objProgram.Deal_Type_Code = DealTypeCode;
             }
             if (GenreCode == 0)
             {
                 objProgram.Genres_Code = null;
             }
             else
             {
                 objProgram.Genres_Code = GenreCode;
             }
             objProgram.Last_UpDated_Time = DateTime.Now;
             objProgram.Last_Action_By = objLoginUser.Users_Code;
             objProgram.Is_Active = "Y";
             objProgram.Program_Name = programName;
             dynamic resultSet;
            if (programCode > 0)
            {
                objProgramService.UpdateCategory(objProgram);
            }
            else
            {
                objProgramService.AddEntity(objProgram);
            }
                // bool isValid = objService.Save(objProgram, out resultSet);
                bool isValid = true;
             if (isValid)
             {
                 //objService = new Program_Service(objLoginEntity.ConnectionStringName);
                 lstProgram_Searched = lstProgram = objProgramService.GetList().OrderByDescending(x => x.Last_UpDated_Time).ToList();
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
                 RecordCount = lstProgram_Searched.Count,
                 Status = status,
                 Message = message
             };
             return Json(obj);
         }
    }
}
