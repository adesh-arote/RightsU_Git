
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class TerritoryController : BaseController
    {
        private List<RightsU_Entities.USP_List_Territory_Result> lstTerritory
        {
            get
            {
                if (Session["lstTerritory"] == null)
                    Session["lstTerritory"] = new List<RightsU_Entities.USP_List_Territory_Result>();
                return (List<RightsU_Entities.USP_List_Territory_Result>)Session["lstTerritory"];
            }
            set { Session["lstTerritory"] = value; }
        }
        private List<RightsU_Entities.USP_List_Territory_Result> lstTerritory_Searched
        {
            get
            {
                if (Session["lstTerritory_Searched"] == null)
                    Session["lstTerritory_Searched"] = new List<RightsU_Entities.USP_List_Territory_Result>();
                return (List<RightsU_Entities.USP_List_Territory_Result>)Session["lstTerritory_Searched"];
            }
            set { Session["lstTerritory_Searched"] = value; }
        }
        private RightsU_Entities.Territory objTerritory
        {
            get
            {
                if (Session["objTerritory"] == null)
                    Session["objTerritory"] = new RightsU_Entities.Territory();
                return (RightsU_Entities.Territory)Session["objTerritory"];
            }
            set { Session["objTerritory"] = value; }
        }
        private Territory_Service objTerritory_Service
        {
            get
            {
                if (Session["objTerritory_Service"] == null)
                    Session["objTerritory_Service"] = new Territory_Service(objLoginEntity.ConnectionStringName);
                return (Territory_Service)Session["objTerritory_Service"];
            }
            set { Session["objTerritory_Service"] = value; }
        }
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTerritoryGroup);
            //string modulecode = Request.QueryString["modulecode"];
            string modulecode = GlobalParams.ModuleCodeForTerritoryGroup.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstTerritory_Searched = lstTerritory = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Territory(Convert.ToInt32(objLoginUser.System_Language_Code)).OrderBy(o => o.Last_Updated_Time).ToList<RightsU_Entities.USP_List_Territory_Result>();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });

            List<RightsU_Entities.Language> lstlanguage = new List<RightsU_Entities.Language>();
            lstlanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            ViewBag.LanguageList = new SelectList(lstlanguage, "language_Name", "language_Name");
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Territory/Index.cshtml");
        }
        public PartialViewResult BindTerritoryList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.USP_List_Territory_Result> lst = new List<RightsU_Entities.USP_List_Territory_Result>();
            int RecordCount = 0;
            RecordCount = lstTerritory_Searched.Count;
            Territory_Service objSerivce = new Territory_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Country> lstcountry = new List<RightsU_Entities.Country>();
            lstcountry = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            ViewBag.Territories = new SelectList(lstcountry, "Country_Code", "Country_Name");

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstTerritory_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstTerritory_Searched.OrderBy(o => o.Territory_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstTerritory_Searched.OrderByDescending(o => o.Territory_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Territory/_TerritoryList.cshtml", lst);
        }
        public JsonResult BindCountryDropdown(string isTheatricalTerritory)
        {
            List<SelectListItem> lstCountry = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Theatrical_Territory == isTheatricalTerritory).
                OrderBy(o => o.Country_Name), "Country_Code", "Country_Name").ToList();
            var obj = new
            {
                CountryList = lstCountry
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
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTerritoryGroup), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        public JsonResult SearchTerritory(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstTerritory_Searched = lstTerritory.Where(w => w.Territory_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstTerritory_Searched = lstTerritory;

            var obj = new
            {
                Record_Count = lstTerritory_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult CheckRecordLock(int territoryCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (territoryCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(territoryCode, GlobalParams.ModuleCodeForTerritoryGroup, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public PartialViewResult AddEditTerritory(int territoryCode)
        {
            objTerritory = null;
            objTerritory_Service = null;

            if (territoryCode > 0)
                objTerritory = objTerritory_Service.GetById(territoryCode);

            objTerritory.Is_Thetrical = (objTerritory.Is_Thetrical ?? "N");
            List<RightsU_Entities.Country> lstCountry = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y"
                && w.Is_Theatrical_Territory == objTerritory.Is_Thetrical).OrderBy(o => o.Country_Name).ToList();
            var countryCode = objTerritory.Territory_Details.Select(s => s.Country_Code).ToArray();
            ViewBag.CountryList = new MultiSelectList(lstCountry, "Country_Code", "Country_Name", countryCode);
            return PartialView("~/Views/Territory/_AddEditTerritory.cshtml", objTerritory);
        }
        public JsonResult ActiveDeactiveTerritory(int territoryCode, string doActive)
        {
            string status = "S", message = "", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(territoryCode, GlobalParams.ModuleCodeForTerritoryGroup, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Territory_Service objService = new Territory_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Territory objTerritory = objService.GetById(territoryCode);
                objTerritory.Is_Active = doActive;
                objTerritory.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objTerritory, out resultSet);
                if (isValid)
                {
                    string Action = "A";
                    lstTerritory.Where(w => w.Territory_Code == territoryCode).First().Status = doActive;
                    lstTerritory_Searched.Where(w => w.Territory_Code == territoryCode).First().Status = doActive;

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
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objTerritory);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForTerritoryGroup), Convert.ToInt32(objTerritory.Territory_Code), LogData, Action, objLoginUser.Users_Code);
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
        public JsonResult SaveTerritory(FormCollection objCollection)
        {
            string Action = "C";
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (objTerritory.Territory_Code > 0)
            {
                message = objMessageKey.Recordupdatedsuccessfully;
                Action = "U";
            }               

            objTerritory.Territory_Name = Convert.ToString(objCollection["Territory_Name"]).Trim();
            objTerritory.Is_Thetrical = Convert.ToString(objCollection["IsTheatrical"] ?? "N");
            objTerritory.Is_Thetrical = (objTerritory.Is_Thetrical == "N") ? "N" : "Y";

            if (objTerritory.Territory_Code == 0)
            {
                objTerritory.EntityState = State.Added;
                objTerritory.Inserted_On = DateTime.Now;
                objTerritory.Inserted_By = objLoginUser.Users_Code;
                objTerritory.Is_Active = "Y";
            }
            else
                objTerritory.EntityState = State.Modified;

            objTerritory.Last_Updated_Time = DateTime.Now;
            objTerritory.Last_Action_By = objLoginUser.Users_Code;


            ICollection<Territory_Details> countryList = new HashSet<Territory_Details>();
            if (objCollection["ddlCountry"] != null)
            {
                string[] arrCountryCodes = objCollection["ddlCountry"].Split(',');
                foreach (string countryCode in arrCountryCodes)
                {
                    Territory_Details objTD = new Territory_Details();
                    objTD.EntityState = State.Added;
                    objTD.Country_Code = Convert.ToInt32(countryCode);
                    countryList.Add(objTD);
                }
            }
            IEqualityComparer<Territory_Details> comparerTerritory = new LambdaComparer<Territory_Details>((x, y) => x.Country_Code == y.Country_Code && x.EntityState != State.Deleted);
            var Deleted_Territory_Details = new List<Territory_Details>();
            var Updated_Territory_Details = new List<Territory_Details>();
            var Added_Territory_Details = CompareLists<Territory_Details>(countryList.ToList<Territory_Details>(), objTerritory.Territory_Details.ToList<Territory_Details>(), comparerTerritory, ref Deleted_Territory_Details, ref Updated_Territory_Details);

            if ( objTerritory.Acq_Deal_Pushback_Territory.Count>0 ||objTerritory.Acq_Deal_Rights_Territory.Count > 0
                || objTerritory.Syn_Deal_Rights_Territory.Count>0 )
            {
                if (Deleted_Territory_Details.Count > 0)
                {
                    status = "E";
                    message = objMessageKey.TerritoryisalreadyusedYoucannotremoveexistingcountries;
                }
            }

            if (status != "E")
            {
                Added_Territory_Details.ToList<Territory_Details>().ForEach(t => objTerritory.Territory_Details.Add(t));
                Deleted_Territory_Details.ToList<Territory_Details>().ForEach(t => t.EntityState = State.Deleted);
               
                dynamic resultSet;
                if (!objTerritory_Service.Save(objTerritory, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objTerritory);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForTerritoryGroup), Convert.ToInt32(objTerritory.Territory_Code), LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {

                    }

                    int recordLockingCode = Convert.ToInt32(objCollection["hdnRecodLockingCode"]);
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                    objTerritory = null;
                    objTerritory_Service = null;
                    lstTerritory_Searched = lstTerritory = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Territory(objLoginUser.System_Language_Code).OrderBy(o => o.Last_Updated_Time).ToList<RightsU_Entities.USP_List_Territory_Result>();                   
                }
            }
            var obj = new
            {
                RecordCount = lstTerritory_Searched.Count,
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
