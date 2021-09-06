using Microsoft.Reporting.WebForms;
using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;
using System.Globalization;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using UTO.RightsU.Avails.Services.RightsUAvailsProvider;
using UTO.RightsU.Avails.AvailEntity.Avail;
using UTO.RightsU.Avails.AvailEntity;
using UTO.RightsU.Avails.AvailEntity.View;
using UTO.Framework.Shared.Configuration;
using RightsU_Plus.Models;
using System.Data;
using OfficeOpenXml;
using System.IO;
using System.Drawing;
using OfficeOpenXml.Style;

namespace RightsU_Plus.Controllers
{
    public class Availability_Movie_NewController : BaseController
    {

        #region --Properties--
        private List<RightsU_Entities.Title> lstTitles
        {
            get
            {
                if (Session["lstTitles"] == null)
                    Session["lstTitles"] = new List<RightsU_Entities.Title>();
                return (List<RightsU_Entities.Title>)Session["lstTitles"];
            }
            set { Session["lstTitles"] = value; }
        }

        private List<RightsU_Entities.Title> lstTitles_Searched
        {
            get
            {
                if (Session["lstTitles_Searched"] == null)
                    Session["lstTitles_Searched"] = new List<RightsU_Entities.Title>();
                return (List<RightsU_Entities.Title>)Session["lstTitles_Searched"];
            }
            set { Session["lstTitles_Searched"] = value; }
        }

        private RightsU_Entities.Platform_Group objPlatform_Group
        {
            get
            {
                if (Session["objPlatform_Group"] == null)
                    Session["objPlatform_Group"] = new RightsU_Entities.Platform_Group();
                return (RightsU_Entities.Platform_Group)Session["objPlatform_Group"];
            }
            set { Session["objPlatform_Group"] = value; }
        }

        private Platform_Group_Service objPlatform_Group_Service
        {
            get
            {
                if (Session["objPlatform_Group_Service"] == null)
                    Session["objPlatform_Group_Service"] = new Platform_Group_Service(objLoginEntity.ConnectionStringName);
                return (Platform_Group_Service)Session["objPlatform_Group_Service"];
            }
            set { Session["objPlatform_Group_Service"] = value; }
        }


        private RightsU_Entities.Language_Group objLanguage_Group
        {
            get
            {
                if (Session["objLanguage_Group"] == null)
                    Session["objLanguage_Group"] = new RightsU_Entities.Language_Group();
                return (RightsU_Entities.Language_Group)Session["objLanguage_Group"];
            }
            set { Session["objLanguage_Group"] = value; }
        }

        private Language_Group_Service objLanguage_Group_Service
        {
            get
            {
                if (Session["objLanguage_Group_Service"] == null)
                    Session["objLanguage_Group_Service"] = new Language_Group_Service(objLoginEntity.ConnectionStringName);
                return (Language_Group_Service)Session["objLanguage_Group_Service"];
            }
            set { Session["objLanguage_Group_Service"] = value; }
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

        private RightsU_Entities.Report_Territory objReportTerritpry
        {
            get
            {
                if (Session["objReportTerritpry"] == null)
                    Session["objReportTerritpry"] = new RightsU_Entities.Report_Territory();
                return (RightsU_Entities.Report_Territory)Session["objReportTerritpry"];
            }
            set { Session["objReportTerritpry"] = value; }
        }

        private Report_Territory_Service objReportTerritpry_Service
        {
            get
            {
                if (Session["objReportTerritpry_Service"] == null)
                    Session["objReportTerritpry_Service"] = new Report_Territory_Service(objLoginEntity.ConnectionStringName);
                return (Report_Territory_Service)Session["objReportTerritpry_Service"];
            }
            set { Session["objReportTerritpry_Service"] = value; }
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
        private RightsU_Entities.Promoter_Group objPromoter_Group
        {
            get
            {
                if (Session["objPromoter_Group"] == null)
                    Session["objPromoter_Group"] = new RightsU_Entities.Promoter_Group();
                return (RightsU_Entities.Promoter_Group)Session["objPromoter_Group"];
            }
            set { Session["objPromoter_Group"] = value; }
        }

        private Promoter_Group_Service objPromoter_Group_Service
        {
            get
            {
                if (Session["objPromoter_Group_Service"] == null)
                    Session["objPromoter_Group_Service"] = new Promoter_Group_Service(objLoginEntity.ConnectionStringName);
                return (Promoter_Group_Service)Session["objPromoter_Group_Service"];
            }
            set { Session["objPromoter_Group_Service"] = value; }
        }

        public string PlatformCodes
        {
            get
            {
                if (Session["PlatformCodes"] == null)
                    Session["PlatformCodes"] = "";
                return (string)Session["PlatformCodes"];
            }
            set { Session["PlatformCodes"] = value; }
        }
        public string PlatformBroadcastCodes
        {
            get
            {
                if (Session["PlatformBroadcastCodes"] == null)
                    Session["PlatformBroadcastCodes"] = "";
                return (string)Session["PlatformBroadcastCodes"];
            }
            set { Session["PlatformBroadcastCodes"] = value; }
        }
        public string MustHave_PlatformCodes
        {
            get
            {
                if (Session["MustHave_PlatformCodes"] == null)
                    Session["MustHave_PlatformCodes"] = "";
                return (string)Session["MustHave_PlatformCodes"];
            }
            set { Session["MustHave_PlatformCodes"] = value; }
        }
        public string PromoterCodes
        {
            get
            {
                if (Session["PromoterCodes"] == null)
                    Session["PromoterCodes"] = "";
                return (string)Session["PromoterCodes"];
            }
            set { Session["PromoterCodes"] = value; }
        }
        public string MustHave_PromoterCodes
        {
            get
            {
                if (Session["MustHave_PromoterCodes"] == null)
                    Session["MustHave_PromoterCodes"] = "";
                return (string)Session["MustHave_PromoterCodes"];
            }
            set { Session["MustHave_PromoterCodes"] = value; }
        }
        #endregion


        static int RcCount = 0;
        static string module = "";
        static string titNames = "";
        static string val = "";
        static bool ContryLevelRights = false;
        static bool TerritoryLevelRights = false;
        static bool IFTARights = false;
        static string TabName = "";
        public ActionResult Index()
        {
            string moduleCode = Request.QueryString["modulecode"];
            string Avail_All_Platform_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Platform").ToList().FirstOrDefault().Parameter_Value;

            ViewBag.Code = moduleCode;
            module = moduleCode;

            BindBusinessUnit();

            try
            {
                lstTitles_Searched = lstTitles = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            }
            catch (Exception ex)
            {

                //throw;
            }

            //ViewBag.BusinessUnitList = new SelectList(new Business_Unit_Service().SearchFor(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name").ToList();

            // new SelectList(new Business_Unit_Service().SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
            //.Select(i => new { Display_Value = i.Business_Unit_Code, Display_Text = i.Business_Unit_Name }).ToList().Distinct(),
            //"Display_Value", "Display_Text");

            ViewBag.LoginUserCode = objLoginUser.Users_Code;
            ContryLevelRights = GetUserModuleRights().Contains(GlobalParams.RightCodeForCountryLevel.ToString());
            TerritoryLevelRights = GetUserModuleRights().Contains(GlobalParams.RightCodeForTerritoryLevel.ToString());
            IFTARights = GetUserModuleRights().Contains(GlobalParams.RightCodeForIFTA.ToString());
            ViewBag.Avail_All_Platform_Code = Avail_All_Platform_Code;
            return View();
        }

        private void BindBusinessUnit()
        {
            string rightsForAllBU = GetUserModuleRights();

            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            string SelectedBU = objSystemParamService.SearchFor(p => p.Parameter_Name == "Title_Avail_BU").ToList().FirstOrDefault().Parameter_Value;
            string[] arr_BU_Codes = SelectedBU.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            List<SelectListItem> list = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(b => b.Users_Business_Unit.Any(UB => UB.Business_Unit_Code == b.Business_Unit_Code
                && UB.Users_Code == objLoginUser.Users_Code)
                && arr_BU_Codes.Contains(b.Business_Unit_Code.ToString()))
                .Select(R => new { Business_Unit_Code = R.Business_Unit_Code, Business_Unit_Name = R.Business_Unit_Name }),
                "Business_Unit_Code", "Business_Unit_Name").ToList();

            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~"))
            {
                list.Insert(0, new SelectListItem() { Selected = true, Text = "All Business Unit", Value = "0" });
            }
            ViewBag.BusinessUnitList = list;

        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(module), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        #region----------------Titles Criteria------------------------
        public PartialViewResult BindTitleList(int BU_Code)
        {
            Title_Service titleService = new Title_Service(objLoginEntity.ConnectionStringName);
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.USP_Get_Avail_Titles_Result> lstAvailTitles = new List<USP_Get_Avail_Titles_Result>();

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
            {
                int Deal_Type_Movie = Convert.ToInt32(objSystemParamService.SearchFor(p => p.Parameter_Name == "Deal_Type_Movie").FirstOrDefault().Parameter_Value);
                int Deal_Type_Cineplay = Convert.ToInt32(objSystemParamService.SearchFor(p => p.Parameter_Name == "Deal_Type_Cineplay").FirstOrDefault().Parameter_Value);
                ViewBag.TitleList = new SelectList(titleService.SearchFor(T => T.Is_Active == "Y" &&
                                                        T.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code && AM.Acq_Deal.Is_Master_Deal == "Y")
                                                        && (T.Deal_Type_Code == Deal_Type_Movie || T.Deal_Type_Code == Deal_Type_Cineplay))
                                                        .Select(l => new ListItem { Text = l.Title_Name, Value = l.Title_Code.ToString() })
                                                        .OrderBy(t => t.Value), "Value", "Text").ToList();
                lstAvailTitles = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Avail_Titles("", Convert.ToString(BU_Code), "M", "").ToList();

            }
            else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {
                int Deal_Type_Movie = Convert.ToInt32(objSystemParamService.SearchFor(p => p.Parameter_Name == "Deal_Type_Movie").FirstOrDefault().Parameter_Value);
                ViewBag.TitleList = new SelectList(titleService.SearchFor(T => T.Is_Active == "Y" &&
                                                        T.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code && AM.Acq_Deal.Is_Master_Deal == "Y")
                                                        && T.Deal_Type_Code != Deal_Type_Movie)
                                                        .Select(l => new ListItem { Text = l.Title_Name, Value = l.Title_Code.ToString() })
                                                        .OrderBy(t => t.Value), "Value", "Text").ToList();
                lstAvailTitles = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Avail_Titles("", Convert.ToString(BU_Code), "S", "").ToList();
            }

            //  lstTitles = ViewBag.TitleList;
            ViewBag.Code = module;
            return PartialView("~/Views/Availability_Movie_New/_TitlesCriteria.cshtml", lstAvailTitles);
        }

        public JsonResult BindSportsPlatTree(int BU_Code, int PrevBUCode)
        {
            string Is_ReloadPlatformTree = "N";
            string BUName = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Business_Unit_Code == BU_Code).Select(w => w.Business_Unit_Name).FirstOrDefault();
            string PrevBuName = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Business_Unit_Code == PrevBUCode).Select(w => w.Business_Unit_Name).FirstOrDefault();

            BUName = BUName == null ? "AllBU" : BUName;
            PrevBuName = PrevBuName == null ? "AllBU" : PrevBuName;

            if (BUName.ToUpper() == "SPORTS" || PrevBuName.ToUpper() == "SPORTS")
                Is_ReloadPlatformTree = "Y";




            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Is_ReloadPlatformTree", Is_ReloadPlatformTree);
            return Json(obj);
        }


        //public PartialViewResult SearchTitles(string searchText, int BU_Code, string[] a)
        //{
        //    System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service();
        //    string Deal_Type_Movie = Convert.ToString(objSystemParamService.SearchFor(p => p.Parameter_Name == "Deal_Type_Movie").FirstOrDefault().Parameter_Value);

        //    List<RightsU_Entities.USP_Get_Avail_Titles_Result> lstAvailTitles = new USP_Service().USP_Get_Avail_Titles(searchText).ToList();
        //    int[] code = lstAvailTitles.Select(x => x.Title_Code).ToArray();
        //    if (a == null)
        //    {
        //        ViewBag.TitleList = new SelectList(lstAvailTitles.Select(l => new ListItem { Text = l.Title_Name, Value = l.Title_Code.ToString() }).OrderBy(t => t.Value), "Value", "Text").ToList();
        //    }
        //    else
        //    {
        //        for (int i = 0; i < a.Length; i++)
        //        {
        //            int abc = Convert.ToInt32(a[i]);
        //            var objTitle = new Title_Service().SearchFor(x => x.Title_Code == abc).Select(x => new { x.Title_Code, x.Title_Name }).Distinct().FirstOrDefault();

        //            for (int j = 0; j < code.Length; j++)
        //            {
        //                if (code[j] == abc)
        //                {
        //                    RightsU_Entities.USP_Get_Avail_Titles_Result temp_AT = lstAvailTitles.Where(x => x.Title_Code == abc).SingleOrDefault();
        //                    lstAvailTitles.Remove(temp_AT);
        //                }
        //            }
        //            RightsU_Entities.USP_Get_Avail_Titles_Result obj = new RightsU_Entities.USP_Get_Avail_Titles_Result();
        //            obj.Title_Code = objTitle.Title_Code;
        //            obj.Title_Name = objTitle.Title_Name;
        //            lstAvailTitles.Add(obj);
        //        }
        //        List<SelectListItem> items = new SelectList(lstAvailTitles.Select(l => new ListItem { Text = l.Title_Name, Value = l.Title_Code.ToString() }).OrderBy(t => t.Value), "Value", "Text").Distinct().ToList();

        //        for (int j = 0; j < a.Length; j++)
        //        {
        //            for (int i = 0; i < items.Count; i++)
        //            {
        //                if (items[i].Value == a[j])
        //                {
        //                    items[i].Selected = true;
        //                }
        //            }
        //        }
        //        ViewBag.TitleList = items.Distinct();
        //    }
        //    return PartialView("~/Views/Availability_Movie/_TitlesCriteria.cshtml", ViewBag.TitleList);
        //}

        public ActionResult SearchTitles(string searchText, string BU_Code, string[] a, string CodeString)
        {
            dynamic result = "";
            if (BU_Code == "0")
            {
                BU_Code = "0";
                //BU_Code = string.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                //     .Select(s => s.Business_Unit_Code.ToString()).ToArray());
            }


            List<RightsU_Entities.USP_Get_Avail_Titles_Result> lstAvailTitles = new List<USP_Get_Avail_Titles_Result>();
            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
            {
                lstAvailTitles = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Avail_Titles(searchText, BU_Code, "M", CodeString).ToList();
            }
            else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                lstAvailTitles = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Avail_Titles(searchText, BU_Code, "S", CodeString).ToList();
            }
            else if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                lstAvailTitles = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Avail_Titles(searchText, BU_Code, "M", CodeString).ToList();
            }


            if (a == null)
            {
                ViewBag.TitleList = new SelectList(lstAvailTitles.Select(l => new ListItem { Text = l.Title_Name, Value = l.Title_Code.ToString() }).OrderBy(t => t.Value), "Value", "Text").ToList();
            }
            else
            {
                for (int i = 0; i < a.Length; i++)
                {
                    int titleCode = Convert.ToInt32(a[i]);
                    RightsU_Entities.USP_Get_Avail_Titles_Result objT = lstAvailTitles.Where(w => w.Title_Code == titleCode).FirstOrDefault();
                    if (objT == null)
                    {
                        objT = new RightsU_Entities.USP_Get_Avail_Titles_Result();
                        var objTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == titleCode).Select(x => new { x.Title_Code, x.Title_Name }).Distinct().FirstOrDefault();
                        objT.Title_Code = objTitle.Title_Code;
                        objT.Title_Name = objTitle.Title_Name;
                        lstAvailTitles.Add(objT);
                    }
                }
                List<SelectListItem> items = new SelectList(lstAvailTitles.Select(l => new ListItem { Text = l.Title_Name, Value = l.Title_Code.ToString() }).OrderBy(t => t.Value), "Value", "Text").Distinct().ToList();
                items.Where(w => a.Contains(w.Value)).ToList().ForEach(f => { f.Selected = true; });
                ViewBag.TitleList = items;

            }
            ViewBag.lstAvailTitles = lstAvailTitles.Count;
            ViewBag.Code = module;
            result = lstAvailTitles.Select(s => new { Title_Name = s.Title_Name, Title_Code = s.Title_Code }).ToList();
            //.Where(x => x.Music_Album_Code == music_Album_Code)
            return Json(result);
            //return PartialView("~/Views/Availability_Movie/_TitlesCriteria.cshtml", lstAvailTitles);
            //return Json(lstAvailTitles);
        }

        public JsonResult AddTitles(int titleCode, string BU_Code, string tempName)
        {
            List<RightsU_Entities.USP_Get_Avail_Titles_Result> lstAvailTitles = new List<USP_Get_Avail_Titles_Result>();
            lstAvailTitles = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Avail_Titles("", BU_Code, "S", "").ToList();
            RightsU_Entities.USP_Get_Avail_Titles_Result objT = lstAvailTitles.Where(w => w.Title_Code == titleCode).FirstOrDefault();
            string[] titleArray = new string[] { };


            var obj = new
            {
                TitleName = tempName + ", " + objT.Title_Name
            };

            return Json(obj);
        }

        #endregion

        #region----------------Period Criteria------------------------

        public PartialViewResult BindPeriod()
        {
            return PartialView("~/Views/Availability_Movie/_PeriodCriteria.cshtml");
        }

        public JsonResult GetSysConfig()
        {
            var Avail_Min_Date = "";
            string date = "";

            System_Parameter_New_Service objSystemParamservice = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            Avail_Min_Date = objSystemParamservice.SearchFor(s => s.Parameter_Name == "Avail_Min_Date").ToList().FirstOrDefault().Parameter_Value;

            if (Avail_Min_Date.ToUpper() == "D")
            {
                date = "D";
            }
            else if (Avail_Min_Date.ToUpper() == "Y")
            {
                date = "Y";
            }
            else if (Avail_Min_Date.ToUpper() == "Q")
            {
                date = "Q";
            }
            else if (Avail_Min_Date.ToUpper() == "M")
            {
                date = "M";
            }

            var obj = new
            {
                dateConfig = date
            };

            return Json(obj);
        }

        #endregion

        #region----------------Region Criteria------------------------
        public PartialViewResult BindRegionRight()
        {
            ViewBag.ISCountryRight = ContryLevelRights;
            ViewBag.IsTerritoryLevelRights = TerritoryLevelRights;
            ViewBag.ModuleCode = module;
            return PartialView("~/Views/Availability_Movie_New/_RegionRightsData.cshtml");
        }

        public PartialViewResult BindRegion(bool IFTA, bool CountryLevel, string CheckRight)
        {
            int IndiaAvailCode = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "India_Avail").ToList().FirstOrDefault().Parameter_Value);
            string Avail_All_Region_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Region").ToList().FirstOrDefault().Parameter_Value;
            string Avail_All_Ifta_Region_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Ifta_Region").ToList().FirstOrDefault().Parameter_Value;

            string SecGroupCode = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Security_Group_Code_Avail").ToList().FirstOrDefault().Parameter_Value;
            List<SelectListItem> TerrList = new List<SelectListItem>();
            var Is_IFTA_Cluster = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Is_IFTA_Cluster").ToList().FirstOrDefault().Parameter_Value;
            if (Is_IFTA_Cluster == "Y")
                ViewBag.IFTACLuster = true;
            else
                ViewBag.IFTACLuster = false;
            IFTARights = GetUserModuleRights().Contains(GlobalParams.RightCodeForIFTA.ToString());
            if (CheckRight != "UnCheck")
                IFTA = IFTARights;

            IFTA = false;

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                if (IFTA == true)
                {
                    string[] arrTerrCodes = new Report_Territory_Country_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Country_Code == IndiaAvailCode).Select(s => s.Report_Territory_Code.ToString()).ToArray();
                    if (SecGroupCode == objLoginUser.Security_Group_Code.ToString())
                        TerrList = new SelectList(new Report_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y" && !arrTerrCodes.Contains(c.Report_Territory_Code.ToString())).Select(c => new ListItem { Text = c.Report_Territory_Name, Value = "T" + c.Report_Territory_Code }), "Value", "Text", "T" + Avail_All_Ifta_Region_Code).ToList();
                    else
                        TerrList = new SelectList(new Report_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y").Select(c => new ListItem { Text = c.Report_Territory_Name, Value = "T" + c.Report_Territory_Code }), "Value", "Text", "T" + Avail_All_Ifta_Region_Code).ToList();
                    ViewBag.TerritoryList = TerrList;
                }
                else
                {
                    string[] arrTerrCodes = new Territory_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Country_Code == IndiaAvailCode).Select(s => s.Territory_Code.ToString()).ToArray();
                    if (SecGroupCode == objLoginUser.Security_Group_Code.ToString())
                        TerrList = new SelectList(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y" && c.Is_Thetrical == "N" && !arrTerrCodes.Contains(c.Territory_Code.ToString())).Select(c => new ListItem { Text = c.Territory_Name, Value = "T" + c.Territory_Code }), "Value", "Text", "T" + Avail_All_Region_Code).ToList();
                    else
                        TerrList = new SelectList(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y" && c.Is_Thetrical == "N").Select(c => new ListItem { Text = c.Territory_Name, Value = "T" + c.Territory_Code }), "Value", "Text", "T" + Avail_All_Region_Code).ToList();
                    ViewBag.TerritoryList = TerrList;
                }
            }
            if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                TerrList = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Domestic_Territory == "Y" && w.Is_Active == "Y")
                     .Select(c => new ListItem { Text = c.Country_Name, Value = "T" + c.Country_Code }), "Value", "Text", "T" + Avail_All_Region_Code).ToList();
                ViewBag.TerritoryList = TerrList;
            }
            if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {
                TerrList.Insert(0, new SelectListItem() { Value = "1", Text = "All System Countries", Selected = true });
                ViewBag.TerritoryList = TerrList;
            }

            List<SelectListItem> CountryList = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y" && c.Is_Theatrical_Territory == "N").Select(c => new ListItem { Text = c.Country_Name, Value = c.Country_Code.ToString() }), "Value", "Text").OrderBy(l => l.Text).ToList();
            ViewBag.CountryList = CountryList;
            ViewBag.ListCountry = new List<SelectListItem>();
            ViewBag.IFTA = IFTA;
            ViewBag.CountryLevel = CountryLevel;
            ViewBag.ModuleCode = module;
            ViewBag.AvailAllRegionCode = Avail_All_Region_Code;
            ViewBag.UserModuleRights = GetUserModuleRights();
            ViewBag.CheckCountryLevel = ContryLevelRights;
            if (ContryLevelRights)
            {
                if (CheckRight == null)
                    CheckRight = "CO";
            }
            else if (TerritoryLevelRights)
            {
                if (CheckRight == null)
                    CheckRight = "IF";
            }
            if (CheckRight == "runQuery")
                ViewBag.TabName = TabName;
            else
                ViewBag.TabName = "";
            ViewBag.CheckRight = CheckRight;
            return PartialView("~/Views/Availability_Movie_New/_RegionCriteria.cshtml");
        }




        public ActionResult LoadCountry(string code, string IFTACluster, string platformcodes)//,string call = ""
        {
            if (platformcodes == null)
            {
                platformcodes = "";
            }

            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();

            if (IFTACluster == "IFTA")
            {
                if (code != "0")
                {
                    IEnumerable<RightsU_Entities.Country> lstLanguage = null;
                    string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    lstLanguage = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Country_Code.ToString())).ToList();

                    var temp = string.Join(",", lstLanguage.Select(x => x.Country_Name.ToString()).ToArray());
                    List<SelectListItem> ListCountry = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Country_Code.ToString())).Select(l => new ListItem { Text = l.Country_Name, Value = l.Country_Code.ToString() }), "Value", "Text").ToList();
                    obj_Dictionary.Add("listCountry", ListCountry);
                    obj_Dictionary.Add("temp", temp);
                    return Json(obj_Dictionary);
                }
                else
                {
                    IEnumerable<RightsU_Entities.Country> lstLanguage = null;
                    string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    lstLanguage = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Country_Code.ToString())).ToList();

                    var temp = string.Join(",", lstLanguage.Select(x => x.Country_Name.ToString()).ToArray());
                    List<SelectListItem> ListCountry = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Country_Code.ToString())).Select(l => new ListItem { Text = l.Country_Name, Value = l.Country_Code.ToString() }), "Value", "Text").ToList();
                    obj_Dictionary.Add("listCountry", ListCountry);
                    obj_Dictionary.Add("temp", temp);
                    return Json(obj_Dictionary);
                }

            }
            else
            {
                if (code != "0")
                {
                    IEnumerable<RightsU_Entities.Country> lstLanguage = null;
                    string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    lstLanguage = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Country_Code.ToString())).ToList();
                    var temp = string.Join(",", lstLanguage.Select(x => x.Country_Name.ToString()).ToArray());
                    List<SelectListItem> ListCountry = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Country_Code.ToString())).Select(l => new ListItem { Text = l.Country_Name, Value = l.Country_Code.ToString() }), "Value", "Text").ToList();
                    obj_Dictionary.Add("listCountry", ListCountry);
                    obj_Dictionary.Add("temp", temp);
                    return Json(obj_Dictionary);
                }

                else
                {
                    IEnumerable<RightsU_Entities.Country> lstLanguage = null;
                    string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    lstLanguage = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Country_Code.ToString())).ToList();

                    var temp = string.Join(",", lstLanguage.Select(x => x.Country_Name.ToString()).ToArray());
                    List<SelectListItem> ListCountry = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Country_Code.ToString())).Select(l => new ListItem { Text = l.Country_Name, Value = l.Country_Code.ToString() }), "Value", "Text").ToList();
                    obj_Dictionary.Add("listCountry", ListCountry);
                    obj_Dictionary.Add("temp", temp);
                    return Json(obj_Dictionary);
                }

            }


        }

        public PartialViewResult AddEditCountry(string TerritoryCode, string IFTACluster, string selectedCodes, string callfrom, string Region_On)
        {
            if (ContryLevelRights == true && Region_On == "CO" && TerritoryCode == "0")
                TerritoryCode = "T3";
            if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                TerritoryCode = "T3";

            string strListTerritoryCodes = "";
            string strListTerritoryCodes_Run = "";
            TerritoryCode = TerritoryCode.Replace("T", string.Empty);
            string[] strTerritoryCode = TerritoryCode.Split(',');


            if (selectedCodes == "" || selectedCodes == null)
            {
                strListTerritoryCodes = "";
            }
            else
            {
                strListTerritoryCodes = selectedCodes;
            }

            if (IFTACluster == "IFTA")
            {
                objReportTerritpry = new RightsU_Entities.Report_Territory();
                objReportTerritpry_Service = null;

                strListTerritoryCodes = string.Join(",", new Report_Territory_Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => strTerritoryCode.Contains(x.Report_Territory_Code.ToString())).ToList().Select(x => Convert.ToString(x.Country_Code)).Distinct());
                strListTerritoryCodes_Run = strListTerritoryCodes;
                List<RightsU_Entities.Country> lstCountry = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Country_Name).ToList();
                if (callfrom == "runQuery")
                {
                    return BindCountryTreeView(selectedCodes, "LG", callfrom, TerritoryCode, strListTerritoryCodes_Run, selectedCodes);
                }

                return BindCountryTreeView(strListTerritoryCodes, "LG", callfrom, TerritoryCode, strListTerritoryCodes_Run, selectedCodes);
            }
            else if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                objCountry = new RightsU_Entities.Country();
                objCountry_Service = null;
                strListTerritoryCodes = string.Join(",", new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => strTerritoryCode.Contains(x.Parent_Country_Code.ToString()) && x.Is_Theatrical_Territory == "Y").ToList().Select(x => Convert.ToString(x.Country_Code)).Distinct());
                strListTerritoryCodes_Run = strListTerritoryCodes;

                if (callfrom == "runQuery")
                {
                    return BindCountryTreeView(selectedCodes, "LG", callfrom, TerritoryCode, strListTerritoryCodes_Run, selectedCodes);
                }
                return BindCountryTreeView(strListTerritoryCodes, "LG", callfrom, TerritoryCode, strListTerritoryCodes_Run, selectedCodes);
            }
            else
            {
                objTerritory = new RightsU_Entities.Territory();
                objTerritory_Service = null;
                strListTerritoryCodes = string.Join(",", new Territory_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => strTerritoryCode.Contains(x.Territory_Code.ToString())).ToList().Select(x => Convert.ToString(x.Country_Code)).Distinct());
                strListTerritoryCodes_Run = strListTerritoryCodes;

                if (callfrom == "runQuery")
                {
                    return BindCountryTreeView(selectedCodes, "LG", callfrom, TerritoryCode, strListTerritoryCodes_Run, selectedCodes);
                }
                return BindCountryTreeView(strListTerritoryCodes, "LG", callfrom, TerritoryCode, strListTerritoryCodes_Run, selectedCodes);
            }

        }


        public PartialViewResult BindCountryTreeView(string strListCountryCodes, string bindType = "", string callFrom = "", string TerritoryCode = "0", string strListTerritoryCodes_Run = "", string strSelected = "")
        {
            string Avail_All_Region_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Region").ToList().FirstOrDefault().Parameter_Value;
            string Avail_All_Ifta_Region_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Ifta_Region").ToList().FirstOrDefault().Parameter_Value;
            Avail_All_Region_Code = Avail_All_Region_Code.Insert(0, "T");
            Avail_All_Ifta_Region_Code = Avail_All_Ifta_Region_Code.Insert(0, "T");

            string strIndiaCastCountryCode = string.Join(",", new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Is_Theatrical_Territory == "N" && s.Country_Name != "India").Select(s => s.Country_Code).ToList());
            if (strListCountryCodes == null)
            {
                strListCountryCodes = "";
            }
            string strTreeId = "Rights_Platform", strTreeValueId = "hdnTVCodes", strTreeText = "hdnTVText";
            if (bindType == "LG")
            {
                strTreeId = strTreeId + "_Country";
                strTreeValueId = strTreeValueId + "_Country";
                strTreeText = strTreeText + "_Country";
            }
            else if (bindType == "MH")
            {
                strTreeId = strTreeId + "_Country_M";
                strTreeValueId = strTreeValueId + "_Country_M";

            }

            else if (bindType == "EM")
            {
                strTreeId = strTreeId + "_Country_E";
                strTreeValueId = strTreeValueId + "_Country_E";
            }

            Country_Tree_View objPTV = new Country_Tree_View(objLoginEntity.ConnectionStringName);
            if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {
                Avail_All_Region_Code = Avail_All_Region_Code.Trim('T');
                if ((module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() && strSelected == "" && TerritoryCode == Avail_All_Region_Code) || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() && strSelected == "" && TerritoryCode == Avail_All_Region_Code)
                    objPTV.CountryCodes_Selected = "".Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                else if ((module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() && strSelected != "" && TerritoryCode == Avail_All_Region_Code) || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() && strSelected != "" && TerritoryCode == Avail_All_Region_Code)
                    objPTV.CountryCodes_Selected = strSelected.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                else
                    objPTV.CountryCodes_Selected = strIndiaCastCountryCode.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            }
            else
            {
                if (TerritoryCode == Avail_All_Region_Code && callFrom == "runQuery" && strSelected == "" || TerritoryCode == Avail_All_Ifta_Region_Code && callFrom == "runQuery" && strSelected == "")
                    objPTV.CountryCodes_Selected = "".Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                else if (TerritoryCode == Avail_All_Region_Code && callFrom == "runQuery" && strSelected != "" || TerritoryCode == Avail_All_Ifta_Region_Code && callFrom == "runQuery" && strSelected != "")
                    objPTV.CountryCodes_Selected = strSelected.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                else if (TerritoryCode == "0" && callFrom == "runQuery" && strSelected != "")
                    objPTV.CountryCodes_Selected = strSelected.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                else
                    objPTV.CountryCodes_Selected = strListCountryCodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }

            objPTV.Show_Selected = true;
            objPTV.objLoginUserSecurityGroupCode = objLoginUser.Security_Group_Code.ToString();
            objPTV.ModuleCode = module;
            //if (callFrom == "runQuery" && TerritoryCode == "0")
            //{
            //    objPTV.CountryCodes_Display = "";
            //}

            if (callFrom == "runQuery" && TerritoryCode != "0")
            {
                objPTV.CountryCodes_Display = strListTerritoryCodes_Run;
            }
            else
            {
                objPTV.CountryCodes_Display = strListCountryCodes;
            }

            if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
                objPTV.Is_Theatrical = "Y";
            else
                objPTV.Is_Theatrical = "N";

            if (bindType == "EM")
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            else
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");

            ViewBag.TreeId = strTreeId;
            ViewBag.TreeValueId = strTreeValueId;
            ViewBag.Treetext = strTreeText;
            return PartialView("_TV_Platform");
        }

        #endregion

        #region----------------Subtitle Language Criteria------------------------

        public PartialViewResult BindSubtitleLanguage(int Language_Group_Code)
        {
            string Avail_All_Language_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Language").ToList().FirstOrDefault().Parameter_Value;
            List<SelectListItem> ddlLanguageGroupNew = new SelectList(new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Group_Name, Value = "G" + l.Language_Group_Code }), "Value", "Text", "G" + Avail_All_Language_Code).ToList();
            //ddlLanguageGroupNew.Insert(0, new SelectListItem() { Value = Avail_All_Language_Code, Text = "All System Languages" });
            ViewBag.ddlLanguageGroupNew = ddlLanguageGroupNew;

            //List<SelectListItem> lstLLanguageGroupNew = new SelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Name, Value = "L" + l.Language_Code }), "Value", "Text").OrderBy(l => l.Text).ToList();
            //lstLLanguageGroupNew.Insert(0, new SelectListItem() { Value = "0", Text = "--Please Select--" });
            //ViewBag.lstLLanguageGroupNew = lstLLanguageGroupNew;
            ViewBag.AvailAllLanguageCode = Avail_All_Language_Code;
            return PartialView("~/Views/Availability_Movie_New/_Subtitle_LanguageCriteria.cshtml");
        }

        public ActionResult LoadLanguageNew(string code, string platformcodes)
        {
            if (platformcodes == null)
                platformcodes = "";

            Dictionary<object, object> obj_DictionarySubLang = new Dictionary<object, object>();
            // int LangGroupCode = Convert.ToInt32(code.TrimStart('G'));
            Language_Group_Service languGroupService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
            //if (LangGroupCode != 0)
            //{
            //    IEnumerable<RightsU_Entities.Language> lstLanguage = null;
            //    string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //    lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).ToList();

            //    var tempLanguageList = string.Join(",", lstLanguage.Select(x => x.Language_Name.ToString()).ToArray());
            //    List<SelectListItem> ListLanguagedetails = new SelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }), "Value", "Text").ToList();
            //    obj_DictionarySubLang.Add("lstLanguageGroupDetails", ListLanguagedetails);
            //    obj_DictionarySubLang.Add("tempLanguageList", tempLanguageList);
            //    return Json(obj_DictionarySubLang);
            //}
            //else
            //{
            IEnumerable<RightsU_Entities.Language> lstLanguage = null;
            string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).ToList();

            var tempLanguageList = string.Join(",", lstLanguage.Select(x => x.Language_Name.ToString()).ToArray());
            List<SelectListItem> ListLanguagedetails = new SelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }), "Value", "Text").ToList();
            obj_DictionarySubLang.Add("lstLanguageGroupDetails", ListLanguagedetails);
            obj_DictionarySubLang.Add("tempLanguageList", tempLanguageList);
            return Json(obj_DictionarySubLang);
            //}
        }

        public ActionResult BindDropdown(string platformcodes)
        {
            IEnumerable<RightsU_Entities.Language> lstLanguage = null;
            string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).ToList();

            var tempLanguageList = string.Join(",", lstLanguage.Select(x => x.Language_Name.ToString()).ToArray());
            List<SelectListItem> ListLanguagedetails = new SelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }), "Value", "Text").ToList();

            return Json(lstLanguage, JsonRequestBehavior.AllowGet);
        }

        public PartialViewResult AddEditLanguage_Group(string Language_Group_Code, string selectedCodes, string callFrom)
        {
            objLanguage_Group = new RightsU_Entities.Language_Group();
            objLanguage_Group_Service = null;

            string strListLanguageCodes = "";
            string strListLanguageCodes_Run = "";
            Language_Group_Code = Language_Group_Code.Replace("G", string.Empty);
            string[] strLanguage_Group_Code = Language_Group_Code.Split(',');

            if (selectedCodes == "" || selectedCodes == null)
            {
                strListLanguageCodes = "";
            }
            else
            {
                strListLanguageCodes = selectedCodes;
            }
            strListLanguageCodes = string.Join(",", new Language_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => strLanguage_Group_Code.Contains(x.Language_Group_Code.ToString())).ToList().Select(x => Convert.ToString(x.Language_Code)).Distinct());
            strListLanguageCodes_Run = strListLanguageCodes;


            //if (Language_Group_Code > 0)
            //{
            //    objLanguage_Group = objLanguage_Group_Service.GetById(Language_Group_Code);
            //    strListLanguageCodes = string.Join(",", new Language_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Language_Group_Code == Language_Group_Code).ToList().Select(x => Convert.ToString(x.Language_Code)));
            //    strListLanguageCodes_Run = strListLanguageCodes;
            //}


            // string strListLanguageCodes = objLanguage_Group.Language_Group_Details.Select(s => s.Language_Code).ToString();
            // string strListLanguageCodes = string.Join(",", new Language_Group_Service().SearchFor(x => x.Language_Group_Code == Language_Group_Code).ToList().Select(x => Convert.ToString(x.Language_Group_Code)));
            //List<RightsU_Entities.Language> lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Language_Name).ToList();
            //var languageCode = objLanguage_Group.Language_Group_Details.Select(s => s.Language_Code).ToArray();
            //ViewBag.LanguageList = new MultiSelectList(lstLanguage, "Language_Code", "Language_Name", languageCode);
            if (callFrom == "runQuery")
            {
                return BindLanguageTreeView(selectedCodes, "LG", callFrom, Language_Group_Code, strListLanguageCodes_Run, selectedCodes);
            }

            return BindLanguageTreeView(strListLanguageCodes, "LG", callFrom, Language_Group_Code, strListLanguageCodes_Run, selectedCodes);
        }

        public PartialViewResult BindLanguageTreeView(string strListLanguageCodes, string bindType = "", string callFrom = "", string Language_Group_Code = "0", string strListLanguageCodes_Run = "", string strSelected = "")
        {
            string Avail_All_Language_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Language").ToList().FirstOrDefault().Parameter_Value;
            Avail_All_Language_Code = Avail_All_Language_Code.Insert(0, "G");
            if (strListLanguageCodes == null)
            {
                strListLanguageCodes = "";
            }
            string strTreeId = "Rights_Platform", strTreeValueId = "hdnTVCodes";
            if (bindType == "LG")
            {
                strTreeId = strTreeId + "_SubLang_G";
                strTreeValueId = strTreeValueId + "_SubLang_G";
            }
            else if (bindType == "MH")
            {
                strTreeId = strTreeId + "SubLang_M";
                strTreeValueId = strTreeValueId + "_SubLang_M";
            }

            else if (bindType == "EM")
            {
                strTreeId = strTreeId + "_SubLang_E";
                strTreeValueId = strTreeValueId + "_SubLang_E";
            }

            Language_Tree_View objPTV = new Language_Tree_View(objLoginEntity.ConnectionStringName);
            //objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //objPTV.PlatformCodes_Display = strPlatform;
            if (Language_Group_Code == Avail_All_Language_Code && callFrom == "runQuery" && strSelected == "")
                objPTV.LanguageCodes_Selected = "".Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            else if (Language_Group_Code == Avail_All_Language_Code && callFrom == "runQuery" && strSelected != "")
                objPTV.LanguageCodes_Selected = strSelected.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            else
                objPTV.LanguageCodes_Selected = strListLanguageCodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            objPTV.Show_Selected = true;
            if (callFrom == "runQuery" && Language_Group_Code == "0")
                objPTV.LanguageCodes_Display = "";
            else if (callFrom == "runQuery" && Language_Group_Code != "0")
            {
                objPTV.LanguageCodes_Display = strListLanguageCodes_Run;
            }
            else
                objPTV.LanguageCodes_Display = strListLanguageCodes;


            if (bindType == "EM")
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            else
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");

            ViewBag.TreeId = strTreeId;
            ViewBag.TreeValueId = strTreeValueId;
            return PartialView("_TV_Platform");
        }

        #endregion

        #region----------------Dubbing Language Criteria------------------------

        public PartialViewResult BindDubbingLanguage(int Language_Group_Code)
        {
            string Avail_All_Language_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Language").ToList().FirstOrDefault().Parameter_Value;
            objLanguage_Group = new RightsU_Entities.Language_Group();
            objLanguage_Group_Service = null;

            if (Language_Group_Code > 0)
                objLanguage_Group = objLanguage_Group_Service.GetById(Language_Group_Code);

            string strListLanguageCodes = string.Join(",", new Language_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Language_Group_Code == Language_Group_Code).ToList().Select(x => Convert.ToString(x.Language_Code)));


            List<RightsU_Entities.Language> lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Language_Name).ToList();
            var languageCode = objLanguage_Group.Language_Group_Details.Select(s => s.Language_Code).ToArray();
            ViewBag.LanguageList = new MultiSelectList(lstLanguage, "Language_Code", "Language_Name", languageCode);

            ViewBag.strListLanguageCodes_Dub = strListLanguageCodes;

            List<SelectListItem> ddlLanguageGroupNew_dub = new SelectList(new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Group_Name, Value = "G" + l.Language_Group_Code }), "Value", "Text", "G" + Avail_All_Language_Code).ToList();
            //ddlLanguageGroupNew_dub.Insert(0, new SelectListItem() { Value = Avail_All_Language_Code, Text = "All System Language" });
            ViewBag.ddlLanguageGroupNew_dub = ddlLanguageGroupNew_dub;
            ViewBag.AvailAllLanguageCode = Avail_All_Language_Code;
            return PartialView("~/Views/Availability_Movie_New/_Dubbing_LanguageCriteria.cshtml");
        }

        public ActionResult LoadLanguageNew_Dub(string code, string platformcodes)
        {
            if (platformcodes == null)
                platformcodes = "";

            Dictionary<object, object> obj_Dictionary_DubLang = new Dictionary<object, object>();
            // int LanGroupCode_Dub = Convert.ToInt32(code.Trim('G'));
            Language_Group_Service langGroupService_Dub = new Language_Group_Service(objLoginEntity.ConnectionStringName);
            //if (LanGroupCode_Dub != 0)
            //{
            //    IEnumerable<RightsU_Entities.Language> lstLanguage = null;
            //    string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //    lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).ToList();
            //    var tempLanguageList_Dub = string.Join(",", lstLanguage.Select(x => x.Language_Name.ToString()).ToArray());
            //    List<SelectListItem> ListLanguageDetails_Dub = new SelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }), "Value", "Text").ToList();
            //    obj_Dictionary_DubLang.Add("lstListLanguageDetails_Dub", ListLanguageDetails_Dub);
            //    obj_Dictionary_DubLang.Add("tempLanguageList_Dub", tempLanguageList_Dub);
            //    return Json(obj_Dictionary_DubLang);
            //}
            //else
            //{
            IEnumerable<RightsU_Entities.Language> lstLanguage = null;
            string[] arrLanguageCode = platformcodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).ToList();

            var tempLanguageList_Dub = string.Join(",", lstLanguage.Select(x => x.Language_Name.ToString()).ToArray());
            List<SelectListItem> ListLanguageDetails_Dub = new SelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrLanguageCode.Contains(s.Language_Code.ToString())).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }), "Value", "Text").ToList();
            obj_Dictionary_DubLang.Add("lstListLanguageDetails_Dub", ListLanguageDetails_Dub);
            obj_Dictionary_DubLang.Add("tempLanguageList_Dub", tempLanguageList_Dub);
            return Json(obj_Dictionary_DubLang);
            //}
            //return Json("");
        }

        public PartialViewResult AddEditLanguage_Group_Dub(string Language_Group_Code, string selectedCodes, string callFrom)
        {
            objLanguage_Group = new RightsU_Entities.Language_Group();
            objLanguage_Group_Service = null;

            string strListLanguageCodes = "";
            string strListLanguageCodes_Run = "";
            Language_Group_Code = Language_Group_Code.Replace("G", string.Empty);
            string[] strLanguage_Group_Code = Language_Group_Code.Split(',');

            if (selectedCodes == "" || selectedCodes == null)
            {
                strListLanguageCodes = "";
            }
            else
            {
                strListLanguageCodes = selectedCodes;
            }
            strListLanguageCodes = string.Join(",", new Language_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => strLanguage_Group_Code.Contains(x.Language_Group_Code.ToString())).ToList().Select(x => Convert.ToString(x.Language_Code)).Distinct());
            strListLanguageCodes_Run = strListLanguageCodes;


            //if (Language_Group_Code > 0)
            //{
            //    objLanguage_Group = objLanguage_Group_Service.GetById(Language_Group_Code);
            //    //int?[] strListLanguageCodes;
            //    strListLanguageCodes = string.Join(",", new Language_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Language_Group_Code == Language_Group_Code).ToList().Select(x => Convert.ToString(x.Language_Code)));
            //    strListLanguageCodes_Run = strListLanguageCodes;
            //}


            //List<RightsU_Entities.Language> lstLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Language_Name).ToList();
            //var languageCode = objLanguage_Group.Language_Group_Details.Select(s => s.Language_Code).ToArray();
            //ViewBag.LanguageList = new MultiSelectList(lstLanguage, "Language_Code", "Language_Name", languageCode);

            if (callFrom == "runQuery")
            {
                return BindLanguageTreeView_Dub(selectedCodes, "LG", callFrom, Language_Group_Code, strListLanguageCodes_Run, selectedCodes);
            }
            return BindLanguageTreeView_Dub(strListLanguageCodes, "LG", callFrom, Language_Group_Code, strListLanguageCodes_Run, selectedCodes);
        }

        public PartialViewResult BindLanguageTreeView_Dub(string strListLanguageCodes, string bindType = "", string callFrom = "", string Language_Group_Code = "0", string strListLanguageCodes_Run = "", string strSelected = "")
        {
            string Avail_All_Language_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Language").ToList().FirstOrDefault().Parameter_Value;
            Avail_All_Language_Code = Avail_All_Language_Code.Insert(0, "G");
            if (strListLanguageCodes == null)
            {
                strListLanguageCodes = "";
            }
            string strTreeId = "Rights_Platform", strTreeValueId = "hdnTVCodes";
            if (bindType == "LG")
            {
                strTreeId = strTreeId + "_DubLang_G";
                strTreeValueId = strTreeValueId + "_DubLang_G";
            }
            else if (bindType == "MH")
            {
                strTreeId = strTreeId + "DubLang_M";
                strTreeValueId = strTreeValueId + "_DubLang_M";
            }

            else if (bindType == "EM")
            {
                strTreeId = strTreeId + "_DubLang_E";
                strTreeValueId = strTreeValueId + "_DubLang_E";
            }

            Language_Tree_View objPTV = new Language_Tree_View(objLoginEntity.ConnectionStringName);
            if (Language_Group_Code == Avail_All_Language_Code && callFrom == "runQuery" && strSelected == "")
                objPTV.LanguageCodes_Selected = "".Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            else if (Language_Group_Code == Avail_All_Language_Code && callFrom == "runQuery" && strSelected != "")
                objPTV.LanguageCodes_Selected = strSelected.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            else
                objPTV.LanguageCodes_Selected = strListLanguageCodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);


            objPTV.Show_Selected = true;
            if (callFrom == "runQuery" && Language_Group_Code == "0")
            {
                objPTV.LanguageCodes_Display = "";
            }
            else if (callFrom == "runQuery" && Language_Group_Code != "0")
            {
                objPTV.LanguageCodes_Display = strListLanguageCodes_Run;
            }
            else
            {
                objPTV.LanguageCodes_Display = strListLanguageCodes;
            }



            if (bindType == "EM")
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            else
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");

            ViewBag.TreeId = strTreeId;
            ViewBag.TreeValueId = strTreeValueId;
            return PartialView("_TV_Platform");
        }

        #endregion

        #region----------------Other Criteria------------------------

        public PartialViewResult BindOther()
        {
            Title_Service titleService = new Title_Service(objLoginEntity.ConnectionStringName);
            List<int> lstTitleLanguageCode = titleService.SearchFor(t => t.Title_Language_Code != null).Select(t => t.Title_Language_Code.Value).Distinct().ToList();
            Language_Service langServiceInstance = new Language_Service(objLoginEntity.ConnectionStringName);
            //var langList = langServiceInstance.SearchFor(l => l.Is_Active == "Y" && lstTitleLanguageCode.Contains(l.Language_Code)).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }).ToList();
            List<SelectListItem> langList = new SelectList(langServiceInstance.SearchFor(l => l.Is_Active == "Y" && lstTitleLanguageCode.Contains(l.Language_Code)).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }), "Value", "Text").ToList();
            ViewBag.langList = langList;

            Sub_License_Service subLicenseServiceInstance = new Sub_License_Service(objLoginEntity.ConnectionStringName);
            //var sublicList = subLicenseServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Sub_License_Name, Value = l.Sub_License_Code.ToString() }).ToList();
            List<SelectListItem> sublicList = new SelectList(subLicenseServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Sub_License_Name, Value = l.Sub_License_Code.ToString() }), "Value", "Text").ToList();
            ViewBag.sublicList = sublicList;

            List<SelectListItem> ddlExclusive = new List<SelectListItem>();
            //ddlExclusive.Add(new SelectListItem { Text = "Both", Value = "B" });
            ddlExclusive.Add(new SelectListItem { Text = "Exclusive", Value = "E" });
            ddlExclusive.Add(new SelectListItem { Text = "Non Exclusive", Value = "N" });
            //  ddlExclusive.Add(new SelectListItem { Text = "Co - Exclusive", Value = "C" });
            ViewBag.ddlExclusive = ddlExclusive;

            var Is_Restriction_Remarks = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Is_Restriction_Remarks").ToList().FirstOrDefault().Parameter_Value;
            if (Is_Restriction_Remarks == "Y")
            {

            }

            ViewBag.Is_Restriction_Remarks = Is_Restriction_Remarks;

            var Is_Digital = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Digital_Avail").ToList().FirstOrDefault().Parameter_Value;
            if (Is_Digital == "Y")
                ViewBag.chkDigital = true;
            else
                ViewBag.chkDigital = false;

            ViewBag.Is_Self_Consumption = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Is_Self_Consumption").ToList().FirstOrDefault().Parameter_Value;
            string Is_Include_Metadata = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Is_Include_Metadata_Avail").ToList().FirstOrDefault().Parameter_Value;
            ViewBag.Is_Other_Remarks = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Is_Include_Other_Remarks_Avail").ToList().FirstOrDefault().Parameter_Value;
            if (Is_Include_Metadata == "Y")
                ViewBag.chkIncludeMetadata = true;
            else
                ViewBag.chkIncludeMetadata = false;
            if (ViewBag.Is_Other_Remarks == "Y")
                ViewBag.Is_Other_Remarks = true;
            else
                ViewBag.Is_Other_Remarks = false;
            ViewBag.ModuleCode = module;

            return PartialView("~/Views/Availability_Movie_New/_OtherCriteria.cshtml");
        }

        #endregion

        #region------------Platform Critera------------------

        public PartialViewResult BindPlatform(int Platform_Group_Code)
        {
            string Avail_All_Platform_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Platform").ToList().FirstOrDefault().Parameter_Value;

            objPlatform_Group = new RightsU_Entities.Platform_Group(); ;
            objPlatform_Group_Service = null;

            if (Platform_Group_Code > 0)
                objPlatform_Group = objPlatform_Group_Service.GetById(Platform_Group_Code);

            string strPlatform_Code = string.Join(",", new Platform_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Platform_Group_Code == Platform_Group_Code).ToList().Select(x => Convert.ToString(x.Platform_Code)));

            //   objPlatform_Group.Is_Thetrical = (objPlatform_Group.Is_Thetrical ?? "N");
            List<RightsU_Entities.Platform> lstPlatforms = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Platform_Code).ToList();
            var platformCode = objPlatform_Group.Platform_Group_Details.Select(s => s.Platform_Code).ToArray();
            ViewBag.PlatformList = new MultiSelectList(lstPlatforms, "Platform_Code", "Platform_Name", platformCode);

            ViewBag.strPlatformCode = strPlatform_Code;


            List<SelectListItem> ddlPlatformGroup = new SelectList(new Platform_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Platform_Group_Code != 0 && p.Is_Active == "Y").Select(R => new { Platform_Group_Value = R.Platform_Group_Code, Platform_Group_Name = R.Platform_Group_Name }), "Platform_Group_Value", "Platform_Group_Name", Avail_All_Platform_Code).Distinct().ToList();
            //ddlPlatformGroup.Insert(0, new SelectListItem() { Value = Avail_All_Platform_Code, Text = "All Platforms" });
            ViewBag.ddlPlatformGroup = ddlPlatformGroup;
            Session["ddlPlatformGroup"] = ddlPlatformGroup;
            ViewBag.Avail_All_Platform_Code = Avail_All_Platform_Code;
            return PartialView("~/Views/Availability_Movie_New/_PlatformCriteria.cshtml");
        }



        public PartialViewResult BindPlatformTreeView(string strPlatform, int BU_Code, string bindType = "", string isRunQuery = "", string Platform_Group_Code = "0", string strSelected = "")
        {
            string Is_Sports_Right = "N";
            string Avail_All_Platform_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Platform").ToList().FirstOrDefault().Parameter_Value;
            string strTreeId = "Rights_Platform", strTreeValueId = "hdnTVCodes";
            string BUName = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Business_Unit_Code == BU_Code).Select(w => w.Business_Unit_Name).FirstOrDefault();
            if (!string.IsNullOrEmpty(BUName))
            {
                if (BUName.ToUpper() == "SPORTS")
                    Is_Sports_Right = "Y";
            }


            if (bindType == "PG")
            {
                strTreeId = strTreeId + "_G";
                strTreeValueId = strTreeValueId + "_G";
            }
            else if (bindType == "MH")
            {
                strTreeId = strTreeId + "_M";
                strTreeValueId = strTreeValueId + "_M";
            }

            else if (bindType == "EM")
            {
                strTreeId = strTreeId + "_E";
                strTreeValueId = strTreeValueId + "_E";
            }
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            //objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //objPTV.PlatformCodes_Display = strPlatform;
            if (Platform_Group_Code == Avail_All_Platform_Code && isRunQuery == "Y" && strSelected == "")
                objPTV.PlatformCodes_Selected = "".Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            else if (Platform_Group_Code == Avail_All_Platform_Code && isRunQuery == "Y" && strSelected != "")
                objPTV.PlatformCodes_Selected = strSelected.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            else
                objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            if (strPlatform == "")
                objPTV.Is_Avail = "Y";
            objPTV.Show_Selected = true;

            if (isRunQuery == "Y" && Platform_Group_Code == "0")
            {
                objPTV.PlatformCodes_Display = "";
            }
            else
            {
                objPTV.PlatformCodes_Display = strPlatform;
            }

            if (bindType == "EM")
            {
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y", Is_Sports_Right);
            }
            else
            {
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N", Is_Sports_Right);
            }
            ViewBag.TreeId = strTreeId;
            ViewBag.TreeValueId = strTreeValueId;
            return PartialView("_TV_Platform");
        }

        public PartialViewResult AddEditPlatform_Group(string Platform_Group_Code, string selectedCodes, string isRunQuery, int BU_Code)
        {
            // TempData.Remove("strPlatformCode");
            string[] strPlatform_Group_Code = Platform_Group_Code.Split(',');

            objPlatform_Group = new RightsU_Entities.Platform_Group(); ;
            objPlatform_Group_Service = null;
            string strPlatform_Code = "";

            if (selectedCodes == "" || selectedCodes == null)
            {
                strPlatform_Code = "";
            }
            else
            {
                strPlatform_Code = selectedCodes;
            }

            strPlatform_Code = string.Join(",", new Platform_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => strPlatform_Group_Code.Contains(x.Platform_Group_Code.ToString())).ToList().Select(x => Convert.ToString(x.Platform_Code)).Distinct());

            //if (Platform_Group_Code > 0)
            //{
            //    objPlatform_Group = objPlatform_Group_Service.GetById(Platform_Group_Code);

            //    strPlatform_Code = string.Join(",", new Platform_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Platform_Group_Code == Platform_Group_Code).ToList().Select(x => Convert.ToString(x.Platform_Code)));
            //}

            ////   objPlatform_Group.Is_Thetrical = (objPlatform_Group.Is_Thetrical ?? "N");
            //List<RightsU_Entities.Platform> lstPlatforms = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Platform_Code).ToList();
            //var platformCode = objPlatform_Group.Platform_Group_Details.Select(s => s.Platform_Code).ToArray();
            //ViewBag.PlatformList = new MultiSelectList(lstPlatforms, "Platform_Code", "Platform_Name", platformCode);

            ViewBag.strPlatformCode = strPlatform_Code;
            return BindPlatformTreeView(strPlatform_Code, BU_Code, "PG", isRunQuery, Platform_Group_Code, selectedCodes);
            //return PartialView("~/Views/Availability_Movie/_PlatformCriteria.cshtml", objPlatform_Group);
        }

        #endregion
        #region------------Self Utilization Critera------------------

        public PartialViewResult BindPromoter()
        {
            return PartialView("~/Views/Availability_Movie_New/_SelfUtilizationCriteria.cshtml");
        }



        public PartialViewResult BindPromoterTreeView(string strPlatform, string bindType = "", string isRunQuery = "", string Platform_Group_Code = "0", string strSelected = "")
        {
            string strTreeId = "Rights_Promoter", strTreeValueId = "hdnTVCodes_Promoter";
            bool RightForShowAllSelfUtilizationPlatform = false;
            RightForShowAllSelfUtilizationPlatform = GetUserModuleRights().Contains(GlobalParams.RightCodeForShowAllSelfUtilizationPlatform.ToString());
            string[] DefaultSelfUtilizationCode = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Default_SelfUtilization_Avail_Codes").Select(s => s.Parameter_Value).FirstOrDefault().Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            if (bindType == "PG")
            {
                strTreeId = strTreeId + "_G";
                strTreeValueId = strTreeValueId + "_G";
            }
            else if (bindType == "MH")
            {
                strTreeId = strTreeId + "_M";
                strTreeValueId = strTreeValueId + "_M";
            }

            else if (bindType == "EM")
            {
                strTreeId = strTreeId + "_E";
                strTreeValueId = strTreeValueId + "_E";
            }
            Promoter_Group_Tree_View objPTV = new Promoter_Group_Tree_View(objLoginEntity.ConnectionStringName);
            objPTV.Promoter_GroupCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //if (strPlatform == "")
            //    objPTV.Is_Avail = "Y";
            objPTV.Show_Selected = true;
            if (bindType == "PG")
            {
                if (RightForShowAllSelfUtilizationPlatform)
                    objPTV.Promoter_GroupCodes_Display = string.Join(",", new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList().Select(x => Convert.ToString(x.Promoter_Group_Code)).Distinct());
                else
                    objPTV.Promoter_GroupCodes_Display = string.Join(",", new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => DefaultSelfUtilizationCode.Contains(x.Promoter_Group_Code.ToString()) || DefaultSelfUtilizationCode.Contains(x.Parent_Group_Code.ToString())).Select(s => s.Promoter_Group_Code).Distinct());
            }
            else
                objPTV.Promoter_GroupCodes_Display = strPlatform;

            if (bindType == "EM")
            {
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            }
            else
            {
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            }
            ViewBag.TreeId = strTreeId;
            ViewBag.TreeValueId = strTreeValueId;
            return PartialView("_TV_Platform");
        }

        public PartialViewResult AddEditPromoter_Group(string Promoter_Group_Code, string selectedCodes, string isRunQuery)
        {
            // TempData.Remove("strPlatformCode");


            objPromoter_Group = new RightsU_Entities.Promoter_Group(); ;
            objPromoter_Group_Service = null;
            string strPromoter_Code = "";
            bool RightForShowAllSelfUtilizationPlatform = false;
            string[] DefaultSelfUtilizationCode = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Default_SelfUtilization_Avail_Codes").Select(s => s.Parameter_Value).FirstOrDefault().Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            RightForShowAllSelfUtilizationPlatform = GetUserModuleRights().Contains(GlobalParams.RightCodeForShowAllSelfUtilizationPlatform.ToString());
            if (selectedCodes == "" || selectedCodes == null)
            {
                if (RightForShowAllSelfUtilizationPlatform)
                    strPromoter_Code = string.Join(",", new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList().Select(x => Convert.ToString(x.Promoter_Group_Code)).Distinct());
                else
                    strPromoter_Code = string.Join(",", new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => DefaultSelfUtilizationCode.Contains(x.Promoter_Group_Code.ToString()) || DefaultSelfUtilizationCode.Contains(x.Parent_Group_Code.ToString())).Select(s => s.Promoter_Group_Code).Distinct());
            }
            else
            {
                strPromoter_Code = selectedCodes;
            }

            //strPromoter_Code = string.Join(",", new Platform_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => strPlatform_Group_Code.Contains(x.Platform_Group_Code.ToString())).ToList().Select(x => Convert.ToString(x.Platform_Code)).Distinct());

            //if (Platform_Group_Code > 0)
            //{
            //    objPlatform_Group = objPlatform_Group_Service.GetById(Platform_Group_Code);

            //    strPlatform_Code = string.Join(",", new Platform_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Platform_Group_Code == Platform_Group_Code).ToList().Select(x => Convert.ToString(x.Platform_Code)));
            //}

            ////   objPlatform_Group.Is_Thetrical = (objPlatform_Group.Is_Thetrical ?? "N");
            //List<RightsU_Entities.Platform> lstPlatforms = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Platform_Code).ToList();
            //var platformCode = objPlatform_Group.Platform_Group_Details.Select(s => s.Platform_Code).ToArray();
            //ViewBag.PlatformList = new MultiSelectList(lstPlatforms, "Platform_Code", "Platform_Name", platformCode);

            ViewBag.strPlatformCode = strPromoter_Code;
            return BindPromoterTreeView(strPromoter_Code, "PG", isRunQuery, Promoter_Group_Code, selectedCodes);
            //return PartialView("~/Views/Availability_Movie/_PlatformCriteria.cshtml", objPlatform_Group);
        }

        #endregion

        #region------------Report Function------------------
        public PartialViewResult BindSelectedResult(string[] titleCodes, string[] platformCodes, string Country_Code,
        string isOriginalLang, string rblPeriodType, string Dubbing_Subtitling,
        string[] Title_Language_Code, string ExcactMatch_Platform, string[] Exclusivity,
        string[] sublicList, string chkExactMatch, string[] ddlMustHaveCountry,
        string[] ddlListCountry, string[] Subtitling_Codes, string[] Dubbing_Codes,
        int BU_Code, string chkDigital, string chkRestRemarks,
        string chkOtherRemarks, string[] MustHave_Platform_Codes, string chkMetaData,
        string chkIFTACluster, string chkCountryLevel, string txtfrom, string txtto, string pfGroupCode, string LangGroup_Sub, string chkExactMatch_Sub,
        string[] MustHave_Subtitle_Codes, string[] ddlListLanguageGroup, string LangGroup_Dub, string chkExactMatch_Dub, string[] MustHave_Dubbing_Codes,
        string[] ddlListLanguageGroup_Dub, string Territory_Code, int episodeFrom, int episodeTo, string tabName, string IncludeAncillary, string[] promoterCodes,
        string ExcactMatch_Promoter, string[] MustHave_Promoter_Codes)
        {
            string strPlatformCodes = ""; string strMustHave_Subtitle_Codes = "", Sub_Exclusion_Codes = "", strMustHave_Dubbing_Codes = "",
                Dub_Exclusion_Codes = "", Subtit_Language_Code = "", Dubbing_Language_Code = "", MustHave_Platform = "", Date_Type = "", strPromoterCodes = "", MustHave_Promoter = "";

            string strTitleCodes = string.Join(",", titleCodes);
            string BUName = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Business_Unit_Code == BU_Code).Select(w => w.Business_Unit_Name).FirstOrDefault();
            string IsExclusivity = string.Join(",", Exclusivity);
            if (module != GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strPlatformCodes = string.Join(",", platformCodes);
                if (!string.IsNullOrEmpty(BUName))
                {

                    if (BUName.ToUpper() == "SPORTS")
                    {
                        PlatformBroadcastCodes = "";
                        PlatformBroadcastCodes = string.Join(",", platformCodes);
                        string[] SelectedPlatformCode = strPlatformCodes.Split(',').ToArray();
                        strPlatformCodes = "";
                        strPlatformCodes = String.Join(",", new Platform_Broadcast_Service(objLoginEntity.ConnectionStringName).SearchFor(s => SelectedPlatformCode.Contains(s.Platform_Broadcast_Code.ToString())).Select(w => w.Platform_Code).Distinct());
                    }

                }
                strPromoterCodes = string.Join(",", promoterCodes);
            }
            if (rblPeriodType == "MI")
                Date_Type = "Minimum";
            else if (rblPeriodType == "FI")
                Date_Type = "Fixed";
            else
                Date_Type = "Flexi";

            string Title_Language_Codes = string.Join(",", Title_Language_Code);
            string SubLicense_Code = string.Join(",", sublicList);
            string Region_MustHave_Codes = string.Join(",", ddlMustHaveCountry);
            string Region_Exclusion_Codes = string.Join(",", ddlListCountry);
            if (module != GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strMustHave_Subtitle_Codes = string.Join(",", MustHave_Subtitle_Codes);
                Sub_Exclusion_Codes = string.Join(",", ddlListLanguageGroup);
                strMustHave_Dubbing_Codes = string.Join(",", MustHave_Dubbing_Codes);
                Dub_Exclusion_Codes = string.Join(",", ddlListLanguageGroup_Dub);
                Subtit_Language_Code = string.Join(",", Subtitling_Codes[0].Split(','));
                Dubbing_Language_Code = string.Join(",", Dubbing_Codes[0].Split(','));
                MustHave_Platform = string.Join(",", MustHave_Platform_Codes);
                MustHave_Promoter = string.Join(",", MustHave_Promoter_Codes);
            }
            string startDate = Convert.ToDateTime(txtfrom).ToString("dd-MM-yyyy");
            string endDate = "";
            if (txtto == "")
            {
                endDate = "";
            }
            else
            {
                endDate = Convert.ToDateTime(txtto).ToString("dd-MM-yyyy");
            }
            //if (ContryLevelRights && tabName == "CO")
            //{
            //    Territory_Code = "0";
            //}
            if (strPlatformCodes == "")
                pfGroupCode = "0";
            if (Subtit_Language_Code == "")
                LangGroup_Sub = "0";
            if (Dubbing_Language_Code == "")
                LangGroup_Dub = "0";

            RightsU_Entities.USP_Get_Title_Availability_LanguageWise_Filter_Result objGTALF = new USP_Get_Title_Availability_LanguageWise_Filter_Result();
            if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                objGTALF = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_Availability_LanguageWise_Filter(strTitleCodes,
                strPlatformCodes, Country_Code, Subtit_Language_Code, Dubbing_Language_Code, MustHave_Platform, Dubbing_Subtitling, Region_MustHave_Codes, Region_Exclusion_Codes, Title_Language_Codes,
                4, chkIFTACluster, LangGroup_Sub, strMustHave_Subtitle_Codes, Sub_Exclusion_Codes, LangGroup_Dub, strMustHave_Dubbing_Codes, Dub_Exclusion_Codes, pfGroupCode, MustHave_Platform,
               Territory_Code, BU_Code.ToString(), SubLicense_Code, chkRestRemarks, chkOtherRemarks, chkMetaData, chkDigital.ToString(), IsExclusivity, "", "").FirstOrDefault();

            }
            else
            {
                objGTALF = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_Availability_LanguageWise_Filter(strTitleCodes,
                    strPlatformCodes, Country_Code, Subtit_Language_Code, Dubbing_Language_Code, MustHave_Platform, Dubbing_Subtitling, Region_MustHave_Codes, Region_Exclusion_Codes, Title_Language_Codes,
                    3, chkIFTACluster, LangGroup_Sub, strMustHave_Subtitle_Codes, Sub_Exclusion_Codes, LangGroup_Dub, strMustHave_Dubbing_Codes, Dub_Exclusion_Codes, pfGroupCode, MustHave_Platform,
                   Territory_Code, BU_Code.ToString(), SubLicense_Code, chkRestRemarks, chkOtherRemarks, chkMetaData, chkDigital.ToString(), IsExclusivity, strPromoterCodes, MustHave_Promoter).FirstOrDefault();
            }

            Session["objGTALF"] = objGTALF;

            ViewBag.DateType = Date_Type;
            ViewBag.Start_Date = GlobalUtil.MakedateFormat(startDate);
            ViewBag.End_Date = GlobalUtil.MakedateFormat(endDate);
            if (chkExactMatch == "EM")
                ViewBag.RegionExact_Match = "Yes";
            else
                ViewBag.RegionExact_Match = "No";
            if (ExcactMatch_Platform == "EM")
                ViewBag.PlatformExact_Match = "Yes";
            else
                ViewBag.PlatformExact_Match = "No";
            if (chkExactMatch_Sub == "EM")
                ViewBag.SubtitleExact_Match = "Yes";
            else
                ViewBag.SubtitleExact_Match = "No";
            if (chkExactMatch_Dub == "EM")
                ViewBag.DubbingExact_Match = "Yes";
            else
                ViewBag.DubbingExact_Match = "No";
            if (isOriginalLang.ToUpper() == "TRUE")
                ViewBag.ISOriginalLang = "Y";
            else
                ViewBag.ISOriginalLang = "N";
            if (ExcactMatch_Promoter == "EM")
                ViewBag.PromoterExact_Match = "Yes";
            else
                ViewBag.PromoterExact_Match = "No";

            string[] IndividualBroadcastCode = PlatformBroadcastCodes.Split(',').ToArray();
            int IndividualSportsCodeCount = new Platform_Broadcast_Service(objLoginEntity.ConnectionStringName).SearchFor(s => IndividualBroadcastCode.Contains(s.Platform_Broadcast_Code.ToString())).Select(w => w.Broadcast_Mode_Code).Count();
            string[] IndividualPlatformCodes = strPlatformCodes.Split(',').ToArray();
            int IndividualPlatformCount = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => IndividualPlatformCodes.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Name).Count();
            if (!string.IsNullOrEmpty(BUName))
            {
                if (BUName.ToUpper() == "SPORTS")
                {
                    ViewBag.PlatformCount = IndividualSportsCodeCount;
                }
            }
            else
            {
                ViewBag.PlatformCount = IndividualPlatformCount;
            }
            string[] MustHavePlatformCodes = MustHave_Platform.Split(',').ToArray();
            int MustHavePlatformCount = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => MustHavePlatformCodes.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Name).Count();
            ViewBag.MustHavePlatformCount = MustHavePlatformCount;

            string[] IndividualPromoterCodes = strPromoterCodes.Split(',').ToArray();
            int IndividualPromoterCount = new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => IndividualPromoterCodes.Contains(w.Promoter_Group_Code.ToString())).Select(s => s.Promoter_Group_Name).Count();
            ViewBag.PromoterCount = IndividualPromoterCount;
            string[] MustHavePromoterCodes = MustHave_Promoter.Split(',').ToArray();
            int MustHavePromoterCount = new Promoter_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(w => MustHavePromoterCodes.Contains(w.Promoter_Group_Code.ToString())).Select(s => s.Promoter_Group_Name).Count();
            ViewBag.MustHavePromoterCount = MustHavePromoterCount;

            ViewBag.Code = module;
            PlatformCodes = strPlatformCodes;
            MustHave_PlatformCodes = MustHave_Platform;
            ViewBag.IsIftaCluster = chkIFTACluster;
            ViewBag.IsCountryLevel = ContryLevelRights;
            ViewBag.EpisodeFrom = episodeFrom;
            ViewBag.EpisodeTo = episodeTo;

            PromoterCodes = strPromoterCodes;
            MustHave_PromoterCodes = MustHave_Promoter;
            if (IncludeAncillary == "Y")
                ViewBag.IncludeAncillary = "Yes";
            else
                ViewBag.IncludeAncillary = "No";
            ViewBag.Is_Self_Consumption = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Is_Self_Consumption").ToList().FirstOrDefault().Parameter_Value;
            return PartialView("~/Views/Availability_Movie_New/_SelectedCriteriaList.cshtml", objGTALF);
        }
        public PartialViewResult BindPlatformTreePopup(string callfrom, int BU_Code)
        {
            string Is_Sport_right = "N";
            string BUName = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Business_Unit_Code == BU_Code).Select(w => w.Business_Unit_Name).FirstOrDefault();
            if (!string.IsNullOrEmpty(BUName))
            {
                if (BUName.ToUpper() == "SPORTS")
                    Is_Sport_right = "Y";
            }

            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            if (callfrom == "I")
            {
                objPTV.PlatformCodes_Display = PlatformCodes;
                objPTV.PlatformCodes_Selected = PlatformCodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            else
            {
                objPTV.PlatformCodes_Display = MustHave_PlatformCodes;
                objPTV.PlatformCodes_Selected = MustHave_PlatformCodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            objPTV.Show_Selected = true;
            //ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y", Is_Sport_right);
            //, PlatformBroadcastCodes
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y", Is_Sport_right, PlatformBroadcastCodes);
            ViewBag.TreeId = "Rights_List_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }
        public PartialViewResult BindPromoterTreePopup(string callfrom)
        {

            Promoter_Group_Tree_View objPTV = new Promoter_Group_Tree_View(objLoginEntity.ConnectionStringName);
            if (callfrom == "I")
            {
                objPTV.Promoter_GroupCodes_Display = PromoterCodes;
                objPTV.Promoter_GroupCodes_Selected = PromoterCodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            else
            {
                objPTV.Promoter_GroupCodes_Display = MustHave_PromoterCodes;
                objPTV.Promoter_GroupCodes_Selected = MustHave_PromoterCodes.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            objPTV.Show_Selected = true;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            ViewBag.TreeId = "Rights_List_Promoter";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }

        public ActionResult DownloadAvailsReport()
        {
            if (Session["AvailsReportFilePath"] != null)
            {
                try
                {
                    byte[] fileBytes = System.IO.File.ReadAllBytes(Session["AvailsReportFilePath"].ToString());
                    string fileName = "AvailsReport.xlsx";
                    return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
                }
                catch (Exception ex)
                {

                    throw;
                }
            }
            //if (Session["AvailsReport"] != null)
            //{
            //    return new DownloadFileActionResult((GridView)Session["AvailsReport"], "AvailsReport.xls");
            //}
            else
            {
                //Some kind of a result that will indicate that the view has 
                //not been created yet. I would use a Javascript message to do so. 
                return new EmptyResult();
            }
        }

        public PartialViewResult BindAvailReport(string[] titleCodes, string[] platformCodes, string Country_Code,
            string isOriginalLang, string rblPeriodType, string Dubbing_Subtitling,
            string[] Title_Language_Code, string ExcactMatch_Platform, string[] Exclusivity,
            string[] sublicList, string chkExactMatch, string[] ddlMustHaveCountry,
            string[] ddlListCountry, string[] Subtitling_Codes, string[] Dubbing_Codes,
            int BU_Code, string chkDigital, string chkRestRemarks,
            string chkOtherRemarks, string[] MustHave_Platform_Codes, string chkMetaData,
            string chkIFTACluster, string txtfrom, string txtto, string pfGroupCode, string LangGroup_Sub, string chkExactMatch_Sub,
            string[] MustHave_Subtitle_Codes, string[] ddlListLanguageGroup, string LangGroup_Dub, string chkExactMatch_Dub, string[] MustHave_Dubbing_Codes,
            string[] ddlListLanguageGroup_Dub, string Territory_Code, int episodeFrom, int episodeTo, string tabName, string IncludeAncillary, string[] PromoterCodes,
            string ExcactMatch_Promoter, string[] MustHave_Promoter_Codes)
        {
            string strPlatformCodes = ""; string strMustHave_Subtitle_Codes = "", Sub_Exclusion_Codes = "", strMustHave_Dubbing_Codes = "",
                Dub_Exclusion_Codes = "", Subtit_Language_Code = "", Dubbing_Language_Code = "", MustHave_Platform = "", strPromoterCodes = "", MustHave_Promoter = "";
            string strTitleCodes = string.Join(",", titleCodes);
            string chkCountryLevel = "N", chkTerritoryLevel = "N";
            if (module != GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strPlatformCodes = string.Join(",", platformCodes);
                strPromoterCodes = string.Join(",", PromoterCodes);
            }
            ViewBag.Code = module;
            string Availability_Ifta_And_Ancillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Availability_Ifta_And_Ancillary").ToList().FirstOrDefault().Parameter_Value;
            string Title_Language_Codes = string.Join(",", Title_Language_Code);
            string SubLicense_Code = string.Join(",", sublicList);
            string Region_MustHave_Codes = string.Join(",", ddlMustHaveCountry);
            string Region_Exclusion_Codes = string.Join(",", ddlListCountry);
            string IsExclusivity = string.Join(",", Exclusivity);
            if (module != GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strMustHave_Subtitle_Codes = string.Join(",", MustHave_Subtitle_Codes);
                Sub_Exclusion_Codes = string.Join(",", ddlListLanguageGroup);
                strMustHave_Dubbing_Codes = string.Join(",", MustHave_Dubbing_Codes);
                Dub_Exclusion_Codes = string.Join(",", ddlListLanguageGroup_Dub);
                Subtit_Language_Code = string.Join(",", Subtitling_Codes[0].Split(','));
                Dubbing_Language_Code = string.Join(",", Dubbing_Codes[0].Split(','));
                MustHave_Platform = string.Join(",", MustHave_Platform_Codes);
                MustHave_Promoter = string.Join(",", MustHave_Promoter_Codes);
            }
            string startDate = Convert.ToDateTime(txtfrom).ToString("yyyy-MM-dd");
            string endDate = "";
            if (txtto == "")
            {
                endDate = "";
            }
            else
            {
                endDate = Convert.ToDateTime(txtto).ToString("yyyy-MM-dd");
            }
            if (ContryLevelRights && tabName == "CO")
            {
                Territory_Code = "0";
                chkCountryLevel = "Y";
            }
            if (TerritoryLevelRights)
            {
                chkTerritoryLevel = "Y";
            }
            if (ContryLevelRights == true && TerritoryLevelRights == true && Country_Code == "")
            {
                tabName = "CO";
                Territory_Code = "0";
                chkCountryLevel = "Y";
            }
            //strTitleCodes = "11905";

            int noOfParam = 0;
            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString())
            {
                if (Availability_Ifta_And_Ancillary == "N")
                    noOfParam = 37;
                else
                    noOfParam = 41;
            }
            else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString())
            {
                if (Availability_Ifta_And_Ancillary == "N")
                    noOfParam = 38;
                else
                    noOfParam = 42;
            }
            else if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
            {
                noOfParam = 37;
            }
            else if (module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {
                noOfParam = 38;
            }
            else if (module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
            {
                noOfParam = 41;
            }
            else if (module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                noOfParam = 39;
            }
            else
            {
                noOfParam = 26;
            }
            if (tabName == "check" || tabName == "UnCheck")
            {
                TabName = "IF";
                tabName = "IF";
            }
            TabName = tabName;
            ReportParameter[] parm = new ReportParameter[noOfParam];
            if (module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                parm[0] = new ReportParameter("Title_Code", strTitleCodes);
                parm[1] = new ReportParameter("Is_Original_Language", isOriginalLang);
                parm[2] = new ReportParameter("Title_Language_Code", Title_Language_Codes);
                parm[3] = new ReportParameter("Date_Type", rblPeriodType);
                parm[4] = new ReportParameter("Start_Date", startDate);
                parm[5] = new ReportParameter("End_Date", endDate);

                parm[6] = new ReportParameter("Platform_Group_Code", pfGroupCode);
                parm[7] = new ReportParameter("Platform_Code", strPlatformCodes);
                parm[8] = new ReportParameter("Platform_ExactMatch", ExcactMatch_Platform);
                parm[9] = new ReportParameter("Platform_MustHave", MustHave_Platform);

                parm[10] = new ReportParameter("Is_IFTA_Cluster", chkIFTACluster);
                parm[11] = new ReportParameter("Territory_Code", Territory_Code);
                parm[12] = new ReportParameter("Country_Code", Country_Code);
                parm[13] = new ReportParameter("Region_ExactMatch", chkExactMatch);
                parm[14] = new ReportParameter("Region_MustHave", Region_MustHave_Codes);
                parm[15] = new ReportParameter("Region_Exclusion", Region_Exclusion_Codes);

                parm[16] = new ReportParameter("Dubbing_Subtitling", Dubbing_Subtitling);
                parm[17] = new ReportParameter("Subtit_Language_Code", Subtit_Language_Code);
                parm[18] = new ReportParameter("Subtitling_Group_Code", LangGroup_Sub);
                parm[19] = new ReportParameter("Subtitling_ExactMatch", chkExactMatch_Sub);
                parm[20] = new ReportParameter("Subtitling_MustHave", strMustHave_Subtitle_Codes);
                parm[21] = new ReportParameter("Subtitling_Exclusion", Sub_Exclusion_Codes);

                parm[22] = new ReportParameter("Dubbing_Group_Code", LangGroup_Dub);
                parm[23] = new ReportParameter("Dubbing_ExactMatch", chkExactMatch_Dub);
                parm[24] = new ReportParameter("Dubbing_MustHave", strMustHave_Dubbing_Codes);
                parm[25] = new ReportParameter("Dubbing_Exclusion", Dub_Exclusion_Codes);
                parm[26] = new ReportParameter("Dubbing_Language_Code", Dubbing_Language_Code);

                parm[27] = new ReportParameter("Restriction_Remarks", chkRestRemarks);
                parm[28] = new ReportParameter("Others_Remarks", chkOtherRemarks);
                parm[29] = new ReportParameter("Exclusivity", IsExclusivity);

                parm[30] = new ReportParameter("SubLicense_Code", SubLicense_Code);
                parm[31] = new ReportParameter("BU_Code", BU_Code.ToString());
                parm[32] = new ReportParameter("Country_Level", chkCountryLevel);
                parm[33] = new ReportParameter("Territory_Level", chkTerritoryLevel);
                parm[34] = new ReportParameter("TabName", tabName);

                parm[35] = new ReportParameter("Promoter_Groups", strPromoterCodes);
                parm[36] = new ReportParameter("Promoter_ExactMatch", ExcactMatch_Promoter);
                parm[37] = new ReportParameter("Promoter_MustHave", MustHave_Promoter);
                parm[38] = new ReportParameter("Episode_From", episodeFrom.ToString());
                parm[39] = new ReportParameter("Episode_To", episodeTo.ToString());
                parm[40] = new ReportParameter("Show_EpisodeWise", "N");
                //parm[11] = new ReportParameter("Created_By", objLoginUser.First_Name + " " + objLoginUser.Last_Name);




                //if (module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
                //{
                //    //parm[35] = new ReportParameter("Include_Ancillary", IncludeAncillary);
                //    parm[36] = new ReportParameter("Promoter_Code", strPromoterCodes);
                //    parm[37] = new ReportParameter("Promoter_ExactMatch", ExcactMatch_Promoter);
                //    parm[38] = new ReportParameter("Promoter_MustHave", MustHave_Promoter);
                //}
                //if (module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
                //{

                //}
            }
            else
            {
                if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())

                {
                    parm[0] = new ReportParameter("Title_Code", strTitleCodes);
                    parm[1] = new ReportParameter("Country_Code", Country_Code);
                    parm[2] = new ReportParameter("Title_Language_Code", Title_Language_Codes);
                    parm[3] = new ReportParameter("Date_Type", rblPeriodType);

                    parm[4] = new ReportParameter("StartDate", GlobalUtil.MakedateFormat(startDate));
                    parm[5] = new ReportParameter("EndDate", GlobalUtil.MakedateFormat(endDate));
                    parm[6] = new ReportParameter("RestrictionRemarks", chkRestRemarks);
                    parm[7] = new ReportParameter("OthersRemarks", chkOtherRemarks);
                    parm[8] = new ReportParameter("Exclusivity", IsExclusivity);
                    parm[9] = new ReportParameter("SubLicense_Code", SubLicense_Code);
                    parm[10] = new ReportParameter("Region_ExactMatch", (chkExactMatch == "") ? "False" : chkExactMatch);
                    parm[11] = new ReportParameter("Region_MustHave", Region_MustHave_Codes);
                    parm[12] = new ReportParameter("Region_Exclusion", Region_Exclusion_Codes);
                    parm[13] = new ReportParameter("BU_Code", BU_Code.ToString());
                    parm[14] = new ReportParameter("Is_Digital", "False");
                    parm[15] = new ReportParameter("Include_Metadata", chkMetaData);
                    parm[16] = new ReportParameter("Created_By", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                    parm[17] = new ReportParameter("Territory_Code", Territory_Code);
                    parm[18] = new ReportParameter("Is_IFTA_Cluster", "");
                    parm[19] = new ReportParameter("Subtitling_Group_Code", "");
                    parm[20] = new ReportParameter("Subtitling_MustHave", "");
                    parm[21] = new ReportParameter("Subtitling_Exclusion", "");
                    parm[22] = new ReportParameter("Dubbing_Group_Code", "");
                    parm[23] = new ReportParameter("Dubbing_Exclusion", "");
                    parm[24] = new ReportParameter("Dubbing_MustHave", "");
                    parm[25] = new ReportParameter("Platform_Group_Code", "");
                    //parm[26] = new ReportParameter("Episode_From", episodeFrom.ToString());
                    //parm[27] = new ReportParameter("Episode_To", episodeTo.ToString());
                    //parm[28] = new ReportParameter("Show_EpisodeWise", "N");

                }
                else
                {
                    parm[0] = new ReportParameter("Title_Code", strTitleCodes);
                    parm[1] = new ReportParameter("Platform_Code", strPlatformCodes);
                    parm[2] = new ReportParameter("Country_Code", Country_Code);
                    parm[3] = new ReportParameter("Is_Original_Language", isOriginalLang);
                    parm[4] = new ReportParameter("Dubbing_Subtitling", Dubbing_Subtitling);
                    parm[5] = new ReportParameter("Date_Type", rblPeriodType);
                    parm[6] = new ReportParameter("Title_Language_Code", Title_Language_Codes);
                    parm[7] = new ReportParameter("Platform_ExactMatch", ExcactMatch_Platform);
                    parm[8] = new ReportParameter("Exclusivity", IsExclusivity);
                    parm[9] = new ReportParameter("SubLicense_Code", SubLicense_Code);
                    parm[10] = new ReportParameter("Region_ExactMatch", chkExactMatch);
                    parm[11] = new ReportParameter("Region_MustHave", Region_MustHave_Codes);
                    parm[12] = new ReportParameter("Created_By", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                    parm[13] = new ReportParameter("Region_Exclusion", Region_Exclusion_Codes);
                    parm[14] = new ReportParameter("Subtit_Language_Code", Subtit_Language_Code);
                    parm[15] = new ReportParameter("Dubbing_Language_Code", Dubbing_Language_Code);
                    parm[16] = new ReportParameter("BU_Code", BU_Code.ToString());
                    parm[17] = new ReportParameter("Is_Digital", chkDigital.ToString());

                    if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString())
                    {
                        parm[18] = new ReportParameter("StartDate", startDate);
                        parm[19] = new ReportParameter("EndDate", endDate);
                        parm[20] = new ReportParameter("RestrictionRemarks", chkRestRemarks);
                        parm[21] = new ReportParameter("OthersRemarks", chkOtherRemarks);
                        parm[22] = new ReportParameter("MustHave_Platform", MustHave_Platform);
                    }
                    else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                    {
                        parm[18] = new ReportParameter("Start_Date", startDate);
                        parm[19] = new ReportParameter("End_Date", endDate);
                        parm[20] = new ReportParameter("Restriction_Remarks", chkRestRemarks);
                        parm[21] = new ReportParameter("Others_Remarks", chkOtherRemarks);
                        parm[22] = new ReportParameter("Platform_MustHave", MustHave_Platform);
                    }

                    parm[23] = new ReportParameter("Include_Metadata", chkMetaData);
                    parm[24] = new ReportParameter("Is_IFTA_Cluster", chkIFTACluster);
                    parm[25] = new ReportParameter("Platform_Group_Code", pfGroupCode);
                    parm[26] = new ReportParameter("Subtitling_Group_Code", LangGroup_Sub);
                    parm[27] = new ReportParameter("Subtitling_ExactMatch", chkExactMatch_Sub);
                    parm[28] = new ReportParameter("Subtitling_MustHave", strMustHave_Subtitle_Codes);
                    parm[29] = new ReportParameter("Subtitling_Exclusion", Sub_Exclusion_Codes);
                    parm[30] = new ReportParameter("Dubbing_Group_Code", LangGroup_Dub);
                    parm[31] = new ReportParameter("Dubbing_ExactMatch", chkExactMatch_Dub);
                    parm[32] = new ReportParameter("Dubbing_MustHave", strMustHave_Dubbing_Codes);
                    parm[33] = new ReportParameter("Dubbing_Exclusion", Dub_Exclusion_Codes);
                    parm[34] = new ReportParameter("Territory_Code", Territory_Code);
                    if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                    {
                        parm[35] = new ReportParameter("Episode_From", episodeFrom.ToString());
                        parm[36] = new ReportParameter("Episode_To", episodeTo.ToString());
                        parm[37] = new ReportParameter("Show_EpisodeWise", "N");
                        if (Availability_Ifta_And_Ancillary == "Y")
                        {
                            if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString())
                            {
                                parm[38] = new ReportParameter("Country_Level", chkCountryLevel);
                                parm[39] = new ReportParameter("Territory_Level", chkTerritoryLevel);
                                parm[40] = new ReportParameter("TabName", tabName);
                                parm[41] = new ReportParameter("Include_Ancillary", IncludeAncillary);
                            }
                        }
                    }

                    if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
                    {
                        parm[35] = new ReportParameter("StartMonth", "0");
                        parm[36] = new ReportParameter("EndYear", "0");
                        if (Availability_Ifta_And_Ancillary == "Y")
                        {
                            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString())
                            {
                                parm[37] = new ReportParameter("Country_Level", chkCountryLevel);
                                parm[38] = new ReportParameter("Territory_Level", chkTerritoryLevel);
                                parm[39] = new ReportParameter("TabName", tabName);
                                parm[40] = new ReportParameter("Include_Ancillary", IncludeAncillary);
                            }
                        }
                    }
                }
            }

            #region populate SearchAvailFilters
            SearchAvailFilters searchAvailFilters = new SearchAvailFilters();

            searchAvailFilters.Others = new Others();
            searchAvailFilters.Others.ModuleCode = Convert.ToInt32(module);



            LicensePeriod licensePeriod = new LicensePeriod();
            licensePeriod.LicensePeriodStartFrom = DateTime.ParseExact(startDate, "yyyy-MM-dd", null);
            if (string.IsNullOrEmpty(endDate))
            {
                licensePeriod.LicensePeriodEndTo = null;
                licensePeriod.IsPerpetualLicense = true;
            }
            else
            {
                licensePeriod.LicensePeriodEndTo = DateTime.ParseExact(endDate, "yyyy-MM-dd", null);
            }
            searchAvailFilters.LicensePeriod = licensePeriod;

            searchAvailFilters.Others.EpisodeFrom = episodeFrom;
            searchAvailFilters.Others.EpisodeTo = episodeTo;

            if (!string.IsNullOrEmpty(strTitleCodes))
                searchAvailFilters.Titles = strTitleCodes.Split(',')?.Select(Int32.Parse)?.ToList()?.Distinct()?.ToList();
            if (!string.IsNullOrEmpty(strPlatformCodes))
                searchAvailFilters.Platforms = strPlatformCodes.Split(',').Select(Int32.Parse).ToList()?.Distinct()?.ToList();

            if (!string.IsNullOrEmpty(ExcactMatch_Platform) && ExcactMatch_Platform.ToUpper() == "MH")
            {
                searchAvailFilters.Others.PlatformMustHaveExactMatch = PlatformMustHaveExactMatch.MustHave;

                if (MustHave_Platform_Codes.ToList().Count > 0)
                {
                    searchAvailFilters.PlatformsMustHave = MustHave_Platform_Codes[0].Split(',')?.Select(Int32.Parse).ToList()?.Distinct()?.ToList();
                    searchAvailFilters.PlatformsMustHave.RemoveAll(i => i == 0);
                }
            }
            else if (!string.IsNullOrEmpty(ExcactMatch_Platform) && ExcactMatch_Platform.ToUpper() == "EM")
            {
                searchAvailFilters.Others.PlatformMustHaveExactMatch = PlatformMustHaveExactMatch.ExactMatch;
            }

            if (!string.IsNullOrEmpty(Country_Code))
                searchAvailFilters.Countries = Country_Code.Split(',').Select(Int32.Parse).ToList()?.Distinct()?.ToList();
            searchAvailFilters.Others.IsTitleLanguage = Convert.ToBoolean(isOriginalLang.ToUpper());

            if (!string.IsNullOrEmpty(chkExactMatch) && chkExactMatch.ToUpper() == "MH")
            {
                searchAvailFilters.Others.CountryMustHaveExactMatch = CountryMustHaveExactMatch.MustHave;

                if (ddlMustHaveCountry.ToList().Count > 0)
                    searchAvailFilters.CountriesMustHave = ddlMustHaveCountry.Select(Int32.Parse).ToList()?.Distinct()?.ToList();
            }
            else if (!string.IsNullOrEmpty(chkExactMatch) && chkExactMatch.ToUpper() == "EM")
            {
                searchAvailFilters.Others.CountryMustHaveExactMatch = CountryMustHaveExactMatch.ExactMatch;
            }

            if (!string.IsNullOrEmpty(Title_Language_Codes))
                searchAvailFilters.Others.TitleLanguage = Title_Language_Codes.Split(',')?.Select(Int32.Parse)?.ToList()?.Distinct()?.ToList();

            if (rblPeriodType.ToUpper() == "FI")
                searchAvailFilters.TypesOfLicensePeriod = TypeOfLicensePeriod.Fixed;
            else if (rblPeriodType.ToUpper() == "MI")
                searchAvailFilters.TypesOfLicensePeriod = TypeOfLicensePeriod.Minimum;
            else
                searchAvailFilters.TypesOfLicensePeriod = TypeOfLicensePeriod.Flexi;

            //#TODO: When Countries Filter is selected and not selected need to check this
            if (!string.IsNullOrEmpty(Country_Code))
            {
                List<string> selectedExclusivity = IsExclusivity.Split(',').ToList();
                if (selectedExclusivity.Contains("E") && selectedExclusivity.Contains("N"))
                    searchAvailFilters.Others.Exclusivity = UTO.RightsU.Avails.AvailEntity.Avail.Exclusivity.Both;
                else if (selectedExclusivity.Contains("E"))
                    searchAvailFilters.Others.Exclusivity = UTO.RightsU.Avails.AvailEntity.Avail.Exclusivity.Yes;
                else
                    searchAvailFilters.Others.Exclusivity = UTO.RightsU.Avails.AvailEntity.Avail.Exclusivity.No;
            }
            else
            {
                List<string> selectedExclusivity = IsExclusivity.Split(',').ToList();
                if (selectedExclusivity.Contains("E") && selectedExclusivity.Contains("N"))
                    searchAvailFilters.Others.Exclusivity = UTO.RightsU.Avails.AvailEntity.Avail.Exclusivity.Both;
                else if (selectedExclusivity.Contains("E"))
                    searchAvailFilters.Others.Exclusivity = UTO.RightsU.Avails.AvailEntity.Avail.Exclusivity.Yes;
                else
                    searchAvailFilters.Others.Exclusivity = UTO.RightsU.Avails.AvailEntity.Avail.Exclusivity.No;
            }

            if (!string.IsNullOrEmpty(SubLicense_Code))
                searchAvailFilters.Others.SubLicensing = SubLicense_Code.Split(',').Select(Int32.Parse).ToList()?.Distinct()?.ToList();
            if (!string.IsNullOrEmpty(Subtit_Language_Code))
                searchAvailFilters.SubTitles = Subtit_Language_Code.Split(',').Select(Int32.Parse).ToList()?.Distinct()?.ToList();

            if (!string.IsNullOrEmpty(chkExactMatch_Sub) && chkExactMatch_Sub.ToUpper() == "MH")
            {
                searchAvailFilters.Others.SubtitleMustHaveExactMatch = SubtitleMustHaveExactMatch.MustHave;

                if (MustHave_Subtitle_Codes.ToList().Count > 0)
                    searchAvailFilters.SubTitlesMustHave = MustHave_Subtitle_Codes.Select(Int32.Parse).ToList()?.Distinct()?.ToList();
            }
            //else if (!string.IsNullOrEmpty(chkExactMatch_Sub) && chkExactMatch_Sub.ToUpper() == "EM")
            //{
            //    searchAvailFilters.Others.SubtitleMustHaveExactMatch = Subtitle.ExactMatch;
            //}

            if (!string.IsNullOrEmpty(Dubbing_Language_Code))
                searchAvailFilters.Dubbings = Dubbing_Language_Code.Split(',').Select(Int32.Parse).ToList()?.Distinct()?.ToList();

            if (!string.IsNullOrEmpty(chkExactMatch_Dub) && chkExactMatch_Dub.ToUpper() == "MH")
            {
                searchAvailFilters.Others.DubbingMustHaveExactMatch = DubbingMustHaveExactMatch.MustHave;

                if (MustHave_Dubbing_Codes.ToList().Count > 0)
                    searchAvailFilters.DubbingsMustHave = MustHave_Dubbing_Codes.Select(Int32.Parse).ToList()?.Distinct()?.ToList();
            }
            else if (!string.IsNullOrEmpty(chkExactMatch_Dub) && chkExactMatch_Dub.ToUpper() == "EM")
            {
                searchAvailFilters.Others.DubbingMustHaveExactMatch = DubbingMustHaveExactMatch.ExactMatch;
            }

            searchAvailFilters.Others.RestrictionRemarks = Convert.ToBoolean(chkRestRemarks.ToUpper());
            searchAvailFilters.Others.OtherRemarks = Convert.ToBoolean(chkOtherRemarks.ToUpper());
            if (chkMetaData == "Y")
            {
                searchAvailFilters.Others.IncludeMetadata = true;
                ViewBag.IncludeMetadata = true;
            }
            else
            {
                searchAvailFilters.Others.IncludeMetadata = false;
                ViewBag.IncludeMetadata = false;
            }

            if (searchAvailFilters.SubTitles != null && searchAvailFilters.SubTitles.Count > 0)
            {
                ViewBag.IncludeSubTitles = true;
            }
            else
            {
                ViewBag.IncludeSubTitles = false;
            }

            if (searchAvailFilters.Dubbings != null && searchAvailFilters.Dubbings.Count > 0)
            {
                ViewBag.IncludeDubbings = true;
            }
            else
            {
                ViewBag.IncludeDubbings = false;
            }

            if (searchAvailFilters.Others.IsTitleLanguage)
            {
                ViewBag.IncludeTitleLanguage = true;
            }
            else
            {
                ViewBag.IncludeTitleLanguage = false;
            }

            searchAvailFilters.Others.BusinessUnitCode = BU_Code;
            #endregion

            #region Get Avails from RightsUAvails Api
            ApplicationConfiguration applicationConfiguration = new ApplicationConfiguration();
            string baseUri = applicationConfiguration.GetConfigurationValue("RightsUAvailsApi");
            List<EachAvailViewModel> eachAvailViewModels = new List<EachAvailViewModel>();
            RightsUAvailsServiceProvider rightsUAvailsServiceProvider = new RightsUAvailsServiceProvider(new Uri(baseUri));

            searchAvailFilters.Others.ModuleCode = 147;

            eachAvailViewModels = rightsUAvailsServiceProvider.GetAvails(searchAvailFilters);
            #endregion

            #region Generate Excel Avail Report File

            try
            {
               // ReportServerCredentials ts = new ReportServerCredentials('');
                //ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
                using (ExcelPackage pck = new ExcelPackage())
                {
                    //Create the worksheet
                    ExcelWorksheet ws = pck.Workbook.Worksheets.Add("AvailsReport");

                    // setting the properties 
                    // of the work sheet  
                    ws.TabColor = System.Drawing.Color.Black;
                    ws.DefaultRowHeight = 12;

                    // Setting the properties 
                    // of the first row 
                    ws.Row(1).Height = 20;
                    ws.Row(1).Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws.Row(1).Style.Font.Bold = true;

                    AddRecords(ws, eachAvailViewModels, searchAvailFilters);

                    pck.Workbook.Properties.Title = "Excel Export Avails Report";
                    pck.Workbook.Properties.Author = "U-TO";
                    pck.Workbook.Properties.Comments = "Avails Report";
                    pck.Workbook.Properties.Company = "U-TO Solutions Pvt. Ltd.";

                    #region Criteria Sheet
                    //Create the worksheet
                    ExcelWorksheet wsCriteria = pck.Workbook.Worksheets.Add("CriteriaFilters");

                    // setting the properties 
                    // of the work sheet  
                    wsCriteria.TabColor = System.Drawing.Color.Black;
                    wsCriteria.DefaultRowHeight = 12;

                    // Setting the properties 
                    // of the first row 
                    wsCriteria.Row(1).Height = 20;
                    wsCriteria.Row(1).Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    wsCriteria.Row(1).Style.Font.Bold = true;



                    #region populate criteria Filters
                    CriteriaFilters criteriaFilters = new CriteriaFilters();
                    criteriaFilters.Titles = "";

                    var objGTALF = (RightsU_Entities.USP_Get_Title_Availability_LanguageWise_Filter_Result)Session["objGTALF"];

                    criteriaFilters.Titles = objGTALF.TitleNames;

                    criteriaFilters.EpisodeFrom = Convert.ToString(episodeFrom);
                    criteriaFilters.EpisodeTo = Convert.ToString(episodeTo);

                    string periodAvailable = string.Empty;
                    if (searchAvailFilters.TypesOfLicensePeriod == TypeOfLicensePeriod.Flexi)
                        periodAvailable = "Flexi Date -";
                    else if (searchAvailFilters.TypesOfLicensePeriod == TypeOfLicensePeriod.Fixed)
                        periodAvailable = "Fixed Date -";
                    else
                        periodAvailable = "Minimum Date -";

                    periodAvailable += " Start Date: " + searchAvailFilters.LicensePeriod.LicensePeriodStartFrom.ToShortDateString();
                    periodAvailable += " End Date: " + searchAvailFilters.LicensePeriod.LicensePeriodEndTo?.ToShortDateString();

                    criteriaFilters.PeriodAvailable = periodAvailable;
                    criteriaFilters.Exclusivity = objGTALF.ExclusivityNames;

                    criteriaFilters.TitleLanguage = objGTALF.TitleLanguage_Names;
                    if (string.IsNullOrEmpty(criteriaFilters.TitleLanguage) && searchAvailFilters.Others.IsTitleLanguage)
                        criteriaFilters.TitleLanguage = "Yes";
                    if (string.IsNullOrEmpty(criteriaFilters.TitleLanguage) && !searchAvailFilters.Others.IsTitleLanguage)
                        criteriaFilters.TitleLanguage = "No";

                    criteriaFilters.IFTACluster = "No";
                    //criteriaFilters.CreatedBy = objGTALF;
                    criteriaFilters.CreatedOn = objGTALF.Created_On.ToLongDateString() + " " + objGTALF.Created_On.ToLongTimeString();

                    ////excelWorksheet.Cells["C9"].Value = "Region";

                    criteriaFilters.Region_Territory = objGTALF.TerritoryNames;
                    criteriaFilters.Region_Countries = objGTALF.CountryNames;
                    criteriaFilters.Region_MustHave = objGTALF.MustHaveCountryNames;
                    if (string.IsNullOrEmpty(criteriaFilters.Region_MustHave))
                        criteriaFilters.Region_MustHave = "NA";
                    criteriaFilters.Region_ExactMatch = objGTALF.ExclusionCountryNames;

                    if (searchAvailFilters.Others.CountryMustHaveExactMatch == CountryMustHaveExactMatch.ExactMatch)
                        criteriaFilters.Region_ExactMatch = "Yes";
                    else
                        criteriaFilters.Region_ExactMatch = "No";

                    ////excelWorksheet.Cells["C15"].Value = "Platform";

                    criteriaFilters.Platform_Group = objGTALF.Platform_Group_Name;
                    criteriaFilters.Platform_Platforms = objGTALF.PlatformNames;
                    criteriaFilters.Platform_MustHave = objGTALF.MustHavePlatformsNames;
                    if (string.IsNullOrEmpty(criteriaFilters.Platform_MustHave))
                        criteriaFilters.Platform_MustHave = "NA";
                    criteriaFilters.Platform_ExactMatch = objGTALF.MustHavePlatformsNames;

                    if (searchAvailFilters.Others.PlatformMustHaveExactMatch == PlatformMustHaveExactMatch.ExactMatch)
                        criteriaFilters.Platform_ExactMatch = "Yes";
                    else
                        criteriaFilters.Platform_ExactMatch = "No";

                    ////excelWorksheet.Cells["C21"].Value = "Subtitling";

                    criteriaFilters.Subtitling_Group = objGTALF.Subtitling_Group_Name;
                    criteriaFilters.Subtitling_Languages = objGTALF.Subtit_LanguageNames;
                    criteriaFilters.Subtitling_MustHave = objGTALF.Subtitling_Must_Have_Names;
                    if (string.IsNullOrEmpty(criteriaFilters.Subtitling_MustHave))
                        criteriaFilters.Subtitling_MustHave = "NA";
                    criteriaFilters.Subtitling_ExactMatch = objGTALF.Subtitling_Exclusion_Names;

                    if (searchAvailFilters.Others.SubtitleMustHaveExactMatch == SubtitleMustHaveExactMatch.ExactMatch)
                        criteriaFilters.Subtitling_ExactMatch = "Yes";
                    else
                        criteriaFilters.Subtitling_ExactMatch = "No";

                    ////excelWorksheet.Cells["C27"].Value = "Dubbing";

                    criteriaFilters.Dubbing_Group = objGTALF.Dubbing_Group_Name;
                    criteriaFilters.Dubbing_Languages = objGTALF.Dubbing_LanguageNames;
                    criteriaFilters.Dubbing_MustHave = objGTALF.Dubbing_Must_Have_Names;
                    if (string.IsNullOrEmpty(criteriaFilters.Dubbing_MustHave))
                        criteriaFilters.Dubbing_MustHave = "NA";
                    criteriaFilters.Dubbing_ExactMatch = objGTALF.Duubing_Exclusion_Names;

                    criteriaFilters.Subtitling = objGTALF.SubtitlingDubbing;

                    if (searchAvailFilters.Others.SubtitleMustHaveExactMatch == SubtitleMustHaveExactMatch.ExactMatch)
                        criteriaFilters.Dubbing_ExactMatch = "Yes";
                    else
                        criteriaFilters.Dubbing_ExactMatch = "No";

                    #endregion



                    AddRecordsCriteria(wsCriteria, searchAvailFilters, criteriaFilters);
                    #endregion

                    string DateTimes = DateTime.Now.TimeOfDay.ToString().Replace(":", "_").Replace(".", "_");

                    //Default Download Filename
                    string FileName = "AvailsReport_" + DateTimes + ".xlsx";

                    //string availsReportFilePath = ConfigurationManager.AppSettings["AvailsReportFilePath"];

                    //Session["AvailsReportFilePath"] = availsReportFilePath + FileName;

                    //pck.SaveAs(new FileInfo(availsReportFilePath + FileName));

                    string filepath = ConfigurationManager.AppSettings["AvailsReportFilePath"].Trim('~');
                    string availsReportFilePath = (Server.MapPath("~") + "\\" + filepath);
                    Session["AvailsReportFilePath"] = availsReportFilePath + FileName;
                    pck.SaveAs(new FileInfo(availsReportFilePath + FileName));

                }
            }
            catch (Exception ex)
            {
                throw;
            }

            #endregion

            GridView gv = new GridView();

            #region add columns
            gv.AutoGenerateColumns = false;

            BoundField boundField_Title = new BoundField();
            boundField_Title.DataField = "TitleName";
            boundField_Title.HeaderText = "Title";
            gv.Columns.Add(boundField_Title);

            if (Convert.ToInt32(module) == 247)
            {
                BoundField boundField_EpisodeFrom = new BoundField();
                boundField_EpisodeFrom.DataField = "EpisodeFrom";
                boundField_EpisodeFrom.HeaderText = "Episode From";
                gv.Columns.Add(boundField_EpisodeFrom);

                BoundField boundField_EpisodeTo = new BoundField();
                boundField_EpisodeTo.DataField = "EpisodeTo";
                boundField_EpisodeTo.HeaderText = "Episode To";
                gv.Columns.Add(boundField_EpisodeTo);
            }
            BoundField boundField_Country = new BoundField();
            boundField_Country.DataField = "Country";
            boundField_Country.HeaderText = "Country";
            gv.Columns.Add(boundField_Country);

            BoundField boundField_StartDate = new BoundField();
            boundField_StartDate.DataField = "StartDate";
            boundField_StartDate.HeaderText = "Start Date";
            gv.Columns.Add(boundField_StartDate);

            BoundField boundField_EndDate = new BoundField();
            boundField_EndDate.DataField = "EndDate";
            boundField_EndDate.HeaderText = "End Date";
            gv.Columns.Add(boundField_EndDate);

            //BoundField boundField_Platform = new BoundField();
            //boundField_Platform.DataField = "Platform";
            //boundField_Platform.HeaderText = "Platform";
            //gv.Columns.Add(boundField_Platform);

            BoundField boundField_Exclusive = new BoundField();
            boundField_Exclusive.DataField = "Exclusive";
            boundField_Exclusive.HeaderText = "Exclusive";
            gv.Columns.Add(boundField_Exclusive);

            BoundField boundField_SubLicense = new BoundField();
            boundField_SubLicense.DataField = "SubLicense";
            boundField_SubLicense.HeaderText = "Sub License";
            gv.Columns.Add(boundField_SubLicense);

            BoundField boundField_Genre = new BoundField();
            boundField_Genre.DataField = "Genre";
            boundField_Genre.HeaderText = "Genres";
            gv.Columns.Add(boundField_Genre);

            BoundField boundField_StarCast = new BoundField();
            boundField_StarCast.DataField = "StarCast";
            boundField_StarCast.HeaderText = "Star Cast";
            gv.Columns.Add(boundField_StarCast);

            BoundField boundField_ReleaseYear = new BoundField();
            boundField_ReleaseYear.DataField = "ReleaseYear";
            boundField_ReleaseYear.HeaderText = "Year Of Release";
            gv.Columns.Add(boundField_ReleaseYear);

            BoundField boundField_Director = new BoundField();
            boundField_Director.DataField = "Director";
            boundField_Director.HeaderText = "Director";
            gv.Columns.Add(boundField_Director);

            BoundField boundField_Duration = new BoundField();
            boundField_Duration.DataField = "Duration";
            boundField_Duration.HeaderText = "Duration (Min)";
            gv.Columns.Add(boundField_Duration);

            BoundField boundField_TitleLanguage = new BoundField();
            boundField_TitleLanguage.DataField = "LanguageName";
            boundField_TitleLanguage.HeaderText = "Title Language";
            gv.Columns.Add(boundField_TitleLanguage);

            if (searchAvailFilters.SubTitles != null && searchAvailFilters.SubTitles.Count > 0)
            {
                BoundField boundField_SubTiltling = new BoundField();
                boundField_SubTiltling.DataField = "SubTiltling";
                boundField_SubTiltling.HeaderText = "SubTiltling";
                gv.Columns.Add(boundField_SubTiltling);
            }

            if (searchAvailFilters.Dubbings != null && searchAvailFilters.Dubbings.Count > 0)
            {
                BoundField boundField_Dubbing = new BoundField();
                boundField_Dubbing.DataField = "Dubbing";
                boundField_Dubbing.HeaderText = "Dubbing";
                gv.Columns.Add(boundField_Dubbing);
            }

            #region platform matrix implementation
            int index = 1;
            ViewBag.searchAvailFiltersPlatforms = searchAvailFilters.Platforms;

            if (eachAvailViewModels.Count > 0)
            {
                //foreach(var platform in )
                //platform list is in the same order as properties in each avail
                //create a list of platforms that needs to be skipped
                //populate this list based on if any platfrom value is No in all the present avails then mark that as skip

                int totalAvailLines = eachAvailViewModels.Count;
                List<string> platformsToBeSkipped = new List<string>();
                #region populate platforms that needs to be skipped as it is not availabale in any of the avail line
                var platform_1 = eachAvailViewModels.Where(avail => avail.Platform1_Value == "No").Count();
                if (platform_1 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform1_Name);
                }
                var platform_2 = eachAvailViewModels.Where(avail => avail.Platform2_Value == "No").Count();
                if (platform_2 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform2_Name);
                }
                var platform_3 = eachAvailViewModels.Where(avail => avail.Platform3_Value == "No").Count();
                if (platform_3 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform3_Name);
                }
                var platform_4 = eachAvailViewModels.Where(avail => avail.Platform4_Value == "No").Count();
                if (platform_4 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform4_Name);
                }
                var platform_5 = eachAvailViewModels.Where(avail => avail.Platform5_Value == "No").Count();
                if (platform_5 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform5_Name);
                }
                var platform_6 = eachAvailViewModels.Where(avail => avail.Platform6_Value == "No").Count();
                if (platform_6 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform6_Name);
                }
                var platform_7 = eachAvailViewModels.Where(avail => avail.Platform7_Value == "No").Count();
                if (platform_7 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform7_Name);
                }
                var platform_8 = eachAvailViewModels.Where(avail => avail.Platform8_Value == "No").Count();
                if (platform_8 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform8_Name);
                }
                var platform_9 = eachAvailViewModels.Where(avail => avail.Platform9_Value == "No").Count();
                if (platform_9 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform9_Name);
                }
                var platform_10 = eachAvailViewModels.Where(avail => avail.Platform10_Value == "No").Count();
                if (platform_10 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform10_Name);
                }
                var platform_11 = eachAvailViewModels.Where(avail => avail.Platform11_Value == "No").Count();
                if (platform_11 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform11_Name);
                }
                var platform_12 = eachAvailViewModels.Where(avail => avail.Platform12_Value == "No").Count();
                if (platform_12 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform12_Name);
                }
                var platform_13 = eachAvailViewModels.Where(avail => avail.Platform13_Value == "No").Count();
                if (platform_13 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform13_Name);
                }
                var platform_14 = eachAvailViewModels.Where(avail => avail.Platform14_Value == "No").Count();
                if (platform_14 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform14_Name);
                }
                var platform_15 = eachAvailViewModels.Where(avail => avail.Platform15_Value == "No").Count();
                if (platform_15 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform15_Name);
                }
                var platform_16 = eachAvailViewModels.Where(avail => avail.Platform16_Value == "No").Count();
                if (platform_16 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform16_Name);
                }
                var platform_17 = eachAvailViewModels.Where(avail => avail.Platform17_Value == "No").Count();
                if (platform_17 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform17_Name);
                }
                var platform_18 = eachAvailViewModels.Where(avail => avail.Platform18_Value == "No").Count();
                if (platform_18 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform18_Name);
                }
                var platform_19 = eachAvailViewModels.Where(avail => avail.Platform19_Value == "No").Count();
                if (platform_19 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform19_Name);
                }
                var platform_20 = eachAvailViewModels.Where(avail => avail.Platform20_Value == "No").Count();
                if (platform_20 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform20_Name);
                }
                var platform_21 = eachAvailViewModels.Where(avail => avail.Platform21_Value == "No").Count();
                if (platform_21 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform21_Name);
                }
                var platform_22 = eachAvailViewModels.Where(avail => avail.Platform22_Value == "No").Count();
                if (platform_22 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform22_Name);
                }
                var platform_23 = eachAvailViewModels.Where(avail => avail.Platform23_Value == "No").Count();
                if (platform_23 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform23_Name);
                }
                var platform_24 = eachAvailViewModels.Where(avail => avail.Platform24_Value == "No").Count();
                if (platform_24 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform24_Name);
                }
                var platform_25 = eachAvailViewModels.Where(avail => avail.Platform25_Value == "No").Count();
                if (platform_25 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform25_Name);
                }
                var platform_26 = eachAvailViewModels.Where(avail => avail.Platform26_Value == "No").Count();
                if (platform_26 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform26_Name);
                }
                var platform_27 = eachAvailViewModels.Where(avail => avail.Platform27_Value == "No").Count();
                if (platform_27 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform27_Name);
                }
                var platform_28 = eachAvailViewModels.Where(avail => avail.Platform28_Value == "No").Count();
                if (platform_28 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform28_Name);
                }
                var platform_29 = eachAvailViewModels.Where(avail => avail.Platform29_Value == "No").Count();
                if (platform_29 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform29_Name);
                }
                var platform_30 = eachAvailViewModels.Where(avail => avail.Platform30_Value == "No").Count();
                if (platform_30 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform30_Name);
                }
                var platform_31 = eachAvailViewModels.Where(avail => avail.Platform31_Value == "No").Count();
                if (platform_31 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform31_Name);
                }
                var platform_32 = eachAvailViewModels.Where(avail => avail.Platform32_Value == "No").Count();
                if (platform_32 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform32_Name);
                }
                var platform_33 = eachAvailViewModels.Where(avail => avail.Platform33_Value == "No").Count();
                if (platform_33 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform33_Name);
                }
                var platform_34 = eachAvailViewModels.Where(avail => avail.Platform34_Value == "No").Count();
                if (platform_34 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform34_Name);
                }
                var platform_35 = eachAvailViewModels.Where(avail => avail.Platform35_Value == "No").Count();
                if (platform_35 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform35_Name);
                }
                var platform_36 = eachAvailViewModels.Where(avail => avail.Platform36_Value == "No").Count();
                if (platform_36 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform36_Name);
                }
                var platform_37 = eachAvailViewModels.Where(avail => avail.Platform37_Value == "No").Count();
                if (platform_37 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform37_Name);
                }
                var platform_38 = eachAvailViewModels.Where(avail => avail.Platform38_Value == "No").Count();
                if (platform_38 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform38_Name);
                }
                var platform_39 = eachAvailViewModels.Where(avail => avail.Platform39_Value == "No").Count();
                if (platform_39 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform39_Name);
                }
                var platform_40 = eachAvailViewModels.Where(avail => avail.Platform40_Value == "No").Count();
                if (platform_40 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform40_Name);
                }
                var platform_41 = eachAvailViewModels.Where(avail => avail.Platform41_Value == "No").Count();
                if (platform_41 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform41_Name);
                }
                var platform_42 = eachAvailViewModels.Where(avail => avail.Platform42_Value == "No").Count();
                if (platform_42 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform42_Name);
                }
                var platform_43 = eachAvailViewModels.Where(avail => avail.Platform43_Value == "No").Count();
                if (platform_43 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform43_Name);
                }
                var platform_44 = eachAvailViewModels.Where(avail => avail.Platform44_Value == "No").Count();
                if (platform_44 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform44_Name);
                }
                var platform_45 = eachAvailViewModels.Where(avail => avail.Platform45_Value == "No").Count();
                if (platform_45 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform45_Name);
                }
                var platform_46 = eachAvailViewModels.Where(avail => avail.Platform46_Value == "No").Count();
                if (platform_46 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform46_Name);
                }
                var platform_47 = eachAvailViewModels.Where(avail => avail.Platform47_Value == "No").Count();
                if (platform_47 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform47_Name);
                }
                var platform_48 = eachAvailViewModels.Where(avail => avail.Platform48_Value == "No").Count();
                if (platform_48 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform48_Name);
                }
                var platform_49 = eachAvailViewModels.Where(avail => avail.Platform49_Value == "No").Count();
                if (platform_49 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform49_Name);
                }
                var platform_50 = eachAvailViewModels.Where(avail => avail.Platform50_Value == "No").Count();
                if (platform_50 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform50_Name);
                }
                var platform_51 = eachAvailViewModels.Where(avail => avail.Platform51_Value == "No").Count();
                if (platform_51 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform51_Name);
                }
                var platform_52 = eachAvailViewModels.Where(avail => avail.Platform52_Value == "No").Count();
                if (platform_52 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform52_Name);
                }
                var platform_53 = eachAvailViewModels.Where(avail => avail.Platform53_Value == "No").Count();
                if (platform_53 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform53_Name);
                }
                var platform_54 = eachAvailViewModels.Where(avail => avail.Platform54_Value == "No").Count();
                if (platform_54 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform54_Name);
                }
                var platform_55 = eachAvailViewModels.Where(avail => avail.Platform55_Value == "No").Count();
                if (platform_55 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform55_Name);
                }
                var platform_56 = eachAvailViewModels.Where(avail => avail.Platform56_Value == "No").Count();
                if (platform_56 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform56_Name);
                }
                var platform_57 = eachAvailViewModels.Where(avail => avail.Platform57_Value == "No").Count();
                if (platform_57 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform57_Name);
                }
                var platform_58 = eachAvailViewModels.Where(avail => avail.Platform58_Value == "No").Count();
                if (platform_58 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform58_Name);
                }
                var platform_59 = eachAvailViewModels.Where(avail => avail.Platform59_Value == "No").Count();
                if (platform_59 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform59_Name);
                }
                var platform_60 = eachAvailViewModels.Where(avail => avail.Platform60_Value == "No").Count();
                if (platform_60 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform60_Name);
                }
                #endregion
                //foreach(var availViewModel in eachAvailViewModels)
                //{
                //    availViewModel.
                //}

                foreach (var platform in eachAvailViewModels[0].PlatformList)
                {
                    bool skipCurrentPlatform = false;
                    if (searchAvailFilters.Platforms != null && searchAvailFilters.Platforms.Count > 0 && !searchAvailFilters.Platforms.Contains(platform.PlatformCode))
                    {
                        skipCurrentPlatform = true;
                    }

                    if (platformsToBeSkipped.Contains(platform.PlatformName))
                    {
                        skipCurrentPlatform = true;
                    }

                    if (!skipCurrentPlatform)
                    {
                        BoundField boundField_platform = new BoundField();
                        boundField_platform.DataField = "Platform" + index + "_Value";
                        boundField_platform.HeaderText = platform.PlatformName;
                        gv.Columns.Add(boundField_platform);
                    }
                    index++;
                }
            }
            #endregion

            BoundField boundField_RestrictionRemarks = new BoundField();
            boundField_RestrictionRemarks.DataField = "RestrictionRemarks";
            boundField_RestrictionRemarks.HeaderText = "Restriction Remark";
            gv.Columns.Add(boundField_RestrictionRemarks);

            //BoundField boundField_SubDealRestrictionRemarks = new BoundField();
            //boundField_SubDealRestrictionRemarks.DataField = "SubDealRestrictionRemarks";
            //boundField_SubDealRestrictionRemarks.HeaderText = "Sub Deal Restriction Remark";
            //gv.Columns.Add(boundField_SubDealRestrictionRemarks);

            BoundField boundField_Remarks = new BoundField();
            boundField_Remarks.DataField = "Remarks";
            boundField_Remarks.HeaderText = "Remarks";
            gv.Columns.Add(boundField_Remarks);

            BoundField boundField_RightsRemarks = new BoundField();
            boundField_RightsRemarks.DataField = "RightsRemarks";
            boundField_RightsRemarks.HeaderText = "Rights Remarks";
            gv.Columns.Add(boundField_RightsRemarks);

            //BoundField boundField_TitleLanguage = new BoundField();
            //boundField_TitleLanguage.DataField = "LanguageName";
            //boundField_TitleLanguage.HeaderText = "Title Language";
            //gv.Columns.Add(boundField_TitleLanguage);

            #endregion

            gv.DataSource = eachAvailViewModels;
            gv.DataBind();

            //using (DataTable dt = new DataTable())
            //{
            //    //sda.Fill(dt);

            //    //Set AutoGenerateColumns False
            //    gv.AutoGenerateColumns = false;

            //    //Set Columns Count
            //    gv.ColumnCount = 3;

            //    //Add Columns
            //    gv.Columns[0].Name = "CustomerId";
            //    gv.Columns[0].HeaderText = "Customer Id";
            //    gv.Columns[0].DataPropertyName = "CustomerID";

            //    gv.Columns[1].HeaderText = "Contact Name";
            //    gv.Columns[1].Name = "Name";
            //    gv.Columns[1].DataPropertyName = "ContactName";

            //    dataGridView1.Columns[2].Name = "Country";
            //    dataGridView1.Columns[2].HeaderText = "Country";
            //    dataGridView1.Columns[2].DataPropertyName = "Country";
            //    dataGridView1.DataSource = dt;
            //}

            Session["AvailsReport"] = gv;

            #region commented code
            //ReportViewer rptViewer = new ReportViewer();
            //if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString())
            //{
            //    if (Availability_Ifta_And_Ancillary == "Y")//availabilyIFTAAND ANCILARY IF Y DEN V18 ESLE SPN
            //        rptViewer = BindReport(parm, "Title_Availability_Languagewise_V18");
            //    else if (Availability_Ifta_And_Ancillary == "N")
            //        rptViewer = BindReport(parm, "Title_Availability_Languagewise_3");
            //}
            //else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString())
            //{
            //    if (Availability_Ifta_And_Ancillary == "Y")
            //        rptViewer = BindReport(parm, "Title_Availability_Show_3_V18");
            //    else if (Availability_Ifta_And_Ancillary == "N")
            //        rptViewer = BindReport(parm, "Title_Availability_Show_3");
            //}
            //else if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
            //    rptViewer = BindReport(parm, "Movie_Availability_Indiacast");
            //else if (module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            //    rptViewer = BindReport(parm, "Show_availability_Indiacast");
            //else if (module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
            //    rptViewer = BindReport(parm, "Self_Utilization_Movie_Availability");
            //else if (module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            //    rptViewer = BindReport(parm, "Self_Utilization_Show_Availability");
            //else
            //    rptViewer = BindReport(parm, "Theatrical_Availability");

            //ViewBag.ReportViewer = rptViewer;
            //return PartialView("~/Views/Shared/ReportViewer.cshtml");
            #endregion

            return PartialView("~/Views/Shared/ReportViewerAvails.cshtml", eachAvailViewModels);
        }

        private void AddRecords(ExcelWorksheet excelWorksheet, List<EachAvailViewModel> eachAvailViewModels, SearchAvailFilters searchAvailFilters)
        {
            if (eachAvailViewModels.Count > 0)
            {
                // Header of the Excel sheet 
                int columnCounter = 0;
                excelWorksheet.Cells[1, ++columnCounter].Value = "Title";
                if (Convert.ToInt32(module) == 247)
                {
                    excelWorksheet.Cells[1, ++columnCounter].Value = "Episode From";
                    excelWorksheet.Cells[1, ++columnCounter].Value = "Episode To";
                }
                excelWorksheet.Cells[1, ++columnCounter].Value = "Country/Territory";//Country/Territory
                excelWorksheet.Cells[1, ++columnCounter].Value = "Start Date";
                excelWorksheet.Cells[1, ++columnCounter].Value = "End Date";
                excelWorksheet.Cells[1, ++columnCounter].Value = "Exclusive";
                excelWorksheet.Cells[1, ++columnCounter].Value = "Sub License";
                excelWorksheet.Cells[1, ++columnCounter].Value = "Genres";
                excelWorksheet.Cells[1, ++columnCounter].Value = "Star Cast";
                excelWorksheet.Cells[1, ++columnCounter].Value = "Year Of Release";
                excelWorksheet.Cells[1, ++columnCounter].Value = "Director";
                excelWorksheet.Cells[1, ++columnCounter].Value = "Duration (Min)";
                if (searchAvailFilters.Others.IsTitleLanguage)
                    excelWorksheet.Cells[1, ++columnCounter].Value = "Title Language";

                if (searchAvailFilters.SubTitles != null && searchAvailFilters.SubTitles.Count > 0)
                {
                    excelWorksheet.Cells[1, ++columnCounter].Value = "SubTiltling";
                }

                if (searchAvailFilters.Dubbings != null && searchAvailFilters.Dubbings.Count > 0)
                {
                    excelWorksheet.Cells[1, ++columnCounter].Value = "Dubbing";
                }

                #region platform matrix implementation
                int index = 1;
                ViewBag.searchAvailFiltersPlatforms = searchAvailFilters.Platforms;

                int totalAvailLines = eachAvailViewModels.Count;
                List<string> platformsToBeSkipped = new List<string>();
                #region populate platforms that needs to be skipped as it is not availabale in any of the avail line
                var platform_1 = eachAvailViewModels.Where(avail => avail.Platform1_Value == "No").Count();
                if (platform_1 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform1_Name);
                }
                var platform_2 = eachAvailViewModels.Where(avail => avail.Platform2_Value == "No").Count();
                if (platform_2 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform2_Name);
                }
                var platform_3 = eachAvailViewModels.Where(avail => avail.Platform3_Value == "No").Count();
                if (platform_3 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform3_Name);
                }
                var platform_4 = eachAvailViewModels.Where(avail => avail.Platform4_Value == "No").Count();
                if (platform_4 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform4_Name);
                }
                var platform_5 = eachAvailViewModels.Where(avail => avail.Platform5_Value == "No").Count();
                if (platform_5 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform5_Name);
                }
                var platform_6 = eachAvailViewModels.Where(avail => avail.Platform6_Value == "No").Count();
                if (platform_6 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform6_Name);
                }
                var platform_7 = eachAvailViewModels.Where(avail => avail.Platform7_Value == "No").Count();
                if (platform_7 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform7_Name);
                }
                var platform_8 = eachAvailViewModels.Where(avail => avail.Platform8_Value == "No").Count();
                if (platform_8 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform8_Name);
                }
                var platform_9 = eachAvailViewModels.Where(avail => avail.Platform9_Value == "No").Count();
                if (platform_9 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform9_Name);
                }
                var platform_10 = eachAvailViewModels.Where(avail => avail.Platform10_Value == "No").Count();
                if (platform_10 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform10_Name);
                }
                var platform_11 = eachAvailViewModels.Where(avail => avail.Platform11_Value == "No").Count();
                if (platform_11 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform11_Name);
                }
                var platform_12 = eachAvailViewModels.Where(avail => avail.Platform12_Value == "No").Count();
                if (platform_12 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform12_Name);
                }
                var platform_13 = eachAvailViewModels.Where(avail => avail.Platform13_Value == "No").Count();
                if (platform_13 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform13_Name);
                }
                var platform_14 = eachAvailViewModels.Where(avail => avail.Platform14_Value == "No").Count();
                if (platform_14 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform14_Name);
                }
                var platform_15 = eachAvailViewModels.Where(avail => avail.Platform15_Value == "No").Count();
                if (platform_15 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform15_Name);
                }
                var platform_16 = eachAvailViewModels.Where(avail => avail.Platform16_Value == "No").Count();
                if (platform_16 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform16_Name);
                }
                var platform_17 = eachAvailViewModels.Where(avail => avail.Platform17_Value == "No").Count();
                if (platform_17 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform17_Name);
                }
                var platform_18 = eachAvailViewModels.Where(avail => avail.Platform18_Value == "No").Count();
                if (platform_18 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform18_Name);
                }
                var platform_19 = eachAvailViewModels.Where(avail => avail.Platform19_Value == "No").Count();
                if (platform_19 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform19_Name);
                }
                var platform_20 = eachAvailViewModels.Where(avail => avail.Platform20_Value == "No").Count();
                if (platform_20 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform20_Name);
                }
                var platform_21 = eachAvailViewModels.Where(avail => avail.Platform21_Value == "No").Count();
                if (platform_21 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform21_Name);
                }
                var platform_22 = eachAvailViewModels.Where(avail => avail.Platform22_Value == "No").Count();
                if (platform_22 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform22_Name);
                }
                var platform_23 = eachAvailViewModels.Where(avail => avail.Platform23_Value == "No").Count();
                if (platform_23 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform23_Name);
                }
                var platform_24 = eachAvailViewModels.Where(avail => avail.Platform24_Value == "No").Count();
                if (platform_24 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform24_Name);
                }
                var platform_25 = eachAvailViewModels.Where(avail => avail.Platform25_Value == "No").Count();
                if (platform_25 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform25_Name);
                }
                var platform_26 = eachAvailViewModels.Where(avail => avail.Platform26_Value == "No").Count();
                if (platform_26 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform26_Name);
                }
                var platform_27 = eachAvailViewModels.Where(avail => avail.Platform27_Value == "No").Count();
                if (platform_27 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform27_Name);
                }
                var platform_28 = eachAvailViewModels.Where(avail => avail.Platform28_Value == "No").Count();
                if (platform_28 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform28_Name);
                }
                var platform_29 = eachAvailViewModels.Where(avail => avail.Platform29_Value == "No").Count();
                if (platform_29 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform29_Name);
                }
                var platform_30 = eachAvailViewModels.Where(avail => avail.Platform30_Value == "No").Count();
                if (platform_30 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform30_Name);
                }
                var platform_31 = eachAvailViewModels.Where(avail => avail.Platform31_Value == "No").Count();
                if (platform_31 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform31_Name);
                }
                var platform_32 = eachAvailViewModels.Where(avail => avail.Platform32_Value == "No").Count();
                if (platform_32 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform32_Name);
                }
                var platform_33 = eachAvailViewModels.Where(avail => avail.Platform33_Value == "No").Count();
                if (platform_33 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform33_Name);
                }
                var platform_34 = eachAvailViewModels.Where(avail => avail.Platform34_Value == "No").Count();
                if (platform_34 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform34_Name);
                }
                var platform_35 = eachAvailViewModels.Where(avail => avail.Platform35_Value == "No").Count();
                if (platform_35 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform35_Name);
                }
                var platform_36 = eachAvailViewModels.Where(avail => avail.Platform36_Value == "No").Count();
                if (platform_36 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform36_Name);
                }
                var platform_37 = eachAvailViewModels.Where(avail => avail.Platform37_Value == "No").Count();
                if (platform_37 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform37_Name);
                }
                var platform_38 = eachAvailViewModels.Where(avail => avail.Platform38_Value == "No").Count();
                if (platform_38 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform38_Name);
                }
                var platform_39 = eachAvailViewModels.Where(avail => avail.Platform39_Value == "No").Count();
                if (platform_39 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform39_Name);
                }
                var platform_40 = eachAvailViewModels.Where(avail => avail.Platform40_Value == "No").Count();
                if (platform_40 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform40_Name);
                }
                var platform_41 = eachAvailViewModels.Where(avail => avail.Platform41_Value == "No").Count();
                if (platform_41 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform41_Name);
                }
                var platform_42 = eachAvailViewModels.Where(avail => avail.Platform42_Value == "No").Count();
                if (platform_42 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform42_Name);
                }
                var platform_43 = eachAvailViewModels.Where(avail => avail.Platform43_Value == "No").Count();
                if (platform_43 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform43_Name);
                }
                var platform_44 = eachAvailViewModels.Where(avail => avail.Platform44_Value == "No").Count();
                if (platform_44 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform44_Name);
                }
                var platform_45 = eachAvailViewModels.Where(avail => avail.Platform45_Value == "No").Count();
                if (platform_45 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform45_Name);
                }
                var platform_46 = eachAvailViewModels.Where(avail => avail.Platform46_Value == "No").Count();
                if (platform_46 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform46_Name);
                }
                var platform_47 = eachAvailViewModels.Where(avail => avail.Platform47_Value == "No").Count();
                if (platform_47 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform47_Name);
                }
                var platform_48 = eachAvailViewModels.Where(avail => avail.Platform48_Value == "No").Count();
                if (platform_48 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform48_Name);
                }
                var platform_49 = eachAvailViewModels.Where(avail => avail.Platform49_Value == "No").Count();
                if (platform_49 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform49_Name);
                }
                var platform_50 = eachAvailViewModels.Where(avail => avail.Platform50_Value == "No").Count();
                if (platform_50 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform50_Name);
                }
                var platform_51 = eachAvailViewModels.Where(avail => avail.Platform51_Value == "No").Count();
                if (platform_51 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform51_Name);
                }
                var platform_52 = eachAvailViewModels.Where(avail => avail.Platform52_Value == "No").Count();
                if (platform_52 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform52_Name);
                }
                var platform_53 = eachAvailViewModels.Where(avail => avail.Platform53_Value == "No").Count();
                if (platform_53 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform53_Name);
                }
                var platform_54 = eachAvailViewModels.Where(avail => avail.Platform54_Value == "No").Count();
                if (platform_54 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform54_Name);
                }
                var platform_55 = eachAvailViewModels.Where(avail => avail.Platform55_Value == "No").Count();
                if (platform_55 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform55_Name);
                }
                var platform_56 = eachAvailViewModels.Where(avail => avail.Platform56_Value == "No").Count();
                if (platform_56 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform56_Name);
                }
                var platform_57 = eachAvailViewModels.Where(avail => avail.Platform57_Value == "No").Count();
                if (platform_57 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform57_Name);
                }
                var platform_58 = eachAvailViewModels.Where(avail => avail.Platform58_Value == "No").Count();
                if (platform_58 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform58_Name);
                }
                var platform_59 = eachAvailViewModels.Where(avail => avail.Platform59_Value == "No").Count();
                if (platform_59 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform59_Name);
                }
                var platform_60 = eachAvailViewModels.Where(avail => avail.Platform60_Value == "No").Count();
                if (platform_60 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform60_Name);
                }
                var platform_61 = eachAvailViewModels.Where(avail => avail.Platform61_Value == "No").Count();
                if (platform_61 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform61_Name);
                }
                var platform_62 = eachAvailViewModels.Where(avail => avail.Platform62_Value == "No").Count();
                if (platform_62 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform62_Name);
                }
                var platform_63 = eachAvailViewModels.Where(avail => avail.Platform63_Value == "No").Count();
                if (platform_63 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform63_Name);
                }
                var platform_64 = eachAvailViewModels.Where(avail => avail.Platform64_Value == "No").Count();
                if (platform_64 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform64_Name);
                }
                var platform_65 = eachAvailViewModels.Where(avail => avail.Platform65_Value == "No").Count();
                if (platform_65 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform65_Name);
                }
                var platform_66 = eachAvailViewModels.Where(avail => avail.Platform66_Value == "No").Count();
                if (platform_66 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform66_Name);
                }
                var platform_67 = eachAvailViewModels.Where(avail => avail.Platform67_Value == "No").Count();
                if (platform_67 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform67_Name);
                }
                var platform_68 = eachAvailViewModels.Where(avail => avail.Platform68_Value == "No").Count();
                if (platform_68 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform68_Name);
                }
                var platform_69 = eachAvailViewModels.Where(avail => avail.Platform69_Value == "No").Count();
                if (platform_69 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform69_Name);
                }
                var platform_70 = eachAvailViewModels.Where(avail => avail.Platform70_Value == "No").Count();
                if (platform_70 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform70_Name);
                }
                var platform_71 = eachAvailViewModels.Where(avail => avail.Platform71_Value == "No").Count();
                if (platform_71 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform71_Name);
                }
                var platform_72 = eachAvailViewModels.Where(avail => avail.Platform72_Value == "No").Count();
                if (platform_72 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform72_Name);
                }
                var platform_73 = eachAvailViewModels.Where(avail => avail.Platform73_Value == "No").Count();
                if (platform_73 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform73_Name);
                }
                var platform_74 = eachAvailViewModels.Where(avail => avail.Platform74_Value == "No").Count();
                if (platform_74 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform74_Name);
                }
                var platform_75 = eachAvailViewModels.Where(avail => avail.Platform75_Value == "No").Count();
                if (platform_75 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform75_Name);
                }
                var platform_76 = eachAvailViewModels.Where(avail => avail.Platform76_Value == "No").Count();
                if (platform_76 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform76_Name);
                }
                var platform_77 = eachAvailViewModels.Where(avail => avail.Platform77_Value == "No").Count();
                if (platform_77 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform77_Name);
                }
                var platform_78 = eachAvailViewModels.Where(avail => avail.Platform78_Value == "No").Count();
                if (platform_78 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform78_Name);
                }
                var platform_79 = eachAvailViewModels.Where(avail => avail.Platform79_Value == "No").Count();
                if (platform_79 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform79_Name);
                }
                var platform_80 = eachAvailViewModels.Where(avail => avail.Platform80_Value == "No").Count();
                if (platform_80 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform80_Name);
                }
                var platform_81 = eachAvailViewModels.Where(avail => avail.Platform81_Value == "No").Count();
                if (platform_81 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform81_Name);
                }
                var platform_82 = eachAvailViewModels.Where(avail => avail.Platform82_Value == "No").Count();
                if (platform_82 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform82_Name);
                }
                var platform_83 = eachAvailViewModels.Where(avail => avail.Platform83_Value == "No").Count();
                if (platform_83 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform83_Name);
                }
                var platform_84 = eachAvailViewModels.Where(avail => avail.Platform84_Value == "No").Count();
                if (platform_84 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform84_Name);
                }
                var platform_85 = eachAvailViewModels.Where(avail => avail.Platform85_Value == "No").Count();
                if (platform_85 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform85_Name);
                }
                var platform_86 = eachAvailViewModels.Where(avail => avail.Platform86_Value == "No").Count();
                if (platform_86 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform86_Name);
                }
                var platform_87 = eachAvailViewModels.Where(avail => avail.Platform87_Value == "No").Count();
                if (platform_87 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform87_Name);
                }
                var platform_88 = eachAvailViewModels.Where(avail => avail.Platform88_Value == "No").Count();
                if (platform_88 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform88_Name);
                }
                var platform_89 = eachAvailViewModels.Where(avail => avail.Platform89_Value == "No").Count();
                if (platform_89 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform89_Name);
                }
                var platform_90 = eachAvailViewModels.Where(avail => avail.Platform90_Value == "No").Count();
                if (platform_90 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform90_Name);
                }
                var platform_91 = eachAvailViewModels.Where(avail => avail.Platform91_Value == "No").Count();
                if (platform_91 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform91_Name);
                }
                var platform_92 = eachAvailViewModels.Where(avail => avail.Platform92_Value == "No").Count();
                if (platform_92 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform92_Name);
                }
                var platform_93 = eachAvailViewModels.Where(avail => avail.Platform93_Value == "No").Count();
                if (platform_93 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform93_Name);
                }
                var platform_94 = eachAvailViewModels.Where(avail => avail.Platform94_Value == "No").Count();
                if (platform_94 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform94_Name);
                }
                var platform_95 = eachAvailViewModels.Where(avail => avail.Platform95_Value == "No").Count();
                if (platform_95 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform95_Name);
                }
                var platform_96 = eachAvailViewModels.Where(avail => avail.Platform96_Value == "No").Count();
                if (platform_96 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform96_Name);
                }
                var platform_97 = eachAvailViewModels.Where(avail => avail.Platform97_Value == "No").Count();
                if (platform_97 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform97_Name);
                }
                var platform_98 = eachAvailViewModels.Where(avail => avail.Platform98_Value == "No").Count();
                if (platform_98 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform98_Name);
                }
                var platform_99 = eachAvailViewModels.Where(avail => avail.Platform99_Value == "No").Count();
                if (platform_99 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform99_Name);
                }
                var platform_100 = eachAvailViewModels.Where(avail => avail.Platform100_Value == "No").Count();
                if (platform_100 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform100_Name);
                }
                var platform_101 = eachAvailViewModels.Where(avail => avail.Platform101_Value == "No").Count();
                if (platform_101 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform101_Name);
                }
                var platform_102 = eachAvailViewModels.Where(avail => avail.Platform102_Value == "No").Count();
                if (platform_102 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform102_Name);
                }
                var platform_103 = eachAvailViewModels.Where(avail => avail.Platform103_Value == "No").Count();
                if (platform_103 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform103_Name);
                }
                var platform_104 = eachAvailViewModels.Where(avail => avail.Platform104_Value == "No").Count();
                if (platform_104 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform104_Name);
                }
                var platform_105 = eachAvailViewModels.Where(avail => avail.Platform105_Value == "No").Count();
                if (platform_105 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform105_Name);
                }
                var platform_106 = eachAvailViewModels.Where(avail => avail.Platform106_Value == "No").Count();
                if (platform_106 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform106_Name);
                }
                var platform_107 = eachAvailViewModels.Where(avail => avail.Platform107_Value == "No").Count();
                if (platform_107 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform107_Name);
                }
                var platform_108 = eachAvailViewModels.Where(avail => avail.Platform108_Value == "No").Count();
                if (platform_108 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform108_Name);
                }
                var platform_109 = eachAvailViewModels.Where(avail => avail.Platform109_Value == "No").Count();
                if (platform_109 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform109_Name);
                }
                var platform_110 = eachAvailViewModels.Where(avail => avail.Platform110_Value == "No").Count();
                if (platform_110 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform110_Name);
                }
                var platform_111 = eachAvailViewModels.Where(avail => avail.Platform111_Value == "No").Count();
                if (platform_111 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform111_Name);
                }
                var platform_112 = eachAvailViewModels.Where(avail => avail.Platform112_Value == "No").Count();
                if (platform_112 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform112_Name);
                }
                var platform_113 = eachAvailViewModels.Where(avail => avail.Platform113_Value == "No").Count();
                if (platform_113 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform113_Name);
                }
                var platform_114 = eachAvailViewModels.Where(avail => avail.Platform114_Value == "No").Count();
                if (platform_114 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform114_Name);
                }
                var platform_115 = eachAvailViewModels.Where(avail => avail.Platform115_Value == "No").Count();
                if (platform_115 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform115_Name);
                }
                var platform_116 = eachAvailViewModels.Where(avail => avail.Platform116_Value == "No").Count();
                if (platform_116 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform116_Name);
                }
                var platform_117 = eachAvailViewModels.Where(avail => avail.Platform117_Value == "No").Count();
                if (platform_117 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform117_Name);
                }
                var platform_118 = eachAvailViewModels.Where(avail => avail.Platform118_Value == "No").Count();
                if (platform_118 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform118_Name);
                }
                var platform_119 = eachAvailViewModels.Where(avail => avail.Platform119_Value == "No").Count();
                if (platform_119 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform119_Name);
                }
                var platform_120 = eachAvailViewModels.Where(avail => avail.Platform120_Value == "No").Count();
                if (platform_120 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform120_Name);
                }
                var platform_121 = eachAvailViewModels.Where(avail => avail.Platform121_Value == "No").Count();
                if (platform_121 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform121_Name);
                }
                var platform_122 = eachAvailViewModels.Where(avail => avail.Platform122_Value == "No").Count();
                if (platform_122 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform122_Name);
                }
                var platform_123 = eachAvailViewModels.Where(avail => avail.Platform123_Value == "No").Count();
                if (platform_123 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform123_Name);
                }
                var platform_124 = eachAvailViewModels.Where(avail => avail.Platform124_Value == "No").Count();
                if (platform_124 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform124_Name);
                }
                var platform_125 = eachAvailViewModels.Where(avail => avail.Platform125_Value == "No").Count();
                if (platform_125 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform125_Name);
                }
                var platform_126 = eachAvailViewModels.Where(avail => avail.Platform126_Value == "No").Count();
                if (platform_126 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform126_Name);
                }
                var platform_127 = eachAvailViewModels.Where(avail => avail.Platform127_Value == "No").Count();
                if (platform_127 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform127_Name);
                }
                var platform_128 = eachAvailViewModels.Where(avail => avail.Platform128_Value == "No").Count();
                if (platform_128 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform128_Name);
                }
                var platform_129 = eachAvailViewModels.Where(avail => avail.Platform129_Value == "No").Count();
                if (platform_129 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform129_Name);
                }
                var platform_130 = eachAvailViewModels.Where(avail => avail.Platform130_Value == "No").Count();
                if (platform_130 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform130_Name);
                }
                var platform_131 = eachAvailViewModels.Where(avail => avail.Platform131_Value == "No").Count();
                if (platform_131 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform131_Name);
                }
                var platform_132 = eachAvailViewModels.Where(avail => avail.Platform132_Value == "No").Count();
                if (platform_132 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform132_Name);
                }
                var platform_133 = eachAvailViewModels.Where(avail => avail.Platform133_Value == "No").Count();
                if (platform_133 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform133_Name);
                }
                var platform_134 = eachAvailViewModels.Where(avail => avail.Platform134_Value == "No").Count();
                if (platform_134 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform134_Name);
                }
                var platform_135 = eachAvailViewModels.Where(avail => avail.Platform135_Value == "No").Count();
                if (platform_135 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform135_Name);
                }
                var platform_136 = eachAvailViewModels.Where(avail => avail.Platform136_Value == "No").Count();
                if (platform_136 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform136_Name);
                }
                var platform_137 = eachAvailViewModels.Where(avail => avail.Platform137_Value == "No").Count();
                if (platform_137 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform137_Name);
                }
                var platform_138 = eachAvailViewModels.Where(avail => avail.Platform138_Value == "No").Count();
                if (platform_138 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform138_Name);
                }
                var platform_139 = eachAvailViewModels.Where(avail => avail.Platform139_Value == "No").Count();
                if (platform_139 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform139_Name);
                }
                var platform_140 = eachAvailViewModels.Where(avail => avail.Platform140_Value == "No").Count();
                if (platform_140 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform140_Name);
                }
                var platform_141 = eachAvailViewModels.Where(avail => avail.Platform141_Value == "No").Count();
                if (platform_141 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform141_Name);
                }
                var platform_142 = eachAvailViewModels.Where(avail => avail.Platform142_Value == "No").Count();
                if (platform_142 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform142_Name);
                }
                var platform_143 = eachAvailViewModels.Where(avail => avail.Platform143_Value == "No").Count();
                if (platform_143 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform143_Name);
                }
                var platform_144 = eachAvailViewModels.Where(avail => avail.Platform144_Value == "No").Count();
                if (platform_144 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform144_Name);
                }
                var platform_145 = eachAvailViewModels.Where(avail => avail.Platform145_Value == "No").Count();
                if (platform_145 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform145_Name);
                }
                var platform_146 = eachAvailViewModels.Where(avail => avail.Platform146_Value == "No").Count();
                if (platform_146 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform146_Name);
                }
                var platform_147 = eachAvailViewModels.Where(avail => avail.Platform147_Value == "No").Count();
                if (platform_147 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform147_Name);
                }
                var platform_148 = eachAvailViewModels.Where(avail => avail.Platform148_Value == "No").Count();
                if (platform_148 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform148_Name);
                }
                var platform_149 = eachAvailViewModels.Where(avail => avail.Platform149_Value == "No").Count();
                if (platform_149 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform149_Name);
                }
                var platform_150 = eachAvailViewModels.Where(avail => avail.Platform150_Value == "No").Count();
                if (platform_150 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform150_Name);
                }
                var platform_151 = eachAvailViewModels.Where(avail => avail.Platform151_Value == "No").Count();
                if (platform_151 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform151_Name);
                }
                var platform_152 = eachAvailViewModels.Where(avail => avail.Platform152_Value == "No").Count();
                if (platform_152 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform152_Name);
                }
                var platform_153 = eachAvailViewModels.Where(avail => avail.Platform153_Value == "No").Count();
                if (platform_153 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform153_Name);
                }
                var platform_154 = eachAvailViewModels.Where(avail => avail.Platform154_Value == "No").Count();
                if (platform_154 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform154_Name);
                }
                var platform_155 = eachAvailViewModels.Where(avail => avail.Platform155_Value == "No").Count();
                if (platform_155 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform155_Name);
                }
                var platform_156 = eachAvailViewModels.Where(avail => avail.Platform156_Value == "No").Count();
                if (platform_156 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform156_Name);
                }
                var platform_157 = eachAvailViewModels.Where(avail => avail.Platform157_Value == "No").Count();
                if (platform_157 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform157_Name);
                }
                var platform_158 = eachAvailViewModels.Where(avail => avail.Platform158_Value == "No").Count();
                if (platform_158 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform158_Name);
                }
                var platform_159 = eachAvailViewModels.Where(avail => avail.Platform159_Value == "No").Count();
                if (platform_159 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform159_Name);
                }
                var platform_160 = eachAvailViewModels.Where(avail => avail.Platform160_Value == "No").Count();
                if (platform_160 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform160_Name);
                }
                var platform_161 = eachAvailViewModels.Where(avail => avail.Platform161_Value == "No").Count();
                if (platform_161 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform161_Name);
                }
                var platform_162 = eachAvailViewModels.Where(avail => avail.Platform162_Value == "No").Count();
                if (platform_162 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform162_Name);
                }
                var platform_163 = eachAvailViewModels.Where(avail => avail.Platform163_Value == "No").Count();
                if (platform_163 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform163_Name);
                }
                var platform_164 = eachAvailViewModels.Where(avail => avail.Platform164_Value == "No").Count();
                if (platform_164 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform164_Name);
                }
                var platform_165 = eachAvailViewModels.Where(avail => avail.Platform165_Value == "No").Count();
                if (platform_165 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform165_Name);
                }
                var platform_166 = eachAvailViewModels.Where(avail => avail.Platform166_Value == "No").Count();
                if (platform_166 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform166_Name);
                }
                var platform_167 = eachAvailViewModels.Where(avail => avail.Platform167_Value == "No").Count();
                if (platform_167 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform167_Name);
                }
                var platform_168 = eachAvailViewModels.Where(avail => avail.Platform168_Value == "No").Count();
                if (platform_168 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform168_Name);
                }
                var platform_169 = eachAvailViewModels.Where(avail => avail.Platform169_Value == "No").Count();
                if (platform_169 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform169_Name);
                }
                var platform_170 = eachAvailViewModels.Where(avail => avail.Platform170_Value == "No").Count();
                if (platform_170 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform170_Name);
                }
                var platform_171 = eachAvailViewModels.Where(avail => avail.Platform171_Value == "No").Count();
                if (platform_171 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform171_Name);
                }
                var platform_172 = eachAvailViewModels.Where(avail => avail.Platform172_Value == "No").Count();
                if (platform_172 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform172_Name);
                }
                var platform_173 = eachAvailViewModels.Where(avail => avail.Platform173_Value == "No").Count();
                if (platform_173 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform173_Name);
                }
                var platform_174 = eachAvailViewModels.Where(avail => avail.Platform174_Value == "No").Count();
                if (platform_174 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform174_Name);
                }
                var platform_175 = eachAvailViewModels.Where(avail => avail.Platform175_Value == "No").Count();
                if (platform_175 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform175_Name);
                }
                var platform_176 = eachAvailViewModels.Where(avail => avail.Platform176_Value == "No").Count();
                if (platform_176 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform176_Name);
                }
                var platform_177 = eachAvailViewModels.Where(avail => avail.Platform177_Value == "No").Count();
                if (platform_177 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform177_Name);
                }
                var platform_178 = eachAvailViewModels.Where(avail => avail.Platform178_Value == "No").Count();
                if (platform_178 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform178_Name);
                }
                var platform_179 = eachAvailViewModels.Where(avail => avail.Platform179_Value == "No").Count();
                if (platform_179 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform179_Name);
                }
                var platform_180 = eachAvailViewModels.Where(avail => avail.Platform180_Value == "No").Count();
                if (platform_180 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform180_Name);
                }
                var platform_181 = eachAvailViewModels.Where(avail => avail.Platform181_Value == "No").Count();
                if (platform_181 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform181_Name);
                }
                var platform_182 = eachAvailViewModels.Where(avail => avail.Platform182_Value == "No").Count();
                if (platform_182 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform182_Name);
                }
                var platform_183 = eachAvailViewModels.Where(avail => avail.Platform183_Value == "No").Count();
                if (platform_183 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform183_Name);
                }
                var platform_184 = eachAvailViewModels.Where(avail => avail.Platform184_Value == "No").Count();
                if (platform_184 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform184_Name);
                }
                var platform_185 = eachAvailViewModels.Where(avail => avail.Platform185_Value == "No").Count();
                if (platform_185 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform185_Name);
                }
                var platform_186 = eachAvailViewModels.Where(avail => avail.Platform186_Value == "No").Count();
                if (platform_186 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform186_Name);
                }
                var platform_187 = eachAvailViewModels.Where(avail => avail.Platform187_Value == "No").Count();
                if (platform_187 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform187_Name);
                }
                var platform_188 = eachAvailViewModels.Where(avail => avail.Platform188_Value == "No").Count();
                if (platform_188 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform188_Name);
                }
                var platform_189 = eachAvailViewModels.Where(avail => avail.Platform189_Value == "No").Count();
                if (platform_189 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform189_Name);
                }
                var platform_190 = eachAvailViewModels.Where(avail => avail.Platform190_Value == "No").Count();
                if (platform_190 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform190_Name);
                }
                var platform_191 = eachAvailViewModels.Where(avail => avail.Platform191_Value == "No").Count();
                if (platform_191 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform191_Name);
                }
                var platform_192 = eachAvailViewModels.Where(avail => avail.Platform192_Value == "No").Count();
                if (platform_192 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform192_Name);
                }
                var platform_193 = eachAvailViewModels.Where(avail => avail.Platform193_Value == "No").Count();
                if (platform_193 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform193_Name);
                }
                var platform_194 = eachAvailViewModels.Where(avail => avail.Platform194_Value == "No").Count();
                if (platform_194 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform194_Name);
                }
                var platform_195 = eachAvailViewModels.Where(avail => avail.Platform195_Value == "No").Count();
                if (platform_195 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform195_Name);
                }
                var platform_196 = eachAvailViewModels.Where(avail => avail.Platform196_Value == "No").Count();
                if (platform_196 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform196_Name);
                }
                var platform_197 = eachAvailViewModels.Where(avail => avail.Platform197_Value == "No").Count();
                if (platform_197 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform197_Name);
                }
                var platform_198 = eachAvailViewModels.Where(avail => avail.Platform198_Value == "No").Count();
                if (platform_198 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform198_Name);
                }
                var platform_199 = eachAvailViewModels.Where(avail => avail.Platform199_Value == "No").Count();
                if (platform_199 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform199_Name);
                }
                var platform_200 = eachAvailViewModels.Where(avail => avail.Platform200_Value == "No").Count();
                if (platform_200 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform200_Name);
                }
                var platform_201 = eachAvailViewModels.Where(avail => avail.Platform201_Value == "No").Count();
                if (platform_201 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform201_Name);
                }
                var platform_202 = eachAvailViewModels.Where(avail => avail.Platform202_Value == "No").Count();
                if (platform_202 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform202_Name);
                }
                var platform_203 = eachAvailViewModels.Where(avail => avail.Platform203_Value == "No").Count();
                if (platform_203 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform203_Name);
                }
                var platform_204 = eachAvailViewModels.Where(avail => avail.Platform204_Value == "No").Count();
                if (platform_204 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform204_Name);
                }
                var platform_205 = eachAvailViewModels.Where(avail => avail.Platform205_Value == "No").Count();
                if (platform_205 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform205_Name);
                }
                var platform_206 = eachAvailViewModels.Where(avail => avail.Platform206_Value == "No").Count();
                if (platform_206 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform206_Name);
                }
                var platform_207 = eachAvailViewModels.Where(avail => avail.Platform207_Value == "No").Count();
                if (platform_207 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform207_Name);
                }
                var platform_208 = eachAvailViewModels.Where(avail => avail.Platform208_Value == "No").Count();
                if (platform_208 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform208_Name);
                }
                var platform_209 = eachAvailViewModels.Where(avail => avail.Platform209_Value == "No").Count();
                if (platform_209 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform209_Name);
                }
                var platform_210 = eachAvailViewModels.Where(avail => avail.Platform210_Value == "No").Count();
                if (platform_210 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform210_Name);
                }
                var platform_211 = eachAvailViewModels.Where(avail => avail.Platform211_Value == "No").Count();
                if (platform_211 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform211_Name);
                }
                var platform_212 = eachAvailViewModels.Where(avail => avail.Platform212_Value == "No").Count();
                if (platform_212 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform212_Name);
                }
                var platform_213 = eachAvailViewModels.Where(avail => avail.Platform213_Value == "No").Count();
                if (platform_213 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform213_Name);
                }
                var platform_214 = eachAvailViewModels.Where(avail => avail.Platform214_Value == "No").Count();
                if (platform_214 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform214_Name);
                }
                var platform_215 = eachAvailViewModels.Where(avail => avail.Platform215_Value == "No").Count();
                if (platform_215 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform215_Name);
                }
                var platform_216 = eachAvailViewModels.Where(avail => avail.Platform216_Value == "No").Count();
                if (platform_216 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform216_Name);
                }
                var platform_217 = eachAvailViewModels.Where(avail => avail.Platform217_Value == "No").Count();
                if (platform_217 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform217_Name);
                }
                var platform_218 = eachAvailViewModels.Where(avail => avail.Platform218_Value == "No").Count();
                if (platform_218 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform218_Name);
                }
                var platform_219 = eachAvailViewModels.Where(avail => avail.Platform219_Value == "No").Count();
                if (platform_219 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform219_Name);
                }
                var platform_220 = eachAvailViewModels.Where(avail => avail.Platform220_Value == "No").Count();
                if (platform_220 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform220_Name);
                }
                var platform_221 = eachAvailViewModels.Where(avail => avail.Platform221_Value == "No").Count();
                if (platform_221 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform221_Name);
                }
                var platform_222 = eachAvailViewModels.Where(avail => avail.Platform222_Value == "No").Count();
                if (platform_222 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform222_Name);
                }
                var platform_223 = eachAvailViewModels.Where(avail => avail.Platform223_Value == "No").Count();
                if (platform_223 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform223_Name);
                }
                var platform_224 = eachAvailViewModels.Where(avail => avail.Platform224_Value == "No").Count();
                if (platform_224 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform224_Name);
                }
                var platform_225 = eachAvailViewModels.Where(avail => avail.Platform225_Value == "No").Count();
                if (platform_225 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform225_Name);
                }
                var platform_226 = eachAvailViewModels.Where(avail => avail.Platform226_Value == "No").Count();
                if (platform_226 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform226_Name);
                }
                var platform_227 = eachAvailViewModels.Where(avail => avail.Platform227_Value == "No").Count();
                if (platform_227 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform227_Name);
                }
                var platform_228 = eachAvailViewModels.Where(avail => avail.Platform228_Value == "No").Count();
                if (platform_228 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform228_Name);
                }
                var platform_229 = eachAvailViewModels.Where(avail => avail.Platform229_Value == "No").Count();
                if (platform_229 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform229_Name);
                }
                var platform_230 = eachAvailViewModels.Where(avail => avail.Platform230_Value == "No").Count();
                if (platform_230 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform230_Name);
                }
                var platform_231 = eachAvailViewModels.Where(avail => avail.Platform231_Value == "No").Count();
                if (platform_231 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform231_Name);
                }
                var platform_232 = eachAvailViewModels.Where(avail => avail.Platform232_Value == "No").Count();
                if (platform_232 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform232_Name);
                }
                var platform_233 = eachAvailViewModels.Where(avail => avail.Platform233_Value == "No").Count();
                if (platform_233 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform233_Name);
                }
                var platform_234 = eachAvailViewModels.Where(avail => avail.Platform234_Value == "No").Count();
                if (platform_234 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform234_Name);
                }
                var platform_235 = eachAvailViewModels.Where(avail => avail.Platform235_Value == "No").Count();
                if (platform_235 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform235_Name);
                }
                var platform_236 = eachAvailViewModels.Where(avail => avail.Platform236_Value == "No").Count();
                if (platform_236 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform236_Name);
                }
                var platform_237 = eachAvailViewModels.Where(avail => avail.Platform237_Value == "No").Count();
                if (platform_237 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform237_Name);
                }
                var platform_238 = eachAvailViewModels.Where(avail => avail.Platform238_Value == "No").Count();
                if (platform_238 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform238_Name);
                }
                var platform_239 = eachAvailViewModels.Where(avail => avail.Platform239_Value == "No").Count();
                if (platform_239 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform239_Name);
                }
                var platform_240 = eachAvailViewModels.Where(avail => avail.Platform240_Value == "No").Count();
                if (platform_240 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform240_Name);
                }
                var platform_241 = eachAvailViewModels.Where(avail => avail.Platform241_Value == "No").Count();
                if (platform_241 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform241_Name);
                }
                var platform_242 = eachAvailViewModels.Where(avail => avail.Platform242_Value == "No").Count();
                if (platform_242 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform242_Name);
                }
                var platform_243 = eachAvailViewModels.Where(avail => avail.Platform243_Value == "No").Count();
                if (platform_243 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform243_Name);
                }
                var platform_244 = eachAvailViewModels.Where(avail => avail.Platform244_Value == "No").Count();
                if (platform_244 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform244_Name);
                }
                var platform_245 = eachAvailViewModels.Where(avail => avail.Platform245_Value == "No").Count();
                if (platform_245 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform245_Name);
                }
                var platform_246 = eachAvailViewModels.Where(avail => avail.Platform246_Value == "No").Count();
                if (platform_246 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform246_Name);
                }
                var platform_247 = eachAvailViewModels.Where(avail => avail.Platform247_Value == "No").Count();
                if (platform_247 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform247_Name);
                }
                var platform_248 = eachAvailViewModels.Where(avail => avail.Platform248_Value == "No").Count();
                if (platform_248 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform248_Name);
                }
                var platform_249 = eachAvailViewModels.Where(avail => avail.Platform249_Value == "No").Count();
                if (platform_249 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform249_Name);
                }
                var platform_250 = eachAvailViewModels.Where(avail => avail.Platform250_Value == "No").Count();
                if (platform_250 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform250_Name);
                }
                var platform_251 = eachAvailViewModels.Where(avail => avail.Platform251_Value == "No").Count();
                if (platform_251 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform251_Name);
                }
                var platform_252 = eachAvailViewModels.Where(avail => avail.Platform252_Value == "No").Count();
                if (platform_252 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform252_Name);
                }
                var platform_253 = eachAvailViewModels.Where(avail => avail.Platform253_Value == "No").Count();
                if (platform_253 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform253_Name);
                }
                var platform_254 = eachAvailViewModels.Where(avail => avail.Platform254_Value == "No").Count();
                if (platform_254 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform254_Name);
                }
                var platform_255 = eachAvailViewModels.Where(avail => avail.Platform255_Value == "No").Count();
                if (platform_255 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform255_Name);
                }
                var platform_256 = eachAvailViewModels.Where(avail => avail.Platform256_Value == "No").Count();
                if (platform_256 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform256_Name);
                }
                var platform_257 = eachAvailViewModels.Where(avail => avail.Platform257_Value == "No").Count();
                if (platform_257 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform257_Name);
                }
                var platform_258 = eachAvailViewModels.Where(avail => avail.Platform258_Value == "No").Count();
                if (platform_258 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform258_Name);
                }
                var platform_259 = eachAvailViewModels.Where(avail => avail.Platform259_Value == "No").Count();
                if (platform_259 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform259_Name);
                }
                var platform_260 = eachAvailViewModels.Where(avail => avail.Platform260_Value == "No").Count();
                if (platform_260 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform260_Name);
                }
                var platform_261 = eachAvailViewModels.Where(avail => avail.Platform261_Value == "No").Count();
                if (platform_261 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform261_Name);
                }
                var platform_262 = eachAvailViewModels.Where(avail => avail.Platform262_Value == "No").Count();
                if (platform_262 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform262_Name);
                }
                var platform_263 = eachAvailViewModels.Where(avail => avail.Platform263_Value == "No").Count();
                if (platform_263 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform263_Name);
                }
                var platform_264 = eachAvailViewModels.Where(avail => avail.Platform264_Value == "No").Count();
                if (platform_264 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform264_Name);
                }
                var platform_265 = eachAvailViewModels.Where(avail => avail.Platform265_Value == "No").Count();
                if (platform_265 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform265_Name);
                }
                var platform_266 = eachAvailViewModels.Where(avail => avail.Platform266_Value == "No").Count();
                if (platform_266 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform266_Name);
                }
                var platform_267 = eachAvailViewModels.Where(avail => avail.Platform267_Value == "No").Count();
                if (platform_267 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform267_Name);
                }
                var platform_268 = eachAvailViewModels.Where(avail => avail.Platform268_Value == "No").Count();
                if (platform_268 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform268_Name);
                }
                var platform_269 = eachAvailViewModels.Where(avail => avail.Platform269_Value == "No").Count();
                if (platform_269 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform269_Name);
                }
                var platform_270 = eachAvailViewModels.Where(avail => avail.Platform270_Value == "No").Count();
                if (platform_270 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform270_Name);
                }
                var platform_271 = eachAvailViewModels.Where(avail => avail.Platform271_Value == "No").Count();
                if (platform_271 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform271_Name);
                }
                var platform_272 = eachAvailViewModels.Where(avail => avail.Platform272_Value == "No").Count();
                if (platform_272 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform272_Name);
                }
                var platform_273 = eachAvailViewModels.Where(avail => avail.Platform273_Value == "No").Count();
                if (platform_273 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform273_Name);
                }
                var platform_274 = eachAvailViewModels.Where(avail => avail.Platform274_Value == "No").Count();
                if (platform_274 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform274_Name);
                }
                var platform_275 = eachAvailViewModels.Where(avail => avail.Platform275_Value == "No").Count();
                if (platform_275 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform275_Name);
                }
                var platform_276 = eachAvailViewModels.Where(avail => avail.Platform276_Value == "No").Count();
                if (platform_276 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform276_Name);
                }
                var platform_277 = eachAvailViewModels.Where(avail => avail.Platform277_Value == "No").Count();
                if (platform_277 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform277_Name);
                }
                var platform_278 = eachAvailViewModels.Where(avail => avail.Platform278_Value == "No").Count();
                if (platform_278 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform278_Name);
                }
                var platform_279 = eachAvailViewModels.Where(avail => avail.Platform279_Value == "No").Count();
                if (platform_279 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform279_Name);
                }
                var platform_280 = eachAvailViewModels.Where(avail => avail.Platform280_Value == "No").Count();
                if (platform_280 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform280_Name);
                }
                var platform_281 = eachAvailViewModels.Where(avail => avail.Platform281_Value == "No").Count();
                if (platform_281 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform281_Name);
                }
                var platform_282 = eachAvailViewModels.Where(avail => avail.Platform282_Value == "No").Count();
                if (platform_282 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform282_Name);
                }
                var platform_283 = eachAvailViewModels.Where(avail => avail.Platform283_Value == "No").Count();
                if (platform_283 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform283_Name);
                }
                var platform_284 = eachAvailViewModels.Where(avail => avail.Platform284_Value == "No").Count();
                if (platform_284 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform284_Name);
                }
                var platform_285 = eachAvailViewModels.Where(avail => avail.Platform285_Value == "No").Count();
                if (platform_285 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform285_Name);
                }
                var platform_286 = eachAvailViewModels.Where(avail => avail.Platform286_Value == "No").Count();
                if (platform_286 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform286_Name);
                }
                var platform_287 = eachAvailViewModels.Where(avail => avail.Platform287_Value == "No").Count();
                if (platform_287 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform287_Name);
                }
                var platform_288 = eachAvailViewModels.Where(avail => avail.Platform288_Value == "No").Count();
                if (platform_288 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform288_Name);
                }
                var platform_289 = eachAvailViewModels.Where(avail => avail.Platform289_Value == "No").Count();
                if (platform_289 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform289_Name);
                }
                var platform_290 = eachAvailViewModels.Where(avail => avail.Platform290_Value == "No").Count();
                if (platform_290 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform290_Name);
                }
                var platform_291 = eachAvailViewModels.Where(avail => avail.Platform291_Value == "No").Count();
                if (platform_291 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform291_Name);
                }
                var platform_292 = eachAvailViewModels.Where(avail => avail.Platform292_Value == "No").Count();
                if (platform_292 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform292_Name);
                }
                var platform_293 = eachAvailViewModels.Where(avail => avail.Platform293_Value == "No").Count();
                if (platform_293 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform293_Name);
                }
                var platform_294 = eachAvailViewModels.Where(avail => avail.Platform294_Value == "No").Count();
                if (platform_294 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform294_Name);
                }
                var platform_295 = eachAvailViewModels.Where(avail => avail.Platform295_Value == "No").Count();
                if (platform_295 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform295_Name);
                }
                var platform_296 = eachAvailViewModels.Where(avail => avail.Platform296_Value == "No").Count();
                if (platform_296 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform296_Name);
                }
                var platform_297 = eachAvailViewModels.Where(avail => avail.Platform297_Value == "No").Count();
                if (platform_297 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform297_Name);
                }
                var platform_298 = eachAvailViewModels.Where(avail => avail.Platform298_Value == "No").Count();
                if (platform_298 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform298_Name);
                }
                var platform_299 = eachAvailViewModels.Where(avail => avail.Platform299_Value == "No").Count();
                if (platform_299 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform299_Name);
                }
                var platform_300 = eachAvailViewModels.Where(avail => avail.Platform300_Value == "No").Count();
                if (platform_300 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform300_Name);
                }
                var platform_301 = eachAvailViewModels.Where(avail => avail.Platform301_Value == "No").Count();
                if (platform_301 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform301_Name);
                }
                var platform_302 = eachAvailViewModels.Where(avail => avail.Platform302_Value == "No").Count();
                if (platform_302 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform302_Name);
                }
                var platform_303 = eachAvailViewModels.Where(avail => avail.Platform303_Value == "No").Count();
                if (platform_303 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform303_Name);
                }
                var platform_304 = eachAvailViewModels.Where(avail => avail.Platform304_Value == "No").Count();
                if (platform_304 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform304_Name);
                }
                var platform_305 = eachAvailViewModels.Where(avail => avail.Platform305_Value == "No").Count();
                if (platform_305 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform305_Name);
                }
                var platform_306 = eachAvailViewModels.Where(avail => avail.Platform306_Value == "No").Count();
                if (platform_306 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform306_Name);
                }
                var platform_307 = eachAvailViewModels.Where(avail => avail.Platform307_Value == "No").Count();
                if (platform_307 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform307_Name);
                }
                var platform_308 = eachAvailViewModels.Where(avail => avail.Platform308_Value == "No").Count();
                if (platform_308 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform308_Name);
                }

                var platform_309 = eachAvailViewModels.Where(avail => avail.Platform309_Value == "No").Count();
                if (platform_309 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform309_Name);
                }
                var platform_310 = eachAvailViewModels.Where(avail => avail.Platform310_Value == "No").Count();
                if (platform_310 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform310_Name);
                }
                var platform_311 = eachAvailViewModels.Where(avail => avail.Platform311_Value == "No").Count();
                if (platform_311 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform311_Name);
                }
                var platform_312 = eachAvailViewModels.Where(avail => avail.Platform312_Value == "No").Count();
                if (platform_312 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform312_Name);
                }
                var platform_313 = eachAvailViewModels.Where(avail => avail.Platform313_Value == "No").Count();
                if (platform_313 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform313_Name);
                }
                var platform_314 = eachAvailViewModels.Where(avail => avail.Platform314_Value == "No").Count();
                if (platform_314 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform314_Name);
                }
                var platform_315 = eachAvailViewModels.Where(avail => avail.Platform315_Value == "No").Count();
                if (platform_315 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform315_Name);
                }
                var platform_316 = eachAvailViewModels.Where(avail => avail.Platform316_Value == "No").Count();
                if (platform_316 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform316_Name);
                }
                var platform_317 = eachAvailViewModels.Where(avail => avail.Platform317_Value == "No").Count();
                if (platform_317 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform317_Name);
                }
                var platform_318 = eachAvailViewModels.Where(avail => avail.Platform318_Value == "No").Count();
                if (platform_318 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform318_Name);
                }
                var platform_319 = eachAvailViewModels.Where(avail => avail.Platform319_Value == "No").Count();
                if (platform_319 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform319_Name);
                }
                var platform_320 = eachAvailViewModels.Where(avail => avail.Platform320_Value == "No").Count();
                if (platform_320 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform320_Name);
                }
                var platform_321 = eachAvailViewModels.Where(avail => avail.Platform321_Value == "No").Count();
                if (platform_321 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform321_Name);

                }
                var platform_322 = eachAvailViewModels.Where(avail => avail.Platform322_Value == "No").Count();
                if (platform_322 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform322_Name);
                }
                var platform_323 = eachAvailViewModels.Where(avail => avail.Platform323_Value == "No").Count();
                if (platform_323 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform323_Name);
                }
                var platform_324 = eachAvailViewModels.Where(avail => avail.Platform324_Value == "No").Count();
                if (platform_324 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform324_Name);
                }
                var platform_325 = eachAvailViewModels.Where(avail => avail.Platform325_Value == "No").Count();
                if (platform_325 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform325_Name);
                }
                var platform_326 = eachAvailViewModels.Where(avail => avail.Platform326_Value == "No").Count();
                if (platform_326 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform326_Name);
                }
                var platform_327 = eachAvailViewModels.Where(avail => avail.Platform327_Value == "No").Count();
                if (platform_327 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform327_Name);
                }
                var platform_328 = eachAvailViewModels.Where(avail => avail.Platform328_Value == "No").Count();
                if (platform_328 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform328_Name);
                }
                var platform_329 = eachAvailViewModels.Where(avail => avail.Platform329_Value == "No").Count();
                if (platform_329 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform329_Name);
                }
                var platform_330 = eachAvailViewModels.Where(avail => avail.Platform330_Value == "No").Count();
                if (platform_330 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform330_Name);
                }
                var platform_331 = eachAvailViewModels.Where(avail => avail.Platform331_Value == "No").Count();
                if (platform_331 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform331_Name);
                }
                var platform_332 = eachAvailViewModels.Where(avail => avail.Platform332_Value == "No").Count();
                if (platform_332== totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform332_Name);
                }
                var platform_333 = eachAvailViewModels.Where(avail => avail.Platform333_Value == "No").Count();
                if (platform_333 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform333_Name);
                }
                var platform_334 = eachAvailViewModels.Where(avail => avail.Platform334_Value == "No").Count();
                if (platform_334 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform334_Name);
                }
                var platform_335 = eachAvailViewModels.Where(avail => avail.Platform335_Value == "No").Count();
                if (platform_335 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform335_Name);
                }
                var platform_336 = eachAvailViewModels.Where(avail => avail.Platform336_Value == "No").Count();
                if (platform_336 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform336_Name);
                }
                var platform_337 = eachAvailViewModels.Where(avail => avail.Platform337_Value == "No").Count();
                if (platform_337 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform337_Name);
                }
                var platform_338 = eachAvailViewModels.Where(avail => avail.Platform338_Value == "No").Count();
                if (platform_338 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform338_Name);
                }
                var platform_339 = eachAvailViewModels.Where(avail => avail.Platform339_Value == "No").Count();
                if (platform_339 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform339_Name);
                }
                var platform_340 = eachAvailViewModels.Where(avail => avail.Platform340_Value == "No").Count();
                if (platform_340 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform340_Name);
                }
                var platform_341 = eachAvailViewModels.Where(avail => avail.Platform341_Value == "No").Count();
                if (platform_341 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform341_Name);
                }
                var platform_342 = eachAvailViewModels.Where(avail => avail.Platform342_Value == "No").Count();
                if (platform_342 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform342_Name);
                }
                var platform_343 = eachAvailViewModels.Where(avail => avail.Platform343_Value == "No").Count();
                if (platform_343 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform343_Name);
                }
                var platform_344 = eachAvailViewModels.Where(avail => avail.Platform344_Value == "No").Count();
                if (platform_344 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform344_Name);
                }
                var platform_345 = eachAvailViewModels.Where(avail => avail.Platform345_Value == "No").Count();
                if (platform_345 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform345_Name);
                }
                var platform_346 = eachAvailViewModels.Where(avail => avail.Platform346_Value == "No").Count();
                if (platform_346 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform346_Name);
                }
                var platform_347 = eachAvailViewModels.Where(avail => avail.Platform347_Value == "No").Count();
                if (platform_347 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform347_Name);
                }
                var platform_348 = eachAvailViewModels.Where(avail => avail.Platform348_Value == "No").Count();
                if (platform_348 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform348_Name);
                }
                var platform_349 = eachAvailViewModels.Where(avail => avail.Platform349_Value == "No").Count();
                if (platform_349 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform349_Name);
                }

                var platform_350 = eachAvailViewModels.Where(avail => avail.Platform350_Value == "No").Count();
                if (platform_350 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform350_Name);
                }
                var platform_351 = eachAvailViewModels.Where(avail => avail.Platform351_Value == "No").Count();
                if (platform_351 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform351_Name);
                }
                var platform_352 = eachAvailViewModels.Where(avail => avail.Platform352_Value == "No").Count();
                if (platform_352 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform352_Name);
                }
                var platform_353 = eachAvailViewModels.Where(avail => avail.Platform353_Value == "No").Count();
                if (platform_353 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform353_Name);
                }
                var platform_354 = eachAvailViewModels.Where(avail => avail.Platform354_Value == "No").Count();
                if (platform_354 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform354_Name);
                }
                var platform_355 = eachAvailViewModels.Where(avail => avail.Platform355_Value == "No").Count();
                if (platform_355 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform355_Name);
                }
                var platform_356 = eachAvailViewModels.Where(avail => avail.Platform356_Value == "No").Count();
                if (platform_356 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform356_Name);
                }
                var platform_357 = eachAvailViewModels.Where(avail => avail.Platform357_Value == "No").Count();
                if (platform_357 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform357_Name);
                }
                var platform_358 = eachAvailViewModels.Where(avail => avail.Platform358_Value == "No").Count();
                if (platform_358 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform358_Name);
                }
                var platform_359 = eachAvailViewModels.Where(avail => avail.Platform359_Value == "No").Count();
                if (platform_359 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform359_Name);
                }
                var platform_360 = eachAvailViewModels.Where(avail => avail.Platform360_Value == "No").Count();
                if (platform_360 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform360_Name);
                }
                var platform_361 = eachAvailViewModels.Where(avail => avail.Platform361_Value == "No").Count();
                if (platform_361 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform361_Name);
                }
                var platform_362 = eachAvailViewModels.Where(avail => avail.Platform362_Value == "No").Count();
                if (platform_362 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform362_Name);
                }
                var platform_363 = eachAvailViewModels.Where(avail => avail.Platform363_Value == "No").Count();
                if (platform_363 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform363_Name);
                }
                var platform_364 = eachAvailViewModels.Where(avail => avail.Platform364_Value == "No").Count();
                if (platform_364 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform364_Name);
                }
                var platform_365 = eachAvailViewModels.Where(avail => avail.Platform365_Value == "No").Count();
                if (platform_365 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform365_Name);
                }
                var platform_366 = eachAvailViewModels.Where(avail => avail.Platform366_Value == "No").Count();
                if (platform_366 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform366_Name);
                }
                var platform_367 = eachAvailViewModels.Where(avail => avail.Platform367_Value == "No").Count();
                if (platform_367 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform367_Name);
                }
                var platform_368 = eachAvailViewModels.Where(avail => avail.Platform368_Value == "No").Count();
                if (platform_368 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform368_Name);
                }
                var platform_369 = eachAvailViewModels.Where(avail => avail.Platform369_Value == "No").Count();
                if (platform_369 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform369_Name);
                }
                var platform_370 = eachAvailViewModels.Where(avail => avail.Platform370_Value == "No").Count();
                if (platform_370 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform370_Name);
                }
                var platform_371 = eachAvailViewModels.Where(avail => avail.Platform371_Value == "No").Count();
                if (platform_371 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform371_Name);
                }
                var platform_372 = eachAvailViewModels.Where(avail => avail.Platform372_Value == "No").Count();
                if (platform_372 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform372_Name);
                }
                var platform_373 = eachAvailViewModels.Where(avail => avail.Platform373_Value == "No").Count();
                if (platform_373 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform373_Name);
                }
                var platform_374 = eachAvailViewModels.Where(avail => avail.Platform374_Value == "No").Count();
                if (platform_374 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform374_Name);
                }
                var platform_375 = eachAvailViewModels.Where(avail => avail.Platform375_Value == "No").Count();
                if (platform_375 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform375_Name);
                }
                var platform_376 = eachAvailViewModels.Where(avail => avail.Platform376_Value == "No").Count();
                if (platform_376 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform376_Name);
                }
                var platform_377 = eachAvailViewModels.Where(avail => avail.Platform377_Value == "No").Count();
                if (platform_377 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform377_Name);
                }
                var platform_378 = eachAvailViewModels.Where(avail => avail.Platform378_Value == "No").Count();
                if (platform_378 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform378_Name);
                }
                var platform_379 = eachAvailViewModels.Where(avail => avail.Platform379_Value == "No").Count();
                if (platform_379 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform379_Name);
                }
                var platform_380 = eachAvailViewModels.Where(avail => avail.Platform380_Value == "No").Count();
                if (platform_380 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform380_Name);
                }
                var platform_381 = eachAvailViewModels.Where(avail => avail.Platform381_Value == "No").Count();
                if (platform_381 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform381_Name);
                }
                var platform_382 = eachAvailViewModels.Where(avail => avail.Platform382_Value == "No").Count();
                if (platform_382 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform382_Name);
                }
                var platform_383 = eachAvailViewModels.Where(avail => avail.Platform383_Value == "No").Count();
                if (platform_383 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform383_Name);
                }
                var platform_384 = eachAvailViewModels.Where(avail => avail.Platform384_Value == "No").Count();
                if (platform_384 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform384_Name);
                }
                var platform_385 = eachAvailViewModels.Where(avail => avail.Platform385_Value == "No").Count();
                if (platform_385 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform385_Name);
                }
                var platform_386 = eachAvailViewModels.Where(avail => avail.Platform386_Value == "No").Count();
                if (platform_386 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform386_Name);
                }
                var platform_387 = eachAvailViewModels.Where(avail => avail.Platform387_Value == "No").Count();
                if (platform_387 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform387_Name);
                }
                var platform_388 = eachAvailViewModels.Where(avail => avail.Platform388_Value == "No").Count();
                if (platform_388 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform388_Name);
                }
                var platform_389 = eachAvailViewModels.Where(avail => avail.Platform389_Value == "No").Count();
                if (platform_389 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform389_Name);
                }
                var platform_390 = eachAvailViewModels.Where(avail => avail.Platform390_Value == "No").Count();
                if (platform_390 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform390_Name);
                }
                var platform_391 = eachAvailViewModels.Where(avail => avail.Platform391_Value == "No").Count();
                if (platform_391 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform391_Name);
                }
                var platform_392 = eachAvailViewModels.Where(avail => avail.Platform392_Value == "No").Count();
                if (platform_392 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform392_Name);
                }
                var platform_393 = eachAvailViewModels.Where(avail => avail.Platform393_Value == "No").Count();
                if (platform_393 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform393_Name);
                }
                var platform_394 = eachAvailViewModels.Where(avail => avail.Platform394_Value == "No").Count();
                if (platform_394 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform394_Name);
                }
                var platform_395 = eachAvailViewModels.Where(avail => avail.Platform395_Value == "No").Count();
                if (platform_395 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform395_Name);
                }
                var platform_396 = eachAvailViewModels.Where(avail => avail.Platform396_Value == "No").Count();
                if (platform_396 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform396_Name);
                }
                var platform_397 = eachAvailViewModels.Where(avail => avail.Platform397_Value == "No").Count();
                if (platform_397 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform397_Name);
                }
                var platform_398 = eachAvailViewModels.Where(avail => avail.Platform398_Value == "No").Count();
                if (platform_398 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform398_Name);
                }
                var platform_399 = eachAvailViewModels.Where(avail => avail.Platform399_Value == "No").Count();
                if (platform_399 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform399_Name);

                }
                var platform_400 = eachAvailViewModels.Where(avail => avail.Platform400_Value == "No").Count();
                if (platform_400 == totalAvailLines)
                {
                    platformsToBeSkipped.Add(eachAvailViewModels[0].Platform400_Name);
                }
                #endregion

                if (eachAvailViewModels.Count > 0)
                {
                    foreach (var platform in eachAvailViewModels[0].PlatformList)
                    {
                        bool skipCurrentPlatform = false;
                        if (searchAvailFilters.Platforms != null && searchAvailFilters.Platforms.Count > 0 && !searchAvailFilters.Platforms.Contains(platform.PlatformCode))
                        {
                            skipCurrentPlatform = true;
                        }

                        if (platformsToBeSkipped.Contains(platform.PlatformName))
                        {
                            skipCurrentPlatform = true;
                        }

                        if (!skipCurrentPlatform)
                        {
                            excelWorksheet.Cells[1, ++columnCounter].Value = platform.PlatformName;
                        }
                        index++;
                    }
                }
                #endregion

                excelWorksheet.Cells[1, ++columnCounter].Value = "Restriction Remark";

                //excelWorksheet.Cells[1, ++columnCounter].Value = "Sub Deal Restriction Remark";

                excelWorksheet.Cells[1, ++columnCounter].Value = "Remarks";

                excelWorksheet.Cells[1, ++columnCounter].Value = "Rights Remarks";

                #region populate all remaining rows

                // Inserting the data into excel 
                // sheet by using the for each loop 
                // As we have values to the first row  
                // we will start with second row 
                int recordIndex = 2;

                foreach (var eachAvailViewModel in eachAvailViewModels)
                {
                    //reset column counter
                    columnCounter = 0;

                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.TitleName;
                    if (Convert.ToInt32(module) == 247)
                    {
                        excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.EpisodeFrom;
                        excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.EpisodeTo;
                    }

                    //TODO: logic for color codes
                    //START:
                    string input = eachAvailViewModel.Country;
                    bool colorCodingRemoved = false;
                    ++columnCounter;
                    while (!colorCodingRemoved)
                    {
                        int indexSpan = input.IndexOf("<span");
                        if (indexSpan > 0)
                        {
                            string content = input.Substring(0, indexSpan);
                            //content = " " + content + " ";
                            var rt1 = excelWorksheet.Cells[recordIndex, columnCounter].RichText.Add(content);
                            rt1.Color = Color.Gray;
                            rt1.PreserveSpace = true;
                            input = input.Substring(indexSpan, input.Length - indexSpan);
                        }
                        else
                        if (indexSpan > -1)
                        {
                            string color = input.Substring(indexSpan + 19, 3);
                            switch (color.ToUpper())
                            {
                                case "RED":
                                    int indexSpanEnd = input.IndexOf("</span");
                                    string content = input.Substring(indexSpan + 25, indexSpanEnd - (indexSpan + 25));
                                    //content = " " + content + " ";
                                    var rt2 = excelWorksheet.Cells[recordIndex, columnCounter].RichText.Add(content);
                                    rt2.Color = Color.Red;
                                    rt2.PreserveSpace = true;
                                    //excelWorksheet.Cells[recordIndex, columnCounter].RichText.Add("_").Color = Color.White;
                                    input = input.Substring(indexSpanEnd + 7);
                                    break;
                                case "GRE":
                                    indexSpanEnd = input.IndexOf("</span");
                                    content = input.Substring(indexSpan + 27, indexSpanEnd - (indexSpan + 27));
                                    //content = " " + content + " ";
                                    var rt3 = excelWorksheet.Cells[recordIndex, columnCounter].RichText.Add(content);
                                    rt3.Color = Color.Green;
                                    rt3.PreserveSpace = true;
                                    //excelWorksheet.Cells[recordIndex, columnCounter].RichText.Add("_").Color = Color.White;
                                    input = input.Substring(indexSpanEnd + 7);
                                    break;
                                case "BLU":
                                    indexSpanEnd = input.IndexOf("</span");
                                    content = input.Substring(indexSpan + 26, indexSpanEnd - (indexSpan + 26));
                                    //content = " " + content + " ";
                                    var rt4 = excelWorksheet.Cells[recordIndex, columnCounter].RichText.Add(content);
                                    rt4.Color = Color.Blue;
                                    rt4.PreserveSpace = true;
                                    //excelWorksheet.Cells[recordIndex, columnCounter].RichText.Add("_").Color = Color.White;
                                    input = input.Substring(indexSpanEnd + 7);
                                    break;
                                default:
                                    break;
                            }
                        }
                        else
                        {
                            colorCodingRemoved = true;
                        }
                    }
                    //END:

                    //excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.Country;

                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.StartDate;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.EndDate;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.Exclusive;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.SubLicense;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.Genre;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.StarCast;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.ReleaseYear;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.Director;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.Duration;
                    if (searchAvailFilters.Others.IsTitleLanguage)
                        excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.LanguageName;

                    if (searchAvailFilters.SubTitles != null && searchAvailFilters.SubTitles.Count > 0)
                    {
                        excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.SubTiltling;
                    }

                    if (searchAvailFilters.Dubbings != null && searchAvailFilters.Dubbings.Count > 0)
                    {
                        excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.Dubbing;
                    }

                    #region platform matrix implementation
                    index = 1;

                    foreach (var platform in eachAvailViewModel.PlatformList)
                    {
                        bool skipCurrentPlatform = false;
                        if (searchAvailFilters.Platforms != null && searchAvailFilters.Platforms.Count > 0 && !searchAvailFilters.Platforms.Contains(platform.PlatformCode))
                        {
                            skipCurrentPlatform = true;
                        }

                        if (platformsToBeSkipped.Contains(platform.PlatformName))
                        {
                            skipCurrentPlatform = true;
                        }

                        if (!skipCurrentPlatform)
                        {
                            excelWorksheet.Cells[recordIndex, ++columnCounter].Value = GetPropertyValue(eachAvailViewModel, "Platform" + index + "_Value");
                            //excelWorksheet.Cells[recordIndex, ++columnCounter].Value = "Platform" + index + "_Value";
                        }
                        index++;
                    }
                    #endregion

                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.RestrictionRemarks;
                    //excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.SubDealRestrictionRemarks;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.Remarks;
                    excelWorksheet.Cells[recordIndex, ++columnCounter].Value = eachAvailViewModel.RightsRemarks;

                    recordIndex++;
                }

                //// By default, the column width is not  
                //// set to auto fit for the content 
                //// of the range, so we are using 
                //// AutoFit() method here.  
                //workSheet.Column(1).AutoFit();
                //workSheet.Column(2).AutoFit();
                //workSheet.Column(3).AutoFit();

                //excelWorksheet.Cells["C5"].Value = " This is an ";

                #endregion

                #region poc code
                //excelWorksheet.Column(1).Width = 15;
                //excelWorksheet.Column(2).Width = 25;
                //excelWorksheet.Column(3).Width = 20;

                //excelWorksheet.Cells["B2"].Value = "Emp No ";
                //excelWorksheet.Cells["B2"].Style.Font.Bold = true;
                //excelWorksheet.Cells["C2"].Value = "777";

                //excelWorksheet.Cells["C2"].Style.Font.Color.SetColor(Color.FromArgb(0, 112, 192));
                //excelWorksheet.Cells["C2"].Style.Font.Bold = true;
                //excelWorksheet.Cells["C2"].Style.Font.Size = 14;

                //excelWorksheet.Cells["B3"].Value = "Name";
                //excelWorksheet.Cells["B3"].Style.Font.Bold = true;
                //excelWorksheet.Cells["C3"].Value = "My Name";
                //excelWorksheet.Cells["C3"].Style.WrapText = true;
                //excelWorksheet.Cells["C3:G3"].Merge = true;

                //excelWorksheet.Cells["C3"].Style.Font.Color.SetColor(Color.FromArgb(0, 112, 192));
                //excelWorksheet.Cells["C3"].Style.Font.Bold = true;
                //excelWorksheet.Cells["C3"].Style.Font.Size = 14;

                //excelWorksheet.Cells["B1:G2"].Style.WrapText = true;

                //excelWorksheet.Cells["C3"].IsRichText = true;

                //var rtDir1 = excelWorksheet.Cells["C3"].RichText.Add(" is Karthi.");
                //rtDir1.Color = Color.Red;

                //// Set two colors for different text in same cell
                //excelWorksheet.Cells["C5"].Value = " This is an ";
                //excelWorksheet.Cells["C5"].Style.WrapText = true;
                //excelWorksheet.Cells["C5"].IsRichText = true;
                //excelWorksheet.Cells["C5"].Style.Font.Bold = true;
                //excelWorksheet.Cells["C5"].Style.Font.Size = 12;
                //excelWorksheet.Cells["C5"].Style.Font.Color.SetColor(Color.FromArgb(0, 112, 192));

                //excelWorksheet.Cells["C5"].RichText.Add("Hello").Color = Color.Red;
                //excelWorksheet.Cells["C5"].RichText.Add("Bollo").Color = Color.Blue;
                //excelWorksheet.Cells["C5"].RichText.Add("Kuch Nahi").Color = Color.Green;

                //excelWorksheet.Cells["B1:G2"].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                //excelWorksheet.Cells["B1:G2"].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                //excelWorksheet.Cells["B1:G2"].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                //excelWorksheet.Cells["B1:G2"].Style.Border.Right.Style = ExcelBorderStyle.Thin;

                //var CellVal = excelWorksheet.Cells["C1"].RichText;

                //var part = CellVal.Add("A");
                //part.Color = Color.Blue;
                #endregion
            }
            else
            {
                //int columnCounter = 0;
                excelWorksheet.Cells["A1:F1"].Merge = true;
                excelWorksheet.Cells["A1:F1"].Value = "No Availability records found for the filters selected.";
                //excelWorksheet.Cells[1, ++columnCounter].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                //excelWorksheet.Cells[1, ++columnCounter].Style.WrapText = false;
            }
        }

        private void AddRecordsCriteria(ExcelWorksheet excelWorksheet, SearchAvailFilters searchAvailFilters, CriteriaFilters criteriaFilters)
        {
            if (Convert.ToInt32(module) == 247)
            {
                #region shows criteria
                excelWorksheet.Column(1).Width = 25;
                excelWorksheet.Column(2).Width = 2;
                excelWorksheet.Column(3).Width = 80;

                using (ExcelRange range = excelWorksheet.Cells[1, 1, 33, 1])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[1, 3, 33, 3])
                {
                    range.Style.WrapText = true;
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[1, 2, 9, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[1, 3, 10, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A11:C11"].Merge = true;
                excelWorksheet.Cells["A11:C11"].Value = "Region";
                excelWorksheet.Cells["A11:C11"].Style.Font.Bold = true;
                excelWorksheet.Cells["A11:C11"].Style.Font.Size = 12;
                excelWorksheet.Cells["A11:C11"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                using (ExcelRange range = excelWorksheet.Cells[12, 2, 15, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[12, 3, 16, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A17:C17"].Merge = true;
                excelWorksheet.Cells["A17:C17"].Value = "Platform";
                excelWorksheet.Cells["A17:C17"].Style.Font.Bold = true;
                excelWorksheet.Cells["A17:C17"].Style.Font.Size = 12;
                excelWorksheet.Cells["A17:C17"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                using (ExcelRange range = excelWorksheet.Cells[18, 2, 21, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[18, 3, 22, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A23:C23"].Merge = true;
                excelWorksheet.Cells["A23:C23"].Value = "Platform";
                excelWorksheet.Cells["A23:C23"].Style.Font.Bold = true;
                excelWorksheet.Cells["A23:C23"].Style.Font.Size = 12;
                excelWorksheet.Cells["A23:C23"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                using (ExcelRange range = excelWorksheet.Cells[24, 2, 27, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[24, 3, 28, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A29:C29"].Merge = true;
                excelWorksheet.Cells["A29:C29"].Value = "Platform";
                excelWorksheet.Cells["A29:C29"].Style.Font.Bold = true;
                excelWorksheet.Cells["A29:C29"].Style.Font.Size = 12;
                excelWorksheet.Cells["A29:C29"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                using (ExcelRange range = excelWorksheet.Cells[30, 2, 32, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[30, 3, 33, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A1"].Value = "Titles";
                excelWorksheet.Cells["A2"].Value = "Episode From";
                excelWorksheet.Cells["A3"].Value = "Episode To";
                excelWorksheet.Cells["A4"].Value = "Period Available";
                excelWorksheet.Cells["A5"].Value = "Exclusivity";
                excelWorksheet.Cells["A6"].Value = "Title Language";
                excelWorksheet.Cells["A7"].Value = "IFTA Cluster";
                excelWorksheet.Cells["A8"].Value = "Created By";
                excelWorksheet.Cells["A9"].Value = "Created On";

                excelWorksheet.Cells["A11"].Value = "Region";

                excelWorksheet.Cells["A12"].Value = "Territory";
                excelWorksheet.Cells["A13"].Value = "Countries";
                excelWorksheet.Cells["A14"].Value = "Must Have";
                excelWorksheet.Cells["A15"].Value = "Exact Match";

                excelWorksheet.Cells["A17"].Value = "Platform";

                excelWorksheet.Cells["A18"].Value = "Group";
                excelWorksheet.Cells["A19"].Value = "Platforms";
                excelWorksheet.Cells["A20"].Value = "Must Have";
                excelWorksheet.Cells["A21"].Value = "Exact Match";

                excelWorksheet.Cells["A23"].Value = "Subtitling";

                excelWorksheet.Cells["A24"].Value = "Group";
                excelWorksheet.Cells["A25"].Value = "Languages";
                excelWorksheet.Cells["A26"].Value = "Must Have";
                excelWorksheet.Cells["A27"].Value = "Exact Match";

                excelWorksheet.Cells["A29"].Value = "Dubbing";

                excelWorksheet.Cells["A30"].Value = "Group";
                excelWorksheet.Cells["A31"].Value = "Languages";
                excelWorksheet.Cells["A32"].Value = "Must Have";
                excelWorksheet.Cells["A33"].Value = "Exact Match";


                excelWorksheet.Cells["C1"].Value = criteriaFilters.Titles;
                excelWorksheet.Cells["C2"].Value = criteriaFilters.EpisodeFrom;
                excelWorksheet.Cells["C3"].Value = criteriaFilters.EpisodeTo;
                excelWorksheet.Cells["C4"].Value = criteriaFilters.PeriodAvailable;
                excelWorksheet.Cells["C5"].Value = criteriaFilters.Exclusivity;
                excelWorksheet.Cells["C6"].Value = criteriaFilters.TitleLanguage;
                excelWorksheet.Cells["C7"].Value = criteriaFilters.IFTACluster;
                excelWorksheet.Cells["C8"].Value = objLoginUser.Login_Name;
                excelWorksheet.Cells["C9"].Value = criteriaFilters.CreatedOn;

                //excelWorksheet.Cells["C9"].Value = "Region";

                excelWorksheet.Cells["C12"].Value = criteriaFilters.Region_Territory == "" ? "NA" : criteriaFilters.Region_Territory;
                excelWorksheet.Cells["C13"].Value = criteriaFilters.Region_Countries == "" ? "NA" : criteriaFilters.Region_Countries;
                excelWorksheet.Cells["C14"].Value = criteriaFilters.Region_MustHave;
                excelWorksheet.Cells["C15"].Value = criteriaFilters.Region_ExactMatch;

                //excelWorksheet.Cells["C15"].Value = "Platform";

                excelWorksheet.Cells["C18"].Value = criteriaFilters.Platform_Group == "" ? "NA" : criteriaFilters.Platform_Group;
                excelWorksheet.Cells["C19"].Value = criteriaFilters.Platform_Platforms == "" ? "NA" : criteriaFilters.Platform_Platforms;
                excelWorksheet.Cells["C20"].Value = criteriaFilters.Platform_MustHave;
                excelWorksheet.Cells["C21"].Value = criteriaFilters.Platform_ExactMatch;

                //excelWorksheet.Cells["C21"].Value = "Subtitling";

                excelWorksheet.Cells["C24"].Value = criteriaFilters.Subtitling_Group == "" ? "NA" : criteriaFilters.Subtitling_Group;
                excelWorksheet.Cells["C25"].Value = criteriaFilters.Subtitling_Languages == "" ? "NA" : criteriaFilters.Subtitling_Languages;
                excelWorksheet.Cells["C26"].Value = criteriaFilters.Subtitling_MustHave;
                excelWorksheet.Cells["C27"].Value = criteriaFilters.Subtitling_ExactMatch;

                //excelWorksheet.Cells["C27"].Value = "Dubbing";

                excelWorksheet.Cells["C30"].Value = criteriaFilters.Dubbing_Group == "" ? "NA" : criteriaFilters.Dubbing_Group;
                excelWorksheet.Cells["C31"].Value = criteriaFilters.Dubbing_Languages == "" ? "NA" : criteriaFilters.Dubbing_Languages;
                excelWorksheet.Cells["C32"].Value = criteriaFilters.Dubbing_MustHave;
                excelWorksheet.Cells["C33"].Value = criteriaFilters.Dubbing_ExactMatch;
                #endregion
            }
            else
            {
                #region movies criteria
                excelWorksheet.Column(1).Width = 25;
                excelWorksheet.Column(2).Width = 2;
                excelWorksheet.Column(3).Width = 80;

                using (ExcelRange range = excelWorksheet.Cells[1, 1, 31, 1])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[1, 3, 31, 3])
                {
                    range.Style.WrapText = true;
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[1, 2, 7, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[1, 3, 8, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A9:C9"].Merge = true;
                excelWorksheet.Cells["A9:C9"].Value = "Region";
                excelWorksheet.Cells["A9:C9"].Style.Font.Bold = true;
                excelWorksheet.Cells["A9:C9"].Style.Font.Size = 12;
                excelWorksheet.Cells["A9:C9"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                using (ExcelRange range = excelWorksheet.Cells[10, 2, 13, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[10, 3, 14, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A15:C15"].Merge = true;
                excelWorksheet.Cells["A15:C15"].Value = "Platform";
                excelWorksheet.Cells["A15:C15"].Style.Font.Bold = true;
                excelWorksheet.Cells["A15:C15"].Style.Font.Size = 12;
                excelWorksheet.Cells["A15:C15"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                using (ExcelRange range = excelWorksheet.Cells[16, 2, 19, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[16, 3, 20, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A21:C21"].Merge = true;
                excelWorksheet.Cells["A21:C21"].Value = "Platform";
                excelWorksheet.Cells["A21:C21"].Style.Font.Bold = true;
                excelWorksheet.Cells["A21:C21"].Style.Font.Size = 12;
                excelWorksheet.Cells["A21:C21"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                using (ExcelRange range = excelWorksheet.Cells[22, 2, 25, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[22, 3, 26, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A27:C27"].Merge = true;
                excelWorksheet.Cells["A27:C27"].Value = "Platform";
                excelWorksheet.Cells["A27:C27"].Style.Font.Bold = true;
                excelWorksheet.Cells["A27:C27"].Style.Font.Size = 12;
                excelWorksheet.Cells["A27:C27"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;

                using (ExcelRange range = excelWorksheet.Cells[28, 2, 31, 2])
                {
                    range.Value = ":";
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = true;
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.General;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                using (ExcelRange range = excelWorksheet.Cells[28, 3, 31, 3])
                {
                    range.Style.Font.Size = 12;
                    range.Style.Font.Bold = false;
                }

                excelWorksheet.Cells["A1"].Value = "Titles";
                excelWorksheet.Cells["A2"].Value = "Period Available";
                excelWorksheet.Cells["A3"].Value = "Exclusivity";
                excelWorksheet.Cells["A4"].Value = "Title Language";
                excelWorksheet.Cells["A5"].Value = "IFTA Cluster";
                excelWorksheet.Cells["A6"].Value = "Created By";
                excelWorksheet.Cells["A7"].Value = "Created On";

                excelWorksheet.Cells["A9"].Value = "Region";

                excelWorksheet.Cells["A10"].Value = "Territory";
                excelWorksheet.Cells["A11"].Value = "Countries";
                excelWorksheet.Cells["A12"].Value = "Must Have";
                excelWorksheet.Cells["A13"].Value = "Exact Match";

                excelWorksheet.Cells["A15"].Value = "Platform";

                excelWorksheet.Cells["A16"].Value = "Group";
                excelWorksheet.Cells["A17"].Value = "Platforms";
                excelWorksheet.Cells["A18"].Value = "Must Have";
                excelWorksheet.Cells["A19"].Value = "Exact Match";

                excelWorksheet.Cells["A21"].Value = "Subtitling";

                excelWorksheet.Cells["A22"].Value = "Group";
                excelWorksheet.Cells["A23"].Value = "Languages";
                excelWorksheet.Cells["A24"].Value = "Must Have";
                excelWorksheet.Cells["A25"].Value = "Exact Match";

                excelWorksheet.Cells["A27"].Value = "Dubbing";

                excelWorksheet.Cells["A28"].Value = "Group";
                excelWorksheet.Cells["A29"].Value = "Languages";
                excelWorksheet.Cells["A30"].Value = "Must Have";
                excelWorksheet.Cells["A31"].Value = "Exact Match";


                excelWorksheet.Cells["C1"].Value = criteriaFilters.Titles;
                excelWorksheet.Cells["C2"].Value = criteriaFilters.PeriodAvailable;
                excelWorksheet.Cells["C3"].Value = criteriaFilters.Exclusivity;
                excelWorksheet.Cells["C4"].Value = criteriaFilters.TitleLanguage;
                excelWorksheet.Cells["C5"].Value = criteriaFilters.IFTACluster;
                excelWorksheet.Cells["C6"].Value = objLoginUser.Login_Name;
                excelWorksheet.Cells["C7"].Value = criteriaFilters.CreatedOn;

                //excelWorksheet.Cells["C9"].Value = "Region";

                excelWorksheet.Cells["C10"].Value = criteriaFilters.Region_Territory == "" ? "NA" : criteriaFilters.Region_Territory;
                excelWorksheet.Cells["C11"].Value = criteriaFilters.Region_Countries == "" ? "NA" : criteriaFilters.Region_Countries;
                excelWorksheet.Cells["C12"].Value = criteriaFilters.Region_MustHave;
                excelWorksheet.Cells["C13"].Value = criteriaFilters.Region_ExactMatch;

                //excelWorksheet.Cells["C15"].Value = "Platform";

                excelWorksheet.Cells["C16"].Value = criteriaFilters.Platform_Group == "" ? "NA" : criteriaFilters.Platform_Group;
                excelWorksheet.Cells["C17"].Value = criteriaFilters.Platform_Platforms == "" ? "NA" : criteriaFilters.Platform_Platforms;
                excelWorksheet.Cells["C18"].Value = criteriaFilters.Platform_MustHave;
                excelWorksheet.Cells["C19"].Value = criteriaFilters.Platform_ExactMatch;

                //excelWorksheet.Cells["C21"].Value = "Subtitling";

                excelWorksheet.Cells["C22"].Value = criteriaFilters.Subtitling_Group == "" ? "NA" : criteriaFilters.Subtitling_Group;
                excelWorksheet.Cells["C23"].Value = criteriaFilters.Subtitling_Languages == "" ? "NA" : criteriaFilters.Subtitling_Languages;
                excelWorksheet.Cells["C24"].Value = criteriaFilters.Subtitling_MustHave;
                excelWorksheet.Cells["C25"].Value = criteriaFilters.Subtitling_ExactMatch;

                //excelWorksheet.Cells["C27"].Value = "Dubbing";

                excelWorksheet.Cells["C28"].Value = criteriaFilters.Dubbing_Group == "" ? "NA" : criteriaFilters.Dubbing_Group;
                excelWorksheet.Cells["C29"].Value = criteriaFilters.Dubbing_Languages == "" ? "NA" : criteriaFilters.Dubbing_Languages;
                excelWorksheet.Cells["C30"].Value = criteriaFilters.Dubbing_MustHave;
                excelWorksheet.Cells["C31"].Value = criteriaFilters.Dubbing_ExactMatch;
                #endregion

            }
        }

        private object GetPropertyValue(object avail, string propertyName)
        {
            return avail.GetType().GetProperties()
               .Single(pi => pi.Name == propertyName)
               .GetValue(avail, null);
        }

        private ReportViewer BindReport(ReportParameter[] parm, string ReportName)
        {
            ReportViewer rptViewer = new ReportViewer();
            rptViewer.ShowParameterPrompts = false;
            ReportCredential(rptViewer);
            rptViewer.ServerReport.ReportPath = string.Empty;
            if (rptViewer.ServerReport.ReportPath == "")
            {
                UTOFrameWork.FrameworkClasses.ReportSetting objRS = new UTOFrameWork.FrameworkClasses.ReportSetting();
                rptViewer.ServerReport.ReportPath = objRS.GetReport(ReportName);
            }
            rptViewer.Visible = true;
            rptViewer.ProcessingMode = ProcessingMode.Remote;
            rptViewer.ServerReport.SetParameters(parm);
            rptViewer.ServerReport.Refresh();

            return rptViewer;
        }

        public void ReportCredential(ReportViewer rptViewer)
        {
            var rptCredetialList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

            string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
            string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

            if (IsCredentialRequired.ToUpper() == "TRUE")
            {
                string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
                string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
                string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];
                rptViewer.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
            }

            if (rptViewer.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
                rptViewer.ServerReport.ReportServerUrl = new Uri(ReportingServer);
        }

        #endregion

        #region------------Save Report Function------------------

        public JsonResult SaveReport(string strInsertVal, string ReportName, string Visibility, int BU_Code, int recordPerPage, string episodeFrom, string episodeTo, string tabNameInSaveQuery,
            string[] titleCodes, string platformCodes, string Country_Code,
        string isOriginalLang, string rblPeriodType, string Dubbing_Subtitling,
        string Title_Language_Code, string ExcactMatch_Platform, string[] Exclusivity,
        string sublicList, string chkExactMatch, string ddlMustHaveCountry,
        string ddlListCountry, string Subtitling_Codes, string Dubbing_Codes,
        string chkDigital, string chkRestRemarks,
        string chkOtherRemarks, string MustHave_Platform_Codes, string chkMetaData,
        string chkIFTACluster, string chkCountryLevel, string txtfrom, string txtto, string pfGroupCode, string LangGroup_Sub, string chkExactMatch_Sub,
        string MustHave_Subtitle_Codes, string ddlListLanguageGroup, string LangGroup_Dub, string chkExactMatch_Dub, string MustHave_Dubbing_Codes,
        string ddlListLanguageGroup_Dub, string Territory_Code, string tabName, string IncludeAncillary, string promoterCodes,
        string ExcactMatch_Promoter, string MustHave_Promoter_Codes)
        {
            if (tabNameInSaveQuery == "check")
                tabNameInSaveQuery = "IF";
            string Right_Level = "";
            if (ContryLevelRights == true && TerritoryLevelRights == true)
                Right_Level = "B";
            else if (ContryLevelRights)
                Right_Level = "C";
            else
                Right_Level = "T";

            int pageSize = RcCount;
            int RecordCount = 0;
            string isPaging = "Y";
            int pageNo = 1;
            string strFilter = "";
            string IsDuplicate = "";

            string IsExclusivity = string.Join(",", Exclusivity);

            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            ObjectParameter objRecordCountSave = new ObjectParameter("RecordCount", 10);

            strInsertVal = strInsertVal.Replace("PU", Visibility);

            if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {
                strInsertVal = strInsertVal + "," + "'" + episodeFrom + "'" + "," + "'" + episodeTo + "'";
                //strInsertVal +","+"'"+ 'x'+"'"
            }
            if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                strInsertVal = strInsertVal + "," + "'" + 'Y' + "'";

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
                strInsertVal = strInsertVal + "," + "'" + "N" + "'";

            if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString())
                strInsertVal = strInsertVal + "," + "'" + "" + "'";
            else
                strInsertVal = strInsertVal + "," + "'" + tabNameInSaveQuery + "'";
            string startDate = Convert.ToDateTime(txtfrom).ToString("yyyy-MM-dd");
            string endDate = "";
            if (txtto == "")
            {
                endDate = "";
            }
            else
            {
                endDate = Convert.ToDateTime(txtto).ToString("yyyy-MM-dd");
            }
            string platform_codes = Country_Code;
            string Country_Codes = platformCodes;
            List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
            Avail_Report_Schedule_UDT objAvail_Report_Schedule_UDT = new Avail_Report_Schedule_UDT();
            objAvail_Report_Schedule_UDT.Title_Code = string.Join(",", titleCodes);
            objAvail_Report_Schedule_UDT.Platform_Code = platform_codes;
            objAvail_Report_Schedule_UDT.Country_Code = Country_Codes;
            objAvail_Report_Schedule_UDT.Is_Original_Language = isOriginalLang;
            objAvail_Report_Schedule_UDT.Dubbing_Subtitling = Dubbing_Subtitling;
            objAvail_Report_Schedule_UDT.Language_Code = Title_Language_Code;
            objAvail_Report_Schedule_UDT.Date_Type = rblPeriodType;
            objAvail_Report_Schedule_UDT.StartDate = startDate;
            objAvail_Report_Schedule_UDT.EndDate = endDate;
            objAvail_Report_Schedule_UDT.UserCode = objLoginUser.Users_Code;
            objAvail_Report_Schedule_UDT.Inserted_On = System.DateTime.Now;
            objAvail_Report_Schedule_UDT.Report_Status = "Y";
            objAvail_Report_Schedule_UDT.Visibility = Visibility;
            objAvail_Report_Schedule_UDT.ReportName = ReportName;
            objAvail_Report_Schedule_UDT.RestrictionRemark = chkRestRemarks;
            objAvail_Report_Schedule_UDT.OtherRemark = chkOtherRemarks;
            objAvail_Report_Schedule_UDT.Platform_ExactMatch = ExcactMatch_Platform;
            objAvail_Report_Schedule_UDT.MustHave_Platform = MustHave_Platform_Codes;
            objAvail_Report_Schedule_UDT.Exclusivity = IsExclusivity;
            objAvail_Report_Schedule_UDT.SubLicenseCode = sublicList;
            objAvail_Report_Schedule_UDT.Region_ExactMatch = chkExactMatch;
            objAvail_Report_Schedule_UDT.Region_MustHave = ddlMustHaveCountry;
            objAvail_Report_Schedule_UDT.Region_Exclusion = ddlListCountry;
            objAvail_Report_Schedule_UDT.Subtit_Language_Code = Subtitling_Codes;
            objAvail_Report_Schedule_UDT.Dubbing_Language_Code = Dubbing_Codes;
            objAvail_Report_Schedule_UDT.BU_Code = BU_Code;
            objAvail_Report_Schedule_UDT.Report_Type = "SQ";
            objAvail_Report_Schedule_UDT.Digital = false;
            objAvail_Report_Schedule_UDT.IncludeMetadata = chkMetaData;
            objAvail_Report_Schedule_UDT.Is_IFTA_Cluster = chkIFTACluster;
            objAvail_Report_Schedule_UDT.Platform_Group_Code = pfGroupCode;
            objAvail_Report_Schedule_UDT.Subtitling_Group_Code = LangGroup_Sub;
            objAvail_Report_Schedule_UDT.Subtitling_ExactMatch = chkExactMatch_Sub;
            objAvail_Report_Schedule_UDT.Subtitling_MustHave = MustHave_Subtitle_Codes;
            objAvail_Report_Schedule_UDT.Subtitling_Exclusion = ddlListLanguageGroup;
            objAvail_Report_Schedule_UDT.Dubbing_Group_Code = LangGroup_Dub;
            objAvail_Report_Schedule_UDT.Dubbing_ExactMatch = chkExactMatch_Dub;
            objAvail_Report_Schedule_UDT.Dubbing_MustHave = MustHave_Dubbing_Codes;
            objAvail_Report_Schedule_UDT.Dubbing_Exclusion = ddlListLanguageGroup_Dub;
            objAvail_Report_Schedule_UDT.Territory_Code = Territory_Code;
            objAvail_Report_Schedule_UDT.IndiaCast = "N";
            objAvail_Report_Schedule_UDT.Region_On = tabNameInSaveQuery;
            objAvail_Report_Schedule_UDT.Include_Ancillary = IncludeAncillary;
            objAvail_Report_Schedule_UDT.Promoter_Code = promoterCodes;
            objAvail_Report_Schedule_UDT.Promoter_ExactMatch = ExcactMatch_Promoter;
            objAvail_Report_Schedule_UDT.MustHave_Promoter = MustHave_Promoter_Codes;
            objAvail_Report_Schedule_UDT.Module_Code = Convert.ToInt32(module);
            objAvail_Report_Schedule_UDT.Episode_From = Convert.ToInt32(episodeFrom);
            objAvail_Report_Schedule_UDT.Episode_To = Convert.ToInt32(episodeTo);
            lst_Avail_Report_Schedule_UDT.Add(objAvail_Report_Schedule_UDT);


            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            //List<USP_Get_Title_Avail_Language_Data_Result> objAvailResult = new List<USP_Get_Title_Avail_Language_Data_Result>();
            //List<USP_Get_Title_Avail_Language_Data_Show_Result> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show_Result>();
            List<USP_Get_Title_Avail_Language_Data> objAvailResult = new List<USP_Get_Title_Avail_Language_Data>();
            List<USP_Get_Title_Avail_Language_Data_Show> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show>();
            if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                  " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                  "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                  + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'TH' ";

            }
            else
            {
                strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                   " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                   "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                   + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' ";
            }
            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
            {
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
                var recordName = objAvailResult.Where(x => x.ReportName == ReportName).FirstOrDefault();

                if (recordName != null)
                {
                    IsDuplicate = "Y";
                }
                else
                {
                    objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "T", strInsertVal, 0, "", "", 0);
                }
            }
            else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {

                objAvailResult_Show = objUSP.USP_Get_Title_Avail_Language_Data_Show(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
                var recordName = objAvailResult_Show.Where(x => x.ReportName == ReportName).FirstOrDefault();

                if (recordName != null)
                {
                    IsDuplicate = "Y";
                }
                else
                {
                    objUSP.USP_Get_Title_Avail_Language_Data_Show(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "S", strInsertVal, 0, "", "", 0);
                }
            }
            else if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
                var recordName = objAvailResult.Where(x => x.ReportName == ReportName).FirstOrDefault();

                if (recordName != null)
                {
                    IsDuplicate = "Y";

                }
                else
                {

                    objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "C", strInsertVal, 0, "", "", 0);
                }
            }
            if (module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
            {
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
                var recordName = objAvailResult.Where(x => x.ReportName == ReportName).FirstOrDefault();

                if (recordName != null)
                {
                    IsDuplicate = "Y";

                }
                else
                {
                    objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "T", strInsertVal, 0, "", "", 0);
                }
            }
            int RecCount = 0;
            if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                RecCount = objAvailResult_Show.Select(s => s.Recordcount).FirstOrDefault();
            else
                RecCount = objAvailResult.Select(s => s.Recordcount).FirstOrDefault();
            var obj = new
            {
                RecordCount = RecCount,
                Duplicate = IsDuplicate
            };

            return Json(obj);
        }
        public JsonResult CheckDuplicateRecord(int BU_Code, int pageNo, int recordPerPage, string ReportName)
        {
            List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
            Avail_Report_Schedule_UDT objAvail_Report_Schedule_UDT = new Avail_Report_Schedule_UDT();
            objAvail_Report_Schedule_UDT.Visibility = "PR";
            objAvail_Report_Schedule_UDT.Module_Code = Convert.ToInt32(module); ;
            lst_Avail_Report_Schedule_UDT.Add(objAvail_Report_Schedule_UDT);
            string Right_Level = "";
            if (ContryLevelRights == true && TerritoryLevelRights == true)
                Right_Level = "B";
            else if (ContryLevelRights)
                Right_Level = "C";
            else
                Right_Level = "T";

            int pageSize = 10;
            int RecordCount = 0, TotalRecordCount = 0;
            string isPaging = "Y";
            //int PageNo = 1;
            string strFilter = "";
            string IsDuplicate = "";
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            //List<USP_Get_Title_Avail_Language_Data_Result> objAvailResult = new List<USP_Get_Title_Avail_Language_Data_Result>();
            List<USP_Get_Title_Avail_Language_Data> objAvailResult = new List<USP_Get_Title_Avail_Language_Data>();
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);

            strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                   " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                   "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                   + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' ";

            objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();

            var recordName = objAvailResult.Where(x => x.ReportName == ReportName).FirstOrDefault();

            var obj = new
            {
                Record_Count = objRecordCount.Value,


            };
            return Json(obj);
        }

        public JsonResult SearchQueryList(int BU_Code, int pageNo, int recordPerPage)
        {
            List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
            Avail_Report_Schedule_UDT objAvail_Report_Schedule_UDT = new Avail_Report_Schedule_UDT();
            objAvail_Report_Schedule_UDT.Visibility = "PR";
            objAvail_Report_Schedule_UDT.Module_Code = Convert.ToInt32(module); ;
            lst_Avail_Report_Schedule_UDT.Add(objAvail_Report_Schedule_UDT);
            string Right_Level = "";
            if (ContryLevelRights == true && TerritoryLevelRights == true)
                Right_Level = "B";
            else if (ContryLevelRights)
                Right_Level = "C";
            else
                Right_Level = "T";

            int pageSize = 10;
            int RecordCount = 0;
            string isPaging = "Y";
            //int PageNo = 1;
            string strFilter = "";
            string IsDuplicate = "";
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            //List<USP_Get_Title_Avail_Language_Data_Result> objAvailResult = new List<USP_Get_Title_Avail_Language_Data_Result>();
            //List<USP_Get_Title_Avail_Language_Data_Show_Result> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show_Result>();
            List<USP_Get_Title_Avail_Language_Data> objAvailResult = new List<USP_Get_Title_Avail_Language_Data>();
            List<USP_Get_Title_Avail_Language_Data_Show> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show>();

            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                  " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                  "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                  + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'TH' AND Module_Code = " + Convert.ToInt32(module) + " ";

            }
            else if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {
                strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                       + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'Y' AND Module_Code = " + Convert.ToInt32(module) + " ";
            }
            else if (module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                if (ContryLevelRights == true && TerritoryLevelRights == true)
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND (Region_On = 'CO' OR Region_On = 'IF') AND Promoter_Code != '' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
                else if (ContryLevelRights == true)
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Region_On = 'CO' AND Promoter_Code != '' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
                else
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Region_On = 'IF' AND Promoter_Code != '' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
            }
            else
            {
                if (ContryLevelRights == true && TerritoryLevelRights == true)
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND (Region_On = 'CO' OR Region_On = 'IF') AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
                else if (ContryLevelRights == true)
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Region_On = 'CO' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
                else
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Region_On = 'IF' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
            }

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
            else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
                objAvailResult_Show = objUSP.USP_Get_Title_Avail_Language_Data_Show(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
            else if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();

            if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                RcCount = objAvailResult_Show.Select(s => s.Recordcount).FirstOrDefault();
            else
                RcCount = objAvailResult.Select(s => s.Recordcount).FirstOrDefault();

            //  RcCount = Convert.ToInt32(objRecordCount.Value);
            var obj = new
            {
                Record_Count = RcCount,
            };
            return Json(obj);
        }

        public JsonResult DeleteQuery(int queryCode)
        {
            List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
            string Right_Level = "";
            if (ContryLevelRights == true && TerritoryLevelRights == true)
                Right_Level = "B";
            else if (ContryLevelRights)
                Right_Level = "C";
            else
                Right_Level = "T";

            string status = "S", message = "Record deleted successfully";
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", 10);
            List<USP_Get_Title_Avail_Language_Data> objAvailResult = new List<USP_Get_Title_Avail_Language_Data>();
            List<USP_Get_Title_Avail_Language_Data_Show> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show>();


            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "D", queryCode.ToString(), 0, "", "", 0).ToList();
            else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
                objAvailResult_Show = objUSP.USP_Get_Title_Avail_Language_Data_Show(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "D", queryCode.ToString(), 0, "", "", 0).ToList();
            else if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "D", queryCode.ToString(), 0, "", "", 0).ToList();
            int RecCount = 0;

            if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                RecCount = objAvailResult_Show.Select(s => s.Recordcount).FirstOrDefault();
            else
                RecCount = objAvailResult.Select(s => s.Recordcount).FirstOrDefault();

            var obj = new
            {
                Status = status,
                Message = message,
                Record_Count = RecCount
            };

            return Json(obj);
        }

        public PartialViewResult BindQueryList(int BU_Code, int pageNo, int recordPerPage)
        {
            List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
            Avail_Report_Schedule_UDT objAvail_Report_Schedule_UDT = new Avail_Report_Schedule_UDT();
            objAvail_Report_Schedule_UDT.Visibility = "PR";
            objAvail_Report_Schedule_UDT.Module_Code = Convert.ToInt32(module); ;
            lst_Avail_Report_Schedule_UDT.Add(objAvail_Report_Schedule_UDT);
            string Right_Level = "";
            if (ContryLevelRights == true && TerritoryLevelRights == true)
                Right_Level = "B";
            else if (ContryLevelRights)
                Right_Level = "C";
            else
                Right_Level = "T";

            int pageSize = 10;
            int RecordCount = 0;
            string isPaging = "Y";
            //int PageNo = 1;
            string strFilter = "";

            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            //List<USP_Get_Title_Avail_Language_Data_Result> objAvailResult = new List<USP_Get_Title_Avail_Language_Data_Result>();
            //List<USP_Get_Title_Avail_Language_Data_Show_Result> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show_Result>();
            List<USP_Get_Title_Avail_Language_Data> objAvailResult = new List<USP_Get_Title_Avail_Language_Data>();
            List<USP_Get_Title_Avail_Language_Data_Show> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show>();
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                  " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                  "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                  + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'TH' AND Module_Code = " + Convert.ToInt32(module) + " ";

            }
            else if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {
                strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                       + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'Y' AND Module_Code = " + Convert.ToInt32(module) + " ";
            }
            else if (module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                if (ContryLevelRights == true && TerritoryLevelRights == true)
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND (Region_On = 'CO' OR Region_On = 'IF') AND Promoter_Code != '' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
                else if (ContryLevelRights == true)
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Region_On = 'CO' AND Promoter_Code != '' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
                else
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Region_On = 'IF' AND Promoter_Code != '' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
            }
            else
            {
                if (ContryLevelRights == true && TerritoryLevelRights == true)
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND (Region_On = 'CO' OR Region_On = 'IF') AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
                else if (ContryLevelRights == true)
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Region_On = 'CO' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
                else
                {
                    strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                           + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Region_On = 'IF' AND Module_Code = " + Convert.ToInt32(module) + " ";
                }
            }
            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
            {
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
            }
            else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                objAvailResult_Show = objUSP.USP_Get_Title_Avail_Language_Data_Show(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
            }
            else if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
            }
            int RecCount = 0;
            if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                RecCount = objAvailResult_Show.Select(s => s.Recordcount).FirstOrDefault();
            else
                RecCount = objAvailResult.Select(s => s.Recordcount).FirstOrDefault();


            int noOfRecordSkip, noOfRecordTake;
            pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);

            if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
            {
                return PartialView("~/Views/Availability_Movie_New/_QueryList.cshtml", objAvailResult_Show);
            }
            else
            {
                return PartialView("~/Views/Availability_Movie_New/_QueryList.cshtml", objAvailResult);
            }
        }

        public JsonResult BindReportCriteria(int BU_Code, int pageNo, int recordPerPage, int Avail_Report_Schedule_Code)
        {
            List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
            Avail_Report_Schedule_UDT objAvail_Report_Schedule_UDT = new Avail_Report_Schedule_UDT();
            objAvail_Report_Schedule_UDT.Visibility = "PR";
            objAvail_Report_Schedule_UDT.Module_Code = Convert.ToInt32(module);
            lst_Avail_Report_Schedule_UDT.Add(objAvail_Report_Schedule_UDT);
            string Right_Level = "";
            if (ContryLevelRights == true && TerritoryLevelRights == true)
                Right_Level = "B";
            else if (ContryLevelRights)
                Right_Level = "C";
            else
                Right_Level = "T";

            int pageSize = 10;
            int RecordCount = 0;
            string isPaging = "Y";
            //int PageNo = 1;
            string strFilter = "";
            //USP_Get_Title_Avail_Language_Data_Result objList = new USP_Get_Title_Avail_Language_Data_Result();
            USP_Get_Title_Avail_Language_Data_Show_Result objList_Show = new USP_Get_Title_Avail_Language_Data_Show_Result();

            dynamic tempList = null;

            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            //List<USP_Get_Title_Avail_Language_Data_Result> objAvailResult = new List<USP_Get_Title_Avail_Language_Data_Result>();
            //List<USP_Get_Title_Avail_Language_Data_Show_Result> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show_Result>();
            List<USP_Get_Title_Avail_Language_Data> objAvailResult = new List<USP_Get_Title_Avail_Language_Data>();
            List<USP_Get_Title_Avail_Language_Data_Show> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show>();

            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'TH' AND Module_Code = " + Convert.ToInt32(module) + " ";

            }
            else
            {
                strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginUser.Users_Code +
                       " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                       "(Select Security_Group_Code from Users where Users_Code=" + objLoginUser.Users_Code
                       + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' AND BU_CODE =" + BU_Code + " AND Report_Type = 'SQ' AND Module_Code = " + Convert.ToInt32(module) + "  ";
            }

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityNewReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
            {
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
                tempList = objAvailResult.Where(x => x.Avail_Report_Schedule_Code == Avail_Report_Schedule_Code).FirstOrDefault();
            }

            else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                objAvailResult_Show = objUSP.USP_Get_Title_Avail_Language_Data_Show(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
                tempList = objAvailResult_Show.Where(x => x.Avail_Report_Schedule_Code == Avail_Report_Schedule_Code).FirstOrDefault();

            }
            else if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginUser.Users_Code, "F", strFilter, pageNo, "", isPaging, pageSize).ToList();
                tempList = objAvailResult.Where(x => x.Avail_Report_Schedule_Code == Avail_Report_Schedule_Code).FirstOrDefault();
            }
            Dictionary<string, object> objDictionary = new Dictionary<string, object>();
            if (module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                objDictionary.Add("Record_Count", tempList.RowNum);
                objDictionary.Add("TitleCode", tempList.Title_Code);
                objDictionary.Add("TitleName", tempList.Title_Names);
                objDictionary.Add("DateType", tempList.Date_Type);
                objDictionary.Add("TerritoryCodes", tempList.Country_Code);
                objDictionary.Add("Exclusivity", tempList.Exclusivity);
                objDictionary.Add("SubLicenseCode", tempList.SubLicense_Code);
                objDictionary.Add("RestrictionRemarks", tempList.RestrictionRemarks);
                objDictionary.Add("OtherRemarks", tempList.OthersRemark);
                objDictionary.Add("IncludeMetadata", tempList.IncludeMetadata);
                objDictionary.Add("IncludeAncillary", tempList.Include_Ancillary);
                objDictionary.Add("IsOriginaLang", tempList.Is_Original_Language);
                objDictionary.Add("SelfConsumption", tempList.Digital);
                objDictionary.Add("Report_Name", tempList.ReportName);
                objDictionary.Add("Visibility", tempList.Visibility);
                objDictionary.Add("StartDate", Convert.ToDateTime(tempList.StartDate).ToString("dd/MM/yyyy"));
                if (tempList.EndDate == "")
                {
                    objDictionary.Add("EndDate", "");
                }
                else
                {
                    objDictionary.Add("EndDate", Convert.ToDateTime(tempList.EndDate).ToString("dd/MM/yyyy"));
                }
                objDictionary.Add("Region_ExactMatch", tempList.Region_ExactMatch);
                objDictionary.Add("Region_MustHave", tempList.Region_MustHave);
                objDictionary.Add("Region_Exclusion", tempList.Region_Exclusion);
                objDictionary.Add("CountryCode", tempList.Territory_Code);

            }
            else
            {
                objDictionary.Add("Record_Count", objRecordCount.Value);
                objDictionary.Add("TitleCode", tempList.Title_Code);
                objDictionary.Add("TitleName", tempList.Title_Names);
                objDictionary.Add("LanguageCodes", tempList.Language_Code);
                objDictionary.Add("DateType", tempList.Date_Type);
                objDictionary.Add("TerritoryCodes", tempList.Country_Code);
                objDictionary.Add("PlatformCodes", tempList.Platform_Code);
                objDictionary.Add("PlatformExactMatch", tempList.Platform_ExactMatch);
                objDictionary.Add("Exclusivity", tempList.Exclusivity);
                objDictionary.Add("SubLicenseCode", tempList.SubLicense_Code);
                objDictionary.Add("RestrictionRemarks", tempList.RestrictionRemarks);
                objDictionary.Add("OtherRemarks", tempList.OthersRemark);
                objDictionary.Add("IncludeMetadata", tempList.IncludeMetadata);
                objDictionary.Add("IncludeAncillary", tempList.Include_Ancillary);
                objDictionary.Add("IsOriginaLang", tempList.Is_Original_Language);
                objDictionary.Add("SelfConsumption", tempList.Digital);
                objDictionary.Add("IFTA", tempList.Is_IFTA_Cluster);
                objDictionary.Add("Report_Name", tempList.ReportName);
                objDictionary.Add("Visibility", tempList.Visibility);

                objDictionary.Add("StartDate", Convert.ToDateTime(tempList.StartDate).ToString("dd/MM/yyyy"));
                if (tempList.EndDate == "")
                {
                    objDictionary.Add("EndDate", "");
                }
                else
                {
                    objDictionary.Add("EndDate", Convert.ToDateTime(tempList.EndDate).ToString("dd/MM/yyyy"));
                }
                objDictionary.Add("Region_ExactMatch", tempList.Region_ExactMatch);
                objDictionary.Add("Region_MustHave", tempList.Region_MustHave);
                objDictionary.Add("Region_Exclusion", tempList.Region_Exclusion);
                objDictionary.Add("CountryCode", tempList.Territory_Code);

                objDictionary.Add("Platform_GroupCode", tempList.Platform_Group_Code);
                objDictionary.Add("Platform_ExactMatch", tempList.Platform_ExactMatch);
                objDictionary.Add("Platform_MustHave", tempList.MustHave_Platform);
                objDictionary.Add("Platfromcodes", tempList.Platform_Code);

                objDictionary.Add("Subtitling_Group_Code", tempList.Subtitling_Group_Code);
                objDictionary.Add("Subtitling_ExactMatch", tempList.Subtitling_ExactMatch);
                objDictionary.Add("Subtitling_MustHave", tempList.Subtitling_MustHave);
                objDictionary.Add("Subtit_Language_Code", tempList.Subtit_Language_Code);
                objDictionary.Add("Subtitling_Exclusion", tempList.Subtitling_Exclusion);

                objDictionary.Add("Dubbing_Group_Code", tempList.Dubbing_Group_Code);
                objDictionary.Add("Dubbing_ExactMatch", tempList.Dubbing_ExactMatch);
                objDictionary.Add("Dubbing_MustHave", tempList.Dubbing_MustHave);
                objDictionary.Add("Dubbing_Language_Code", tempList.Dubbing_Language_Code);
                objDictionary.Add("Dubbing_Exclusion", tempList.Dubbing_Exclusion);
                objDictionary.Add("TabName", tempList.Region_On);
                objDictionary.Add("Promoter_code", tempList.Promoter_Code);
                objDictionary.Add("Promoter_MustHave", tempList.MustHave_Promoter);
                objDictionary.Add("PromoterExactMatch", tempList.Promoter_ExactMatch);
            }
            TabName = tempList.Region_On;
            if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
            {
                objDictionary.Add("Episode_From", tempList.Episode_From);
                objDictionary.Add("Episode_To", tempList.Episode_To);
            }

            return Json(objDictionary);

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
        #endregion
    }
}