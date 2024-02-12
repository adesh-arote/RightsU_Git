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
    public class DigitalConfigController : BaseController
    {
        #region Properties

        private List<Digital_Tab> lstDigital_Tab
        {
            get
            {
                if (Session["lstDigital_Tab"] == null)
                    Session["lstDigital_Tab"] = new List<Digital_Tab>();
                return (List<Digital_Tab>)Session["lstDigital_Tab"];
            }
            set { Session["lstDigital_Tab"] = value; }
        }

        private List<Digital_Tab> lstDigital_Tab_Searched
        {
            get
            {
                if (Session["lstDigital_Tab_Searched"] == null)
                    Session["lstDigital_Tab_Searched"] = new List<Digital_Tab>();
                return (List<Digital_Tab>)Session["lstDigital_Tab_Searched"];
            }
            set { Session["lstDigital_Tab_Searched"] = value; }
        }

        private List<Digital_Config> lstDigital_Config_Searched
        {
            get
            {
                if (Session["lstDigital_Config_Searched"] == null)
                    Session["lstDigital_Config_Searched"] = new List<Digital_Config>();
                return (List<Digital_Config>)Session["lstDigital_Config_Searched"];
            }
            set { Session["lstDigital_Config_Searched"] = value; }
        }

        #endregion


        // GET: DigitalConfig
        public ActionResult Index()
        {
            //LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCurrency);

            //string moduleCode = GlobalParams.ModuleCodeForCurrency.ToString();
            //string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            //ViewBag.Code = moduleCode;
            //ViewBag.LangCode = SysLanguageCode;

            FetchData();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            //lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Tab Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Tab Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            //ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/DigitalConfig/Index.cshtml");
        }

        public PartialViewResult BindPartialPages(string key, int DigitalTabCode)
        {
            Digital_Tab objDigital_Tab = new Digital_Tab();

            if (key == "LIST")
            {
                //LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCurrency);

                //string moduleCode = GlobalParams.ModuleCodeForCurrency.ToString();
                //string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
                //ViewBag.Code = moduleCode;
                //ViewBag.LangCode = SysLanguageCode;

                FetchData();
                List<SelectListItem> lstSort = new List<SelectListItem>();
                //lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
                lstSort.Add(new SelectListItem { Text = "Tab Name Asc", Value = "NA" });
                lstSort.Add(new SelectListItem { Text = "Tab Name Desc", Value = "ND" });
                ViewBag.SortType = lstSort;
                //ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/DigitalConfig/_DigitalConfig.cshtml");
            }
            else
            {
                string strTabType = string.Empty;
                string strEditWindowType = string.Empty;
                string strModule = string.Empty;

                if (key == "ADD")
                {
                    ViewBag.PageType = "ADD";
                }
                else if (key == "EDIT")
                {
                    objDigital_Tab = new Digital_Tab_Service(objLoginEntity.ConnectionStringName).GetById(DigitalTabCode);
                    strTabType = objDigital_Tab.Tab_Type;
                    strEditWindowType = objDigital_Tab.EditWindowType;
                    strModule = Convert.ToString(objDigital_Tab.Module_Code);
                    ViewBag.PageType = "EDIT";
                }
                else if (key == "VIEW")
                {
                    objDigital_Tab = new Digital_Tab_Service(objLoginEntity.ConnectionStringName).GetById(DigitalTabCode);
                    ViewBag.PageType = "VIEW";
                }

                lstDigital_Config_Searched = objDigital_Tab.Digital_Config.ToList();

                //TabType Dropdown list
                List<SelectListItem> lstTabType = new List<SelectListItem>();
                lstTabType.Add(new SelectListItem { Text = "NS", Value = "NS" });
                lstTabType.Add(new SelectListItem { Text = "?", Value = "?" });
                TempData["TabTypeDDL"] = new SelectList(lstTabType, "Value", "Text", strTabType);

                //EditWindowType Dropdown list
                List<SelectListItem> lstEditWindowType = new List<SelectListItem>();
                lstEditWindowType.Add(new SelectListItem { Text = "inLine", Value = "inLine" });
                lstEditWindowType.Add(new SelectListItem { Text = "PopUp", Value = "PopUp" });
                TempData["EditWindowTypeDDL"] = new SelectList(lstEditWindowType, "Value", "Text", strEditWindowType);

                //Module Dropdown list
                List<SelectListItem> lstModule = new List<SelectListItem>();
                lstModule.Add(new SelectListItem { Text = "Acquisition Deals", Value = "30" });
                lstModule.Add(new SelectListItem { Text = "Syndication Deals", Value = "35" });
                TempData["ModuleDDL"] = new SelectList(lstModule, "Value", "Text", strModule);

                return PartialView("~/Views/DigitalConfig/_AddEditDigitalConfig.cshtml", objDigital_Tab);
            }
        }

        public PartialViewResult BindDigitalConfigList(int pageNo, int recordPerPage, string sortType)
        {
            List<Digital_Tab> lst = new List<Digital_Tab>();
            int RecordCount = 0;
            RecordCount = lstDigital_Tab_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                //if (sortType == "T")
                //    lst = lstSupplementary_Tab_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //else 
                if (sortType == "NA")
                    lst = lstDigital_Tab_Searched.OrderBy(o => o.Digital_Tab_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstDigital_Tab_Searched.OrderByDescending(o => o.Digital_Tab_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/DigitalConfig/_DigitalConfigList.cshtml", lst);
        }

        public PartialViewResult BindTabConfig(int DigitalTabCode, string PageType)
        {
            List<RightsU_Entities.Digital_Config> lst = new List<RightsU_Entities.Digital_Config>();
            int RecordCount = 0;
            ViewBag.PageType = PageType;

            RecordCount = lstDigital_Config_Searched.Where(x => x.Digital_Tab_Code == DigitalTabCode || x.Digital_Config_Code == 0).Where(x => x.EntityState != State.Deleted).ToList().Count();
            if (RecordCount > 0)
            {
                lst = lstDigital_Config_Searched.Where(x => x.Digital_Tab_Code == DigitalTabCode || x.Digital_Config_Code == 0).Where(x => x.EntityState != State.Deleted).ToList();
            }

            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/DigitalConfig/_TabConfigList.cshtml", lst);
        }

        #region --- Other Methods ---

        private void FetchData()
        {
            lstDigital_Tab_Searched = lstDigital_Tab = new Digital_Tab_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
        }

        public JsonResult SearchDigitalConfig(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstDigital_Tab_Searched = lstDigital_Tab.Where(w => w.Digital_Tab_Description.ToUpper().Contains(searchText.ToUpper())
                || w.Short_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstDigital_Tab_Searched = lstDigital_Tab;

            var obj = new
            {
                Record_Count = lstDigital_Tab_Searched.Count
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCurrency), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public JsonResult AddEditTabConfig(int TabId, string dummyGuid, string commandName)
        {
            string status = "S", message = "Record {ACTION} successfully";

            string Digital_Code = string.Empty;
            string Control_Type = string.Empty;
            string Is_Multiselect = string.Empty;
            string Whr_Criteria = string.Empty;

            if (commandName == "ADD")
            {
                TempData["Action"] = "AddTabConfig";
            }
            else if (commandName == "EDIT")
            {
                RightsU_Entities.Digital_Config objDigital_TabConfig = new RightsU_Entities.Digital_Config();
                objDigital_TabConfig = lstDigital_Config_Searched.Where(x => x.Dummy_Guid.ToString() == dummyGuid).FirstOrDefault();

                Digital_Code = Convert.ToString(objDigital_TabConfig.Digital_Code);
                Control_Type = objDigital_TabConfig.Control_Type;
                Is_Multiselect = objDigital_TabConfig.Is_Multiselect;
                Whr_Criteria = objDigital_TabConfig.Whr_Criteria;

                TempData["Action"] = "EditTabConfig";
                TempData["idTabConfig"] = objDigital_TabConfig.Dummy_Guid;
            }

            //Digital Dropdown list 
            List<RightsU_Entities.Digital> lstDigital = new Digital_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
            TempData["DigitalDDL"] = new SelectList(lstDigital, "Digital_Code", "Digital_Name", Digital_Code);

            //Control Type Dropdown list
            List<SelectListItem> lstControlType = new List<SelectListItem>();
            lstControlType.Add(new SelectListItem { Text = "TextArea", Value = "TXTAREA" });
            lstControlType.Add(new SelectListItem { Text = "Dropdown", Value = "TXTDDL" });
            lstControlType.Add(new SelectListItem { Text = "Date", Value = "DATE" });
            lstControlType.Add(new SelectListItem { Text = "CheckBox", Value = "CHK" });
            lstControlType.Add(new SelectListItem { Text = "Numeric", Value = "INT" });
            TempData["ControlTypeDDL"] = new SelectList(lstControlType, "Value", "Text", Control_Type);

            //ISMultiple select Dropdown list
            List<SelectListItem> lstMultipleSelect = new List<SelectListItem>();
            lstMultipleSelect.Add(new SelectListItem { Text = "Yes", Value = "Y" });
            lstMultipleSelect.Add(new SelectListItem { Text = "No", Value = "N" });
            TempData["IsMultipleSelectDDL"] = new SelectList(lstMultipleSelect, "Value", "Text", Is_Multiselect);

            //AdditionalColumn Dropdown
            List<string> lstDigitalData = new Digital_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(x => x.Digital_Type).Distinct().ToList();
            List<SelectListItem> lstAdditional = new List<SelectListItem>();
            for (int i = 0; i < lstDigitalData.Count(); i++)
            {
                lstAdditional.Add(new SelectListItem { Text = lstDigitalData[i], Value = lstDigitalData[i] });
            }
            TempData["AdditionalDDL"] = new SelectList(lstAdditional, "Value", "Text", Whr_Criteria);
            var obj = new
            {

                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveDigitalTabConfig(FormCollection objFormCollection)
        {
            Digital_Tab_Service objDigital_Tab_Service = new Digital_Tab_Service(objLoginEntity.ConnectionStringName);
            Digital_Tab objDigital_Tab = new Digital_Tab();

            string status = "S", message = "Record {ACTION} successfully";

            #region Form Collection Data

            int Digital_Tab_Code = 0;

            if (objFormCollection["Digital_Tab_Code"] != null)
            {
                Digital_Tab_Code = Convert.ToInt32(objFormCollection["Digital_Tab_Code"]);
            }

            string Digital_Tab_Description = Convert.ToString(objFormCollection["Digital_Tab_Description"]).Trim();
            string Short_Name = Convert.ToString(objFormCollection["Short_Name"]).Trim();
            int Order_No = Convert.ToInt32(objFormCollection["Order_No"]);
            string Tab_Type = Convert.ToString(objFormCollection["ddlTabType"]);
            string EditWindowType = Convert.ToString(objFormCollection["ddlEditWindowType"]);


            int Module_Code = 0;
            if (objFormCollection["ddlModule"] != null && objFormCollection["ddlModule"] != "")
            {
                Module_Code = Convert.ToInt32(objFormCollection["ddlModule"]);
            }

            //string IS_Show = Convert.ToString(objFormCollection["IS_Show"]) == "false" ? "N" : "Y";

            #endregion

            bool isOrderNoExist = lstDigital_Tab.Where(x => x.Order_No == Order_No && x.Digital_Tab_Code != Digital_Tab_Code).Count() > 0 ? true : false;

            if (lstDigital_Config_Searched.Where(x => x.EntityState != State.Deleted).Count() > 0 && isOrderNoExist == false)
            {
                if (Digital_Tab_Code > 0)
                {
                    #region Update Supplementary Tab

                    objDigital_Tab = objDigital_Tab_Service.GetById(Digital_Tab_Code);
                    objDigital_Tab.Digital_Tab_Description = Digital_Tab_Description;
                    objDigital_Tab.Short_Name = Short_Name;
                    objDigital_Tab.Order_No = Order_No;
                    objDigital_Tab.Tab_Type = Tab_Type;
                    objDigital_Tab.EditWindowType = EditWindowType;
                    objDigital_Tab.Module_Code = Module_Code;
                    //objDigital_Tab.Is_Show = IS_Show;
                    objDigital_Tab.EntityState = State.Modified;

                    #endregion
                }
                else
                {
                    #region Add Supplementary Tab

                    objDigital_Tab.Digital_Tab_Description = Digital_Tab_Description;
                    objDigital_Tab.Short_Name = Short_Name;
                    objDigital_Tab.Order_No = Order_No;
                    objDigital_Tab.Tab_Type = Tab_Type;
                    objDigital_Tab.EditWindowType = EditWindowType;
                    objDigital_Tab.Module_Code = Module_Code;
                    //objDigital_Tab.Is_Show = IS_Show;
                    objDigital_Tab.EntityState = State.Added;

                    objDigital_Tab.Digital_Tab_Code = objDigital_Tab_Service.SearchFor(t => true).Max(z => z.Digital_Tab_Code) + 1;

                    #endregion
                }

                foreach (var item in lstDigital_Config_Searched)
                {
                    if (item.Digital_Config_Code > 0)
                    {
                        //modify
                        Digital_Config objDb = objDigital_Tab.Digital_Config.Where(w => w.Digital_Config_Code == item.Digital_Config_Code).FirstOrDefault();
                        objDb.Digital_Code = item.Digital_Code;
                        objDb.Control_Type = item.Control_Type;
                        objDb.Is_Multiselect = item.Is_Multiselect;
                        objDb.Is_Mandatory = item.Is_Mandatory;
                        objDb.Max_Length = item.Max_Length;
                        objDb.Page_Control_Order = item.Page_Control_Order;
                        objDb.Control_Field_Order = item.Control_Field_Order;
                        objDb.View_Name = item.View_Name;
                        objDb.Text_Field = item.Text_Field;
                        objDb.Value_Field = item.Value_Field;
                        objDb.Whr_Criteria = item.Whr_Criteria;
                        objDb.EntityState = item.EntityState;
                    }
                    if (item.Digital_Config_Code == 0)
                    {
                        //add
                        item.Digital = null;
                        item.Digital_Tab = null;
                        objDigital_Tab.Digital_Config.Add(item);
                    }
                }

                dynamic resultSet;
                bool isDuplicate = objDigital_Tab_Service.Validate(objDigital_Tab, out resultSet);
                if (isDuplicate)
                {
                    bool isValid = objDigital_Tab_Service.Save(objDigital_Tab, out resultSet);
                    if (isValid)
                    {
                        lstDigital_Tab_Searched = lstDigital_Tab = new Digital_Tab_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                        status = "S";

                        int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                        DBUtil.Release_Record(recordLockingCode);

                        if (Digital_Tab_Code > 0)
                            message = objMessageKey.Recordupdatedsuccessfully;
                        else
                            message = objMessageKey.RecordAddedSuccessfully;
                    }
                    else
                    {
                        status = "E";
                        message = resultSet;
                    }
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
            }
            else
            {
                if (isOrderNoExist)
                {
                    status = "E";
                    message = "Tab Order No is already exist.";
                }
                else
                {
                    status = "E";
                    message = "Please add atleast one row in Digital Tab Config section.";
                }
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        #endregion

        #region Tab Config Operations

        public JsonResult DeleteTabConfig(string dummyGuid)
        {
            string status = "S", message = "Record {ACTION} successfully";
            RightsU_Entities.Digital_Config objTabConfig = lstDigital_Config_Searched.Where(x => x.Dummy_Guid.ToString() == dummyGuid).SingleOrDefault();

            if (objTabConfig != null)
            {
                if (objTabConfig.Digital_Config_Code > 0)
                {
                    objTabConfig.EntityState = State.Deleted;
                }
                else
                {
                    lstDigital_Config_Searched.Remove(objTabConfig);
                }
                //message = message.Replace("{ACTION}", "Deleted");
                message = objMessageKey.RecordDeletedsuccessfully;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult UpdateTabConfig(FormCollection objFormCollection)
        {
            string str_DummyGuid = objFormCollection["DummyGuid"].ToString();
            string str_digital = objFormCollection["digital"].ToString().Trim();
            string str_controlType = objFormCollection["controlType"].ToString().Trim();
            string str_isMultipleSelect = Convert.ToString(objFormCollection["isMultipleSelect"]) == "" ? "N" : objFormCollection["isMultipleSelect"].ToString().Trim();
            string str_isMandatory = Convert.ToBoolean(objFormCollection["isMandatory"].ToString().Trim()) == true ? "Y" : "N";
            string str_maxLength = objFormCollection["maxLength"].ToString().Trim();
            string str_pageControlOrder = objFormCollection["pageControlOrder"].ToString().Trim();
            string str_controlFieldOrder = objFormCollection["controlFieldOrder"].ToString().Trim();
            string str_viewName = objFormCollection["viewName"].ToString().Trim();
            string str_txtField = objFormCollection["txtField"].ToString().Trim();
            string str_valueField = objFormCollection["valueField"].ToString().Trim();
            string str_additional = objFormCollection["additional"].ToString().Trim();
            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;


            //int VendorCode_AddEdit = Convert.ToInt32(Session["VendorCode_AddEdit"]);

            if (lstDigital_Config_Searched.Where(x => x.Dummy_Guid != str_DummyGuid)
                .Where(s => s.Digital_Code.ToString() == str_digital && s.EntityState != State.Deleted).Count() > 0)
            {
                status = "E";
                message = objMessageKey.RecordAlreadyExists;
            }
            else
            {
                RightsU_Entities.Digital_Config objTabConfig = lstDigital_Config_Searched.Where(x => x._Dummy_Guid == str_DummyGuid).SingleOrDefault();
                objTabConfig.Digital_Code = Convert.ToInt32(str_digital);
                objTabConfig.Control_Type = str_controlType;
                objTabConfig.Is_Multiselect = str_isMultipleSelect;
                objTabConfig.Is_Mandatory = str_isMandatory;
                if (!string.IsNullOrEmpty(str_maxLength))
                {
                    objTabConfig.Max_Length = Convert.ToInt32(str_maxLength);
                }

                if (!string.IsNullOrEmpty(str_pageControlOrder))
                {
                    objTabConfig.Page_Control_Order = Convert.ToInt32(str_pageControlOrder);
                }

                if (!string.IsNullOrEmpty(str_controlFieldOrder))
                {
                    objTabConfig.Control_Field_Order = Convert.ToInt32(str_controlFieldOrder);
                }
                objTabConfig.View_Name = str_viewName;
                objTabConfig.Text_Field = str_txtField;
                objTabConfig.Value_Field = str_valueField;
                objTabConfig.Whr_Criteria = str_additional;

                objTabConfig.Digital = new Digital_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(str_digital));

                if (objTabConfig.Digital_Config_Code > 0)
                {
                    objTabConfig.EntityState = State.Modified;
                }
            }


            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveTabConfig(FormCollection objFormCollection)
        {
            string str_digital = objFormCollection["digital"].ToString().Trim();
            string str_controlType = objFormCollection["controlType"].ToString().Trim();
            string str_isMultipleSelect = Convert.ToString(objFormCollection["isMultipleSelect"]) == "" ? "N" : objFormCollection["isMultipleSelect"].ToString().Trim();
            string str_isMandatory = Convert.ToBoolean(objFormCollection["isMandatory"].ToString().Trim()) == true ? "Y" : "N";
            string str_maxLength = objFormCollection["maxLength"].ToString().Trim();
            string str_pageControlOrder = objFormCollection["pageControlOrder"].ToString().Trim();
            string str_controlFieldOrder = objFormCollection["controlFieldOrder"].ToString().Trim();
            string str_viewName = objFormCollection["viewName"].ToString().Trim();
            string str_txtField = objFormCollection["txtField"].ToString().Trim();
            string str_valueField = objFormCollection["valueField"].ToString().Trim();
            string str_additional = objFormCollection["additional"].ToString().Trim();
            string str_DigitalTabCode = objFormCollection["DigitalTabCode"].ToString().Trim();
            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;


            //int VendorCode_AddEdit = Convert.ToInt32(Session["VendorCode_AddEdit"]);

            if (lstDigital_Config_Searched.Where(s => s.Digital_Code.ToString() == str_digital && s.EntityState != State.Deleted).Count() > 0)
            {
                status = "E";
                message = objMessageKey.RecordAlreadyExists;
            }
            else
            {
                RightsU_Entities.Digital_Config objTabConfig = new Digital_Config();
                objTabConfig.Digital = new Digital();
                objTabConfig.Digital_Tab = new Digital_Tab();

                objTabConfig.Digital_Code = Convert.ToInt32(str_digital);
                objTabConfig.Control_Type = str_controlType;
                objTabConfig.Is_Multiselect = str_isMultipleSelect;
                objTabConfig.Is_Mandatory = str_isMandatory;
                if (!string.IsNullOrEmpty(str_maxLength))
                {
                    objTabConfig.Max_Length = Convert.ToInt32(str_maxLength);
                }

                if (!string.IsNullOrEmpty(str_pageControlOrder))
                {
                    objTabConfig.Page_Control_Order = Convert.ToInt32(str_pageControlOrder);
                }

                if (!string.IsNullOrEmpty(str_controlFieldOrder))
                {
                    objTabConfig.Control_Field_Order = Convert.ToInt32(str_controlFieldOrder);
                }
                objTabConfig.View_Name = str_viewName;
                objTabConfig.Text_Field = str_txtField;
                objTabConfig.Value_Field = str_valueField;
                objTabConfig.Whr_Criteria = str_additional;
                if (!string.IsNullOrEmpty(str_DigitalTabCode))
                {
                    objTabConfig.Digital_Tab_Code = Convert.ToInt32(str_DigitalTabCode);
                }

                objTabConfig.Digital_Config_Code = 0;
                objTabConfig.Digital = new Digital_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(str_digital));

                objTabConfig.EntityState = State.Added;
                lstDigital_Config_Searched.Add(objTabConfig);

            }


            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion

        #region Digital Master

        public JsonResult Save_Digital_Master(string Digital_Master_Name)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string status = "S", message = "Record saved successfully";
            Digital_Service objService = new Digital_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Digital objDigital = new RightsU_Entities.Digital();
            objDigital.EntityState = State.Added;
            objDigital.Digital_Name = Digital_Master_Name;
            objDigital.Is_Active = "Y";

            dynamic resultSet;
            bool isValid = objService.Save(objDigital, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objDigital.Digital_Code,
                Text = objDigital.Digital_Name
            };

            return Json(obj);
        }
        public PartialViewResult BindDigitalMaster(int DigitalCode, string MasterMode, string searchText)
        {
            List<RightsU_Entities.Digital> lst = new List<RightsU_Entities.Digital>();

            ViewBag.MasterMode = MasterMode;
            if (!string.IsNullOrEmpty(searchText))
            {
                lst = new Digital_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Digital_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
            {
                lst = new Digital_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            }
            

            if (MasterMode == "EDIT")
            {
                RightsU_Entities.Digital objDigital_Master = new RightsU_Entities.Digital();
                objDigital_Master = lst.Where(x => x.Digital_Code == DigitalCode).FirstOrDefault();

                TempData["Action"] = "EditDigital";
                TempData["idDigital"] = objDigital_Master.Digital_Code;
            }

            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/DigitalConfig/_DigitalMasterList.cshtml", lst);
        }
        public JsonResult UpdateDigitalMaster(FormCollection objFormCollection)
        {
            string str_Digital_Name = objFormCollection["Digital_Name"].ToString();
            string str_IsActive = Convert.ToBoolean(objFormCollection["IsActive"].ToString().Trim()) == true ? "Y" : "N";
            int Digital_Code = 0;
            if (!string.IsNullOrEmpty(objFormCollection["Digital_Code"]))
            {
                Digital_Code = Convert.ToInt32(objFormCollection["Digital_Code"]);
            }
            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;

            Digital_Service objService = new Digital_Service(objLoginEntity.ConnectionStringName);

            RightsU_Entities.Digital objDigital = objService.GetById(Digital_Code);
            objDigital.EntityState = State.Modified;
            objDigital.Digital_Name = str_Digital_Name;
            objDigital.Is_Active = str_IsActive;

            dynamic resultSet;
            bool isValid = objService.Save(objDigital, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion

        #region Digital Data Master

        public PartialViewResult BindDigitalDataMaster(int DigitalDataCode, string MasterMode, string searchText)
        {
            List<RightsU_Entities.Digital_Data> lst = new List<RightsU_Entities.Digital_Data>();

            ViewBag.MasterMode = MasterMode;
            if (!string.IsNullOrEmpty(searchText))
            {
                lst = new Digital_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Data_Description.ToUpper().Contains(searchText.ToUpper()) || x.Digital_Type.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
            {
                lst = new Digital_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            }            

            if (MasterMode == "EDIT")
            {
                RightsU_Entities.Digital_Data objDigitalData_Master = new RightsU_Entities.Digital_Data();
                objDigitalData_Master = lst.Where(x => x.Digital_Data_Code == DigitalDataCode).FirstOrDefault();

                TempData["Action"] = "EditDigitalData";
                TempData["idDigitalData"] = objDigitalData_Master.Digital_Data_Code;
            }

            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/DigitalConfig/_DigitalDataMasterList.cshtml", lst);
        }

        public JsonResult Save_DigitalData_Master(string Digital_Data_Desc, string Digital_Type)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string status = "S", message = "Record saved successfully";
            Digital_Data_Service objService = new Digital_Data_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Digital_Data objDigitalData = new RightsU_Entities.Digital_Data();
            objDigitalData.EntityState = State.Added;
            objDigitalData.Data_Description = Digital_Data_Desc;
            objDigitalData.Digital_Type = Digital_Type;
            objDigitalData.Is_Active = "Y";

            dynamic resultSet;
            bool isValid = objService.Save(objDigitalData, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objDigitalData.Digital_Type,
                Text = objDigitalData.Digital_Type
            };

            return Json(obj);
        }

        public JsonResult UpdateDigitalDataMaster(FormCollection objFormCollection)
        {
            string str_Digital_Data_Desc = objFormCollection["Digital_Data_Desc"].ToString();
            string str_Digital_Type = objFormCollection["Digital_Type"].ToString();
            string str_IsActive = Convert.ToBoolean(objFormCollection["IsActive"].ToString().Trim()) == true ? "Y" : "N";
            int Digital_Data_Code = 0;
            if (!string.IsNullOrEmpty(objFormCollection["Digital_Data_Code"]))
            {
                Digital_Data_Code = Convert.ToInt32(objFormCollection["Digital_Data_Code"]);
            }
            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;

            Digital_Data_Service objService = new Digital_Data_Service(objLoginEntity.ConnectionStringName);

            RightsU_Entities.Digital_Data objDigitalData = objService.GetById(Digital_Data_Code);
            objDigitalData.EntityState = State.Modified;
            objDigitalData.Data_Description = str_Digital_Data_Desc;
            objDigitalData.Digital_Type = str_Digital_Type;
            objDigitalData.Is_Active = str_IsActive;

            dynamic resultSet;
            bool isValid = objService.Save(objDigitalData, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion

        #region Tab ListView Config

        public PartialViewResult BindTabListViewData(int DigitalTabCode)
        {
            RightsU_Entities.Digital_Tab objDigital_Tab = new RightsU_Entities.Digital_Tab();
            Digital_Config objDigital_Config = new Digital_Config();


            objDigital_Tab = new Digital_Tab_Service(objLoginEntity.ConnectionStringName).GetById(DigitalTabCode);

            //Key Config Dropdown list             
            TempData["KeyConfigDDL"] = new SelectList(objDigital_Tab.Digital_Config.Where(x => x.Control_Type == "TXTDDL").ToList(), "Digital_Config_Code", "Digital.Digital_Name", objDigital_Tab.Key_Config_Code);

            if (objDigital_Tab.Key_Config_Code > 0 || objDigital_Tab.Key_Config_Code != null)
            {
                objDigital_Config = objDigital_Tab.Digital_Config.Where(x => x.Digital_Config_Code == objDigital_Tab.Key_Config_Code).SingleOrDefault();

                //DigitalData Dropdown List
                List<Digital_Data> lstDigitalData = new Digital_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Digital_Type == objDigital_Config.Whr_Criteria).ToList();

                int[] selectedDigitalData = !string.IsNullOrEmpty(objDigital_Config.LP_Digital_Data_Code) ? objDigital_Config.LP_Digital_Data_Code.Split(',').Select(x => int.Parse(x)).ToArray() : new int[0];
                TempData["DigitalDataDDL"] = new MultiSelectList(lstDigitalData, "Digital_Data_Code", "Data_Description", selectedDigitalData);

                //DigitalValueConfig Dropdown List
                var DigitalValueConfig = new Digital_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Digital_Type == objDigital_Config.Whr_Criteria).ToList();

                int[] SelectedDigitalValueConfig = !string.IsNullOrEmpty(objDigital_Config.LP_Digital_Value_Config_Code) ? objDigital_Config.LP_Digital_Value_Config_Code.Split(',').Select(x => int.Parse(x)).ToArray() : new int[0];
                TempData["DigitalValueConfigDDL"] = new MultiSelectList(objDigital_Tab.Digital_Config, "Digital_Config_Code", "Digital.Digital_Name", SelectedDigitalValueConfig);

                if (objDigital_Tab.Is_Show == "Y")
                {
                    ViewBag.DisplayLevel = "TL";
                }
                else if (objDigital_Tab.Is_Show == "N")
                {
                    if (!string.IsNullOrEmpty(objDigital_Config.LP_Digital_Data_Code) && !string.IsNullOrEmpty(objDigital_Config.LP_Digital_Value_Config_Code))
                    {
                        ViewBag.DisplayLevel = "DL";
                    }
                    else
                    {
                        ViewBag.DisplayLevel = "NS";
                    }
                }
            }
            else
            {
                if (objDigital_Tab.Is_Show == "Y")
                {
                    ViewBag.DisplayLevel = "TL";
                }
                else if (objDigital_Tab.Is_Show == "N")
                {
                    ViewBag.DisplayLevel = "NS";
                }

                //DigitalData Dropdown List
                List<Digital_Data> lstDigitalData = new List<Digital_Data>();

                TempData["DigitalDataDDL"] = new MultiSelectList(lstDigitalData, "Digital_Data_Code", "Data_Description");

                //DigitalValueConfig Dropdown List
                List<Digital_Data> DigitalValueConfig = new List<Digital_Data>();

                TempData["DigitalValueConfigDDL"] = new MultiSelectList(objDigital_Tab.Digital_Config, "Digital_Config_Code", "Digital.Digital_Name");
            }
            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/DigitalConfig/_DigitalTabListViewConfig.cshtml", objDigital_Tab);
        }

        public JsonResult FillSupplementaryData(string keyConfigCode)
        {
            Supplementary_Config objSupplementary_Config = new Supplementary_Config();
            List<Supplementary_Data> lstSupplementaryData = new List<Supplementary_Data>();

            if (!string.IsNullOrEmpty(keyConfigCode))
            {
                objSupplementary_Config = new Supplementary_Config_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(keyConfigCode));
                lstSupplementaryData = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Supplementary_Type == objSupplementary_Config.Whr_Criteria).ToList();
            }

            int[] selectedSupplementaryData = !string.IsNullOrEmpty(objSupplementary_Config.LP_Supplementary_Data_Code) ? objSupplementary_Config.LP_Supplementary_Data_Code.Split(',').Select(x => int.Parse(x)).ToArray() : new int[0];

            var obj = new
            {
                Data = lstSupplementaryData,
                selectedValues = selectedSupplementaryData
            };

            return Json(obj, JsonRequestBehavior.AllowGet);
        }

        public JsonResult UpdateTabListViewData(FormCollection objFormCollection)
        {
            Digital_Config objDigital_Config = new Digital_Config();

            string str_LP_Digital_Data_Code = objFormCollection["LP_Digital_Data_Code"].ToString();
            string str_LP_Digital_Value_Config_Code = objFormCollection["LP_Digital_Value_Config_Code"].ToString();
            string str_DisplayLevel = objFormCollection["DisplayLevel"].ToString();

            int Digital_Tab_Code = 0;
            if (!string.IsNullOrEmpty(objFormCollection["Digital_Tab_Code"]))
            {
                Digital_Tab_Code = Convert.ToInt32(objFormCollection["Digital_Tab_Code"]);
            }

            int Key_Config_Code = 0;
            if (!string.IsNullOrEmpty(objFormCollection["Key_Config_Code"]))
            {
                Key_Config_Code = Convert.ToInt32(objFormCollection["Key_Config_Code"]);
            }

            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;

            Digital_Tab_Service objService = new Digital_Tab_Service(objLoginEntity.ConnectionStringName);

            RightsU_Entities.Digital_Tab objDigitalTab = objService.GetById(Digital_Tab_Code);
            objDigitalTab.EntityState = State.Modified;
            objDigitalTab.Key_Config_Code = Key_Config_Code;
            if (Key_Config_Code > 0)
            {
                objDigital_Config = objDigitalTab.Digital_Config.Where(x => x.Digital_Config_Code == Key_Config_Code).SingleOrDefault();
            }            

            if (str_DisplayLevel == "TL")
            {
                objDigitalTab.Is_Show = "Y";

                objDigital_Config.LP_Digital_Data_Code = null;
                objDigital_Config.LP_Digital_Value_Config_Code = null;
                objDigital_Config.EntityState = State.Modified;
            }
            else if (str_DisplayLevel == "DL")
            {
                objDigitalTab.Is_Show = "N";


                objDigital_Config.LP_Digital_Data_Code = str_LP_Digital_Data_Code;
                objDigital_Config.LP_Digital_Value_Config_Code = str_LP_Digital_Value_Config_Code;
                objDigital_Config.EntityState = State.Modified;
            }
            else if (str_DisplayLevel == "NS")
            {
                objDigitalTab.Is_Show = "N";
                objDigitalTab.Key_Config_Code = null;

                objDigital_Config.LP_Digital_Data_Code = null;
                objDigital_Config.LP_Digital_Value_Config_Code = null;
                objDigital_Config.EntityState = State.Modified;
            }

            dynamic resultSet;
            bool isValid = objService.Save(objDigitalTab, out resultSet);
            FetchData();
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion
    }
}