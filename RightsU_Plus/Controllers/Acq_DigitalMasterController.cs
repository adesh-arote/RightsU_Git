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
    public class Acq_DigitalMasterController : BaseController
    {
        //Sessions to interact with database
        private List<RightsU_Entities.Digital_Config> lstDigitalConfig_Searched
        {
            get
            {
                if (Session["Digital_Config_Searched"] == null)
                    Session["Digital_Config_Searched"] = new List<RightsU_Entities.Digital_Config>();
                return (List<RightsU_Entities.Digital_Config>)Session["Digital_Config_Searched"];
            }
            set { Session["Digital_Config_Searched"] = value; }
        }
        private Digital_Config_Service objDigital_Config_Service
        {
            get
            {
                if (Session["Digital_Config_Service"] == null)
                    Session["Digital_Config_Service"] = new Digital_Config_Service(objLoginEntity.ConnectionStringName);
                return (Digital_Config_Service)Session["Digital_Config_Service"];
            }
            set { Session["Digital_Config_Service"] = value; }
        }

        private List<RightsU_Entities.Digital_Tab> lstDigitalTab_Searched
        {
            get
            {
                if (Session["lstDigitalTab_Searched"] == null)
                    Session["lstDigitalTab_Searched"] = new List<RightsU_Entities.Digital_Tab>();
                return (List<RightsU_Entities.Digital_Tab>)Session["lstDigitalTab_Searched"];
            }
            set { Session["lstDigitalTab_Searched"] = value; }
        }
        private Digital_Tab_Service objDigital_Tab_Service
        {
            get
            {
                if (Session["Digital_Tab_Service"] == null)
                    Session["Digital_Tab_Service"] = new Digital_Tab_Service(objLoginEntity.ConnectionStringName);
                return (Digital_Tab_Service)Session["Digital_Tab_Service"];
            }
            set { Session["Digital_Tab_Service"] = value; }
        }

        private List<RightsU_Entities.Digital> lstDigital_Searched
        {
            get
            {
                if (Session["Digital_Searched"] == null)
                    Session["Digital_Searched"] = new List<RightsU_Entities.Digital>();
                return (List<RightsU_Entities.Digital>)Session["Digital_Searched"];
            }
            set { Session["Digital_Searched"] = value; }
        }        
        private Digital_Service objDigital_Service
        {
            get
            {
                if (Session["Digital_Service"] == null)
                    Session["Digital_Service"] = new Digital_Service(objLoginEntity.ConnectionStringName);
                return (Digital_Service)Session["Digital_Service"];
            }
            set { Session["Digital_Service"] = value; }
        }

        private List<RightsU_Entities.Digital_Data> lstDigitalData_Searched
        {
            get
            {
                if (Session["Digital_Data_Searched"] == null)
                    Session["Digital_Data_Searched"] = new List<RightsU_Entities.Digital_Data>();
                return (List<RightsU_Entities.Digital_Data>)Session["Digital_Data_Searched"];
            }
            set { Session["Digital_Data_Searched"] = value; }
        }        
        private Digital_Data_Service objDigital_Data_Service
        {
            get
            {
                if (Session["Digital_Data_Service"] == null)
                    Session["Digital_Data_Service"] = new Digital_Data_Service(objLoginEntity.ConnectionStringName);
                return (Digital_Data_Service)Session["Digital_Data_Service"];
            }
            set { Session["Digital_Data_Service"] = value; }
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
            
            if (TempData["Tab"] != null)
            {
                ViewBag.AddTab = TempData["Tab"];                
            }
            else
            {
                ViewBag.AddTab = "";
            }
            if (TempData["Message"] != null)
            {
                ViewBag.Message = TempData["Message"];
                TempData["Message"] = null;
            }
            return View("~/Views/Acq_DigitalMaster/Acq_DigitalMaster.cshtml");
        }

        //To fetch the data from database
        private void FetchDataConfig()
        {
            lstDigitalConfig_Searched  = objDigital_Config_Service.SearchFor(x => true).OrderBy(o => o.Digital_Config_Code).Where(a => a.View_Name != null).ToList();
        }
        private void FetchDataData()
        {
            lstDigitalData_Searched = objDigital_Data_Service.SearchFor(x => true).OrderBy(o => o.Digital_Data_Code).Where(a => a.Data_Description != null).ToList();
        }
        private void FetchData()
        {
            lstDigital_Searched = objDigital_Service.SearchFor(x => true).OrderBy(o => o.Digital_Code).Where(a => a.Digital_Name != null).ToList();
        }
        private void FetchDataTab()
        {
            lstDigitalTab_Searched  = objDigital_Tab_Service.SearchFor(x => true).OrderBy(o => o.Digital_Tab_Code).Where(a => a.Short_Name != null).ToList();
        }

        //To bind the main pages to views

        public PartialViewResult BindDigitalConfigList(int pageNo, int recordPerPage, string sortType)
        {            
            TempData["Tab"] = "Config";
            List<RightsU_Entities.Digital_Config> lst = new List<RightsU_Entities.Digital_Config>();
            int RecordCount = 0;
            RecordCount = lstDigitalConfig_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstDigitalConfig_Searched.OrderBy(o => o.Digital_Config_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstDigitalConfig_Searched.OrderBy(o => o.Label_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstDigitalConfig_Searched.OrderByDescending(o => o.View_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();               
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_DigitalMaster/_Digital_Config.cshtml", lst);
        }
        public PartialViewResult BindDigitalTabList(int pageNo, int recordPerPage)
        {           
            TempData["Tab"] = "Tab";
            List<RightsU_Entities.Digital_Tab> lst = new List<RightsU_Entities.Digital_Tab>();
            int RecordCount = 0;
            RecordCount = lstDigitalTab_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                
                lst = lstDigitalTab_Searched.Take(noOfRecordTake).Skip(noOfRecordSkip).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_DigitalMaster/_Digital_Tab.cshtml", lst);
        }
        public PartialViewResult BindDigitalList(int pageNo, int recordPerPage, string sortType)
        {           
            TempData["Tab"] = "Digi";
            List<RightsU_Entities.Digital> lst = new List<RightsU_Entities.Digital>();
            int RecordCount = 0;
            RecordCount = lstDigital_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstDigital_Searched.OrderBy(o => o.Digital_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstDigital_Searched.OrderBy(o => o.Digital_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstDigital_Searched.OrderByDescending(o => o.Digital_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
               
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_DigitalMaster/_Digital.cshtml", lst);
        }
        public PartialViewResult BindDigitalDataList(int pageNo, int recordPerPage, string sortType)
        {            
            TempData["Tab"] = "Data";
            List<RightsU_Entities.Digital_Data> lst = new List<RightsU_Entities.Digital_Data>();
            int RecordCount = 0;
            RecordCount = lstDigitalData_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);

                if (sortType == "T")
                    lst = lstDigitalData_Searched.OrderBy(o => o.Digital_Data_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstDigitalData_Searched.OrderBy(o => o.Data_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstDigitalData_Searched.OrderByDescending(o => o.Data_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Acq_DigitalMaster/_Digital_Data.cshtml", lst);
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

        //Digital Tab crud operations
        [HttpGet]
        public ActionResult AddOrEditDigitalTab(int id)
        {
            Digital_Tab SPTab = new Digital_Tab();
            if (id > 0)
            {               
                SPTab = lstDigitalTab_Searched.Where(a => a.Digital_Tab_Code == id).FirstOrDefault();
            }
            
            return View("~/Views/Acq_DigitalMaster/_AddEditView_Digital_Tab.cshtml", SPTab);
        }    
        [HttpPost]
        public ActionResult AddOrEditDigitalTab(int DigitalTabCode, string ShortName, string DigitalTabDescription, int OrderNo, string TabType, string EditWindowType, int ModuleCode, int KeyConfigCode, string IsShow)
        {
            objDigital_Tab_Service = null;
            Digital_Tab DigitalTab = new Digital_Tab();
            if (DigitalTabCode > 0)
            {
                DigitalTab.EntityState = State.Modified;
                DigitalTab.Digital_Tab_Code = DigitalTabCode;
            }
            else
            {
                DigitalTab.EntityState = State.Added;
            }
            DigitalTab.Digital_Config = null;
            DigitalTab.Digital_Tab_Description = DigitalTabDescription;
            DigitalTab.Order_No = OrderNo;
            DigitalTab.Tab_Type = TabType;
            DigitalTab.EditWindowType = EditWindowType;
            DigitalTab.Module_Code = ModuleCode;
            DigitalTab.Short_Name = ShortName;
            DigitalTab.Is_Show = IsShow;
            if (KeyConfigCode == 0)
            {
                DigitalTab.Key_Config_Code = null;
            }
            else
            {
                DigitalTab.Key_Config_Code = KeyConfigCode;
            }
            //DigitalTab.EntityState = State.Modified;
            int Result = 0;
            Result = validationForDigitalTab(DigitalTab);
            if(Result == 3)
            {
                dynamic resultSet;
                if (objDigital_Tab_Service.Save(DigitalTab, out resultSet))
                {
                    if(DigitalTabCode > 0)
                    {
                        TempData["Message"] = "Digital Tab " + objMessageKey.Recordupdatedsuccessfully;
                    }
                    else
                    {
                        TempData["Message"] = "Digital Tab " + objMessageKey.RecordAddedSuccessfully;
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
                TempData["Message"] = "You're trying to insert duplicate Digital Tab data";
                TempData["Tab"] = "Tab";
                var obj = new
                {
                    Status = "S"
                };
                return Json(obj);
            }
            return View();
        }
        public ActionResult DetailsTab(int id)
        {           
            Digital_Tab SPTab = new Digital_Tab();            
            SPTab = objDigital_Tab_Service.GetById(id);
            ViewBag.Title = "View";
            return View("~/Views/Acq_DigitalMaster/_AddEditView_Digital_Tab.cshtml", SPTab);
        }
        public ActionResult DeleteTab(int id)
        {
            Digital_Tab SPTab = new Digital_Tab();
            
            SPTab = objDigital_Tab_Service.GetById(id);
            SPTab.EntityState = State.Deleted;
            dynamic resultset;
            if (objDigital_Tab_Service.Delete(SPTab, out resultset))
            {
                TempData["Message"] = "Digital Tab " + objMessageKey.RecordDeletedsuccessfully;
                TempData["Tab"] = "Tab";
            }
            return RedirectToAction("Index");
        }
        public int validationForDigitalTab(Digital_Tab Object)
        {
            int Result = 1;
            FetchDataTab();
            if (Object.EntityState == State.Modified)
            {
                foreach (Digital_Tab DBObject in lstDigitalTab_Searched)
                {
                    if (DBObject.Digital_Tab_Description == Object.Digital_Tab_Description || DBObject.Short_Name == Object.Short_Name || DBObject.Key_Config_Code == Object.Key_Config_Code || DBObject.Order_No == Object.Order_No)
                    {
                        if (DBObject.Module_Code == Object.Module_Code)
                        {
                            if (DBObject.Digital_Tab_Code != Object.Digital_Tab_Code)
                            {
                                Result = 6;
                                break;
                            }
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
                foreach (Digital_Tab DBObject in lstDigitalTab_Searched)
                {
                    if (DBObject.Digital_Tab_Description == Object.Digital_Tab_Description || DBObject.Short_Name == Object.Short_Name || DBObject.Key_Config_Code == Object.Key_Config_Code || DBObject.Order_No == Object.Order_No)
                    {
                        if (DBObject.Module_Code == Object.Module_Code)
                        {
                            Result = 6;
                            break;
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
            return Result;
        }
        //Digital CRUD Operations
        [HttpGet]
        public ActionResult AddOrEditDigital(int id)
        {           
            Digital SP = new Digital();
            if (id > 0) {
                SP = objDigital_Service.GetById(id);
            }           
            return View("~/Views/Acq_DigitalMaster/_AddEditView_Digital.cshtml", SP);
        }
        [HttpPost]
        public ActionResult AddOrEditDigital(string IsActive, string DigitalName, int DigitalCode)
        {
            objDigital_Service = null;
            Digital Digital = new Digital();
            Digital.Is_Active = IsActive;
            
            Digital.Digital_Name = DigitalName;
            if(DigitalCode > 0)
            {
                Digital.Digital_Code = DigitalCode;
                Digital.EntityState = State.Modified;
            }
            else
            {
                Digital.EntityState = State.Added;
            }
            int Result = 0;
            Result = validationForDigital(Digital);
            if (Result == 3)
            {
                dynamic resultSet;
                if (objDigital_Service.Save(Digital, out resultSet))
                {
                    if(DigitalCode > 0)
                    {
                        TempData["Message"] = "Digital " + objMessageKey.Recordupdatedsuccessfully;
                    }
                    else
                    {
                        TempData["Message"] = "Digital " + objMessageKey.RecordAddedSuccessfully;
                    }
                    TempData["Tab"] = "Digi";
                    var obj = new
                    {
                        Status = "S"
                    };
                    return Json(obj);
                }
            }
            else
            {
                TempData["Message"] = "You're trying to insert duplicate Digital data";
                TempData["Tab"] = "Digi";
                var obj = new
                {
                    Status = "S"
                };
                return Json(obj);
            }
            
            return View();
        }
        public ActionResult DetailsDigital(int id)
        {
            Digital SP = new Digital();           
            SP = objDigital_Service.GetById(id);
            ViewBag.Title = "View";
            return View("~/Views/Acq_DigitalMaster/_AddEditView_Digital.cshtml", SP);
        }
        public ActionResult Delete(int id)
        {
            Digital SP = new Digital();            
            SP = objDigital_Service.GetById(id);
            SP.EntityState = State.Deleted;
            dynamic resultset;

            if (objDigital_Service.Delete(SP, out resultset))
            {
                TempData["Message"] = "Digital " + objMessageKey.RecordDeletedsuccessfully;
                TempData["Tab"] = "Digi";
            }
            return RedirectToAction("Index");            
        }
        public int validationForDigital(Digital Object)
        {
            int Result = 1;
            FetchData();
            if (Object.EntityState == State.Modified)
            {
                foreach (Digital DBObject in lstDigital_Searched)
                {
                    if (DBObject.Digital_Name == Object.Digital_Name)
                    {
                        if (DBObject.Digital_Code != Object.Digital_Code)
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
                foreach (Digital DBObject in lstDigital_Searched)
                {
                    if (DBObject.Digital_Name == Object.Digital_Name)
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

        //Digital_Data Tab Crud Operations 
        [HttpGet]
        public ActionResult AddOrEditDigitalData(int id)
        {
            Digital_Data DigiData = new Digital_Data();
            if (id > 0)
            {
                DigiData = objDigital_Data_Service.GetById(id);
            }
            
            return View("~/Views/Acq_DigitalMaster/_AddEditView_Digital_Data.cshtml", DigiData);
        }
        [HttpPost]
        public ActionResult AddOrEditDigitalData(string IsActive, int DigitalDataCode, string DigitalType, string DataDescription)
        {
            objDigital_Data_Service = null;
            Digital_Data DigitalData = new Digital_Data();

            DigitalData.Is_Active = IsActive;
            if(DigitalDataCode > 0)
            {
                DigitalData.Digital_Data_Code = DigitalDataCode;
                DigitalData.EntityState = State.Modified;
            }
            else
            {
                DigitalData.EntityState = State.Added;
            }
            DigitalData.Digital_Type = DigitalType;
            DigitalData.Data_Description = DataDescription;

            int Result = 0;
            Result = validationForDigitalData(DigitalData);
            if(Result == 3)
            {
                dynamic resultSet;
                if (objDigital_Data_Service.Save(DigitalData, out resultSet))
                {
                    if(DigitalDataCode > 0)
                    {
                        TempData["Message"] = "Digital Data " + objMessageKey.Recordupdatedsuccessfully;
                    }
                    else
                    {
                        TempData["Message"] = "Digital Data " + objMessageKey.RecordAddedSuccessfully;
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
                TempData["Message"] = "You're trying to insert duplicate data in Digital Data";
                var obj = new
                {
                    Status = "S"
                };
                return Json(obj);
            }
            return View();
        }
        public ActionResult DetailsData(int id)
        {
            Digital_Data SPData = new Digital_Data();            
            SPData = objDigital_Data_Service.GetById(id);
            ViewBag.Title = "View";
            return View("~/Views/Acq_DigitalMaster/_AddEditView_Digital_Data.cshtml", SPData);
        }
        public ActionResult DeleteData(int id)
        {
            Digital_Data SPData = new Digital_Data();            
            SPData = objDigital_Data_Service.GetById(id);
            SPData.EntityState = State.Deleted;
            dynamic resultset;

            if (objDigital_Data_Service.Delete(SPData, out resultset))
            {
                TempData["Message"] = "Digital Data " + objMessageKey.RecordDeletedsuccessfully;
                TempData["Tab"] = "Data";
            }
            return RedirectToAction("Index");
            //return View("~/Views/Acq_SupplementaryMaster/Acq_SupplementaryMasters.cshtml");
        }
        public int validationForDigitalData(Digital_Data Object)
        {
            int Result = 1;
            FetchData();
            if (Object.EntityState == State.Modified)
            {
                foreach (Digital_Data DBObject in lstDigitalData_Searched)
                {
                    if (DBObject.Data_Description == Object.Data_Description)
                    {
                        if (DBObject.Digital_Data_Code != Object.Digital_Data_Code)
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
                foreach (Digital_Data DBObject in lstDigitalData_Searched)
                {
                    if (DBObject.Data_Description == Object.Data_Description)
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

        //Search Method for Rights_U Ribbon
        public JsonResult SearchConfig(string searchText, string TabValue)
        {
            int Record_Count = 0;

            if (!string.IsNullOrEmpty(searchText) && TabValue == "Tab")
            {
                FetchDataTab();
                lstDigitalTab_Searched = lstDigitalTab_Searched.Where(w => w.Digital_Tab_Description.ToUpper().Contains(searchText.ToUpper())).ToList();
                Record_Count = lstDigitalTab_Searched.Count;
            }
            else if (searchText == "" && TabValue == "Tab")
            {
                FetchDataTab();
                Record_Count = lstDigitalTab_Searched.Count;
            }
            if (!string.IsNullOrEmpty(searchText) && TabValue == "ConfigTab")
            {
                FetchDataConfig();
                lstDigitalConfig_Searched = lstDigitalConfig_Searched.Where(w => w.Digital_Tab.Digital_Tab_Description.ToUpper().Contains(searchText.ToUpper())).ToList();
                Record_Count = lstDigitalConfig_Searched.Count;
            }
            else if (searchText == "" && TabValue == "ConfigTab")
            {               
                FetchDataConfig();
                Record_Count = lstDigitalConfig_Searched.Count;
            }
            if (!string.IsNullOrEmpty(searchText) && TabValue == "DataTab")
            {
                FetchDataData();
                lstDigitalData_Searched = lstDigitalData_Searched.Where(w => w.Data_Description.ToUpper().Contains(searchText.ToUpper())).ToList();
                Record_Count = lstDigitalData_Searched.Count;
            }
            else if (searchText == "" && TabValue == "DataTab")
            {              
                FetchDataData();
                Record_Count = lstDigitalData_Searched.Count;
            }

            if (!string.IsNullOrEmpty(searchText) && TabValue == "DigiTab")
            {
                FetchData();
                lstDigital_Searched = lstDigital_Searched.Where(w => w.Digital_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
                Record_Count = lstDigital_Searched.Count;
            }
            else if (searchText == "" && TabValue == "DigiTab")
            {               
                FetchData();
                Record_Count = lstDigital_Searched.Count;
            }

            var obj = new
            {
                Record_Count = Record_Count
            };

            return Json(obj);
        }

        //DigitalConfig crud operations
        [HttpGet]
        public ActionResult AddOrEditDigitalConfig(int id)
        {
            Digital_Config SPConfig = new Digital_Config();
            if (id > 0)
            {
                SPConfig = objDigital_Config_Service.GetById(id);
                ViewBag.Tab = new SelectList(lstDigitalTab_Searched, "Digital_Tab_Code", "Digital_Tab_Description", SPConfig.Digital_Tab.Digital_Tab_Code);
                ViewBag.Digi = new SelectList(lstDigital_Searched, "Digital_Code", "Digital_Name", SPConfig.Digital.Digital_Code);
            }
            else
            {
                ViewBag.Tab = new SelectList(lstDigitalTab_Searched, "Digital_Tab_Code", "Digital_Tab_Description");
                ViewBag.Digi = new SelectList(lstDigital_Searched, "Digital_Code", "Digital_Name");
            }
                      
            return PartialView("~/Views/Acq_DigitalMaster/_AddEditView_Digital_Config.cshtml", SPConfig);
        }
        [HttpPost]
        public ActionResult AddOrEditDigitalConfig(int DigitalConfigCode, int DigitalCode, int DigitalTabCode, string PageGroup, string LabelName, string ControlType, string IsMandatory, string IsMultiselect, int MaxLength, int PageControlOrder, int ControlFieldOrder, string DefaultValues, string ViewName, string TextField, string ValueField, string WhrCriteria)
        {
            objDigital_Config_Service = null;
            Digital_Config DigitalConfig = new Digital_Config();
            int DigiCode = Convert.ToInt32(DigitalCode);
            int DigiTabCode = Convert.ToInt32(DigitalTabCode);
            if(DigitalConfigCode > 0)
            {
                DigitalConfig = objDigital_Config_Service.GetById(DigitalConfigCode);
                DigitalConfig.Digital_Config_Code = DigitalConfigCode;
                DigitalConfig.EntityState = State.Modified;
            }
            else
            {
                DigitalConfig.EntityState = State.Added;
            }
            if (MaxLength == 0)
            {
                DigitalConfig.Max_Length = null;
            }
            else
            {
                DigitalConfig.Max_Length = MaxLength;
            }                       
            DigitalConfig.Page_Group = PageGroup;
            DigitalConfig.Label_Name = LabelName;
            DigitalConfig.Control_Type = ControlType;
            DigitalConfig.Is_Mandatory = IsMandatory;
            DigitalConfig.Is_Multiselect = IsMultiselect;
            DigitalConfig.Page_Control_Order = PageControlOrder;
            DigitalConfig.Control_Field_Order = ControlFieldOrder;
            DigitalConfig.Default_Values = DefaultValues;
            DigitalConfig.View_Name = ViewName;
            DigitalConfig.Text_Field = TextField;
            DigitalConfig.Value_Field = ValueField;
            DigitalConfig.Whr_Criteria = WhrCriteria;
            DigitalConfig.Digital_Code = DigitalCode;
            DigitalConfig.Digital_Tab_Code = DigitalTabCode;

            dynamic resultset;
            if (objDigital_Config_Service.Save(DigitalConfig, out resultset))
            {
                TempData["Message"] = "Digital Config " + objMessageKey.Recordupdatedsuccessfully;
                TempData["Tab"] = "Config";

                var obj = new
                {
                    Status = "S"
                };
                return Json(obj);
            }
            return View();
        }
        public ActionResult DetailsConfig(int id)
        {
            Digital_Config SPConfig = new Digital_Config();            
            SPConfig = objDigital_Config_Service.GetById(id);
            ViewBag.Title = "View";
            return View("~/Views/Acq_DigitalMaster/_AddEditView_Digital_Config.cshtml", SPConfig);
        }
        public ActionResult DeleteConfig(int id)
        {
            Digital_Config SPConfig = new Digital_Config();
            //SPConfig = lstSupplementaryConfig_Searched.Where(a => a.Supplementary_Config_Code == id).FirstOrDefault();
            SPConfig = objDigital_Config_Service.GetById(id);
            SPConfig.EntityState = State.Deleted;
            dynamic resultset;
            if (objDigital_Config_Service.Delete(SPConfig, out resultset))
            {
                TempData["Message"] = "Digital Config " + objMessageKey.RecordDeletedsuccessfully;
                TempData["Tab"] = "Config";
            }
            return RedirectToAction("Index");
            
        }
    }
}



