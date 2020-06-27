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
            if (ModuleCode == "10")
                lstVendor_Searched = lstVendor_Searched.Where(w => w.Party_Type == "V").ToList();
            else
                lstVendor_Searched = lstVendor_Searched.Where(w => w.Party_Type == "C").ToList();
            
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
        public PartialViewResult BindVendorContact(int VendorCode ,string Mode)
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
                if (ModuleCode == "10"){
                    lstVendor_Searched = lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Party_Type == "V").OrderByDescending(o => o.Last_Updated_Time).ToList();
                    ModuleName = "Party";                    
                }
                else
                {
                    lstVendor_Searched = lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true && x.Party_Type == "C").OrderByDescending(o => o.Last_Updated_Time).ToList();
                     ModuleName = "Customer";
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
                else if(key == "VIEW")
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
                List<SelectListItem> PartySelectList  = new List<SelectListItem>(); 
                PartySelectList = new SelectList(new Party_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderBy(o => o.Party_Group_Name), "Party_Group_Code", "Party_Group_Name", PartyMasterCode).ToList();
                PartySelectList.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
                ViewBag.PartyMasterList = PartySelectList;

                // Send this list to the view                     
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
               lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForVendor), objLoginUser.Security_Group_Code,objLoginUser.Users_Code).ToList();
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
                objVendor.Fax_No = Vendor_FaxNo;
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
                objVendor.Fax_No = Vendor_FaxNo;  
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
            objVendor.Short_Code = objUser_MVC.Short_Code;
            objVendor.Last_Updated_Time = System.DateTime.Now;
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

                    if (VendorCode > 0)
                        message = objMessageKey.Recordupdatedsuccessfully;
                    //message = message.Replace("{ACTION}", "updated");
                    else
                        message = objMessageKey.RecordAddedSuccessfully;
                        //message = message.Replace("{ACTION}", "added");
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
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }
                if (doActive == "Y")
                    if(status == "E")
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
    }
}
