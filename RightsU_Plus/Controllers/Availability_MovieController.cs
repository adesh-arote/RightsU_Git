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

namespace RightsU_Plus.Controllers
{
    public class Availability_MovieController : BaseController
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
            string Is_Allow_Avail_Deal_Type_Title = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Is_Allow_Avail_Deal_Type_Title").ToList().FirstOrDefault().Parameter_Value;

            ViewBag.Is_Allow_Avail_Deal_Type_Title = Is_Allow_Avail_Deal_Type_Title;
            ViewBag.Code = moduleCode;
            module = moduleCode;

            BindBusinessUnit(moduleCode);

            lstTitles_Searched = lstTitles = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();

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

        private void BindBusinessUnit(string modulecode)
        {
            string rightsForAllBU = GetUserModuleRights();

            string SelectedBU = "";
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);

            if (Convert.ToInt32(modulecode) == GlobalParams.ModuleCodeForMovieAvailabilityReport)
            {
                SelectedBU = objSystemParamService.SearchFor(p => p.Parameter_Name == "Title_Avail_BU").ToList().FirstOrDefault().Parameter_Value;
            }

            if (Convert.ToInt32(modulecode) == GlobalParams.ModuleCodeForProgramAvailabilityReport)
            {
                SelectedBU = objSystemParamService.SearchFor(p => p.Parameter_Name == "Title_Avail_Show_BU").ToList().FirstOrDefault().Parameter_Value;
            }

            string[] arr_BU_Codes = SelectedBU.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            List<SelectListItem> list = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(b => b.Users_Business_Unit.Any(UB => UB.Business_Unit_Code == b.Business_Unit_Code
                && UB.Users_Code == objLoginUser.Users_Code)
                && arr_BU_Codes.Contains(b.Business_Unit_Code.ToString()))
                .Select(R => new { Business_Unit_Code = R.Business_Unit_Code, Business_Unit_Name = R.Business_Unit_Name }),
                "Business_Unit_Code", "Business_Unit_Name").ToList();

            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                list.Insert(0, new SelectListItem() { Selected = true, Text = "All Regional GEC", Value = "-1" });
            }

            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~"))
            {
                list.Insert(0, new SelectListItem() { Selected = true, Text = "All Business Unit", Value = "0" });
                if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
                {
                    var allBU = list.Find(x => x.Value == "-1");
                    allBU.Selected = false;
                }
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

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
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
            return PartialView("~/Views/Availability_Movie/_TitlesCriteria.cshtml", lstAvailTitles);
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

        public ActionResult SearchTitles(string searchText, string BU_Code, string[] a, string CodeString, int dealTypeCode = 0)
        {
            dynamic result = "";
            if (BU_Code == "0")
            {
                BU_Code = "0";
                //BU_Code = string.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                //     .Select(s => s.Business_Unit_Code.ToString()).ToArray());
            }
            BU_Code = BU_Code + "~" + dealTypeCode.ToString();

            List<RightsU_Entities.USP_Get_Avail_Titles_Result> lstAvailTitles = new List<USP_Get_Avail_Titles_Result>();
            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
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
            return PartialView("~/Views/Availability_Movie/_RegionRightsData.cshtml");
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

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
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
            return PartialView("~/Views/Availability_Movie/_RegionCriteria.cshtml");
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
            return PartialView("~/Views/Availability_Movie/_Subtitle_LanguageCriteria.cshtml");
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
            return PartialView("~/Views/Availability_Movie/_Dubbing_LanguageCriteria.cshtml");
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

        public JsonResult BindAdvanced_Search_Controls()
        {

            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();

            List<USP_Get_Acq_PreReq_Result> obj_USP_Get_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();

            obj_USP_Get_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("DTP,DTC", "LST", objLoginUser.Users_Code, 0,
                0, 0).ToList();

            obj_Dictionary.Add("USP_Result", obj_USP_Get_PreReq_Result);

            return Json(obj_Dictionary);
        }

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
            ddlExclusive.Add(new SelectListItem { Text = "Both", Value = "B" });
            ddlExclusive.Add(new SelectListItem { Text = "Exclusive", Value = "E" });
            ddlExclusive.Add(new SelectListItem { Text = "Non Exclusive", Value = "N" });
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

            return PartialView("~/Views/Availability_Movie/_OtherCriteria.cshtml");
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
            return PartialView("~/Views/Availability_Movie/_PlatformCriteria.cshtml");
        }



        public PartialViewResult BindPlatformTreeView(string strPlatform, string bindType = "", string isRunQuery = "", string Platform_Group_Code = "0", string strSelected = "")
        {
            string Avail_All_Platform_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Avail_All_Platform").ToList().FirstOrDefault().Parameter_Value;
            string strTreeId = "Rights_Platform", strTreeValueId = "hdnTVCodes";
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

        public PartialViewResult AddEditPlatform_Group(string Platform_Group_Code, string selectedCodes, string isRunQuery)
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
            return BindPlatformTreeView(strPlatform_Code, "PG", isRunQuery, Platform_Group_Code, selectedCodes);
            //return PartialView("~/Views/Availability_Movie/_PlatformCriteria.cshtml", objPlatform_Group);
        }

        #endregion
        #region------------Self Utilization Critera------------------

        public PartialViewResult BindPromoter()
        {
            return PartialView("~/Views/Availability_Movie/_SelfUtilizationCriteria.cshtml");
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
        string[] Title_Language_Code, string ExcactMatch_Platform, string Exclusivity,
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

            if (module != GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
            {
                strPlatformCodes = string.Join(",", platformCodes);
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
            if (ContryLevelRights && tabName == "CO")
            {
                Territory_Code = "0";
            }
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
               Territory_Code, BU_Code.ToString(), SubLicense_Code, chkRestRemarks, chkOtherRemarks, chkMetaData, chkDigital.ToString(), Exclusivity, "", "").FirstOrDefault();

            }
            else
            {
                objGTALF = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_Availability_LanguageWise_Filter(strTitleCodes,
                    strPlatformCodes, Country_Code, Subtit_Language_Code, Dubbing_Language_Code, MustHave_Platform, Dubbing_Subtitling, Region_MustHave_Codes, Region_Exclusion_Codes, Title_Language_Codes,
                    3, chkIFTACluster, LangGroup_Sub, strMustHave_Subtitle_Codes, Sub_Exclusion_Codes, LangGroup_Dub, strMustHave_Dubbing_Codes, Dub_Exclusion_Codes, pfGroupCode, MustHave_Platform,
                   Territory_Code, BU_Code.ToString(), SubLicense_Code, chkRestRemarks, chkOtherRemarks, chkMetaData, chkDigital.ToString(), Exclusivity, strPromoterCodes, MustHave_Promoter).FirstOrDefault();
            }
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

            string[] IndividualPlatformCodes = strPlatformCodes.Split(',').ToArray();
            int IndividualPlatformCount = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(w => IndividualPlatformCodes.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Name).Count();
            ViewBag.PlatformCount = IndividualPlatformCount;
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
            return PartialView("~/Views/Availability_Movie/_SelectedCriteriaList.cshtml", objGTALF);
        }
        public PartialViewResult BindPlatformTreePopup(string callfrom)
        {

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
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
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
        public PartialViewResult BindAvailReport(string[] titleCodes, string[] platformCodes, string Country_Code,
            string isOriginalLang, string rblPeriodType, string Dubbing_Subtitling,
            string[] Title_Language_Code, string ExcactMatch_Platform, string Exclusivity,
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

            string Availability_Ifta_And_Ancillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Availability_Ifta_And_Ancillary").ToList().FirstOrDefault().Parameter_Value;
            string Title_Language_Codes = string.Join(",", Title_Language_Code);
            string SubLicense_Code = string.Join(",", sublicList);
            string Region_MustHave_Codes = string.Join(",", ddlMustHaveCountry);
            string Region_Exclusion_Codes = string.Join(",", ddlListCountry);

            //Check whether Modelling avail is enable or not

            string Is_Enable_Modelling_Avail = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Enable_Modelling_Avail").ToList().FirstOrDefault().Parameter_Value;

            var strBU_Code = BU_Code.ToString();
            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString())
            {
                if (BU_Code == 0)
                {
                    strBU_Code = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(x => x.Business_Unit_Code).ToList());
                    //businessUnitcode = string.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                    //     .Select(s => s.Business_Unit_Code.ToString()).ToArray());
                }
                else if (BU_Code == -1)
                {
                    var BUforRegGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                    var arrayBUforRegGEC = BUforRegGEC.Split(',');
                    strBU_Code = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code) && arrayBUforRegGEC.Contains(x.Business_Unit_Code.ToString())).Select(x => x.Business_Unit_Code).ToList());
                }
            }

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
            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString())
            {
                if (Availability_Ifta_And_Ancillary == "N")
                    noOfParam = 39;
                else
                    noOfParam = 43;
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

            if (Is_Enable_Modelling_Avail == "Y")
            {
                noOfParam = 34;
            }


            if (tabName == "check" || tabName == "UnCheck")
            {
                TabName = "IF";
                tabName = "IF";
            }
            TabName = tabName;
            ReportParameter[] parm = new ReportParameter[noOfParam];

            if (Is_Enable_Modelling_Avail == "N")
            {

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
                    parm[29] = new ReportParameter("Exclusivity", Exclusivity);

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
                        parm[8] = new ReportParameter("Exclusivity", Exclusivity);
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
                        parm[8] = new ReportParameter("Exclusivity", Exclusivity);
                        parm[9] = new ReportParameter("SubLicense_Code", SubLicense_Code);
                        parm[10] = new ReportParameter("Region_ExactMatch", chkExactMatch);
                        parm[11] = new ReportParameter("Region_MustHave", Region_MustHave_Codes);
                        parm[12] = new ReportParameter("Created_By", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                        parm[13] = new ReportParameter("Region_Exclusion", Region_Exclusion_Codes);
                        parm[14] = new ReportParameter("Subtit_Language_Code", Subtit_Language_Code);
                        parm[15] = new ReportParameter("Dubbing_Language_Code", Dubbing_Language_Code);
                        if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString())
                        {
                            parm[16] = new ReportParameter("BU_Code", strBU_Code);
                        }
                        else
                        {
                            parm[16] = new ReportParameter("BU_Code", BU_Code.ToString());
                        }
                        parm[17] = new ReportParameter("Is_Digital", chkDigital.ToString());

                        if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
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

                        if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
                        {
                            string Is_Allow_Title_Objection = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Is_Allow_Title_Objection").ToList().FirstOrDefault().Parameter_Value;
                            string Is_Syn_CoExclusive = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name == "Is_Syn_CoExclusive").ToList().FirstOrDefault().Parameter_Value;

                            parm[35] = new ReportParameter("StartMonth", "0");
                            parm[36] = new ReportParameter("EndYear", "0");
                            parm[37] = new ReportParameter("DisplayObjection", (Is_Allow_Title_Objection == "Y" ? "TRUE" : "FALSE"));
                            parm[38] = new ReportParameter("DisplayCoExRemarks", (Is_Syn_CoExclusive == "Y" ? "TRUE" : "FALSE"));
                            if (Availability_Ifta_And_Ancillary == "Y")
                            {
                                if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString())
                                {
                                    parm[39] = new ReportParameter("Country_Level", chkCountryLevel);
                                    parm[40] = new ReportParameter("Territory_Level", chkTerritoryLevel);
                                    parm[41] = new ReportParameter("TabName", tabName);
                                    parm[42] = new ReportParameter("Include_Ancillary", IncludeAncillary);
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                string Report_Type = "M";
                if(module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString())
                {
                    Report_Type = "M";
                }
                else if(module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString())
                {
                    Report_Type = "S";
                }

                parm[0] = new ReportParameter("TitleCodes", strTitleCodes);
                parm[1] = new ReportParameter("DateType", rblPeriodType);
                parm[2] = new ReportParameter("StartDate", startDate);
                parm[3] = new ReportParameter("EndDate", endDate);
                parm[4] = new ReportParameter("PlatformCodes", strPlatformCodes);
                parm[5] = new ReportParameter("ExactMatchPlatforms", ExcactMatch_Platform);
                parm[6] = new ReportParameter("MustHavePlatforms", MustHave_Platform);

                parm[7] = new ReportParameter("IsIFTACluster", chkIFTACluster);
                parm[8] = new ReportParameter("TerritoryCodes", Territory_Code);
                parm[9] = new ReportParameter("CountryCodes", Country_Code);
                parm[10] = new ReportParameter("ExactMatchCountry", chkExactMatch);
                parm[11] = new ReportParameter("MustHaveCountry", Region_MustHave_Codes);
                parm[12] = new ReportParameter("ExclusionCountry", Region_Exclusion_Codes);

                parm[13] = new ReportParameter("IsTitleLanguage", isOriginalLang);
                parm[14] = new ReportParameter("TitleLanguageCode", Title_Language_Codes);

                parm[15] = new ReportParameter("DubbingSubtitling", Dubbing_Subtitling);
                parm[16] = new ReportParameter("SubtitlingGroupCodes", LangGroup_Sub);
                parm[17] = new ReportParameter("SubtitlingCodes", Subtit_Language_Code);
                parm[18] = new ReportParameter("ExactMatchSubtitling", chkExactMatch_Sub);
                parm[19] = new ReportParameter("MustHaveSubtitling", strMustHave_Subtitle_Codes);
                parm[20] = new ReportParameter("ExclusionSubtitling", Sub_Exclusion_Codes);

                parm[21] = new ReportParameter("DubbingGroupCodes", LangGroup_Dub);
                parm[22] = new ReportParameter("DubbingCodes", Dubbing_Language_Code);
                parm[23] = new ReportParameter("ExactMatchDubbing", chkExactMatch_Dub);
                parm[24] = new ReportParameter("MustHaveDubbing", strMustHave_Dubbing_Codes);
                parm[25] = new ReportParameter("ExclusionDubbing", Dub_Exclusion_Codes);

                parm[26] = new ReportParameter("Exclusivity", Exclusivity);
                parm[27] = new ReportParameter("SubLicenseCode", SubLicense_Code);
                parm[28] = new ReportParameter("RestrictionRemarks", chkRestRemarks);
                parm[29] = new ReportParameter("OthersRemarks", chkOtherRemarks);
                parm[30] = new ReportParameter("BUCode", BU_Code.ToString());
                parm[31] = new ReportParameter("IsDigital", chkDigital);
                parm[32] = new ReportParameter("L1Output", "N");
                parm[33] = new ReportParameter("Report_Type", Report_Type);

            }


            ReportViewer rptViewer = new ReportViewer();

            if (Is_Enable_Modelling_Avail == "Y")
            {

                rptViewer = BindReport(parm, "rpt_Availability");
            }
            else
            {

                if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString())
                {
                    if (Availability_Ifta_And_Ancillary == "Y")//availabilyIFTAAND ANCILARY IF Y DEN V18 ESLE SPN
                        rptViewer = BindReport(parm, "Title_Availability_Languagewise_V18");
                    else if (Availability_Ifta_And_Ancillary == "N")
                        rptViewer = BindReport(parm, "Title_Availability_Languagewise_3");
                }
                else if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString())
                {
                    if (Availability_Ifta_And_Ancillary == "Y")
                        rptViewer = BindReport(parm, "Title_Availability_Show_3_V18");
                    else if (Availability_Ifta_And_Ancillary == "N")
                        rptViewer = BindReport(parm, "Title_Availability_Show_3");
                }
                else if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
                    rptViewer = BindReport(parm, "Movie_Availability_Indiacast");
                else if (module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                    rptViewer = BindReport(parm, "Show_availability_Indiacast");
                else if (module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
                    rptViewer = BindReport(parm, "Self_Utilization_Movie_Availability");
                else if (module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
                    rptViewer = BindReport(parm, "Self_Utilization_Show_Availability");
                else
                    rptViewer = BindReport(parm, "Theatrical_Availability");
            }
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
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
        string Title_Language_Code, string ExcactMatch_Platform, string Exclusivity,
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

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationProgramAvailabilityReport.ToString())
                strInsertVal = strInsertVal + "," + "'" + "N" + "'";

            if (module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForTheatricalAvailabilityReport.ToString())
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
            objAvail_Report_Schedule_UDT.Exclusivity = Exclusivity;
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
            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString())
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
            try
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

                if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
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
            catch
            {
                var obj = new
                {
                    Record_Count = RcCount,
                };
                return Json(obj);
            }
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


            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
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
            try
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
                if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
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
                    return PartialView("~/Views/Availability_Movie/_QueryList.cshtml", objAvailResult_Show);
                }
                else
                {
                    return PartialView("~/Views/Availability_Movie/_QueryList.cshtml", objAvailResult);
                }
            }
            catch
            {
                List<USP_Get_Title_Avail_Language_Data> objAvailResult = new List<USP_Get_Title_Avail_Language_Data>();
                List<USP_Get_Title_Avail_Language_Data_Show> objAvailResult_Show = new List<USP_Get_Title_Avail_Language_Data_Show>();

                if (module == GlobalParams.ModuleCodeForProgramAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastProgramAvailabilityReport.ToString())
                {
                    return PartialView("~/Views/Availability_Movie/_QueryList.cshtml", objAvailResult_Show);
                }
                else
                {
                    return PartialView("~/Views/Availability_Movie/_QueryList.cshtml", objAvailResult);
                }
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

            if (module == GlobalParams.ModuleCodeForMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForIndiacastMovieAvailabilityReport.ToString() || module == GlobalParams.ModuleCodeForSelfUtilizationMovieAvailabilityReport.ToString())
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









