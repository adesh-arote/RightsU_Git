using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class VendorController : BaseController
    {
        #region --- Properties ---

        private List<RightsU_Entities.Vendor> lstVendor
        {
            get
            {
                if (Session["lstVendor"] == null)
                    Session["lstVendor"] = new List<RightsU_Entities.Vendor>();
                return (List<RightsU_Entities.Vendor>)Session["lstVendor"];
            }
            set { Session["lstVendor"] = value; }
        }

        private List<RightsU_Entities.Vendor> lstVendor_Searched
        {
            get
            {
                if (Session["lstVendor_Searched"] == null)
                    Session["lstVendor_Searched"] = new List<RightsU_Entities.Vendor>();
                return (List<RightsU_Entities.Vendor>)Session["lstVendor_Searched"];
            }
            set { Session["lstVendor_Searched"] = value; }
        }

        private List<RightsU_Entities.Vendor_Contacts> lstVendorContact
        {
            get
            {
                if (Session["lstVendorContact"] == null)
                    Session["lstVendorContact"] = new List<RightsU_Entities.Vendor_Contacts>();
                return (List<RightsU_Entities.Vendor_Contacts>)Session["lstVendorContact"];
            }
            set { Session["lstVendorContact"] = value; }
        }

        private List<RightsU_Entities.Vendor_Contacts> lstVendorContact_Searched
        {
            get
            {
                if (Session["lstVendorContact_Searched"] == null)
                    Session["lstVendorContact_Searched"] = new List<RightsU_Entities.Vendor_Contacts>();
                return (List<RightsU_Entities.Vendor_Contacts>)Session["lstVendorContact_Searched"];
            }
            set { Session["lstVendorContact_Searched"] = value; }
        }

        private List<RightsU_Entities.Country> lstCountry
        {
            get
            {
                if (Session["lstCountry"] == null)
                    Session["lstCountry"] = new List<RightsU_Entities.Country>();
                return (List<RightsU_Entities.Country>)Session["lstCountry"];
            }
            set { Session["lstCountry"] = value; }
        }

        private List<RightsU_Entities.Country> lstCountry_Searched
        {
            get
            {
                if (Session["lstCountry_Searched"] == null)
                    Session["lstCountry_Searched"] = new List<RightsU_Entities.Country>();
                return (List<RightsU_Entities.Country>)Session["lstCountry_Searched"];
            }
            set { Session["lstCountry_Searched"] = value; }
        }

        private List<RightsU_Entities.Role> lstRole
        {
            get
            {
                if (Session["lstRole"] == null)
                    Session["lstRole"] = new List<RightsU_Entities.Role>();
                return (List<RightsU_Entities.Role>)Session["lstRole"];
            }
            set { Session["lstRole"] = value; }
        }

        private List<RightsU_Entities.Role> lstRole_Searched
        {
            get
            {
                if (Session["lstRole_Searched"] == null)
                    Session["lstRole_Searched"] = new List<RightsU_Entities.Role>();
                return (List<RightsU_Entities.Role>)Session["lstRole_Searched"];
            }
            set { Session["lstRole_Searched"] = value; }
        }

        private string ModuleCode
        {
            get
            {
                if (Session["ModuleCode"] == null)
                {
                    Session["ModuleCode"] = 0;
                }
                return Convert.ToString(Session["ModuleCode"].ToString());
            }
            set
            {
                Session["ModuleCode"] = value;
            }
        }

        #endregion

        #region ------Additional Info---

        private AL_Vendor_Details objSessALVendorDetails
        {
            get
            {
                if (Session["APVendorDetails"] == null)
                    Session["APVendorDetails"] = new AL_Vendor_Details();
                return (AL_Vendor_Details)Session["APVendorDetails"];
            }
            set
            {
                Session["APVendorDetails"] = value;
            }
        }

        //private AL_Vendor_Rule APVendorRule
        //{
        //    get
        //    {
        //        if (Session["APVendorRule"] == null)
        //            Session["APVendorRule"] = new AL_Vendor_Rule();
        //        return (AL_Vendor_Rule)Session["APVendorRule"];
        //    }
        //    set
        //    {
        //        Session["APVendorRule"] = value;
        //    }
        //}

        //private AL_Vendor_Rule_Criteria APVendorRuleCriteria
        //{
        //    get
        //    {
        //        if (Session["APVendorRuleCriteria"] == null)
        //            Session["APVendorRuleCriteria"] = new AL_Vendor_Rule_Criteria();
        //        return (AL_Vendor_Rule_Criteria)Session["APVendorRuleCriteria"];
        //    }
        //    set
        //    {
        //        Session["APVendorRuleCriteria"] = value;
        //    }
        //}

        //private AL_Vendor_OEM APVendorOEM //APVendorOem
        //{
        //    get
        //    {
        //        if (Session["APVendorOem"] == null)
        //            Session["APVendorOem"] = new AL_Vendor_OEM();
        //        return (AL_Vendor_OEM)Session["APVendorOem"];
        //    }
        //    set
        //    {
        //        Session["APVendorOem"] = value;
        //    }
        //}

        //private AL_Vendor_TnC APVendorTnC
        //{
        //    get
        //    {
        //        if (Session["APVendorTnC"] == null)
        //            Session["APVendorTnC"] = new AL_Vendor_TnC();
        //        return (AL_Vendor_TnC)Session["APVendorTnC"];
        //    }
        //    set
        //    {
        //        Session["APVendorTnC"] = value;
        //    }
        //}

        private RightsU_Entities.Vendor objSessVendor
        {
            get
            {
                if (Session["SessVendor"] == null)
                    Session["SessVendor"] = new RightsU_Entities.Vendor();
                return (RightsU_Entities.Vendor)Session["SessVendor"];
            }
            set
            {
                Session["SessVendor"] = value;
            }
        }

        private RightsU_Entities.AL_Vendor_Rule objVr
        {
            get
            {
                if (Session["SessContentRule"] == null)
                    Session["SessContentRule"] = new RightsU_Entities.AL_Vendor_Rule();
                return (RightsU_Entities.AL_Vendor_Rule)Session["SessContentRule"];
            }
            set
            {
                Session["SessContentRule"] = value;
            }
        }

        private List<RightsU_Entities.Extended_Columns> DDlExtendedColumnsLst
        {
            get
            {
                if (Session["DDlExtendedColumnsLst"] == null)
                    Session["DDlExtendedColumnsLst"] = new List<RightsU_Entities.Extended_Columns>();
                return (List<RightsU_Entities.Extended_Columns>)Session["DDlExtendedColumnsLst"];
            }
            set
            {
                Session["DDlExtendedColumnsLst"] = value;
            }
        }

        private List<int> UsedDDlExtendedColumnsLst
        {
            get
            {
                if (Session["UsedDDlExtendedColumnsLst"] == null)
                    Session["UsedDDlExtendedColumnsLst"] = new List<int>();
                return (List<int>)Session["UsedDDlExtendedColumnsLst"];
            }
            set
            {
                Session["UsedDDlExtendedColumnsLst"] = value;
            }
        }

        private List<RightsU_Entities.AL_OEM> DDlOEMLst
        {
            get
            {
                if (Session["DDlOEMLst"] == null)
                    Session["DDlOEMLst"] = new List<RightsU_Entities.AL_OEM>();
                return (List<RightsU_Entities.AL_OEM>)Session["DDlOEMLst"];
            }
            set
            {
                Session["DDlOEMLst"] = value;
            }
        }

        private List<int> UsedDDlOEMlst
        {
            get
            {
                if (Session["UsedDDlOEMlst"] == null)
                    Session["UsedDDlOEMlst"] = new List<int>();
                return (List<int>)Session["UsedDDlOEMlst"];
            }
            set
            {
                Session["UsedDDlOEMlst"] = value;
            }
        }

        private List<RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result> lstSelectObject
        {
            get
            {
                if (Session["varListType"] == null)
                    Session["varListType"] = new List<RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result>();
                return (List<RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result>)Session["varListType"];
            }
            set
            {
                Session["varListType"] = value;
            }
        }

        private List<string> SelectedColumnValues
        {
            get
            {
                if (Session["SelectedColumnValues"] == null)
                    Session["SelectedColumnValues"] = new List<string>();
                return (List<string>)Session["SelectedColumnValues"];
            }
            set
            {
                Session["SelectedColumnValues"] = value;
            }
        }

        private Dictionary<string, object> objSessDictionary
        {
            get
            {
                if (Session["DictionarySessionObj"] == null)
                    Session["DictionarySessionObj"] = new Dictionary<string, object>();
                return (Dictionary<string, object>)Session["DictionarySessionObj"];
            }
            set
            {
                Session["DictionarySessionObj"] = value;
            }
        }

        #endregion

        #region --- List And Binding ---

        public ViewResult Index()
        {
            string VendorModuleCode = Request.QueryString["modulecode"];
            if (VendorModuleCode == "10")
            {
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForVendor);
                //ModuleCode = Request.QueryString["modulecode"];
                ModuleCode = GlobalParams.ModuleCodeForVendor.ToString();
                //lstRole_Searched = lstRole_Searched = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Role_Type == "V").ToList();
                //lstCountry_Searched = lstCountry = new Country_Service().SearchFor(x => x.Is_Active == "Y").ToList();
                //lstVendor_Searched = lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
                //lstVendorContact_Searched = lstVendorContact = new Vendor_Contacts_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                //ViewBag.UserModuleRights = GetUserModuleRights();              
            }
            else
            {
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCustomer);
                ModuleCode = GlobalParams.ModuleCodeForCustomer.ToString();
            }

            return View("~/Views/Vendor/Index.cshtml");
        }

        public PartialViewResult BindVendorList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.Vendor> lst = new List<RightsU_Entities.Vendor>();
            int RecordCount = 0;
            //if (ModuleCode == "10")
            //    lstVendor_Searched = lstVendor_Searched.Where(w => w.Party_Type == "V").ToList();
            //else
            //    lstVendor_Searched = lstVendor_Searched.Where(w => w.Party_Type == "C").ToList();

            RecordCount = lstVendor_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstVendor_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstVendor_Searched.OrderBy(o => o.Vendor_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstVendor_Searched.OrderByDescending(o => o.Vendor_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Vendor/_VendorList.cshtml", lst);
        }

        public PartialViewResult BindVendorContact(int VendorCode, string Mode)
        {
            List<RightsU_Entities.Vendor_Contacts> lst = new List<RightsU_Entities.Vendor_Contacts>();
            int RecordCount = 0;
            ViewBag.Mode = Mode;
            RecordCount = lstVendorContact_Searched.Where(x => x.Vendor_Code == VendorCode || x.Vendor_Code == 0).Where(x => x.EntityState != State.Deleted).ToList().Count();
            if (RecordCount > 0)
            {
                lst = lstVendorContact_Searched.Where(x => x.Vendor_Code == VendorCode || x.Vendor_Code == 0).Where(x => x.EntityState != State.Deleted).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Vendor/_Add_Edit_Vendor.cshtml", lst);
        }

        public PartialViewResult BindPartialPages(string key, int VendorCode)
        {
            string ModuleName = "";
            ViewBag.isProdHouse = GetUserModuleRights().Contains(GlobalParams.RightCodeForProductionHouseUser.ToString());
            string AllowShortCode = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "allow_ShortCodeFor_Vendor").Select(s => s.Parameter_Value).FirstOrDefault();
            ViewBag.AllowShortCode = AllowShortCode;
            ViewBag.IsAllowPartyMaster = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "IsAllowPartyMaster").Select(w => w.Parameter_Value).FirstOrDefault();
            Vendor_Service objService = new Vendor_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Vendor objVendor = null;
            if (key == "LIST")
            {
                ViewBag.Code = ModuleCode;
                ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
                List<SelectListItem> lstSort = new List<SelectListItem>();
                lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
                ViewBag.SortType = lstSort;
                lstRole_Searched = lstRole_Searched = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Role_Type.Contains("V")).ToList();
                lstCountry_Searched = lstCountry = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                string IsAeroplay = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Allow_Party_Details").Select(w => w.Parameter_Value).FirstOrDefault();
                if(IsAeroplay == "Y")   // Allow_Party_Details = paremeter used for aeroplay, non-aeroplay wise configuration - IF Y then Aeroplay else N for non-aeroplay
                {
                    lstVendor_Searched = lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
                    ModuleName = "Party";   
                }
                else
                {
                    if (ModuleCode == Convert.ToString(GlobalParams.ModuleCodeForVendor))
                    {
                        lstVendor_Searched = lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Party_Type == "V").OrderByDescending(o => o.Last_Updated_Time).ToList();
                        ModuleName = "Party";
                    }
                    else
                    {
                        lstVendor_Searched = lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Party_Type == "C").OrderByDescending(o => o.Last_Updated_Time).ToList();
                        ModuleName = "Customer";
                    }
                }
                
                ViewBag.ModuleName = ModuleName;
                lstVendorContact_Searched = lstVendorContact = new Vendor_Contacts_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/Vendor/_Vendor.cshtml");
            }
            else
            {
                int PartyMasterCode = 0;
                Session["VendorCode_AddEdit"] = VendorCode;
                if (VendorCode > 0 && key != "VIEW")
                {
                    ViewBag.Mode = "";
                    ViewData["Status"] = "U";
                    objVendor = objService.GetById(VendorCode);

                    ViewData["MyVendor"] = objVendor;
                    #region  --- Country ---
                    List<SelectListItem> listSelectListItems = new List<SelectListItem>();
                    List<Vendor_Country> strCode = objVendor.Vendor_Country.ToList().Where(x => x.Is_Theatrical == "N").ToList();
                    foreach (var country in strCode)
                    {
                        int i = Convert.ToInt32(country.Country_Code);
                        RightsU_Entities.Country objCountry = lstCountry_Searched.Where(x => x.Country_Code == i).SingleOrDefault();
                        string CountryName = objCountry.Country_Name;
                        SelectListItem selectList = new SelectListItem()
                        {
                            Text = CountryName,
                            Value = i.ToString(),
                            Selected = true
                        };
                        listSelectListItems.Add(selectList);
                    }
                    List<RightsU_Entities.Country> temp_lstCountry = new List<RightsU_Entities.Country>();
                    temp_lstCountry = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "N").ToList(); ;
                    foreach (var item in strCode)
                    {
                        int i = Convert.ToInt32(item.Country_Code);
                        var akshay = lstCountry_Searched.First(x => x.Country_Code == i);
                        temp_lstCountry.Remove(akshay);
                    }
                    foreach (RightsU_Entities.Country city in temp_lstCountry)
                    {
                        SelectListItem selectList = new SelectListItem()
                        {
                            Text = city.Country_Name,
                            Value = city.Country_Code.ToString(),
                        };
                        listSelectListItems.Add(selectList);
                    }
                    TempData["Country"] = listSelectListItems;
                    #endregion
                    #region --- Theterical ---
                    List<SelectListItem> listSelectListItems_Theatrical = new List<SelectListItem>();
                    List<Vendor_Country> strCode_Theterical = objVendor.Vendor_Country.ToList().Where(x => x.Is_Theatrical == "Y").ToList();
                    foreach (var country in strCode_Theterical)
                    {
                        int i = Convert.ToInt32(country.Country_Code);
                        RightsU_Entities.Country objCountry = lstCountry_Searched.Where(x => x.Country_Code == i).SingleOrDefault();
                        string CountryName = objCountry.Country_Name;
                        SelectListItem selectList = new SelectListItem()
                        {
                            Text = CountryName,
                            Value = i.ToString(),
                            Selected = true
                        };
                        listSelectListItems_Theatrical.Add(selectList);
                    }
                    List<RightsU_Entities.Country> temp_lstCountry_Theaterical = new List<RightsU_Entities.Country>();
                    temp_lstCountry_Theaterical = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "Y").ToList(); ;
                    foreach (var item in strCode_Theterical)
                    {
                        int i = Convert.ToInt32(item.Country_Code);
                        var lstCountry = lstCountry_Searched.First(x => x.Country_Code == i);
                        temp_lstCountry_Theaterical.Remove(lstCountry);
                    }
                    foreach (RightsU_Entities.Country city in temp_lstCountry_Theaterical)
                    {
                        SelectListItem selectList = new SelectListItem()
                        {
                            Text = city.Country_Name,
                            Value = city.Country_Code.ToString(),
                        };
                        listSelectListItems_Theatrical.Add(selectList);
                    }
                    TempData["Theatrical"] = listSelectListItems_Theatrical;
                    Syn_Deal_Service objSDS = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
                    List<Syn_Deal> lstSyn_Deal = objSDS.SearchFor(s => s.Vendor_Code == VendorCode).ToList();

                    Acq_Deal_Service objADS = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                    List<Acq_Deal> lstAcq_Deal = objADS.SearchFor(s => s.Vendor_Code == VendorCode).ToList();

                    var ListSType = lstSyn_Deal.Select(x => x.Customer_Type).Distinct().ToList();
                    var ListAType = lstAcq_Deal.Select(a => a.Role_Code).Distinct().ToList();

                    //List<int> lstType = (List<int>)ListSType;

                    ViewData["ListSType"] = ListSType;
                    ViewData["ListAType"] = ListAType;
                    #endregion

                    #region -----type-----
                    List<Role> lstRole = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Role_Type.Contains("V")).OrderBy(o => o.Role_Name).ToList();
                    var roleCodes = objVendor.Vendor_Role.Select(s => s.Role_Code).ToArray();
                    //var roleCodes = new[] { 8, 29 };
                    // ViewBag.RoleList = new MultiSelectList(lstRole, "Role_Code", "Role_Name", new[] { 8, 29 });
                    TempData["RoleList"] = new MultiSelectList(lstRole, "Role_Code", "Role_Name", roleCodes);
                    #endregion
                    List<RightsU_Entities.Party_Category> lstPartyCategory = new Party_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                    var PartyCategoryCode = objVendor.Party_Category_Code;
                    ViewBag.PartyCategory = new SelectList(lstPartyCategory, "Party_Category_Code", "Party_Category_Name", PartyCategoryCode);
                    PartyMasterCode = Convert.ToInt32(objVendor.Party_Group_Code);

                }
                else if (key == "VIEW")
                {
                    objVendor = objService.GetById(VendorCode);
                    ViewBag.Mode = "V";
                    ViewData["MyVendor"] = objVendor;
                }
                else
                {
                    ViewBag.Mode = "";
                    List<Role> lstRole = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Role_Type.Contains("V")).OrderBy(o => o.Role_Name).ToList();
                    TempData["RoleList"] = new MultiSelectList(lstRole, "Role_Code", "Role_Name");
                    List<SelectListItem> lstRoles = new List<SelectListItem>();
                    List<RightsU_Entities.Role> temp_lstRoles = lstRole_Searched.Where(x => x.Role_Type.Contains("V")).ToList();
                    foreach (RightsU_Entities.Role city in temp_lstRoles)
                    {
                        SelectListItem selectList = new SelectListItem()
                        {
                            Text = city.Role_Name,
                            Value = city.Role_Code.ToString(),
                        };
                        lstRoles.Add(selectList);
                    }
                    TempData["Roles"] = lstRoles;
                    ViewData["Status"] = "A";
                    ViewData["MyVendor"] = "";
                    #region == country & theterical
                    List<SelectListItem> listSelectListItems = new List<SelectListItem>();
                    List<RightsU_Entities.Country> temp_lstCountry = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "N").ToList();
                    foreach (RightsU_Entities.Country city in temp_lstCountry)
                    {
                        SelectListItem selectList = new SelectListItem()
                        {
                            Text = city.Country_Name,
                            Value = city.Country_Code.ToString(),
                        };
                        listSelectListItems.Add(selectList);
                    }
                    TempData["Country"] = listSelectListItems;
                    List<SelectListItem> listSelectListItems_Theatrical = new List<SelectListItem>();
                    List<RightsU_Entities.Country> temp_lstTheatrical = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "Y").ToList();
                    foreach (RightsU_Entities.Country city in temp_lstTheatrical)
                    {
                        SelectListItem selectList = new SelectListItem()
                        {
                            Text = city.Country_Name,
                            Value = city.Country_Code.ToString(),
                        };
                        listSelectListItems_Theatrical.Add(selectList);
                    }
                    TempData["Theatrical"] = listSelectListItems_Theatrical;
                    #endregion
                    List<RightsU_Entities.Party_Category> lstPartyCategory = new Party_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                    ViewBag.PartyCategory = new SelectList(lstPartyCategory, "Party_Category_Code", "Party_Category_Name");
                }
                List<SelectListItem> PartySelectList = new List<SelectListItem>();
                PartySelectList = new SelectList(new Party_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderBy(o => o.Party_Group_Name), "Party_Group_Code", "Party_Group_Name", PartyMasterCode).ToList();
                PartySelectList.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
                ViewBag.PartyMasterList = PartySelectList;

                // Send this list to the view                     
                objSessVendor = objVendor;
                objSessALVendorDetails = new AL_Vendor_Details();
                if (objVendor != null && objVendor.AL_Vendor_Details != null)
                {
                    objSessALVendorDetails = objVendor.AL_Vendor_Details.FirstOrDefault();
                }
                return PartialView("~/Views/Vendor/_AddEditPartyVendor.cshtml");
            }
        }

        #endregion

        #region  --- Other Methods ---

        public JsonResult CheckRecordLock(int VendorCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (VendorCode > 0)
            {
                if (ModuleCode == "10")
                    isLocked = DBUtil.Lock_Record(VendorCode, GlobalParams.ModuleCodeForVendor, objLoginUser.Users_Code, out RLCode, out strMessage);
                else
                    isLocked = DBUtil.Lock_Record(VendorCode, GlobalParams.ModuleCodeForCustomer, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
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
            List<string> lstRights = new List<string>();
            if (ModuleCode == "10")
            {
                lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForVendor), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            }
            else
            {
                lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCustomer), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            }
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
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

        public JsonResult Save_Party_Master(string Party_Master_Name)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string status = "S", message = "Record saved successfully";
            Party_Group_Service objService = new Party_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Party_Group objPartyGroup = new RightsU_Entities.Party_Group();
            objPartyGroup.EntityState = State.Added;
            objPartyGroup.InsertedOn = DateTime.Now;
            objPartyGroup.Last_Updated_By = DateTime.Now;
            objPartyGroup.Is_Active = "Y";
            objPartyGroup.Party_Group_Name = Party_Master_Name;
            dynamic resultSet;
            bool isValid = objService.Save(objPartyGroup, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objPartyGroup.Party_Group_Code,
                Text = objPartyGroup.Party_Group_Name
            };

            return Json(obj);
        }

        #endregion

        #region --- vendorList ---

        public JsonResult SearchVendor(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstVendor_Searched = lstVendor.Where(w => w.Vendor_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstVendor_Searched = lstVendor;

            var obj = new
            {
                Record_Count = lstVendor_Searched.Count
            };
            return Json(obj);
        }

        public ActionResult AddEditVendorList(int VendorCode)
        {
            ViewBag.IsAllowPartyMaster = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "IsAllowPartyMaster").Select(w => w.Parameter_Value).FirstOrDefault();
            Session["VendorCode_AddEdit"] = VendorCode;
            if (VendorCode > 0)
            {
                ViewData["Status"] = "U";
                Vendor_Service objService = new Vendor_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Vendor objVendor = objService.GetById(VendorCode);
                ViewData["MyVendor"] = objVendor;
                #region  --- Country ---
                List<SelectListItem> listSelectListItems = new List<SelectListItem>();
                List<Vendor_Country> strCode = objVendor.Vendor_Country.ToList().Where(x => x.Is_Theatrical == "N").ToList();
                foreach (var country in strCode)
                {
                    int i = Convert.ToInt32(country.Country_Code);
                    RightsU_Entities.Country objCountry = lstCountry_Searched.Where(x => x.Country_Code == i).SingleOrDefault();
                    string CountryName = objCountry.Country_Name;
                    SelectListItem selectList = new SelectListItem()
                    {
                        Text = CountryName,
                        Value = i.ToString(),
                        Selected = true
                    };
                    listSelectListItems.Add(selectList);
                }
                List<RightsU_Entities.Country> temp_lstCountry = new List<RightsU_Entities.Country>();
                temp_lstCountry = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "N").ToList(); ;
                foreach (var item in strCode)
                {
                    int i = Convert.ToInt32(item.Country_Code);
                    var removeCountry = lstCountry_Searched.First(x => x.Country_Code == i);
                    temp_lstCountry.Remove(removeCountry);
                }
                foreach (RightsU_Entities.Country city in temp_lstCountry)
                {
                    SelectListItem selectList = new SelectListItem()
                    {
                        Text = city.Country_Name,
                        Value = city.Country_Code.ToString(),
                    };
                    listSelectListItems.Add(selectList);
                }
                TempData["Country"] = listSelectListItems;
                #endregion
                #region --- Theterical ---
                List<SelectListItem> listSelectListItems_Theatrical = new List<SelectListItem>();
                List<Vendor_Country> strCode_Theterical = objVendor.Vendor_Country.ToList().Where(x => x.Is_Theatrical == "Y").ToList();
                foreach (var country in strCode_Theterical)
                {
                    int i = Convert.ToInt32(country.Country_Code);
                    RightsU_Entities.Country objCountry = lstCountry_Searched.Where(x => x.Country_Code == i).SingleOrDefault();
                    string CountryName = objCountry.Country_Name;
                    SelectListItem selectList = new SelectListItem()
                    {
                        Text = CountryName,
                        Value = i.ToString(),
                        Selected = true
                    };
                    listSelectListItems_Theatrical.Add(selectList);
                }
                List<RightsU_Entities.Country> temp_lstCountry_Theaterical = new List<RightsU_Entities.Country>();
                temp_lstCountry_Theaterical = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "Y").ToList(); ;
                foreach (var item in strCode_Theterical)
                {
                    int i = Convert.ToInt32(item.Country_Code);
                    var akshay = lstCountry_Searched.First(x => x.Country_Code == i);
                    temp_lstCountry_Theaterical.Remove(akshay);
                }
                foreach (RightsU_Entities.Country city in temp_lstCountry_Theaterical)
                {
                    SelectListItem selectList = new SelectListItem()
                    {
                        Text = city.Country_Name,
                        Value = city.Country_Code.ToString(),
                    };
                    listSelectListItems_Theatrical.Add(selectList);
                }
                TempData["Theatrical"] = listSelectListItems_Theatrical;

                #endregion
            }
            else
            {
                ViewData["Status"] = "A";
                ViewData["MyVendor"] = "";
                #region == country & theterical
                List<SelectListItem> listSelectListItems = new List<SelectListItem>();
                List<RightsU_Entities.Country> temp_lstCountry = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "N").ToList();
                foreach (RightsU_Entities.Country city in temp_lstCountry)
                {
                    SelectListItem selectList = new SelectListItem()
                    {
                        Text = city.Country_Name,
                        Value = city.Country_Code.ToString(),
                    };
                    listSelectListItems.Add(selectList);
                }
                TempData["Country"] = listSelectListItems;
                List<SelectListItem> listSelectListItems_Theatrical = new List<SelectListItem>();
                List<RightsU_Entities.Country> temp_lstTheatrical = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "Y").ToList();
                foreach (RightsU_Entities.Country city in temp_lstTheatrical)
                {
                    SelectListItem selectList = new SelectListItem()
                    {
                        Text = city.Country_Name,
                        Value = city.Country_Code.ToString(),
                    };
                    listSelectListItems_Theatrical.Add(selectList);
                }
                TempData["Theatrical"] = listSelectListItems_Theatrical;
                #endregion
            }
            ViewData["Role"] = lstRole_Searched; // Send this list to the view
            //return View("~/Views/Vendor/Add_Edit_Vendor.cshtml");
            return View("~/Views/Vendor/_AddEditPartyVendor.cshtml");

        }

        public JsonResult SaveVendor(RightsU_Entities.Vendor objUser_MVC, FormCollection objFormCollection)
        {
            Vendor_Service objVendorService = new Vendor_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Vendor objVendor = new RightsU_Entities.Vendor();
            #region --FormCollection
            var listSelectedCountry = new String[0];
            var listSelectedTheatrical = new String[0];
            List<int> Type_ID = new List<int>();
            int VendorCode = 0;
            if (objFormCollection["VendorCode"] != null)
            {
                VendorCode = Convert.ToInt32(objFormCollection["VendorCode"]);
            }
            string Vendor_Name = objFormCollection["Vendor_Name"].ToString().Trim();
            string Vendor_Addr = objFormCollection["Vendor_Addr"].ToString().Trim();
            string Vendor_PhNo = objFormCollection["Vendor_PhNo"].ToString().Trim();
            string Vendor_FaxNo = objFormCollection["Vendor_FaxNo"].ToString().Trim();
            string Vendor_STNo = objFormCollection["Vendor_STNo"].ToString().Trim();
            string Vendor_VATNo = objFormCollection["Vendor_VATNo"].ToString().Trim();
            string Vendor_TINNo = objFormCollection["Vendor_TINNo"].ToString().Trim();
            string Vendor_PANNo = objFormCollection["Vendor_PANNo"].ToString().Trim();
            string Vendor_CSTNo = objFormCollection["Vendor_CSTNo"].ToString().Trim();
            string Vendor_CINno = objFormCollection["Vendor_CINno"].ToString().Trim();
            string Vendor_GSTNo = objFormCollection["Vendor_GSTNo"].ToString().Trim();
            int Party_Group_Code = Convert.ToInt32(objFormCollection["Party_Group_Code"]);
            int PartyCategoryCode = 0;
            if (objFormCollection["ddlPartyCategory"] != null && objFormCollection["ddlPartyCategory"] != "")
            {
                PartyCategoryCode = Convert.ToInt32(objFormCollection["ddlPartyCategory"]);
            }
            if (objFormCollection["Country"] != null)
            {
                listSelectedCountry = Convert.ToString(objFormCollection["Country"]).Split(',');
            }
            if (objFormCollection["Theatrical"] != null)
            {
                listSelectedTheatrical = Convert.ToString(objFormCollection["Theatrical"]).Split(',');
            }

            #endregion
            string status = "S", message = "Record {ACTION} successfully";
            if (VendorCode > 0)
            {
                #region   -- -Update vendor
                objVendor = objVendorService.GetById(VendorCode);
                objVendor.Vendor_Name = Vendor_Name;
                objVendor.Address = Vendor_Addr;
                objVendor.Phone_No = Vendor_PhNo;
                objVendor.Short_Code = Vendor_FaxNo;
                objVendor.ST_No = Vendor_STNo;
                objVendor.VAT_No = Vendor_VATNo;
                objVendor.TIN_No = Vendor_TINNo;
                objVendor.PAN_No = Vendor_PANNo;
                objVendor.CST_No = Vendor_CSTNo;
                objVendor.CIN_No = Vendor_CINno;
                objVendor.GST_No = Vendor_GSTNo;
                if (ModuleCode == "10")
                    objVendor.Party_Type = "V";
                else
                    objVendor.Party_Type = "C";
                if (PartyCategoryCode > 0)
                    objVendor.Party_Category_Code = PartyCategoryCode;
                else
                    objVendor.Party_Category_Code = null;
                objVendor.Last_Action_By = objLoginUser.Users_Code;
                objVendor.Party_Group_Code = Party_Group_Code;
                if (objVendor.Party_Group_Code == 0)
                    objVendor.Party_Group_Code = null;
                objVendor.EntityState = State.Modified;
                ICollection<Vendor_Country> VendorCountryList = new HashSet<Vendor_Country>();
                if (objFormCollection["Country"] != null)
                {
                    foreach (var CountryCode in listSelectedCountry)
                    {
                        int i = Convert.ToInt32(CountryCode);
                        RightsU_Entities.Vendor_Country objCountry = new RightsU_Entities.Vendor_Country();
                        objCountry.EntityState = State.Added;
                        objCountry.Is_Theatrical = "N";
                        objCountry.Country_Code = i;
                        VendorCountryList.Add(objCountry);
                    }
                }
                IEqualityComparer<Vendor_Country> comparerVendorCountry = new LambdaComparer<Vendor_Country>((x, y) => x.Country_Code == y.Country_Code && x.Is_Theatrical == "N" && x.EntityState != State.Deleted);
                var Deleted_Vendor_Country = new List<Vendor_Country>();
                var Updated_Vendor_Country = new List<Vendor_Country>();
                var Added_Vendor_Country = CompareLists<Vendor_Country>(VendorCountryList.ToList<Vendor_Country>(), objVendor.Vendor_Country.Where(x => x.Is_Theatrical == "N").ToList<Vendor_Country>(), comparerVendorCountry, ref Deleted_Vendor_Country, ref Updated_Vendor_Country);
                Added_Vendor_Country.ToList<Vendor_Country>().ForEach(t => objVendor.Vendor_Country.Add(t));
                Deleted_Vendor_Country.ToList<Vendor_Country>().ForEach(t => t.EntityState = State.Deleted);


                //if (objVendor.Acq_Deal.Count > 0 || objVendor.Acq_Deal_Cost_Commission.Count > 0 ||objVendor.Acq_Deal_Cost_Variable_Cost.Count > 0 ||objVendor.Acq_Deal_Licensor.Count > 0 ||objVendor.Syn_Deal.Count > 0 ||objVendor.Syn_Deal_Revenue_Commission.Count > 0 
                //    || objVendor.Syn_Deal_Revenue_Variable_Cost.Count > 0 )
                //{
                //    if (Deleted_Vendor_Country.Count > 0 ||)
                //    {
                //        status = "E";
                //        message = "Party is already used. You cannot remove existing countries.";
                //    }
                //}



                ICollection<Vendor_Country> VendorTheatricalList = new HashSet<Vendor_Country>();
                if (objFormCollection["Theatrical"] != null)
                {
                    foreach (var CountryCode in listSelectedTheatrical)
                    {
                        int i = Convert.ToInt32(CountryCode);
                        RightsU_Entities.Vendor_Country objCountry = new RightsU_Entities.Vendor_Country();
                        objCountry.Is_Theatrical = "Y";
                        objCountry.Country_Code = i;
                        VendorTheatricalList.Add(objCountry);
                    }
                }
                IEqualityComparer<Vendor_Country> comparerVendorTheaterical = new LambdaComparer<Vendor_Country>((x, y) => x.Country_Code == y.Country_Code && x.Is_Theatrical == "Y" && x.EntityState != State.Deleted);
                var Deleted_Vendor_Theaterical = new List<Vendor_Country>();
                var Updated_Vendor_Theaterical = new List<Vendor_Country>();
                var Added_Vendor_Theaterical = CompareLists<Vendor_Country>(VendorTheatricalList.ToList<Vendor_Country>(), objVendor.Vendor_Country.Where(x => x.Is_Theatrical == "Y").ToList<Vendor_Country>(), comparerVendorTheaterical, ref Deleted_Vendor_Theaterical, ref Updated_Vendor_Theaterical);
                Added_Vendor_Theaterical.ToList<Vendor_Country>().ForEach(t => objVendor.Vendor_Country.Add(t));
                Deleted_Vendor_Theaterical.ToList<Vendor_Country>().ForEach(t => t.EntityState = State.Deleted);


                List<RightsU_Entities.Vendor_Contacts> tempVendorContact = new List<RightsU_Entities.Vendor_Contacts>();
                tempVendorContact = lstVendorContact_Searched.Where(x => x.Vendor_Code == 0 || x.Vendor_Code == VendorCode && x.EntityState != State.Deleted).ToList();
                IEqualityComparer<Vendor_Contacts> comparerVendor_Contacts = new LambdaComparer<Vendor_Contacts>((x, y) => x.Vendor_Contacts_Code == y.Vendor_Contacts_Code && x.EntityState != State.Deleted);
                var Deleted_Vendor_Contacts = new List<Vendor_Contacts>();
                var Updated_Vendor_Contacts = new List<Vendor_Contacts>();
                var Added_Vendor_Contacts = CompareLists<Vendor_Contacts>(tempVendorContact.ToList<Vendor_Contacts>(), objVendor.Vendor_Contacts.ToList<Vendor_Contacts>(), comparerVendor_Contacts, ref Deleted_Vendor_Contacts, ref Updated_Vendor_Contacts);
                Added_Vendor_Contacts.ToList<Vendor_Contacts>().ForEach(t => objVendor.Vendor_Contacts.Add(t));
                Deleted_Vendor_Contacts.ToList<Vendor_Contacts>().ForEach(t => t.EntityState = State.Deleted);
                List<RightsU_Entities.Vendor_Contacts> Modified_VC = new List<RightsU_Entities.Vendor_Contacts>();
                Modified_VC = tempVendorContact.Where(x => x.EntityState == State.Modified).ToList();
                foreach (var item in Modified_VC)
                {
                    foreach (var objVendorContact in objVendor.Vendor_Contacts)
                    {
                        if (objVendorContact.Vendor_Contacts_Code == item.Vendor_Contacts_Code)
                        {
                            objVendorContact.Department = item.Department;
                            objVendorContact.Phone_No = item.Phone_No;
                            objVendorContact.Email = item.Email;
                            objVendorContact.Contact_Name = item.Contact_Name;
                            objVendorContact.EntityState = State.Modified;
                        }
                    }

                }
                objVendor.Vendor_Contacts.Except(Deleted_Vendor_Contacts);
                #endregion
            }
            else
            {
                #region   -- -save vendor
                objVendor.Vendor_Name = Vendor_Name;
                objVendor.Address = Vendor_Addr;
                objVendor.Phone_No = Vendor_PhNo;
                objVendor.Short_Code = Vendor_FaxNo;
                objVendor.ST_No = Vendor_STNo;
                objVendor.VAT_No = Vendor_VATNo;
                objVendor.TIN_No = Vendor_TINNo;
                objVendor.PAN_No = Vendor_PANNo;
                objVendor.CST_No = Vendor_CSTNo;
                objVendor.CIN_No = Vendor_CINno;
                objVendor.GST_No = Vendor_GSTNo;
                objVendor.Party_Group_Code = Party_Group_Code;
                if (objVendor.Party_Group_Code == 0)
                    objVendor.Party_Group_Code = null;
                if (ModuleCode == "10")
                    objVendor.Party_Type = "V";
                else
                    objVendor.Party_Type = "C";
                objVendor.Is_Active = "Y";
                if (PartyCategoryCode > 0)
                    objVendor.Party_Category_Code = PartyCategoryCode;
                objVendor.Inserted_By = objLoginUser.Users_Code;
                objVendor.Inserted_On = System.DateTime.Now;
                objVendor.EntityState = State.Added;
                if (objFormCollection["Country"] != null)
                {
                    foreach (var CountryCode in listSelectedCountry)
                    {
                        int i = Convert.ToInt32(CountryCode);
                        RightsU_Entities.Vendor_Country objCountry = new RightsU_Entities.Vendor_Country();
                        objCountry.Is_Theatrical = "N";
                        objCountry.Country_Code = i;
                        objVendor.Vendor_Country.Add(objCountry);
                    }
                }
                if (objFormCollection["Theatrical"] != null)
                {
                    foreach (var CountryCode in listSelectedTheatrical)
                    {
                        int i = Convert.ToInt32(CountryCode);
                        RightsU_Entities.Vendor_Country objCountry = new RightsU_Entities.Vendor_Country();
                        objCountry.Is_Theatrical = "Y";
                        objCountry.Country_Code = i;
                        objVendor.Vendor_Country.Add(objCountry);
                    }
                }

                List<RightsU_Entities.Vendor_Contacts> temp_lstContact = new List<RightsU_Entities.Vendor_Contacts>();
                temp_lstContact = lstVendorContact_Searched.Where(x => x.Vendor_Code == 0).ToList();
                if (temp_lstContact.Count > 0)
                {
                    foreach (RightsU_Entities.Vendor_Contacts item in temp_lstContact)
                    {
                        objVendor.Vendor_Contacts.Add(item);
                    }
                }
                #endregion
            }
            #region ----- Type-----
            ICollection<Vendor_Role> RoleList = new HashSet<Vendor_Role>();
            if (objFormCollection["RoleList"] != null)
            {
                string[] arrRoleCode = objFormCollection["RoleList"].Split(',');
                foreach (string RoleCode in arrRoleCode)
                {
                    Vendor_Role objVR = new Vendor_Role();
                    objVR.EntityState = State.Added;
                    objVR.Role_Code = Convert.ToInt32(RoleCode);
                    RoleList.Add(objVR);
                }
            }

            IEqualityComparer<Vendor_Role> comparerRoles = new LambdaComparer<Vendor_Role>((x, y) => x.Role_Code == y.Role_Code && x.EntityState != State.Deleted);
            var Deleted_Role_Code = new List<Vendor_Role>();
            var Updatedd_Role_Code = new List<Vendor_Role>();
            var Addedd_Role_Code = CompareLists<Vendor_Role>(RoleList.ToList<Vendor_Role>(), objVendor.Vendor_Role.ToList<Vendor_Role>(), comparerRoles, ref Deleted_Role_Code, ref Updatedd_Role_Code);
            Addedd_Role_Code.ToList<Vendor_Role>().ForEach(t => objVendor.Vendor_Role.Add(t));
            Deleted_Role_Code.ToList<Vendor_Role>().ForEach(t => t.EntityState = State.Deleted);
            #endregion
            //objVendor.Short_Code = objUser_MVC.Short_Code;
            objVendor.Last_Updated_Time = System.DateTime.Now;

            #region --- Additional Info Methods ---

            string debugger = "";
            if (objSessVendor.Party_Type != null)
            {
                objVendor.Party_Type = objSessVendor.Party_Type;
            }
            //if (objVendor.Party_Type == "C")
            //{
            //    //objVendor.AL_Vendor_Details = objSessVendor.AL_Vendor_Details;
            //    //objVendor.AL_Vendor_Details.Add(objSessALVendorDetails);
            //    //objVendor.AL_Vendor_Rule = objSessVendor.AL_Vendor_Rule;
            //    //objVendor.AL_Vendor_OEM = objSessVendor.AL_Vendor_OEM;
            //    //objVendor.AL_Vendor_TnC = objSessVendor.AL_Vendor_TnC;
            //}
            //else if (objVendor.Party_Type == "V")
            //{
            //    //objVendor.AL_Vendor_Details = objSessVendor.AL_Vendor_Details;
            //}
            objVendor = SaveRuleOemDetailsForVendor(objVendor, objVendor.Party_Type);

            #endregion

            dynamic resultSet;
            bool isDuplicate = objVendorService.Validate(objVendor, out resultSet);
            if (isDuplicate)
            {
                bool isValid = objVendorService.Save(objVendor, out resultSet);
                if (isValid)
                {
                    lstVendor_Searched = lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                    status = "S";

                    int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                    DBUtil.Release_Record(recordLockingCode);

                    string Action = "";
                    if (VendorCode > 0)
                    {
                        Action = "U"; // U = "Update";
                        message = objMessageKey.Recordupdatedsuccessfully;
                        //message = message.Replace("{ACTION}", "updated");
                    }
                    else
                    {
                        Action = "C"; // C = "Create";
                        message = objMessageKey.RecordAddedSuccessfully;
                        //message = message.Replace("{ACTION}", "added");
                    }

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objVendor);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForVendor, objVendor.Vendor_Code, LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {


                    }

                    objSessALVendorDetails = null;
                    objSessVendor = null;
                    objVr = null;
                    DDlExtendedColumnsLst = null;
                    UsedDDlExtendedColumnsLst = null;
                    DDlOEMLst = null;
                    UsedDDlOEMlst = null;
                    lstSelectObject = null;
                    SelectedColumnValues = null;
                    objSessDictionary = null;
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
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveVendor(int vendorCode, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            CommonUtil objCommonUtil = new CommonUtil();
            if (ModuleCode == "10")
                isLocked = objCommonUtil.Lock_Record(vendorCode, GlobalParams.ModuleCodeForVendor, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            else
                isLocked = objCommonUtil.Lock_Record(vendorCode, GlobalParams.ModuleCodeForCustomer, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);

            if (isLocked)
            {
                string Action = "";
                // string status = "S", message = "Record {ACTION} successfully";
                Vendor_Service objService = new Vendor_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Vendor objVendor = objService.GetById(vendorCode);
                objVendor.Is_Active = doActive;
                objVendor.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objVendor, out resultSet);
                if (isValid)
                {
                    lstVendor.Where(w => w.Vendor_Code == vendorCode).First().Is_Active = doActive;
                    lstVendor_Searched.Where(w => w.Vendor_Code == vendorCode).First().Is_Active = doActive;

                    if (doActive == "Y")
                        Action = "A"; // A = "Active";
                    else
                        Action = "DA"; // DA = "Deactivate";

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objVendor);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeForVendor, objVendor.Vendor_Code, LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {


                    }
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }
                if (doActive == "Y")
                    if (status == "E")
                        message = objMessageKey.CouldNotActivatedRecord;
                    else
                        //message = message.Replace("{ACTION}", "Activated");
                        message = objMessageKey.Recordactivatedsuccessfully;
                else
                {
                    if (status == "E")
                        message = objMessageKey.CouldNotDeactivatedRecord;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                        //message = message.Replace("{ACTION}", "Deactivated");
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

        #endregion

        #region --- Vendor Contacts Crud Method ---

        public JsonResult SaveVendorContact(FormCollection objFormCollection)
        {
            string str_Department = objFormCollection["Department"].ToString().Trim();
            string str_Email = objFormCollection["Email"].ToString().Trim();
            string str_Phone_No = objFormCollection["Phone_No"].ToString().Trim();
            string str_Contact_Name = objFormCollection["Contact_Name"].ToString().Trim();

            string status = "S", message = objMessageKey.RecordAddedSuccessfully;



            int VendorCode_AddEdit = Convert.ToInt32(Session["VendorCode_AddEdit"]);

            if (lstVendorContact_Searched.Where(r => r.Vendor_Code == 0 || r.Vendor_Code == VendorCode_AddEdit).Where(s => s.Email.ToUpper() == str_Email.ToUpper() && s.EntityState != State.Deleted).Count() > 0)
            {
                status = "E";
                message = objMessageKey.EmailIDalredyexists;
            }
            else
            {
                RightsU_Entities.Vendor_Contacts objVendorContacts = new RightsU_Entities.Vendor_Contacts();

                objVendorContacts.Department = str_Department;
                objVendorContacts.Email = str_Email;
                objVendorContacts.Phone_No = str_Phone_No;
                objVendorContacts.Contact_Name = str_Contact_Name;
                objVendorContacts.Vendor_Code = 0;
                objVendorContacts.EntityState = State.Added;
                lstVendorContact_Searched.Add(objVendorContacts);
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult AddEditVendorContact(string dummyGuid, string commandName)
        {
            string status = "S", message = "Record {ACTION} successfully";
            if (commandName == "ADD")
            {
                TempData["Action"] = "AddVendorContact";
            }
            else if (commandName == "EDIT")
            {
                RightsU_Entities.Vendor_Contacts objVendorContact = new RightsU_Entities.Vendor_Contacts();
                objVendorContact = lstVendorContact_Searched.Where(x => x.Dummy_Guid.ToString() == dummyGuid).SingleOrDefault();
                TempData["Action"] = "EditVendorContact";
                TempData["idVendorContact"] = objVendorContact.Dummy_Guid;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult UpdateVendorContact(FormCollection objFormCollection)
        {
            string str_DummyGuid = objFormCollection["DummyGuid"].ToString();
            string str_Department = objFormCollection["Department"].ToString().Trim();
            string str_Email = objFormCollection["Email"].ToString().Trim();
            string str_Phone_No = objFormCollection["Phone_No"].ToString().Trim();
            string str_Contact_Name = objFormCollection["Contact_Name"].ToString().Trim();
            string status = "S", message = objMessageKey.Recordupdatedsuccessfully;


            int VendorCode_AddEdit = Convert.ToInt32(Session["VendorCode_AddEdit"]);

            if (lstVendorContact_Searched.Where(r => r.Vendor_Code == 0 || r.Vendor_Code == VendorCode_AddEdit)
                .Where(x => x._Dummy_Guid != str_DummyGuid)
                .Where(s => s.Email.ToUpper() == str_Email.ToUpper() && s.EntityState != State.Deleted).Count() > 0)
            {
                status = "E";
                message = objMessageKey.EmailIDalredyexists;
            }
            else
            {
                RightsU_Entities.Vendor_Contacts objVendorContacts = lstVendorContact_Searched.Where(x => x._Dummy_Guid == str_DummyGuid).SingleOrDefault();
                objVendorContacts.Department = str_Department;
                objVendorContacts.Email = str_Email;
                objVendorContacts.Phone_No = str_Phone_No;
                objVendorContacts.Contact_Name = str_Contact_Name;
                if (objVendorContacts.Vendor_Code > 0)
                {
                    objVendorContacts.EntityState = State.Modified;
                }
            }


            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult DeleteVendorContact(string dummyGuid)
        {
            string status = "S", message = "Record {ACTION} successfully";
            RightsU_Entities.Vendor_Contacts objVendorContacts = lstVendorContact_Searched.Where(x => x._Dummy_Guid == dummyGuid).SingleOrDefault();
            if (objVendorContacts != null)
            {
                if (objVendorContacts.Vendor_Code > 0)
                {
                    objVendorContacts.EntityState = State.Deleted;
                }
                else
                {
                    lstVendorContact_Searched.Remove(objVendorContacts);
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

        #endregion

        #region ---Additional Info---

        public RightsU_Entities.Vendor SaveRuleOemDetailsForVendor(RightsU_Entities.Vendor objDBVendor, string PartyType)
        {
            //List<AL_Vendor_Rule> AddedVendorRule = new List<AL_Vendor_Rule>();
            //List<AL_Vendor_Rule_Criteria> AddedVendorRuleCriteria = new List<AL_Vendor_Rule_Criteria>();
            //List<AL_Vendor_OEM> AddedVendorOEM = new List<AL_Vendor_OEM>();
            //List<AL_Vendor_TnC> AddedVendorTnC = new List<AL_Vendor_TnC>();

            foreach (AL_Vendor_Details objSessionVendorDetails in objSessVendor.AL_Vendor_Details)
            {
                if (objSessionVendorDetails.AL_Vendor_Detail_Code > 0)
                {
                    AL_Vendor_Details objDBVendorDetails = new AL_Vendor_Details();
                    objDBVendorDetails = objDBVendor.AL_Vendor_Details.Where(w => w.AL_Vendor_Detail_Code == objSessionVendorDetails.AL_Vendor_Detail_Code).FirstOrDefault();
                    if (objSessionVendorDetails.EntityState == State.Modified)
                    {
                        objDBVendorDetails.Banner_Codes = objSessionVendorDetails.Banner_Codes;
                        objDBVendorDetails.Pref_Exclusion_Codes = objSessionVendorDetails.Pref_Exclusion_Codes;
                        objDBVendorDetails.EntityState = objSessionVendorDetails.EntityState;
                        objDBVendorDetails.Extended_Group_Code_Booking = objSessionVendorDetails.Extended_Group_Code_Booking;
                    }
                }
                if (objSessionVendorDetails.AL_Vendor_Detail_Code == 0 || objSessionVendorDetails.AL_Vendor_Detail_Code < 0)
                {
                    if (objSessionVendorDetails.EntityState == State.Added)
                    {
                        objDBVendor.AL_Vendor_Details.Add(objSessionVendorDetails);
                    }
                }
            }

            if (objSessVendor.Party_Type == "C")
            {
                foreach (AL_Vendor_Rule objSessionVendorRule in objSessVendor.AL_Vendor_Rule)
                {
                    if (objSessionVendorRule.AL_Vendor_Rule_Code > 0)
                    {
                        //Either be modified, Deleted or unchanged 

                        AL_Vendor_Rule objDBVendorRule = new AL_Vendor_Rule();
                        objDBVendorRule = objDBVendor.AL_Vendor_Rule.Where(w => w.AL_Vendor_Rule_Code == objSessionVendorRule.AL_Vendor_Rule_Code).FirstOrDefault();
                        if (objSessionVendorRule.EntityState == State.Modified)
                        {
                            objDBVendorRule.Rule_Name = objSessionVendorRule.Rule_Name;
                            objDBVendorRule.Rule_Short_Name = objSessionVendorRule.Rule_Short_Name;
                            objDBVendorRule.Rule_Type = objSessionVendorRule.Rule_Type;
                            objDBVendorRule.Is_Active = objSessionVendorRule.Is_Active;
                            objDBVendorRule.EntityState = objSessionVendorRule.EntityState;
                            objDBVendorRule.Criteria = objSessionVendorRule.Criteria;
                        }

                        foreach (AL_Vendor_Rule_Criteria objSessionVendorRuleCriteria in objSessionVendorRule.AL_Vendor_Rule_Criteria)
                        {
                            if (objSessionVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code > 0)
                            {
                                AL_Vendor_Rule_Criteria objDBVendorRuleCriteria = new AL_Vendor_Rule_Criteria();
                                objDBVendorRuleCriteria = objDBVendorRule.AL_Vendor_Rule_Criteria.Where(w => w.AL_Vendor_Rule_Criteria_Code == objSessionVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code).FirstOrDefault();

                                if (objSessionVendorRuleCriteria.EntityState == State.Modified)
                                {
                                    objDBVendorRuleCriteria.Columns_Code = objSessionVendorRuleCriteria.Columns_Code;
                                    objDBVendorRuleCriteria.Columns_Value = objSessionVendorRuleCriteria.Columns_Value;
                                    objDBVendorRuleCriteria.EntityState = objSessionVendorRuleCriteria.EntityState;
                                }
                                if (objSessionVendorRuleCriteria.EntityState == State.Deleted)
                                {
                                    objDBVendorRuleCriteria.Columns_Code = objSessionVendorRuleCriteria.Columns_Code;
                                    objDBVendorRuleCriteria.Columns_Value = objSessionVendorRuleCriteria.Columns_Value;
                                    objDBVendorRuleCriteria.EntityState = objSessionVendorRuleCriteria.EntityState;
                                }
                            }
                            if (objSessionVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code < 0)
                            {
                                objDBVendorRule.AL_Vendor_Rule_Criteria.Add(objSessionVendorRuleCriteria);
                            }
                        }
                    }
                    if (objSessionVendorRule.AL_Vendor_Rule_Code < 0 || objSessionVendorRule.EntityState == State.Added)
                    {
                        //State is added so direct add in DB Object
                        objDBVendor.AL_Vendor_Rule.Add(objSessionVendorRule);
                    }
                }
                foreach (AL_Vendor_OEM objSessionVendorOEM in objSessVendor.AL_Vendor_OEM)
                {
                    if (objSessionVendorOEM.AL_Vendor_OEM_Code > 0)
                    {
                        AL_Vendor_OEM objDBVendorOem = new AL_Vendor_OEM();
                        objDBVendorOem = objDBVendor.AL_Vendor_OEM.Where(w => w.AL_Vendor_OEM_Code == objSessionVendorOEM.AL_Vendor_OEM_Code).FirstOrDefault();
                        if (objSessionVendorOEM.EntityState == State.Modified)
                        {
                            objDBVendorOem.AL_OEM_Code = objSessionVendorOEM.AL_OEM_Code;
                            objDBVendorOem.EntityState = objSessionVendorOEM.EntityState;
                            objDBVendorOem.Is_Active = objSessionVendorOEM.Is_Active;
                        }
                    }
                    if (objSessionVendorOEM.AL_Vendor_OEM_Code < 0)
                    {
                        objDBVendor.AL_Vendor_OEM.Add(objSessionVendorOEM);
                    }
                }
                foreach (AL_Vendor_TnC objSessionVendorTnC in objSessVendor.AL_Vendor_TnC)
                {
                    if (objSessionVendorTnC.AL_Vendor_TnC_Code > 0)
                    {
                        AL_Vendor_TnC objDBVendorTnc = new AL_Vendor_TnC();
                        objDBVendorTnc = objDBVendor.AL_Vendor_TnC.Where(w => w.AL_Vendor_TnC_Code == objSessionVendorTnC.AL_Vendor_TnC_Code).FirstOrDefault();
                        if (objSessionVendorTnC.EntityState == State.Modified)
                        {
                            objDBVendorTnc.TnC_Description = objSessionVendorTnC.TnC_Description;
                            objDBVendorTnc.EntityState = objSessionVendorTnC.EntityState;
                        }
                    }
                    if (objSessionVendorTnC.AL_Vendor_TnC_Code < 0)
                    {
                        objDBVendor.AL_Vendor_TnC.Add(objSessionVendorTnC);
                    }
                }
            }

            var VendorPartyCheck = new Vendor_Service(objLoginEntity.ConnectionStringName).GetById(objDBVendor.Vendor_Code);
            string DBPartyType = objSessVendor.Party_Type;
            if (VendorPartyCheck != null)
            {
                DBPartyType = VendorPartyCheck.Party_Type;
            }

            if (objSessVendor.Party_Type == "V" && DBPartyType != objSessVendor.Party_Type)
            {
                //Entity state deleted for Everything when Previously selected Client was changed to Vendor
                foreach (AL_Vendor_Rule objDBRule in objDBVendor.AL_Vendor_Rule)
                {
                    foreach (AL_Vendor_Rule_Criteria objDBRuleCrite in objDBRule.AL_Vendor_Rule_Criteria)
                    {
                        objDBRuleCrite.EntityState = State.Deleted;
                    }
                    objDBRule.EntityState = State.Deleted;
                }
                foreach (AL_Vendor_OEM objDBOEM in objDBVendor.AL_Vendor_OEM)
                {
                    objDBOEM.EntityState = State.Deleted;
                }
                foreach (AL_Vendor_TnC objDBTnC in objDBVendor.AL_Vendor_TnC)
                {
                    objDBTnC.EntityState = State.Deleted;
                }
            }

            return objDBVendor;
        }

        public ActionResult AdditionalInfo(string CommandName, int VendorDetailCode)
        {
            AL_Vendor_Details objVendorDetail = new AL_Vendor_Details();
            objVendorDetail = objSessALVendorDetails;
            //List<string> SelectedBannerValues = new List<string>();
            string SelectedBannerValue = "";
            List<string> SelectedPrefExclusionValues = new List<string>();
            ViewBag.DisplayMode = CommandName;

            List<Banner> lstBanner = new List<Banner>();
            Banner_Service objBannerService = new Banner_Service(objLoginEntity.ConnectionStringName);
            lstBanner = objBannerService.SearchFor(s => true).ToList();

            #region
            //Gets all banners that are used in Parties except the current one. ---- Below statement might need this condition in where block ' && objVendorDetail.Vendor.Is_Active != "N" '
            List<string> UsedBannersList = new AL_Vendor_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.AL_Vendor_Detail_Code != objVendorDetail.AL_Vendor_Detail_Code && w.Banner_Codes != null).Select(s => s.Banner_Codes).ToList();
            lstBanner = lstBanner.Where(w => !UsedBannersList.Any(a => a == Convert.ToString(w.Banner_Code))).ToList();
            #endregion

            ViewBag.Banner = new SelectList(lstBanner, "Banner_Code", "Banner_Name");

            //List of Pref Exclusion

            List<Extended_Columns_Value> lstPrefExcValues = new List<Extended_Columns_Value>();
            Extended_Columns_Value_Service objExtColValService = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.System_Parameter_New PrefExc_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_Keyword_PrefExclusion_Code").FirstOrDefault();
            string PrefExcludVal = PrefExc_system_Parameter.Parameter_Value;
            lstPrefExcValues = objExtColValService.SearchFor(s => true).Where(w => w.Columns_Code.ToString() == PrefExcludVal).ToList();
            ViewBag.PrefExclusion = new MultiSelectList(lstPrefExcValues, "Columns_Value_Code", "Columns_Value");

            List<Extended_Group> lstExtGrp = new List<Extended_Group>();
            Extended_Group_Service objExtGrpService = new Extended_Group_Service(objLoginEntity.ConnectionStringName);
            lstExtGrp = objExtGrpService.SearchFor(s => true).Where(w => w.Module_Code == GlobalParams.ModuleCodeForBookingSheet).ToList();
            ViewBag.ExtGrpCfg = new SelectList(lstExtGrp, "Extended_Group_Code", "Group_Name");

            RightsU_Entities.System_Parameter_New system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "Enable_Booking_Sheet_For_Party").FirstOrDefault();
            ViewBag.DisplayBookingSheet = system_Parameter.Parameter_Value;

            if (objVendorDetail != null)
            {
                if (objVendorDetail.Banner_Codes != null)
                {
                    //SelectedBannerValues = objVendorDetail.Banner_Codes.Split(',').ToList();
                    //objVendorDetail.SelectedBannerValues = string.Join(",", lstBanner.Where(w => SelectedBannerValues.Any(a => a == w.Banner_Code.ToString())).Select(s => s.Banner_Name));
                    SelectedBannerValue = objVendorDetail.Banner_Codes;
                    objVendorDetail.SelectedBannerValues = lstBanner.Where(w => Convert.ToString(w.Banner_Code) == SelectedBannerValue).Select(s => s.Banner_Name).FirstOrDefault();
                }

                if (objVendorDetail.Pref_Exclusion_Codes != null)
                {
                    SelectedPrefExclusionValues = objVendorDetail.Pref_Exclusion_Codes.Split(',').ToList();
                    objVendorDetail.SelectedPrefExclusionValues = string.Join(",", lstPrefExcValues.Where(w => SelectedPrefExclusionValues.Any(b => b == w.Columns_Value_Code.ToString())).Select(s => s.Columns_Value));
                }

                if (objVendorDetail.Extended_Group_Code_Booking != null)
                {
                    objVendorDetail.SelectedBookingSheetValue = lstExtGrp.Where(w => w.Extended_Group_Code == objVendorDetail.Extended_Group_Code_Booking).FirstOrDefault().Group_Name;
                }

                //ViewBag.Banner = new MultiSelectList(lstBanner, "Banner_Code", "Banner_Name", SelectedBannerValues);
                ViewBag.Banner = new SelectList(lstBanner, "Banner_Code", "Banner_Name", SelectedBannerValue);
                ViewBag.PrefExclusion = new MultiSelectList(lstPrefExcValues, "Columns_Value_Code", "Columns_Value", SelectedPrefExclusionValues);
                ViewBag.ExtGrpCfg = new SelectList(lstExtGrp, "Extended_Group_Code", "Group_Name", objVendorDetail.Extended_Group_Code_Booking);
            }
            objVendorDetail.SelectedPartyType = objSessVendor.Party_Type;
            return PartialView("_AdditionalInfo", objVendorDetail);
        }

        public ActionResult SaveAdditionalInfo(AL_Vendor_Details alVendorDetails, string PartyType)
        {
            if (alVendorDetails.AL_Vendor_Detail_Code == 0 && objSessVendor.AL_Vendor_Details.Count == 0)
            {
                alVendorDetails.EntityState = State.Added;
                objSessVendor.AL_Vendor_Details.Add(alVendorDetails);
            }
            else
            {
                if (alVendorDetails.AL_Vendor_Detail_Code > 0)
                {
                    AL_Vendor_Details objDBAlVendorDetails = objSessVendor.AL_Vendor_Details.Where(w => w.AL_Vendor_Detail_Code == alVendorDetails.AL_Vendor_Detail_Code).FirstOrDefault();
                    alVendorDetails.EntityState = State.Modified;
                    objDBAlVendorDetails.AL_Vendor_Detail_Code = alVendorDetails.AL_Vendor_Detail_Code;
                    objDBAlVendorDetails.Banner_Codes = alVendorDetails.Banner_Codes;
                    objDBAlVendorDetails.EntityState = alVendorDetails.EntityState;
                    objDBAlVendorDetails.Extended_Group_Code_Booking = alVendorDetails.Extended_Group_Code_Booking;
                    objDBAlVendorDetails.Pref_Exclusion_Codes = alVendorDetails.Pref_Exclusion_Codes;
                    objDBAlVendorDetails.SelectedBannerValues = alVendorDetails.SelectedBannerValues;
                    objDBAlVendorDetails.SelectedPrefExclusionValues = alVendorDetails.SelectedPrefExclusionValues;
                }
                if (alVendorDetails.AL_Vendor_Detail_Code == 0)
                {
                    AL_Vendor_Details objSessVendorDetails = objSessVendor.AL_Vendor_Details.Where(w => w.AL_Vendor_Detail_Code == alVendorDetails.AL_Vendor_Detail_Code).FirstOrDefault();
                    alVendorDetails.EntityState = State.Added;
                    objSessVendorDetails.AL_Vendor_Detail_Code = alVendorDetails.AL_Vendor_Detail_Code;
                    objSessVendorDetails.Banner_Codes = alVendorDetails.Banner_Codes;
                    objSessVendorDetails.EntityState = alVendorDetails.EntityState;
                    objSessVendorDetails.Extended_Group_Code_Booking = alVendorDetails.Extended_Group_Code_Booking;
                    objSessVendorDetails.Pref_Exclusion_Codes = alVendorDetails.Pref_Exclusion_Codes;
                    objSessVendorDetails.SelectedBannerValues = alVendorDetails.SelectedBannerValues;
                    objSessVendorDetails.SelectedPrefExclusionValues = alVendorDetails.SelectedPrefExclusionValues;
                }
            }

            objSessVendor.Party_Type = PartyType;
            objSessALVendorDetails = alVendorDetails;

            var obj = new
            {
                Status = "S",
                Message = "Additional Data Saved successfully"
            };

            return Json(obj);
        }

        public ActionResult DeleteAdditionalResult()
        {

            return Json("");
        }

        #endregion

        #region --- CONTENT RULE ---

        public ActionResult ContentRule(string TabName, string CommandName, int Id)
        {
            List<AL_Vendor_Rule> lstVendorRule = new List<AL_Vendor_Rule>();
            lstVendorRule = objSessVendor.AL_Vendor_Rule.ToList();
            foreach (AL_Vendor_Rule aL_Vendor_Rule in lstVendorRule)
            {
                if (aL_Vendor_Rule.Rule_Type == "M")
                {
                    aL_Vendor_Rule.Rule_Type_Name = "Movie";
                }
                if (aL_Vendor_Rule.Rule_Type == "S")
                {
                    aL_Vendor_Rule.Rule_Type_Name = "Show";
                }
            }
            ViewBag.CommandNameCRList = CommandName;

            return PartialView("_ContentRule", lstVendorRule);
        }

        public ActionResult ContentRulePopUp(string TabName, string CommandName, int CrCode)
        {
            AL_Vendor_Rule objVendorRule;
            ViewBag.TabName = TabName;
            ViewBag.CommandNameCR = CommandName;
            ViewBag.CrCode = CrCode;

            if (CrCode != 0)
            {
                objVendorRule = objSessVendor.AL_Vendor_Rule.Where(a => a.AL_Vendor_Rule_Code == CrCode).FirstOrDefault();
            }
            else
            {
                objVendorRule = new AL_Vendor_Rule();
                objVendorRule.Rule_Type = "M";
            }

            objVr = objVendorRule;
            FetchAllExtendedColumns();
            CheckForSelectedValues();

            if (CommandName == "EDIT")
            {
                UsedDDlExtendedColumnsLst = objVr.AL_Vendor_Rule_Criteria.Select(s => Convert.ToInt32(s.Columns_Code)).ToList();
            }

            return PartialView("_ContentRulePopup", objVendorRule);
        }

        public ActionResult SaveContentRule(AL_Vendor_Rule ALVendorRule)
        {
            string status = "S";
            string message = "";

            if (CheckDuplicateContentRuleClientForSameType(ALVendorRule.Rule_Name, ALVendorRule.Rule_Type, ALVendorRule.AL_Vendor_Rule_Code, ALVendorRule.Vendor_Code))
            {
                ALVendorRule.AL_Vendor_Rule_Criteria = objVr.AL_Vendor_Rule_Criteria;
                string CommaSeparatedCriteria = string.Join(",", objVr.AL_Vendor_Rule_Criteria.Where(w => w.EntityState != State.Deleted).Select(s => s.ExtendedColumnNames).ToList());
                ALVendorRule.Criteria = CommaSeparatedCriteria;
                ALVendorRule.Is_Active = "Y";

                if (ALVendorRule.AL_Vendor_Rule_Code == 0)
                {
                    if (objSessVendor.AL_Vendor_Rule.Count == 0)
                    {
                        ALVendorRule.AL_Vendor_Rule_Code = -1;
                        ALVendorRule.EntityState = State.Added;
                    }
                    else
                    {
                        ALVendorRule.AL_Vendor_Rule_Code = Convert.ToInt32(Session["tempCRID"]) - 1;
                        ALVendorRule.EntityState = State.Added;
                    }
                    ALVendorRule.Is_Active = "Y";
                    Session["tempCRID"] = ALVendorRule.AL_Vendor_Rule_Code;
                    objSessVendor.AL_Vendor_Rule.Add(ALVendorRule);
                }
                else
                {
                    if (ALVendorRule.AL_Vendor_Rule_Code > 0)
                    {
                        AL_Vendor_Rule objAVR_DB = objSessVendor.AL_Vendor_Rule.Where(w => w.AL_Vendor_Rule_Code == ALVendorRule.AL_Vendor_Rule_Code).FirstOrDefault();
                        objAVR_DB.Rule_Name = ALVendorRule.Rule_Name;
                        objAVR_DB.Rule_Short_Name = ALVendorRule.Rule_Short_Name;
                        objAVR_DB.Criteria = ALVendorRule.Criteria;
                        objAVR_DB.AL_Vendor_Rule_Criteria = ALVendorRule.AL_Vendor_Rule_Criteria;
                        objAVR_DB.Rule_Type = ALVendorRule.Rule_Type;
                        ALVendorRule.EntityState = State.Modified;
                        objAVR_DB.EntityState = ALVendorRule.EntityState;
                    }
                    if (ALVendorRule.AL_Vendor_Rule_Code < 0)
                    {
                        AL_Vendor_Rule objAVR_Sess = objSessVendor.AL_Vendor_Rule.Where(w => w.AL_Vendor_Rule_Code == ALVendorRule.AL_Vendor_Rule_Code).FirstOrDefault();
                        objAVR_Sess.Rule_Name = ALVendorRule.Rule_Name;
                        objAVR_Sess.Rule_Short_Name = ALVendorRule.Rule_Short_Name;
                        objAVR_Sess.Criteria = ALVendorRule.Criteria;
                        objAVR_Sess.AL_Vendor_Rule_Criteria = ALVendorRule.AL_Vendor_Rule_Criteria;
                        objAVR_Sess.Rule_Type = ALVendorRule.Rule_Type;
                        ALVendorRule.EntityState = State.Added;
                        objAVR_Sess.EntityState = ALVendorRule.EntityState;
                    }
                }

                objVr = null;
                UsedDDlExtendedColumnsLst = null;
                DDlExtendedColumnsLst = null;
            }
            else
            {
                status = "E";
                message = "Content rule with same Name and Title type for this Party already exists";
            }

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        public ActionResult DeleteContentRule(int CRCode, string Action)
        {
            string status = "S";
            string message = "";

            AL_Vendor_Rule objVR = objSessVendor.AL_Vendor_Rule.Where(w => w.AL_Vendor_Rule_Code == CRCode).FirstOrDefault();

            if (objVR != null)
            {
                if (objVR.Is_Active == "Y")
                {
                    objVR.Is_Active = "N";
                    objVR.EntityState = State.Modified;
                }
                else
                {
                    objVR.Is_Active = "Y";
                    objVR.EntityState = State.Modified;
                }
                if (Action == "DELETE")
                {
                    objSessVendor.AL_Vendor_Rule.Remove(objVR);
                }
            }
            else
            {
                status = "E";
                message = objMessageKey.FileNotFound;
            }

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        public ActionResult ContentRulePopUpGrid(string CommandName, int CrCCode, int CrCode)
        {
            List<AL_Vendor_Rule_Criteria> lstVendorRuleCriteria = new List<AL_Vendor_Rule_Criteria>();

            lstVendorRuleCriteria = objVr.AL_Vendor_Rule_Criteria.ToList();
            ViewBag.CommandNameCrC = CommandName;
            ViewBag.CrCCode = CrCCode;
            ViewBag.CrCode = CrCode;
            ViewBag.CrCodeOnAdd = CrCode;
            List<int> DisableDDlList = UsedDDlExtendedColumnsLst;
            ViewBag.ExtendedColumnDDl = new SelectList(DDlExtendedColumnsLst, "Columns_Code", "Columns_Name", 0, DisableDDlList);
            foreach (AL_Vendor_Rule_Criteria alVRC in lstVendorRuleCriteria.Where(w => w.AL_Vendor_Rule_Criteria_Code > 0))
            {
                if (alVRC.ExtendedColumnNames == "" || alVRC.ExtendedColumnNames == null)
                {
                    alVRC.ExtendedColumnNames = alVRC.Extended_Columns.Columns_Name;
                }
                if (alVRC.EntityState != State.Deleted)
                {
                    UsedDDlExtendedColumnsLst.Add(Convert.ToInt32(alVRC.Columns_Code));
                }
                UsedDDlExtendedColumnsLst = UsedDDlExtendedColumnsLst.Distinct().ToList();

                if (alVRC.DataFieldNames == null && alVRC.Extended_Columns.Control_Type == "DDL")
                {
                    CreateExtendedDataObject(Convert.ToInt32(alVRC.Columns_Code));
                    List<string> SelectedValues = alVRC.Columns_Value.Split(',').ToList();
                    alVRC.DataFieldNames = string.Join(",", lstSelectObject.Where(w => SelectedValues.Any(a => w.Columns_Value_Code.ToString() == a)).Select(s => s.ColumnsValue));
                }
            }

            if (CrCCode != 0)
            {
                AL_Vendor_Rule_Criteria objVRC;

                objVRC = objVr.AL_Vendor_Rule_Criteria.Where(w => w.AL_Vendor_Rule_Criteria_Code == CrCCode).FirstOrDefault();

                CreateExtendedDataObject(Convert.ToInt32(objVRC.Columns_Code));
                DisableDDlList = UsedDDlExtendedColumnsLst.Where(w => w != objVRC.Columns_Code).ToList();
                ViewBag.ExtendedColumnDDl = new SelectList(DDlExtendedColumnsLst, "Columns_Code", "Columns_Name", objVRC.Columns_Code, DisableDDlList);

                object controlType;
                object isMultiSelect;
                ViewBag.Controltype = controlType = objSessDictionary.Where(w => w.Key == "ControlType").FirstOrDefault().Value;
                ViewBag.IsMultiSelect = isMultiSelect = objSessDictionary.Where(w => w.Key == "IsMultiSelect").FirstOrDefault().Value;

                if (controlType.ToString() == "DDL" && isMultiSelect.ToString() == "N")
                {
                    ViewBag.DDlSelectList = new SelectList(lstSelectObject, "Columns_Value_Code", "ColumnsValue", objVRC.Columns_Value);
                }
                else if (controlType.ToString() == "DDL" && isMultiSelect.ToString() == "Y")
                {
                    SelectedColumnValues = objVRC.Columns_Value.Split(',').ToList();
                    ViewBag.DDlSelectList = new MultiSelectList(lstSelectObject, "Columns_Value_Code", "ColumnsValue", SelectedColumnValues);
                }
            }
            List<AL_Vendor_Rule_Criteria> lstVendorRuleCriteriaDisplay = lstVendorRuleCriteria.Where(w => w.EntityState != State.Deleted).ToList();
            if (lstVendorRuleCriteriaDisplay == null)
            {
                lstVendorRuleCriteriaDisplay = new List<AL_Vendor_Rule_Criteria>();
            }

            return PartialView("_ContentRuleGrid", lstVendorRuleCriteriaDisplay);
        }

        public ActionResult SaveContentPopupGrid(AL_Vendor_Rule_Criteria ALVendorRuleCriteria)
        {
            string status = "S";
            string message = "";

            if (ALVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code == 0)
            {
                if (objVr.AL_Vendor_Rule_Criteria.Count == 0)
                {
                    ALVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code = -1;
                    ALVendorRuleCriteria.EntityState = State.Added;
                    objVr.AL_Vendor_Rule_Criteria.Add(ALVendorRuleCriteria);
                }
                else
                {
                    ALVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code = Convert.ToInt32(Session["TempCRCID"]) - 1;
                    ALVendorRuleCriteria.EntityState = State.Added;
                    objVr.AL_Vendor_Rule_Criteria.Add(ALVendorRuleCriteria);
                }
                Session["TempCRCID"] = ALVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code;
            }
            else
            {
                if (ALVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code > 0)
                {
                    AL_Vendor_Rule_Criteria objCrC_DB = objVr.AL_Vendor_Rule_Criteria.Where(w => w.AL_Vendor_Rule_Criteria_Code == ALVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code).FirstOrDefault();
                    objCrC_DB.Columns_Code = ALVendorRuleCriteria.Columns_Code;
                    objCrC_DB.Columns_Value = ALVendorRuleCriteria.Columns_Value;
                    objCrC_DB.ExtendedColumnNames = ALVendorRuleCriteria.ExtendedColumnNames;
                    objCrC_DB.DataFieldNames = ALVendorRuleCriteria.DataFieldNames;
                    objCrC_DB.EntityState = State.Modified;
                }
                if (ALVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code < 0)
                {
                    AL_Vendor_Rule_Criteria objCrC_Sess = objVr.AL_Vendor_Rule_Criteria.Where(w => w.AL_Vendor_Rule_Criteria_Code == ALVendorRuleCriteria.AL_Vendor_Rule_Criteria_Code).FirstOrDefault();
                    objCrC_Sess.Columns_Code = ALVendorRuleCriteria.Columns_Code;
                    objCrC_Sess.Columns_Value = ALVendorRuleCriteria.Columns_Value;
                    objCrC_Sess.ExtendedColumnNames = ALVendorRuleCriteria.ExtendedColumnNames;
                    objCrC_Sess.DataFieldNames = ALVendorRuleCriteria.DataFieldNames;
                    objCrC_Sess.EntityState = State.Added;
                }
                //Run a method to see how many Extended columns are used when edited remove the edited one from list and redo the list
                CheckForSelectedValues();
            }
            //DisableSelectedValues(Convert.ToInt32(ALVendorRuleCriteria.Columns_Code));
            UsedDDlExtendedColumnsLst.Add(Convert.ToInt32(ALVendorRuleCriteria.Columns_Code));

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        public ActionResult DeleteContentPopupGrid(int CRCCode)
        {
            string status = "S";
            string message = "";

            AL_Vendor_Rule_Criteria objVRC = objVr.AL_Vendor_Rule_Criteria.Where(w => w.AL_Vendor_Rule_Criteria_Code == CRCCode).FirstOrDefault();

            if (objVRC != null)
            {
                if (objVRC.AL_Vendor_Rule_Criteria_Code > 0)
                {
                    objVRC.EntityState = State.Deleted;
                    UsedDDlExtendedColumnsLst.Remove(Convert.ToInt32(objVRC.Columns_Code));
                }
                else
                {
                    objVr.AL_Vendor_Rule_Criteria.Remove(objVRC);
                }
                CheckForSelectedValues();
            }
            else
            {
                status = "E";
                message = objMessageKey.FileNotFound;
            }

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        #endregion

        #region --- OEM ---

        public ActionResult OEM(string TabName, string CommandName, int Id)
        {
            List<AL_Vendor_OEM> lstVendorOEM = new List<AL_Vendor_OEM>();
            lstVendorOEM = objSessVendor.AL_Vendor_OEM.Where(w => w.EntityState != State.Deleted).ToList();
            ViewBag.CommandNameOEM = CommandName;
            ViewBag.OEMCode = Id;
            ViewBag.TabName = TabName;
            FetchAllOEMs();
            UsedOEMinDDl();
            List<int> DisableDDlOEM = UsedDDlOEMlst;
            ViewBag.OEMDDl = new SelectList(DDlOEMLst, "AL_OEM_Code", "Company_Name", 0, DisableDDlOEM);

            foreach (AL_Vendor_OEM alOEM in lstVendorOEM.Where(w => w.AL_Vendor_OEM_Code > 0))
            {
                if (alOEM.SelectedOEMName == "" || alOEM.SelectedOEMName == null)
                {
                    alOEM.SelectedOEMName = alOEM.AL_OEM.Company_Name;
                }

                UsedDDlOEMlst.Add(Convert.ToInt32(alOEM.AL_OEM_Code));
                UsedDDlOEMlst = UsedDDlOEMlst.Distinct().ToList();
            }

            if (Id != 0)
            {
                AL_Vendor_OEM objVendorOEM;
                objVendorOEM = objSessVendor.AL_Vendor_OEM.Where(w => w.AL_Vendor_OEM_Code == Id).FirstOrDefault();
                DisableDDlOEM = UsedDDlOEMlst.Where(w => w != objVendorOEM.AL_OEM_Code).ToList();
                ViewBag.OEMDDl = new SelectList(DDlOEMLst, "AL_OEM_Code", "Company_Name", objVendorOEM.AL_OEM_Code, DisableDDlOEM);
            }

            return PartialView("_OEM", lstVendorOEM);
        }

        public ActionResult SaveVendorOEM(AL_Vendor_OEM ALVendorOEM)
        {
            string status = "S";
            string message = "";

            if (ALVendorOEM.AL_Vendor_OEM_Code == 0)
            {
                if (objSessVendor.AL_Vendor_OEM.Count == 0)
                {
                    ALVendorOEM.AL_Vendor_OEM_Code = -1;
                    ALVendorOEM.EntityState = State.Added;
                }
                else
                {
                    ALVendorOEM.AL_Vendor_OEM_Code = Convert.ToInt32(Session["tempOEMID"]) - 1;
                    ALVendorOEM.EntityState = State.Added;
                }
                ALVendorOEM.Is_Active = "Y";
                Session["tempOEMID"] = ALVendorOEM.AL_Vendor_OEM_Code;
                objSessVendor.AL_Vendor_OEM.Add(ALVendorOEM);
            }
            else
            {
                if (ALVendorOEM.AL_Vendor_OEM_Code > 0)
                {
                    AL_Vendor_OEM objOEM_DB = objSessVendor.AL_Vendor_OEM.Where(w => w.AL_Vendor_OEM_Code == ALVendorOEM.AL_Vendor_OEM_Code).FirstOrDefault();
                    objOEM_DB.AL_OEM_Code = ALVendorOEM.AL_OEM_Code;
                    objOEM_DB.SelectedOEMName = ALVendorOEM.SelectedOEMName;
                    objOEM_DB.EntityState = State.Modified;
                }
                if (ALVendorOEM.AL_Vendor_OEM_Code < 0)
                {
                    AL_Vendor_OEM objOEM_Sess = objSessVendor.AL_Vendor_OEM.Where(w => w.AL_Vendor_OEM_Code == ALVendorOEM.AL_Vendor_OEM_Code).FirstOrDefault();
                    objOEM_Sess.AL_OEM_Code = ALVendorOEM.AL_OEM_Code;
                    objOEM_Sess.SelectedOEMName = ALVendorOEM.SelectedOEMName;
                    ALVendorOEM.EntityState = State.Added;
                }
            }
            UsedOEMinDDl();
            UsedDDlOEMlst.Add(Convert.ToInt32(ALVendorOEM.AL_OEM_Code));

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        public ActionResult DeleteVendorOEM(int VendorOEMCode, string Action)
        {
            string status = "S";
            string message = "";

            AL_Vendor_OEM objVendorOEM = objSessVendor.AL_Vendor_OEM.Where(w => w.AL_Vendor_OEM_Code == VendorOEMCode).FirstOrDefault();

            if (objVendorOEM != null)
            {
                //objSessVendor.AL_Vendor_OEM.Remove(objVendorOEM);
                if (objVendorOEM.Is_Active == "Y")
                {
                    objVendorOEM.Is_Active = "N";
                    objVendorOEM.EntityState = State.Modified;
                }
                else
                {
                    objVendorOEM.Is_Active = "Y";
                    objVendorOEM.EntityState = State.Modified;
                }
                if (Action == "DELETE")
                {
                    objSessVendor.AL_Vendor_OEM.Remove(objVendorOEM);
                }
            }
            else
            {
                status = "E";
                message = objMessageKey.FileNotFound;
            }
            UsedOEMinDDl();

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        #endregion

        #region --- TNC ---

        public ActionResult TnC(string TabName, string CommandName, int Id)
        {
            List<AL_Vendor_TnC> lstTnC = new List<AL_Vendor_TnC>();
            lstTnC = objSessVendor.AL_Vendor_TnC.Where(w => w.EntityState != State.Deleted).ToList();
            ViewBag.CommandNameTnC = CommandName;
            ViewBag.TnCCode = Id;
            ViewBag.TabName = TabName;

            return PartialView("_TnC", lstTnC);
        }

        public ActionResult SaveTnC(AL_Vendor_TnC apVendorTnC)
        {
            string status = "S";
            string message = "";

            if (apVendorTnC.AL_Vendor_TnC_Code == 0)
            {
                if (objSessVendor.AL_Vendor_TnC.Count == 0)
                {
                    apVendorTnC.AL_Vendor_TnC_Code = -1;
                    apVendorTnC.EntityState = State.Added;
                    objSessVendor.AL_Vendor_TnC.Add(apVendorTnC);
                }
                else
                {
                    apVendorTnC.AL_Vendor_TnC_Code = Convert.ToInt32(Session["tempTnCID"]) - 1;
                    apVendorTnC.EntityState = State.Added;
                    objSessVendor.AL_Vendor_TnC.Add(apVendorTnC);
                }
                Session["tempTnCID"] = apVendorTnC.AL_Vendor_TnC_Code;
            }
            else
            {
                if (apVendorTnC.AL_Vendor_TnC_Code > 0)
                {
                    AL_Vendor_TnC objTnC_DB = objSessVendor.AL_Vendor_TnC.Where(w => w.AL_Vendor_TnC_Code == apVendorTnC.AL_Vendor_TnC_Code).FirstOrDefault();
                    objTnC_DB.TnC_Description = apVendorTnC.TnC_Description;
                    objTnC_DB.EntityState = State.Modified;
                }
                if (apVendorTnC.AL_Vendor_TnC_Code < 0)
                {
                    AL_Vendor_TnC objTnC_Sess = objSessVendor.AL_Vendor_TnC.Where(w => w.AL_Vendor_TnC_Code == apVendorTnC.AL_Vendor_TnC_Code).FirstOrDefault();
                    objTnC_Sess.TnC_Description = apVendorTnC.TnC_Description;
                    objTnC_Sess.EntityState = State.Added;
                }
            }

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        public ActionResult DeleteTnc(int VendorTncCode)
        {
            string status = "S";
            string message = "";

            AL_Vendor_TnC objVendorTnc = objSessVendor.AL_Vendor_TnC.Where(w => w.AL_Vendor_TnC_Code == VendorTncCode).FirstOrDefault();

            if (objVendorTnc != null)
            {
                //objSessVendor.AL_Vendor_TnC.Remove(objVendorTnc);
                objVendorTnc.EntityState = State.Deleted;
            }
            else
            {
                status = "E";
                message = objMessageKey.FileNotFound;
            }

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        #endregion

        #region --- Extra Methods ---

        private void FetchAllExtendedColumns()
        {
            List<RightsU_Entities.Extended_Columns> lstExtendedColumns = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            List<RightsU_Entities.Extended_Group> lstExtendedGroups = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Module_Code == GlobalParams.ModuleCodeForVendor).ToList();
            List<int> UsedExtendedColumns = new List<int>();
            foreach (Extended_Group eg in lstExtendedGroups)
            {
                foreach (Extended_Group_Config egc in eg.Extended_Group_Config)
                {
                    UsedExtendedColumns.Add(egc.Extended_Columns.Columns_Code);
                }
            }
            lstExtendedColumns = lstExtendedColumns.Where(w => UsedExtendedColumns.Any(a => w.Columns_Code == a)).ToList();

            DDlExtendedColumnsLst = lstExtendedColumns;
        }

        private void CheckForSelectedValues()
        {
            List<int> UpdatedListOfSelectedalues = new List<int>();
            UpdatedListOfSelectedalues = objVr.AL_Vendor_Rule_Criteria.Where(w => w.EntityState != State.Deleted).Select(s => Convert.ToInt32(s.Columns_Code)).ToList();
            UsedDDlExtendedColumnsLst = UsedDDlExtendedColumnsLst.Where(w => UpdatedListOfSelectedalues.Any(a => w == a)).ToList();
        }

        private void FetchAllOEMs()
        {
            List<RightsU_Entities.AL_OEM> lstOEMs = new AL_OEM_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            DDlOEMLst = lstOEMs;
        }

        private void UsedOEMinDDl()
        {
            List<int> UpdatedOEMValues = new List<int>();
            UpdatedOEMValues = objSessVendor.AL_Vendor_OEM.Select(s => Convert.ToInt32(s.AL_OEM_Code)).ToList();
            UsedDDlOEMlst = UsedDDlOEMlst.Where(w => UpdatedOEMValues.Any(a => w == a)).ToList();
        }

        public ActionResult ChangeDataInputType(int SelectedFieldType)
        {
            CreateExtendedDataObject(SelectedFieldType);

            return Json(objSessDictionary);
        }

        public void CreateExtendedDataObject(int SelectedFieldType)
        {
            Extended_Columns SelectedExCol = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Columns_Code == SelectedFieldType).FirstOrDefault();
            //Dictionary<string, object> obj = new Dictionary<string, object>();
            objSessDictionary = new Dictionary<string, object>();
            List<RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result> lstCol = new List<RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result>();

            if (SelectedExCol.Control_Type == "DDL")
            {
                if (SelectedExCol.Ref_Table != null)
                {
                    #region
                    //if (SelectedExCol.Ref_Table.ToUpper() == "TALENT".ToUpper())
                    //{
                    //    string ColumnsCode = SelectedExCol.Columns_Code.ToString();
                    //    string AdditionalCondition = SelectedExCol.Additional_Condition.ToString();

                    //    int RoleCode = 0;

                    //    if (AdditionalCondition != "")
                    //        RoleCode = Convert.ToInt32(AdditionalCondition);
                    //    lstCol = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Role.Any(TR => TR.Role_Code == RoleCode)).Where(y => y.Is_Active == "Y").Select(i => new SelectObject { ColumnsValue = i.Talent_Name, Columns_Value_Code = i.Talent_Code }).ToList();
                    //}

                    //if (SelectedExCol.Ref_Table.ToUpper() == "Extended_Columns_Value".ToUpper())
                    //{
                    //    int Column_Code = Convert.ToInt32(SelectedFieldType);
                    //    lstCol = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Column_Code).Select(y => new SelectObject { ColumnsValue = y.Columns_Value, Columns_Value_Code = y.Columns_Value_Code }).ToList();
                    //}
                    //if (SelectedExCol.Ref_Table.ToUpper() == "Banner".ToUpper())
                    //{
                    //    int AdditionalConditionCode = Convert.ToInt32(SelectedExCol.Additional_Condition);
                    //    lstCol = new Banner_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Select(y => new SelectObject { ColumnsValue = y.Banner_Name, Columns_Value_Code = y.Banner_Code }).ToList();
                    //}
                    #endregion

                    if (SelectedExCol.Is_Defined_Values == "N")
                    {
                        //Procedure Call
                        lstCol = new USP_Service(objLoginEntity.ConnectionStringName).USPGet_DDLValues_For_ExtendedColumns(SelectedFieldType).ToList();
                    }
                    else
                    {
                        int Column_Code = Convert.ToInt32(SelectedFieldType);
                        lstCol = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Column_Code).Select(y => new RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result { ColumnsValue = y.Columns_Value, Columns_Value_Code = y.Columns_Value_Code }).ToList();
                    }
                }
                else
                {
                    int Column_Code = Convert.ToInt32(SelectedFieldType);
                    lstCol = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Column_Code).Select(y => new RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result { ColumnsValue = y.Columns_Value, Columns_Value_Code = y.Columns_Value_Code }).ToList();
                }
                lstSelectObject = lstCol;

                if (SelectedExCol.Is_Multiple_Select == "Y")
                {
                    MultiSelectList newListItem = new MultiSelectList(lstCol, "Columns_Value_Code", "ColumnsValue");
                    if (SelectedColumnValues != null)
                    {
                        newListItem = new MultiSelectList(lstCol, "Columns_Value_Code", "ColumnsValue", SelectedColumnValues);
                    }
                    objSessDictionary.Add("SelectListItem", newListItem);
                    objSessDictionary.Add("IsMultiSelect", "Y");
                }
                else
                {
                    SelectList newListItem = new SelectList(lstCol, "Columns_Value_Code", "ColumnsValue");
                    if (SelectedColumnValues.Count == 1)
                    {
                        newListItem = new SelectList(lstCol, "Columns_Value_Code", "ColumnsValue", SelectedColumnValues);
                    }
                    objSessDictionary.Add("SelectListItem", newListItem);
                    objSessDictionary.Add("IsMultiSelect", "N");
                }
            }
            else if (SelectedExCol.Control_Type == "TXT")
            {
                objSessDictionary.Add("TextBox", "<input type=\"text\" id=\"CrCData\">");
                // Or contains ("CB, RB, SDTED, DATE")
                //obj.Add("Checkbox", "something");
            }
            else if (SelectedExCol.Control_Type == "DATE")
            {
                //Check for condition on view ContentRuleGrid to change text box to datepicker. Line -> (result.ControlType == "DATE")
                objSessDictionary.Add("Date", "<input type=\"text\" id=\"CrCData\" class=\"isDatepicker\" >");
            }
            else if (SelectedExCol.Control_Type == "INT")
            {
                objSessDictionary.Add("Number", "<input type=\"text\" id=\"CrCData\" class=\"isNumeric\" >");
            }
            else if (SelectedExCol.Control_Type == "CB")
            {
                string CheckBoxes = "";
                string CBValue = "RB";
                CheckBoxes = "<input type=\"checkbox\" id=\"CrCData\" name=\"Vendor\" value=\"" + CBValue + "\">";
                objSessDictionary.Add("CheckBox", CheckBoxes);
            }
            else if (SelectedExCol.Control_Type == "RB")
            {
                string RadioButtons = "";
                string RBValue = "RB";
                RadioButtons = "<input type=\"radio\" id=\"CrCData\" name=\"Vendor\" value=\"" + RBValue + "\">";
                objSessDictionary.Add("RadioButton", RadioButtons);
            }
            else if (SelectedExCol.Control_Type == "SDTED")
            {
                string StartDate = "<input type=\"date\" id=\"CrCData\">";
                string EndDate = "<input type=\"date\" id=\"CrCData\">";
                string Dates = StartDate + EndDate;
                objSessDictionary.Add("StartDateEndDate", Dates);
            }

            objSessDictionary.Add("ControlType", SelectedExCol.Control_Type);
            //obj = SelectListItem, IsMultiSelect, TextBox, ControlType

        }

        public bool CheckDuplicateContentRuleClientForSameType(string Rule_Name, string Rule_Type, int? AL_Vendor_Rule_Code, int? Vendor_Code)
        {
            int DuplicateCount = objSessVendor.AL_Vendor_Rule.Where(w => w.Rule_Name.ToUpper() == Rule_Name.ToUpper() && w.Rule_Type == Rule_Type && w.AL_Vendor_Rule_Code != AL_Vendor_Rule_Code).Count();

            if (DuplicateCount > 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        #endregion
    }

    public class SelectObject
    {
        public string ColumnsValue { get; set; }
        public int Columns_Value_Code { get; set; }
    }
}

//AL_Vendor_Details;
//AL_Vendor_Rule;
//AL_Vendor_Rule_Criteria;
//AL_OEM;
//AL_Vendor_TnC;
