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
    public class supplementry_ConfigController : BaseController
    {
        private List<RightsU_Entities.Supplementary_Tab> lstSupplementary_Tabs
        {
            get
            {
                if (Session["lstSupplementary_Tabs"] == null)
                    Session["lstSupplementary_Tabs"] = new List<RightsU_Entities.Supplementary_Tab>();
                return (List<RightsU_Entities.Supplementary_Tab>)Session["lstSupplementary_Tabs"];
            }
            set { Session["lstSupplementary_Tabs"] = value; }
        }

        private List<RightsU_Entities.Supplementary_Tab> Supplementary_Tabs
        {
            get
            {
                if (Session["Supplementary_Tabs"] == null)
                    Session["Supplementary_Tabs"] = new List<RightsU_Entities.Supplementary_Tab>();
                return (List<RightsU_Entities.Supplementary_Tab>)Session["Supplementary_Tabs"];
            }
            set { Session["Supplementary_Tabs"] = value; }
        }

        private List<Supplementary_Config> lstSupplementary_Config
        {
            get
            {
                if (Session["lstSupplementary_Config"] == null)
                    Session["lstSupplementary_Config"] = new List<Supplementary_Config>();
                return (List<Supplementary_Config>)Session["lstSupplementary_Config"];
            }
            set { Session["lstSupplementary_Config"] = value; }
        }
        // GET: supplementry_Config
        public ActionResult Index()
        {
            lstSupplementary_Config = null;
            Supplementary_Tabs = null;
            lstSupplementary_Tabs = null;
            FetchData();
            return View();
        }

        private void FetchData()
        {
            lstSupplementary_Tabs = Supplementary_Tabs = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
        }

        public PartialViewResult BindConfigGrids(string key, int Supplimentary_TabCode)
        {
            Supplementary_Tab ObjSupp_Tab = new Supplementary_Tab();
            if (key == "LIST")
            {
                ViewBag.PageType = "List";
                FetchData();
                return PartialView("~/Views/supplementry_Config/_SuppConfigGrid.cshtml");
            }
            else
            {
                string selectedTabType = "";
                string selectedAddEditWindow = "";
                string selectedModule = "";
                if (key == "ADD")
                {
                    ViewBag.PageType = "ADD";
                    //ObjSupp_Tab = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).GetById(Supplimentary_TabCode);
                }
                else if (key == "EDIT")
                {
                    
                    ObjSupp_Tab = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).GetById(Supplimentary_TabCode);
                    selectedTabType = ObjSupp_Tab.Tab_Type;
                    selectedAddEditWindow = ObjSupp_Tab.EditWindowType;
                    selectedModule = Convert.ToString(ObjSupp_Tab.Module_Code);
                    ViewBag.PageType = "EDIT";
                }
                else if (key == "VIEW")
                {
                    ObjSupp_Tab = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).GetById(Supplimentary_TabCode);
                    selectedTabType = ObjSupp_Tab.Tab_Type;
                    selectedAddEditWindow = ObjSupp_Tab.EditWindowType;
                    selectedModule = Convert.ToString(ObjSupp_Tab.Module_Code);
                    ViewBag.PageType = "VIEW";
                }
                    lstSupplementary_Config = ObjSupp_Tab.Supplementary_Config.ToList();

                List<SelectListItem> lstModule = new List<SelectListItem>();
                lstModule.Add(new SelectListItem { Text = "Acquisition Deals", Value = "30" });
                lstModule.Add(new SelectListItem { Text = "Syndication Deals", Value = "35" });
                TempData["ModuleDDL"] = new SelectList(lstModule, "Value", "Text", selectedModule);

                List<SelectListItem> lstAddEditWindow = new List<SelectListItem>();
                lstAddEditWindow.Add(new SelectListItem { Text = "inLine", Value = "inLine" });
                lstAddEditWindow.Add(new SelectListItem { Text = "PopUp", Value = "PopUp" });
                TempData["EditWindowTypeDDL"] = new SelectList(lstAddEditWindow, "Value", "Text", selectedAddEditWindow);

                List<SelectListItem> lstTabType = new List<SelectListItem>();
                lstTabType.Add(new SelectListItem { Text = "NS", Value = "NS" });
                TempData["TabTypeDDL"] = new SelectList(lstTabType, "Value", "Text", selectedTabType);

                return PartialView("~/Views/supplementry_Config/_AddEditSuppConfig.cshtml", ObjSupp_Tab);
            }
        }
        [HttpPost]
        public PartialViewResult BindSuppConfigGrid(int pageNo, int recordPerPage)
        {
            List<Supplementary_Tab> lst = new List<Supplementary_Tab>();
            int RecordCount = 0;
            RecordCount = lstSupplementary_Tabs.Count();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstSupplementary_Tabs.OrderBy(o => o.Supplementary_Tab_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/supplementry_Config/_SuppConfigGridView.cshtml", lst);

        }

        public JsonResult SearchSuppConfig(string searchText)
        {
            //if (!string.IsNullOrEmpty(searchText))
            //{
            //    lstSupplementary_Tabs = Supplementary_Tabs.Where(w => w.Supplementary_Tab_Description.ToUpper().Contains(searchText.ToUpper())
            //    || w.Short_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            //}
            //else
            //    lstSupplementary_Tabs = Supplementary_Tabs;

            var obj = new
            {
                Record_Count = lstSupplementary_Tabs.Count
            };

            return Json(obj);
        }

        public JsonResult SearchConfig(string searchText)
        {
            var obj = new
            {
                Record_Count = lstSupplementary_Config.Count
            };

            return Json(obj);
        }

        [HttpPost]
        public PartialViewResult BindSuppConfigGridView(int SupplementaryTabCode, string PageType)
        {
            List<Supplementary_Config> lst = new List<Supplementary_Config>();
            int RecordCount = 0;
            ViewBag.PageType = PageType;
            RecordCount = lstSupplementary_Config.Where(x =>
             x.Supplementary_Tab_Code == SupplementaryTabCode ||
             x.Supplementary_Config_Code == 0
            ).Where(x => x.EntityState != State.Deleted).ToList().Count();
            if (RecordCount > 0)
            {
               // int noOfRecordSkip, noOfRecordTake;
               // pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);

                lst = lstSupplementary_Config.Where(x =>
                 x.Supplementary_Tab_Code == SupplementaryTabCode ||
                 x.Supplementary_Config_Code == 0
                ).Where(x => x.EntityState != State.Deleted).ToList();
            }

            return PartialView("~/Views/supplementry_Config/_TConfigDetailsList.cshtml", lst);
        }

        public JsonResult AddEditTabConfigDetails(int Id, string dummyGuid, string commandName)
        {
          
            string status = "S", message = "Record {ACTION} successfully";
            string SelectedSupplementary_Code = "";
            string Control_Type = "";
            string Is_Multiselect = "";
            string Whr_Criteria = "";
            if (commandName == "ADD")
            {
                TempData["Action"] = "AddConfig";
            }
            else if (commandName == "EDIT")
            {
                Supplementary_Config objSuppConfig = new Supplementary_Config();
                objSuppConfig = lstSupplementary_Config.Where(x => x.Dummy_Guid.ToString() == dummyGuid).FirstOrDefault();
                SelectedSupplementary_Code = Convert.ToString(objSuppConfig.Supplementary_Code);
                Control_Type = objSuppConfig.Control_Type;
                Is_Multiselect = objSuppConfig.Is_Multiselect;
                Whr_Criteria = objSuppConfig.Whr_Criteria;

                TempData["Action"] = "EditTabConfig";
                TempData["idTabConfig"] = objSuppConfig.Dummy_Guid;
            }

                List<Supplementary> lstSupplimentary = new Supplementary_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Supplementary_Name != null).ToList();
            TempData["SupplimentaryDDL"] = new SelectList(lstSupplimentary, "Supplementary_Code", "Supplementary_Name", SelectedSupplementary_Code);


            List<SelectListItem> lstControl_Type = new List<SelectListItem>();
            lstControl_Type.Add(new SelectListItem { Text = "TextArea", Value = "TXTAREA" });
            lstControl_Type.Add(new SelectListItem { Text = "Dropdown", Value = "TXTDDL" });
            lstControl_Type.Add(new SelectListItem { Text = "Date", Value = "DATE" });
            lstControl_Type.Add(new SelectListItem { Text = "CheckBox", Value = "CHK" });
            lstControl_Type.Add(new SelectListItem { Text = "Numeric", Value = "INT" });
            TempData["lstControl_Type"] = new SelectList(lstControl_Type, "Value", "Text", Control_Type);

            List<SelectListItem> lstIs_Multiselect = new List<SelectListItem>();
            lstIs_Multiselect.Add(new SelectListItem { Text = "Yes", Value = "Y" });
            lstIs_Multiselect.Add(new SelectListItem { Text = "No", Value = "N" });
            TempData["lstIs_MultiselectDDL"] = new SelectList(lstIs_Multiselect, "Value", "Text", Is_Multiselect);

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

        public JsonResult Savesupp_ConfigDetails(FormCollection objFormCollection)
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


            if (lstSupplementary_Config.Where(s => s.Supplementary_Code.ToString() == str_supplementary && s.EntityState != State.Deleted).Count() > 0)
            {
                status = "E";
                message = objMessageKey.RecordAlreadyExists;
            }
            else
            {
               Supplementary_Config objConfigDetails = new Supplementary_Config();
                objConfigDetails.Supplementary = new Supplementary();
                objConfigDetails.Supplementary_Tab = new Supplementary_Tab();

                objConfigDetails.Supplementary_Code = Convert.ToInt32(str_supplementary);
                objConfigDetails.Control_Type = str_controlType;
                objConfigDetails.Is_Multiselect = str_isMultipleSelect;
                objConfigDetails.Is_Mandatory = str_isMandatory;

                if (!string.IsNullOrEmpty(str_maxLength))
                {
                    objConfigDetails.Max_Length = Convert.ToInt32(str_maxLength);
                }
                if (!string.IsNullOrEmpty(str_pageControlOrder))
                {
                    objConfigDetails.Page_Control_Order = Convert.ToInt32(str_pageControlOrder);
                }

                if (!string.IsNullOrEmpty(str_controlFieldOrder))
                {
                    objConfigDetails.Control_Field_Order = Convert.ToInt32(str_controlFieldOrder);
                }
                objConfigDetails.View_Name = str_viewName;
                objConfigDetails.Text_Field = str_txtField;
                objConfigDetails.Value_Field = str_valueField;
                objConfigDetails.Whr_Criteria = str_additional;
                if (!string.IsNullOrEmpty(str_SupplementaryTabCode))
                {
                    objConfigDetails.Supplementary_Tab_Code = Convert.ToInt32(str_SupplementaryTabCode);
                }

                objConfigDetails.Supplementary_Config_Code = 0;
                objConfigDetails.Supplementary = new Supplementary_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(str_supplementary));

                objConfigDetails.EntityState = State.Added;
                lstSupplementary_Config.Add(objConfigDetails);
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult UpdateConfigDetails(FormCollection objFormCollection)
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

            if (lstSupplementary_Config.Where(x => x.Dummy_Guid != str_DummyGuid)
                .Where(s => s.Supplementary_Code.ToString() == str_supplementary && s.EntityState != State.Deleted).Count() > 0)
            {
                status = "E";
                message = objMessageKey.RecordAlreadyExists;
            }
            else
            {
                Supplementary_Config objTabConfig = lstSupplementary_Config.Where(x => x._Dummy_Guid == str_DummyGuid).SingleOrDefault();
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
        public JsonResult Save_Supp_Master(string Supp_Name)
        {
            
            string status = "S", message = "Record saved successfully";
            Supplementary_Service objService = new Supplementary_Service(objLoginEntity.ConnectionStringName);
            Supplementary objSupp= new Supplementary();
            objSupp.EntityState = State.Added;
            objSupp.Supplementary_Name = Supp_Name;
            objSupp.Is_Active = "Y";
            dynamic resultSet;
            bool isValid = objService.Save(objSupp, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objSupp.Supplementary_Code,
                Text = objSupp.Supplementary_Name
            };

            return Json(obj);
        }
        public JsonResult DeleteConfig(string dummyGuid)
        {
            string status = "S", message = "Record {ACTION} successfully";
            Supplementary_Config objConfig = lstSupplementary_Config.Where(x => x.Dummy_Guid.ToString() == dummyGuid).SingleOrDefault();
            if (objConfig != null)
            {
                if (objConfig.Supplementary_Config_Code > 0)
                {
                    objConfig.EntityState = State.Deleted;
                }
                else
                {
                    lstSupplementary_Config.Remove(objConfig);
                }
                message = objMessageKey.RecordDeletedsuccessfully;
            }
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

            string status = "s", message = "Record {ACTION} successfully";
            int Supplementary_Tab_Code = 0;
            if (objFormCollection["hdnSuppTabCode"] != null)
            {
                Supplementary_Tab_Code = Convert.ToInt32(objFormCollection["hdnSuppTabCode"]);
            }

            string Supplementary_Tab_Description = Convert.ToString(objFormCollection["Supplementary_Tab_Name"]).Trim();
            string Short_Name = Convert.ToString(objFormCollection["Short_Name"]).Trim();
            int Order_No = Convert.ToInt32(objFormCollection["Order_No"]);
            string Tab_Type = Convert.ToString(objFormCollection["ddlTabType"]);
            string EditWindowType = Convert.ToString(objFormCollection["ddlAddEditWindow"]);
           // string Is_Show = Convert.ToString(objFormCollection["Is_Show"]);
            int Module_Code = 0;
            if (objFormCollection["ddlModule"] != null && objFormCollection["ddlModule"] != "")
            {
                Module_Code = Convert.ToInt32(objFormCollection["ddlModule"]);
            }

            bool IsOrderNoExist = Supplementary_Tabs.Where(x => x.Order_No == Order_No && x.Supplementary_Tab_Code != Supplementary_Tab_Code).Count() > 0 ? true : false;
            if (lstSupplementary_Config.Where(x => x.EntityState != State.Deleted).Count() > 0 && IsOrderNoExist == false)
            {
                if (Supplementary_Tab_Code > 0)
                {
                    objSupplementary_Tab = objSupplementary_Tab_Service.GetById(Supplementary_Tab_Code);
                    objSupplementary_Tab.Supplementary_Tab_Description = Supplementary_Tab_Description;
                    objSupplementary_Tab.Short_Name = Short_Name;
                    objSupplementary_Tab.Order_No = Order_No;
                    objSupplementary_Tab.Tab_Type = Tab_Type;
                    objSupplementary_Tab.EditWindowType = EditWindowType;
                    objSupplementary_Tab.Module_Code = Module_Code;
                    objSupplementary_Tab.Is_Show = "N";
                    objSupplementary_Tab.EntityState = State.Modified;
                }
                else
                {
                    objSupplementary_Tab.Supplementary_Tab_Description = Supplementary_Tab_Description;
                    objSupplementary_Tab.Short_Name = Short_Name;
                    objSupplementary_Tab.Order_No = Order_No;
                    objSupplementary_Tab.Tab_Type = Tab_Type;
                    objSupplementary_Tab.EditWindowType = EditWindowType;
                    objSupplementary_Tab.Module_Code = Module_Code;
                    objSupplementary_Tab.Is_Show = "N";
                    objSupplementary_Tab.EntityState = State.Added;

                    objSupplementary_Tab.Supplementary_Tab_Code = objSupplementary_Tab_Service.SearchFor(t => true).Max(z => z.Supplementary_Tab_Code) + 1;
                }

                foreach (var item in lstSupplementary_Config)
                {
                    if (item.Supplementary_Config_Code > 0)
                    {
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
                        lstSupplementary_Tabs = Supplementary_Tabs = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                        status = "S";
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
                if (IsOrderNoExist)
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
    }
}