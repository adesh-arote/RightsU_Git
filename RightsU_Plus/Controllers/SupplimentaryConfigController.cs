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
    public class SupplimentaryConfigController : BaseController
    {

        #region --- Properties ---

        private List<RightsU_Entities.Supplementary_Tab> lstSupplementary_Tab
        {
            get
            {
                if (Session["lstSupplementary_Tab"] == null)
                    Session["lstSupplementary_Tab"] = new List<RightsU_Entities.Supplementary_Tab>();
                return (List<RightsU_Entities.Supplementary_Tab>)Session["lstSupplementary_Tab"];
            }
            set { Session["lstSupplementary_Tab"] = value; }
        }

        private List<RightsU_Entities.Supplementary_Tab> lstSupplementary_Tab_Searched
        {
            get
            {
                if (Session["lstSupplementary_Tab_Searched"] == null)
                    Session["lstSupplementary_Tab_Searched"] = new List<RightsU_Entities.Supplementary_Tab>();
                return (List<RightsU_Entities.Supplementary_Tab>)Session["lstSupplementary_Tab_Searched"];
            }
            set { Session["lstSupplementary_Tab_Searched"] = value; }
        }

        //private List<RightsU_Entities.Supplementary_Config> lstSupplementary_Config
        //{
        //    get
        //    {
        //        if (Session["lstSupplementary_Config"] == null)
        //            Session["lstSupplementary_Config"] = new List<RightsU_Entities.Supplementary_Config>();
        //        return (List<RightsU_Entities.Supplementary_Config>)Session["lstSupplementary_Config"];
        //    }
        //    set { Session["lstSupplementary_Config"] = value; }
        //}

        private List<RightsU_Entities.Supplementary_Config> lstSupplementary_Config_Searched
        {
            get
            {
                if (Session["lstSupplementary_Config_Searched"] == null)
                    Session["lstSupplementary_Config_Searched"] = new List<RightsU_Entities.Supplementary_Config>();
                return (List<RightsU_Entities.Supplementary_Config>)Session["lstSupplementary_Config_Searched"];
            }
            set { Session["lstSupplementary_Config_Searched"] = value; }
        }

        //private RightsU_Entities.Supplementary_Tab objSupplementary_Tab
        //{
        //    get
        //    {
        //        if (Session["objSupplementary_Tab"] == null)
        //            Session["objSupplementary_Tab"] = new RightsU_Entities.Supplementary_Tab();
        //        return (RightsU_Entities.Supplementary_Tab)Session["objSupplementary_Tab"];
        //    }
        //    set { Session["objSupplementary_Tab"] = value; }
        //}

        //private Supplementary_Tab_Service objSupplementary_Tab_Service
        //{
        //    get
        //    {
        //        if (Session["objSupplementary_Tab_Service"] == null)
        //            Session["objSupplementary_Tab_Service"] = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);
        //        return (Supplementary_Tab_Service)Session["objSupplementary_Tab_Service"];
        //    }
        //    set { Session["objSupplementary_Tab_Service"] = value; }
        //}

        #endregion

        // GET: SupplimentaryConfig
        public ViewResult Index()
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
            return View("~/Views/SupplimentaryConfig/Index.cshtml");

        }

        public PartialViewResult BindSupplimentaryConfigList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.Supplementary_Tab> lst = new List<RightsU_Entities.Supplementary_Tab>();
            int RecordCount = 0;
            RecordCount = lstSupplementary_Tab_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                //if (sortType == "T")
                //    lst = lstSupplementary_Tab_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //else 
                if (sortType == "NA")
                    lst = lstSupplementary_Tab_Searched.OrderBy(o => o.Supplementary_Tab_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstSupplementary_Tab_Searched.OrderByDescending(o => o.Supplementary_Tab_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/SupplimentaryConfig/_SupplimentaryConfigList.cshtml", lst);
        }

        public PartialViewResult BindPartialPages(string key, int SupplimentaryTabCode)
        {
            RightsU_Entities.Supplementary_Tab objSupplementary_Tab = new RightsU_Entities.Supplementary_Tab();

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
                return PartialView("~/Views/SupplimentaryConfig/_SupplimentaryConfig.cshtml");
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
                    objSupplementary_Tab = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).GetById(SupplimentaryTabCode);
                    strTabType = objSupplementary_Tab.Tab_Type;
                    strEditWindowType = objSupplementary_Tab.EditWindowType;
                    strModule = Convert.ToString(objSupplementary_Tab.Module_Code);
                    ViewBag.PageType = "EDIT";
                }
                else if (key == "VIEW")
                {
                    objSupplementary_Tab = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).GetById(SupplimentaryTabCode);
                    ViewBag.PageType = "VIEW";
                }

                lstSupplementary_Config_Searched = objSupplementary_Tab.Supplementary_Config.ToList();

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

                return PartialView("~/Views/SupplimentaryConfig/_AddEditSupplimentaryConfig.cshtml", objSupplementary_Tab);
            }
        }

        public PartialViewResult BindTabConfig(int SupplementaryTabCode, string PageType)
        {
            List<RightsU_Entities.Supplementary_Config> lst = new List<RightsU_Entities.Supplementary_Config>();
            int RecordCount = 0;
            ViewBag.PageType = PageType;

            RecordCount = lstSupplementary_Config_Searched.Where(x => x.Supplementary_Tab_Code == SupplementaryTabCode || x.Supplementary_Config_Code == 0).Where(x => x.EntityState != State.Deleted).ToList().Count();
            if (RecordCount > 0)
            {
                lst = lstSupplementary_Config_Searched.Where(x => x.Supplementary_Tab_Code == SupplementaryTabCode || x.Supplementary_Config_Code == 0).Where(x => x.EntityState != State.Deleted).ToList();
            }

            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/SupplimentaryConfig/_TabConfigList.cshtml", lst);
        }

        #region --- Other Methods ---

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
            lstSupplementary_Tab_Searched = lstSupplementary_Tab = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCurrency), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public JsonResult SearchSupplimentaryConfig(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstSupplementary_Tab_Searched = lstSupplementary_Tab.Where(w => w.Supplementary_Tab_Description.ToUpper().Contains(searchText.ToUpper())
                || w.Short_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstSupplementary_Tab_Searched = lstSupplementary_Tab;

            var obj = new
            {
                Record_Count = lstSupplementary_Tab_Searched.Count
            };

            return Json(obj);
        }

        //public JsonResult CheckRecordLock(int supplimentaryTabCode)
        //{
        //    string strMessage = "";
        //    int RLCode = 0;
        //    bool isLocked = true;
        //    if (supplimentaryTabCode > 0)
        //    {
        //        CommonUtil objCommonUtil = new CommonUtil();
        //        isLocked = objCommonUtil.Lock_Record(supplimentaryTabCode, GlobalParams.ModuleCodeForCurrency, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
        //    }

        //    var obj = new
        //    {
        //        Is_Locked = (isLocked) ? "Y" : "N",
        //        Message = strMessage,
        //        Record_Locking_Code = RLCode
        //    };
        //    return Json(obj);
        //}

        public JsonResult AddEditTabConfig(int TabId, string dummyGuid, string commandName)
        {
            string status = "S", message = "Record {ACTION} successfully";

            string Supplementary_Code = string.Empty;
            string Control_Type = string.Empty;
            string Is_Multiselect = string.Empty;
            string Whr_Criteria = string.Empty;

            if (commandName == "ADD")
            {
                TempData["Action"] = "AddTabConfig";
            }
            else if (commandName == "EDIT")
            {
                RightsU_Entities.Supplementary_Config objSupplementary_TabConfig = new RightsU_Entities.Supplementary_Config();
                objSupplementary_TabConfig = lstSupplementary_Config_Searched.Where(x => x.Dummy_Guid.ToString() == dummyGuid).FirstOrDefault();

                Supplementary_Code = Convert.ToString(objSupplementary_TabConfig.Supplementary_Code);
                Control_Type = objSupplementary_TabConfig.Control_Type;
                Is_Multiselect = objSupplementary_TabConfig.Is_Multiselect;
                Whr_Criteria = objSupplementary_TabConfig.Whr_Criteria;

                TempData["Action"] = "EditTabConfig";
                TempData["idTabConfig"] = objSupplementary_TabConfig.Dummy_Guid;
            }

            //Supplementary Dropdown list 
            List<RightsU_Entities.Supplementary> lstSupplimentary = new Supplementary_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
            TempData["SupplimentaryDDL"] = new SelectList(lstSupplimentary, "Supplementary_Code", "Supplementary_Name", Supplementary_Code);

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
            List<string> lstSupplimentaryData = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(x => x.Supplementary_Type).Distinct().ToList();
            List<SelectListItem> lstAdditional = new List<SelectListItem>();
            for (int i = 0; i < lstSupplimentaryData.Count(); i++)
            {
                lstAdditional.Add(new SelectListItem { Text = lstSupplimentaryData[i], Value = lstSupplimentaryData[i] });
            }
            TempData["AdditionalDDL"] = new SelectList(lstAdditional, "Value", "Text", Whr_Criteria);
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveSupplementaryTabConfig(FormCollection objFormCollection)
        {
            Supplementary_Tab_Service objSupplementary_Tab_Service = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);
            Supplementary_Tab objSupplementary_Tab = new Supplementary_Tab();

            string status = "S", message = "Record {ACTION} successfully";

            #region Form Collection Data

            int Supplementary_Tab_Code = 0;

            if (objFormCollection["Supplementary_Tab_Code"] != null)
            {
                Supplementary_Tab_Code = Convert.ToInt32(objFormCollection["Supplementary_Tab_Code"]);
            }

            string Supplementary_Tab_Description = Convert.ToString(objFormCollection["Supplementary_Tab_Description"]).Trim();
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

            bool isOrderNoExist = lstSupplementary_Tab.Where(x => x.Order_No == Order_No && x.Supplementary_Tab_Code != Supplementary_Tab_Code).Count() > 0 ? true : false;

            if (lstSupplementary_Config_Searched.Where(x => x.EntityState != State.Deleted).Count() > 0 && isOrderNoExist == false)
            {
                if (Supplementary_Tab_Code > 0)
                {
                    #region Update Supplementary Tab

                    objSupplementary_Tab = objSupplementary_Tab_Service.GetById(Supplementary_Tab_Code);
                    objSupplementary_Tab.Supplementary_Tab_Description = Supplementary_Tab_Description;
                    objSupplementary_Tab.Short_Name = Short_Name;
                    objSupplementary_Tab.Order_No = Order_No;
                    objSupplementary_Tab.Tab_Type = Tab_Type;
                    objSupplementary_Tab.EditWindowType = EditWindowType;
                    objSupplementary_Tab.Module_Code = Module_Code;
                    //objSupplementary_Tab.Is_Show = IS_Show;
                    objSupplementary_Tab.EntityState = State.Modified;

                    #endregion
                }
                else
                {
                    #region Add Supplementary Tab

                    objSupplementary_Tab.Supplementary_Tab_Description = Supplementary_Tab_Description;
                    objSupplementary_Tab.Short_Name = Short_Name;
                    objSupplementary_Tab.Order_No = Order_No;
                    objSupplementary_Tab.Tab_Type = Tab_Type;
                    objSupplementary_Tab.EditWindowType = EditWindowType;
                    objSupplementary_Tab.Module_Code = Module_Code;
                    //objSupplementary_Tab.Is_Show = IS_Show;
                    objSupplementary_Tab.EntityState = State.Added;

                    objSupplementary_Tab.Supplementary_Tab_Code = objSupplementary_Tab_Service.SearchFor(t => true).Max(z => z.Supplementary_Tab_Code) + 1;

                    #endregion
                }

                foreach (var item in lstSupplementary_Config_Searched)
                {
                    if (item.Supplementary_Config_Code > 0)
                    {
                        //modify
                        Supplementary_Config objDb = objSupplementary_Tab.Supplementary_Config.Where(w => w.Supplementary_Config_Code == item.Supplementary_Config_Code).FirstOrDefault();
                        objDb.Supplementary_Code = item.Supplementary_Code;
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
                    if (item.Supplementary_Config_Code == 0)
                    {
                        //add
                        item.Supplementary = null;
                        item.Supplementary_Tab = null;
                        objSupplementary_Tab.Supplementary_Config.Add(item);
                    }
                }

                dynamic resultSet;
                bool isDuplicate = objSupplementary_Tab_Service.Validate(objSupplementary_Tab, out resultSet);
                if (isDuplicate)
                {
                    bool isValid = objSupplementary_Tab_Service.Save(objSupplementary_Tab, out resultSet);
                    if (isValid)
                    {
                        lstSupplementary_Tab_Searched = lstSupplementary_Tab = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                        status = "S";

                        int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                        DBUtil.Release_Record(recordLockingCode);

                        if (Supplementary_Tab_Code > 0)
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
                    message = "Please add atleast one row in Supplementary Tab Config section.";
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
            RightsU_Entities.Supplementary_Config objTabConfig = lstSupplementary_Config_Searched.Where(x => x.Dummy_Guid.ToString() == dummyGuid).SingleOrDefault();

            if (objTabConfig != null)
            {
                if (objTabConfig.Supplementary_Config_Code > 0)
                {
                    objTabConfig.EntityState = State.Deleted;
                }
                else
                {
                    lstSupplementary_Config_Searched.Remove(objTabConfig);
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
            string str_supplementary = objFormCollection["supplementary"].ToString().Trim();
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

            if (lstSupplementary_Config_Searched.Where(x => x.Dummy_Guid != str_DummyGuid)
                .Where(s => s.Supplementary_Code.ToString() == str_supplementary && s.EntityState != State.Deleted).Count() > 0)
            {
                status = "E";
                message = objMessageKey.RecordAlreadyExists;
            }
            else
            {
                RightsU_Entities.Supplementary_Config objTabConfig = lstSupplementary_Config_Searched.Where(x => x._Dummy_Guid == str_DummyGuid).SingleOrDefault();
                objTabConfig.Supplementary_Code = Convert.ToInt32(str_supplementary);
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

                objTabConfig.Supplementary = new Supplementary_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(str_supplementary));

                if (objTabConfig.Supplementary_Config_Code > 0)
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
            string str_supplementary = objFormCollection["supplementary"].ToString().Trim();
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
            string str_SupplementaryTabCode = objFormCollection["SupplementaryTabCode"].ToString().Trim();
            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;


            //int VendorCode_AddEdit = Convert.ToInt32(Session["VendorCode_AddEdit"]);

            if (lstSupplementary_Config_Searched.Where(s => s.Supplementary_Code.ToString() == str_supplementary && s.EntityState != State.Deleted).Count() > 0)
            {
                status = "E";
                message = objMessageKey.RecordAlreadyExists;
            }
            else
            {
                RightsU_Entities.Supplementary_Config objTabConfig = new Supplementary_Config();
                objTabConfig.Supplementary = new Supplementary();
                objTabConfig.Supplementary_Tab = new Supplementary_Tab();

                objTabConfig.Supplementary_Code = Convert.ToInt32(str_supplementary);
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
                if (!string.IsNullOrEmpty(str_SupplementaryTabCode))
                {
                    objTabConfig.Supplementary_Tab_Code = Convert.ToInt32(str_SupplementaryTabCode);
                }

                objTabConfig.Supplementary_Config_Code = 0;
                objTabConfig.Supplementary = new Supplementary_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(str_supplementary));

                objTabConfig.EntityState = State.Added;
                lstSupplementary_Config_Searched.Add(objTabConfig);

            }


            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion

        #region Supplementary Master

        public PartialViewResult BindSupplementaryMaster(int SupplementaryCode, string MasterMode, string searchText)
        {
            List<RightsU_Entities.Supplementary> lst = new List<RightsU_Entities.Supplementary>();

            ViewBag.MasterMode = MasterMode;
            if (!string.IsNullOrEmpty(searchText))
            {
                lst = new Supplementary_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Supplementary_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
            {
                lst = new Supplementary_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            }
            //lst = new Supplementary_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();

            if (MasterMode == "EDIT")
            {
                RightsU_Entities.Supplementary objSupplementary_Master = new RightsU_Entities.Supplementary();
                objSupplementary_Master = lst.Where(x => x.Supplementary_Code == SupplementaryCode).FirstOrDefault();

                TempData["Action"] = "EditSupplementary";
                TempData["idSupplementary"] = objSupplementary_Master.Supplementary_Code;
            }

            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/SupplimentaryConfig/_SupplementaryMasterList.cshtml", lst);
        }

        public JsonResult Save_Supplementary_Master(string Supplementary_Master_Name)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string status = "S", message = "Record saved successfully";
            Supplementary_Service objService = new Supplementary_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Supplementary objSupplementary = new RightsU_Entities.Supplementary();
            objSupplementary.EntityState = State.Added;
            objSupplementary.Supplementary_Name = Supplementary_Master_Name;
            objSupplementary.Is_Active = "Y";

            dynamic resultSet;
            bool isValid = objService.Save(objSupplementary, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objSupplementary.Supplementary_Code,
                Text = objSupplementary.Supplementary_Name
            };

            return Json(obj);
        }

        public JsonResult UpdateSupplementaryMaster(FormCollection objFormCollection)
        {
            string str_Supplementary_Name = objFormCollection["Supplementary_Name"].ToString();
            string str_IsActive = Convert.ToBoolean(objFormCollection["IsActive"].ToString().Trim()) == true ? "Y" : "N";
            int Supplementary_Code = 0;
            if (!string.IsNullOrEmpty(objFormCollection["Supplementary_Code"]))
            {
                Supplementary_Code = Convert.ToInt32(objFormCollection["Supplementary_Code"]);
            }
            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;

            Supplementary_Service objService = new Supplementary_Service(objLoginEntity.ConnectionStringName);

            RightsU_Entities.Supplementary objSupplementary = objService.GetById(Supplementary_Code);
            objSupplementary.EntityState = State.Modified;
            objSupplementary.Supplementary_Name = str_Supplementary_Name;
            objSupplementary.Is_Active = str_IsActive;

            dynamic resultSet;
            bool isValid = objService.Save(objSupplementary, out resultSet);
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

        #region Supplementary Data Master

        public PartialViewResult BindSupplementaryDataMaster(int SupplementaryDataCode, string MasterMode, string searchText)
        {
            List<RightsU_Entities.Supplementary_Data> lst = new List<RightsU_Entities.Supplementary_Data>();

            ViewBag.MasterMode = MasterMode;

            if (!string.IsNullOrEmpty(searchText))
            {
                lst = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Data_Description.ToUpper().Contains(searchText.ToUpper()) || x.Supplementary_Type.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
            {
                lst = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            }

            if (MasterMode == "EDIT")
            {
                RightsU_Entities.Supplementary_Data objSupplementaryData_Master = new RightsU_Entities.Supplementary_Data();
                objSupplementaryData_Master = lst.Where(x => x.Supplementary_Data_Code == SupplementaryDataCode).FirstOrDefault();

                TempData["Action"] = "EditSupplementaryData";
                TempData["idSupplementaryData"] = objSupplementaryData_Master.Supplementary_Data_Code;
            }

            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/SupplimentaryConfig/_SupplementaryDataMasterList.cshtml", lst);
        }

        public JsonResult Save_SupplementaryData_Master(string Supplementary_Data_Desc, string Supplementary_Type)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string status = "S", message = "Record saved successfully";
            Supplementary_Data_Service objService = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Supplementary_Data objSupplementaryData = new RightsU_Entities.Supplementary_Data();
            objSupplementaryData.EntityState = State.Added;
            objSupplementaryData.Data_Description = Supplementary_Data_Desc;
            objSupplementaryData.Supplementary_Type = Supplementary_Type;
            objSupplementaryData.Is_Active = "Y";

            dynamic resultSet;
            bool isValid = objService.Save(objSupplementaryData, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objSupplementaryData.Supplementary_Type,
                Text = objSupplementaryData.Supplementary_Type
            };

            return Json(obj);
        }

        public JsonResult UpdateSupplementaryDataMaster(FormCollection objFormCollection)
        {
            string str_Supplementary_Data_Desc = objFormCollection["Supplementary_Data_Desc"].ToString();
            string str_Supplementary_Type = objFormCollection["Supplementary_Type"].ToString();
            string str_IsActive = Convert.ToBoolean(objFormCollection["IsActive"].ToString().Trim()) == true ? "Y" : "N";
            int Supplementary_Data_Code = 0;
            if (!string.IsNullOrEmpty(objFormCollection["Supplementary_Data_Code"]))
            {
                Supplementary_Data_Code = Convert.ToInt32(objFormCollection["Supplementary_Data_Code"]);
            }
            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;

            Supplementary_Data_Service objService = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName);

            RightsU_Entities.Supplementary_Data objSupplementaryData = objService.GetById(Supplementary_Data_Code);
            objSupplementaryData.EntityState = State.Modified;
            objSupplementaryData.Data_Description = str_Supplementary_Data_Desc;
            objSupplementaryData.Supplementary_Type = str_Supplementary_Type;
            objSupplementaryData.Is_Active = str_IsActive;

            dynamic resultSet;
            bool isValid = objService.Save(objSupplementaryData, out resultSet);
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

        public PartialViewResult BindTabListViewData(int SupplementaryTabCode)
        {
            RightsU_Entities.Supplementary_Tab objSupplementary_Tab = new RightsU_Entities.Supplementary_Tab();
            Supplementary_Config objSupplementary_Config = new Supplementary_Config();


            objSupplementary_Tab = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).GetById(SupplementaryTabCode);

            //Key Config Dropdown list             
            TempData["KeyConfigDDL"] = new SelectList(objSupplementary_Tab.Supplementary_Config.Where(x => x.Control_Type == "TXTDDL").ToList(), "Supplementary_Config_Code", "Supplementary.Supplementary_Name", objSupplementary_Tab.Key_Config_Code);

            if (objSupplementary_Tab.Key_Config_Code > 0 || objSupplementary_Tab.Key_Config_Code != null)
            {
                objSupplementary_Config = objSupplementary_Tab.Supplementary_Config.Where(x => x.Supplementary_Config_Code == objSupplementary_Tab.Key_Config_Code).SingleOrDefault();

                //SupplementaryData Dropdown List
                List<Supplementary_Data> lstSupplementaryData = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Supplementary_Type == objSupplementary_Config.Whr_Criteria).ToList();

                int[] selectedSupplementaryData = !string.IsNullOrEmpty(objSupplementary_Config.LP_Supplementary_Data_Code) ? objSupplementary_Config.LP_Supplementary_Data_Code.Split(',').Select(x => int.Parse(x)).ToArray() : new int[0];
                TempData["SupplementaryDataDDL"] = new MultiSelectList(lstSupplementaryData, "Supplementary_Data_Code", "Data_Description", selectedSupplementaryData);

                //SupplementaryValueConfig Dropdown List
                var SupplementaryValueConfig = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Supplementary_Type == objSupplementary_Config.Whr_Criteria).ToList();

                int[] SelectedSupplementaryValueConfig = !string.IsNullOrEmpty(objSupplementary_Config.LP_Supplementary_Value_Config_Code) ? objSupplementary_Config.LP_Supplementary_Value_Config_Code.Split(',').Select(x => int.Parse(x)).ToArray() : new int[0];
                TempData["SupplementaryValueConfigDDL"] = new MultiSelectList(objSupplementary_Tab.Supplementary_Config, "Supplementary_Config_Code", "Supplementary.Supplementary_Name", SelectedSupplementaryValueConfig);

                if (objSupplementary_Tab.Is_Show == "Y")
                {
                    ViewBag.DisplayLevel = "TL";
                }
                else if (objSupplementary_Tab.Is_Show == "N")
                {
                    if (!string.IsNullOrEmpty(objSupplementary_Config.LP_Supplementary_Data_Code) && !string.IsNullOrEmpty(objSupplementary_Config.LP_Supplementary_Value_Config_Code))
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
                if (objSupplementary_Tab.Is_Show == "Y")
                {
                    ViewBag.DisplayLevel = "TL";
                }
                else if (objSupplementary_Tab.Is_Show == "N")
                {
                    ViewBag.DisplayLevel = "NS";
                }

                //SupplementaryData Dropdown List
                List<Supplementary_Data> lstSupplementaryData = new List<Supplementary_Data>();

                TempData["SupplementaryDataDDL"] = new MultiSelectList(lstSupplementaryData, "Supplementary_Data_Code", "Data_Description");

                //SupplementaryValueConfig Dropdown List
                List<Supplementary_Data> SupplementaryValueConfig = new List<Supplementary_Data>();

                TempData["SupplementaryValueConfigDDL"] = new MultiSelectList(objSupplementary_Tab.Supplementary_Config, "Supplementary_Config_Code", "Supplementary.Supplementary_Name");
            }





            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/SupplimentaryConfig/_SupplementaryTabListViewConfig.cshtml", objSupplementary_Tab);
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
            Supplementary_Config objSupplementary_Config = new Supplementary_Config();


            string str_LP_Supplementary_Data_Code = objFormCollection["LP_Supplementary_Data_Code"].ToString();
            string str_LP_Supplementary_Value_Config_Code = objFormCollection["LP_Supplementary_Value_Config_Code"].ToString();
            string str_DisplayLevel = objFormCollection["DisplayLevel"].ToString();

            int Supplementary_Tab_Code = 0;
            if (!string.IsNullOrEmpty(objFormCollection["Supplementary_Tab_Code"]))
            {
                Supplementary_Tab_Code = Convert.ToInt32(objFormCollection["Supplementary_Tab_Code"]);
            }

            int Key_Config_Code = 0;
            if (!string.IsNullOrEmpty(objFormCollection["Key_Config_Code"]))
            {
                Key_Config_Code = Convert.ToInt32(objFormCollection["Key_Config_Code"]);
            }

            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;

            Supplementary_Tab_Service objService = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);

            RightsU_Entities.Supplementary_Tab objSupplementaryTab = objService.GetById(Supplementary_Tab_Code);
            objSupplementaryTab.EntityState = State.Modified;
            objSupplementaryTab.Key_Config_Code = Key_Config_Code;
            if (Key_Config_Code > 0)
            {
                objSupplementary_Config = objSupplementaryTab.Supplementary_Config.Where(x => x.Supplementary_Config_Code == Key_Config_Code).SingleOrDefault();
            }

            if (str_DisplayLevel == "TL")
            {
                objSupplementaryTab.Is_Show = "Y";

                objSupplementary_Config.LP_Supplementary_Data_Code = null;
                objSupplementary_Config.LP_Supplementary_Value_Config_Code = null;
                objSupplementary_Config.EntityState = State.Modified;
            }
            else if (str_DisplayLevel == "DL")
            {
                objSupplementaryTab.Is_Show = "N";


                objSupplementary_Config.LP_Supplementary_Data_Code = str_LP_Supplementary_Data_Code;
                objSupplementary_Config.LP_Supplementary_Value_Config_Code = str_LP_Supplementary_Value_Config_Code;
                objSupplementary_Config.EntityState = State.Modified;
            }
            else if (str_DisplayLevel == "NS")
            {
                objSupplementaryTab.Is_Show = "N";
                objSupplementaryTab.Key_Config_Code = null;

                objSupplementary_Config.LP_Supplementary_Data_Code = null;
                objSupplementary_Config.LP_Supplementary_Value_Config_Code = null;
                objSupplementary_Config.EntityState = State.Modified;
            }

            dynamic resultSet;
            bool isValid = objService.Save(objSupplementaryTab, out resultSet);
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