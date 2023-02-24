using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Data.SqlClient;
using System.Configuration;

namespace RightsU_Plus.Controllers
{
    public class Acq_SupplementaryMasterController : BaseController
    {
        private List<RightsU_Entities.Supplementary_Config> lstSupplementaryConfig_Searched
        {
            get
            {
                if (Session["Supplementary_Config_Searched"] == null)
                    Session["Supplementary_Config_Searched"] = new List<RightsU_Entities.Supplementary_Config>();
                return (List<RightsU_Entities.Supplementary_Config>)Session["Supplementary_Config_Searched"];
            }
            set { Session["Supplementary_Config_Searched"] = value; }
        }
        private Supplementary_Config_Service objSupplementary_Config_Service
        {
            get
            {
                if (Session["Supplementary_Config_Service"] == null)
                    Session["Supplementary_Config_Service"] = new Supplementary_Config_Service(objLoginEntity.ConnectionStringName);
                return (Supplementary_Config_Service)Session["Supplementary_Config_Service"];
            }
            set { Session["Supplementary_Config_Service"] = value; }
        }

        private List<RightsU_Entities.Supplementary_Tab> lstSupplementaryTab_Searched
        {
            get
            {
                if (Session["lstSupplementaryTab_Searched"] == null)
                    Session["lstSupplementaryTab_Searched"] = new List<RightsU_Entities.Supplementary_Tab>();
                return (List<RightsU_Entities.Supplementary_Tab>)Session["lstSupplementaryTab_Searched"];
            }
            set { Session["lstSupplementaryTab_Searched"] = value; }
        }
        private Supplementary_Tab_Service objSupplementary_Tab_Service
        {
            get
            {
                if (Session["Supplementary_Tab_Service"] == null)
                    Session["Supplementary_Tab_Service"] = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);
                return (Supplementary_Tab_Service)Session["Supplementary_Tab_Service"];
            }
            set { Session["Supplementary_Tab_Service"] = value; }
        }

        private List<RightsU_Entities.Supplementary> lstSupplementary_Searched
        {
            get
            {
                if (Session["Supplementary_Searched"] == null)
                    Session["Supplementary_Searched"] = new List<RightsU_Entities.Supplementary>();
                return (List<RightsU_Entities.Supplementary>)Session["Supplementary_Searched"];
            }
            set { Session["Supplementary_Searched"] = value; }
        }
        private Supplementary_Service objSupplementary_Service
        {
            get
            {
                if (Session["Supplementary_Service"] == null)
                    Session["Supplementary_Service"] = new Supplementary_Service(objLoginEntity.ConnectionStringName);
                return (Supplementary_Service)Session["Supplementary_Service"];
            }
            set { Session["Supplementary_Service"] = value; }
        }

        private List<RightsU_Entities.Supplementary_Data> lstSupplementaryData_Searched
        {
            get
            {
                if (Session["Supplementary_Data_Searched"] == null)
                    Session["Supplementary_Data_Searched"] = new List<RightsU_Entities.Supplementary_Data>();
                return (List<RightsU_Entities.Supplementary_Data>)Session["Supplementary_Data_Searched"];
            }
            set { Session["Supplementary_Data_Searched"] = value; }
        }
        private Supplementary_Data_Service objSupplementary_Data_Service
        {
            get
            {
                if (Session["Supplementary_Data_Service"] == null)
                    Session["Supplementary_Data_Service"] = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName);
                return (Supplementary_Data_Service)Session["Supplementary_Data_Service"];
            }
            set { Session["Supplementary_Data_Service"] = value; }
        }

        //Main index page       
        public ActionResult Index()
        {
            FetchDataConfig();
            FetchDataData();
            FetchData();
            FetchDataTab();

            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            ViewBag.Message = "";
            ViewBag.MessageForTab = "";
            ViewBag.AddTab = "";

            if (TempData["Tab"] != null)
            {
                ViewBag.AddTab = TempData["Tab"];
            }
            if (TempData["Message"] != null)
            {
                ViewBag.Message = TempData["Message"];
            }
            return View("~/Views/Acq_SupplementaryMaster/Acq_SupplementaryMasters.cshtml");
        }

        //To fetch the data from database
        private void FetchDataConfig()
        {
            lstSupplementaryConfig_Searched = objSupplementary_Config_Service.SearchFor(x => true).OrderBy(o => o.Supplementary_Config_Code).Where(a => a.View_Name != null).ToList();
        }

        private void FetchDataData()
        {
            lstSupplementaryData_Searched = objSupplementary_Data_Service.SearchFor(x => true).OrderBy(o => o.Supplementary_Data_Code).Where(a => a.Data_Description != null).ToList();
        }

        private void FetchData()
        {
            lstSupplementary_Searched = objSupplementary_Service.SearchFor(x => true).OrderBy(o => o.Supplementary_Code).Where(a => a.Supplementary_Name != null).ToList();
        }

        private void FetchDataTab()
        {
            lstSupplementaryTab_Searched = objSupplementary_Tab_Service.SearchFor(x => true).OrderBy(o => o.Supplementary_Tab_Code).Where(a => a.Short_Name != null).ToList();
        }

        //To bind the main pages to views
        public PartialViewResult BindSupplementaryConfigList(int pageNo, int recordPerPage, string sortType)
        {
            TempData["Tab"] = "Config";
            List<RightsU_Entities.Supplementary_Config> lst = new List<RightsU_Entities.Supplementary_Config>();
            int RecordCount = 0;
            RecordCount = lstSupplementaryConfig_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstSupplementaryConfig_Searched.OrderBy(o => o.Supplementary_Config_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstSupplementaryConfig_Searched.OrderBy(o => o.Label_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstSupplementaryConfig_Searched.OrderByDescending(o => o.View_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_SupplementaryMaster/_Supplementary_Config.cshtml", lst);
        }
        public PartialViewResult BindSupplementaryTabList(int pageNo, int recordPerPage)
        {
            TempData["Tab"] = "Tab";
            List<RightsU_Entities.Supplementary_Tab> lst = new List<RightsU_Entities.Supplementary_Tab>();
            int RecordCount = 0;
            RecordCount = lstSupplementaryTab_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);

                lst = lstSupplementaryTab_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_SupplementaryMaster/_Supplementary_Tab.cshtml", lst);
        }
        public PartialViewResult BindSupplementaryList(int pageNo, int recordPerPage, string sortType)
        {
            TempData["Tab"] = "Supp";
            List<RightsU_Entities.Supplementary> lst = new List<RightsU_Entities.Supplementary>();
            int RecordCount = 0;
            RecordCount = lstSupplementary_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstSupplementary_Searched.OrderBy(o => o.Supplementary_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstSupplementary_Searched.OrderBy(o => o.Supplementary_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstSupplementary_Searched.OrderByDescending(o => o.Supplementary_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();

            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_SupplementaryMaster/_Supplementary.cshtml", lst);
        }
        public PartialViewResult BindSupplementaryDataList(int pageNo, int recordPerPage, string sortType)
        {
            TempData["Tab"] = "Data";
            List<RightsU_Entities.Supplementary_Data> lst = new List<RightsU_Entities.Supplementary_Data>();
            int RecordCount = 0;
            RecordCount = lstSupplementaryData_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);

                if (sortType == "T")
                    lst = lstSupplementaryData_Searched.OrderBy(o => o.Supplementary_Data_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstSupplementaryData_Searched.OrderBy(o => o.Data_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstSupplementaryData_Searched.OrderByDescending(o => o.Data_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();

            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_SupplementaryMaster/_Supplementary_Data.cshtml", lst);
        }

        //method to give page number in binding method
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCurrency), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
        }

        //SupplementaryTab Tab crud operations
        [HttpGet]
        public ActionResult AddOrEditSupplementaryTab(int id)
        {
            Supplementary_Tab SupplementaryTab = new Supplementary_Tab();
            if (id > 0)
            {
                SupplementaryTab = lstSupplementaryTab_Searched.Where(a => a.Supplementary_Tab_Code == id).FirstOrDefault();
            }
            return View("CreateSupplementaryTab", SupplementaryTab);
        }
        [HttpPost]
        public ActionResult AddOrEditSupplementaryTab(int SupplementaryTabCode, string ShortName, string SupplementaryTabDescription, int OrderNo, string TabType, string EditWindowType, int ModuleCode, int KeyConfigCode, string IsShow)
        {
            objSupplementary_Tab_Service = null;
            Supplementary_Tab SupplementaryTab = new Supplementary_Tab();
            if (SupplementaryTabCode > 0)
            {
                SupplementaryTab = objSupplementary_Tab_Service.GetById(SupplementaryTabCode);
                SupplementaryTab.EntityState = State.Modified;
                SupplementaryTab.Supplementary_Tab_Code = SupplementaryTabCode;
            }
            else
            {
                FetchDataTab();
                SupplementaryTab.Supplementary_Tab_Code = lstSupplementaryTab_Searched.Max(a => a.Supplementary_Tab_Code) + 1;
                //SupplementaryTab.Supplementary_Tab_Code = objSupplementary_Tab_Service.GetById()
                SupplementaryTab.EntityState = State.Added;
            }
            SupplementaryTab.Supplementary_Config = null;
            SupplementaryTab.Supplementary_Tab_Description = SupplementaryTabDescription;
            SupplementaryTab.Order_No = OrderNo;
            SupplementaryTab.Tab_Type = TabType;
            SupplementaryTab.EditWindowType = EditWindowType;
            SupplementaryTab.Module_Code = ModuleCode;
            SupplementaryTab.Short_Name = ShortName;
            SupplementaryTab.Is_Show = IsShow;
            if (KeyConfigCode == 0)
            {
                SupplementaryTab.Key_Config_Code = null;
            }
            else
            {
                SupplementaryTab.Key_Config_Code = KeyConfigCode;
            }
            int Result = 0;
            Result = validationForSupplementaryTab(SupplementaryTab);
            if (Result == 3)
            {
                dynamic resultSet;
                if (objSupplementary_Tab_Service.Save(SupplementaryTab, out resultSet))
                {
                    if (SupplementaryTabCode > 0)
                    {
                        TempData["Message"] = "Supplementary Tab " + objMessageKey.Recordupdatedsuccessfully;
                    }
                    else
                    {
                        TempData["Message"] = "Supplementary Tab " + objMessageKey.RecordAddedSuccessfully;
                    }
                    TempData["Tab"] = "Tab";
                    var obj = new
                    {
                        Status = "S"
                    };
                    return Json(obj);
                }
            }
            else
            {
                TempData["Message"] = "You are trying to insert duplicate data in Supplementary Tab";
                TempData["Tab"] = "Tab";
                var obj = new
                {
                    Status = "S"
                };
                return Json(obj);
            }
            return RedirectToAction("Index");
        }
        public ActionResult DetailsSupplementaryTab(int id)
        {
            Supplementary_Tab SPTab = new Supplementary_Tab();
            //SPTab = lstSupplementaryTab_Searched.Where(a => a.Supplementary_Tab_Code == id).FirstOrDefault();
            SPTab = objSupplementary_Tab_Service.GetById(id);
            ViewBag.Title = "View";
            return View("~/Views/Acq_SupplementaryMaster/CreateSupplementaryTab.cshtml", SPTab);
        }
        public ActionResult DeleteSupplementaryTab(int id)
        {
            objSupplementary_Tab_Service = null;
            Supplementary_Tab SP_Tab = new Supplementary_Tab();
            //SPTab = lstSupplementaryTab_Searched.Where(a => a.Supplementary_Tab_Code == id).FirstOrDefault();
            SP_Tab = objSupplementary_Tab_Service.GetById(id);
            
            SP_Tab.EntityState = State.Deleted;
            dynamic resultset;
            if (objSupplementary_Tab_Service.Delete(SP_Tab, out resultset))
            {
                TempData["Message"] = "Supplementary Tab " + objMessageKey.RecordDeletedsuccessfully;
                TempData["Tab"] = "Tab";
            }
            return RedirectToAction("Index");
        }
        public int validationForSupplementaryTab(Supplementary_Tab Object)
        {
            int Result = 1;
            FetchDataTab();
            if (Object.EntityState == State.Modified)
            {
                foreach (Supplementary_Tab DBObject in lstSupplementaryTab_Searched)
                {
                    if (DBObject.Supplementary_Tab_Description == Object.Supplementary_Tab_Description || DBObject.Short_Name == Object.Short_Name || DBObject.Key_Config_Code == Object.Key_Config_Code || DBObject.Order_No == Object.Order_No)
                    {
                        if (DBObject.Module_Code == Object.Module_Code)
                        {
                            if(DBObject.Supplementary_Tab_Code != Object.Supplementary_Tab_Code)
                            {
                                Result = 6;
                                break;
                            }                                                    
                        }
                    }
                }
                if(Result == 6)
                {
                    Result = 6;
                }
                else
                {
                    Result = 3;
                }
                
            }
            else
            {
                foreach (Supplementary_Tab DBObject in lstSupplementaryTab_Searched)
                {
                    if(DBObject.Supplementary_Tab_Description == Object.Supplementary_Tab_Description || DBObject.Short_Name == Object.Short_Name || DBObject.Key_Config_Code == Object.Key_Config_Code || DBObject.Order_No == Object.Order_No)
                    {
                        if(DBObject.Module_Code == Object.Module_Code)
                        {
                            Result = 6;
                            break;
                        }                       
                    }                                        
                }
                if(Result == 6)
                {
                    Result = 6;
                }
                else
                {
                    Result = 3;
                }
            }
            return Result;
        }

        //Supplementary CRUD Operations
        [HttpGet]
        public ActionResult AddOrEditSupplementary(int id)
        {
            Supplementary SP = new Supplementary();
            if (id > 0)
            {
                SP = lstSupplementary_Searched.Where(a => a.Supplementary_Code == id).FirstOrDefault();
            }
            return View("~/Views/Acq_SupplementaryMaster/CreateSupplementary.cshtml", SP);

        }
        [HttpPost]
        public ActionResult AddOrEditSupplementary(string IsActive, string SupplementaryName, int SupplementaryCode)
        {
            objSupplementary_Service = null;
            Supplementary Supplementary = new Supplementary();
            Supplementary.Is_Active = IsActive;
            Supplementary.Supplementary_Name = SupplementaryName;
            if (SupplementaryCode > 0)
            {
                Supplementary.EntityState = State.Modified;
                Supplementary.Supplementary_Code = SupplementaryCode;
            }
            else
            {
                Supplementary.EntityState = State.Added;
            }
            int Result = 0;
            Result = validationForSupplementary(Supplementary);
            if(Result == 3)
            {
                dynamic resultSet;
                if (objSupplementary_Service.Save(Supplementary, out resultSet))
                {
                    if (SupplementaryCode > 0)
                    {
                        TempData["Message"] = "Supplementary " + objMessageKey.Recordupdatedsuccessfully;
                    }
                    else
                    {
                        TempData["Message"] = "Supplementary " + objMessageKey.RecordAddedSuccessfully;
                    }
                    TempData["Tab"] = "Supp";
                    var obj = new
                    {
                        Status = "S"
                    };
                    return Json(obj);
                }
            }
            else
            {
                TempData["Message"] = "You are trying insert Duplicate Supplementary Name";

                TempData["Tab"] = "Supp";
                var obj = new
                {
                    Status = "S"
                };
                return Json(obj);
            }
            
            return RedirectToAction("Index");
        }
        public ActionResult DetailsSupplementary(int id)
        {
            Supplementary SP = new Supplementary();
            //SP = lstSupplementary.Where(a => a.Supplementary_Code == id).FirstOrDefault();
            SP = objSupplementary_Service.GetById(id);
            ViewBag.Title = "View";
            return View("~/Views/Acq_SupplementaryMaster/CreateSupplementary.cshtml", SP);
        }
        public ActionResult DeleteSupplementary(int id)
        {
            Supplementary SP = new Supplementary();
            //SP = lstSupplementary.Where(a => a.Supplementary_Code == id).FirstOrDefault();
            SP = objSupplementary_Service.GetById(id);
            SP.EntityState = State.Deleted;
            dynamic resultset;

            if (objSupplementary_Service.Delete(SP, out resultset))
            {
                TempData["Message"] = "Supplementary " + objMessageKey.RecordDeletedsuccessfully;
                TempData["Tab"] = "Supp";
            }
            return RedirectToAction("Index");
        }
        public int validationForSupplementary(Supplementary Object)
        {
            int Result = 1;
            FetchData();
            if(Object.EntityState == State.Modified)
            {
                foreach (Supplementary DBObject in lstSupplementary_Searched)
                {
                    if (DBObject.Supplementary_Name == Object.Supplementary_Name)
                    {
                        if(DBObject.Supplementary_Code != Object.Supplementary_Code)
                        {
                            Result = 6;
                        }                        
                    }
                }
                if (Result == 6)
                {
                    Result = 6;
                }
                else
                {
                    Result = 3;
                }
            }
            else
            {
                foreach (Supplementary DBObject in lstSupplementary_Searched)
                {
                    if (DBObject.Supplementary_Name == Object.Supplementary_Name)
                    {
                        Result = 6;
                    }
                }
                if (Result == 6)
                {
                    Result = 6;
                }
                else
                {
                    Result = 3;
                }
            }           
            return Result;
        }

        //Supplementary_Data Tab Crud Operations 
        [HttpGet]
        public ActionResult AddOrEditSupplementaryData(int id)
        {
            Supplementary_Data SPData = new Supplementary_Data();
            if (id > 0)
            {
                SPData = objSupplementary_Data_Service.GetById(id);
            }
            return View("~/Views/Acq_SupplementaryMaster/CreateSupplementaryData.cshtml", SPData);
        }
        [HttpPost]
        public ActionResult AddOrEditSupplementaryData(string IsActive, int SupplementaryDataCode, string SupplementaryType, string DataDescription)
        {
            objSupplementary_Data_Service = null;
            Supplementary_Data SupplementaryData = new Supplementary_Data();

            SupplementaryData.Is_Active = "Y";

            SupplementaryData.Supplementary_Type = SupplementaryType;
            SupplementaryData.Data_Description = DataDescription;
            if (SupplementaryDataCode > 0)
            {
                SupplementaryData.EntityState = State.Modified;
                SupplementaryData.Supplementary_Data_Code = SupplementaryDataCode;
            }
            else
            {
                SupplementaryData.EntityState = State.Added;
            }
            int Result = 1;
            Result = validationForSupplementaryData(SupplementaryData);
            if (Result == 3)
            {
                dynamic resultSet;
                if (objSupplementary_Data_Service.Save(SupplementaryData, out resultSet))
                {
                    if (SupplementaryDataCode > 0)
                    {
                        TempData["Message"] = "Supplementary Data " + objMessageKey.Recordupdatedsuccessfully;
                    }
                    else
                    {
                        TempData["Message"] = "Supplementary Data " + objMessageKey.RecordAddedSuccessfully;
                    }
                    TempData["Tab"] = "Data";
                    var obj = new
                    {
                        Status = "S"
                    };
                    return Json(obj);
                }
            }
            else
            {
                TempData["Message"] = "Supplementary Data " + objMessageKey.ShowError;
                TempData["Tab"] = "Data";
                var obj = new
                {
                    Status = "S"
                };
                return Json(obj);
            }
            
            return RedirectToAction("Index");
        }
        public ActionResult DetailsSupplementaryData(int id)
        {
            Supplementary_Data SPData = new Supplementary_Data();
            //SPData = lstSupplementaryData_Searched.Where(a => a.Supplementary_Data_Code == id).FirstOrDefault();
            SPData = objSupplementary_Data_Service.GetById(id);
            ViewBag.Title = "View";
            return View("~/Views/Acq_SupplementaryMaster/CreateSupplementaryData.cshtml", SPData);
        }
        public ActionResult DeleteSupplementaryData(int id)
        {
            Supplementary_Data SPData = new Supplementary_Data();
            //SPData = lstSupplementaryData_Searched.Where(a => a.Supplementary_Data_Code == id).FirstOrDefault();
            SPData = objSupplementary_Data_Service.GetById(id);
            SPData.EntityState = State.Deleted;
            dynamic resultset;

            if (objSupplementary_Data_Service.Delete(SPData, out resultset))
            {
                TempData["Message"] = "Supplementary Data " + objMessageKey.RecordDeletedsuccessfully;
                TempData["Tab"] = "Data";
            }
            return RedirectToAction("Index");
        }
        public int validationForSupplementaryData(Supplementary_Data Object)
        {
            int Result = 1;
            FetchData();
            if (Object.EntityState == State.Modified)
            {
                foreach (Supplementary_Data DBObject in lstSupplementaryData_Searched)
                {
                    if (DBObject.Data_Description == Object.Data_Description)
                    {
                        if(DBObject.Supplementary_Data_Code != Object.Supplementary_Data_Code)
                        {
                            Result = 6;
                        }                        
                    }
                }
                if (Result == 6)
                {
                    Result = 6;
                }
                else
                {
                    Result = 3;
                }
            }
            else
            {
                foreach(Supplementary_Data DBObject in lstSupplementaryData_Searched)
                {
                    if(DBObject.Data_Description == Object.Data_Description)
                    {
                        Result = 6;
                    }
                }
                if(Result == 6)
                {
                    Result = 6;
                }
                else
                {
                    Result = 3;
                }
            }
            return Result;
        }
        //Search Function for Rights_U Ribbon search
        public JsonResult SearchConfig(string searchText, string TabValue)
        {
            int Record_Count = 0;
            if (!string.IsNullOrEmpty(searchText) && TabValue == "Tab")
            {
                FetchDataTab();
                lstSupplementaryTab_Searched = lstSupplementaryTab_Searched.Where(w => w.Supplementary_Tab_Description.ToUpper().Contains(searchText.ToUpper())).ToList();
                Record_Count = lstSupplementaryTab_Searched.Count;
            }
            else if (searchText == "" && TabValue == "Tab")
            {
                FetchDataTab();
                Record_Count = lstSupplementaryTab_Searched.Count;
            }
            if (!string.IsNullOrEmpty(searchText) && TabValue == "ConfigTab")
            {
                FetchDataConfig();
                lstSupplementaryConfig_Searched = lstSupplementaryConfig_Searched.Where(w => w.Supplementary_Tab.Supplementary_Tab_Description.ToUpper().Contains(searchText.ToUpper())).ToList();

                Record_Count = lstSupplementaryConfig_Searched.Count;
            }
            else if (searchText == "" && TabValue == "ConfigTab")
            {
                FetchDataConfig();
                Record_Count = lstSupplementaryConfig_Searched.Count;
            }
            if (!string.IsNullOrEmpty(searchText) && TabValue == "DataTab")
            {
                FetchDataData();
                lstSupplementaryData_Searched = lstSupplementaryData_Searched.Where(w => w.Data_Description.ToUpper().Contains(searchText.ToUpper())).ToList();
                Record_Count = lstSupplementaryData_Searched.Count;
            }
            else if (searchText == "" && TabValue == "DataTab")
            {
                FetchDataData();
                Record_Count = lstSupplementaryData_Searched.Count;
            }
            if (!string.IsNullOrEmpty(searchText) && TabValue == "SuppTab")
            {
                FetchData();
                lstSupplementary_Searched = lstSupplementary_Searched.Where(w => w.Supplementary_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
                Record_Count = lstSupplementary_Searched.Count;
            }
            else if (searchText == "" && TabValue == "SuppTab")
            {
                FetchData();
                Record_Count = lstSupplementary_Searched.Count;
            }
            var obj = new
            {
                Record_Count = Record_Count
            };
            return Json(obj);
        }

        //SupplementaryConfig crud operations
        [HttpGet]
        public ActionResult AddOrEditSupplementaryConfig(int id)
        {
            Supplementary_Config SPConfig = new Supplementary_Config();
            if (id > 0)
            {
                SPConfig = objSupplementary_Config_Service.GetById(id);
                ViewBag.Tab = new SelectList(lstSupplementaryTab_Searched, "Supplementary_Tab_Code", "Supplementary_Tab_Description", SPConfig.Supplementary_Tab.Supplementary_Tab_Code);
                ViewBag.Supp = new SelectList(lstSupplementary_Searched, "Supplementary_Code", "Supplementary_Name", SPConfig.Supplementary.Supplementary_Code);
            }
            else
            {
                ViewBag.Tab = new SelectList(lstSupplementaryTab_Searched, "Supplementary_Tab_Code", "Supplementary_Tab_Description");
                ViewBag.Supp = new SelectList(lstSupplementary_Searched, "Supplementary_Code", "Supplementary_Name");
            }

            return PartialView("~/Views/Acq_SupplementaryMaster/CreateSupplementaryConfig.cshtml", SPConfig);
        }
        [HttpPost]
        public ActionResult AddOrEditSupplementaryConfig(int SupplementaryConfigCode, int SupplementaryCode, int SupplementaryTabCode, string PageGroup, string LabelName, string ControlType, string IsMandatory, string IsMultiselect, int MaxLength, int PageControlOrder, int ControlFieldOrder, string DefaultValues, string ViewName, string TextField, string ValueField, string WhrCriteria)
        {
            objSupplementary_Config_Service = null;
            int SuppCode = Convert.ToInt32(SupplementaryCode);
            int SuppTabCode = Convert.ToInt32(SupplementaryTabCode);
            Supplementary_Config SupplementaryConfig = new Supplementary_Config();
            if (SupplementaryConfigCode > 0)
            {
                SupplementaryConfig.Supplementary_Config_Code = SupplementaryConfigCode;
                SupplementaryConfig = objSupplementary_Config_Service.GetById(SupplementaryConfigCode);
                SupplementaryConfig.EntityState = State.Modified;
                SupplementaryConfig.Supplementary_Config_Code = SupplementaryConfigCode;
            }
            else
            {
                SupplementaryConfig.EntityState = State.Added;
            }

            SupplementaryConfig.Page_Group = PageGroup;
            SupplementaryConfig.Label_Name = LabelName;
            SupplementaryConfig.Control_Type = ControlType;
            SupplementaryConfig.Is_Mandatory = IsMandatory;
            SupplementaryConfig.Is_Multiselect = IsMultiselect;
            SupplementaryConfig.Page_Control_Order = PageControlOrder;
            SupplementaryConfig.Control_Field_Order = ControlFieldOrder;
            SupplementaryConfig.Default_Values = DefaultValues;
            SupplementaryConfig.View_Name = ViewName;
            SupplementaryConfig.Text_Field = TextField;
            SupplementaryConfig.Value_Field = ValueField;
            SupplementaryConfig.Whr_Criteria = WhrCriteria;
            SupplementaryConfig.Supplementary_Code = SupplementaryCode;
            SupplementaryConfig.Supplementary_Tab_Code = SupplementaryTabCode;

            if (MaxLength == 0)
            {
                SupplementaryConfig.Max_Length = null;
            }
            else
            {
                SupplementaryConfig.Max_Length = MaxLength;
            }
            dynamic resultset;
            if (objSupplementary_Config_Service.Save(SupplementaryConfig, out resultset))
            {
                if (SupplementaryConfigCode > 0)
                {
                    TempData["Message"] = "Supplementary Config " + objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    TempData["Message"] = "Supplementary Config " + objMessageKey.RecordAddedSuccessfully;
                }
                TempData["Tab"] = "Config";
                var obj = new
                {
                    Status = "S"
                };
                return Json(obj);
            }
            return RedirectToAction("Index");
        }
        public ActionResult DetailsSupplementaryConfig(int id)
        {
            Supplementary_Config SPConfig = new Supplementary_Config();
            //SPConfig = lstSupplementaryConfig_Searched.Where(a => a.Supplementary_Config_Code == id).FirstOrDefault();
            SPConfig = objSupplementary_Config_Service.GetById(id);
            ViewBag.Title = "View";
            return View("~/Views/Acq_SupplementaryMaster/CreateSupplementaryConfig.cshtml", SPConfig);
        }
        public ActionResult DeleteSupplementaryConfig(int id)
        {
            Supplementary_Config SPConfig = new Supplementary_Config();
            //SPConfig = lstSupplementaryConfig_Searched.Where(a => a.Supplementary_Config_Code == id).FirstOrDefault();
            SPConfig = objSupplementary_Config_Service.GetById(id);
            SPConfig.EntityState = State.Deleted;
            dynamic resultset;
            if (objSupplementary_Config_Service.Delete(SPConfig, out resultset))
            {
                TempData["Message"] = "Supplementary Config " + objMessageKey.RecordDeletedsuccessfully;
            }
            return RedirectToAction("Index");
        }        
    }
}



