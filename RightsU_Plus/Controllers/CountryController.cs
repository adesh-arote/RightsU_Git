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
    public class CountryController : BaseController
    {
        private List<RightsU_Entities.USP_List_Country_Result> lstCountry
        {
            get
            {
                if (Session["lstCountry"] == null)
                    Session["lstCountry"] = new List<RightsU_Entities.USP_List_Country_Result>();
                return (List<RightsU_Entities.USP_List_Country_Result>)Session["lstCountry"];
            }
            set { Session["lstCountry"] = value; }
        }
        private List<RightsU_Entities.USP_List_Country_Result> lstCountry_Searched
        {
            get
            {
                if (Session["lstCountry_Searched"] == null)
                    Session["lstCountry_Searched"] = new List<RightsU_Entities.USP_List_Country_Result>();
                return (List<RightsU_Entities.USP_List_Country_Result>)Session["lstCountry_Searched"];
            }
            set { Session["lstCountry_Searched"] = value; }
        }
        private RightsU_Entities.Country objCountry
        {
            get
            {
                if (Session["objCountry"] == null)
                    Session["objCountry"] = new RightsU_Entities.Country();
                return (RightsU_Entities.Country)Session["objCountry"];
            }
            set { Session["objCountry"] = value; }
        }
        private Country_Service objCountry_Service
        {
            get
            {
                if (Session["objCountry_Service"] == null)
                    Session["objCountry_Service"] = new Country_Service(objLoginEntity.ConnectionStringName);
                return (Country_Service)Session["objCountry_Service"];
            }
            set { Session["objCountry_Service"] = value; }
        }
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCountry);
            //string modulecode = Request.QueryString["modulecode"];
            string modulecode = GlobalParams.ModuleCodeForCountry.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            FetchData();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Country/Index.cshtml");
        }
        public PartialViewResult BindCountryList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.USP_List_Country_Result> lst = new List<RightsU_Entities.USP_List_Country_Result>();
            int RecordCount = 0;
            RecordCount = lstCountry_Searched.Count;
            Country_Service objCountrySerivce = new Country_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Language> lstlanguage = new List<RightsU_Entities.Language>();
            lstlanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            ViewBag.Countries = new SelectList(lstlanguage, "language_Code", "language_Name");

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstCountry_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstCountry_Searched.OrderBy(o => o.Country_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstCountry_Searched.OrderByDescending(o => o.Country_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Country/_CountryList.cshtml", lst);
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
        private void FetchData()
        {
            lstCountry_Searched = lstCountry = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Country(objLoginUser.System_Language_Code).OrderBy(o => o.Last_Updated_Time).ToList<RightsU_Entities.USP_List_Country_Result>();
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCountry), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        public JsonResult SearchCountry(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstCountry_Searched = lstCountry.Where(w => w.Country_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstCountry_Searched = lstCountry;

            var obj = new
            {
                Record_Count = lstCountry_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult CheckRecordLock(int countryCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (countryCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(countryCode, GlobalParams.ModuleCodeForCountry, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public PartialViewResult AddEditCountry(int countryCode)
        {
            objCountry = null;
            objCountry_Service = null;

            if (countryCode > 0)
                objCountry = objCountry_Service.GetById(countryCode);

            List<RightsU_Entities.Language> lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Language_Name).ToList();
            var languageCodes = objCountry.Country_Language.Select(s => s.Language_Code).ToArray();
            ViewBag.LanguageList = new MultiSelectList(lstLanguage, "Language_Code", "Language_Name", languageCodes);

            List<RightsU_Entities.Country> lstBaseCountry = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y" && w.Is_Domestic_Territory == "Y").OrderBy(o => o.Country_Name).ToList();
            var parentCountryCode = objCountry.Parent_Country_Code;
            ViewBag.BaseCountryList = new SelectList(lstBaseCountry, "Country_Code", "Country_Name", parentCountryCode);

           objCountry.Base_Country_Count = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Domestic_Territory == "Y").Count();

            return PartialView("~/Views/Country/_AddEditCountry.cshtml", objCountry);
        }
        public JsonResult ActiveDeactiveCountry(int countryCode, string doActive)
        {
           // string status = "S", message = "";
             string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(countryCode, GlobalParams.ModuleCodeForCountry, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Country_Service objService = new Country_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Country objCountry = objService.GetById(countryCode);
                objCountry.Is_Active = doActive;
                objCountry.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objCountry, out resultSet);
                if (isValid)
                {
                    lstCountry.Where(w => w.Country_Code == countryCode).First().Is_Active = doActive;
                    lstCountry_Searched.Where(w => w.Country_Code == countryCode).First().Is_Active = doActive;

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
                //message = "Cound not {ACTION} record";
                message = strMessage;
            }
            
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public JsonResult SaveCountry(FormCollection objCollection)
        {
            string status = "S", message = "";
            objCountry.Country_Name = Convert.ToString(objCollection["Country_Name"]);
            objCountry.Is_Theatrical_Territory = Convert.ToString(objCollection["IsTheatricalTerritory"] ?? "N");

            if (!objCountry.Is_Theatrical_Territory.Equals("N"))
            {
                objCountry.Is_Theatrical_Territory = "Y";
                objCountry.Is_Domestic_Territory = "N";
                objCountry.Parent_Country_Code = Convert.ToInt32(objCollection["ddlCountry"]);
            }
            else
            {
                objCountry.Is_Domestic_Territory = Convert.ToString(objCollection["IsDomesticTerritory"]);
                objCountry.Parent_Country_Code = null;
            }

            if (objCountry.Country_Code == 0)
            {
                objCountry.EntityState = State.Added;
                objCountry.Inserted_On = DateTime.Now;
                objCountry.Inserted_By = objLoginUser.Users_Code;
                objCountry.Is_Active = "Y";
            }
            else
                objCountry.EntityState = State.Modified;

            objCountry.Last_Updated_Time = DateTime.Now;
            objCountry.Last_Action_By = objLoginUser.Users_Code;

            #region --- Channel ---
            ICollection<Country_Language> languageList = new HashSet<Country_Language>();
            if (objCollection["ddlLanguage"] != null)
            {
                string[] arrLanguageCodes = objCollection["ddlLanguage"].Split(',');
                foreach (string langaugeCode in arrLanguageCodes)
                {
                    Country_Language objCL = new Country_Language();
                    objCL.EntityState = State.Added;
                    objCL.Language_Code = Convert.ToInt32(langaugeCode);
                    languageList.Add(objCL);
                }
            }
            IEqualityComparer<Country_Language> comparerChannel = new LambdaComparer<Country_Language>((x, y) => x.Language_Code == y.Language_Code && x.EntityState != State.Deleted);
            var Deleted_Country_Language = new List<Country_Language>();
            var Updated_Country_Language = new List<Country_Language>();
            var Added_Country_Language = CompareLists<Country_Language>(languageList.ToList<Country_Language>(), objCountry.Country_Language.ToList<Country_Language>(), comparerChannel, ref Deleted_Country_Language, ref Updated_Country_Language);
            Added_Country_Language.ToList<Country_Language>().ForEach(t => objCountry.Country_Language.Add(t));
            Deleted_Country_Language.ToList<Country_Language>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            if (objCountry.Country_Code > 0)
                message = objMessageKey.Recordupdatedsuccessfully;
            else
                message = objMessageKey.RecordAddedSuccessfully;

            dynamic resultSet;
            if (!objCountry_Service.Save(objCountry, out resultSet))
            {
                status = "E";
                message = resultSet;
            }
            else
            {
                int recordLockingCode = Convert.ToInt32(objCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                objCountry = null;
                objCountry_Service = null;
                FetchData();
            }

            var obj = new
            {
                Record_Count= lstCountry_Searched.Count,
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
    }
}
