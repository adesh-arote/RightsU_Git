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
    public class LanguageGroupController : BaseController
    {
        private readonly USP_Service objProcedureService = new USP_Service();
        private readonly RightsU_Dapper.BLL.Services.Language_Group_Service objLanguageGroupService = new RightsU_Dapper.BLL.Services.Language_Group_Service();
        private readonly RightsU_Dapper.BLL.Services.Language_Service objLanguageService = new RightsU_Dapper.BLL.Services.Language_Service();
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

        private List<RightsU_Dapper.Entity.Language_Group> lstLanguage_Group
        {
            get
            {
                if (Session["lstLanguage_Group"] == null)
                    Session["lstLanguage_Group"] = new List<RightsU_Dapper.Entity.Language_Group>();
                return (List<RightsU_Dapper.Entity.Language_Group>)Session["lstLanguage_Group"];
            }
            set { Session["lstLanguage_Group"] = value; }
        }

        private List<RightsU_Dapper.Entity.Language_Group> lstLanguage_Group_Searched
        {
            get
            {
                if (Session["lstLanguage_Group_Searched"] == null)
                    Session["lstLanguage_Group_Searched"] = new List<RightsU_Dapper.Entity.Language_Group>();
                return (List<RightsU_Dapper.Entity.Language_Group>)Session["lstLanguage_Group_Searched"];
            }
            set { Session["lstLanguage_Group_Searched"] = value; }
        }

        public JsonResult SearchLanguage_Group(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstLanguage_Group_Searched = lstLanguage_Group.Where(w => w.Language_Group_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstLanguage_Group_Searched = lstLanguage_Group;

            var obj = new
            {
                Record_Count = lstLanguage_Group_Searched.Count
            };
            return Json(obj);
        }

        public PartialViewResult BindLanguage_GroupList(int pageNo, int recordPerPage, int Language_Group_Code, string commandName, string sortType)
        {

            ViewBag.Language_Group_Code = Language_Group_Code;
            ViewBag.CommandName = commandName;
            //Language_Group_Service objService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Language_Group objLanguage_Group = objLanguageGroupService.GetLanguageGroupByID(Language_Group_Code, new Type[] { typeof(Language_Group_Details) });

            if (commandName == "EDIT" || commandName == "ADD")
            {
                dynamic languageCode = null;
                List<RightsU_Dapper.Entity.Language> lstLanguage = objLanguageService.GetList().OrderBy(o => o.Language_Name).ToList();
             
                if (commandName == "EDIT")
                {
                    languageCode = objLanguage_Group.Language_Group_Details.Select(s => s.Language_Code).ToArray();
                }
                ViewBag.LanguageList = new MultiSelectList(lstLanguage, "Language_Code", "Language_Name", languageCode);
            }
            //else if (commandName == "ADD")
            //{
            //    List<RightsU_Entities.Language> lstLanguage = new Language_Service().SearchFor(w => true).OrderBy(o => o.Language_Name).ToList();
            //    //var languageCode = objLanguage_Group.Language_Group_Details.Select(s => s.Language_Code).ToArray();
            //    ViewBag.LanguageList = new MultiSelectList(lstLanguage, "Language_Code", "Language_Name");
            //}
            List<RightsU_Dapper.Entity.Language_Group> lst = new List<RightsU_Dapper.Entity.Language_Group>();
            int RecordCount = 0;
            RecordCount = lstLanguage_Group_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstLanguage_Group_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstLanguage_Group_Searched.OrderBy(o => o.Language_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstLanguage_Group_Searched.OrderByDescending(o => o.Language_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/LanguageGroup/_LanguageGroup.cshtml", lst);
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

        public JsonResult ActiveDeactiveLanguage_Group(int Language_Group_Code, string doActive)
        {

            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(Language_Group_Code, GlobalParams.ModuleCodeForLanguageGroup, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Language_Group_Service objService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Language_Group objLanguage = objLanguageGroupService.GetLanguageGroupByID(Language_Group_Code);
                objLanguage.Is_Active = doActive;
                //objLanguage.EntityState = State.Modified;
                dynamic resultSet;
                //bool isValid = objService.Save(objLanguage, out resultSet);
                bool isValid = true;
                if (isValid)
                {
                    lstLanguage_Group.Where(w => w.Language_Group_Code == Language_Group_Code).First().Is_Active = doActive;
                    lstLanguage_Group_Searched.Where(w => w.Language_Group_Code == Language_Group_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                }
                else
                {
                    status = "E";
                    if (doActive == "Y")
                        message = objMessageKey.CouldNotActivatedRecord;
                    else
                        message = objMessageKey.CouldNotDeactivatedRecord;
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

        public JsonResult SaveLanguage_Group(int Language_Group_Code, string Language_Group_Name, string[] LanguageCodes, int Record_Code)
        {
            string status = "S", message = "Record {ACTION} successfully";
            //Language_Group_Service objService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Language_Group objL = new RightsU_Dapper.Entity.Language_Group();
            RightsU_Dapper.Entity.Language objLG = new RightsU_Dapper.Entity.Language();
            if (Language_Group_Code > 0)
            {
                objL = objLanguageGroupService.GetLanguageGroupByID(Language_Group_Code);
                //objL.EntityState = State.Modified;
                //objLanguageGroupService.UpdateMusic_Deal(objL);
            }
            else
            {
                objL = new RightsU_Dapper.Entity.Language_Group();
                //objLanguageGroupService.AddEntity(objL);
                //objL.EntityState = State.Added;
                objL.Inserted_On = DateTime.Now;
                objL.Inserted_By = objLoginUser.Users_Code;
            }
            objL.Last_Updated_Time = System.DateTime.Now;

            ICollection<RightsU_Dapper.Entity.Language_Group_Details> BuisnessUnitList = new HashSet<RightsU_Dapper.Entity.Language_Group_Details>();
            if (LanguageCodes != null)
            {
                // string[] arrBuisnessCode = LanguageCodes[0].s
                foreach (string BuisnessUnitCode in LanguageCodes)
                {
                    RightsU_Dapper.Entity.Language_Group_Details objTR = new Language_Group_Details();
                    //objLanguageGroupService.AddEntity(objTR);

                    //objTR.EntityState = State.Added;
                    objTR.Language_Code = Convert.ToInt32(BuisnessUnitCode);
                    BuisnessUnitList.Add(objTR);
                }
            }

            IEqualityComparer<RightsU_Dapper.Entity.Language_Group_Details> comparerBuisness_Unit = new RightsU_Dapper.BLL.LambdaComparer<RightsU_Dapper.Entity.Language_Group_Details>((x, y) => x.Language_Code == y.Language_Code); //&& x.EntityState != State.Deleted);
            var Deleted_Language_Group_Details = new List<RightsU_Dapper.Entity.Language_Group_Details>();
            var Updated_Language_Group_Details = new List<RightsU_Dapper.Entity.Language_Group_Details>();

            var Added_Language_Group_Details = CompareLists<RightsU_Dapper.Entity.Language_Group_Details>(BuisnessUnitList.ToList<RightsU_Dapper.Entity.Language_Group_Details>(), objL.Language_Group_Details.ToList<RightsU_Dapper.Entity.Language_Group_Details>(), comparerBuisness_Unit, ref Deleted_Language_Group_Details, ref Updated_Language_Group_Details);
            Added_Language_Group_Details.ToList<RightsU_Dapper.Entity.Language_Group_Details>().ForEach(t => objL.Language_Group_Details.Add(t));
            Deleted_Language_Group_Details.ToList<RightsU_Dapper.Entity.Language_Group_Details>().ForEach(t => objL.Language_Group_Details.Remove(t));
            if (Language_Group_Code > 0)
            {
                if (objL.Acq_Deal_Rights_Dubbing.Count > 0 || objL.Acq_Deal_Rights_Subtitling.Count > 0 || objL.Syn_Deal_Rights_Dubbing.Count > 0 || objL.Syn_Deal_Rights_Subtitling.Count > 0)
                {
                    if (Deleted_Language_Group_Details.Count > 0)
                    {
                        status = "E";
                        message = objMessageKey.LanguageGroupisalreadyusedYoucannotremoveexistingLanguages;
                    }
                }
            }
            objL.Last_Updated_Time = DateTime.Now;
            objL.Last_Action_By = objLoginUser.Users_Code;
            objL.Is_Active = "Y";
            objL.Language_Group_Name = Language_Group_Name;
            
            
            if (status != "E")
            {
                try
                {
                    if (Language_Group_Code == 0)
                        objLanguageGroupService.AddEntity(objL);
                    else
                        objLanguageGroupService.UpdateMusic_Deal(objL);

                    dynamic resultSet;
                    // bool isValid = objService.Save(objL, out resultSet);
                    bool isValid = true;
                    if (isValid)
                    {
                        lstLanguage_Group_Searched = lstLanguage_Group = objLanguageGroupService.GetList().OrderByDescending(x => x.Last_Updated_Time).ToList();
                    }
                }
                catch (Exception e)
                {
                    string a = e.Message;

                    status = "E";
                    message = "";
                }
                    
                int recordLockingCode = Convert.ToInt32(Record_Code);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);

                if (Language_Group_Code > 0)
                    if(status == "E")
                        message = objMessageKey.languagegroupalreadyexists;
                    else
                        message = objMessageKey.Recordupdatedsuccessfully;
                        //message = message.Replace("{ACTION}", "updated");
                else
                    if (status == "E")
                        message = objMessageKey.languagegroupalreadyexists;
                    else
                        message = objMessageKey.Recordsavedsuccessfully;
                        //message = message.Replace("{ACTION}", "saved");
            }
            var obj = new
            {
                RecordCount= lstLanguage_Group_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);



        }

        public JsonResult CheckRecordLock(int Language_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Language_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Language_Code, GlobalParams.ModuleCodeForLanguageGroup, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        private string GetUserModuleRights()
        {
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForLanguageGroup);
            string moduleCode = GlobalParams.ModuleCodeForLanguageGroup.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstLanguage_Group_Searched = lstLanguage_Group = (List<RightsU_Dapper.Entity.Language_Group>)objLanguageGroupService.GetList(new Type[] { typeof(Language_Group_Details) });
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/LanguageGroup/Index.cshtml");
            //return View(lstLanguage_Group_Searched);
        }
        //public void FetchData()
        //{
        //    lstLanguage_Group_Searched = lstLanguage_Group = new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        //}

    }
}
