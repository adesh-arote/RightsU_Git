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
    public class Title_ObjectionController : BaseController
    {
        #region Properties

        private List<RightsU_Entities.USP_Title_Objection_List_Result> lstUSP_Title_Objection_List
        {
            get
            {
                if (Session["lstUSP_Title_Objection_List"] == null)
                    Session["lstUSP_Title_Objection_List"] = new List<RightsU_Entities.USP_Title_Objection_List_Result>();
                return (List<RightsU_Entities.USP_Title_Objection_List_Result>)Session["lstUSP_Title_Objection_List"];
            }
            set { Session["lstUSP_Title_Objection_List"] = value; }
        }
        private List<RightsU_Entities.USP_Title_Objection_List_Result> lstUSP_Title_Objection_List_Searched
        {
            get
            {
                if (Session["lstUSP_Title_Objection_List_Searched"] == null)
                    Session["lstUSP_Title_Objection_List_Searched"] = new List<RightsU_Entities.USP_Title_Objection_List_Result>();
                return (List<RightsU_Entities.USP_Title_Objection_List_Result>)Session["lstUSP_Title_Objection_List_Searched"];
            }
            set { Session["lstUSP_Title_Objection_List_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {

            return View();
        }
        public PartialViewResult BindPartialPages(string key, int TitleObjectionCode)
        {

            //Vendor_Service objService = new Vendor_Service(objLoginEntity.ConnectionStringName);
            //RightsU_Entities.Vendor objVendor = null;
            if (key == "LIST")
            {

                ViewBag.ddlTitle = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName)
                                         .USP_Title_Objection_List("A", "", "")
                                         .ToList()
                                         .Select(x => new { x.Title_Code, x.Title }).ToList().Distinct()
                                         ,"Title_Code", "Title");

                ViewBag.ddlLicensor = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName)
                                        .USP_Title_Objection_List("A", "", "")
                                        .ToList()
                                        .Select(x => new { x.Licensor_Code, x.Licensor }).ToList().Distinct()
                                        ,"Licensor_Code", "Licensor");

                lstUSP_Title_Objection_List_Searched = lstUSP_Title_Objection_List = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_List("A", "", "").ToList();
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/Title_Objection/_Title_Objection.cshtml");
            }
            else
                return PartialView();
            //else
            //{
            //    int PartyMasterCode = 0;
            //    Session["VendorCode_AddEdit"] = VendorCode;
            //    if (VendorCode > 0 && key != "VIEW")
            //    {
            //        ViewBag.Mode = "";
            //        ViewData["Status"] = "U";
            //        objVendor = objService.GetById(VendorCode);

            //        ViewData["MyVendor"] = objVendor;
            //        #region  --- Country ---
            //        List<SelectListItem> listSelectListItems = new List<SelectListItem>();
            //        List<Vendor_Country> strCode = objVendor.Vendor_Country.ToList().Where(x => x.Is_Theatrical == "N").ToList();
            //        foreach (var country in strCode)
            //        {
            //            int i = Convert.ToInt32(country.Country_Code);
            //            RightsU_Entities.Country objCountry = lstCountry_Searched.Where(x => x.Country_Code == i).SingleOrDefault();
            //            string CountryName = objCountry.Country_Name;
            //            SelectListItem selectList = new SelectListItem()
            //            {
            //                Text = CountryName,
            //                Value = i.ToString(),
            //                Selected = true
            //            };
            //            listSelectListItems.Add(selectList);
            //        }
            //        List<RightsU_Entities.Country> temp_lstCountry = new List<RightsU_Entities.Country>();
            //        temp_lstCountry = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "N").ToList(); ;
            //        foreach (var item in strCode)
            //        {
            //            int i = Convert.ToInt32(item.Country_Code);
            //            var akshay = lstCountry_Searched.First(x => x.Country_Code == i);
            //            temp_lstCountry.Remove(akshay);
            //        }
            //        foreach (RightsU_Entities.Country city in temp_lstCountry)
            //        {
            //            SelectListItem selectList = new SelectListItem()
            //            {
            //                Text = city.Country_Name,
            //                Value = city.Country_Code.ToString(),
            //            };
            //            listSelectListItems.Add(selectList);
            //        }
            //        TempData["Country"] = listSelectListItems;
            //        #endregion
            //        #region --- Theterical ---
            //        List<SelectListItem> listSelectListItems_Theatrical = new List<SelectListItem>();
            //        List<Vendor_Country> strCode_Theterical = objVendor.Vendor_Country.ToList().Where(x => x.Is_Theatrical == "Y").ToList();
            //        foreach (var country in strCode_Theterical)
            //        {
            //            int i = Convert.ToInt32(country.Country_Code);
            //            RightsU_Entities.Country objCountry = lstCountry_Searched.Where(x => x.Country_Code == i).SingleOrDefault();
            //            string CountryName = objCountry.Country_Name;
            //            SelectListItem selectList = new SelectListItem()
            //            {
            //                Text = CountryName,
            //                Value = i.ToString(),
            //                Selected = true
            //            };
            //            listSelectListItems_Theatrical.Add(selectList);
            //        }
            //        List<RightsU_Entities.Country> temp_lstCountry_Theaterical = new List<RightsU_Entities.Country>();
            //        temp_lstCountry_Theaterical = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "Y").ToList(); ;
            //        foreach (var item in strCode_Theterical)
            //        {
            //            int i = Convert.ToInt32(item.Country_Code);
            //            var lstCountry = lstCountry_Searched.First(x => x.Country_Code == i);
            //            temp_lstCountry_Theaterical.Remove(lstCountry);
            //        }
            //        foreach (RightsU_Entities.Country city in temp_lstCountry_Theaterical)
            //        {
            //            SelectListItem selectList = new SelectListItem()
            //            {
            //                Text = city.Country_Name,
            //                Value = city.Country_Code.ToString(),
            //            };
            //            listSelectListItems_Theatrical.Add(selectList);
            //        }
            //        TempData["Theatrical"] = listSelectListItems_Theatrical;
            //        Syn_Deal_Service objSDS = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            //        List<Syn_Deal> lstSyn_Deal = objSDS.SearchFor(s => s.Vendor_Code == VendorCode).ToList();

            //        Acq_Deal_Service objADS = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            //        List<Acq_Deal> lstAcq_Deal = objADS.SearchFor(s => s.Vendor_Code == VendorCode).ToList();

            //        var ListSType = lstSyn_Deal.Select(x => x.Customer_Type).Distinct().ToList();
            //        var ListAType = lstAcq_Deal.Select(a => a.Role_Code).Distinct().ToList();

            //        //List<int> lstType = (List<int>)ListSType;

            //        ViewData["ListSType"] = ListSType;
            //        ViewData["ListAType"] = ListAType;
            //        #endregion

            //        #region -----type-----
            //        List<Role> lstRole = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Role_Type.Contains("V")).OrderBy(o => o.Role_Name).ToList();
            //        var roleCodes = objVendor.Vendor_Role.Select(s => s.Role_Code).ToArray();
            //        //var roleCodes = new[] { 8, 29 };
            //        // ViewBag.RoleList = new MultiSelectList(lstRole, "Role_Code", "Role_Name", new[] { 8, 29 });
            //        TempData["RoleList"] = new MultiSelectList(lstRole, "Role_Code", "Role_Name", roleCodes);
            //        #endregion
            //        List<RightsU_Entities.Party_Category> lstPartyCategory = new Party_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
            //        var PartyCategoryCode = objVendor.Party_Category_Code;
            //        ViewBag.PartyCategory = new SelectList(lstPartyCategory, "Party_Category_Code", "Party_Category_Name", PartyCategoryCode);
            //        PartyMasterCode = Convert.ToInt32(objVendor.Party_Group_Code);

            //    }
            //    else if (key == "VIEW")
            //    {
            //        objVendor = objService.GetById(VendorCode);
            //        ViewBag.Mode = "V";
            //        ViewData["MyVendor"] = objVendor;
            //    }
            //    else
            //    {
            //        ViewBag.Mode = "";
            //        List<Role> lstRole = new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Role_Type.Contains("V")).OrderBy(o => o.Role_Name).ToList();
            //        TempData["RoleList"] = new MultiSelectList(lstRole, "Role_Code", "Role_Name");
            //        List<SelectListItem> lstRoles = new List<SelectListItem>();
            //        List<RightsU_Entities.Role> temp_lstRoles = lstRole_Searched.Where(x => x.Role_Type.Contains("V")).ToList();
            //        foreach (RightsU_Entities.Role city in temp_lstRoles)
            //        {
            //            SelectListItem selectList = new SelectListItem()
            //            {
            //                Text = city.Role_Name,
            //                Value = city.Role_Code.ToString(),
            //            };
            //            lstRoles.Add(selectList);
            //        }
            //        TempData["Roles"] = lstRoles;
            //        ViewData["Status"] = "A";
            //        ViewData["MyVendor"] = "";
            //        #region == country & theterical
            //        List<SelectListItem> listSelectListItems = new List<SelectListItem>();
            //        List<RightsU_Entities.Country> temp_lstCountry = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "N").ToList();
            //        foreach (RightsU_Entities.Country city in temp_lstCountry)
            //        {
            //            SelectListItem selectList = new SelectListItem()
            //            {
            //                Text = city.Country_Name,
            //                Value = city.Country_Code.ToString(),
            //            };
            //            listSelectListItems.Add(selectList);
            //        }
            //        TempData["Country"] = listSelectListItems;
            //        List<SelectListItem> listSelectListItems_Theatrical = new List<SelectListItem>();
            //        List<RightsU_Entities.Country> temp_lstTheatrical = lstCountry_Searched.Where(x => x.Is_Theatrical_Territory == "Y").ToList();
            //        foreach (RightsU_Entities.Country city in temp_lstTheatrical)
            //        {
            //            SelectListItem selectList = new SelectListItem()
            //            {
            //                Text = city.Country_Name,
            //                Value = city.Country_Code.ToString(),
            //            };
            //            listSelectListItems_Theatrical.Add(selectList);
            //        }
            //        TempData["Theatrical"] = listSelectListItems_Theatrical;
            //        #endregion
            //        List<RightsU_Entities.Party_Category> lstPartyCategory = new Party_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
            //        ViewBag.PartyCategory = new SelectList(lstPartyCategory, "Party_Category_Code", "Party_Category_Name");
            //    }
            //    List<SelectListItem> PartySelectList = new List<SelectListItem>();
            //    PartySelectList = new SelectList(new Party_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderBy(o => o.Party_Group_Name), "Party_Group_Code", "Party_Group_Name", PartyMasterCode).ToList();
            //    PartySelectList.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            //    ViewBag.PartyMasterList = PartySelectList;

            //    // Send this list to the view                     
            //    return PartialView("~/Views/Vendor/_AddEditPartyVendor.cshtml");
            //}
        }

        public PartialViewResult BindTitleObjectionList(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.USP_Title_Objection_List_Result> lst = new List<RightsU_Entities.USP_Title_Objection_List_Result>();
            int RecordCount = 0;
            lstUSP_Title_Objection_List_Searched = lstUSP_Title_Objection_List_Searched.ToList();

            RecordCount = lstUSP_Title_Objection_List_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstUSP_Title_Objection_List_Searched.OrderByDescending(o => o.Title).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Title_Objection/_Title_Objection_List.cshtml", lst);
        }

        #region Other Method
        private string GetUserModuleRights()
        {
            List<string> lstRights = new List<string>();
            lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTitleObjection), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
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

        public JsonResult SearchTitleObjection(string Type, string Title_Codes = "", string Licensor_Codes = "")
        {
            lstUSP_Title_Objection_List_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_List(Type, Title_Codes, Licensor_Codes).ToList();

            var obj = new
            {
                Record_Count = lstUSP_Title_Objection_List_Searched.Count
            };
            return Json(obj);
        }
        public JsonResult BindTitleLicencor(string Type, string MapFor, string Title_Codes = "",string Licensor_Codes = "" )
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            if (MapFor == "T")
            {
                SelectList lstTitle = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName)
                                    .USP_Title_Objection_List(Type, Title_Codes, Licensor_Codes)
                                    .ToList()
                                    .Select(x=> new { Display_Value = x.Title_Code, Display_Text = x.Title }).ToList().Distinct()
                                    , "Display_Value", "Display_Text");
                obj_Dictionary.Add("lstTitle", lstTitle);
            }
            else if (MapFor == "L")
            {
                SelectList lstLicensor = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName)
                                .USP_Title_Objection_List(Type, Title_Codes, Licensor_Codes)
                                .ToList()
                                .Select(x => new { Display_Value= x.Licensor_Code, Display_Text = x.Licensor }).ToList().Distinct()
                                , "Display_Value", "Display_Text");
                obj_Dictionary.Add("lstLicensor", lstLicensor); 
            }

            return Json(obj_Dictionary);
        }
        
        #endregion
    }
}