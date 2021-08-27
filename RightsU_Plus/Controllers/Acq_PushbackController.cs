using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using System.Collections;
using UTOFrameWork.FrameworkClasses;
using System.Globalization;
using System.Threading;
using System.Web.UI;
using RightsU_Plus.Controllers;
using System.Data.Entity.Core.Objects;

namespace RightsU_WebApp.Controllers
{
    public class Acq_PushbackController : BaseController
    {
        #region --- Properties ---
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value; }
        }
        public List<USP_Validate_Rev_HB_Duplication_UDT_Acq> lstDupRecords
        {
            get
            {
                if (Session["lstDupRecords"] == null)
                    Session["lstDupRecords"] = new List<USP_Validate_Rev_HB_Duplication_UDT_Acq>();
                return (List<USP_Validate_Rev_HB_Duplication_UDT_Acq>)Session["lstDupRecords"];
            }
            set
            {
                Session["lstDupRecords"] = value;
            }
        }
        public List<USP_List_Rights_Result> lstAcqPushback
        {
            get
            {
                if (Session["lstAcqPushback"] == null)
                    Session["lstAcqPushback"] = new List<USP_List_Rights_Result>();
                return (List<USP_List_Rights_Result>)Session["lstAcqPushback"];
            }
            set { Session["lstAcqPushback"] = value; }
        }
        private USP_Service objUSPS
        {
            get
            {
                if (Session["USPS_Acq_Pushback"] == null)
                    Session["USPS_Acq_Pushback"] = new USP_Service(objLoginEntity.ConnectionStringName);
                return (USP_Service)Session["USPS_Acq_Pushback"];
            }
            set { Session["USPS_Acq_Pushback"] = value; }
        }
        public string DPlatformCode
        {
            get
            {
                if (Session["DPlatformCode"] == null)
                    Session["DPlatformCode"] = "";
                return (string)Session["DPlatformCode"];
            }
            set { Session["DPlatformCode"] = value; }
        }
        #endregion

        #region --- Page Load ---
        public PartialViewResult Index(string CallFrom)
        {
            lstDupRecords = null;
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            ViewBag.Mode = "LIST";
            ViewBag.TitleList = BindTitle(objDeal_Schema.Pushback_Titles ?? "");
            objDeal_Schema.Page_From = GlobalParams.Page_From_Pushback;
            if (CallFrom == "A" || CallFrom == "U")
                ViewBag.Msg = CallFrom == "A" ? objMessageKey.ReverseHoldbacksavedsuccessfully : objMessageKey.ReverseHoldbackupdatedsuccessfully;

            List<USP_List_Rights_Result> lst = new List<USP_List_Rights_Result>();
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;

            int prevAcq_Deal = 0;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_VIEW && TempData["prevAcqDeal"] != null)
            {
                prevAcq_Deal = Convert.ToInt32(TempData["prevAcqDeal"]);
                TempData.Keep("prevAcqDeal");
            }
            ViewBag.prevAcq_Deal = prevAcq_Deal;

            Session["FileName"] = "";
            Session["FileName"] = "acq_LicensorHoldback";
            return PartialView("~/Views/Acq_Deal/_Acq_Pushback_List.cshtml", lst);
        }
        public PartialViewResult BindRightsFilterData()
        {
            Acq_Deal objAd = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            var titleList = from Adm in objAd.Acq_Deal_Movie
                            from adr in objAd.Acq_Deal_Pushback
                            from adrt in adr.Acq_Deal_Pushback_Title
                            where Adm.Acq_Deal_Code == adr.Acq_Deal_Code && adr.Acq_Deal_Pushback_Code == adrt.Acq_Deal_Pushback_Code && adrt.Title_Code == Adm.Title_Code
                            select new { Title_Code = Adm.Acq_Deal_Movie_Code, Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, Adm.Title.Title_Name, Adm.Episode_Starts_From, Adm.Episode_End_To) };
            ViewBag.TitleList = new MultiSelectList(titleList.ToList().Distinct(), "Title_Code", "Title_Name");
            int?[] acqdealpushbackCode = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Select(x => (int?)x.Acq_Deal_Pushback_Code).ToArray();
            string[] regioncode = new string[] { "" };
            if (objDeal_Schema.Pushback_Region != null)
            {
                regioncode = objDeal_Schema.Pushback_Region.Split(',');
            }
            string[] arrSelectedCountryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "I").Where(w => regioncode.Contains("C" + "" + w.Country_Code.ToString() + "")).Select(s => "C" + "" + s.Country_Code.ToString() + "").ToArray();
            string[] arrSelectedTerritoryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "G").Where(w => regioncode.Contains("T" + "" + w.Territory_Code.ToString() + "")).Select(s => "T" + "" + s.Territory_Code.ToString() + "").ToArray();

            int?[] countryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
            int?[] territoryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

            List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
            if (arrSelectedCountryCode.Count() > 0)
                lsts.Where(s => s.GroupName == "Country" && arrSelectedCountryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);

            lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "C" + "" + s.Territory_Code.ToString() + "" }).ToList());
            if (arrSelectedTerritoryCode.Count() > 0)
                lsts.Where(s => s.GroupName == "Territory" && arrSelectedTerritoryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            string[] arrcountryCode = arrSelectedCountryCode.Select(x => x.Replace("C", "")).ToArray();
            string Country_Terr_Name = string.Join(",", new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrcountryCode.Contains(x.Country_Code.ToString())).Select(s => s.Country_Name).ToArray());
            string[] arrterritoryCode = arrSelectedTerritoryCode.Select(x => x.Replace("T", "")).ToArray();
            Country_Terr_Name = Country_Terr_Name + "," + string.Join(",", new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrterritoryCode.Contains(s.Territory_Code.ToString())).Select(s => s.Territory_Name).ToArray());
            string[] regionname = new string[] { "" };
            if (Country_Terr_Name != "")
                regionname = Country_Terr_Name.TrimStart(',').TrimEnd(',').Split(',');

            if (regionname.Count() > 3)
                ViewBag.RegionName = " " + regionname.Count() + " Selected";
            else
                ViewBag.RegionName = Country_Terr_Name.TrimStart(',').TrimEnd(',');
            ViewBag.Region = lsts;
            ViewBag.RegionId = "ddlRegionn";
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            //  ViewBag.RightsFlag = "AR";
            ViewBag.Exclusive_Rights = new SelectList(new[]
                {
                    new { Code = "B", Name = "Both" },
                    new { Code = "Y", Name = "Yes" },
                    new { Code = "N", Name = "No" }
                }, "Code", "Name");

            ViewBag.FilterPageFrom = "AP";
            return PartialView("~/Views/Shared/_Rights_Filter.cshtml");
        }
        public JsonResult BindRegionList(string TitleCode)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            string htmldata = "";
            string hdntitleCode = "";
            if (TitleCode == "")
            {
                int?[] acqdealpushbackCode = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Select(x => (int?)x.Acq_Deal_Pushback_Code).ToArray();
                int?[] countryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
                int?[] territoryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

                List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
                lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
                htmldata = CustomHtmlHelpers.getGroupHtml(lsts);
            }
            else
            {
                string[] code = TitleCode.Split(',');

                string[] titlecode = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => code.Contains(x.Acq_Deal_Movie_Code.ToString())).Select(s => s.Title_Code.ToString()).ToArray();
                int?[] pushbackCode = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Pushback_Title).Where(w => titlecode.Contains(w.Title_Code.ToString())).Select(s => s.Acq_Deal_Pushback_Code).ToArray();
                int?[] countryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => pushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
                int?[] territoryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => pushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

                List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
                lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
                htmldata = CustomHtmlHelpers.getGroupHtml(lsts);
                string strPlatform = string.Join(",", new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Pushback_Platform).Select(w => w.Platform_Code).ToArray());
                hdntitleCode = string.Join(",", titlecode);
            }

            obj.Add("htmldata", htmldata);
            obj.Add("TitleCode", hdntitleCode);
            //obj.Add("ddlRegionn", new SelectList(lsts, "Text", "Value"));
            //obj.Add("SelectedCode", selectedCountryCodes);
            return Json(obj);
        }
        public PartialViewResult BindRightsPlatformTreePopup(string TitleCode, string platformcode)
        {
            if (DPlatformCode != "")
                platformcode = DPlatformCode;
            DPlatformCode = null;
            string strPlatform;
            string selectedplatform = "";
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string[] titlecode = TitleCode.Split(',');
            string[] pCode = platformcode.Split(',');
            int?[] rightsCode = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Pushback_Title).Where(w => titlecode.Contains(w.Title_Code.ToString())).Select(s => s.Acq_Deal_Pushback_Code).ToArray();

            if (TitleCode == "")
            {
                selectedplatform = string.Join(",", new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Pushback_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                strPlatform = string.Join(",", new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Pushback_Platform).Select(w => w.Platform_Code).Distinct().ToArray());
                if (strPlatform == "")
                    strPlatform = "0";
                objPTV.PlatformCodes_Display = strPlatform;
                objPTV.PlatformCodes_Selected = selectedplatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            else
            {
                selectedplatform = string.Join(",", new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Acq_Deal_Pushback_Code)).SelectMany(x => x.Acq_Deal_Pushback_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                strPlatform = string.Join(",", new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Acq_Deal_Pushback_Code)).SelectMany(s => s.Acq_Deal_Pushback_Platform).Select(w => w.Platform_Code).Distinct().ToArray());
                if (strPlatform == "")
                    strPlatform = "0";
                objPTV.PlatformCodes_Display = strPlatform;
                objPTV.PlatformCodes_Selected = selectedplatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            objPTV.Show_Selected = false;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform_Filter";
            ViewBag.TreeValueId = "hdnTVCode";
            return PartialView("_TV_Platform");
        }
        public ActionResult Cancel()
        {
            ClearSession();
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            objDeal_Schema = null;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                return RedirectToAction("Index", "Acq_List");
            }
        }
        [HttpPost]
        public ActionResult ChangeTab(string hdnTabName)
        {
            int PageNo = objDeal_Schema.PageNo;
            if (hdnTabName == "")
                objDeal_Schema = null;
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, PageNo, objDeal_Schema.Deal_Type_Code);
        }
        private void FillForm(string view_Type, string Title_Code_Search, int txtpageSize = 100, int pageNo = 0)
        {
            objDeal_Schema.Pushback_View = view_Type;
            objDeal_Schema.Pushback_Titles = Title_Code_Search;
            objDeal_Schema.Pushback_PageSize = txtpageSize;
            objDeal_Schema.Pushback_PageNo = pageNo;
        }
        [HttpPost]
        public PartialViewResult Bind_Grid_List(string Selected_Title_Code, string view_Type, string RegionCode, string PlatformCode, int txtpageSize = 100, int page_index = 0, string IsCallFromPaging = "N")
        {
            if (DPlatformCode == "D")
                DPlatformCode = PlatformCode;
            ViewBag.Mode = "LIST";
            int PageNo = page_index <= 0 ? 1 : page_index + 1;
            if (IsCallFromPaging == "N" || IsCallFromPaging == "C")
            {
                //Here C means Summary and Deatails
                objDeal_Schema.List_Pushback.Clear();
            }

            FillForm(view_Type, Selected_Title_Code, txtpageSize, PageNo);

            int totalRcord = 0;
            ObjectParameter objPageNo = new ObjectParameter("PageNo", PageNo);
            ObjectParameter objTotalRecord = new ObjectParameter("TotalRecord", totalRcord);
            List<USP_List_Rights_Result> lst = objUSPS.USP_List_Rights("AP", objDeal_Schema.Pushback_View, objDeal_Schema.Deal_Code,
                objDeal_Schema.Pushback_Titles, RegionCode, PlatformCode, "", objPageNo, txtpageSize, objTotalRecord, "").ToList();

            ViewBag.RecordCount = Convert.ToInt32(objTotalRecord.Value);
            ViewBag.PageNo = Convert.ToInt32(objPageNo.Value);

            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.Page_View = objDeal_Schema.Pushback_View;
            objDeal_Schema.Pushback_Region = RegionCode;
            objDeal_Schema.Pushback_Platform = PlatformCode;
            objDeal_Schema.Pushback_Title = Selected_Title_Code;
            int?[] acqdealpushbackCode = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Select(x => (int?)x.Acq_Deal_Pushback_Code).ToArray();
            string[] regioncode = RegionCode.Split(',');
            string[] arrSelectedCountryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "I").Where(w => regioncode.Contains(w.Country_Code.ToString())).Select(s => s.Country_Code.ToString()).ToArray();
            string[] arrSelectedTerritoryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "G").Where(w => regioncode.Contains(w.Territory_Code.ToString())).Select(s => s.Territory_Code.ToString()).ToArray();

            int?[] countryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
            int?[] territoryCode = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealpushbackCode.Contains(x.Acq_Deal_Pushback_Code) && x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

            List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
            lsts.Where(s => s.GroupName == "Country" && arrSelectedCountryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
            lsts.Where(s => s.GroupName == "Territory" && arrSelectedTerritoryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            ViewBag.Region = lsts;
            //if(lstDupRecords.Count() > 0)
            //{
            //    Errormessage = 
            //}
            return PartialView("~/Views/Acq_Deal/_List_Pushback.cshtml", lst);
        }
        public PartialViewResult BindPlatformTreePopup(int rightCode)
        {
            Acq_Deal_Pushback objADP = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName).GetById(rightCode);
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string strPlatform = string.Join(",", objADP.Acq_Deal_Pushback_Platform.Select(s => s.Platform_Code).ToArray());
            objPTV.PlatformCodes_Display = strPlatform;
            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            objPTV.Show_Selected = true;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");

            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }
        private MultiSelectList BindTitle(string selectedTitleCode)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().
                BindSearchList_Rights(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Condition, (objDeal_Schema.Pushback_Titles ?? ""), "A");
        }

        private MultiSelectList BindTitle_Popup(string selectedTitleCode)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().
                BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, selectedTitleCode);
        }


        #endregion

        #region=============BindDropDown===============
        private MultiSelectList BindCountry(string Selected_Country_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindCountry_List("N", Selected_Country_Code);
        }
        private MultiSelectList BindTerritory(string Selected_Territory_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTerritory_List("N", Selected_Territory_Code);
        }
        private MultiSelectList BindLanguage(string Selected_Language_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindLanguage_List(Selected_Language_Code);
        }
        private MultiSelectList BindLanguage_Group(string Selected_Language_Group_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindLanguage_Group_List(Selected_Language_Group_Code);
        }
        private MultiSelectList BindMilestone_Type(int Selected_Milestone_Type_Code = 0)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindMilestone_List(Selected_Milestone_Type_Code);
        }
        private MultiSelectList BindMilestone_Unit(int selected_Milestone_Unit = 0)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindMilestone_Unit_List(selected_Milestone_Unit);
        }
        public JsonResult BindDropDown_Popup(string str_Type)
        {
            // I - Country // G -Territory // SL -Sub Lang // SG - Sub Lang Group // DL -Dub Lang // DG - Dubb Lang Group              
            if (str_Type == "I")
            {
                var arr = BindCountry();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "G")
            {
                var arr = BindTerritory();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "SL" || str_Type == "DL")
            {
                var arr = BindLanguage();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "SG" || str_Type == "DG")
            {
                var arr = BindLanguage_Group();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            return Json("", JsonRequestBehavior.AllowGet);
        }
        private void BindAllViewBag(string selected_Title_Code, string selected_Country_Code, string selected_Territory_Type, string selected_SL_Code, string selected_SL_Type, string selected_DL_Code, string selected_DL_Type, int selected_Milestone_Type_Code, int selected_Milestone_Unit)
        {
            ViewBag.Title_List_Popup = BindTitle_Popup(selected_Title_Code);
            ViewBag.Territory_List_Popup = selected_Territory_Type == "G" ? BindTerritory(selected_Country_Code) : BindCountry(selected_Country_Code);
            ViewBag.SL_List_Popup = selected_SL_Type == "G" ? BindLanguage_Group(selected_SL_Code) : BindLanguage(selected_SL_Code);
            ViewBag.DL_List_Popup = selected_DL_Type == "G" ? BindLanguage_Group(selected_DL_Code) : BindLanguage(selected_DL_Code);
            ViewBag.Milestone_Type_Popup = BindMilestone_Type(selected_Milestone_Type_Code);
            ViewBag.Milestone_Unit_Popup = BindMilestone_Unit(selected_Milestone_Unit);
        }
        private void CultureInfoFunction()
        {
            CultureInfo CI = new CultureInfo("pt-PT");
            CI.DateTimeFormat.ShortDatePattern = "dd/MM/yyyy";
            Thread.CurrentThread.CurrentCulture = CI;
            Thread.CurrentThread.CurrentUICulture = CI;
        }
        #endregion

        #region --- Add/Edit/Delete Pushback ---
        [HttpPost]
        public PartialViewResult Add(string Title_Code_Search, string View_Type_Search)
        {
            ViewBag.Mode = "ADD";
            BindPlatformTreeView(new string[] { "0" });
            ViewBag.Title_Code_Search = Title_Code_Search;
            ViewBag.View_Type = View_Type_Search;
            BindAllViewBag("", "", "", "", "", "", "", 0, 0);
            return PartialView("~/Views/Acq_Deal/_Acq_Pushback.cshtml", new Acq_Deal_Pushback());
        }
        public JsonResult Save_Pushback(Acq_Deal_Pushback obj, string hdnTitleList, string hdnRights_Platform_Code, int? Year, int? Month, int? Day,
                string hdnTerritory_Type, string hdn_Dubbing_Type, string hdn_SubTitling_Type, string hdnTerritoryList,
            string hdn_Dubb_LanguageList, string hdn_Sub_LanguageList, int? TCODE, int? Episode_From, int? Episode_To, int? PCODE, string Title_Code_Search, string View_Type_Search, string hdnRight_Start_Date, string hdnRight_End_Date, int? page_index, int? txtpageSize, string type)
        {
            string msg = obj.Acq_Deal_Pushback_Code > 0 ? "U" : "A";
            ViewBag.Mode = type;

            if (type == "CLONE")
            {
                TCODE = 0;
                PCODE = 0;
            }
            bool IsSameAsGroup = false;
            if (hdnRight_Start_Date != "")
            {
                // CultureInfoFunction();
                obj.Right_Start_Date = Convert.ToDateTime(hdnRight_Start_Date);
                if (hdnRight_End_Date != "" && obj.Is_Tentative != "Y")
                    obj.Right_End_Date = Convert.ToDateTime(hdnRight_End_Date);
                else
                    obj.Right_End_Date = null;
            }
            else
                obj.Right_Start_Date = null;
            if (TCODE > 0 || PCODE > 0)
            {
                int PushbackCode = obj.Acq_Deal_Pushback_Code;
                Acq_Deal objDeal = new Acq_Deal();
                Acq_Deal_Service objADS = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                objDeal = objADS.GetById(obj.Acq_Deal_Code ?? 0);
                Acq_Deal_Pushback objExistingRight = objDeal.Acq_Deal_Pushback.Where(t => t.Acq_Deal_Pushback_Code == PushbackCode).FirstOrDefault();
                if (objExistingRight.Acq_Deal_Pushback_Title.Count == 1 && TCODE > 0 && objExistingRight.Acq_Deal_Pushback_Platform.Count == 1 && PCODE > 0)
                    IsSameAsGroup = true;
                else if (objExistingRight.Acq_Deal_Pushback_Title.Count == 1 && TCODE > 0 && PCODE == 0)
                    IsSameAsGroup = true;
                else
                {
                    Acq_Deal_Pushback objAcqDealPushback = new Acq_Deal_Pushback();
                    Acq_Deal_Pushback_Service objADPS = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName);
                    Acq_Deal_Pushback objFirstRight = new Acq_Deal_Pushback();
                    if (obj.Right_Type == "Y")
                    {
                        if (obj.Right_Start_Date != null)
                            objFirstRight.Right_Start_Date = Convert.ToDateTime(obj.Right_Start_Date);
                        if (obj.Right_End_Date != null)
                            objFirstRight.Right_End_Date = Convert.ToDateTime(obj.Right_End_Date);
                        objFirstRight.Is_Tentative = obj.Is_Tentative;
                    }
                    else
                    {
                        objFirstRight.Is_Tentative = null;
                        objFirstRight.Milestone_Type_Code = obj.Milestone_Type_Code;
                        objFirstRight.Milestone_Unit_Type = obj.Milestone_Unit_Type;
                        objFirstRight.Milestone_No_Of_Unit = obj.Milestone_No_Of_Unit;
                    }
                    objFirstRight.Right_Type = obj.Right_Type;
                    objFirstRight.Is_Title_Language_Right = obj.Is_Title_Language_Right;
                    objFirstRight.Remarks = obj.Remarks;
                    objFirstRight = CreatePushbackObject(objFirstRight, hdnTitleList, hdnRights_Platform_Code, Year ?? 0, Month ?? 0, Day ?? 0,
                        hdnTerritory_Type, hdn_Dubbing_Type, hdn_SubTitling_Type, hdnTerritoryList, hdn_Dubb_LanguageList, hdn_Sub_LanguageList, hdnRight_Start_Date, hdnRight_End_Date, ref objADPS);
                    objFirstRight.EntityState = State.Added;
                    objDeal.Acq_Deal_Pushback.Add(objFirstRight);
                    objExistingRight.EntityState = State.Modified;
                    bool isMovieDelete = true;
                    if (objExistingRight.Acq_Deal_Pushback_Title.Count > 1)
                        objExistingRight.Acq_Deal_Pushback_Title.Where(t => t.Title_Code == TCODE).ToList<Acq_Deal_Pushback_Title>().ForEach(x => { x.EntityState = State.Deleted; });
                    else
                        isMovieDelete = false;

                    if (PCODE > 0)
                        if (!isMovieDelete)
                            objExistingRight.Acq_Deal_Pushback_Platform.ToList<Acq_Deal_Pushback_Platform>().ForEach(t => { if (t.Platform_Code == PCODE) t.EntityState = State.Deleted; });
                        else if (objExistingRight.Acq_Deal_Pushback_Platform.Count > 1)
                        {
                            Acq_Deal_Pushback objSecondRight = SetNewAcqDealRight(objExistingRight, TCODE, Episode_From, Episode_To, PCODE);
                            objDeal.Acq_Deal_Pushback.Add(objSecondRight);
                        }
                    objDeal.SaveGeneralOnly = false;
                    objDeal.EntityState = State.Modified;
                    dynamic resultSet;
                    
                    objADS.Save(objDeal, out resultSet);
                }
            }
            else
                IsSameAsGroup = true;

            if (IsSameAsGroup || ViewBag.Mode == "CLONE")
            {
                dynamic resultSet;
                if (type == "CLONE")
                {
                    obj.Acq_Deal_Pushback_Code = 0;
                }
                Acq_Deal_Pushback_Service objADPS = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal_Pushback objAcq_Deal_Pushback = CreatePushbackObject(obj, hdnTitleList, hdnRights_Platform_Code, Year ?? 0, Month ?? 0, Day ?? 0,
                    hdnTerritory_Type, hdn_Dubbing_Type, hdn_SubTitling_Type, hdnTerritoryList, hdn_Dubb_LanguageList, hdn_Sub_LanguageList, hdnRight_Start_Date, hdnRight_End_Date, ref objADPS);
                objAcq_Deal_Pushback = CreateRightObject(objAcq_Deal_Pushback, obj);
                objADPS.Save(objAcq_Deal_Pushback, out resultSet);
                lstDupRecords = resultSet;
                //if (lstDupRecords.Count() > 0)
                //{
                //    return ShowValidationPopup(resultSet);
                //}
                //if (lstDupRecords.Count() > 0)
                //{
                //    Show_Validation_Popup("","5",1);
                //}
                objAcq_Deal_Pushback = null;
                objADPS = null;
            }
            string status = msg, errorMessag = "";
            Dictionary<string, object> obj_Dictionary = new Dictionary<string, object>();
            obj_Dictionary.Add("Status", status);
            
            if(lstDupRecords.Count() > 0)
            {
                errorMessag = "ERROR";
            }
            obj_Dictionary.Add("Error_Message", errorMessag);
            return Json(obj_Dictionary);
            //return RedirectToAction("Index", new { CallFrom = msg, Selected_Title_Code = Title_Code_Search });            
        }
        private bool ShowValidationPopup(dynamic resultSet)
        {
            lstDupRecords = resultSet;

            if (lstDupRecords.Count > 0)
                return false;

            return true;
        }
        public ActionResult Show_Validation_Popup(string searchForTitles, string PageSize, int PageNo)
        {
            MultiSelectList arr_Title_List = new MultiSelectList(lstDupRecords.Select(s => new { Title_Name = s.Title_Name }).Distinct().ToList(), "Title_Name", "Title_Name", searchForTitles.Split(','));
            ViewBag.SearchTitles = arr_Title_List;

            PageNo += 1;
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = PageSize;
            int Record_Count = 0;
            List<USP_Validate_Rev_HB_Duplication_UDT_Acq> lstDuplicates = (new GlobalController()).Acq_Rev_HB_Validation_Popup(lstDupRecords, searchForTitles, PageSize, PageNo, out Record_Count);
            ViewBag.RecordCount = Record_Count;

            return PartialView("_Acq_Rev_HB_Validation_Popup", lstDuplicates);
        }
        private Acq_Deal_Pushback CreateRightObject(Acq_Deal_Pushback objExistingRights, Acq_Deal_Pushback objMVCRights)
        {
           
            Deal_Rights_UDT objDRUDT = new Deal_Rights_UDT();

            objDRUDT.Title_Code = objExistingRights.Acq_Deal_Pushback_Title.Select(x=>x.Title_Code).First();
            objDRUDT.Platform_Code = objExistingRights.Acq_Deal_Pushback_Platform.Select(x=>x.Platform_Code).First();
            //objDRUDT.Deal_Rights_Code = objPage_Properties.TCODE > 0 ? 0 : objPage_Properties.RCODE; //objExistingRights.Acq_Deal_Rights_Code;
            objDRUDT.Deal_Rights_Code = objExistingRights.Acq_Deal_Pushback_Code;
            objDRUDT.Deal_Code = objExistingRights.Acq_Deal_Code = objDeal_Schema.Deal_Code;
            //objDRUDT.Is_Exclusive = objExistingRights.Is_Exclusive = IsExclusive ? "Y" : "N";
            //objDRUDT.Is_Exclusive = objExistingRights.Is_Exclusive = IsExclusive;
            //objExistingRights.Is = Is_Under_Production;
            //objDRUDT.Is_Theatrical_Right = objExistingRights.Is = Is_Theatrical_Right ? "Y" : "N";

            objDRUDT.Is_Title_Language_Right = objExistingRights.Is_Title_Language_Right;  /*? "Y" : "N";*/
            //objDRUDT.Sub_License_Code = objMVCRights.Sub_License_Code;
            //objDRUDT.Is_Sub_License = objExistingRights.Is_Sub_License = chkSubLicensing.Checked ? "Y" : "N";

            //if (objMVCRights.Sub_License_Code > 0)
            //if (form["hdnSub_License_Code"] != "0" && form["hdnSub_License_Code"] != null && form["hdnSub_License_Code"] != "" && form["hdnSub_License_Code"] != "-1")
            //{
            //    objDRUDT.Sub_License_Code = objExistingRights.Sub_License_Code = Convert.ToInt32(form["hdnSub_License_Code"]);
            //    objDRUDT.Is_Sub_License = objExistingRights.Is_Sub_License = "Y";
            //}
            //else
            //{
            //    objDRUDT.Sub_License_Code = objExistingRights.Sub_License_Code = null;
            //    objDRUDT.Is_Sub_License = objExistingRights.Is_Sub_License = "N";
            //}

            //objDRUDT.Is_Theatrical_Right = objExistingRights.Is_Theatrical_Right = objMVCRights.Is_Theatrical_Right.ToUpper() == "TRUE" ? "Y" : "N";
            if (objMVCRights.Right_Type == "M" && (objExistingRights.Right_Type == "Y" || objExistingRights.Right_Type == "U"))
                objExistingRights.Right_Start_Date = objExistingRights.Right_End_Date = objExistingRights.Right_Start_Date = objExistingRights.Right_End_Date = null;

            objDRUDT.Right_Type = objExistingRights.Right_Type = objMVCRights.Right_Type;
            objExistingRights.Right_Type = objMVCRights.Right_Type;
            objDRUDT.Term = objExistingRights.Term;//= "";
            objDRUDT.Milestone_Type_Code = objExistingRights.Milestone_Type_Code = null;
            objDRUDT.Milestone_No_Of_Unit = objExistingRights.Milestone_No_Of_Unit = null;
            objDRUDT.Milestone_Unit_Type = objExistingRights.Milestone_Unit_Type = null;

            objExistingRights.LstDeal_Pushback_UDT = new List<Deal_Rights_UDT>();
            objExistingRights.LstDeal_Pushback_UDT.Add(objDRUDT);


            bool newTitle = false;
            objExistingRights.LstDeal_Pushback_Title_UDT.Clear();
            foreach (Acq_Deal_Pushback_Title objTitle in objExistingRights.Acq_Deal_Pushback_Title)
            {
                //if (objTitle.Title_Code == objPage_Properties.TCODE
                //    && objTitle.Episode_From == objPage_Properties.Episode_From && objTitle.Episode_To == objPage_Properties.Episode_To) { }
                //else if (objTitle.EntityState != State.Deleted)
                if (objTitle.EntityState != State.Deleted)
                {
                    Deal_Rights_Title_UDT objDeal_Rights_Title_UDT = new Deal_Rights_Title_UDT();
                    objDeal_Rights_Title_UDT.Deal_Rights_Code = (objTitle.Acq_Deal_Pushback_Code == null) ? 0 : objTitle.Acq_Deal_Pushback_Code;
                    objDeal_Rights_Title_UDT.Title_Code = (objTitle.Title_Code == null) ? 0 : objTitle.Title_Code;
                    objDeal_Rights_Title_UDT.Episode_From = objTitle.Episode_From;
                    objDeal_Rights_Title_UDT.Episode_To = objTitle.Episode_To;
                    objExistingRights.LstDeal_Pushback_Title_UDT.Add(objDeal_Rights_Title_UDT);
                    newTitle = true;
                }
            }

            objExistingRights.LstDeal_Pushback_Platform_UDT = new List<Deal_Rights_Platform_UDT>(
                            objExistingRights.Acq_Deal_Pushback_Platform.Where(t => t.EntityState != State.Deleted && (t.Platform_Code != objExistingRights.Acq_Deal_Pushback_Platform.Select(x=>x.Platform_Code).First() || newTitle)).Select(x =>
                            new Deal_Rights_Platform_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Pushback_Code == null) ? 0 : x.Acq_Deal_Pushback_Code,
                                Platform_Code = (x.Platform_Code == null) ? 0 : x.Platform_Code
                            }));

            objExistingRights.LstDeal_Pushback_Territory_UDT = new List<Deal_Rights_Territory_UDT>(
                            objExistingRights.Acq_Deal_Pushback_Territory.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Territory_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Pushback_Code == null) ? 0 : x.Acq_Deal_Pushback_Code,
                                Territory_Code = (x.Territory_Code == null) ? 0 : x.Territory_Code,
                                Country_Code = (x.Country_Code == null) ? 0 : x.Country_Code,
                                Territory_Type = (x.Territory_Type == null) ? "I" : x.Territory_Type
                            }));

            objExistingRights.LstDeal_Pushback_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>(
                            objExistingRights.Acq_Deal_Pushback_Subtitling.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Subtitling_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Pushback_Code == null) ? 0 : x.Acq_Deal_Pushback_Code,
                                Subtitling_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));

            objExistingRights.LstDeal_Pushback_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>(
                            objExistingRights.Acq_Deal_Pushback_Dubbing.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Dubbing_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Pushback_Code == null) ? 0 : x.Acq_Deal_Pushback_Code,
                                Dubbing_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));
            return objExistingRights;
        }
        private Acq_Deal_Pushback CreatePushbackObject(Acq_Deal_Pushback objDeal_Pushback, string hdnMMovies, string hdnRights_Platform, int? Year, int? Month, int? Day,
               string hdnTerritory_Type, string hdn_Dubbing_Type, string hdn_SubTitling_Type, string hdnTerritoryList, string hdn_Dubb_LanguageList, string hdn_Sub_LanguageList, string Right_Start_Date, string Right_End_Date, ref Acq_Deal_Pushback_Service objADPS)
        {
            Acq_Deal_Pushback objAcq_Deal_Pushback = new Acq_Deal_Pushback();
            if (objDeal_Pushback.Acq_Deal_Pushback_Code > 0)
            {
                objAcq_Deal_Pushback = objADPS.GetById(objDeal_Pushback.Acq_Deal_Pushback_Code);
                objAcq_Deal_Pushback.EntityState = State.Modified;
            }
            else
                objAcq_Deal_Pushback.EntityState = State.Added;
            objAcq_Deal_Pushback.Acq_Deal_Code = objDeal_Schema.Deal_Code;
            objAcq_Deal_Pushback.Right_Type = objDeal_Pushback.Right_Type;
            if (objAcq_Deal_Pushback.Right_Type == "Y")
            {
                objAcq_Deal_Pushback.Term = Year.ToString() + "." + Month.ToString() + "." + Day.ToString();
                if (Right_Start_Date != null)
                    objAcq_Deal_Pushback.Right_Start_Date = Convert.ToDateTime(objDeal_Pushback.Right_Start_Date);
                if (Right_End_Date != null && objDeal_Pushback.Is_Tentative != "Y")
                    objAcq_Deal_Pushback.Right_End_Date = Convert.ToDateTime(objDeal_Pushback.Right_End_Date);
                else
                {
                    DateTime dtSD = Convert.ToDateTime(objAcq_Deal_Pushback.Right_Start_Date);
                    if (Year != null && Year > 0)
                        dtSD = dtSD.AddYears(Year ?? 0);
                    if (Month != null && Month > 0)
                        dtSD = dtSD.AddMonths(Month ?? 0);
                    if (Day != null && Day > 0)
                        dtSD = dtSD.AddDays(Day ?? 0);
                    dtSD = dtSD.AddDays(-1);
                    objAcq_Deal_Pushback.Right_End_Date = dtSD;
                }
                objAcq_Deal_Pushback.Milestone_Type_Code = null;
                objAcq_Deal_Pushback.Milestone_No_Of_Unit = null;
                objAcq_Deal_Pushback.Milestone_Unit_Type = null;
                objAcq_Deal_Pushback.Is_Tentative = objDeal_Pushback.Is_Tentative;
            }
            else
            {
                objAcq_Deal_Pushback.Right_Start_Date = null;
                objAcq_Deal_Pushback.Right_End_Date = null;
                objAcq_Deal_Pushback.Is_Tentative = "N";
                objAcq_Deal_Pushback.Milestone_Type_Code = objDeal_Pushback.Milestone_Type_Code;
                objAcq_Deal_Pushback.Milestone_No_Of_Unit = objDeal_Pushback.Milestone_No_Of_Unit;
                objAcq_Deal_Pushback.Milestone_Unit_Type = objDeal_Pushback.Milestone_Unit_Type;
                objAcq_Deal_Pushback.Term = null;
            }
            objAcq_Deal_Pushback.Is_Title_Language_Right = objDeal_Pushback.Is_Title_Language_Right;
            objAcq_Deal_Pushback.Remarks = objDeal_Pushback.Remarks;
            #region ========= Title object creation =========
            objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.ToList().ForEach(i => i.EntityState = State.Deleted);
            if (hdnMMovies != "")
            {
                string[] tiTitle_Codes = hdnMMovies.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string titleCode in tiTitle_Codes)
                {
                    Acq_Deal_Pushback_Title objT = (Acq_Deal_Pushback_Title)objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(t => t.Title_Code == Convert.ToInt32(titleCode)).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Acq_Deal_Pushback_Title();
                    if (objT.Acq_Deal_Pushback_Title_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        int code = Convert.ToInt32((string.IsNullOrEmpty(titleCode)) ? "0" : titleCode);
                        if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        {
                            Title_List objTL = null;
                            objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();
                            objT.Episode_From = objTL.Episode_From;
                            objT.Episode_To = objTL.Episode_To;
                            objT.Title_Code = objTL.Title_Code;
                        }
                        else
                        {
                            objT.Episode_From = 1;
                            objT.Episode_To = 1;
                            objT.Title_Code = code;
                        }
                        objT.EntityState = State.Added;
                        objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Add(objT);
                    }
                }
            }
            #endregion
            #region=========Save platform=====
            string strSelectedPlatforms = hdnRights_Platform.Trim().Replace("_", "").Replace(" ", "").Replace("_0", "");
            if (strSelectedPlatforms.Trim() != "")
            {
                objAcq_Deal_Pushback.Acq_Deal_Pushback_Platform.ToList().ForEach(i => i.EntityState = State.Deleted);
                string[] P_Codes = strSelectedPlatforms.Trim().Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Distinct().ToArray();
                foreach (string platformCode in P_Codes)
                {
                    if (platformCode.Trim() != "" && platformCode.Trim() != "0")
                    {
                        Acq_Deal_Pushback_Platform objP = objAcq_Deal_Pushback.Acq_Deal_Pushback_Platform.Where(t => t.Platform_Code == Convert.ToInt32(platformCode)).Select(i => i).FirstOrDefault();
                        if (objP == null)
                        {
                            objP = new Acq_Deal_Pushback_Platform();
                            objP.Platform_Code = Convert.ToInt32(platformCode.Trim());
                            objP.EntityState = State.Added;
                        }
                        else
                            objP.EntityState = State.Unchanged;
                        objAcq_Deal_Pushback.Acq_Deal_Pushback_Platform.Add(objP);
                    }
                }
            }
            #endregion
            #region ========= Terr object creation =========
            objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.ToList().ForEach(i => i.EntityState = State.Deleted);
            bool IsChangeType = false;
            if (objDeal_Pushback.Acq_Deal_Pushback_Territory != null)
                if (objDeal_Pushback.Acq_Deal_Pushback_Territory.Count > 0)
                {
                    if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.ElementAt(0).Territory_Type == "G" && hdnTerritory_Type == "I")
                    {
                        if (hdnTerritoryList != "")
                        {
                            string[] terCodes = hdnTerritoryList.Split(new char[] { ',' }, StringSplitOptions.None);
                            foreach (string TerritoryCode in terCodes)
                            {
                                Acq_Deal_Pushback_Territory objTer = new Acq_Deal_Pushback_Territory();
                                objTer.Territory_Type = "I";
                                objTer.EntityState = State.Added;
                                objTer.Territory_Code = null;
                                objTer.Country_Code = Convert.ToInt32(TerritoryCode);
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Add(objTer);
                            }
                        }
                        IsChangeType = true;
                    }
                    else if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.ElementAt(0).Territory_Type == "I" && hdnTerritory_Type == "G")
                    {
                        if (hdnTerritoryList != "")
                        {
                            string[] terCodes = hdnTerritoryList.Split(new char[] { ',' }, StringSplitOptions.None);
                            foreach (string TerritoryCode in terCodes)
                            {
                                Acq_Deal_Pushback_Territory objTer = new Acq_Deal_Pushback_Territory();
                                objTer.Territory_Type = "G";
                                objTer.EntityState = State.Added;
                                objTer.Country_Code = null;
                                objTer.Territory_Code = Convert.ToInt32(TerritoryCode);
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Add(objTer);
                            }
                        }
                        IsChangeType = true;
                    }
                }
            if (!IsChangeType)
            {
                if (hdnTerritoryList != "")
                {
                    string[] terCodes = hdnTerritoryList.Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string TerritoryCode in terCodes)
                    {
                        Acq_Deal_Pushback_Territory objTer = null;
                        if (hdnTerritory_Type == "I")
                        {
                            objTer = objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Where(t => t.Country_Code == Convert.ToInt32(TerritoryCode)).Select(i => i).FirstOrDefault();
                            if (objTer == null)
                            {
                                objTer = new Acq_Deal_Pushback_Territory();
                                objTer.Territory_Type = "I";
                                objTer.Territory_Code = null;
                                objTer.Country_Code = Convert.ToInt32(TerritoryCode);
                                objTer.EntityState = State.Added;
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Add(objTer);
                            }
                            else
                                objTer.EntityState = State.Unchanged;
                        }
                        else
                        {
                            objTer = objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Where(t => t.Territory_Code == Convert.ToInt32(TerritoryCode)).Select(i => i).FirstOrDefault();
                            if (objTer == null)
                            {
                                objTer = new Acq_Deal_Pushback_Territory();
                                objTer.Territory_Type = "G";
                                objTer.Territory_Code = Convert.ToInt32(TerritoryCode);
                                objTer.Country_Code = null;
                                objTer.EntityState = State.Added;
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Add(objTer);
                            }
                            else
                                objTer.EntityState = State.Unchanged;
                        }
                    }
                }
            }
            #endregion
            #region ========= SubTitle object creation =========
            IsChangeType = false;
            objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.ToList<Acq_Deal_Pushback_Subtitling>().ForEach(t => t.EntityState = State.Deleted);
            if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling != null)
                if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Count > 0)
                {
                    if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.ElementAt(0).Language_Type == "G" && hdn_SubTitling_Type == "SL")
                    {
                        if (hdn_Sub_LanguageList != "")
                        {
                            string[] terCodes = hdn_Sub_LanguageList.Split(new char[] { ',' }, StringSplitOptions.None);
                            foreach (string SubtitlingCode in terCodes)
                            {
                                Acq_Deal_Pushback_Subtitling objSub = new Acq_Deal_Pushback_Subtitling();
                                objSub.Language_Type = "L";
                                objSub.EntityState = State.Added;
                                objSub.Language_Code = Convert.ToInt32(SubtitlingCode);
                                objDeal_Pushback.Acq_Deal_Pushback_Subtitling.Add(objSub);
                            }
                        }
                        IsChangeType = true;
                    }
                    else if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.ElementAt(0).Language_Type == "L" && hdn_SubTitling_Type == "SG")
                    {
                        if (hdn_Sub_LanguageList != "")
                        {
                            string[] terCodes = hdn_Sub_LanguageList.Split(new char[] { ',' }, StringSplitOptions.None);
                            foreach (string SubtitlingCode in terCodes)
                            {
                                Acq_Deal_Pushback_Subtitling objSub = new Acq_Deal_Pushback_Subtitling();
                                objSub.Language_Type = "G";
                                objSub.EntityState = State.Added;
                                objSub.Language_Group_Code = Convert.ToInt32(SubtitlingCode);
                                objDeal_Pushback.Acq_Deal_Pushback_Subtitling.Add(objSub);
                            }
                        }
                        IsChangeType = true;
                    }
                }
            if (!IsChangeType)
            {
                if (hdn_Sub_LanguageList != "")
                {
                    string[] subCodes = hdn_Sub_LanguageList.Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string SubtitlingCode in subCodes)
                    {
                        Acq_Deal_Pushback_Subtitling objSub = null;
                        if (hdn_SubTitling_Type == "SG")
                        {
                            objSub = objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Where(t => t.Language_Group_Code == Convert.ToInt32(SubtitlingCode)).Select(i => i).FirstOrDefault();
                            if (objSub == null)
                            {
                                objSub = new Acq_Deal_Pushback_Subtitling();
                                objSub.Language_Type = "G";
                                objSub.Language_Group_Code = Convert.ToInt32(SubtitlingCode);
                                objSub.EntityState = State.Added;
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Add(objSub);
                            }
                            else
                                objSub.EntityState = State.Unchanged;
                        }
                        else
                        {
                            objSub = objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Where(t => t.Language_Code == Convert.ToInt32(SubtitlingCode)).Select(i => i).FirstOrDefault();
                            if (objSub == null)
                            {
                                objSub = new Acq_Deal_Pushback_Subtitling();
                                objSub.Language_Type = "L";
                                objSub.Language_Code = Convert.ToInt32(SubtitlingCode);
                                objSub.EntityState = State.Added;
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Add(objSub);
                            }
                            else
                                objSub.EntityState = State.Unchanged;
                        }
                    }
                }
            }
            #endregion
            #region ========= Dubbing object creation =========
            IsChangeType = false;
            objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.ToList<Acq_Deal_Pushback_Dubbing>().ForEach(t => t.EntityState = State.Deleted);
            if (objDeal_Pushback.Acq_Deal_Pushback_Dubbing != null)
                if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Count > 0)
                {
                    if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.ElementAt(0).Language_Type == "G" && hdn_Dubbing_Type == "DL")
                    {
                        if (hdn_Dubb_LanguageList != "")
                        {
                            string[] terCodes = hdn_Dubb_LanguageList.Split(new char[] { ',' }, StringSplitOptions.None);
                            foreach (string DubbingCode in terCodes)
                            {
                                Acq_Deal_Pushback_Dubbing objSub = new Acq_Deal_Pushback_Dubbing();
                                objSub.Language_Type = "L";
                                objSub.EntityState = State.Added;
                                objSub.Language_Code = Convert.ToInt32(DubbingCode);
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Add(objSub);
                            }
                        }
                        IsChangeType = true;
                    }
                    else if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.ElementAt(0).Language_Type == "L" && hdn_Dubbing_Type == "DG")
                    {
                        if (hdn_Dubb_LanguageList != "")
                        {
                            string[] terCodes = hdn_Dubb_LanguageList.Split(new char[] { ',' }, StringSplitOptions.None);
                            foreach (string DubbingCode in terCodes)
                            {
                                Acq_Deal_Pushback_Dubbing objSub = new Acq_Deal_Pushback_Dubbing();
                                objSub.Language_Type = "G";
                                objSub.EntityState = State.Added;
                                objSub.Language_Group_Code = Convert.ToInt32(DubbingCode);
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Add(objSub);
                            }
                        }
                        IsChangeType = true;
                    }
                }
            if (!IsChangeType)
            {
                if (hdn_Dubb_LanguageList != "")
                {
                    string[] subCodes = hdn_Dubb_LanguageList.Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string DubbingCode in subCodes)
                    {
                        Acq_Deal_Pushback_Dubbing objSub = null;
                        if (hdn_Dubbing_Type == "DG")
                        {
                            objSub = objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Where(t => t.Language_Group_Code == Convert.ToInt32(DubbingCode)).Select(i => i).FirstOrDefault();
                            if (objSub == null)
                            {
                                objSub = new Acq_Deal_Pushback_Dubbing();
                                objSub.Language_Type = "G";
                                objSub.Language_Group_Code = Convert.ToInt32(DubbingCode);
                                objSub.EntityState = State.Added;
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Add(objSub);
                            }
                            else
                                objSub.EntityState = State.Unchanged;
                        }
                        else
                        {
                            objSub = objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Where(t => t.Language_Code == Convert.ToInt32(DubbingCode)).Select(i => i).FirstOrDefault();
                            if (objSub == null)
                            {
                                objSub = new Acq_Deal_Pushback_Dubbing();
                                objSub.Language_Type = "L";
                                objSub.Language_Code = Convert.ToInt32(DubbingCode);
                                objSub.EntityState = State.Added;
                                objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Add(objSub);
                            }
                            else
                                objSub.EntityState = State.Unchanged;
                        }
                    }
                }
            }
            #endregion
            return objAcq_Deal_Pushback;
        }

        public Acq_Deal_Pushback SetNewAcqDealRight(Acq_Deal_Pushback objExistingRight, int? Title_Code, int? Episode_From, int? Episode_To, int? Platform_Code)
        {
            Acq_Deal_Pushback objSecondRight = new Acq_Deal_Pushback();
            Acq_Deal_Pushback_Title objT = new Acq_Deal_Pushback_Title();
            objT.Title_Code = Title_Code;
            objT.Episode_From = Episode_From;
            objT.Episode_To = Episode_To;
            objT.EntityState = State.Added;
            objSecondRight.Acq_Deal_Pushback_Title.Add(objT);
            objExistingRight.Acq_Deal_Pushback_Platform.ToList<Acq_Deal_Pushback_Platform>().ForEach(t =>
            {
                if (t.Platform_Code != Platform_Code)
                {
                    Acq_Deal_Pushback_Platform objP = new Acq_Deal_Pushback_Platform();
                    objP.Platform_Code = t.Platform_Code;
                    objP.EntityState = State.Added;
                    objSecondRight.Acq_Deal_Pushback_Platform.Add(objP);
                }
            });
            objExistingRight.Acq_Deal_Pushback_Territory.ToList<Acq_Deal_Pushback_Territory>().ForEach(t =>
            {
                Acq_Deal_Pushback_Territory objTer = new Acq_Deal_Pushback_Territory();
                objTer.Territory_Code = t.Territory_Code;
                objTer.Territory_Type = t.Territory_Type;
                objTer.Country_Code = t.Country_Code;
                objTer.EntityState = State.Added;
                objSecondRight.Acq_Deal_Pushback_Territory.Add(objTer);
            });
            objExistingRight.Acq_Deal_Pushback_Subtitling.ToList<Acq_Deal_Pushback_Subtitling>().ForEach(t =>
            {
                Acq_Deal_Pushback_Subtitling objS = new Acq_Deal_Pushback_Subtitling();
                objS.Language_Code = t.Language_Code;
                objS.Language_Type = t.Language_Type;
                objS.Language_Group_Code = t.Language_Group_Code;
                objS.EntityState = State.Added;
                objSecondRight.Acq_Deal_Pushback_Subtitling.Add(objS);
            });
            objExistingRight.Acq_Deal_Pushback_Dubbing.ToList<Acq_Deal_Pushback_Dubbing>().ForEach(t =>
            {
                Acq_Deal_Pushback_Dubbing objD = new Acq_Deal_Pushback_Dubbing();
                objD.Language_Code = t.Language_Code;
                objD.Language_Type = t.Language_Type;
                objD.Language_Group_Code = t.Language_Group_Code;
                objD.EntityState = State.Added;
                objSecondRight.Acq_Deal_Pushback_Dubbing.Add(objD);
            });

            objSecondRight.Acq_Deal_Code = objExistingRight.Acq_Deal_Code;
            objSecondRight.Is_Title_Language_Right = objExistingRight.Is_Title_Language_Right;
            objSecondRight.Right_Type = objExistingRight.Right_Type;
            objSecondRight.Is_Tentative = objExistingRight.Is_Tentative;
            objSecondRight.Right_Start_Date = objExistingRight.Right_Start_Date;
            objSecondRight.Right_End_Date = objExistingRight.Right_End_Date;
            objSecondRight.Right_Start_Date = objExistingRight.Right_Start_Date;
            objSecondRight.Right_End_Date = objExistingRight.Right_End_Date;
            objSecondRight.Term = objExistingRight.Term;
            objSecondRight.Milestone_Type_Code = objExistingRight.Milestone_Type_Code;
            objSecondRight.Milestone_No_Of_Unit = objExistingRight.Milestone_No_Of_Unit;
            objSecondRight.Milestone_Unit_Type = objExistingRight.Milestone_Unit_Type;
            objSecondRight.Remarks = objExistingRight.Remarks;
            objSecondRight.EntityState = State.Added;
            return objSecondRight;
        }
        [HttpPost]
        public PartialViewResult DeletePushback(int RightCode, int DealCode, int TitleCode, int PlatformCode, int EpisodeFrom, int EpisodeTo, string View_Type, string Title_Code_Serch, int txtpageSize, int PageNo)
        {
            DPlatformCode = "D";
            int Acq_Deal_Pushback_Code = RightCode;
            string msg = "";
            try
            {

                int Right_Code = RightCode;
                int Deal_Code = DealCode;
                int Episode_From = EpisodeFrom;
                int Episode_To = EpisodeTo;
                int Platform_Code = 0;
                if (View_Type == "D")
                    Platform_Code = PlatformCode;
                bool IsSameAsGroup = false;
                if (TitleCode > 0 || Platform_Code > 0)
                {
                    Acq_Deal objDeal = new Acq_Deal();
                    Acq_Deal_Service objADS = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                    objDeal = objADS.GetById(Deal_Code);
                    Acq_Deal_Pushback objExistingRight = objDeal.Acq_Deal_Pushback.Where(t => t.Acq_Deal_Pushback_Code == Right_Code).FirstOrDefault();
                    if (objExistingRight.Acq_Deal_Pushback_Title.Count == 1 && TitleCode > 0 && objExistingRight.Acq_Deal_Pushback_Platform.Count == 1 && Platform_Code > 0)
                        IsSameAsGroup = true;
                    else if (objExistingRight.Acq_Deal_Pushback_Title.Count == 1 && TitleCode > 0 && Platform_Code == 0)
                        IsSameAsGroup = true;
                    else
                    {
                        bool isMovieDelete = true;
                        if (objExistingRight.Acq_Deal_Pushback_Title.Count > 1)
                            objExistingRight.Acq_Deal_Pushback_Title.Where(t => t.Title_Code == TitleCode && t.Episode_From == Episode_From && t.Episode_To == Episode_To).ToList<Acq_Deal_Pushback_Title>().ForEach(x => { x.EntityState = State.Deleted; });
                        else
                            isMovieDelete = false;

                        if (Platform_Code > 0)
                        {
                            if (!isMovieDelete)
                                objExistingRight.Acq_Deal_Pushback_Platform.ToList<Acq_Deal_Pushback_Platform>().ForEach(t => { if (t.Platform_Code == Platform_Code) t.EntityState = State.Deleted; });
                            else if (objExistingRight.Acq_Deal_Pushback_Platform.Count > 1)
                            {
                                Acq_Deal_Pushback objSecondRight = SetNewAcqDealRight(objExistingRight, TitleCode, Episode_From, Episode_To, Platform_Code);
                                objDeal.Acq_Deal_Pushback.Add(objSecondRight);
                            }
                        }
                        objExistingRight.EntityState = State.Modified;
                        objDeal.EntityState = State.Modified;
                        objDeal.SaveGeneralOnly = false;
                        dynamic resultSet;
                        objADS.Save(objDeal, out resultSet);
                    }
                }
                else
                    IsSameAsGroup = true;

                if (IsSameAsGroup)
                {
                    Acq_Deal_Pushback_Service objADRS = new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName);
                    Acq_Deal_Pushback objRights = objADRS.GetById(Right_Code);
                    objRights.EntityState = State.Deleted;
                    dynamic resultSet;
                    bool isValid = objADRS.Delete(objRights, out resultSet);
                    if (isValid)
                        msg = objMessageKey.ReverseHoldbackDeletedSuccessfully;
                }
            }
            catch (Exception ex) { }
            ViewBag.Mode = "LIST";
            objDeal_Schema.List_Pushback.Clear();
            FillForm(View_Type, Title_Code_Serch, txtpageSize, PageNo);

            int totalRcord = 0;
            ObjectParameter objPageNo = new ObjectParameter("PageNo", PageNo);
            ObjectParameter objTotalRecord = new ObjectParameter("TotalRecord", totalRcord);
            List<USP_List_Rights_Result> lst = objUSPS.USP_List_Rights("AP", objDeal_Schema.Pushback_View, objDeal_Schema.Deal_Code,
                objDeal_Schema.Pushback_Titles, "", "", "", objPageNo, txtpageSize, objTotalRecord, "").ToList();

            ViewBag.RecordCount = Convert.ToInt32(objTotalRecord.Value);
            ViewBag.PageNo = Convert.ToInt32(objPageNo.Value);

            return PartialView("~/Views/Acq_Deal/_List_Pushback.cshtml", lst);
        }
        public PartialViewResult Edit_Pushback(int PushbackCode, int TitleCode, int PlatformCode, int EpisodeFrom, int EpisodeTo, string View_Type, string Title_Code_Search, int? page_index, int? txtpageSize)
        {
            ViewBag.PushbackCode = PushbackCode;
            ViewBag.Mode = "EDIT";
            ViewBag.TCODE = TitleCode;
            ViewBag.Episode_From = EpisodeFrom;
            ViewBag.Episode_To = EpisodeTo;
            ViewBag.PCODE = PlatformCode;
            ViewBag.Title_Code_Search = Title_Code_Search;
            ViewBag.View_Type_Search = View_Type;
            Acq_Deal_Pushback objAcq_Deal_Pushback = (new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName)).GetById(PushbackCode);
            string selected_Country_Territory_Code = "";
            string selected_Subtitling_Code = "";
            string selected_Dubbing_Code = "";
            string Territory_Type = "G";
            string SL_Type = "G";
            string DL_Type = "G", selected_Title_Code = "";
            //string selected_Title_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(i => (i.Title_Code == TitleCode) || TitleCode == 0).Select(i => i.Title_Code).ToList()));            
            if (TitleCode > 0)
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To && y.Title_Code == TitleCode).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    selected_Title_Code = string.Join(",", objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(i => (i.Title_Code == TitleCode)).Select(t => t.Title_Code.ToString()).Distinct());
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    selected_Title_Code = string.Join(",", objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Select(t => t.Title_Code.ToString()).Distinct());
            }
            string[] arr_Selected_pltcode = objAcq_Deal_Pushback.Acq_Deal_Pushback_Platform.Where(i => (i.Platform_Code == PlatformCode) || PlatformCode == 0).Select(i => i.Platform_Code.ToString()).ToArray();
            BindPlatformTreeView(arr_Selected_pltcode);
            if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Where(i => i.Territory_Type == "G").Count() > 0)
                selected_Country_Territory_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Where(i => i.Territory_Type == "G").Select(i => i.Territory_Code).ToList()));
            else
            {
                selected_Country_Territory_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Where(i => i.Territory_Type == "I").Select(i => i.Country_Code).ToList()));
                Territory_Type = "I";
            }

            if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Where(i => i.Language_Type == "G").Count() > 0)
                selected_Subtitling_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Where(i => i.Language_Type == "G").Select(i => i.Language_Group_Code).ToList()));
            else
            {
                selected_Subtitling_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Where(i => i.Language_Type == "L").Select(i => i.Language_Code).ToList()));
                SL_Type = "L";
            }

            if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Where(i => i.Language_Type == "G").Count() > 0)
                selected_Dubbing_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Where(i => i.Language_Type == "G").Select(i => i.Language_Group_Code).ToList()));
            else
            {
                selected_Dubbing_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Where(i => i.Language_Type == "L").Select(i => i.Language_Code).ToList()));
                DL_Type = "L";
            }
            int selected_Milestone_Type_Code = objAcq_Deal_Pushback.Right_Type == "M" ? objAcq_Deal_Pushback.Milestone_Type_Code ?? 0 : 0;
            int Milestone_Unit_Code = objAcq_Deal_Pushback.Right_Type == "M" ? objAcq_Deal_Pushback.Milestone_Unit_Type ?? 0 : 0;
            BindAllViewBag(selected_Title_Code, selected_Country_Territory_Code, Territory_Type, selected_Subtitling_Code, SL_Type, selected_Dubbing_Code, DL_Type, selected_Milestone_Type_Code, Milestone_Unit_Code);
            int b = objAcq_Deal_Pushback.Acq_Deal_Pushback_Platform.Where(i => (i.Platform_Code != 0)).ToArray().Count();
            ViewBag.TCount = b;
            //List<USP_List_Rights_Result> lst = BindGrid(Title_Code_Search, View_Type);
            int a = selected_Country_Territory_Code.Split(',').Count();
            ViewBag.RCount = a;
            return PartialView("~/Views/Acq_Deal/_Acq_Pushback.cshtml", objAcq_Deal_Pushback);
        }



        public ActionResult Clone_Pushback(int PushbackCode, int TitleCode, int PlatformCode, int EpisodeFrom, int EpisodeTo, string View_Type, string Title_Code_Search, int? page_index, int? txtpageSize)
        {
            ViewBag.PushbackCode = PushbackCode;
            ViewBag.Mode = "CLONE";
            ViewBag.TCODE = TitleCode;
            ViewBag.Episode_From = EpisodeFrom;
            ViewBag.Episode_To = EpisodeTo;
            ViewBag.PCODE = PlatformCode;
            ViewBag.Title_Code_Search = Title_Code_Search;
            ViewBag.View_Type_Search = View_Type;
            Acq_Deal_Pushback objAcq_Deal_Pushback = (new Acq_Deal_Pushback_Service(objLoginEntity.ConnectionStringName)).GetById(PushbackCode);
            string selected_Country_Territory_Code = "";
            string selected_Subtitling_Code = "";
            string selected_Dubbing_Code = "";
            string Territory_Type = "G";
            string SL_Type = "G";
            string DL_Type = "G", selected_Title_Code = "";
            //string selected_Title_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(i => (i.Title_Code == TitleCode) || TitleCode == 0).Select(i => i.Title_Code).ToList()));            
            if (TitleCode > 0)
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To && y.Title_Code == TitleCode).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    selected_Title_Code = string.Join(",", objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(i => (i.Title_Code == TitleCode)).Select(t => t.Title_Code.ToString()).Distinct());
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    selected_Title_Code = string.Join(",", objAcq_Deal_Pushback.Acq_Deal_Pushback_Title.Select(t => t.Title_Code.ToString()).Distinct());
            }
            string[] arr_Selected_pltcode = objAcq_Deal_Pushback.Acq_Deal_Pushback_Platform.Where(i => (i.Platform_Code == PlatformCode) || PlatformCode == 0).Select(i => i.Platform_Code.ToString()).ToArray();
            BindPlatformTreeView(arr_Selected_pltcode);
            if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Where(i => i.Territory_Type == "G").Count() > 0)
                selected_Country_Territory_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Where(i => i.Territory_Type == "G").Select(i => i.Territory_Code).ToList()));
            else
            {
                selected_Country_Territory_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Territory.Where(i => i.Territory_Type == "I").Select(i => i.Country_Code).ToList()));
                Territory_Type = "I";
            }

            if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Where(i => i.Language_Type == "G").Count() > 0)
                selected_Subtitling_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Where(i => i.Language_Type == "G").Select(i => i.Language_Group_Code).ToList()));
            else
            {
                selected_Subtitling_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Subtitling.Where(i => i.Language_Type == "L").Select(i => i.Language_Code).ToList()));
                SL_Type = "L";
            }

            if (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Where(i => i.Language_Type == "G").Count() > 0)
                selected_Dubbing_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Where(i => i.Language_Type == "G").Select(i => i.Language_Group_Code).ToList()));
            else
            {
                selected_Dubbing_Code = string.Join(",", (objAcq_Deal_Pushback.Acq_Deal_Pushback_Dubbing.Where(i => i.Language_Type == "L").Select(i => i.Language_Code).ToList()));
                DL_Type = "L";
            }
            int selected_Milestone_Type_Code = objAcq_Deal_Pushback.Right_Type == "M" ? objAcq_Deal_Pushback.Milestone_Type_Code ?? 0 : 0;
            int Milestone_Unit_Code = objAcq_Deal_Pushback.Right_Type == "M" ? objAcq_Deal_Pushback.Milestone_Unit_Type ?? 0 : 0;
            BindAllViewBag(selected_Title_Code, selected_Country_Territory_Code, Territory_Type, selected_Subtitling_Code, SL_Type, selected_Dubbing_Code, DL_Type, selected_Milestone_Type_Code, Milestone_Unit_Code);
            int b = objAcq_Deal_Pushback.Acq_Deal_Pushback_Platform.Where(i => (i.Platform_Code != 0)).ToArray().Count();
            ViewBag.TCount = b;
            //List<USP_List_Rights_Result> lst = BindGrid(Title_Code_Search, View_Type);
            int a = selected_Country_Territory_Code.Split(',').Count();
            ViewBag.RCount = a;
            return PartialView("~/Views/Acq_Deal/_Acq_Pushback.cshtml", objAcq_Deal_Pushback);
        }





        private void BindPlatformTreeView(string[] arr_Selected_Plt_Code)
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            if (arr_Selected_Plt_Code.Count() > 0)
                objPTV.PlatformCodes_Selected = arr_Selected_Plt_Code;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnRights_Platform_Code";
        }
        #endregion

        #region --- Other Methods ---
        private void ClearSession()
        {
            objDeal_Schema.List_Pushback.Clear();
            objDeal_Schema.Pushback_PageNo = 1;
            objDeal_Schema.Pushback_View = "G";
            objDeal_Schema.Pushback_Titles = "";
        }
        private bool AssignPaging(int txtPageSize)
        {
            int recordPageNo = 1;
            objDeal_Schema.Pushback_PageSize = txtPageSize;
            int PageSize = txtPageSize <= 0 ? 100 : txtPageSize;
            bool IsRecordExist = true;
            int prevPageSize = 0;
            while (IsRecordExist)
            {
                if (objDeal_Schema.List_Pushback.Skip(prevPageSize).Count() > PageSize)
                {
                    int rightCode = (objDeal_Schema.List_Pushback.Skip(prevPageSize)).ElementAt(PageSize - 1).Rights_Code.Value;
                    if (rightCode == (objDeal_Schema.List_Pushback.Skip(prevPageSize)).ElementAt(PageSize).Rights_Code.Value)
                    {
                        if (objDeal_Schema.List_Pushback.Skip(prevPageSize).Where(r => r.Rights_Code < rightCode).Count() != 0)
                        {
                            objDeal_Schema.List_Pushback.Skip(prevPageSize).Where(r => r.Rights_Code < rightCode).ToList().ForEach(r =>
                            {
                                r.PageNo = recordPageNo;
                                r.PageCount = objDeal_Schema.List_Pushback.Skip(prevPageSize).Where(lr => lr.Rights_Code < rightCode).Count();
                                r.RecordCount = objDeal_Schema.List_Pushback.Count();
                            });

                            prevPageSize += objDeal_Schema.List_Pushback.Skip(prevPageSize).Where(lr => lr.Rights_Code < rightCode).Count();
                        }
                        else
                        {
                            objDeal_Schema.List_Pushback.Skip(prevPageSize).Where(r => r.Rights_Code == rightCode).ToList().ForEach(r =>
                            {
                                r.PageNo = recordPageNo;
                                r.PageCount = objDeal_Schema.List_Pushback.Skip(prevPageSize).Where(lr => lr.Rights_Code == rightCode).Count();
                                r.RecordCount = objDeal_Schema.List_Pushback.Count();
                            });

                            prevPageSize += objDeal_Schema.List_Pushback.Skip(prevPageSize).Where(lr => lr.Rights_Code == rightCode).Count();
                        }
                    }
                    else
                    {
                        objDeal_Schema.List_Pushback.Skip(prevPageSize).Take(PageSize).ToList().ForEach(r =>
                        {
                            r.PageNo = recordPageNo;
                            r.PageCount = PageSize;
                            r.RecordCount = objDeal_Schema.List_Pushback.Count();
                        });
                        prevPageSize += PageSize;
                    }
                }
                else
                {
                    objDeal_Schema.List_Pushback.Skip(prevPageSize).ToList().ForEach(r =>
                    {
                        r.PageNo = recordPageNo;
                        r.PageCount = objDeal_Schema.List_Pushback.Skip(prevPageSize).Count();
                        r.RecordCount = objDeal_Schema.List_Pushback.Count();
                    });
                    prevPageSize += objDeal_Schema.List_Pushback.Skip(prevPageSize).Count();
                }



                if (objDeal_Schema.List_Pushback.Count == prevPageSize)
                {
                    IsRecordExist = false;
                    TotalPages = recordPageNo;
                }
                else
                {
                    IsRecordExist = true;
                    recordPageNo++;
                }
            }
            return true;
        }
        public int TotalPages { get; set; }
        public string ShowAll()
        {
            ClearSession();
            return "Success";
        }
        #endregion
    }
}
