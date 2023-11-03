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
    public class LanguageGroupController : BaseController
    {
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

        private List<RightsU_Entities.Language_Group> lstLanguage_Group
        {
            get
            {
                if (Session["lstLanguage_Group"] == null)
                    Session["lstLanguage_Group"] = new List<RightsU_Entities.Language_Group>();
                return (List<RightsU_Entities.Language_Group>)Session["lstLanguage_Group"];
            }
            set { Session["lstLanguage_Group"] = value; }
        }

        private List<RightsU_Entities.Language_Group> lstLanguage_Group_Searched
        {
            get
            {
                if (Session["lstLanguage_Group_Searched"] == null)
                    Session["lstLanguage_Group_Searched"] = new List<RightsU_Entities.Language_Group>();
                return (List<RightsU_Entities.Language_Group>)Session["lstLanguage_Group_Searched"];
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
            Language_Group_Service objService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Language_Group objLanguage_Group = objService.GetById(Language_Group_Code);

            if (commandName == "EDIT" || commandName == "ADD")
            {
                dynamic languageCode = null;
                List<RightsU_Entities.Language> lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).OrderBy(o => o.Language_Name).ToList();
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
            List<RightsU_Entities.Language_Group> lst = new List<RightsU_Entities.Language_Group>();
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
                Language_Group_Service objService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Language_Group objLanguage = objService.GetById(Language_Group_Code);
                objLanguage.Is_Active = doActive;
                objLanguage.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objLanguage, out resultSet);
                if (isValid)
                {
                    string Action = "A";
                    lstLanguage_Group.Where(w => w.Language_Group_Code == Language_Group_Code).First().Is_Active = doActive;
                    lstLanguage_Group_Searched.Where(w => w.Language_Group_Code == Language_Group_Code).First().Is_Active = doActive;
                    if (doActive == "Y")
                    {
                        message = objMessageKey.Recordactivatedsuccessfully;
                        Action = "A";
                    }                        
                    else
                    {
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                        Action = "DA";
                    }

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objLanguage);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForLanguageGroup), Convert.ToInt32(objLanguage.Language_Group_Code), LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {

                    }
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
            string Action = "C";
            string status = "S", message = "Record {ACTION} successfully";
            Language_Group_Service objService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Language_Group objL = new RightsU_Entities.Language_Group();
            if (Language_Group_Code > 0)
            {
                objL = objService.GetById(Language_Group_Code);
                objL.EntityState = State.Modified;
            }
            else
            {
                objL = new RightsU_Entities.Language_Group();
                objL.EntityState = State.Added;
                objL.Inserted_On = DateTime.Now;
                objL.Inserted_By = objLoginUser.Users_Code;
            }
            objL.Last_Updated_Time = System.DateTime.Now;

            ICollection<RightsU_Entities.Language_Group_Details> BuisnessUnitList = new HashSet<RightsU_Entities.Language_Group_Details>();
            if (LanguageCodes != null)
            {
                // string[] arrBuisnessCode = LanguageCodes[0].s
                foreach (string BuisnessUnitCode in LanguageCodes)
                {
                    RightsU_Entities.Language_Group_Details objTR = new Language_Group_Details();
                    objTR.EntityState = State.Added;
                    objTR.Language_Code = Convert.ToInt32(BuisnessUnitCode);
                    BuisnessUnitList.Add(objTR);
                }
            }

            IEqualityComparer<RightsU_Entities.Language_Group_Details> comparerBuisness_Unit = new LambdaComparer<RightsU_Entities.Language_Group_Details>((x, y) => x.Language_Code == y.Language_Code && x.EntityState != State.Deleted);
            var Deleted_Users_Business_Unit = new List<RightsU_Entities.Language_Group_Details>();
            var Updated_Users_Business_Unit = new List<RightsU_Entities.Language_Group_Details>();

            var Added_Users_Business_Unit = CompareLists<RightsU_Entities.Language_Group_Details>(BuisnessUnitList.ToList<RightsU_Entities.Language_Group_Details>(), objL.Language_Group_Details.ToList<RightsU_Entities.Language_Group_Details>(), comparerBuisness_Unit, ref Deleted_Users_Business_Unit, ref Updated_Users_Business_Unit);
            Added_Users_Business_Unit.ToList<RightsU_Entities.Language_Group_Details>().ForEach(t => objL.Language_Group_Details.Add(t));
            Deleted_Users_Business_Unit.ToList<RightsU_Entities.Language_Group_Details>().ForEach(t => t.EntityState = State.Deleted);
            if (Language_Group_Code > 0)
            {
                if (objL.Acq_Deal_Rights_Dubbing.Count > 0 || objL.Acq_Deal_Rights_Subtitling.Count > 0 || objL.Syn_Deal_Rights_Dubbing.Count > 0 || objL.Syn_Deal_Rights_Subtitling.Count > 0)
                {
                    if (Deleted_Users_Business_Unit.Count > 0)
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
                dynamic resultSet;
                bool isValid = objService.Save(objL, out resultSet);

                if (isValid)
                {
                     lstLanguage_Group_Searched = lstLanguage_Group = objService.SearchFor(s => true).OrderByDescending(x => x.Last_Updated_Time).ToList();
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
                int recordLockingCode = Convert.ToInt32(Record_Code);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);

                if (Language_Group_Code > 0)
                {
                    if (status == "E")
                    {
                        message = objMessageKey.languagegroupalreadyexists;
                    }                        
                    else
                    {
                        message = objMessageKey.Recordupdatedsuccessfully;
                        //message = message.Replace("{ACTION}", "updated");
                        Action = "U";
                    }
                }
                else
                {
                    if (status == "E")
                    {
                        message = objMessageKey.languagegroupalreadyexists;
                    }                        
                    else
                    {
                        message = objMessageKey.Recordsavedsuccessfully;
                        //message = message.Replace("{ACTION}", "saved");
                        Action = "C";
                    }
                }

                if (isValid)
                {
                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objL);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForLanguageGroup), Convert.ToInt32(objL.Language_Group_Code), LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {

                    }
                }
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForLanguageGroup);
            string moduleCode = GlobalParams.ModuleCodeForLanguageGroup.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstLanguage_Group_Searched = lstLanguage_Group = new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
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
