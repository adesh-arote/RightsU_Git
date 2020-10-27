using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_RightsController : BaseController
    {
        #region ============= SESSION DECLARATION ============

        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.Syn_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.Syn_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.Syn_DEAL_SCHEMA] = value; }
        }
        public Syn_Deal_Rights objSyn_Deal_Rights
        {
            get
            {
                if (Session["Syn_Deal_Rights"] == null)
                    Session["Syn_Deal_Rights"] = new Syn_Deal_Rights();
                return (Syn_Deal_Rights)Session["Syn_Deal_Rights"];
            }
            set { Session["Syn_Deal_Rights"] = value; }
        }
        public List<Syn_Deal_Rights_Holdback> Lst_Syn_Deal_Rights_Holdback
        {
            get
            {
                if (Session["Lst_Syn_Deal_Rights_Holdback"] == null && objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Count() == 0)
                    Session["Lst_Syn_Deal_Rights_Holdback"] = new List<Syn_Deal_Rights_Holdback>();
                return (List<Syn_Deal_Rights_Holdback>)Session["Lst_Syn_Deal_Rights_Holdback"];
            }
            set { Session["Lst_Syn_Deal_Rights_Holdback"] = value; }
        }
        public List<Syn_Deal_Rights_Blackout> Lst_Syn_Deal_Rights_Blackout
        {
            get
            {
                if (Session["Lst_Syn_Deal_Rights_Blackout"] == null && objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.Count() == 0)
                    Session["Lst_Syn_Deal_Rights_Blackout"] = new List<Syn_Deal_Rights_Blackout>();
                return (List<Syn_Deal_Rights_Blackout>)Session["Lst_Syn_Deal_Rights_Blackout"];
            }
            set { Session["Lst_Syn_Deal_Rights_Blackout"] = value; }
        }
        public List<Syn_Deal_Rights_Promoter> Lst_Syn_Deal_Rights_Promoter
        {
            get
            {
                if (Session["Lst_Syn_Deal_Rights_Promoter"] == null && objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Count() == 0)
                    Session["Lst_Syn_Deal_Rights_Promoter"] = new List<Syn_Deal_Rights_Promoter>();
                return (List<Syn_Deal_Rights_Promoter>)Session["Lst_Syn_Deal_Rights_Promoter"];
            }
            set { Session["Lst_Syn_Deal_Rights_Promoter"] = value; }
        }
        public Rights_Page_Properties objPage_Properties
        {
            get
            {
                if (Session["Rights_Page_Properties"] == null)
                    Session["Rights_Page_Properties"] = new Rights_Page_Properties();
                return (Rights_Page_Properties)Session["Rights_Page_Properties"];
            }
            set { Session["Rights_Page_Properties"] = value; }
        }
        public List<USP_Validate_Rights_Duplication_UDT> lstDupRecords
        {
            get
            {
                if (Session["lstDupRecords"] == null)
                    Session["lstDupRecords"] = new List<USP_Validate_Rights_Duplication_UDT>();
                return (List<USP_Validate_Rights_Duplication_UDT>)Session["lstDupRecords"];
            }
            set
            {
                Session["lstDupRecords"] = value;
            }
        }
        public string AllCountry_Territory_Codes
        {
            get
            {
                if (Session["AllCountry_Territory_Codes"] == null) return string.Empty;
                return Convert.ToString(Session["AllCountry_Territory_Codes"]);
            }
            set { Session["AllCountry_Territory_Codes"] = value; }
        }
        public string IsHB
        {
            get
            {
                if (Session["IsHB"] == null) Session["IsHB"] = "0";
                return Convert.ToString(Session["IsHB"]);
            }
            set { Session["IsHB"] = value; }
        }
        public string AllPlatform_Codes
        {
            get
            {
                if (Session["AllPlatform_Codes"] == null) return string.Empty;
                return Convert.ToString(Session["AllPlatform_Codes"]);
            }
            set { Session["AllPlatform_Codes"] = value; }
        }
        public string SubTitle_Lang_Codes
        {
            get
            {
                if (Session["SubTitle_Lang_Codes"] == null) return string.Empty;
                return Convert.ToString(Session["SubTitle_Lang_Codes"]);
            }
            set { Session["SubTitle_Lang_Codes"] = value; }
        }
        public string Dubb_Lang_Codes
        {
            get
            {
                if (Session["Dubb_Lang_Codes"] == null) return string.Empty;
                return Convert.ToString(Session["Dubb_Lang_Codes"]);
            }
            set { Session["Dubb_Lang_Codes"] = value; }
        }
        public List<Syn_Deal_Rights_Holdback_Validation> lstSDRHV
        {
            get
            {
                if (Session["lstSDRHV"] == null)
                    Session["lstSDRHV"] = new List<Syn_Deal_Rights_Holdback_Validation>();
                return (List<Syn_Deal_Rights_Holdback_Validation>)Session["lstSDRHV"];
            }
            set { Session["lstSDRHV"] = value; }
        }
        #endregion

        public ActionResult Index()
        {
            Session["HoldbackCancelled"] = null;
            objSyn_Deal_Rights = null;
            Lst_Syn_Deal_Rights_Holdback = null;
            Lst_Syn_Deal_Rights_Blackout = null;
            objPage_Properties = null;
            lstDupRecords = null;
            AllCountry_Territory_Codes = null;
            IsHB = null;
            AllPlatform_Codes = null;
            SubTitle_Lang_Codes = null;
            Dubb_Lang_Codes = null;
            lstSDRHV = null;

            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString_Rights"] != null)
            {
                obj_Dictionary = TempData["QueryString_Rights"] as Dictionary<string, string>;
                TempData.Keep("QueryString_Rights");
                objPage_Properties.RMODE = obj_Dictionary["MODE"];
            }

            if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_ADD)
            {
                objSyn_Deal_Rights = new Syn_Deal_Rights();
                objSyn_Deal_Rights.Right_Type = objSyn_Deal_Rights.Original_Right_Type = "Y";
                objSyn_Deal_Rights.Is_Theatrical_Right = "N";
                Set_Selected_Codes();
                SetVisibility();
            }
            else if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_CLONE)
            {
                objPage_Properties.RCODE = Convert.ToInt32(obj_Dictionary["RCode"]);
                objPage_Properties.PCODE = Convert.ToInt32(obj_Dictionary["PCode"]);
                objPage_Properties.TCODE = Convert.ToInt32(obj_Dictionary["TCode"]);
                objPage_Properties.Episode_From = Convert.ToInt32(obj_Dictionary["Episode_From"]);
                objPage_Properties.Episode_To = Convert.ToInt32(obj_Dictionary["Episode_To"]);
                objPage_Properties.IsHB = obj_Dictionary["IsHB"];
                FillCloneFormDetails();
                SetVisibility();
                objPage_Properties.RCODE = 0;
                objPage_Properties.TCODE = 0;
                objPage_Properties.PCODE = 0;
            }
            else if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_EDIT)
            {
                objPage_Properties.RCODE = Convert.ToInt32(obj_Dictionary["RCode"]);
                objPage_Properties.PCODE = Convert.ToInt32(obj_Dictionary["PCode"]);
                objPage_Properties.TCODE = Convert.ToInt32(obj_Dictionary["TCode"]);
                objPage_Properties.Episode_From = Convert.ToInt32(obj_Dictionary["Episode_From"]);
                objPage_Properties.Episode_To = Convert.ToInt32(obj_Dictionary["Episode_To"]);
                objPage_Properties.IsHB = obj_Dictionary["IsHB"];
                objPage_Properties.Is_Syn_Acq_Mapp = obj_Dictionary["Is_Syn_Acq_Mapp"];
                FillFormDetails();
                SetVisibility();
            }
            ViewBag.AcqSyn_Rights_Thetrical = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Rights_Thetrical").First().Parameter_Value;
            objDeal_Schema.Page_From = GlobalParams.Page_From_Rights;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;

            try
            {
                ViewBag.Term_Perputity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").First().Parameter_Value;
                ViewBag.Enabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
            }
            catch (Exception)
            {
                ViewBag.Term_Perputity = 0;
                ViewBag.Enabled_Perpetuity = "N";
            }

            Session["FileName"] = "";
            Session["FileName"] = "syn_Rights";
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.RMODE = objPage_Properties.RMODE;
            return View("~/Views/Syn_Deal/_Syn_Rights.cshtml", objSyn_Deal_Rights);
        }

        public ActionResult View()
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();

            if (TempData["QueryString_Rights"] != null)
            {
                obj_Dictionary = TempData["QueryString_Rights"] as Dictionary<string, string>;
                TempData.Keep("QueryString_Rights");
            }

            Session["HoldbackCancelled"] = null;
            objSyn_Deal_Rights = null;
            Lst_Syn_Deal_Rights_Holdback = null;
            Lst_Syn_Deal_Rights_Blackout = null;
            objPage_Properties = null;
            lstDupRecords = null;
            AllCountry_Territory_Codes = null;
            IsHB = null;
            AllPlatform_Codes = null;
            SubTitle_Lang_Codes = null;
            Dubb_Lang_Codes = null;
            lstSDRHV = null;

            objPage_Properties.RMODE = obj_Dictionary["MODE"];
            objPage_Properties.RCODE = Convert.ToInt32(obj_Dictionary["RCode"]);
            objPage_Properties.PCODE = Convert.ToInt32(obj_Dictionary["PCode"]);
            objPage_Properties.TCODE = Convert.ToInt32(obj_Dictionary["TCode"]);
            objPage_Properties.Episode_From = Convert.ToInt32(obj_Dictionary["Episode_From"]);
            objPage_Properties.Episode_To = Convert.ToInt32(obj_Dictionary["Episode_To"]);
            objPage_Properties.IsHB = obj_Dictionary["IsHB"];
            objPage_Properties.Is_Syn_Acq_Mapp = obj_Dictionary["Is_Syn_Acq_Mapp"];

            FillViewFormDetails();
            SetVisibility();
            try
            {
                ViewBag.AcqSyn_Rights_Thetrical = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Rights_Thetrical").First().Parameter_Value.ToString();
                ViewBag.Enabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
            }
            catch (Exception e)
            {
                ViewBag.Enabled_Perpetuity = "N";
            }
            if ((new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Deal_Rights_Code == objPage_Properties.RCODE).Count()) > 0)
                SetSyndication_Object();

            objDeal_Schema.Page_From = GlobalParams.Page_From_Rights;
            ViewBag.Record_Locking_Code = 0;

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;

            ViewBag.TreeId = "Rights_Platform";
            ViewBag.PromoterTab = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Promoter_Tab").Select(x => x.Parameter_Value).FirstOrDefault();
            return View("~/Views/Syn_Deal/_Syn_Rights_View.cshtml", objSyn_Deal_Rights);
        }
        private DateTime CalculateEndDate()
        {
            int Year = Convert.ToInt32(objSyn_Deal_Rights.Term_YY);
            int Month = Convert.ToInt32(objSyn_Deal_Rights.Term_MM);
            int Day = Convert.ToInt32(objSyn_Deal_Rights.Term_DD);
            DateTime EDate = (objSyn_Deal_Rights.Actual_Right_Start_Date.Value).AddYears(Year).AddMonths(Month).AddDays(Day);
            return EDate;
        }
        private void FillFormDetails()
        {
            ViewBag.MODE = "E";
            Syn_Deal_Rights_Service objADRS = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            objSyn_Deal_Rights.Syn_Deal_Rights_Code = objPage_Properties.RCODE;
            objSyn_Deal_Rights = objADRS.GetById(objSyn_Deal_Rights.Syn_Deal_Rights_Code);
            if (objSyn_Deal_Rights.Original_Right_Type == null && objSyn_Deal_Rights.Right_Type == "U")
                objSyn_Deal_Rights.Original_Right_Type = "";
            else if (objSyn_Deal_Rights.Original_Right_Type == null)
                objSyn_Deal_Rights.Original_Right_Type = objSyn_Deal_Rights.Right_Type;
            if (objPage_Properties.TCODE > 0)
            {
                int EpStart = 0, EpEnd = 0;

                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    objPage_Properties.Acquired_Title_Codes = objDeal_Schema.Title_List.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(s => s.Acq_Deal_Movie_Code).FirstOrDefault().ToString();
                    EpStart = objPage_Properties.Episode_From;
                    EpEnd = objPage_Properties.Episode_To;
                }
                else
                {
                    objPage_Properties.Acquired_Title_Codes = objPage_Properties.TCODE.ToString();
                    EpStart = 1;
                    EpEnd = 1;
                }
                objSyn_Deal_Rights.Syn_Deal_Rights_Title.Clear();
                Syn_Deal_Rights_Title objSyn_Deal_Rights_Title = new Syn_Deal_Rights_Title();
                objSyn_Deal_Rights_Title.Title_Code = objPage_Properties.TCODE;
                objSyn_Deal_Rights_Title.Episode_From = EpStart;
                objSyn_Deal_Rights_Title.Episode_To = EpEnd;
                objSyn_Deal_Rights.Syn_Deal_Rights_Title.Add(objSyn_Deal_Rights_Title);
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    objPage_Properties.Acquired_Title_Codes = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    objPage_Properties.Acquired_Title_Codes = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title_Code.ToString()).Distinct());
            }

            if (objPage_Properties.PCODE > 0)
            {
                objSyn_Deal_Rights.Syn_Deal_Rights_Platform = objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Where(t => t.Platform_Code == objPage_Properties.PCODE).ToList<Syn_Deal_Rights_Platform>();
                if (objPage_Properties.IsHB.ToUpper() == "YES")
                {
                    objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.ToList<Syn_Deal_Rights_Holdback>().ForEach(t => t.Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Syn_Deal_Rights_Holdback_Platform.Remove(x); }));
                    objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.ToList<Syn_Deal_Rights_Blackout>().ForEach(t => t.Syn_Deal_Rights_Blackout_Platform.ToList<Syn_Deal_Rights_Blackout_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Syn_Deal_Rights_Blackout_Platform.Remove(x); }));
                }
                else
                    objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Clear();
            }
            if (objSyn_Deal_Rights.Original_Right_Type == null)
                objSyn_Deal_Rights.Original_Right_Type = "";
            if (objSyn_Deal_Rights.Original_Right_Type == "Y" || objSyn_Deal_Rights.Original_Right_Type == "U")
            {
                objSyn_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objSyn_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_End_Date).Replace("-", "/");
                string[] arr = objSyn_Deal_Rights.Term.Split('.');
                objSyn_Deal_Rights.Term_YY = arr[0];
                objSyn_Deal_Rights.Term_MM = arr[1];
                objSyn_Deal_Rights.Term_DD = arr[2];

                if (objSyn_Deal_Rights.Original_Right_Type == "U")
                    objSyn_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }
            else if (objSyn_Deal_Rights.Right_Type == "U" && objSyn_Deal_Rights.Original_Right_Type.TrimEnd() == "")
            {
                objSyn_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objSyn_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }
            if (objSyn_Deal_Rights.ROFR_Date != DateTime.MinValue && objSyn_Deal_Rights.ROFR_Date != null)
            {
                objSyn_Deal_Rights.ROFR_DT = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.ROFR_Date).Replace("-", "/");
                if (objSyn_Deal_Rights.Right_End_Date != DateTime.MinValue && objSyn_Deal_Rights.Right_End_Date != null)
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString((objSyn_Deal_Rights.Right_End_Date.Value - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays);
                else
                    if (objSyn_Deal_Rights.Term_YY != null || objSyn_Deal_Rights.Term_MM != null || objSyn_Deal_Rights.Term_DD != null)
                {
                    DateTime EndDate = CalculateEndDate();
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString(((EndDate - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays) - 1);
                }
                else
                        if (objSyn_Deal_Rights.Right_Type == "M" && objSyn_Deal_Rights.Actual_Right_End_Date != null && objSyn_Deal_Rights.Actual_Right_End_Date != DateTime.MinValue)
                {
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString((objSyn_Deal_Rights.Actual_Right_End_Date.Value - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays);
                }
            }

            objPage_Properties.Acquired_Platform_Codes = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            string strPlatform = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            objSyn_Deal_Rights.Platform_Codes = strPlatform;
            objSyn_Deal_Rights.Region_Type = "I";

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Count() > 0)
                objSyn_Deal_Rights.Region_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).ElementAt(0).Territory_Type;
            objSyn_Deal_Rights.Sub_Type = "L";
            if (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Count() > 0)
                objSyn_Deal_Rights.Sub_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;
            objSyn_Deal_Rights.Dub_Type = "L";
            if (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Count() > 0)
                objSyn_Deal_Rights.Dub_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;
            if (objSyn_Deal_Rights.Sub_Type == "L")
                objPage_Properties.Acquired_Subtitling_Codes = objSyn_Deal_Rights.Sub_Codes;
            else
                if (objSyn_Deal_Rights.Sub_Codes != "" && objSyn_Deal_Rights.Sub_Codes != null)
                objPage_Properties.Acquired_Subtitling_Codes = GetLangCodes(objSyn_Deal_Rights.Sub_Codes);
            if (objSyn_Deal_Rights.Dub_Type == "L")
                objPage_Properties.Acquired_Dubbing_Codes = objSyn_Deal_Rights.Dub_Codes;
            else
                if (objSyn_Deal_Rights.Dub_Codes != "" && objSyn_Deal_Rights.Dub_Codes != null)
                objPage_Properties.Acquired_Dubbing_Codes = GetLangCodes(objSyn_Deal_Rights.Dub_Codes);
        }

        private void FillCloneFormDetails()
        {
            ViewBag.MODE = "C";
            Syn_Deal_Rights_Service objSDRS = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Rights objSyn_Deal_Rights_Current = objSDRS.GetById(objPage_Properties.RCODE);
            if (objSyn_Deal_Rights.Original_Right_Type == null && objSyn_Deal_Rights.Right_Type == "U")
                objSyn_Deal_Rights.Original_Right_Type = "";
            else if (objSyn_Deal_Rights.Original_Right_Type == null)
                objSyn_Deal_Rights.Original_Right_Type = objSyn_Deal_Rights.Right_Type;
            #region Set object for Clone

            objSyn_Deal_Rights = new Syn_Deal_Rights();
            objSyn_Deal_Rights.Promoter_Flag = objSyn_Deal_Rights_Current.Promoter_Flag;
            objSyn_Deal_Rights.Syn_Deal_Code = objSyn_Deal_Rights_Current.Syn_Deal_Code;
            objSyn_Deal_Rights.Disable_IsExclusive = objSyn_Deal_Rights_Current.Disable_IsExclusive;
            objSyn_Deal_Rights.Disable_RightType = objSyn_Deal_Rights_Current.Disable_RightType;
            objSyn_Deal_Rights.Disable_SubLicensing = objSyn_Deal_Rights_Current.Disable_SubLicensing;
            objSyn_Deal_Rights.Disable_Tentative = objSyn_Deal_Rights_Current.Disable_Tentative;
            objSyn_Deal_Rights.Disable_Thetrical = objSyn_Deal_Rights_Current.Disable_Thetrical;
            objSyn_Deal_Rights.Disable_TitleRights = objSyn_Deal_Rights_Current.Disable_TitleRights;
            objSyn_Deal_Rights.Dub_Codes = objSyn_Deal_Rights_Current.Dub_Codes;
            objSyn_Deal_Rights.Dub_Type = objSyn_Deal_Rights_Current.Dub_Type;
            objSyn_Deal_Rights.Effective_Start_Date = objSyn_Deal_Rights_Current.Effective_Start_Date;
            objSyn_Deal_Rights.End_Date = objSyn_Deal_Rights_Current.End_Date;
            objSyn_Deal_Rights.Existing_RightType = objSyn_Deal_Rights_Current.Existing_RightType;
            objSyn_Deal_Rights.Is_Exclusive = objSyn_Deal_Rights_Current.Is_Exclusive;
            objSyn_Deal_Rights.Is_ROFR = objSyn_Deal_Rights_Current.Is_ROFR;
            objSyn_Deal_Rights.Is_Sub_License = objSyn_Deal_Rights_Current.Is_Sub_License;
            objSyn_Deal_Rights.Is_Tentative = objSyn_Deal_Rights_Current.Is_Tentative;
            objSyn_Deal_Rights.Is_Theatrical_Right = objSyn_Deal_Rights_Current.Is_Theatrical_Right;
            objSyn_Deal_Rights.Is_Title_Language_Right = objSyn_Deal_Rights_Current.Is_Title_Language_Right;
            objSyn_Deal_Rights.Milestone_No_Of_Unit = objSyn_Deal_Rights_Current.Milestone_No_Of_Unit;
            objSyn_Deal_Rights.Milestone_Type_Code = objSyn_Deal_Rights_Current.Milestone_Type_Code;
            objSyn_Deal_Rights.Milestone_Unit_Type = objSyn_Deal_Rights_Current.Milestone_Unit_Type;
            objSyn_Deal_Rights.Perpetuity_Date = objSyn_Deal_Rights_Current.Perpetuity_Date;
            objSyn_Deal_Rights.Platform_Codes = objSyn_Deal_Rights_Current.Platform_Codes;
            objSyn_Deal_Rights.Region_Codes = objSyn_Deal_Rights_Current.Region_Codes;
            objSyn_Deal_Rights.Region_Type = objSyn_Deal_Rights_Current.Region_Type;
            objSyn_Deal_Rights.Restriction_Remarks = objSyn_Deal_Rights_Current.Restriction_Remarks;
            objSyn_Deal_Rights.Right_End_Date = objSyn_Deal_Rights_Current.Right_End_Date;
            objSyn_Deal_Rights.Right_Start_Date = objSyn_Deal_Rights_Current.Right_Start_Date;
            objSyn_Deal_Rights.Right_Status = objSyn_Deal_Rights_Current.Right_Status;
            objSyn_Deal_Rights.Right_Type = objSyn_Deal_Rights_Current.Right_Type;
            objSyn_Deal_Rights.ROFR_Code = objSyn_Deal_Rights_Current.ROFR_Code;
            objSyn_Deal_Rights.ROFR_Date = objSyn_Deal_Rights_Current.ROFR_Date;
            objSyn_Deal_Rights.ROFR_Days = objSyn_Deal_Rights_Current.ROFR_Days;
            objSyn_Deal_Rights.ROFR_DT = objSyn_Deal_Rights_Current.ROFR_DT;
            objSyn_Deal_Rights.Start_Date = objSyn_Deal_Rights_Current.Start_Date;
            objSyn_Deal_Rights.Sub_Codes = objSyn_Deal_Rights_Current.Sub_Codes;
            objSyn_Deal_Rights.Sub_License_Code = objSyn_Deal_Rights_Current.Sub_License_Code;
            objSyn_Deal_Rights.Sub_Type = objSyn_Deal_Rights_Current.Sub_Type;
            objSyn_Deal_Rights.Term = objSyn_Deal_Rights_Current.Term;
            objSyn_Deal_Rights.Term_MM = objSyn_Deal_Rights_Current.Term_MM;
            objSyn_Deal_Rights.Term_YY = objSyn_Deal_Rights_Current.Term_YY;
            objSyn_Deal_Rights.Term_DD = objSyn_Deal_Rights_Current.Term_DD;
            objSyn_Deal_Rights.Theatrical_Platform_Code = objSyn_Deal_Rights_Current.Theatrical_Platform_Code;
            objSyn_Deal_Rights.Title_Codes = objSyn_Deal_Rights_Current.Title_Codes;
            objSyn_Deal_Rights.Original_Right_Type = objSyn_Deal_Rights_Current.Original_Right_Type;
            objSyn_Deal_Rights_Current.Syn_Deal_Rights_Dubbing.ToList().ForEach(d =>
            {
                Syn_Deal_Rights_Dubbing objDub = new Syn_Deal_Rights_Dubbing();
                objDub.Language_Code = d.Language_Code;
                objDub.Language_Group_Code = d.Language_Group_Code;
                objDub.Language_Type = d.Language_Type;
                objDub.EntityState = State.Added;
                objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Add(objDub);
            });

            objSyn_Deal_Rights_Current.Syn_Deal_Rights_Subtitling.ToList().ForEach(d =>
            {
                Syn_Deal_Rights_Subtitling objDub = new Syn_Deal_Rights_Subtitling();
                objDub.Language_Code = d.Language_Code;
                objDub.Language_Group_Code = d.Language_Group_Code;
                objDub.Language_Type = d.Language_Type;
                objDub.EntityState = State.Added;
                objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Add(objDub);
            });

            objSyn_Deal_Rights_Current.Syn_Deal_Rights_Platform.ToList().ForEach(d =>
            {
                Syn_Deal_Rights_Platform objDub = new Syn_Deal_Rights_Platform();
                objDub.Platform_Code = d.Platform_Code;
                objDub.EntityState = State.Added;
                objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Add(objDub);
            });

            objSyn_Deal_Rights_Current.Syn_Deal_Rights_Territory.ToList().ForEach(d =>
            {
                Syn_Deal_Rights_Territory objDub = new Syn_Deal_Rights_Territory();
                objDub.Country_Code = d.Country_Code;
                objDub.Territory_Code = d.Territory_Code;
                objDub.Territory_Type = d.Territory_Type;
                objDub.EntityState = State.Added;
                objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Add(objDub);
            });

            objSyn_Deal_Rights_Current.Syn_Deal_Rights_Title.ToList().ForEach(d =>
            {
                Syn_Deal_Rights_Title objDub = new Syn_Deal_Rights_Title();
                objDub.Title_Code = d.Title_Code;
                objDub.Episode_From = d.Episode_From;
                objDub.Episode_To = d.Episode_To;
                objDub.EntityState = State.Added;
                objSyn_Deal_Rights.Syn_Deal_Rights_Title.Add(objDub);
            });

            List<Syn_Deal_Rights_Holdback> lstRightsHoldBack = objSyn_Deal_Rights_Current.Syn_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted).ToList();
            List<Syn_Deal_Rights_Blackout> lstRightsBlackOuts = objSyn_Deal_Rights_Current.Syn_Deal_Rights_Blackout.Where(t => t.EntityState != State.Deleted).ToList();
            List<Syn_Deal_Rights_Promoter> lstRightsPromoter = objSyn_Deal_Rights_Current.Syn_Deal_Rights_Promoter.Where(t => t.EntityState != State.Deleted).ToList();
            lstRightsHoldBack.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Syn_Deal_Rights_Holdback objH = new Syn_Deal_Rights_Holdback();
                    objH.Holdback_Type = t.Holdback_Type;
                    objH.HB_Run_After_Release_No = t.HB_Run_After_Release_No;
                    objH.HB_Run_After_Release_Units = t.HB_Run_After_Release_Units;
                    objH.Holdback_On_Platform_Code = t.Holdback_On_Platform_Code;
                    objH.Holdback_Release_Date = t.Holdback_Release_Date;
                    objH.Holdback_Comment = t.Holdback_Comment;
                    objH.Is_Title_Language_Right = t.Is_Title_Language_Right;
                    objH.EntityState = State.Added;
                    t.Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Holdback_Platform objP = new Syn_Deal_Rights_Holdback_Platform();
                            objP.Platform_Code = x.Platform_Code;
                            objP.EntityState = State.Added;
                            objH.Syn_Deal_Rights_Holdback_Platform.Add(objP);
                        }
                    });
                    t.Syn_Deal_Rights_Holdback_Territory.ToList<Syn_Deal_Rights_Holdback_Territory>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Holdback_Territory objTer = new Syn_Deal_Rights_Holdback_Territory();
                            objTer.Territory_Code = x.Territory_Code;
                            objTer.Territory_Type = x.Territory_Type;
                            objTer.Country_Code = x.Country_Code;
                            objTer.EntityState = State.Added;
                            objH.Syn_Deal_Rights_Holdback_Territory.Add(objTer);
                        }
                    });
                    t.Syn_Deal_Rights_Holdback_Subtitling.ToList<Syn_Deal_Rights_Holdback_Subtitling>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Holdback_Subtitling objS = new Syn_Deal_Rights_Holdback_Subtitling();
                            objS.Language_Code = x.Language_Code;
                            objS.EntityState = State.Added;
                            objH.Syn_Deal_Rights_Holdback_Subtitling.Add(objS);
                        }
                    });
                    t.Syn_Deal_Rights_Holdback_Dubbing.ToList<Syn_Deal_Rights_Holdback_Dubbing>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Holdback_Dubbing objD = new Syn_Deal_Rights_Holdback_Dubbing();
                            objD.Language_Code = x.Language_Code;
                            objD.EntityState = State.Added;
                            objH.Syn_Deal_Rights_Holdback_Dubbing.Add(objD);
                        }
                    });
                    objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Add(objH);
                }
            });

            lstRightsBlackOuts.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Syn_Deal_Rights_Blackout objB = new Syn_Deal_Rights_Blackout();
                    objB.Start_Date = t.Start_Date;
                    objB.End_Date = t.End_Date;
                    objB.EntityState = State.Added;
                    t.Syn_Deal_Rights_Blackout_Platform.ToList<Syn_Deal_Rights_Blackout_Platform>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Blackout_Platform objP = new Syn_Deal_Rights_Blackout_Platform();
                            objP.Platform_Code = x.Platform_Code;
                            objP.EntityState = State.Added;
                            objB.Syn_Deal_Rights_Blackout_Platform.Add(objP);
                        }
                    });
                    t.Syn_Deal_Rights_Blackout_Territory.ToList<Syn_Deal_Rights_Blackout_Territory>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Blackout_Territory objTer = new Syn_Deal_Rights_Blackout_Territory();
                            objTer.Territory_Code = x.Territory_Code;
                            objTer.Territory_Type = x.Territory_Type;
                            objTer.Country_Code = x.Country_Code;
                            objTer.EntityState = State.Added;
                            objB.Syn_Deal_Rights_Blackout_Territory.Add(objTer);
                        }
                    });
                    t.Syn_Deal_Rights_Blackout_Subtitling.ToList<Syn_Deal_Rights_Blackout_Subtitling>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Blackout_Subtitling objS = new Syn_Deal_Rights_Blackout_Subtitling();
                            objS.Language_Code = x.Language_Code;
                            objS.EntityState = State.Added;
                            objB.Syn_Deal_Rights_Blackout_Subtitling.Add(objS);
                        }
                    });
                    t.Syn_Deal_Rights_Blackout_Dubbing.ToList<Syn_Deal_Rights_Blackout_Dubbing>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Blackout_Dubbing objD = new Syn_Deal_Rights_Blackout_Dubbing();
                            objD.Language_Code = x.Language_Code;
                            objD.EntityState = State.Added;
                            objB.Syn_Deal_Rights_Blackout_Dubbing.Add(objD);
                        }
                    });
                    objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.Add(objB);
                }
            });
            lstRightsPromoter.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Syn_Deal_Rights_Promoter objP = new Syn_Deal_Rights_Promoter();
                    objP.EntityState = State.Added;
                    t.Syn_Deal_Rights_Promoter_Group.ToList<Syn_Deal_Rights_Promoter_Group>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Promoter_Group objPG = new Syn_Deal_Rights_Promoter_Group();
                            objPG.Promoter_Group_Code = x.Promoter_Group_Code;
                            objPG.EntityState = State.Added;
                            objP.Syn_Deal_Rights_Promoter_Group.Add(objPG);
                        }
                    });
                    t.Syn_Deal_Rights_Promoter_Remarks.ToList<Syn_Deal_Rights_Promoter_Remarks>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Promoter_Remarks objPR = new Syn_Deal_Rights_Promoter_Remarks();
                            objPR.Promoter_Remarks_Code = x.Promoter_Remarks_Code;
                            objPR.EntityState = State.Added;
                            objP.Syn_Deal_Rights_Promoter_Remarks.Add(objPR);
                        }
                    });
                    objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Add(objP);
                }
            });
            #endregion

            if (objPage_Properties.TCODE > 0)
            {
                int EpStart = 0, EpEnd = 0;
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    objPage_Properties.Acquired_Title_Codes = objDeal_Schema.Title_List.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(s => s.Acq_Deal_Movie_Code).FirstOrDefault().ToString();
                    EpStart = objPage_Properties.Episode_From;
                    EpEnd = objPage_Properties.Episode_To;
                }
                else
                {
                    objPage_Properties.Acquired_Title_Codes = objPage_Properties.TCODE.ToString();
                    EpStart = 1;
                    EpEnd = 1;
                }
                objSyn_Deal_Rights.Syn_Deal_Rights_Title.Clear();
                Syn_Deal_Rights_Title objSyn_Deal_Rights_Title = new Syn_Deal_Rights_Title();
                objSyn_Deal_Rights_Title.Title_Code = objPage_Properties.TCODE;
                objSyn_Deal_Rights_Title.Episode_From = EpStart;
                objSyn_Deal_Rights_Title.Episode_To = EpEnd;
                objSyn_Deal_Rights.Syn_Deal_Rights_Title.Add(objSyn_Deal_Rights_Title);
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    objPage_Properties.Acquired_Title_Codes = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    objPage_Properties.Acquired_Title_Codes = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title_Code.ToString()).Distinct());
            }

            if (objPage_Properties.PCODE > 0)
            {
                objSyn_Deal_Rights.Syn_Deal_Rights_Platform = objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Where(t => t.Platform_Code == objPage_Properties.PCODE).ToList<Syn_Deal_Rights_Platform>();

                if (objPage_Properties.IsHB.ToUpper() == "YES")
                {
                    objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.ToList<Syn_Deal_Rights_Holdback>().ForEach(t => t.Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Syn_Deal_Rights_Holdback_Platform.Remove(x); }));
                    objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.ToList<Syn_Deal_Rights_Blackout>().ForEach(t => t.Syn_Deal_Rights_Blackout_Platform.ToList<Syn_Deal_Rights_Blackout_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Syn_Deal_Rights_Blackout_Platform.Remove(x); }));
                }
                else
                    objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Clear();
            }

            if (objSyn_Deal_Rights.Original_Right_Type == "Y")
            {
                objSyn_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objSyn_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_End_Date).Replace("-", "/");
                string[] arr = objSyn_Deal_Rights.Term.Split('.');
                objSyn_Deal_Rights.Term_YY = arr[0];
                objSyn_Deal_Rights.Term_MM = arr[1];
                objSyn_Deal_Rights.Term_DD = arr[2];
            }
            else if (objSyn_Deal_Rights.Original_Right_Type == "U")
            {
                objSyn_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objSyn_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objSyn_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_End_Date).Replace("-", "/");
            }
            else if (objSyn_Deal_Rights.Right_Type == "U" && objSyn_Deal_Rights.Original_Right_Type.TrimEnd() == "")
            {
                objSyn_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objSyn_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }
            if (objSyn_Deal_Rights.ROFR_Date != DateTime.MinValue && objSyn_Deal_Rights.ROFR_Date != null)
            {
                objSyn_Deal_Rights.ROFR_DT = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.ROFR_Date).Replace("-", "/");

                if (objSyn_Deal_Rights.Right_End_Date != DateTime.MinValue && objSyn_Deal_Rights.Right_End_Date != null)
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString((objSyn_Deal_Rights.Right_End_Date.Value - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays);
                else
                    if (objSyn_Deal_Rights.Term_YY != null || objSyn_Deal_Rights.Term_MM != null || objSyn_Deal_Rights.Term_DD != null)
                {
                    DateTime EndDate = CalculateEndDate();
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString(((EndDate - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays) - 1);
                }
                else
                        if (objSyn_Deal_Rights.Right_Type == "M" && objSyn_Deal_Rights.Actual_Right_End_Date != null && objSyn_Deal_Rights.Actual_Right_End_Date != DateTime.MinValue)
                {
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString((objSyn_Deal_Rights.Actual_Right_End_Date.Value - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays);
                }
            }

            objPage_Properties.Acquired_Platform_Codes = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            string strPlatform = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            objSyn_Deal_Rights.Platform_Codes = strPlatform;
            Set_Selected_Codes();
            objSyn_Deal_Rights.Region_Type = "I";

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Count() > 0)
                objSyn_Deal_Rights.Region_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).ElementAt(0).Territory_Type;

            objSyn_Deal_Rights.Sub_Type = "L";

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Count() > 0)
                objSyn_Deal_Rights.Sub_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            objSyn_Deal_Rights.Dub_Type = "L";

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Count() > 0)
                objSyn_Deal_Rights.Dub_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            string Region_Type = objSyn_Deal_Rights.Region_Type;
            if (Region_Type == "I")
                Region_Type = (objSyn_Deal_Rights.Is_Theatrical_Right == "N") ? "C" : "THC";
            else
                Region_Type = (objSyn_Deal_Rights.Is_Theatrical_Right == "N") ? "T" : "THT";
            //GET_DATA_FOR_APPROVED_TITLES(objPage_Properties.Acquired_Title_Codes, objPage_Properties.Acquired_Platform_Codes, "", Region_Type, (objSyn_Deal_Rights.Sub_Type == "L") ? "SL" : "SG", (objSyn_Deal_Rights.Dub_Type == "L") ? "DL" : "DG");
            // BindDDLs();
            if (objSyn_Deal_Rights.Sub_Type == "L")
                objPage_Properties.Acquired_Subtitling_Codes = objSyn_Deal_Rights.Sub_Codes;
            else
                objPage_Properties.Acquired_Subtitling_Codes = GetLangCodes(objSyn_Deal_Rights.Sub_Codes);

            if (objSyn_Deal_Rights.Dub_Type == "L")
                objPage_Properties.Acquired_Dubbing_Codes = objSyn_Deal_Rights.Dub_Codes;
            else
                objPage_Properties.Acquired_Dubbing_Codes = GetLangCodes(objSyn_Deal_Rights.Dub_Codes);
        }

        private void FillViewFormDetails()
        {
            ViewBag.MODE = "V";
            Syn_Deal_Rights_Service objADRS = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            objSyn_Deal_Rights.Syn_Deal_Rights_Code = objPage_Properties.RCODE;
            objSyn_Deal_Rights = objADRS.GetById(objSyn_Deal_Rights.Syn_Deal_Rights_Code);
            if (objSyn_Deal_Rights.Original_Right_Type == null && objSyn_Deal_Rights.Right_Type == "U")
                objSyn_Deal_Rights.Original_Right_Type = "";
            else if (objSyn_Deal_Rights.Original_Right_Type == null)
                objSyn_Deal_Rights.Original_Right_Type = objSyn_Deal_Rights.Right_Type;
            string selectedTitles = string.Empty;

            if (objPage_Properties.TCODE > 0)
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                {
                    ViewBag.TitleNames = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(t => t.Title.Title_Name + " ( " + t.Episode_From + " - " + t.Episode_To + " ) "));
                    selectedTitles = objDeal_Schema.Title_List.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(s => s.Acq_Deal_Movie_Code).FirstOrDefault().ToString();
                    ViewBag.TitleCode_prom = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(t => t.Title.Title_Code)); ;
                }
                else if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    ViewBag.TitleNames = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(t => t.Title.Title_Name + " ( " + ((t.Episode_From == 0) ? "Unlimited" : t.Episode_From.ToString()) + " ) "));
                    selectedTitles = objDeal_Schema.Title_List.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(s => s.Acq_Deal_Movie_Code).FirstOrDefault().ToString();
                    ViewBag.TitleCode_prom = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(t => t.Title.Title_Code));
                }
                else
                {
                    ViewBag.TitleNames = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE).Select(t => t.Title.Title_Name).Distinct());
                    selectedTitles = objPage_Properties.TCODE.ToString();
                    ViewBag.TitleCode_prom = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE).Select(t => t.Title.Title_Code).Distinct());
                }
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                {
                    ViewBag.TitleNames = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title.Title_Name + " ( " + t.Episode_From + " - " + t.Episode_To + " ) "));
                    selectedTitles = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                    ViewBag.TitleCode_prom = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title.Title_Code));
                }
                else if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    ViewBag.TitleNames = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title.Title_Name + " ( " + ((t.Episode_From == 0) ? "Unlimited" : t.Episode_From.ToString()) + " ) "));
                    selectedTitles = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                    ViewBag.TitleCode_prom = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title.Title_Code));
                }
                else
                {
                    ViewBag.TitleNames = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title.Title_Name).Distinct());
                    selectedTitles = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title_Code).Distinct());
                    ViewBag.TitleCode_prom = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title.Title_Code).Distinct());
                }
            }

            if (objPage_Properties.PCODE > 0)
            {
                objSyn_Deal_Rights.Syn_Deal_Rights_Platform = objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Where(t => t.Platform_Code == objPage_Properties.PCODE).ToList<Syn_Deal_Rights_Platform>();

                if (objPage_Properties.IsHB.ToUpper() == "YES")
                {
                    objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.ToList<Syn_Deal_Rights_Holdback>().ForEach(t => t.Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Syn_Deal_Rights_Holdback_Platform.Remove(x); }));
                    objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.ToList<Syn_Deal_Rights_Blackout>().ForEach(t => t.Syn_Deal_Rights_Blackout_Platform.ToList<Syn_Deal_Rights_Blackout_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Syn_Deal_Rights_Blackout_Platform.Remove(x); }));
                }
                else
                    objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Clear();
            }

            if (objSyn_Deal_Rights.Original_Right_Type == "Y" || objSyn_Deal_Rights.Original_Right_Type == "U")
            {
                objSyn_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objSyn_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objSyn_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objSyn_Deal_Rights.Right_End_Date).Replace("-", "/");

                if (objSyn_Deal_Rights.Original_Right_Type != "Y")
                {
                    if (objSyn_Deal_Rights.Right_Start_Date != null && objSyn_Deal_Rights.Right_End_Date != null)
                        objSyn_Deal_Rights.Term = calculateTerm((DateTime)objSyn_Deal_Rights.Right_Start_Date, (DateTime)objSyn_Deal_Rights.Right_End_Date);
                }
                    string[] arr = objSyn_Deal_Rights.Term.Split('.');
                objSyn_Deal_Rights.Term_YY = arr[0];
                objSyn_Deal_Rights.Term_MM = arr[1];
                objSyn_Deal_Rights.Term_DD = arr[2];

                if (objSyn_Deal_Rights.Original_Right_Type == "U")
                    objSyn_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objSyn_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");

            }
            else if (objSyn_Deal_Rights.Right_Type == "U" && objSyn_Deal_Rights.Original_Right_Type.TrimEnd() == "")
            {
                objSyn_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objSyn_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objSyn_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }
            if (objSyn_Deal_Rights.ROFR_Date != DateTime.MinValue && objSyn_Deal_Rights.ROFR_Date != null)
            {
                objSyn_Deal_Rights.ROFR_DT = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objSyn_Deal_Rights.ROFR_Date).Replace("-", "/");
                if (objSyn_Deal_Rights.Right_End_Date != DateTime.MinValue && objSyn_Deal_Rights.Right_End_Date != null)
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString((objSyn_Deal_Rights.Right_End_Date.Value - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays);
                else
                    if (objSyn_Deal_Rights.Term_YY != null || objSyn_Deal_Rights.Term_MM != null || objSyn_Deal_Rights.Term_DD != null)
                {
                    DateTime EndDate = CalculateEndDate();
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString(((EndDate - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays) - 1);
                }
                else
                        if (objSyn_Deal_Rights.Right_Type == "M" && objSyn_Deal_Rights.Actual_Right_End_Date != null && objSyn_Deal_Rights.Actual_Right_End_Date != DateTime.MinValue)
                {
                    objSyn_Deal_Rights.ROFR_Days = Convert.ToString((objSyn_Deal_Rights.Actual_Right_End_Date.Value - objSyn_Deal_Rights.ROFR_Date.Value).TotalDays);
                }
            }

            string selected_Country = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type == "G" ? i.Territory.Territory_Name : i.Country.Country_Name).ToList()));
            ViewBag.selected_Country_Count = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type == "G" ? i.Territory.Territory_Name : i.Country.Country_Name).ToList().Count;
            string selected_SL = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Name : i.Language.Language_Name).ToList()));
            string selected_DL = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Name : i.Language.Language_Name).ToList())); ;

            ViewBag.selected_SL_Count = objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Name : i.Language.Language_Name).ToList().Count;
            ViewBag.selected_DL_Count = objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Name : i.Language.Language_Name).ToList().Count; ;

            ViewBag.selected_Country = selected_Country.Replace(",", ", ");
            ViewBag.selected_SL = selected_SL.Replace(",", ", ");
            ViewBag.selected_DL = selected_DL.Replace(",", ", ");

            ViewBag.SelectedTitleCodes = selectedTitles;
            selectedTitles = GetTitleLanguageName(selectedTitles);
            ViewBag.TitleLanguageName = (selectedTitles == "" ? "(-)" : "(" + selectedTitles + ")");





            objPage_Properties.Acquired_Platform_Codes = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            string strPlatform = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            objSyn_Deal_Rights.Platform_Codes = strPlatform;

            //added by akshay for promoter


            ViewBag.Terr_Type_prom = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type).FirstOrDefault();
            ViewBag.Sub_Type_prom = objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type).FirstOrDefault();
            ViewBag.Dub_Type_prom = objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type).FirstOrDefault();



            ViewBag.CountryCode_prom = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type == "G" ? i.Territory.Territory_Code : i.Country.Country_Code).ToList())); ;
            ViewBag.SubtitlingCode_prom = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Code : i.Language.Language_Code).ToList()));
            ViewBag.DubbingCode_prom = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Code : i.Language.Language_Code).ToList())); ;

        }

        private string calculateTerm(DateTime startDate, DateTime endDate)
        {
            DateTime FromYear = startDate;
            DateTime ToYear = endDate.AddDays(1);
            int Years = ToYear.Year - FromYear.Year;
            int month = ToYear.Month - FromYear.Month;
            int TotalMonths = (Years * 12) + month;
            int y = TotalMonths / 12;
            int m = TotalMonths % 12;
            return y + "." + m;
        }

        #region =========== BIND DDLS AND PAGE LOAD CONTROLS ===========

        public PartialViewResult BindPlatformTreeView(string strPlatform, string strTitles, string IsBulk = "N")
        {
            if (!strPlatform.StartsWith("0") && strPlatform != string.Empty)
                strPlatform = "0," + strPlatform;
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            GET_DATA_FOR_APPROVED_TITLES(strTitles, "", "PL", "", "", "");
            if (objPage_Properties.RMODE != "V" || IsBulk == "Y")
            {
                if (objSyn_Deal_Rights.Is_Theatrical_Right == "N")
                    objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                objPTV.HBPlatformCodes_Reference = (from hb in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback
                                                    from hbpm in hb.Syn_Deal_Rights_Holdback_Platform
                                                    where hbpm.EntityState != State.Deleted
                                                    select hbpm.Platform_Code.ToString()).ToArray();

                // Check title in run exist or not
                if (objPage_Properties.RMODE != "C")
                {
                    List<Title_List> lstTitle = (from rightTitle in objSyn_Deal_Rights.Syn_Deal_Rights_Title
                                                 from title in objDeal_Schema.Title_List
                                                 where rightTitle.Title_Code == title.Title_Code && rightTitle.Episode_From == title.Episode_From && rightTitle.Episode_To == title.Episode_To
                                                 select title).ToList();

                    List<Syn_Deal_Run> lstRun = new Syn_Deal_Run_Service(objLoginEntity.ConnectionStringName).SearchFor(r => r.Syn_Deal_Code == objDeal_Schema.Deal_Code).ToList();

                    var q = (from run in lstRun
                             where lstTitle.Any(t => t.Title_Code == run.Title_Code && t.Episode_From == run.Episode_From && t.Episode_To == run.Episode_To)
                             select run).Distinct();

                    if (q.Count() > 0)
                    {
                        List<string> lstPlatformCodes_isnoofrun = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_No_Of_Run == "Y").Select(p => p.Platform_Code.ToString()).ToList();
                        objPTV.RunPlatformCodes_Reference = strPlatform.Split(',').ToList().Where(x => lstPlatformCodes_isnoofrun.Contains(x)).ToArray();
                    }
                }
                objPTV.PlatformCodes_Display = (AllPlatform_Codes == "") ? "0" : AllPlatform_Codes;
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            }
            else
            {
                if (objSyn_Deal_Rights.Is_Theatrical_Right == "N")
                    objPTV.PlatformCodes_Display = strPlatform;

                objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                objPTV.Show_Selected = true;

                ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            }

            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("~/Views/Shared/_TV_Platform.cshtml");
        }

        private void SetVisibility()
        {
            System_Parameter_New_Service objSPNS = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            objPage_Properties.Is_ROFR_Type_Visible = objSPNS.SearchFor(p => p.Parameter_Name == "Is_ROFR_Type_Visible").ToList().ElementAt(0).Parameter_Value;
            //objPage_Properties.Is_ROFR_Type_Visible = objSPNS.SearchFor(p => p.Parameter_Name == "Is_ROFR_Type_Visible").Select(x => x.Parameter_Value).FirstOrDefault();
            objSyn_Deal_Rights.Theatrical_Platform_Code = objSPNS.SearchFor(p => p.Parameter_Name == "THEATRICAL_PLATFORM_CODE").ToList().ElementAt(0).Parameter_Value;
            //objSyn_Deal_Rights.Theatrical_Platform_Code = objSPNS.SearchFor(p => p.Parameter_Name == "THEATRICAL_PLATFORM_CODE").Select(x => x.Parameter_Value).FirstOrDefault();
        }

        #endregion

        #region ============== ASYNC & JSON CALLS ==============
        private List<USP_Get_Acq_PreReq_Result> Get_USP_Get_Acq_PreReq_Result(string Data_For, string str_Type)
        {
            /*
                ROR = ROFR(Rights for Refusal)
				SBL	= SubLicencing					
				SL  = SubTitle Lang.
				SG  = SubTitle Lang. Group.
				DL  = Dubbing Lang.				  
				DG  = Dubbing Group.
				T   = Territory
				C   = Couuntry
				THT = Theatrical Territory
				THC = Theatrical Country             
             */
            //Call From - str_Type - "DR" - Document.Ready,"C" - Change Event                              
            //No need to send strType to USP
            List<USP_Get_Acq_PreReq_Result> lst_USP_Get_Acq_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();
            lst_USP_Get_Acq_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Rights_PreReq(objDeal_Schema.Deal_Code,
                                                                                                   objDeal_Schema.Deal_Type_Code,
                                                                   Data_For, str_Type, AllCountry_Territory_Codes, SubTitle_Lang_Codes, Dubb_Lang_Codes).ToList();
            return lst_USP_Get_Acq_PreReq_Result;
        }
        public JsonResult Bind_JSON_ListBox(string str_Type, string Is_Thetrical, string titleCodes, string platformCodes, string Region_Type, string rdbSubtitlingLanguage, string rdbDubbingLanguage)
        {
            // I - Country // G -Territory // SL -Sub Lang // SG - Sub Lang Group // DL -Dub Lang // DG - Dubb Lang Group
            List<USP_Get_Acq_PreReq_Result> Obj_USP_Result = new List<USP_Get_Acq_PreReq_Result>();
            string Data_For = "";//, country_Territory_Codes = "0", sub_Lang_Codes = "0", dub_Lang_Codes = "0";                
            string Sub_Type = ""; string Dub_type = "";
            if (str_Type == "DR")
            {
                Set_Selected_Codes();
                if (str_Type == "DR")
                {
                    if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_ADD)
                        Data_For = "TIT,ROR,SBL";
                    else if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_EDIT || objPage_Properties.RMODE == GlobalParams.DEAL_MODE_CLONE)
                    {
                        string platform_Type = (Is_Thetrical.ToUpper() == "FALSE") ? "PL" : "TPL";
                        if (objSyn_Deal_Rights.Is_Theatrical_Right == "Y")
                            Region_Type = objSyn_Deal_Rights.Region_Type == "G" ? "THT" : "THC";
                        else
                            Region_Type = objSyn_Deal_Rights.Region_Type == "G" ? "T" : "C";
                        if (platform_Type == "TPL")
                            GET_DATA_FOR_APPROVED_TITLES(objPage_Properties.Acquired_Title_Codes, "", "TPL", "", "", "");
                        GET_DATA_FOR_APPROVED_TITLES(objPage_Properties.Acquired_Title_Codes, objPage_Properties.Acquired_Platform_Codes, "", Region_Type, (objSyn_Deal_Rights.Sub_Type == "L") ? "SL" : "SG", (objSyn_Deal_Rights.Dub_Type == "L") ? "DL" : "DG");
                        Data_For = "TIT,ROR,SBL";
                        Sub_Type = objSyn_Deal_Rights.Sub_Type == "G" ? "SG" : "SL";
                        Dub_type = objSyn_Deal_Rights.Dub_Type == "G" ? "DG" : "DL";
                        Data_For = Data_For + "," + Region_Type + "," + Sub_Type + "," + Dub_type;
                    }
                    Obj_USP_Result = Get_USP_Get_Acq_PreReq_Result(Data_For, str_Type);
                }
            }

            else
            {
                if (Region_Type == "I")
                    Region_Type = (Is_Thetrical == "N") ? "C" : "THC";
                else
                    Region_Type = (Is_Thetrical == "N") ? "T" : "THT";
                Data_For = str_Type;
                if (str_Type == "I" || str_Type == "T" || str_Type == "G")
                {
                    Data_For = Region_Type;
                }
                else if (str_Type == "SL" || str_Type == "DL" || str_Type == "SG" || str_Type == "DG")
                {
                    Data_For = str_Type;
                }
                else if (str_Type == "A")
                {
                    Sub_Type = (rdbSubtitlingLanguage == "G" || rdbSubtitlingLanguage == "SG") ? "SG" : "SL";
                    Dub_type = (rdbDubbingLanguage == "G" || rdbDubbingLanguage == "DG") ? "DG" : "DL";
                    Data_For = Data_For + "," + Region_Type + "," + Sub_Type + "," + Dub_type;
                }
                if (Data_For != "")
                {
                    GET_DATA_FOR_APPROVED_TITLES(titleCodes, platformCodes, "", Region_Type, rdbSubtitlingLanguage, rdbDubbingLanguage);
                    Obj_USP_Result = Get_USP_Get_Acq_PreReq_Result(Data_For, str_Type);
                }
            }
            Dictionary<string, object> objdic = new Dictionary<string, object>();
            objdic.Add("USP_Result", Obj_USP_Result);
            //USP_Get_Acq_PreReq_Result a = new USP_Get_Acq_PreReq_Result();
            //a.Data_For = "SBL";
            //a.Display_Text = "Please Select";
            //a.Display_Value = 0;
            //Obj_USP_Result.Add(a);
            objdic.Add("Selected_ROR", objSyn_Deal_Rights.ROFR_Code ?? 0);
            if (objSyn_Deal_Rights.Syn_Deal_Code == 0)
                objdic.Add("Selected_SBL", Convert.ToString(0));
            else if (objSyn_Deal_Rights.Sub_License_Code == null)
                objdic.Add("Selected_SBL", -1);
            else
                objdic.Add("Selected_SBL", Convert.ToString(objSyn_Deal_Rights.Sub_License_Code));
            objdic.Add("Selected_Tit_Code", objSyn_Deal_Rights.Title_Codes == null ? "" : objSyn_Deal_Rights.Title_Codes);
            objdic.Add("Selected_R_Code", objSyn_Deal_Rights.Region_Codes == null ? "" : objSyn_Deal_Rights.Region_Codes);
            objdic.Add("Selected_SL_Code", objSyn_Deal_Rights.Sub_Codes == null ? "" : objSyn_Deal_Rights.Sub_Codes);
            objdic.Add("Selected_DL_Code", objSyn_Deal_Rights.Dub_Codes == null ? "" : objSyn_Deal_Rights.Dub_Codes);
            objdic.Add("Selected_R_Type", objSyn_Deal_Rights.Region_Type == null ? "" : objSyn_Deal_Rights.Region_Type);//No need
            objdic.Add("Selected_SL_Type", objSyn_Deal_Rights.Sub_Type == null ? "" : objSyn_Deal_Rights.Sub_Type);//No need
            objdic.Add("Selected_DL_Type", objSyn_Deal_Rights.Dub_Type == null ? "" : objSyn_Deal_Rights.Dub_Type);//No need
            return Json(objdic, JsonRequestBehavior.AllowGet);
        }

        public string GetTitleLanguageName(string selectedTitles)
        {
            if (string.IsNullOrEmpty(selectedTitles))
                return "-";
            else
            {
                //Deal_Schema ObjDealSchema = (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    string[] arrSelectedTitles = selectedTitles.Split(',');
                    selectedTitles = string.Join(", ", objDeal_Schema.Title_List.Where(x => arrSelectedTitles.Contains(x.Acq_Deal_Movie_Code.ToString())).Select(s => s.Title_Code).ToArray().Distinct());
                }
                if (objDeal_Schema.Master_Deal_Movie_Code > 0)
                    selectedTitles = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Movie_Code == objDeal_Schema.Master_Deal_Movie_Code).Select(s => s.Title_Code.ToString()).FirstOrDefault();

                string languageName = (new USP_Service(objLoginEntity.ConnectionStringName)).USP_Get_Title_Language(selectedTitles).FirstOrDefault();

                if (string.IsNullOrEmpty(languageName))
                    return "-";

                return languageName;
            }
        }
        public JsonResult Validate_Groups(string Region_Codes, string Dubbing_Codes, string Subtitling_Codes)
        {
            List<string> lst_ErrorMsg = new List<string>();
            lst_ErrorMsg.AddRange(new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Rights_Duplication_Country_Lang(Region_Codes, Subtitling_Codes, Dubbing_Codes, "SR"));

            if (lst_ErrorMsg.Count() > 0)
                return Json(lst_ErrorMsg[0].ToString(), JsonRequestBehavior.AllowGet);

            return Json("", JsonRequestBehavior.AllowGet);
        }

        public string Validate_Acq_Right_Title_Platform(string hdnPlatform, string hdnMMovies, string Right_Type, string Is_Tentative, string Start_Date, string End_Date)
        {
            string Message = "";
            Platform_Service objPservice = new Platform_Service(objLoginEntity.ConnectionStringName);
            List<string> lstPlatformCode = objPservice.SearchFor(p => p.Is_Applicable_Syn_Run == "Y").Select(p => p.Platform_Code.ToString()).ToList();
            Syn_Deal_Service objDealService = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal objDeal = objDealService.GetById(objDeal_Schema.Deal_Code);

            int platformcount = (from s in lstPlatformCode
                                 where hdnPlatform.Contains(s)
                                 select s).Count();

            if (platformcount > 0)
            {
                List<int> lstTitlecode = (from objRun in objDeal.Syn_Deal_Run
                                          where objRun.Syn_Deal_Code == objDeal_Schema.Deal_Code && objRun.Is_Yearwise_Definition == "Y"
                                          select objRun.Title_Code.Value).ToList();

                int count = objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();

                List<int> arrTitleCode = new List<int>();
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    List<Title_List> lstDealMovie = objDeal.Syn_Deal_Movie.Where(m => hdnMMovies.Split(',').Contains(m.Syn_Deal_Movie_Code.ToString())).Select(m => new Title_List
                    {
                        Title_Code = m.Title_Code.Value,
                        Episode_From = m.Episode_From.Value,
                        Episode_To = m.Episode_End_To.Value,
                        Acq_Deal_Movie_Code = m.Syn_Deal_Movie_Code
                    }).ToList();

                    List<Syn_Deal_Run> q = (from run in objDeal.Syn_Deal_Run
                                            where lstDealMovie.Any(m => m.Title_Code == run.Title_Code && m.Episode_From == run.Episode_From && m.Episode_To == run.Episode_To)
                                            select run).ToList();

                    #region added by akshay
                    List<Syn_Deal_Rights_Title> RemovedTitle_List = new List<Syn_Deal_Rights_Title>();
                    List<Title_List> AddTitle_List = new List<Title_List>();

                    foreach (Title_List objTL in lstDealMovie)
                    {
                        if (q.Where(x => x.Episode_From == objTL.Episode_From && x.Episode_To == objTL.Episode_To && x.Title_Code == objTL.Title_Code).Count() == 0)
                            AddTitle_List.Add(objTL);
                    }

                    if (lstDealMovie.Count() < objSyn_Deal_Rights.Syn_Deal_Rights_Title.Count())
                    {
                        foreach (Syn_Deal_Rights_Title objTL in objSyn_Deal_Rights.Syn_Deal_Rights_Title)
                        {
                            
                            if (q.Where(x => x.Episode_From == objTL.Episode_From && x.Episode_To == objTL.Episode_To && x.Title_Code == objTL.Title_Code).Count() == 0)
                                RemovedTitle_List.Add(objTL);
                        }
                    }
                    #endregion added by akshay

                    if (q.Count() > 0)
                    {
                        var r = from rights in objDeal.Syn_Deal_Rights
                                from rightsTitle in rights.Syn_Deal_Rights_Title
                                where rights.Syn_Deal_Rights_Code != objSyn_Deal_Rights.Syn_Deal_Rights_Code &&
                                q.Any(t => t.Title_Code == rightsTitle.Title_Code && t.Episode_From == rightsTitle.Episode_From && t.Episode_To == rightsTitle.Episode_To) &&
                                rights.Syn_Deal_Rights_Platform.Any(p => p.Platform.Is_No_Of_Run == "Y")
                                select rightsTitle;

                        if (r.Count() == 0 && AddTitle_List.Count == 0 && RemovedTitle_List.Count() == 0)
                            return objMessageKey.CannotchangerightstitleasRunDefinitionisalreadyaddedTochangerightsperioddeleteRunDefinitionfirst;
                    }
                }
                else
                {
                    arrTitleCode = hdnMMovies.Split(',').Select(t => Convert.ToInt32(t)).ToList();
                    foreach (Syn_Deal_Rights_Title adrt in objSyn_Deal_Rights.Syn_Deal_Rights_Title)
                    {
                        if (objDeal.Syn_Deal_Run.Any(r => r.Title_Code == adrt.Title_Code) && !arrTitleCode.Contains((int)adrt.Title_Code))
                        {
                            return objMessageKey.CannotchangerightstitleasRunDefinitionisalreadyaddedTochangerightsperioddeleteRunDefinitionfirst;
                        }
                    }
                }

                if (Right_Type == objSyn_Deal_Rights.Right_Type)
                {
                    if (objSyn_Deal_Rights.Right_Type == "Y")
                    {
                        bool isTentative = (objSyn_Deal_Rights.Is_Tentative == "Y") ? true : false;
                        if (count > 0 && isTentative != Convert.ToBoolean(Is_Tentative))
                        {
                            return objMessageKey.CannotchangeTentativestateasRunDefinitionisalreadyaddedTochangerightsperioddeleteRunDefinitionfirst;
                        }
                        else
                            if (count > 0 && (objSyn_Deal_Rights.Right_Start_Date != Convert.ToDateTime(GlobalUtil.MakedateFormat(Start_Date)) || objSyn_Deal_Rights.Right_End_Date != Convert.ToDateTime(GlobalUtil.MakedateFormat(End_Date))))
                        {
                            return objMessageKey.CannotchangerightsperiodasRunDefinitionisalreadyaddedTochangerightsperioddeleteRunDefinitionfirst;
                        }
                    }
                }
                else
                {
                    if (count > 0)
                    {
                        return objMessageKey.CannotchangerightsperiodtypeasRunDefinitionisalreadyaddedTochangerightsperioddeleteRunDefinitionfirst;
                    }
                }
            }
            else
            {
                List<int> lstTitlecodeWithoutYearWise = (from objRun in objDeal.Syn_Deal_Run
                                                         where objRun.Syn_Deal_Code == objDeal_Schema.Deal_Code
                                                         select objRun.Title_Code.Value).ToList();

                int count = objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(t => lstTitlecodeWithoutYearWise.Contains(t.Title_Code.Value)).Count();

                List<int> lstTitleCodeOfCurrentRight = objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title_Code.Value).ToList();
                bool IsCableExistInOtherRightWithSameTitle = objDeal.Syn_Deal_Rights.Any(r => r.Syn_Deal_Rights_Code != objSyn_Deal_Rights.Syn_Deal_Rights_Code && r.Syn_Deal_Rights_Title.Any(t => lstTitleCodeOfCurrentRight.Contains(t.Title_Code.Value)) && r.Syn_Deal_Rights_Platform.Any(p => lstPlatformCode.Contains(p.Platform_Code.ToString())));
                if (count > 0 && !IsCableExistInOtherRightWithSameTitle)
                {
                    return objMessageKey.PleaseselectatleastonecablerightasRunDefinitionisalreadyaddedTodeselectcablerightsdeleteRunDefinitionfirst;
                }
            }

            return Message;
        }

        private int GetExceptValues(string SelectedValues, string SavedValues)
        {
            if (SelectedValues != "")
            {
                var arr_Selected_Values = SelectedValues.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var arr_Saved_Values = SavedValues.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var result = arr_Saved_Values.Except(arr_Selected_Values);
                if (result.Count() > 0)
                    return result.Count();
            }
            else
                return 1;
            return 0;
        }

        private string GetLangCodes(string LangGroup_Code)
        {
            string[] arr_Selected_Lang_Codes = LangGroup_Code.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            string Selected_Lang_Codes = string.Join(",", new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(i => arr_Selected_Lang_Codes.Contains(i.Language_Group_Code.ToString()))
                                                .SelectMany(LD => LD.Language_Group_Details
                                                                .Where(LGD => arr_Selected_Lang_Codes.Contains(LGD.Language_Group_Code.ToString()))
                                                                .Select(LGD => LGD.Language_Code)
                                                                .Distinct()
                                                            ).Distinct().ToArray()
                                                    );
            return Selected_Lang_Codes;
        }
        public ActionResult Show_Validation_Popup(string searchForTitles, string PageSize, int PageNo)
        {
            MultiSelectList arr_Title_List = new MultiSelectList(lstDupRecords.Select(s => new { Title_Name = s.Title_Name }).Distinct().ToList(), "Title_Name", "Title_Name", searchForTitles.Split(','));
            ViewBag.SearchTitles = arr_Title_List;
            PageNo += 1;
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = PageSize;
            int Record_Count = 0;
            List<USP_Validate_Rights_Duplication_UDT> lstDuplicates = (new GlobalController()).Acq_Rights_Validation_Popup(lstDupRecords, searchForTitles, PageSize, PageNo, out Record_Count);
            ViewBag.RecordCount = Record_Count;
            return PartialView("~/Views/Shared/_Acq_Validation_Popup.cshtml", lstDuplicates);
        }
        public ActionResult ChangeTabFromView(string hdnTabName = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);
        }
        public JsonResult CheckHBRegionWithRightsRegion(string region_type, string region_Code)
        {
            List<int> lstRegionNotExist = new List<int>();
            List<int> countryList = new List<int>();
            List<int> territoryList;
            List<int> filterTerritory = null;
            foreach (Syn_Deal_Rights_Holdback objHB in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(h => h.EntityState != State.Deleted))
                countryList.AddRange(objHB.Syn_Deal_Rights_Holdback_Territory.Where(s => s.EntityState != State.Deleted).Select(t => t.Country_Code.Value));

            countryList = countryList.Distinct().ToList();
            if (!string.IsNullOrEmpty(region_Code))
                territoryList = region_Code.Split(',').Select(s => Convert.ToInt32(s)).ToList();
            else
                territoryList = new List<int>();

            if (region_type == "G")
            {
                Territory_Details_Service objTDService = new Territory_Details_Service(objLoginEntity.ConnectionStringName);
                filterTerritory = objTDService.SearchFor(t => territoryList.Contains(t.Territory_Code)).Select(t => t.Country_Code).Distinct().ToList();
                lstRegionNotExist = countryList.Where(l => !filterTerritory.Contains(l)).Select(l => l).ToList();
            }
            else
                lstRegionNotExist = countryList.Where(l => !territoryList.Contains(l)).Select(l => l).ToList();

            if (lstRegionNotExist.Count > 0)
            {
                string country = string.Join(",", new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(c => lstRegionNotExist.Contains(c.Country_Code)).Select(c => c.Country_Name));
                return Json(country);
            }
            else
                return Json("Valid");
        }

        public JsonResult CheckHBSubtitleWithRightsSubtitle(string Subtitle_type, string Subtitle_Code)
        {
            List<int> lstLanguageNotExist = new List<int>();
            List<int> languageList = new List<int>();
            foreach (Syn_Deal_Rights_Holdback objHB in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(h => h.EntityState != State.Deleted))
                languageList.AddRange(objHB.Syn_Deal_Rights_Holdback_Subtitling.Where(s => s.EntityState != State.Deleted).Select(t => t.Language_Code.Value));

            languageList = languageList.Distinct().ToList();

            List<int> languageGroupList;

            if (!string.IsNullOrEmpty(Subtitle_Code))
                languageGroupList = Subtitle_Code.Split(',').Select(s => Convert.ToInt32(s)).ToList();
            else
                languageGroupList = new List<int>();

            if (Subtitle_type == "G")
            {
                Language_Group_Service objLGService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
                List<Language_Group> lgGroup = new List<Language_Group>();
                lgGroup.AddRange(objLGService.SearchFor(l => languageGroupList.Contains(l.Language_Group_Code)));

                var filterLG = (from lg in lgGroup
                                from l in lg.Language_Group_Details
                                select l.Language_Code).Distinct().ToList();

                lstLanguageNotExist = languageList.Where(l => !filterLG.Contains(l)).Select(l => l).ToList();
            }
            else
                lstLanguageNotExist = languageList.Where(l => !languageGroupList.Contains(l)).Select(l => l).ToList();

            if (lstLanguageNotExist.Count > 0)
            {
                string languages = string.Join(",", new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(l => lstLanguageNotExist.Contains(l.Language_Code)).Select(l => l.Language_Name));
                return Json(languages);
            }
            else
                return Json("Valid");
        }

        public JsonResult CheckHBDubbingWithRightsDubbing(string Dubbing_type, string Dubbing_Code)
        {
            List<int> lstLanguageNotExist = new List<int>();
            List<int> languageList = new List<int>();
            foreach (Syn_Deal_Rights_Holdback objHB in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(h => h.EntityState != State.Deleted))
                languageList.AddRange(objHB.Syn_Deal_Rights_Holdback_Dubbing.Where(s => s.EntityState != State.Deleted).Select(t => t.Language_Code.Value));

            languageList = languageList.Distinct().ToList();
            List<int> languageGroupList;

            if (!string.IsNullOrEmpty(Dubbing_Code))
                languageGroupList = Dubbing_Code.Split(',').Select(s => Convert.ToInt32(s)).ToList();
            else
                languageGroupList = new List<int>();

            if (Dubbing_type == "G")
            {
                Language_Group_Service objLGService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
                List<Language_Group> lgGroup = new List<Language_Group>();
                lgGroup.AddRange(objLGService.SearchFor(l => languageGroupList.Contains(l.Language_Group_Code)));

                var filterLG = (from lg in lgGroup
                                from l in lg.Language_Group_Details
                                select l.Language_Code).Distinct().ToList();
                lstLanguageNotExist = languageList.Where(l => !filterLG.Contains(l)).Select(l => l).ToList();
            }
            else
                lstLanguageNotExist = languageList.Where(l => !languageGroupList.Contains(l)).Select(l => l).ToList();

            if (lstLanguageNotExist.Count > 0)
            {
                string languages = string.Join(",", new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(l => lstLanguageNotExist.Contains(l.Language_Code)).Select(l => l.Language_Name));
                return Json(languages);
            }
            else
                return Json("Valid");
        }
        #endregion

        #region ============== SAVE METHODS ==============

        //, string hdnTitle_Code, string hdnTVCodes, string Rights_Period, string Term_YY, string Term_MM, string Perpetuity_Date
        public ActionResult Save_Rights(Syn_Deal_Rights objRights, FormCollection form)
        {
            //new USP_Service().USP_ValidateIfHoldbackExist(objRights.;

            string message = string.Empty;
            //List<USP_CheckHoldbackForSyn_UDT> objCheckHoldBackUDT = new List<USP_CheckHoldbackForSyn_UDT>();
            //objSyn_Deal_Rights = CreateRightObject(objSyn_Deal_Rights, objRights, form);

            if (Session["HoldbackCancelled"] != "Y")
            {
                Session["Region_Type"] = form["hdnRegion_Type"];
                Session["Sub_Type"] = form["hdnSub_Type"];
                Session["Dub_Type"] = form["hdnDub_Type"];

                Session["Title_Codes"] = form["hdnTitle_Code"].Replace(" ", "");
                Session["Platform_Codes"] = form["hdnTVCodes"].Replace(" ", "");
                Session["Region_Codes"] = form["hdnRegion_Code"].Replace(" ", "");
                Session["Sub_Codes"] = form["hdnSub_Code"].Replace(" ", "");
                Session["Dub_Codes"] = form["hdnDub_Code"].Replace(" ", "");
                Session["Start_Date"] = form["Start_Date"].Replace(" ", "");
                Session["End_Date"] = (form["End_Date"] ?? "").Replace(" ", "");
                if (Session["HB_Code"] == null || Session["HB_Code"] == "")
                {
                    Session["HB_Code"] = form["hdnHB_Code"] == null ? "" : form["hdnHB_Code"].Replace(" ", "");
                }
                Session["IsExclusive"] = Convert.ToBoolean(form["hdnIs_Exclusive"]);
                Session["IsTitleLanguageRight"] = Convert.ToBoolean(form["hdnIs_Title_Language_Right"]);
                if (Session["HB_Code"] == "")
                {
                    var objUSP_ValidateIfHoldbackExist = new USP_Service(objLoginEntity.ConnectionStringName).USP_ValidateIfHoldbackExist(objPage_Properties.RCODE, Convert.ToString(Session["Title_Codes"]), Convert.ToString(Session["Region_Codes"]),
                        Convert.ToString(Session["Platform_Codes"]), Convert.ToString(Session["Sub_Codes"]), Convert.ToString(Session["Dub_Codes"]), Convert.ToString(Session["Region_Type"]), Convert.ToString(Session["Sub_Type"]), Convert.ToString(Session["Dub_Type"]),
                        Convert.ToString(Session["Start_Date"]), Convert.ToString(Session["End_Date"]), "", (Convert.ToBoolean(Session["IsTitleLanguageRight"]) == true ? "Y" : "N")).Select(p => p.Holdback_Code).ToArray();

                    if (objUSP_ValidateIfHoldbackExist.Length > 0)
                    {
                        if (Convert.ToInt64(objUSP_ValidateIfHoldbackExist[0]) > 0)
                        {
                            Session["HoldbackCancelled"] = "N";
                            return Json(objUSP_ValidateIfHoldbackExist, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
            }


            if (TempData["QueryString_Rights"] != null)
                TempData["QueryString_Rights"] = null;




            var Is_Valid = SaveDealRight(objRights, form);
            string strPlatform = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Where(p => p.EntityState != State.Deleted).Select(i => i.Platform_Code).Distinct().ToList()));
            objSyn_Deal_Rights.Platform_Codes = strPlatform;
            //BindDDLs();
            ViewBag.ShowPopup = "";
            ViewBag.Message = "";
            ViewBag.MessageFrom = "SV";
            ViewBag.MODE = "E";
            string tabName = form["hdnTabName"];

            if (!Is_Valid)
                message = "ERROR";
            else
            {
                AllPlatform_Codes = null;
                SubTitle_Lang_Codes = null;
                Dubb_Lang_Codes = null;
                if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_EDIT)
                    message = objMessageKey.Rightupdatedsuccessfully;
                else
                    message = objMessageKey.Rightsavedsuccessfully;
            }

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            else
                ViewBag.Record_Locking_Code = 0;
            Session["HoldbackCancelled"] = "N";
            Session["HB_Code"] = "";
            return Content(message);// View("Index", objAcq_Deal_Rights);
        }
        public ActionResult showHoldbackValidationPopup(string acqdealMovieCode)
        {
            lstSDRHV = null;
            string deletedHBCodes = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(w => w.EntityState == State.Deleted).Select(s => s.Syn_Deal_Rights_Holdback_Code).ToArray());
            foreach (Syn_Deal_Rights_Holdback objSDRHB in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(w => w.EntityState != State.Deleted))
            {
                int Count = 0;
                string acqDealMovieCode = acqdealMovieCode;
                string[] ADMCode = acqDealMovieCode.Split(',');
                //string[] title_Code = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => ADMCode.Contains(x.Syn_Deal_Movie_Code.ToString())).Select(y => y.Title_Code.ToString()).ToArray();
                string tempcode = "";
                string[] titleCode = new string[] { };
                string ignorableHBCode = ((string.IsNullOrEmpty(deletedHBCodes) ? "" : deletedHBCodes + ",") + objSDRHB.Syn_Deal_Rights_Holdback_Code.ToString());
                Count = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Deal_Rights_Holdback_Validation(ignorableHBCode, objSDRHB.strPlatformCodes, objSDRHB.strCountryCodes, acqDealMovieCode, objDeal_Schema.Deal_Type_Code, objSDRHB.Is_Title_Language_Right, objSDRHB.strDubbingCodes, objSDRHB.strSubtitlingCodes, objDeal_Schema.Rights_Is_Exclusive).FirstOrDefault().Rec_Count;

                if (Count > 0)
                {
                    Syn_Deal_Rights_Holdback_Validation objSDRHV = new Syn_Deal_Rights_Holdback_Validation();
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        titleCode = objDeal_Schema.Title_List.Where(w => ADMCode.Contains(w.Acq_Deal_Movie_Code.ToString())).Select(s => s.Title_Code.ToString()).ToArray();
                    else
                        titleCode = ADMCode;

                    objSDRHV.Title_Name = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => titleCode.Contains(x.Title_Code.ToString())).Select(x => x.Title_Name).FirstOrDefault();
                    string[] platforCode = objSDRHB.strPlatformCodes.Split(',');
                    string[] platforms = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => platforCode.Contains(x.Platform_Code.ToString())).Select(x => x.Platform_Name).ToArray();
                    objSDRHV.Platform = string.Join(", ", platforms);
                    string[] countryCode = objSDRHB.strCountryCodes.Split(',');
                    string[] countrys = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => countryCode.Contains(x.Country_Code.ToString())).Select(x => x.Country_Name).ToArray();
                    objSDRHV.Region = string.Join(", ", countrys);
                    lstSDRHV.Add(objSDRHV);

                }
                if (Count == 0)
                    lstSDRHV = null;
            }
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Holdback_Validation_Popup.cshtml", lstSDRHV);
        }

        private bool SaveDealRight(Syn_Deal_Rights objRights, FormCollection form)
        {
            // Material_Medium
            bool IsValid = true;
            if (IsValid)
            {
                bool IsSameAsGroup = false;
                if (objPage_Properties.TCODE > 0 || objPage_Properties.PCODE > 0)
                {
                    Syn_Deal objDeal = new Syn_Deal();
                    Syn_Deal_Service objADS = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
                    objDeal = objADS.GetById(objSyn_Deal_Rights.Syn_Deal_Code);
                    Syn_Deal_Rights objExistingRight = objDeal.Syn_Deal_Rights.Where(t => t.Syn_Deal_Rights_Code == objPage_Properties.RCODE).FirstOrDefault();
                    if (objExistingRight.Syn_Deal_Rights_Title.Count == 1 && objPage_Properties.TCODE > 0 && objExistingRight.Syn_Deal_Rights_Platform.Count == 1 && objPage_Properties.PCODE > 0)
                        IsSameAsGroup = true;
                    else if (objExistingRight.Syn_Deal_Rights_Title.Count == 1 && objPage_Properties.TCODE > 0 && objPage_Properties.PCODE == 0)
                        IsSameAsGroup = true;
                    else
                    {
                        //This is the new object to be save
                        Syn_Deal_Rights objFirstRight = new Syn_Deal_Rights();
                        objDeal.Syn_Deal_Rights.Add(objFirstRight);

                        #region =========== Assign Platform and Holdback to Second Object ===========
                        if (Lst_Syn_Deal_Rights_Holdback == null)
                            Lst_Syn_Deal_Rights_Holdback = new List<Syn_Deal_Rights_Holdback>();
                        foreach (Syn_Deal_Rights_Holdback objADRHB in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback)
                        {
                            Lst_Syn_Deal_Rights_Holdback.Add(objADRHB);
                        }

                        if (Lst_Syn_Deal_Rights_Blackout == null)
                            Lst_Syn_Deal_Rights_Blackout = new List<Syn_Deal_Rights_Blackout>();
                        foreach (Syn_Deal_Rights_Blackout objADRHB in objSyn_Deal_Rights.Syn_Deal_Rights_Blackout)
                        {
                            Lst_Syn_Deal_Rights_Blackout.Add(objADRHB);
                        }

                        objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.ToList<Syn_Deal_Rights_Promoter>().ForEach(t =>
                        {
                            if (t.EntityState != State.Deleted)
                            {
                                Syn_Deal_Rights_Promoter objPromoter = new Syn_Deal_Rights_Promoter();
                                objPromoter.EntityState = State.Added;
                                t.Syn_Deal_Rights_Promoter_Group.ToList<Syn_Deal_Rights_Promoter_Group>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Syn_Deal_Rights_Promoter_Group objG = new Syn_Deal_Rights_Promoter_Group();
                                        objG.Promoter_Group_Code = x.Promoter_Group_Code;
                                        objG.EntityState = State.Added;
                                        objPromoter.Syn_Deal_Rights_Promoter_Group.Add(objG);
                                    }
                                });
                                t.Syn_Deal_Rights_Promoter_Remarks.ToList<Syn_Deal_Rights_Promoter_Remarks>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Syn_Deal_Rights_Promoter_Remarks objR = new Syn_Deal_Rights_Promoter_Remarks();
                                        objR.Promoter_Remarks_Code = x.Promoter_Remarks_Code;
                                        objR.EntityState = State.Added;
                                        objPromoter.Syn_Deal_Rights_Promoter_Remarks.Add(objR);
                                    }
                                });

                                objFirstRight.Syn_Deal_Rights_Promoter.Add(objPromoter);
                            }
                        });

                        Lst_Syn_Deal_Rights_Promoter = new List<Syn_Deal_Rights_Promoter>();
                        foreach (Syn_Deal_Rights_Promoter objSDPR in objSyn_Deal_Rights.Syn_Deal_Rights_Promoter)
                        {
                            Lst_Syn_Deal_Rights_Promoter.Add(objSDPR);
                        }
                        #endregion

                        objFirstRight = CreateRightObject(objFirstRight, objRights, form);
                        objFirstRight.EntityState = State.Added;
                        objExistingRight.EntityState = State.Modified;
                        bool isMovieDelete = true;
                        if (objExistingRight.Syn_Deal_Rights_Title.Count > 1)
                        {
                            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                                objExistingRight.Syn_Deal_Rights_Title.Where(t => t.Title_Code == objPage_Properties.TCODE && t.Episode_From == objPage_Properties.Episode_From && t.Episode_To == objPage_Properties.Episode_To).ToList<Syn_Deal_Rights_Title>().ForEach(x => { x.EntityState = State.Deleted; });
                            else
                                objExistingRight.Syn_Deal_Rights_Title.Where(t => t.Title_Code == objPage_Properties.TCODE).ToList<Syn_Deal_Rights_Title>().ForEach(x => { x.EntityState = State.Deleted; });
                        }
                        else
                            isMovieDelete = false;

                        if (objPage_Properties.PCODE > 0)
                        {
                            if (!isMovieDelete)

                                objExistingRight.Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>().ForEach(t => { if (t.Platform_Code == objPage_Properties.PCODE) t.EntityState = State.Deleted; });
                            else if (objExistingRight.Syn_Deal_Rights_Platform.Count > 1)
                            {
                                Syn_Deal_Rights objSecondRight = SetNewSynDealRight(objExistingRight, objPage_Properties.TCODE, objPage_Properties.Episode_From, objPage_Properties.Episode_To, objPage_Properties.PCODE);
                                objDeal.Syn_Deal_Rights.Add(objSecondRight);
                            }
                        }
                        objDeal.SaveGeneralOnly = false;
                        objDeal.EntityState = State.Modified;

                        dynamic resultSet;
                        objADS.Save(objDeal, out resultSet);
                        objSyn_Deal_Rights = objFirstRight;
                        return true;
                    }
                }
                else
                    IsSameAsGroup = true;

                if (IsSameAsGroup)
                {
                    if (Lst_Syn_Deal_Rights_Holdback == null)
                        Lst_Syn_Deal_Rights_Holdback = new List<Syn_Deal_Rights_Holdback>();
                    foreach (Syn_Deal_Rights_Holdback objADRHB in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback)
                    {
                        Lst_Syn_Deal_Rights_Holdback.Add(objADRHB);
                    }

                    if (Lst_Syn_Deal_Rights_Blackout == null)
                        Lst_Syn_Deal_Rights_Blackout = new List<Syn_Deal_Rights_Blackout>();
                    foreach (Syn_Deal_Rights_Blackout objADRHB in objSyn_Deal_Rights.Syn_Deal_Rights_Blackout)
                    {
                        Lst_Syn_Deal_Rights_Blackout.Add(objADRHB);
                    }
                    Lst_Syn_Deal_Rights_Promoter = null;
                    Lst_Syn_Deal_Rights_Promoter = new List<Syn_Deal_Rights_Promoter>();
                    foreach (Syn_Deal_Rights_Promoter objSDPR in objSyn_Deal_Rights.Syn_Deal_Rights_Promoter)
                    {
                        Lst_Syn_Deal_Rights_Promoter.Add(objSDPR);
                    }
                    Syn_Deal_Rights_Service objADRS = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
                    if (objSyn_Deal_Rights.Syn_Deal_Rights_Code > 0)
                    {
                        objSyn_Deal_Rights = objADRS.GetById(objSyn_Deal_Rights.Syn_Deal_Rights_Code);
                        objSyn_Deal_Rights.EntityState = State.Modified;
                    }
                    else
                    {
                        objSyn_Deal_Rights.Syn_Deal_Code = objDeal_Schema.Deal_Code;
                        objSyn_Deal_Rights.EntityState = State.Added;
                    }
                    objSyn_Deal_Rights.Promoter_Flag = Convert.ToString(form["hdnPromoter"]);
                    objRights.Restriction_Remarks = objRights.Restriction_Remarks != null ? objRights.Restriction_Remarks.Replace("\r\n", "\n") : "";
                    objSyn_Deal_Rights = CreateRightObject(objSyn_Deal_Rights, objRights, form);

                    if (objSyn_Deal_Rights.Syn_Deal_Rights_Code > 0)
                        objSyn_Deal_Rights.EntityState = State.Modified;
                    else
                        objSyn_Deal_Rights.EntityState = State.Added;

                    dynamic resultSet;
                    objADRS.Save(objSyn_Deal_Rights, out resultSet);
                    return true;
                }
            }
            else
            {
                return false;
            }
            return true;
        }

        private Syn_Deal_Rights CreateRightObject(Syn_Deal_Rights objExistingRights, Syn_Deal_Rights objMVCRights, FormCollection form)
        {
            string Enabled_Perpetuity = "";
            try
            {
                Enabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;

            }

            catch (Exception e)
            {
                Enabled_Perpetuity = "N";
            }
            if (Lst_Syn_Deal_Rights_Promoter == null)
                Lst_Syn_Deal_Rights_Promoter = new List<Syn_Deal_Rights_Promoter>();
            if (objExistingRights.Syn_Deal_Rights_Code > 0)
            {
                objExistingRights.Syn_Deal_Rights_Title.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Platform.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Territory.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Subtitling.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Dubbing.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Holdback.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Blackout.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Promoter.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Last_Updated_Time = DateTime.Now;
                objExistingRights.Last_Action_By = objLoginUser.Users_Code;
            }
            else if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_CLONE)
            {
                objExistingRights.Syn_Deal_Rights_Title.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Platform.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Territory.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Subtitling.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Dubbing.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Syn_Deal_Rights_Holdback.Clear();
                objExistingRights.Syn_Deal_Rights_Blackout.Clear();
                objExistingRights.Syn_Deal_Rights_Promoter.Clear();
                objExistingRights.Inserted_On = DateTime.Now;
                objExistingRights.Inserted_By = objLoginUser.Users_Code;
            }
            else
            {
                objExistingRights.Syn_Deal_Rights_Holdback.Clear();
                objExistingRights.Syn_Deal_Rights_Blackout.Clear();
                objExistingRights.Syn_Deal_Rights_Promoter.Clear();
                objExistingRights.Inserted_On = DateTime.Now;
                objExistingRights.Inserted_By = objLoginUser.Users_Code;
            }

            string Region_Type = form["hdnRegion_Type"];
            string Sub_Type = form["hdnSub_Type"];
            string Dub_Type = form["hdnDub_Type"];

            string Title_Codes = form["hdnTitle_Code"].Replace(" ", "");
            string Platform_Codes = form["hdnTVCodes"].Replace(" ", "");
            string Region_Codes = form["hdnRegion_Code"].Replace(" ", "");
            string Sub_Codes = form["hdnSub_Code"].Replace(" ", "");
            string Dub_Codes = form["hdnDub_Code"].Replace(" ", "");
            bool IsExclusive = Convert.ToBoolean(form["hdnIs_Exclusive"]);
            bool IsTitleLanguageRight = Convert.ToBoolean(form["hdnIs_Title_Language_Right"]);

            objExistingRights.Region_Type = Region_Type;
            objExistingRights.Sub_Type = Sub_Type;
            objExistingRights.Dub_Type = Dub_Type;
            objExistingRights.Platform_Codes = Platform_Codes;
            objExistingRights.Right_Status = "P";


            Deal_Rights_UDT objDRUDT = new Deal_Rights_UDT();

            #region ========= Title object creation =========

            ICollection<Syn_Deal_Rights_Title> selectTitleList = new HashSet<Syn_Deal_Rights_Title>();

            if (Title_Codes != "")
            {
                string[] titCodes = Title_Codes.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string titleCode in titCodes)
                {
                    Syn_Deal_Rights_Title objT = new Syn_Deal_Rights_Title();

                    int code = Convert.ToInt32((string.IsNullOrEmpty(titleCode)) ? "0" : titleCode);

                    int EpStart = 1, EpEnd = 1;
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        Title_List objTL = null;
                        objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();
                        EpStart = objTL.Episode_From;
                        EpEnd = objTL.Episode_To;
                        code = objTL.Title_Code;
                    }

                    objT = (Syn_Deal_Rights_Title)objExistingRights.Syn_Deal_Rights_Title.Where(t => t.Title_Code == Convert.ToInt32(code) && t.Episode_From == EpStart && t.Episode_To == EpEnd).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Syn_Deal_Rights_Title();

                    if (objT.Syn_Deal_Rights_Title_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.Episode_From = EpStart;
                        objT.Episode_To = EpEnd;
                        objT.Title_Code = code;
                        objT.EntityState = State.Added;

                        objExistingRights.Syn_Deal_Rights_Title.Add(objT);
                    }
                }
            }

            #endregion

            #region ========= Save Platform =====

            if (Platform_Codes.Trim() != "")
            {
                Platform_Codes = Platform_Codes.Replace("_", "").Trim().Replace("_", "").Replace(" ", "").Replace("_0", "").Trim(); ;
                string[] PTitle_Codes = Platform_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Distinct().ToArray();
                foreach (string platformCode in PTitle_Codes)
                {
                    if (platformCode != "" && platformCode != "0")
                    {
                        Syn_Deal_Rights_Platform objP = objExistingRights.Syn_Deal_Rights_Platform.Where(t => t.Platform_Code == Convert.ToInt32(platformCode)).Select(i => i).FirstOrDefault();
                        if (objP == null)
                            objP = new Syn_Deal_Rights_Platform();

                        if (objP.Syn_Deal_Rights_Platform_Code > 0)
                        {
                            objP.EntityState = State.Unchanged;
                        }
                        else
                        {
                            objP.Platform_Code = Convert.ToInt32(platformCode);
                            objP.EntityState = State.Added;
                        }
                        objExistingRights.Syn_Deal_Rights_Platform.Add(objP);
                    }
                }
            }

            #endregion

            #region ========= Country / Territory object creation =========

            if (Region_Codes.Trim() != "")
            {
                string[] TC_Codes = Region_Codes.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string CtrCode in TC_Codes)
                {
                    Syn_Deal_Rights_Territory objT = objExistingRights.Syn_Deal_Rights_Territory.Where(t =>
                            (t.Country_Code == Convert.ToInt32(CtrCode) && t.Territory_Type == Region_Type) ||
                            (t.Territory_Code == Convert.ToInt32(CtrCode) && t.Territory_Type == Region_Type)
                        ).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Syn_Deal_Rights_Territory();

                    if (objT.Syn_Deal_Rights_Territory_Code > 0)
                    {
                        objT.EntityState = State.Unchanged;
                    }
                    else
                    {
                        if (Region_Type == "G")
                        {
                            objT.Country_Code = null;
                            objT.Territory_Code = Convert.ToInt32(CtrCode);
                        }
                        else
                        {
                            objT.Country_Code = Convert.ToInt32(CtrCode);
                            objT.Territory_Code = null;
                        }
                        objT.Territory_Type = Region_Type;
                        objT.EntityState = State.Added;
                    }

                    objExistingRights.Syn_Deal_Rights_Territory.Add(objT);
                }
            }

            #endregion

            #region ========= SubTitle object creation =========

            if (Sub_Codes.Trim() != "")
            {
                string[] ST_Codes = Sub_Codes.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string lngCode in ST_Codes)
                {
                    Syn_Deal_Rights_Subtitling objSub = objExistingRights.Syn_Deal_Rights_Subtitling.Where(t =>
                            (t.Language_Code == Convert.ToInt32(lngCode) && t.Language_Type == Sub_Type) ||
                            (t.Language_Group_Code == Convert.ToInt32(lngCode) && t.Language_Type == Sub_Type)
                        ).Select(i => i).FirstOrDefault();

                    if (objSub == null)
                        objSub = new Syn_Deal_Rights_Subtitling();

                    if (objSub.Syn_Deal_Rights_Subtitling_Code > 0)
                    {
                        objSub.EntityState = State.Unchanged;
                    }
                    else
                    {
                        if (Sub_Type == "G")
                        {
                            objSub.Language_Code = null;
                            objSub.Language_Group_Code = Convert.ToInt32(lngCode);
                        }
                        else
                        {
                            objSub.Language_Code = Convert.ToInt32(lngCode);
                            objSub.Language_Group_Code = null;
                        }
                        objSub.Language_Type = Sub_Type;
                        objSub.EntityState = State.Added;
                    }

                    objExistingRights.Syn_Deal_Rights_Subtitling.Add(objSub);
                }
            }

            #endregion

            #region ========= Dubbing object creation =========

            if (Dub_Codes.Trim() != "")
            {
                string[] ST_Codes = Dub_Codes.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string lngCode in ST_Codes)
                {
                    Syn_Deal_Rights_Dubbing objDub = objExistingRights.Syn_Deal_Rights_Dubbing.Where(t =>
                            (t.Language_Code == Convert.ToInt32(lngCode) && t.Language_Type == Dub_Type) ||
                            (t.Language_Group_Code == Convert.ToInt32(lngCode) && t.Language_Type == Dub_Type)
                        ).Select(i => i).FirstOrDefault();

                    if (objDub == null)
                        objDub = new Syn_Deal_Rights_Dubbing();

                    if (objDub.Syn_Deal_Rights_Dubbing_Code > 0)
                    {
                        objDub.EntityState = State.Unchanged;
                    }
                    else
                    {
                        if (Dub_Type == "G")
                        {
                            objDub.Language_Code = null;
                            objDub.Language_Group_Code = Convert.ToInt32(lngCode);
                        }
                        else
                        {
                            objDub.Language_Code = Convert.ToInt32(lngCode);
                            objDub.Language_Group_Code = null;
                        }
                        objDub.Language_Type = Dub_Type;
                        objDub.EntityState = State.Added;
                    }

                    objExistingRights.Syn_Deal_Rights_Dubbing.Add(objDub);
                }
            }

            #endregion

            objDRUDT.Title_Code = objPage_Properties.TCODE;
            objDRUDT.Platform_Code = objPage_Properties.PCODE;
            objDRUDT.Deal_Rights_Code = objPage_Properties.RCODE; //objExistingRights.Acq_Deal_Rights_Code;
            objDRUDT.Deal_Code = objExistingRights.Syn_Deal_Code = objDeal_Schema.Deal_Code;
            objDRUDT.Is_Exclusive = objExistingRights.Is_Exclusive = IsExclusive ? "Y" : "N";
            objDRUDT.Is_Title_Language_Right = objExistingRights.Is_Title_Language_Right = IsTitleLanguageRight ? "Y" : "N";
            objExistingRights.Is_Pushback = objMVCRights.Is_Pushback = "N";

            objDRUDT.Is_Sub_License = objExistingRights.Is_Sub_License = form["rdoSublicensing"];
            objDRUDT.Sub_License_Code = objExistingRights.Sub_License_Code = null;
            if (objExistingRights.Is_Sub_License == "Y")
            {
                if (objMVCRights.Sub_License_Code > 0)
                    objDRUDT.Sub_License_Code = objExistingRights.Sub_License_Code = objMVCRights.Sub_License_Code;
            }

            objDRUDT.Is_Theatrical_Right = objExistingRights.Is_Theatrical_Right = objMVCRights.Is_Theatrical_Right.ToUpper() == "TRUE" ? "Y" : "N";

            if (objMVCRights.Right_Type == "M" && (objSyn_Deal_Rights.Right_Type == "Y" || objSyn_Deal_Rights.Right_Type == "U"))
                objExistingRights.Actual_Right_Start_Date = objExistingRights.Actual_Right_End_Date = objExistingRights.Right_Start_Date = objExistingRights.Right_End_Date = null;

            objDRUDT.Right_Type = objExistingRights.Right_Type = objMVCRights.Right_Type;
            objExistingRights.Original_Right_Type = objMVCRights.Original_Right_Type;
            objDRUDT.Term = objExistingRights.Term = "";
            objDRUDT.Is_Tentative = objExistingRights.Is_Tentative = "N";
            objDRUDT.Milestone_Type_Code = objExistingRights.Milestone_Type_Code = null;
            objDRUDT.Milestone_No_Of_Unit = objExistingRights.Milestone_No_Of_Unit = null;
            objDRUDT.Milestone_Unit_Type = objExistingRights.Milestone_Unit_Type = null;
            objExistingRights.ROFR_Code = null;

            if (objMVCRights.Original_Right_Type == "Y")
            {
                objDRUDT.Is_Tentative = objExistingRights.Is_Tentative = objMVCRights.Is_Tentative.ToUpper() == "TRUE" ? "Y" : "N";
                objDRUDT.Term = objExistingRights.Term = objMVCRights.Term_YY + "." + objMVCRights.Term_MM + "." + objMVCRights.Term_DD;
                objExistingRights.Right_Start_Date = null;
                objExistingRights.Right_End_Date = null;

                if (!string.IsNullOrEmpty(objMVCRights.Start_Date))
                    objDRUDT.Right_Start_Date = objExistingRights.Right_Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(objMVCRights.Start_Date));

                if (!string.IsNullOrEmpty(objMVCRights.End_Date))
                    objDRUDT.Right_End_Date = objExistingRights.Right_End_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(objMVCRights.End_Date));

                if (objDRUDT.Is_Tentative == "Y")
                {
                    DateTime dtSD = Convert.ToDateTime(objExistingRights.Right_Start_Date);
                    if (objMVCRights.Term_YY != "")
                        dtSD = dtSD.AddYears(Convert.ToInt32(objMVCRights.Term_YY));
                    if (objMVCRights.Term_MM != "")
                        dtSD = dtSD.AddMonths(Convert.ToInt32(objMVCRights.Term_MM));
                    if (objMVCRights.Term_DD != "")
                        dtSD = dtSD.AddMonths(Convert.ToInt32(objMVCRights.Term_DD));
                    dtSD = dtSD.AddDays(-1);
                    objDRUDT.Right_End_Date = objExistingRights.Right_End_Date = dtSD;
                }

                objExistingRights.Effective_Start_Date = objExistingRights.Right_Start_Date;
                objExistingRights.Actual_Right_Start_Date = objExistingRights.Right_Start_Date;
                objExistingRights.Actual_Right_End_Date = objExistingRights.Right_End_Date;

                //Change the logic of effective start date in case of holdback added on release type
                if (objMVCRights.ROFR_Code > 0 && objPage_Properties.Is_ROFR_Type_Visible == "Y")
                    objExistingRights.ROFR_Code = objMVCRights.ROFR_Code;
            }
            else if (objMVCRights.Original_Right_Type == "U")
            {
                if (Enabled_Perpetuity == "Y")
                {
                    objDRUDT.Right_Type = objExistingRights.Right_Type = "Y";
                    string termYear = "0";
                    try
                    {
                        termYear = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").First().Parameter_Value;
                    }
                    catch (Exception)
                    {
                        termYear = "0";
                    }
                    objExistingRights.Term = termYear + ".0";

                    if (!string.IsNullOrEmpty(objMVCRights.Perpetuity_Date))
                    {
                        objDRUDT.Right_Start_Date = objExistingRights.Right_Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(objMVCRights.Perpetuity_Date));
                        objDRUDT.Right_End_Date = objExistingRights.Right_End_Date = ((DateTime)objExistingRights.Right_Start_Date).
                            AddYears(Convert.ToInt32(termYear)).AddDays(-1);
                    }
                }
                else
                {
                    objDRUDT.Right_Type = objExistingRights.Right_Type = "U";
                    //objDRUDT.Original_Right_Type = 
                    objExistingRights.Original_Right_Type = "";

                    objDRUDT.Right_Start_Date = objExistingRights.Right_Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(objMVCRights.Perpetuity_Date));
                    objDRUDT.Right_End_Date = objExistingRights.Right_End_Date = null;
                }
                objExistingRights.Effective_Start_Date = objExistingRights.Right_Start_Date;
                objExistingRights.Actual_Right_Start_Date = objExistingRights.Right_Start_Date;
                objExistingRights.Actual_Right_End_Date = objExistingRights.Right_End_Date;
                objExistingRights.ROFR_Code = null;

            }
            objDRUDT.Is_ROFR = objExistingRights.Is_ROFR = "N";
            objDRUDT.ROFR_Date = objExistingRights.ROFR_Date = null;

            if (!string.IsNullOrEmpty(objMVCRights.ROFR_DT))
            {
                objExistingRights.ROFR_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(objMVCRights.ROFR_DT));
                objDRUDT.Is_ROFR = objExistingRights.Is_ROFR = "Y";
            }

            objDRUDT.Restriction_Remarks = objExistingRights.Restriction_Remarks = objMVCRights.Restriction_Remarks;

            objExistingRights.LstDeal_Rights_UDT = new List<Deal_Rights_UDT>();
            objExistingRights.LstDeal_Rights_UDT.Add(objDRUDT);

            objExistingRights.LstDeal_Rights_Title_UDT = new List<Deal_Rights_Title_UDT>(
                            objExistingRights.Syn_Deal_Rights_Title.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Title_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Title_Code = (x.Title_Code == null) ? 0 : x.Title_Code,
                                Episode_From = x.Episode_From,
                                Episode_To = x.Episode_To
                            }));

            objExistingRights.LstDeal_Rights_Platform_UDT = new List<Deal_Rights_Platform_UDT>(
                            objExistingRights.Syn_Deal_Rights_Platform.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Platform_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Platform_Code = (x.Platform_Code == null) ? 0 : x.Platform_Code
                            }));

            objExistingRights.LstDeal_Rights_Territory_UDT = new List<Deal_Rights_Territory_UDT>(
                            objExistingRights.Syn_Deal_Rights_Territory.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Territory_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Territory_Code = (x.Territory_Code == null) ? 0 : x.Territory_Code,
                                Country_Code = (x.Country_Code == null) ? 0 : x.Country_Code,
                                Territory_Type = (x.Territory_Type == null) ? "I" : x.Territory_Type
                            }));

            objExistingRights.LstDeal_Rights_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>(
                            objExistingRights.Syn_Deal_Rights_Subtitling.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Subtitling_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Subtitling_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));

            objExistingRights.LstDeal_Rights_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>(
                            objExistingRights.Syn_Deal_Rights_Dubbing.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Dubbing_UDT
                            {
                                Deal_Rights_Code = (x.Syn_Deal_Rights_Code == null) ? 0 : x.Syn_Deal_Rights_Code,
                                Dubbing_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));

            #region=====Save Holdback================
            #region =========== Holdback ===========
            Lst_Syn_Deal_Rights_Holdback.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Syn_Deal_Rights_Holdback objH = new Syn_Deal_Rights_Holdback();
                    objH.Holdback_Type = t.Holdback_Type;
                    objH.HB_Run_After_Release_No = t.HB_Run_After_Release_No;
                    objH.HB_Run_After_Release_Units = t.HB_Run_After_Release_Units;
                    objH.Holdback_On_Platform_Code = t.Holdback_On_Platform_Code;
                    objH.Holdback_Release_Date = t.Holdback_Release_Date;
                    objH.Holdback_Comment = t.Holdback_Comment;
                    objH.Acq_Deal_Rights_Holdback_Code = t.Acq_Deal_Rights_Holdback_Code;
                    objH.Is_Original_Language = t.Is_Original_Language;
                    objH._DummyProp = t._DummyProp;
                    if (objH.Syn_Deal_Rights_Holdback_Code > 0)
                        objH.EntityState = State.Modified;
                    else
                        objH.EntityState = State.Added;
                    t.Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Holdback_Platform objP = new Syn_Deal_Rights_Holdback_Platform();
                            objP.Platform_Code = x.Platform_Code;
                            objP.EntityState = State.Added;
                            objH.Syn_Deal_Rights_Holdback_Platform.Add(objP);
                        }
                    });
                    t.Syn_Deal_Rights_Holdback_Territory.ToList<Syn_Deal_Rights_Holdback_Territory>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Holdback_Territory objTer = new Syn_Deal_Rights_Holdback_Territory();
                            objTer.Territory_Code = x.Territory_Code;
                            objTer.Territory_Type = x.Territory_Type;
                            objTer.Country_Code = x.Country_Code;
                            objTer.EntityState = State.Added;
                            objH.Syn_Deal_Rights_Holdback_Territory.Add(objTer);
                        }
                    });
                    t.Syn_Deal_Rights_Holdback_Subtitling.ToList<Syn_Deal_Rights_Holdback_Subtitling>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Holdback_Subtitling objS = new Syn_Deal_Rights_Holdback_Subtitling();
                            objS.Language_Code = x.Language_Code;
                            objS.EntityState = State.Added;
                            objH.Syn_Deal_Rights_Holdback_Subtitling.Add(objS);
                        }
                    });
                    t.Syn_Deal_Rights_Holdback_Dubbing.ToList<Syn_Deal_Rights_Holdback_Dubbing>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Holdback_Dubbing objD = new Syn_Deal_Rights_Holdback_Dubbing();
                            objD.Language_Code = x.Language_Code;
                            objD.EntityState = State.Added;
                            objH.Syn_Deal_Rights_Holdback_Dubbing.Add(objD);
                        }
                    });
                    objExistingRights.Syn_Deal_Rights_Holdback.Add(objH);
                }
            });


            Lst_Syn_Deal_Rights_Blackout.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Syn_Deal_Rights_Blackout objB = new Syn_Deal_Rights_Blackout();
                    objB.Start_Date = t.Start_Date;
                    objB.End_Date = t.End_Date;
                    objB.EntityState = t.EntityState;
                    objExistingRights.Syn_Deal_Rights_Blackout.Add(objB);
                }
            });
            #endregion
            #endregion
            #region -----Promoter
            Lst_Syn_Deal_Rights_Promoter.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Syn_Deal_Rights_Promoter objP = new Syn_Deal_Rights_Promoter();
                    objP.Last_Action_By = objLoginUser.Users_Code;
                    objP.Last_Updated_Time = System.DateTime.Now;

                    if (objP.Syn_Deal_Rights_Promoter_Code > 0)
                        objP.EntityState = State.Modified;
                    else
                        objP.EntityState = State.Added;

                    t.Syn_Deal_Rights_Promoter_Group.ToList<Syn_Deal_Rights_Promoter_Group>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Promoter_Group objG = new Syn_Deal_Rights_Promoter_Group();
                            objG.Promoter_Group_Code = x.Promoter_Group_Code;
                            objG.EntityState = State.Added;
                            objP.Syn_Deal_Rights_Promoter_Group.Add(objG);
                        }
                    });

                    t.Syn_Deal_Rights_Promoter_Remarks.ToList<Syn_Deal_Rights_Promoter_Remarks>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Syn_Deal_Rights_Promoter_Remarks objR = new Syn_Deal_Rights_Promoter_Remarks();
                            objR.Promoter_Remarks_Code = x.Promoter_Remarks_Code;
                            objR.EntityState = State.Added;
                            objP.Syn_Deal_Rights_Promoter_Remarks.Add(objR);
                        }
                    });

                    objExistingRights.Syn_Deal_Rights_Promoter.Add(objP);
                }

            });
            #endregion
            return objExistingRights;
        }

        private bool ShowValidationPopup(dynamic resultSet)
        {
            lstDupRecords = resultSet;
            if (lstDupRecords.Count > 0)
                return false;
            return true;
        }
        #endregion
        public JsonResult Cancel_Rights()
        {
            TempData["QueryString_Rights"] = null;
            objSyn_Deal_Rights = null;
            objPage_Properties = null;
            lstDupRecords = null;
            return Json(objDeal_Schema.PageNo);
        }

        private void SetSyndication_Object()
        {
            //Call From Page Load in Edit Mode
            int[] arr_Syn_Rights_Code = (new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Deal_Rights_Code == objPage_Properties.RCODE).Select(i => i.Syn_Deal_Rights_Code).Distinct().ToArray());
            objPage_Properties.obj_lst_Syn_Rights = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(i => arr_Syn_Rights_Code.Contains(i.Syn_Deal_Rights_Code)).Select(i => i).ToList();
            if (objPage_Properties.Is_Syn_Acq_Mapp == "Y")
            {
                objSyn_Deal_Rights.Disable_SubLicensing = "Y";
                objSyn_Deal_Rights.Disable_Tentative = "Y";
                objSyn_Deal_Rights.Disable_Thetrical = "Y";
                objSyn_Deal_Rights.Disable_RightType = "Y";
                objSyn_Deal_Rights.Existing_RightType = objSyn_Deal_Rights.Right_Type;

                if (objSyn_Deal_Rights.Is_Exclusive == "Y" && objPage_Properties.obj_lst_Syn_Rights.Where(i => i.Is_Exclusive == "Y").Select(i => i.Is_Exclusive.ToString()).FirstOrDefault() == "Y")
                    objSyn_Deal_Rights.Disable_IsExclusive = "Y";
                if (objSyn_Deal_Rights.Is_Title_Language_Right == "Y" && objPage_Properties.obj_lst_Syn_Rights.Where(i => i.Is_Title_Language_Right == "Y").Select(i => i.Is_Title_Language_Right.ToString()).FirstOrDefault() == "Y")
                    objSyn_Deal_Rights.Disable_TitleRights = "Y";
            }
        }

        private bool GET_DATA_FOR_APPROVED_TITLES(string titles, string platforms, string Platform_Type, string Region_Type, string Subtitling_Type, string Dubbing_Type, string CallFrom = "")
        {
            // Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
            platforms = string.Join(",", platforms.Split(',').Where(p => p != "0"));
            List<USP_GET_DATA_FOR_APPROVED_TITLES_Result> objList = new List<USP_GET_DATA_FOR_APPROVED_TITLES_Result>();
            if (titles != "" && titles != "0")
                objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_DATA_FOR_APPROVED_TITLES(titles, platforms, Platform_Type, Region_Type, Subtitling_Type, Dubbing_Type, objDeal_Schema.Deal_Code).ToList();
            else
                AllCountry_Territory_Codes = AllPlatform_Codes = SubTitle_Lang_Codes = Dubb_Lang_Codes = "";
            if (Platform_Type == "PL" || Platform_Type == "TPL")
                AllPlatform_Codes = objList.Select(i => i.RequiredCodes).FirstOrDefault();
            else
            {
                foreach (USP_GET_DATA_FOR_APPROVED_TITLES_Result obj in objList)
                {
                    AllCountry_Territory_Codes = obj.RequiredCodes;
                    SubTitle_Lang_Codes = obj.SubTitle_Lang_Code;
                    Dubb_Lang_Codes = obj.Dubb_Lang_Code;
                }
            }
            return true;
        }

        public Syn_Deal_Rights SetNewSynDealRight(Syn_Deal_Rights objExistingRight, int Title_Code, int Episode_From, int Episode_To, int Platform_Code)
        {
            Syn_Deal_Rights objSecondRight = new Syn_Deal_Rights();
            Syn_Deal_Rights_Title objT = new Syn_Deal_Rights_Title();
            objT.Title_Code = Title_Code;
            objT.Episode_From = Episode_From;
            objT.Episode_To = Episode_To;
            objT.EntityState = State.Added;
            objSecondRight.Right_Status = "P";
            objSecondRight.Syn_Deal_Rights_Title.Add(objT);

            objExistingRight.Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>().ForEach(t =>
            {
                if (t.Platform_Code != Platform_Code)
                {
                    Syn_Deal_Rights_Platform objP = new Syn_Deal_Rights_Platform();
                    objP.Platform_Code = t.Platform_Code;
                    objP.EntityState = State.Added;
                    objSecondRight.Syn_Deal_Rights_Platform.Add(objP);
                }
            });
            objExistingRight.Syn_Deal_Rights_Territory.ToList<Syn_Deal_Rights_Territory>().ForEach(t =>
            {
                Syn_Deal_Rights_Territory objTer = new Syn_Deal_Rights_Territory();
                objTer.Territory_Code = t.Territory_Code;
                objTer.Territory_Type = t.Territory_Type;
                objTer.Country_Code = t.Country_Code;
                objTer.EntityState = State.Added;
                objSecondRight.Syn_Deal_Rights_Territory.Add(objTer);
            });
            objExistingRight.Syn_Deal_Rights_Subtitling.ToList<Syn_Deal_Rights_Subtitling>().ForEach(t =>
            {
                Syn_Deal_Rights_Subtitling objS = new Syn_Deal_Rights_Subtitling();
                objS.Language_Code = t.Language_Code;
                objS.Language_Type = t.Language_Type;
                objS.Language_Group_Code = t.Language_Group_Code;
                objS.EntityState = State.Added;
                objSecondRight.Syn_Deal_Rights_Subtitling.Add(objS);
            });
            objExistingRight.Syn_Deal_Rights_Dubbing.ToList<Syn_Deal_Rights_Dubbing>().ForEach(t =>
            {
                Syn_Deal_Rights_Dubbing objD = new Syn_Deal_Rights_Dubbing();
                objD.Language_Code = t.Language_Code;
                objD.Language_Type = t.Language_Type;
                objD.Language_Group_Code = t.Language_Group_Code;
                objD.EntityState = State.Added;
                objSecondRight.Syn_Deal_Rights_Dubbing.Add(objD);
            });
            objExistingRight.Syn_Deal_Rights_Holdback.ToList<Syn_Deal_Rights_Holdback>().ForEach(t =>
            {
                Syn_Deal_Rights_Holdback objH = new Syn_Deal_Rights_Holdback();
                objH.Holdback_Type = t.Holdback_Type;
                objH.HB_Run_After_Release_No = t.HB_Run_After_Release_No;
                objH.HB_Run_After_Release_Units = t.HB_Run_After_Release_Units;
                objH.Holdback_On_Platform_Code = t.Holdback_On_Platform_Code;
                objH.Holdback_Release_Date = t.Holdback_Release_Date;
                objH.Holdback_Comment = t.Holdback_Comment;
                objH.Is_Title_Language_Right = t.Is_Title_Language_Right;
                objH.Is_Original_Language = t.Is_Original_Language;
                objH.EntityState = State.Added;
                t.Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>().ForEach(x =>
                {
                    Syn_Deal_Rights_Holdback_Platform objP = new Syn_Deal_Rights_Holdback_Platform();
                    objP.Platform_Code = x.Platform_Code;
                    objP.EntityState = State.Added;
                    objH.Syn_Deal_Rights_Holdback_Platform.Add(objP);
                });
                t.Syn_Deal_Rights_Holdback_Territory.ToList<Syn_Deal_Rights_Holdback_Territory>().ForEach(x =>
                {
                    Syn_Deal_Rights_Holdback_Territory objTer = new Syn_Deal_Rights_Holdback_Territory();
                    objTer.Territory_Code = x.Territory_Code;
                    objTer.Territory_Type = x.Territory_Type;
                    objTer.Country_Code = x.Country_Code;
                    objTer.EntityState = State.Added;
                    objH.Syn_Deal_Rights_Holdback_Territory.Add(objTer);
                });
                t.Syn_Deal_Rights_Holdback_Subtitling.ToList<Syn_Deal_Rights_Holdback_Subtitling>().ForEach(x =>
                {
                    Syn_Deal_Rights_Holdback_Subtitling objS = new Syn_Deal_Rights_Holdback_Subtitling();
                    objS.Language_Code = x.Language_Code;
                    objS.EntityState = State.Added;
                    objH.Syn_Deal_Rights_Holdback_Subtitling.Add(objS);
                });
                t.Syn_Deal_Rights_Holdback_Dubbing.ToList<Syn_Deal_Rights_Holdback_Dubbing>().ForEach(x =>
                {
                    Syn_Deal_Rights_Holdback_Dubbing objD = new Syn_Deal_Rights_Holdback_Dubbing();
                    objD.Language_Code = x.Language_Code;
                    objD.EntityState = State.Added;
                    objH.Syn_Deal_Rights_Holdback_Dubbing.Add(objD);
                });
                objSecondRight.Syn_Deal_Rights_Holdback.Add(objH);
            });
            objExistingRight.Syn_Deal_Rights_Promoter.ToList<Syn_Deal_Rights_Promoter>().ForEach(t =>
            {
                Syn_Deal_Rights_Promoter objPromoter = new Syn_Deal_Rights_Promoter();
                objPromoter.EntityState = State.Added;
                t.Syn_Deal_Rights_Promoter_Group.ToList<Syn_Deal_Rights_Promoter_Group>().ForEach(x =>
                {
                    Syn_Deal_Rights_Promoter_Group objG = new Syn_Deal_Rights_Promoter_Group();
                    objG.Promoter_Group_Code = x.Promoter_Group_Code;
                    objG.EntityState = State.Added;
                    objPromoter.Syn_Deal_Rights_Promoter_Group.Add(objG);
                });
                t.Syn_Deal_Rights_Promoter_Remarks.ToList<Syn_Deal_Rights_Promoter_Remarks>().ForEach(x =>
                {
                    Syn_Deal_Rights_Promoter_Remarks objR = new Syn_Deal_Rights_Promoter_Remarks();
                    objR.Promoter_Remarks_Code = x.Promoter_Remarks_Code;
                    objR.EntityState = State.Added;
                    objPromoter.Syn_Deal_Rights_Promoter_Remarks.Add(objR);
                });

                objSecondRight.Syn_Deal_Rights_Promoter.Add(objPromoter);
            });
            objSecondRight.Syn_Deal_Code = objExistingRight.Syn_Deal_Code;
            objSecondRight.Is_Exclusive = objExistingRight.Is_Exclusive;
            objSecondRight.Is_Title_Language_Right = objExistingRight.Is_Title_Language_Right;
            objSecondRight.Is_Sub_License = objExistingRight.Is_Sub_License;
            objSecondRight.Sub_License_Code = objExistingRight.Sub_License_Code;
            objSecondRight.Is_Theatrical_Right = objExistingRight.Is_Theatrical_Right;
            objSecondRight.Right_Type = objExistingRight.Right_Type;
            objSecondRight.Is_Pushback = "N";
            objSecondRight.Is_Tentative = objExistingRight.Is_Tentative;
            objSecondRight.Right_Start_Date = objExistingRight.Right_Start_Date;
            objSecondRight.Right_End_Date = objExistingRight.Right_End_Date;
            objSecondRight.Effective_Start_Date = objExistingRight.Effective_Start_Date;
            objSecondRight.Actual_Right_Start_Date = objExistingRight.Actual_Right_Start_Date;
            objSecondRight.Actual_Right_End_Date = objExistingRight.Actual_Right_End_Date;
            objSecondRight.Term = objExistingRight.Term;
            objSecondRight.Milestone_Type_Code = objExistingRight.Milestone_Type_Code;
            objSecondRight.Milestone_No_Of_Unit = objExistingRight.Milestone_No_Of_Unit;
            objSecondRight.Milestone_Unit_Type = objExistingRight.Milestone_Unit_Type;
            objSecondRight.Is_ROFR = objExistingRight.Is_ROFR;
            objSecondRight.ROFR_Date = objExistingRight.ROFR_Date;
            objSecondRight.Restriction_Remarks = objExistingRight.Restriction_Remarks;
            objSecondRight.Inserted_By = objExistingRight.Inserted_By;
            objSecondRight.Inserted_On = objExistingRight.Inserted_On;
            if (objLoginUser != null)
                objSecondRight.Last_Action_By = objLoginUser.Users_Code;
            objSecondRight.Last_Updated_Time = DateTime.Now;
            objSecondRight.EntityState = State.Added;
            return objSecondRight;
        }

        public JsonResult CheckTheatrical(string titleCodes)
        {
            GET_DATA_FOR_APPROVED_TITLES(titleCodes, "", "TPL", "", "", "");
            return Json(AllPlatform_Codes);
        }

        public PartialViewResult ShowRestriction_Remarks_Popup()
        {
            List<USP_Get_Data_Restriction_Remark_UDT> objResult = new List<USP_Get_Data_Restriction_Remark_UDT>();
            if (objSyn_Deal_Rights != null)
            {
                IEnumerable<string> obj_Mapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Acq_Mapping(objSyn_Deal_Rights.Syn_Deal_Code, "N");
                objResult = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Data_Restriction_Remark_UDT(
                   objSyn_Deal_Rights.LstDeal_Rights_UDT,
                   objSyn_Deal_Rights.LstDeal_Rights_Title_UDT,
                   objSyn_Deal_Rights.LstDeal_Rights_Platform_UDT,
                   objSyn_Deal_Rights.LstDeal_Rights_Territory_UDT,
                   objSyn_Deal_Rights.LstDeal_Rights_Subtitling_UDT,
                   objSyn_Deal_Rights.LstDeal_Rights_Dubbing_UDT).ToList();
            }
            return PartialView("~/Views/Syn_Deal/_Syn_RestRemark_Popup.cshtml", objResult);
        }

        private void Set_Selected_Codes()
        {
            string selected_Title_Code = "";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.EntityState != State.Deleted && y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
            else
                selected_Title_Code = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(i => i.EntityState != State.Deleted).Select(t => t.Title_Code.ToString()).Distinct());

            string selected_Country_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type == "G" ? i.Territory_Code : i.Country_Code).ToList()));
            string selected_SL_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group_Code : i.Language_Code).ToList()));
            string selected_DL_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group_Code : i.Language_Code).ToList()));

            string Region_Type = "I";
            if (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Region_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).ElementAt(0).Territory_Type;

            string Sub_Type = "L";
            if (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Sub_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            string Dub_Type = "L";
            if (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Dub_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            objSyn_Deal_Rights.Title_Codes = selected_Title_Code;
            objSyn_Deal_Rights.Region_Type = Region_Type;
            objSyn_Deal_Rights.Sub_Type = Sub_Type;
            objSyn_Deal_Rights.Dub_Type = Dub_Type;
            objSyn_Deal_Rights.Region_Codes = selected_Country_Code;
            objSyn_Deal_Rights.Sub_Codes = selected_SL_Code;
            objSyn_Deal_Rights.Dub_Codes = selected_DL_Code;
        }

        //public JsonResult CheckHoldbackExistInAcq(Syn_Deal_Rights objRights)
        //{
        //    //USP_Service objService = new USP_Service();
        //    //if(objSyn_Deal_Rights.LstDeal_Rights_Territory_UDT.)
        //    //objService.USP_ValidateIfHoldbackExist(objSyn_Deal_Rights.Title_Codes,objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Select(p => p.));
        //    return Json("");
        //}
        public JsonResult CancelHoldbackCopy()
        {
            Session["HoldbackCancelled"] = "Y";
            return Json("");
        }

        public JsonResult DeleteExistingPromoter()
        {
            objSyn_Deal_Rights.Syn_Deal_Rights_Promoter.Select(x => x.EntityState = State.Deleted).ToList();

            var ob = new
            {
            };
            return Json(ob);
        }
    }
    public class Syn_Deal_Rights_Holdback_Validation
    {
        private string _Title_Name = string.Empty;
        private string _Region = string.Empty;
        private string _Platform = string.Empty;
        public string Title_Name
        {
            get { return _Title_Name; }
            set { _Title_Name = value; }
        }
        public string Region
        {
            get { return _Region; }
            set { _Region = value; }
        }
        public string Platform
        {
            get { return _Platform; }
            set { _Platform = value; }
        }
    }
}

