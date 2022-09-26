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
    public class Acq_RightsController : BaseController
    {
        #region --- Session Declaration ---
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
        public Acq_Deal_Rights objAcq_Deal_Rights
        {
            get
            {
                if (Session["ACQ_DEAL_RIGHTS"] == null)
                    Session["ACQ_DEAL_RIGHTS"] = new Acq_Deal_Rights();
                return (Acq_Deal_Rights)Session["ACQ_DEAL_RIGHTS"];
            }
            set { Session["ACQ_DEAL_RIGHTS"] = value; }
        }
        public List<Acq_Deal_Rights_Holdback> Lst_Acq_Deal_Rights_Holdback
        {
            get
            {
                if (Session["Lst_Acq_Deal_Rights_Holdback"] == null && objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Count() == 0)
                    Session["Lst_Acq_Deal_Rights_Holdback"] = new List<Acq_Deal_Rights_Holdback>();
                return (List<Acq_Deal_Rights_Holdback>)Session["Lst_Acq_Deal_Rights_Holdback"];
            }
            set { Session["Lst_Acq_Deal_Rights_Holdback"] = value; }
        }
        public List<Acq_Deal_Rights_Blackout> Lst_Acq_Deal_Rights_Blackout
        {
            get
            {
                if (Session["Lst_Acq_Deal_Rights_Blackout"] == null && objAcq_Deal_Rights.Acq_Deal_Rights_Blackout.Count() == 0)
                    Session["Lst_Acq_Deal_Rights_Blackout"] = new List<Acq_Deal_Rights_Blackout>();
                return (List<Acq_Deal_Rights_Blackout>)Session["Lst_Acq_Deal_Rights_Blackout"];
            }
            set { Session["Lst_Acq_Deal_Rights_Blackout"] = value; }
        }
        public List<Acq_Deal_Rights_Promoter> Lst_Acq_Deal_Rights_Promoter
        {
            get
            {
                if (Session["Lst_Acq_Deal_Rights_Promoter"] == null && objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Count() == 0)
                    Session["Lst_Acq_Deal_Rights_Promoter"] = new List<Acq_Deal_Rights_Promoter>();
                return (List<Acq_Deal_Rights_Promoter>)Session["Lst_Acq_Deal_Rights_Promoter"];
            }
            set { Session["Lst_Acq_Deal_Rights_Promoter"] = value; }
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
        public List<Acq_Deal_Rights_Holdback_Validation> lstADRHV
        {
            get
            {
                if (Session["lstADRHV"] == null)
                    Session["lstADRHV"] = new List<Acq_Deal_Rights_Holdback_Validation>();
                return (List<Acq_Deal_Rights_Holdback_Validation>)Session["lstADRHV"];
            }
            set { Session["lstADRHV"] = value; }
        }

        public bool Is_Buyback
        {
            get
            {
                if (Session["Is_Buyback"] == null)
                    Session["Is_Buyback"] = false;
                return Convert.ToBoolean(Session["Is_Buyback"]);
            }
            set { Session["Is_Buyback"] = value; }
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

        public Syn_Deal_Rights objSyn_Deal_Rights_Buyback
        {
            get
            {
                if (Session["Syn_Deal_Rights"] == null)
                    Session["Syn_Deal_Rights"] = new Syn_Deal_Rights();
                return (Syn_Deal_Rights)Session["Syn_Deal_Rights"];
            }
            set { Session["Syn_Deal_Rights"] = value; }
        }
        #endregion

        #region --- New Changes ---
        public PartialViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            objAcq_Deal_Rights = null;
            Lst_Acq_Deal_Rights_Holdback = null;
            Lst_Acq_Deal_Rights_Blackout = null;
            objPage_Properties = null;
            lstDupRecords = null;
            lstADRHV = null;
            objSyn_Deal_Rights_Buyback = null;
            Session["Is_Buyback"] = false;
            Session["FileName"] = null;

            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();

            if (TempData["QueryString_Rights"] != null)
            {
                obj_Dictionary = TempData["QueryString_Rights"] as Dictionary<string, string>;
                TempData.Keep("QueryString_Rights");
                objPage_Properties.RMODE = obj_Dictionary["MODE"];
            }

            if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_ADD)
            {
                objAcq_Deal_Rights = new Acq_Deal_Rights();
                objAcq_Deal_Rights.Right_Type = objAcq_Deal_Rights.Original_Right_Type = "Y";
                objAcq_Deal_Rights.Is_Theatrical_Right = "N";
                SetSelectedCodesToObject();
                SelectList arr_Template_List = new SelectList(new Acq_Rights_Template_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y")
                   .Select(i => new { i.Acq_Rights_Template_Code, i.Template_Name }).ToList(), "Acq_Rights_Template_Code", "Template_Name");

                ViewBag.arr_Template_List = arr_Template_List;
                objAcq_Deal_Rights.Platform_Codes = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            }
            else if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_CLONE || objPage_Properties.RMODE == GlobalParams.DEAL_MODE_EDIT)
            {
                objPage_Properties.RCODE = Convert.ToInt32(obj_Dictionary["RCode"]);
                objPage_Properties.PCODE = Convert.ToInt32(obj_Dictionary["PCode"]);
                objPage_Properties.TCODE = Convert.ToInt32(obj_Dictionary["TCode"]);
                objPage_Properties.Episode_From = Convert.ToInt32(obj_Dictionary["Episode_From"]);
                objPage_Properties.Episode_To = Convert.ToInt32(obj_Dictionary["Episode_To"]);
                objPage_Properties.IsHB = obj_Dictionary["IsHB"];

                if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_CLONE)
                {
                    FillCloneFormDetails();
                    objPage_Properties.RCODE = 0;
                    objPage_Properties.TCODE = 0;
                    objPage_Properties.PCODE = 0;
                }
                else
                {
                    objPage_Properties.Is_Syn_Acq_Mapp = obj_Dictionary["Is_Syn_Acq_Mapp"];
                    FillFormDetails();

                    if ((new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Deal_Rights_Code == objPage_Properties.RCODE).Count()) > 0)
                        SetSyndication_Object();

                    if (objAcq_Deal_Rights.Right_Type == "Y")
                        SetRunDefinition_Object();

                    if (objAcq_Deal_Rights.Right_Type == "M" && objPage_Properties.Is_Syn_Acq_Mapp == "Y" && !string.IsNullOrEmpty(objAcq_Deal_Rights.Milestone_Start_Date) && !string.IsNullOrEmpty(objAcq_Deal_Rights.Milestone_End_Date))
                        objAcq_Deal_Rights.Disable_RightType = "M";
                }
            }
            ViewBag.AcqSyn_Rights_Thetrical = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Rights_Thetrical").First().Parameter_Value.ToString();
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

            ViewBag.Allow_Perpetual_Date_Logic = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Allow_Perpetual_Date_Logic").FirstOrDefault().Parameter_Value;
            ViewBag.Deal_Workflow_Flag = objDeal_Schema.Deal_Workflow_Flag;
            objPage_Properties.Is_Syn_Acq_Mapp = obj_Dictionary["Is_Syn_Acq_Mapp"];
            SetVisibility();

            objDeal_Schema.Page_From = GlobalParams.Page_From_Rights;

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;

            Syn_Deal_Rights objSyn_Deal_Rights = new Syn_Deal_Rights();
            Syn_Deal_Rights_Platform objSyn_Deal_Rights_Platform = new Syn_Deal_Rights_Platform();

            objAcq_Deal_Rights.Buyback_Syn_Rights_Code = objAcq_Deal_Rights.Buyback_Syn_Rights_Code == "" ? null : objAcq_Deal_Rights.Buyback_Syn_Rights_Code;

            string isTitleLanguageDisabledForBuyback = "";

            if (objAcq_Deal_Rights.Buyback_Syn_Rights_Code != null)
            {
                objSyn_Deal_Rights_Buyback = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(objAcq_Deal_Rights.Buyback_Syn_Rights_Code));
                string.Join(",", (objSyn_Deal_Rights_Buyback.Syn_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
                isTitleLanguageDisabledForBuyback = objSyn_Deal_Rights_Buyback.Is_Title_Language_Right;
            }

            ViewBag.StartDate_Buyback = objSyn_Deal_Rights_Buyback.Actual_Right_Start_Date == null ? "" : ((DateTime)objSyn_Deal_Rights_Buyback.Actual_Right_Start_Date).ToString("dd/MM/yyyy");//objSyn_Deal_Rights_Buyback.Actual_Right_Start_Date;
            ViewBag.EndDate_Buyback = objSyn_Deal_Rights_Buyback.Actual_Right_End_Date == null ? "" : ((DateTime)objSyn_Deal_Rights_Buyback.Actual_Right_End_Date).ToString("dd/MM/yyyy");
            ViewBag.IsSynExclusive = objSyn_Deal_Rights_Buyback.Is_Exclusive;
            ViewBag.IsTitleLanguageForBuyback = isTitleLanguageDisabledForBuyback;


            Session["FileName"] = "acq_Rights";
            ViewBag.TreeId = "Rights_Platform";
            return PartialView("~/Views/Acq_Deal/_Acq_Rights.cshtml", objAcq_Deal_Rights);
        }
        public PartialViewResult View()
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();

            if (TempData["QueryString_Rights"] != null)
            {
                obj_Dictionary = TempData["QueryString_Rights"] as Dictionary<string, string>;
                TempData.Keep("QueryString_Rights");
            }

            objAcq_Deal_Rights = null;
            Lst_Acq_Deal_Rights_Holdback = null;
            Lst_Acq_Deal_Rights_Blackout = null;
            objPage_Properties = null;
            lstDupRecords = null;
            lstADRHV = null;
            Session["FileName"] = null;
            Session["Is_Buyback"] = false;

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

            if ((new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Deal_Rights_Code == objPage_Properties.RCODE).Count()) > 0)
                SetSyndication_Object();

            objDeal_Schema.Page_From = GlobalParams.Page_From_Rights;
            ViewBag.Record_Locking_Code = 0;
            ViewBag.Allow_Perpetual_Date_Logic = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Allow_Perpetual_Date_Logic").FirstOrDefault().Parameter_Value;

            try
            {
                ViewBag.AcqSyn_Rights_Thetrical = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Rights_Thetrical").First().Parameter_Value.ToString();
                ViewBag.Enabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
            }
            catch (Exception e)
            {
                ViewBag.Enabled_Perpetuity = "N";
            }
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;

            Session["FileName"] = "";
            Session["FileName"] = "acq_Rights";
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.PromoterTab = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Promoter_Tab").First().Parameter_Value;
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_View.cshtml", objAcq_Deal_Rights);
        }
        #endregion

        #region --- Other Methods ---
        private DateTime CalculateEndDate()
        {
            int Year = Convert.ToInt32(objAcq_Deal_Rights.Term_YY);
            int Month = Convert.ToInt32(objAcq_Deal_Rights.Term_MM);
            int Day = Convert.ToInt32(objAcq_Deal_Rights.Term_DD);
            DateTime EDate = (objAcq_Deal_Rights.Actual_Right_Start_Date.Value).AddYears(Year).AddMonths(Month).AddDays(Day);
            return EDate;
        }
        private void FillFormDetails()
        {
            ViewBag.MODE = "E";
            Acq_Deal_Rights_Service objADRS = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            //string Enabled_Perpetuity= new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
            objAcq_Deal_Rights.Acq_Deal_Rights_Code = objPage_Properties.RCODE;
            objAcq_Deal_Rights = objADRS.GetById(objAcq_Deal_Rights.Acq_Deal_Rights_Code);

            objAcq_Deal_Rights.Buyback_Syn_Rights_Code = objAcq_Deal_Rights.Buyback_Syn_Rights_Code == "" ? null : objAcq_Deal_Rights.Buyback_Syn_Rights_Code;
            if (objAcq_Deal_Rights.Buyback_Syn_Rights_Code != null)
            {
                Session["Is_Buyback"] = true;
            }
            else
            {
                Session["Is_Buyback"] = false;
            }

            if (objAcq_Deal_Rights.Original_Right_Type == null && objAcq_Deal_Rights.Right_Type == "U")
                objAcq_Deal_Rights.Original_Right_Type = "";
            else if (objAcq_Deal_Rights.Original_Right_Type == null)
                objAcq_Deal_Rights.Original_Right_Type = objAcq_Deal_Rights.Right_Type;
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

                objAcq_Deal_Rights.Acq_Deal_Rights_Title.Clear();
                Acq_Deal_Rights_Title objAcq_Deal_Rights_Title = new Acq_Deal_Rights_Title();
                objAcq_Deal_Rights_Title.Title_Code = objPage_Properties.TCODE;
                objAcq_Deal_Rights_Title.Episode_From = EpStart;
                objAcq_Deal_Rights_Title.Episode_To = EpEnd;
                objAcq_Deal_Rights.Acq_Deal_Rights_Title.Add(objAcq_Deal_Rights_Title);
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    objPage_Properties.Acquired_Title_Codes = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    objPage_Properties.Acquired_Title_Codes = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(t => t.Title_Code.ToString()).Distinct());
            }

            if (objPage_Properties.PCODE > 0)
            {
                objAcq_Deal_Rights.Acq_Deal_Rights_Platform = objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Where(t => t.Platform_Code == objPage_Properties.PCODE).ToList<Acq_Deal_Rights_Platform>();

                if (objPage_Properties.IsHB.ToUpper() == "YES")
                {
                    objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.ToList<Acq_Deal_Rights_Holdback>().ForEach(t => t.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Acq_Deal_Rights_Holdback_Platform.Remove(x); }));
                    objAcq_Deal_Rights.Acq_Deal_Rights_Blackout.ToList<Acq_Deal_Rights_Blackout>().ForEach(t => t.Acq_Deal_Rights_Blackout_Platform.ToList<Acq_Deal_Rights_Blackout_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Acq_Deal_Rights_Blackout_Platform.Remove(x); }));
                }
                else
                    objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Clear();
            }

            if (objAcq_Deal_Rights.Original_Right_Type == "Y" || objAcq_Deal_Rights.Original_Right_Type == "U")
            {
                objAcq_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objAcq_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_End_Date).Replace("-", "/");
                string[] arr = objAcq_Deal_Rights.Term.Split('.');
                objAcq_Deal_Rights.Term_YY = arr[0];
                objAcq_Deal_Rights.Term_MM = arr[1];
                if (arr.Length > 2)
                    objAcq_Deal_Rights.Term_DD = arr[2];
                else
                    objAcq_Deal_Rights.Term_DD = "0";

                if (objAcq_Deal_Rights.Original_Right_Type == "U")
                    objAcq_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }
            else if (objAcq_Deal_Rights.Original_Right_Type == "M")
            {
                if (objAcq_Deal_Rights.Actual_Right_Start_Date != null)
                    objAcq_Deal_Rights.Milestone_Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
                else
                    objAcq_Deal_Rights.Is_Tentative = "Y";

                if (objAcq_Deal_Rights.Actual_Right_End_Date != null)
                    objAcq_Deal_Rights.Milestone_End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_End_Date).Replace("-", "/");
            }
            else if (objAcq_Deal_Rights.Right_Type == "U" && objAcq_Deal_Rights.Original_Right_Type.TrimEnd() == "")
            {
                objAcq_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_Start_Date).Replace("-", "/");
                //objAcq_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_End_Date).Replace("-", "/");
                //string[] arr = objAcq_Deal_Rights.Term.Split('.');
                //objAcq_Deal_Rights.Term_YY = arr[0];
                //objAcq_Deal_Rights.Term_MM = arr[1];

                //if (objAcq_Deal_Rights.Original_Right_Type == "U")
                objAcq_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }

            if (objAcq_Deal_Rights.ROFR_Date != DateTime.MinValue && objAcq_Deal_Rights.ROFR_Date != null)
            {
                objAcq_Deal_Rights.ROFR_DT = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.ROFR_Date).Replace("-", "/");
                if (objAcq_Deal_Rights.Right_End_Date != DateTime.MinValue && objAcq_Deal_Rights.Right_End_Date != null)
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString((objAcq_Deal_Rights.Right_End_Date.Value - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays);
                else
                    if (objAcq_Deal_Rights.Term_YY != null || objAcq_Deal_Rights.Term_MM != null || objAcq_Deal_Rights.Term_DD != null)
                {
                    DateTime EndDate = CalculateEndDate();
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString(((EndDate - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays) - 1);
                }
                else
                        if (objAcq_Deal_Rights.Right_Type == "M" && objAcq_Deal_Rights.Actual_Right_End_Date != null && objAcq_Deal_Rights.Actual_Right_End_Date != DateTime.MinValue)
                {
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString((objAcq_Deal_Rights.Actual_Right_End_Date.Value - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays);
                }
            }

            SetSelectedCodesToObject();
            objPage_Properties.Acquired_Platform_Codes = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            string strPlatform = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            objAcq_Deal_Rights.Platform_Codes = strPlatform;

            if (objAcq_Deal_Rights.Sub_Type == "L")
                objPage_Properties.Acquired_Subtitling_Codes = objAcq_Deal_Rights.Sub_Codes;
            else
                objPage_Properties.Acquired_Subtitling_Codes = GetLangCodes(objAcq_Deal_Rights.Sub_Codes);

            if (objAcq_Deal_Rights.Dub_Type == "L")
                objPage_Properties.Acquired_Dubbing_Codes = objAcq_Deal_Rights.Dub_Codes;
            else
                objPage_Properties.Acquired_Dubbing_Codes = GetLangCodes(objAcq_Deal_Rights.Dub_Codes);
        }
        private void FillCloneFormDetails()
        {
            ViewBag.MODE = "C";
            Acq_Deal_Rights_Service objADRS = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Rights objAcq_Deal_Rights_Current = objADRS.GetById(objPage_Properties.RCODE);
            if (objAcq_Deal_Rights.Original_Right_Type == null && objAcq_Deal_Rights.Right_Type == "U")
                objAcq_Deal_Rights.Original_Right_Type = "";
            else if (objAcq_Deal_Rights.Original_Right_Type == null)
                objAcq_Deal_Rights.Original_Right_Type = objAcq_Deal_Rights.Right_Type;
            #region Set object for Clone

            objAcq_Deal_Rights = new Acq_Deal_Rights();
            objAcq_Deal_Rights.Promoter_Flag = objAcq_Deal_Rights_Current.Promoter_Flag;
            objAcq_Deal_Rights.Acq_Deal_Code = objAcq_Deal_Rights_Current.Acq_Deal_Code;
            objAcq_Deal_Rights.Actual_Right_Start_Date = objAcq_Deal_Rights_Current.Actual_Right_Start_Date;
            objAcq_Deal_Rights.Actual_Right_End_Date = objAcq_Deal_Rights_Current.Actual_Right_End_Date;
            objAcq_Deal_Rights.Disable_IsExclusive = objAcq_Deal_Rights_Current.Disable_IsExclusive;
            objAcq_Deal_Rights.Disable_RightType = objAcq_Deal_Rights_Current.Disable_RightType;
            objAcq_Deal_Rights.Disable_SubLicensing = objAcq_Deal_Rights_Current.Disable_SubLicensing;
            objAcq_Deal_Rights.Disable_Tentative = objAcq_Deal_Rights_Current.Disable_Tentative;
            objAcq_Deal_Rights.Disable_Thetrical = objAcq_Deal_Rights_Current.Disable_Thetrical;
            objAcq_Deal_Rights.Disable_TitleRights = objAcq_Deal_Rights_Current.Disable_TitleRights;
            objAcq_Deal_Rights.Dub_Codes = objAcq_Deal_Rights_Current.Dub_Codes;
            objAcq_Deal_Rights.Dub_Type = objAcq_Deal_Rights_Current.Dub_Type;
            objAcq_Deal_Rights.Effective_Start_Date = objAcq_Deal_Rights_Current.Effective_Start_Date;
            objAcq_Deal_Rights.End_Date = objAcq_Deal_Rights_Current.End_Date;
            objAcq_Deal_Rights.Existing_RightType = objAcq_Deal_Rights_Current.Existing_RightType;
            objAcq_Deal_Rights.Is_Exclusive = objAcq_Deal_Rights_Current.Is_Exclusive;
            objAcq_Deal_Rights.Is_Under_Production = objAcq_Deal_Rights_Current.Is_Under_Production;
            objAcq_Deal_Rights.Is_ROFR = objAcq_Deal_Rights_Current.Is_ROFR;
            objAcq_Deal_Rights.Is_Sub_License = objAcq_Deal_Rights_Current.Is_Sub_License;

            objAcq_Deal_Rights.Is_Theatrical_Right = objAcq_Deal_Rights_Current.Is_Theatrical_Right;
            objAcq_Deal_Rights.Is_Title_Language_Right = objAcq_Deal_Rights_Current.Is_Title_Language_Right;
            objAcq_Deal_Rights.Is_Verified = objAcq_Deal_Rights_Current.Is_Verified;
            objAcq_Deal_Rights.Milestone_No_Of_Unit = objAcq_Deal_Rights_Current.Milestone_No_Of_Unit;
            objAcq_Deal_Rights.Milestone_Type_Code = objAcq_Deal_Rights_Current.Milestone_Type_Code;
            objAcq_Deal_Rights.Milestone_Unit_Type = objAcq_Deal_Rights_Current.Milestone_Unit_Type;
            objAcq_Deal_Rights.Perpetuity_Date = objAcq_Deal_Rights_Current.Perpetuity_Date;
            objAcq_Deal_Rights.Platform_Codes = objAcq_Deal_Rights_Current.Platform_Codes;
            objAcq_Deal_Rights.Region_Codes = objAcq_Deal_Rights_Current.Region_Codes;
            objAcq_Deal_Rights.Region_Type = objAcq_Deal_Rights_Current.Region_Type;
            objAcq_Deal_Rights.Restriction_Remarks = objAcq_Deal_Rights_Current.Restriction_Remarks;
            objAcq_Deal_Rights.Right_Type = objAcq_Deal_Rights_Current.Right_Type;
            objAcq_Deal_Rights.Original_Right_Type = objAcq_Deal_Rights_Current.Original_Right_Type;
            if (objAcq_Deal_Rights.Original_Right_Type != "M")
            {
                objAcq_Deal_Rights.Is_Tentative = objAcq_Deal_Rights_Current.Is_Tentative;
                objAcq_Deal_Rights.Right_End_Date = objAcq_Deal_Rights_Current.Right_End_Date;
                objAcq_Deal_Rights.Right_Start_Date = objAcq_Deal_Rights_Current.Right_Start_Date;
            }
            objAcq_Deal_Rights.Right_Status = objAcq_Deal_Rights_Current.Right_Status;
            if (objAcq_Deal_Rights.Original_Right_Type == "M")
            {
                objAcq_Deal_Rights.Is_Tentative = "Y";
                if (objAcq_Deal_Rights.Actual_Right_Start_Date != null)
                    objAcq_Deal_Rights.Milestone_Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
                if (objAcq_Deal_Rights.Actual_Right_End_Date != null)
                    objAcq_Deal_Rights.Milestone_End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_End_Date).Replace("-", "/");
            }
            else if (objAcq_Deal_Rights.Right_Type == "U" && objAcq_Deal_Rights.Original_Right_Type.TrimEnd() == "")
            {
                objAcq_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_Start_Date).Replace("-", "/");
                //objAcq_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_End_Date).Replace("-", "/");
                //string[] arr = objAcq_Deal_Rights.Term.Split('.');
                //objAcq_Deal_Rights.Term_YY = arr[0];
                //objAcq_Deal_Rights.Term_MM = arr[1];

                //if (objAcq_Deal_Rights.Original_Right_Type == "U")
                objAcq_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }

            objAcq_Deal_Rights.ROFR_Code = objAcq_Deal_Rights_Current.ROFR_Code;
            objAcq_Deal_Rights.ROFR_Date = objAcq_Deal_Rights_Current.ROFR_Date;
            objAcq_Deal_Rights.ROFR_Days = objAcq_Deal_Rights_Current.ROFR_Days;
            objAcq_Deal_Rights.ROFR_DT = objAcq_Deal_Rights_Current.ROFR_DT;
            objAcq_Deal_Rights.Start_Date = objAcq_Deal_Rights_Current.Start_Date;
            objAcq_Deal_Rights.Sub_Codes = objAcq_Deal_Rights_Current.Sub_Codes;
            objAcq_Deal_Rights.Sub_License_Code = objAcq_Deal_Rights_Current.Sub_License_Code;
            objAcq_Deal_Rights.Sub_Type = objAcq_Deal_Rights_Current.Sub_Type;
            objAcq_Deal_Rights.Term = objAcq_Deal_Rights_Current.Term;
            objAcq_Deal_Rights.Term_MM = objAcq_Deal_Rights_Current.Term_MM;
            objAcq_Deal_Rights.Term_YY = objAcq_Deal_Rights_Current.Term_YY;
            objAcq_Deal_Rights.Term_DD = objAcq_Deal_Rights_Current.Term_DD;
            objAcq_Deal_Rights.Theatrical_Platform_Code = objAcq_Deal_Rights_Current.Theatrical_Platform_Code;
            objAcq_Deal_Rights.Title_Codes = objAcq_Deal_Rights_Current.Title_Codes;

            objAcq_Deal_Rights_Current.Acq_Deal_Rights_Dubbing.ToList().ForEach(d =>
            {
                Acq_Deal_Rights_Dubbing objDub = new Acq_Deal_Rights_Dubbing();
                objDub.Language_Code = d.Language_Code;
                objDub.Language_Group_Code = d.Language_Group_Code;
                objDub.Language_Type = d.Language_Type;
                objDub.EntityState = State.Added;
                objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Add(objDub);
            });

            objAcq_Deal_Rights_Current.Acq_Deal_Rights_Subtitling.ToList().ForEach(d =>
            {
                Acq_Deal_Rights_Subtitling objDub = new Acq_Deal_Rights_Subtitling();
                objDub.Language_Code = d.Language_Code;
                objDub.Language_Group_Code = d.Language_Group_Code;
                objDub.Language_Type = d.Language_Type;
                objDub.EntityState = State.Added;
                objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Add(objDub);
            });

            objAcq_Deal_Rights_Current.Acq_Deal_Rights_Platform.ToList().ForEach(d =>
            {
                Acq_Deal_Rights_Platform objDub = new Acq_Deal_Rights_Platform();
                objDub.Platform_Code = d.Platform_Code;
                objDub.EntityState = State.Added;
                objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Add(objDub);
            });

            objAcq_Deal_Rights_Current.Acq_Deal_Rights_Territory.ToList().ForEach(d =>
            {
                Acq_Deal_Rights_Territory objDub = new Acq_Deal_Rights_Territory();
                objDub.Country_Code = d.Country_Code;
                objDub.Territory_Code = d.Territory_Code;
                objDub.Territory_Type = d.Territory_Type;
                objDub.EntityState = State.Added;
                objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Add(objDub);
            });

            objAcq_Deal_Rights_Current.Acq_Deal_Rights_Title.ToList().ForEach(d =>
            {
                Acq_Deal_Rights_Title objDub = new Acq_Deal_Rights_Title();
                objDub.Title_Code = d.Title_Code;
                objDub.Episode_From = d.Episode_From;
                objDub.Episode_To = d.Episode_To;
                objDub.EntityState = State.Added;
                objAcq_Deal_Rights.Acq_Deal_Rights_Title.Add(objDub);
            });

            List<Acq_Deal_Rights_Holdback> lstRightsHoldBack = objAcq_Deal_Rights_Current.Acq_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted).ToList();
            List<Acq_Deal_Rights_Blackout> lstRightsBlackOuts = objAcq_Deal_Rights_Current.Acq_Deal_Rights_Blackout.Where(t => t.EntityState != State.Deleted).ToList();
            List<Acq_Deal_Rights_Promoter> lstRightsPromoter = objAcq_Deal_Rights_Current.Acq_Deal_Rights_Promoter.Where(t => t.EntityState != State.Deleted).ToList();
            lstRightsHoldBack.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Acq_Deal_Rights_Holdback objH = new Acq_Deal_Rights_Holdback();
                    objH.Holdback_Type = t.Holdback_Type;
                    objH.HB_Run_After_Release_No = t.HB_Run_After_Release_No;
                    objH.HB_Run_After_Release_Units = t.HB_Run_After_Release_Units;
                    objH.Holdback_On_Platform_Code = t.Holdback_On_Platform_Code;
                    objH.Holdback_Release_Date = t.Holdback_Release_Date;
                    objH.Holdback_Comment = t.Holdback_Comment;
                    objH.Is_Title_Language_Right = t.Is_Title_Language_Right;
                    objH.EntityState = State.Added;
                    t.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Holdback_Platform objP = new Acq_Deal_Rights_Holdback_Platform();
                            objP.Platform_Code = x.Platform_Code;
                            objP.EntityState = State.Added;
                            objH.Acq_Deal_Rights_Holdback_Platform.Add(objP);
                        }
                    });
                    t.Acq_Deal_Rights_Holdback_Territory.ToList<Acq_Deal_Rights_Holdback_Territory>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Holdback_Territory objTer = new Acq_Deal_Rights_Holdback_Territory();
                            objTer.Territory_Code = x.Territory_Code;
                            objTer.Territory_Type = x.Territory_Type;
                            objTer.Country_Code = x.Country_Code;
                            objTer.EntityState = State.Added;
                            objH.Acq_Deal_Rights_Holdback_Territory.Add(objTer);
                        }
                    });
                    t.Acq_Deal_Rights_Holdback_Subtitling.ToList<Acq_Deal_Rights_Holdback_Subtitling>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Holdback_Subtitling objS = new Acq_Deal_Rights_Holdback_Subtitling();
                            objS.Language_Code = x.Language_Code;
                            objS.EntityState = State.Added;
                            objH.Acq_Deal_Rights_Holdback_Subtitling.Add(objS);
                        }
                    });
                    t.Acq_Deal_Rights_Holdback_Dubbing.ToList<Acq_Deal_Rights_Holdback_Dubbing>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Holdback_Dubbing objD = new Acq_Deal_Rights_Holdback_Dubbing();
                            objD.Language_Code = x.Language_Code;
                            objD.EntityState = State.Added;
                            objH.Acq_Deal_Rights_Holdback_Dubbing.Add(objD);
                        }
                    });
                    objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Add(objH);
                }
            });

            lstRightsBlackOuts.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Acq_Deal_Rights_Blackout objB = new Acq_Deal_Rights_Blackout();
                    objB.Start_Date = t.Start_Date;
                    objB.End_Date = t.End_Date;
                    objB.EntityState = State.Added;
                    t.Acq_Deal_Rights_Blackout_Platform.ToList<Acq_Deal_Rights_Blackout_Platform>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Blackout_Platform objP = new Acq_Deal_Rights_Blackout_Platform();
                            objP.Platform_Code = x.Platform_Code;
                            objP.EntityState = State.Added;
                            objB.Acq_Deal_Rights_Blackout_Platform.Add(objP);
                        }
                    });
                    t.Acq_Deal_Rights_Blackout_Territory.ToList<Acq_Deal_Rights_Blackout_Territory>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Blackout_Territory objTer = new Acq_Deal_Rights_Blackout_Territory();
                            objTer.Territory_Code = x.Territory_Code;
                            objTer.Territory_Type = x.Territory_Type;
                            objTer.Country_Code = x.Country_Code;
                            objTer.EntityState = State.Added;
                            objB.Acq_Deal_Rights_Blackout_Territory.Add(objTer);
                        }
                    });
                    t.Acq_Deal_Rights_Blackout_Subtitling.ToList<Acq_Deal_Rights_Blackout_Subtitling>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Blackout_Subtitling objS = new Acq_Deal_Rights_Blackout_Subtitling();
                            objS.Language_Code = x.Language_Code;
                            objS.EntityState = State.Added;
                            objB.Acq_Deal_Rights_Blackout_Subtitling.Add(objS);
                        }
                    });
                    t.Acq_Deal_Rights_Blackout_Dubbing.ToList<Acq_Deal_Rights_Blackout_Dubbing>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Blackout_Dubbing objD = new Acq_Deal_Rights_Blackout_Dubbing();
                            objD.Language_Code = x.Language_Code;
                            objD.EntityState = State.Added;
                            objB.Acq_Deal_Rights_Blackout_Dubbing.Add(objD);
                        }
                    });
                    objAcq_Deal_Rights.Acq_Deal_Rights_Blackout.Add(objB);
                }
            });



            lstRightsPromoter.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Acq_Deal_Rights_Promoter objP = new Acq_Deal_Rights_Promoter();
                    objP.EntityState = State.Added;
                    t.Acq_Deal_Rights_Promoter_Group.ToList<Acq_Deal_Rights_Promoter_Group>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Promoter_Group objPG = new Acq_Deal_Rights_Promoter_Group();
                            objPG.Promoter_Group_Code = x.Promoter_Group_Code;
                            objPG.EntityState = State.Added;
                            objP.Acq_Deal_Rights_Promoter_Group.Add(objPG);
                        }
                    });
                    t.Acq_Deal_Rights_Promoter_Remarks.ToList<Acq_Deal_Rights_Promoter_Remarks>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Promoter_Remarks objPR = new Acq_Deal_Rights_Promoter_Remarks();
                            objPR.Promoter_Remarks_Code = x.Promoter_Remarks_Code;
                            objPR.EntityState = State.Added;
                            objP.Acq_Deal_Rights_Promoter_Remarks.Add(objPR);
                        }
                    });
                    objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.Add(objP);
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
                objAcq_Deal_Rights.Acq_Deal_Rights_Title.Clear();
                Acq_Deal_Rights_Title objAcq_Deal_Rights_Title = new Acq_Deal_Rights_Title();
                objAcq_Deal_Rights_Title.Title_Code = objPage_Properties.TCODE;
                objAcq_Deal_Rights_Title.Episode_From = EpStart;
                objAcq_Deal_Rights_Title.Episode_To = EpEnd;
                objAcq_Deal_Rights.Acq_Deal_Rights_Title.Add(objAcq_Deal_Rights_Title);
                //objAcq_Deal_Rights_Current.Acq_Deal_Rights_Title.Add(objAcq_Deal_Rights_Title);
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    objPage_Properties.Acquired_Title_Codes = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    objPage_Properties.Acquired_Title_Codes = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(t => t.Title_Code.ToString()).Distinct());
            }

            if (objPage_Properties.PCODE > 0)
            {
                objAcq_Deal_Rights.Acq_Deal_Rights_Platform = objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Where(t => t.Platform_Code == objPage_Properties.PCODE).ToList<Acq_Deal_Rights_Platform>();

                if (objPage_Properties.IsHB.ToUpper() == "YES")
                {
                    objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.ToList<Acq_Deal_Rights_Holdback>().ForEach(t => t.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Acq_Deal_Rights_Holdback_Platform.Remove(x); }));
                    objAcq_Deal_Rights.Acq_Deal_Rights_Blackout.ToList<Acq_Deal_Rights_Blackout>().ForEach(t => t.Acq_Deal_Rights_Blackout_Platform.ToList<Acq_Deal_Rights_Blackout_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Acq_Deal_Rights_Blackout_Platform.Remove(x); }));
                }
                else
                    objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Clear();
            }

            if (objAcq_Deal_Rights.Original_Right_Type == "Y")
            {
                objAcq_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objAcq_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_End_Date).Replace("-", "/");
                string[] arr = objAcq_Deal_Rights.Term.Split('.');
                objAcq_Deal_Rights.Term_YY = arr[0];
                objAcq_Deal_Rights.Term_MM = arr[1];
                if (arr.Length > 2)
                    objAcq_Deal_Rights.Term_DD = arr[2];
                else
                    objAcq_Deal_Rights.Term_DD = "0";
            }
            else if (objAcq_Deal_Rights.Original_Right_Type == "U")
            {
                objAcq_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
                objAcq_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objAcq_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_End_Date).Replace("-", "/");
            }

            if (objAcq_Deal_Rights.ROFR_Date != DateTime.MinValue && objAcq_Deal_Rights.ROFR_Date != null)
            {
                objAcq_Deal_Rights.ROFR_DT = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.ROFR_Date).Replace("-", "/");

                if (objAcq_Deal_Rights.Right_End_Date != DateTime.MinValue && objAcq_Deal_Rights.Right_End_Date != null)
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString((objAcq_Deal_Rights.Right_End_Date.Value - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays);
                else
                    if (objAcq_Deal_Rights.Term_YY != null || objAcq_Deal_Rights.Term_MM != null || objAcq_Deal_Rights.Term_DD != null)
                {
                    DateTime EndDate = CalculateEndDate();
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString(((EndDate - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays) - 1);
                }
                else
                        if (objAcq_Deal_Rights.Right_Type == "M" && objAcq_Deal_Rights.Actual_Right_End_Date != null && objAcq_Deal_Rights.Actual_Right_End_Date != DateTime.MinValue)
                {
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString((objAcq_Deal_Rights.Actual_Right_End_Date.Value - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays);
                }
            }

            SetSelectedCodesToObject();
            objPage_Properties.Acquired_Platform_Codes = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            string strPlatform = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            objAcq_Deal_Rights.Platform_Codes = strPlatform;

            if (objAcq_Deal_Rights.Sub_Type == "L")
                objPage_Properties.Acquired_Subtitling_Codes = objAcq_Deal_Rights.Sub_Codes;
            else
                objPage_Properties.Acquired_Subtitling_Codes = GetLangCodes(objAcq_Deal_Rights.Sub_Codes);

            if (objAcq_Deal_Rights.Dub_Type == "L")
                objPage_Properties.Acquired_Dubbing_Codes = objAcq_Deal_Rights.Dub_Codes;
            else
                objPage_Properties.Acquired_Dubbing_Codes = GetLangCodes(objAcq_Deal_Rights.Dub_Codes);
        }
        private void FillViewFormDetails()
        {
            ViewBag.MODE = "V";
            Acq_Deal_Rights_Service objADRS = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            objAcq_Deal_Rights.Acq_Deal_Rights_Code = objPage_Properties.RCODE;
            objAcq_Deal_Rights = objADRS.GetById(objAcq_Deal_Rights.Acq_Deal_Rights_Code);

            if (objAcq_Deal_Rights.Original_Right_Type == null && objAcq_Deal_Rights.Right_Type == "U")
                objAcq_Deal_Rights.Original_Right_Type = "";
            else if (objAcq_Deal_Rights.Original_Right_Type == null)
                objAcq_Deal_Rights.Original_Right_Type = objAcq_Deal_Rights.Right_Type;
            string selectedTitles = string.Empty;

            if (objPage_Properties.TCODE > 0)
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                {
                    ViewBag.TitleNames = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(t => t.Title.Title_Name + " ( " + t.Episode_From + " - " + t.Episode_To + " ) "));
                    selectedTitles = objDeal_Schema.Title_List.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(s => s.Acq_Deal_Movie_Code).FirstOrDefault().ToString();
                }
                else if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    ViewBag.TitleNames = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(t => t.Title.Title_Name + " ( " + ((t.Episode_From == 0) ? "Unlimited" : t.Episode_From.ToString()) + " ) "));
                    selectedTitles = objDeal_Schema.Title_List.Where(x => x.Title_Code == objPage_Properties.TCODE && x.Episode_From == objPage_Properties.Episode_From && x.Episode_To == objPage_Properties.Episode_To).Select(s => s.Acq_Deal_Movie_Code).FirstOrDefault().ToString();
                }
                else
                {
                    ViewBag.TitleNames = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.Title_Code == objPage_Properties.TCODE).Select(t => t.Title.Title_Name).Distinct());
                    selectedTitles = objPage_Properties.TCODE.ToString();
                }
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                {
                    ViewBag.TitleNames = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(t => t.Title.Title_Name + " ( " + t.Episode_From + " - " + t.Episode_To + " ) "));
                    selectedTitles = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                }
                else if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    ViewBag.TitleNames = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(t => t.Title.Title_Name + " ( " + ((t.Episode_From == 0) ? "Unlimited" : t.Episode_From.ToString()) + " ) "));
                    selectedTitles = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                }
                else
                {
                    ViewBag.TitleNames = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(t => t.Title.Title_Name).Distinct());
                    selectedTitles = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(t => t.Title_Code).Distinct());
                }
            }

            if (objPage_Properties.PCODE > 0)
            {
                objAcq_Deal_Rights.Acq_Deal_Rights_Platform = objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Where(t => t.Platform_Code == objPage_Properties.PCODE).ToList<Acq_Deal_Rights_Platform>();

                if (objPage_Properties.IsHB.ToUpper() == "YES")
                {
                    objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.ToList<Acq_Deal_Rights_Holdback>().ForEach(t => t.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Acq_Deal_Rights_Holdback_Platform.Remove(x); }));
                    objAcq_Deal_Rights.Acq_Deal_Rights_Blackout.ToList<Acq_Deal_Rights_Blackout>().ForEach(t => t.Acq_Deal_Rights_Blackout_Platform.ToList<Acq_Deal_Rights_Blackout_Platform>().ForEach(x => { if (x.Platform_Code != objPage_Properties.PCODE) t.Acq_Deal_Rights_Blackout_Platform.Remove(x); }));
                }
                else
                    objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Clear();
            }

            if (objAcq_Deal_Rights.Original_Right_Type == "Y" || objAcq_Deal_Rights.Original_Right_Type == "U")
            {
                objAcq_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objAcq_Deal_Rights.Right_Start_Date).Replace("-", "/");
                objAcq_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objAcq_Deal_Rights.Right_End_Date).Replace("-", "/");
                if (objAcq_Deal_Rights.Original_Right_Type != "Y")
                {
                    if (objAcq_Deal_Rights.Right_Start_Date != null && objAcq_Deal_Rights.Right_End_Date != null)
                        objAcq_Deal_Rights.Term = calculateTerm((DateTime)objAcq_Deal_Rights.Right_Start_Date, (DateTime)objAcq_Deal_Rights.Right_End_Date);
                }
                string[] arr = objAcq_Deal_Rights.Term.Split('.');
                objAcq_Deal_Rights.Term_YY = arr[0];
                objAcq_Deal_Rights.Term_MM = arr[1];
                if (arr.Length > 2)
                    objAcq_Deal_Rights.Term_DD = arr[2];
                else
                    objAcq_Deal_Rights.Term_DD = "0";

                if (objAcq_Deal_Rights.Original_Right_Type == "U")
                    objAcq_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }
            else if (objAcq_Deal_Rights.Original_Right_Type == "M")
            {
                objAcq_Deal_Rights.Milestone_Start_Date = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
                objAcq_Deal_Rights.Milestone_End_Date = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objAcq_Deal_Rights.Actual_Right_End_Date).Replace("-", "/");
            }
            else if (objAcq_Deal_Rights.Right_Type == "U" && objAcq_Deal_Rights.Original_Right_Type.TrimEnd() == "")
            {
                objAcq_Deal_Rights.Start_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_Start_Date).Replace("-", "/");
                //objAcq_Deal_Rights.End_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Right_End_Date).Replace("-", "/");
                //string[] arr = objAcq_Deal_Rights.Term.Split('.');
                //objAcq_Deal_Rights.Term_YY = arr[0];
                //objAcq_Deal_Rights.Term_MM = arr[1];

                //if (objAcq_Deal_Rights.Original_Right_Type == "U")
                objAcq_Deal_Rights.Perpetuity_Date = string.Format("{0:" + GlobalParams.DateFormat + "}", objAcq_Deal_Rights.Actual_Right_Start_Date).Replace("-", "/");
            }
            if (objAcq_Deal_Rights.ROFR_Date != DateTime.MinValue && objAcq_Deal_Rights.ROFR_Date != null)
            {
                objAcq_Deal_Rights.ROFR_DT = string.Format("{0:" + GlobalParams.DateFormat_Display + "}", objAcq_Deal_Rights.ROFR_Date).Replace("-", "/");
                if (objAcq_Deal_Rights.Right_End_Date != DateTime.MinValue && objAcq_Deal_Rights.Right_End_Date != null)
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString((objAcq_Deal_Rights.Right_End_Date.Value - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays);
                else
                    if (objAcq_Deal_Rights.Term_YY != null || objAcq_Deal_Rights.Term_MM != null || objAcq_Deal_Rights.Term_DD != null)
                {
                    DateTime EndDate = CalculateEndDate();
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString(((EndDate - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays) - 1);
                }
                else
                        if (objAcq_Deal_Rights.Right_Type == "M" && objAcq_Deal_Rights.Actual_Right_End_Date != null && objAcq_Deal_Rights.Actual_Right_End_Date != DateTime.MinValue)
                {
                    objAcq_Deal_Rights.ROFR_Days = Convert.ToString((objAcq_Deal_Rights.Actual_Right_End_Date.Value - objAcq_Deal_Rights.ROFR_Date.Value).TotalDays);
                }
            }

            string selected_Country = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type == "G" ? i.Territory.Territory_Name : i.Country.Country_Name).ToList()));
            ViewBag.selected_Country_Count = objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type == "G" ? i.Territory.Territory_Name : i.Country.Country_Name).ToList().Count();
            string selected_SL = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Name : i.Language.Language_Name).ToList()));
            string selected_DL = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Name : i.Language.Language_Name).ToList())); ;
            ViewBag.selected_SL_Count = (objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Name : i.Language.Language_Name).ToList().Count);
            ViewBag.selected_DL_Count = (objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group.Language_Group_Name : i.Language.Language_Name).ToList().Count);

            ViewBag.selected_Country = selected_Country.Replace(",", ", ");
            ViewBag.selected_SL = selected_SL.Replace(",", ", ");
            ViewBag.selected_DL = selected_DL.Replace(",", ", ");

            selectedTitles = GetTitleLanguageName(selectedTitles);
            ViewBag.TitleLanguageName = (selectedTitles == "" ? "(-)" : "(" + selectedTitles + ")");

            if (objAcq_Deal_Rights.Milestone_Unit_Type != null)
                ViewBag.Milestone_Unit_Type = BindMilestone_Unit_List(objAcq_Deal_Rights.Milestone_Unit_Type.Value);

            objPage_Properties.Acquired_Platform_Codes = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            string strPlatform = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(i => i.Platform_Code).Distinct().ToList()));
            objAcq_Deal_Rights.Platform_Codes = strPlatform;
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
        #endregion

        public string BindMilestone_Unit_List(int selected_Milestone_Unit)
        {
            string Milestone_Unit_Type = string.Empty;
            switch (selected_Milestone_Unit)
            {
                case 1:
                    Milestone_Unit_Type = "Days";
                    break;
                case 2:
                    Milestone_Unit_Type = "Weeks";
                    break;
                case 3:
                    Milestone_Unit_Type = "Months";
                    break;
                case 4:
                    Milestone_Unit_Type = "Years";
                    break;
            }
            return Milestone_Unit_Type;
        }

        #region ---  Bind Dropdowns and page load controls ---

        public PartialViewResult BindPlatformTreeView(string strPlatform, string IsBulk = "N")
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);

            if (objPage_Properties.RMODE != "V" || IsBulk == "Y")
            {
                string referancePlatforms = "";

                if (objPage_Properties.obj_lst_Syn_Rights.Count() > 0 && objPage_Properties.Is_Syn_Acq_Mapp == "Y" && objPage_Properties.RMODE != "C")
                {
                    string[] arr_Selected_PCodes = objPage_Properties.Acquired_Platform_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    objPTV.Reference_From = "S";
                    referancePlatforms += string.Join(",", objPage_Properties.obj_lst_Syn_Rights.SelectMany(sm => sm.Syn_Deal_Rights_Platform).Where(w => (w.Platform_Code == objPage_Properties.PCODE || objPage_Properties.PCODE <= 0) && arr_Selected_PCodes.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                }

                if (objAcq_Deal_Rights.Is_Theatrical_Right == "N")
                    objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                if (referancePlatforms != "" && objPage_Properties.RMODE != "C")
                    objPTV.SynPlatformCodes_Reference = referancePlatforms.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);

                objPTV.HBPlatformCodes_Reference = (from hb in objAcq_Deal_Rights.Acq_Deal_Rights_Holdback
                                                    from hbpm in hb.Acq_Deal_Rights_Holdback_Platform
                                                    where hbpm.EntityState != State.Deleted
                                                    select hbpm.Platform_Code.ToString()).ToArray();


                string Is_Allow_Title_Objection = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName)
                    .SearchFor(x => x.Parameter_Name == "Is_Allow_Title_Objection").FirstOrDefault().Parameter_Value;

                if (Is_Allow_Title_Objection == "Y")
                {
                    int?[] def = objPage_Properties.Acquired_Title_Codes.Split(',').Select(x => (int?)Convert.ToInt32(x)).ToArray();

                    var TOC = new Title_Objection_Service(objLoginEntity.ConnectionStringName)
                        .SearchFor(x => x.Record_Code == objDeal_Schema.Deal_Code && x.Record_Type == "A" && def.Contains(x.Title_Code))
                        .Select(x => x.Title_Objection_Code).ToList();
                    string[] pCode = new Title_Objection_Platform_Service(objLoginEntity.ConnectionStringName)
                        .SearchFor(x => TOC.Contains((int)x.Title_Objection_Code)).Select(x => x.Platform_Code.ToString()).ToArray();
                    objPTV.TOPlatformCodes_Reference = pCode;
                }

                // Check title in run exist or not
                if (objPage_Properties.RMODE != "C")
                {

                    #region------------- Ancillary reference -----------------
                    if (objPage_Properties.RMODE != "A")
                    {
                        //CHECKING THE REFERENCE FOR ANCILLARY IF IS_ANCILLARY_ADVANCE IS ACTIVE
                        string isAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
                        if (isAdvAncillary == "Y" && objAcq_Deal_Rights.Acq_Deal != null)
                        {

                            var PCforAncillaryTitle = (dynamic)null;
                            if (objAcq_Deal_Rights.Acq_Deal.Deal_Type_Code == 11)
                            {
                                string lstTitleCode = "";
                                foreach (var item in objAcq_Deal_Rights.Acq_Deal_Rights_Title)
                                {
                                    lstTitleCode = lstTitleCode + objAcq_Deal_Rights.Acq_Deal.Acq_Deal_Movie.Where(x => x.Title_Code == item.Title_Code
                                                                            && x.Episode_Starts_From == item.Episode_From
                                                                            && x.Episode_End_To == item.Episode_To)
                                                                            .Select(x => x.Acq_Deal_Movie_Code.ToString()).FirstOrDefault() + ",";
                                }

                                lstTitleCode = lstTitleCode.TrimEnd(',');
                                string[] lstTit = lstTitleCode.Split(',');
                                PCforAncillaryTitle = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_PlatformCodes_For_Ancillary(lstTitleCode, "", "PL", objDeal_Schema.Deal_Code, "Y", objAcq_Deal_Rights.Acq_Deal_Rights_Code).FirstOrDefault();
                            }
                            else
                            {
                                string lstTitleCode = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(x => x.Title_Code.ToString()).ToArray());

                                //GET THE LIST OF TITLE CODE
                                string[] lstTit = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(x => x.Title_Code.ToString()).ToArray();

                                //GET THE LIST OF PLATFORM CODE WHICH IS SELECTED AS PER TITLE
                                PCforAncillaryTitle = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_PlatformCodes_For_Ancillary(lstTitleCode, "", "PL", objDeal_Schema.Deal_Code, "Y", objAcq_Deal_Rights.Acq_Deal_Rights_Code).FirstOrDefault();

                            }

                            objPTV.AncPlatformCodes_Reference = PCforAncillaryTitle.Split(',');
                        }
                    }
                    #endregion

                    List<Title_List> lstTitle = (from rightTitle in objAcq_Deal_Rights.Acq_Deal_Rights_Title
                                                 from title in objDeal_Schema.Title_List
                                                 where rightTitle.Title_Code == title.Title_Code && rightTitle.Episode_From == title.Episode_From && rightTitle.Episode_To == title.Episode_To
                                                 select title).ToList();

                    //Code commented in multiline by akshay to show all run defn added noded 
                    /*
                    List<Acq_Deal_Run> lstRun = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName).SearchFor(r => r.Acq_Deal_Code == objDeal_Schema.Deal_Code).ToList();

                    var q = (from run in lstRun
                             from runTitle in run.Acq_Deal_Run_Title
                             where lstTitle.Any(t => t.Title_Code == runTitle.Title_Code && t.Episode_From == runTitle.Episode_From && t.Episode_To == runTitle.Episode_To)
                             select runTitle).Distinct();

                    if (q.Count() > 0)
                    {
                        int[] selectedCodes = Array.ConvertAll(strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries), s => int.Parse(s));
                        int[] platformCodes = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_No_Of_Run == "Y").Select(p => p.Platform_Code).ToArray();
                        //List<Acq_Deal_Rights> lstRights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s =>
                        //    s.Acq_Deal_Code == objAcq_Deal_Rights.Acq_Deal_Code &&
                        //    s.Acq_Deal_Rights_Code != objAcq_Deal_Rights.Acq_Deal_Rights_Code).ToList();

                        //bool disable = (from Acq_Deal_Rights objRight in lstRights
                        //                from Acq_Deal_Rights_Platform objP in objRight.Acq_Deal_Rights_Platform
                        //                where platformCodes.Contains((int)objP.Platform_Code)
                        //                select objRight
                        // ).Any();

                        objPTV.RunPlatformCodes_Reference = platformCodes.Intersect(selectedCodes).ToArray().Select(x => x.ToString()).ToArray();

                    }
                    */
                    List<Acq_Deal_Budget> lstBudget = new Acq_Deal_Budget_Service(objLoginEntity.ConnectionStringName).SearchFor(r => r.Acq_Deal_Code == objDeal_Schema.Deal_Code).ToList();

                    var b = (from budget in lstBudget
                             where lstTitle.Any(t => t.Title_Code == budget.Title_Code && t.Episode_From == budget.Episode_From && t.Episode_To == budget.Episode_To)
                             select budget).Distinct();

                    if (b.Count() > 0)
                        objPTV.BudgetPlatformCodes_Reference = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_No_Of_Run == "Y").Select(p => p.Platform_Code.ToString()).ToArray();
                }
                if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
                {
                    var lstPlatforms = objSyn_Deal_Rights_Buyback.Syn_Deal_Rights_Platform.ToList();
                    string SyndicatedPlatforms = String.Join(",", objSyn_Deal_Rights_Buyback.Syn_Deal_Rights_Platform.Select(x=>x.Platform_Code)).ToString();

                    objPTV.PlatformCodes_Display = SyndicatedPlatforms;//strPlatform;
                }

                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            }
            else
            {
                if (objAcq_Deal_Rights.Is_Theatrical_Right == "N")
                    objPTV.PlatformCodes_Display = strPlatform;

                objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                //if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
                if(!String.IsNullOrEmpty(objAcq_Deal_Rights.Buyback_Syn_Rights_Code))
                {
                    ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y","","Buyback");
                }
                else
                {
                    ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
                }
            }

            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }

        private void SetSelectedCodesToObject()
        {
            string selected_Title_Code = "";

            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(y => y.EntityState != State.Deleted && y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
            else
                selected_Title_Code = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(i => i.EntityState != State.Deleted).Select(t => t.Title_Code.ToString()).Distinct());

            string selected_Country_Code = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type == "G" ? i.Territory_Code : i.Country_Code).ToList()));
            string selected_SL_Code = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group_Code : i.Language_Code).ToList()));
            string selected_DL_Code = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group_Code : i.Language_Code).ToList()));
            int selected_Milestone_Code = (objAcq_Deal_Rights.Milestone_Type_Code == null) ? 0 : objAcq_Deal_Rights.Milestone_Type_Code.Value;
            string Region_Type = "I";

            if (objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Region_Type = objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).ElementAt(0).Territory_Type;

            string Sub_Type = "L";

            if (objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Sub_Type = objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            string Dub_Type = "L";

            if (objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Dub_Type = objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            objAcq_Deal_Rights.Region_Type = Region_Type;
            objAcq_Deal_Rights.Sub_Type = Sub_Type;
            objAcq_Deal_Rights.Dub_Type = Dub_Type;
            objAcq_Deal_Rights.Region_Codes = selected_Country_Code;
            objAcq_Deal_Rights.Sub_Codes = selected_SL_Code;
            objAcq_Deal_Rights.Dub_Codes = selected_DL_Code;
        }

        public JsonResult BindAllPreReq_Async()
        {
            string dataFor = "TIT,CTR,STL,DBL,RFR,MST,MUN,SBL";

            #region --- Data For Region ---
            string Region_Type = "I", isTheatrical = objAcq_Deal_Rights.Is_Theatrical_Right;
            if (objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Region_Type = objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).ElementAt(0).Territory_Type;
            string dataFor_Region = "CTR";
            if (Region_Type == "I")
            {
                if (isTheatrical == "Y")
                    dataFor_Region = "CTT";
            }
            else
            {
                if (isTheatrical == "Y")
                    dataFor_Region = "TRT";
                else
                    dataFor_Region = "TER";
            }
            dataFor = dataFor.Replace("CTR", dataFor_Region);
            #endregion

            #region --- Data For Subtitling ---
            string Sub_Type = "L";
            if (objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Sub_Type = objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            string dataFor_Sub = "STL";
            if (Sub_Type == "G")
                dataFor_Sub = "STG";
            dataFor = dataFor.Replace("STL", dataFor_Sub);
            #endregion

            #region --- Data For Dubbing ---
            string dubType = "L";
            if (objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Count() > 0)
                dubType = objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            string dataFor_Dub = "DBL";
            if (dubType == "G")
                dataFor_Dub = "DBG";
            dataFor = dataFor.Replace("DBL", dataFor_Dub);
            #endregion

            string selected_Title_Code = "";

            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(y => y.EntityState != State.Deleted && y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
            else
                selected_Title_Code = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(i => i.EntityState != State.Deleted).Select(t => t.Title_Code.ToString()).Distinct());

            string Selected_Region_Code = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Select(i => i.Territory_Type == "G" ? i.Territory_Code : i.Country_Code).ToList()));
            string Selected_Subtitling_Code = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group_Code : i.Language_Code).ToList()));
            string Selected_Dubbing_Code = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Select(i => i.Language_Type == "G" ? i.Language_Group_Code : i.Language_Code).ToList()));
            int selected_Milestone_Code = (objAcq_Deal_Rights.Milestone_Type_Code == null) ? 0 : objAcq_Deal_Rights.Milestone_Type_Code.Value;

            objAcq_Deal_Rights.Region_Type = Region_Type;
            objAcq_Deal_Rights.Sub_Type = Sub_Type;
            objAcq_Deal_Rights.Dub_Type = dubType;
            objAcq_Deal_Rights.Region_Codes = Selected_Region_Code;
            objAcq_Deal_Rights.Sub_Codes = Selected_Subtitling_Code;
            objAcq_Deal_Rights.Dub_Codes = Selected_Dubbing_Code;

            List<USP_Get_Acq_PreReq_Result> lst_USP_Get_Acq_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();
            string str_Type = "DR";
            //if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
            //{
            //    string Data_For = "";//, country_Territory_Codes = "0", sub_Lang_Codes = "0", dub_Lang_Codes = "0";                
            //    string Dub_type = "";
            //    if (str_Type == "DR")
            //    {
            //        if (str_Type == "DR")
            //        {
            //            if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_ADD)
            //                Data_For = "TIT,ROR,SBL";
            //            else if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_EDIT || objPage_Properties.RMODE == GlobalParams.DEAL_MODE_CLONE)
            //            {
            //                string platform_Type = (isTheatrical.ToUpper() == "FALSE") ? "PL" : "TPL";
            //                if (objAcq_Deal_Rights.Is_Theatrical_Right == "Y")
            //                    Region_Type = objAcq_Deal_Rights.Region_Type == "G" ? "THT" : "THC";
            //                else
            //                    Region_Type = objAcq_Deal_Rights.Region_Type == "G" ? "T" : "C";
            //                //if (platform_Type == "TPL")
            //                //    GET_DATA_FOR_APPROVED_TITLES(objPage_Properties.Acquired_Title_Codes, "", "TPL", "", "", "");

            //                Data_For = "TIT,ROR,SBL";
            //                Sub_Type = objAcq_Deal_Rights.Sub_Type == "G" ? "SG" : "SL";
            //                Dub_type = objAcq_Deal_Rights.Dub_Type == "G" ? "DG" : "DL";
            //                Data_For = Data_For + "," + Region_Type + "," + Sub_Type + "," + Dub_type;
            //            }

            //            /*
            //       ROR = ROFR(Rights for Refusal)
            //       SBL	= SubLicencing					
            //       SL  = SubTitle Lang.
            //       SG  = SubTitle Lang. Group.
            //       DL  = Dubbing Lang.				  
            //       DG  = Dubbing Group.
            //       T   = Territory
            //       C   = Couuntry
            //       THT = Theatrical Territory
            //       THC = Theatrical Country             
            //    */
            //            //Call From - str_Type - "DR" - Document.Ready,"C" - Change Event                              
            //            //No need to send strType to USP
            //            lst_USP_Get_Acq_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Rights_PreReq(objDeal_Schema.Deal_Code,
            //                                                                                                   objDeal_Schema.Deal_Type_Code,
            //                                                                   Data_For, str_Type, objAcq_Deal_Rights.Region_Codes, objAcq_Deal_Rights.Sub_Codes, objAcq_Deal_Rights.Dub_Codes).ToList();

            //        }
            //    }
            //}

            // New Logic for buyback Region, SL , DL on Page load
            List<USP_Get_Acq_PreReq_Result> Obj_USP_Result_RGN = new List<USP_Get_Acq_PreReq_Result>();
            List<USP_Get_Acq_PreReq_Result> Obj_USP_Result_SL = new List<USP_Get_Acq_PreReq_Result>();
            List<USP_Get_Acq_PreReq_Result> Obj_USP_Result_DL = new List<USP_Get_Acq_PreReq_Result>();
            if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
            {
                // I - Country // G -Territory // SL -Sub Lang // SG - Sub Lang Group // DL -Dub Lang // DG - Dubb Lang Group

                //, country_Territory_Codes = "0", sub_Lang_Codes = "0", dub_Lang_Codes = "0";                
                //string Sub_Type = ""; string Dub_type = "";
                string PlatformCodes = String.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Select(x => x.Platform_Code).ToList());
                {
                    if (Region_Type == "I")
                        Region_Type = (isTheatrical == "N") ? "C" : "THC";
                    else
                        Region_Type = (isTheatrical == "N") ? "T" : "THT";

                    string str_Type_RGN = objAcq_Deal_Rights.Region_Type;
                    string str_Type_SL = Sub_Type;
                    string str_Type_DL = dubType;

                    string Data_For_RGN = "";
                    string Data_For_SL = "";
                    string Data_For_DL = "";

                    str_Type_SL = str_Type_SL == "L" ? "SL" : str_Type_SL;
                    str_Type_DL = str_Type_DL == "L" ? "DL" : str_Type_DL;

                    str_Type_SL = str_Type_SL == "G" ? "SG" : str_Type_SL;
                    str_Type_DL = str_Type_DL == "G" ? "DG" : str_Type_DL;

                    string Sub_Type_SL = str_Type_SL;
                    string Sub_Type_DL = str_Type_DL;

                    //Data_For = str_Type;
                    if (str_Type_RGN == "I" || str_Type_RGN == "T" || str_Type_RGN == "G")
                    {
                        Data_For_RGN = Region_Type;

                        GET_DATA_FOR_APPROVED_TITLES(selected_Title_Code, PlatformCodes, "", Region_Type, Sub_Type_SL, Sub_Type_DL);
                        Obj_USP_Result_RGN = Get_USP_Get_Acq_PreReq_Result(Data_For_RGN, str_Type_RGN);

                    }

                    if (str_Type_SL == "SL" || str_Type_SL == "SG" || str_Type_SL == "L")
                    {    
                        Data_For_SL = str_Type_SL;

                        GET_DATA_FOR_APPROVED_TITLES(selected_Title_Code, PlatformCodes, "", Region_Type, Sub_Type_SL, Sub_Type_DL);
                        Obj_USP_Result_SL = Get_USP_Get_Acq_PreReq_Result(Data_For_SL, str_Type_SL);
                    }

                    if (str_Type_DL == "DL" || str_Type_DL == "DG")
                    {
                        Data_For_DL = str_Type_DL;

                        GET_DATA_FOR_APPROVED_TITLES(selected_Title_Code, PlatformCodes, "", Region_Type, Sub_Type_SL, Sub_Type_DL);
                        Obj_USP_Result_DL = Get_USP_Get_Acq_PreReq_Result(Data_For_DL, str_Type_DL);
                    }

                    //if (Data_For != "")
                    //{
                    //    GET_DATA_FOR_APPROVED_TITLES(selected_Title_Code, PlatformCodes, "", Region_Type, Sub_Type, dubType);
                    //    Obj_USP_Result = Get_USP_Get_Acq_PreReq_Result(Data_For, str_Type);
                    //}
                }
            }



            List<USP_Get_Acq_PreReq_Result> lstUSP_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Rights_PreReq(objDeal_Schema.Deal_Code, dataFor, objDeal_Schema.Deal_Type_Code, objPage_Properties.Is_Syn_Acq_Mapp).ToList();
            var subList = new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == "SBL"), "Display_Value", "Display_Text").ToList();
            //subList.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Title_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == "TIT"), "Display_Value", "Display_Text").ToList());
            obj.Add("Selected_Title_Code", selected_Title_Code);
            if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
            {
                obj.Add("Region_List", new SelectList(Obj_USP_Result_RGN.Where(x => x.Data_For == "RGN"), "Display_Value", "Display_Text").ToList());
            }
            else
            {
                obj.Add("Region_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == dataFor_Region), "Display_Value", "Display_Text").ToList());
            }

            obj.Add("Selected_Region_Code", Selected_Region_Code);
            obj.Add("Sub_License_List", subList);
            if (objAcq_Deal_Rights.Acq_Deal_Code == 0)
                obj.Add("Sub_License_Code", 0);
            else if (objAcq_Deal_Rights.Sub_License_Code == null)
                obj.Add("Sub_License_Code", -1);
            else
                obj.Add("Sub_License_Code", objAcq_Deal_Rights.Sub_License_Code);
            obj.Add("Milestone_Type_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == "MST"), "Display_Value", "Display_Text").ToList());
            obj.Add("Milestone_Type_Code", (objAcq_Deal_Rights.Milestone_Type_Code ?? 0));
            obj.Add("Milestone_Unit_Type_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == "MUN"), "Display_Value", "Display_Text").ToList());
            obj.Add("Milestone_Unit_Type", (objAcq_Deal_Rights.Milestone_Unit_Type ?? 0));
            obj.Add("ROFR_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == "RFR"), "Display_Value", "Display_Text").ToList());
            obj.Add("ROFR_Code", (objAcq_Deal_Rights.ROFR_Code ?? 0));
            if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
            {
                obj.Add("Subtitle_List", new SelectList(Obj_USP_Result_SL.Where(x => x.Data_For == "SL"), "Display_Value", "Display_Text").ToList());
            }
            else
            {
                obj.Add("Subtitle_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == dataFor_Sub), "Display_Value", "Display_Text").ToList());
            }

            obj.Add("Selected_Subtitling_Code", Selected_Subtitling_Code);
            if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
            {
                obj.Add("Dubbing_List", new SelectList(Obj_USP_Result_DL.Where(x => x.Data_For == "DL"), "Display_Value", "Display_Text").ToList());
            }
            else
            {
                obj.Add("Dubbing_List", new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == dataFor_Dub), "Display_Value", "Display_Text").ToList());
            }

            obj.Add("Selected_Dubbing_Code", Selected_Dubbing_Code);
            return Json(obj);
        }

        private MultiSelectList BindCountry(string Is_Theatrical_Right, string Selected_Country_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindCountry_List(Is_Theatrical_Right, Selected_Country_Code);
        }

        private MultiSelectList BindTerritory(string Is_Theatrical_Right, string Selected_Territory_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTerritory_List(Is_Theatrical_Right, Selected_Territory_Code);
        }

        private MultiSelectList BindLanguage(string Selected_Language_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindLanguage_List(Selected_Language_Code);
        }

        private MultiSelectList BindLanguage_Group(string Selected_Language_Group_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindLanguage_Group_List(Selected_Language_Group_Code);
        }

        private void SetVisibility()
        {
            System_Parameter_New_Service objSPNS = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            objPage_Properties.Is_ROFR_Type_Visible = objSPNS.SearchFor(p => p.Parameter_Name == "Is_ROFR_Type_Visible").ToList().ElementAt(0).Parameter_Value;
            objAcq_Deal_Rights.Theatrical_Platform_Code = objSPNS.SearchFor(p => p.Parameter_Name == "THEATRICAL_PLATFORM_CODE").ToList().ElementAt(0).Parameter_Value;
        }

        #endregion

        #region ============== ASYNC & JSON CALLS ==============

        public JsonResult Bind_JSON_ListBox(string str_Type, string Is_Thetrical, string titleCodes, string platformCodes, string Region_Type, string rdbSubtitlingLanguage, string rdbDubbingLanguage)
        {
            // I - Country // G -Territory // SL -Sub Lang // SG - Sub Lang Group // DL -Dub Lang // DG - Dubb Lang Group

            //List<USP_Get_Acq_PreReq_Result> lst_USP_Get_Acq_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();
            ////string str_Type = "";
            //string Data_For = "";
            //if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
            //{
            //    if (str_Type == "I")
            //        str_Type = (Is_Thetrical == "N") ? "C" : "THC";
            //    else
            //        str_Type = (Is_Thetrical == "N") ? "T" : "THT";

            //    Data_For = str_Type;
            //    if (str_Type == "I" || str_Type == "T" || str_Type == "G")
            //    {
            //        Data_For = str_Type;
            //    }
            //    else if (str_Type == "SL" || str_Type == "DL" || str_Type == "SG" || str_Type == "DG")
            //    {
            //        Data_For = str_Type;
            //    }
            //    //else if (str_Type == "A")
            //    //{
            //    //    Sub_Type = (rdbSubtitlingLanguage == "G" || rdbSubtitlingLanguage == "SG") ? "SG" : "SL";
            //    //    Dub_type = (rdbDubbingLanguage == "G" || rdbDubbingLanguage == "DG") ? "DG" : "DL";
            //    //    Data_For = Data_For + "," + Region_Type + "," + Sub_Type + "," + Dub_type;
            //    //}
            //    if (Data_For != "")
            //    {
            //        lst_USP_Get_Acq_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Rights_PreReq(objDeal_Schema.Deal_Code,
            //                                                                                                   objDeal_Schema.Deal_Type_Code,
            //                                                                   Data_For, str_Type, objAcq_Deal_Rights.Region_Codes, objAcq_Deal_Rights.Sub_Codes, objAcq_Deal_Rights.Dub_Codes).ToList();


            //    }
            //}

            //new functionality start
            List<USP_Get_Acq_PreReq_Result> Obj_USP_Result = new List<USP_Get_Acq_PreReq_Result>();
            if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
            {
                // I - Country // G -Territory // SL -Sub Lang // SG - Sub Lang Group // DL -Dub Lang // DG - Dubb Lang Group

                string Data_For = "";//, country_Territory_Codes = "0", sub_Lang_Codes = "0", dub_Lang_Codes = "0";                
                string Sub_Type = ""; string Dub_type = "";
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
            }


            //end


            if (str_Type == "I")
            {
                if (objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted).Count() == 0)
                {
                    if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
                    {
                        var arr = new MultiSelectList(Obj_USP_Result.Select(i => new { Territory_Code = i.Display_Value, Territory_Name = i.Display_Text }).OrderBy(x => x.Territory_Name).ToList(), "Territory_Code", "Territory_Name");
                        return Json(arr, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        var arr = BindCountry(Is_Thetrical);
                        return Json(arr, JsonRequestBehavior.AllowGet);
                    }


                }
                else
                    return Json("Holdback is already added.");
            }
            else if (str_Type == "T" || str_Type == "G")
            {
                if (objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted).Count() == 0)
                {
                    if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
                    {
                        var arr = new MultiSelectList(Obj_USP_Result.Select(i => new { Territory_Code = i.Display_Value, Territory_Name = i.Display_Text }).OrderBy(x => x.Territory_Name).ToList(), "Territory_Code", "Territory_Name");
                        return Json(arr, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        var arr = BindTerritory(Is_Thetrical);
                        return Json(arr, JsonRequestBehavior.AllowGet);
                    }

                }
                else
                    return Json("Holdback is already added.");
            }
            else if (str_Type == "SL" || str_Type == "DL")
            {
                if (str_Type == "SL")
                {
                    if (objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.EntityState != State.Deleted).SelectMany(i => i.Acq_Deal_Rights_Holdback_Subtitling).Where(w => w.Language_Code > 0 && w.EntityState != State.Deleted).Select(AS => AS.Language_Code).Count() > 0)
                        return Json("Holdback is already added.");
                }
                else
                    if (str_Type == "DL")
                {
                    if (objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.EntityState != State.Deleted).SelectMany(i => i.Acq_Deal_Rights_Holdback_Dubbing).Where(w => w.Language_Code > 0 && w.EntityState != State.Deleted).Select(AS => AS.Language_Code).Count() > 0)
                        return Json("Holdback is already added.");
                }

                if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
                {
                    var arr = new MultiSelectList(Obj_USP_Result.Select(i => new { Language_Code = i.Display_Value, Language_Name = i.Display_Text }).OrderBy(x => x.Language_Name).ToList(), "Language_Code", "Language_Name");
                    return Json(arr, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    var arr = BindLanguage();
                    return Json(arr, JsonRequestBehavior.AllowGet);
                }
            }
            else if (str_Type == "SG" || str_Type == "DG")
            {
                if (str_Type == "SG")
                {
                    if (objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.EntityState != State.Deleted).SelectMany(i => i.Acq_Deal_Rights_Holdback_Subtitling).Where(w => w.Language_Code > 0 && w.EntityState != State.Deleted).Select(AS => AS.Language_Code).Count() > 0)
                        return Json("Holdback is already added.");
                }
                else
                    if (str_Type == "DG")
                {
                    if (objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.EntityState != State.Deleted).SelectMany(i => i.Acq_Deal_Rights_Holdback_Dubbing).Where(w => w.Language_Code > 0 && w.EntityState != State.Deleted).Select(AS => AS.Language_Code).Count() > 0)
                        return Json("Holdback is already added.");
                }

                if (Convert.ToBoolean(Session["Is_Buyback"]) == true)
                {
                    var arr = new MultiSelectList(Obj_USP_Result.Select(i => new { Language_Group_Code = i.Display_Value, Language_Group_Name = i.Display_Text }).OrderBy(x => x.Language_Group_Name).ToList(), "Language_Group_Code", "Language_Group_Name");
                    return Json(arr, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    var arr = BindLanguage_Group();
                    return Json(arr, JsonRequestBehavior.AllowGet);
                }

            }
            return Json("", JsonRequestBehavior.AllowGet);
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
                    selectedTitles = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Movie_Code == objDeal_Schema.Master_Deal_Movie_Code).Select(s => s.Title_Code.ToString()).FirstOrDefault();

                string languageName = (new USP_Service(objLoginEntity.ConnectionStringName)).USP_Get_Title_Language(selectedTitles).FirstOrDefault();

                if (string.IsNullOrEmpty(languageName))
                    return "-";

                return languageName;
            }
        }

        public JsonResult GetPerpetuity_Logic_Date(int?[] titleCodes, string perpetuityDate, string callFromValidate = "N")
        {
            string Result = "";
            if (perpetuityDate != "")
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    for (int i = 0; i < titleCodes.Length; i++)
                    {
                        int AMDCode = (int)titleCodes.ElementAt(i);
                        var TCode = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)
                            .SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code && x.Acq_Deal_Movie_Code == AMDCode)
                            .Select(y => y.Title_Code).FirstOrDefault();
                        titleCodes.SetValue(TCode, i);
                    }
                }
                if (callFromValidate == "Y")
                {
                    var lstTitleCode = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(x => titleCodes.Contains(x.Title_Code)).Select(x => x.Title_Code).Distinct().ToList();
                    var TitleCodeNo_Release_Date = titleCodes.Except(lstTitleCode);
                    Result = String.Join(", ", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => TitleCodeNo_Release_Date.Contains(x.Title_Code)).Select(x => x.Title_Name).ToList());
                }
                else
                {
                    List<Title_Perpetuity_Date> lstTPD = Calculate_Perpetuity_Logic(titleCodes, perpetuityDate);
                    if (titleCodes.Count() == 1 && lstTPD.Count > 0)
                    {
                        Result = lstTPD.Where(x => x.TitleCode == titleCodes.ElementAt(0)).Select(x => x.Perpetuity_Date).FirstOrDefault().ToString("dd/MM/yyyy");
                    }
                }
            }
            return Json(Result, JsonRequestBehavior.AllowGet);
        }

        public List<Title_Perpetuity_Date> Calculate_Perpetuity_Logic(int?[] titleCodes, string perpetuityDate)
        {
            var Term_Perputity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").Select(x => x.Parameter_Value).FirstOrDefault();
            var lstTit_Perpetuity_Date = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(x => titleCodes.Contains(x.Title_Code)).ToList()
                    .GroupBy(p => p.Title_Code, (key, g) => new { TitleCode = key, Min_Release_Date = (DateTime)g.Select(x => x.Release_Date).Min() });


            List<Title_Perpetuity_Date> lstTPD = new List<Title_Perpetuity_Date>();
            foreach (var item in lstTit_Perpetuity_Date)
            {
                Title_Perpetuity_Date obj = new Title_Perpetuity_Date();
                obj.TitleCode = item.TitleCode;
                obj.Release_Date = item.Min_Release_Date;
                int year = item.Min_Release_Date.Year;
                DateTime firstDay = new DateTime(year + 1, 1, 1);
                obj.Perpetuity_Date = firstDay.AddYears(Convert.ToInt32(Term_Perputity)).AddDays(-1);
                lstTPD.Add(obj);
            }
            return lstTPD;
        }

        public JsonResult Validate_Groups(string Region_Codes, string Dubbing_Codes, string Subtitling_Codes)
        {
            List<string> lst_ErrorMsg = new List<string>();
            lst_ErrorMsg.AddRange(new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Rights_Duplication_Country_Lang(Region_Codes, Subtitling_Codes, Dubbing_Codes, "SR"));

            if (lst_ErrorMsg.Count() > 0)
                return Json(lst_ErrorMsg[0].ToString(), JsonRequestBehavior.AllowGet);

            return Json("", JsonRequestBehavior.AllowGet);
        }

        public string Validate_Acq_Rights_After_Syndication(string Tit_Codes, string Reg_Type, string Reg_Codes, string Sub_Type,
            string Sub_Codes, string Dub_Type, string Dub_Codes, string Right_Start_Date, string Right_End_Date)
        {

            string message = "";
            if (objPage_Properties.RCODE == 0)
                return message;

            if (objPage_Properties.obj_lst_Syn_Rights.Count() > 0 && objPage_Properties.Is_Syn_Acq_Mapp == "Y")
            {
                int Count = 0;
                Syn_Acq_Mapping_Service objSAMS = new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName);
                var Min_Max_Date = objSAMS.SearchFor(i => i.Deal_Rights_Code == objPage_Properties.RCODE).Where(j => j.Right_Start_Date != null).Select(i => new { Right_Start_Date = i.Right_Start_Date, Right_End_Date = i.Right_End_Date });
                DateTime Min_R_SDate = Convert.ToDateTime(Min_Max_Date.Select(i => i.Right_Start_Date).Min());

                if (Right_Start_Date != "")
                {
                    int result = DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(Right_Start_Date)), Min_R_SDate);
                    if (result <= 0)
                    {
                        if (Right_End_Date != "" && Right_End_Date != null)
                        {
                            DateTime Max_R_EDate = Convert.ToDateTime(Min_Max_Date.Where(i => i.Right_End_Date != null).Select(i => i.Right_End_Date).Max());
                            result = DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(Right_End_Date)), Max_R_EDate);
                            if (result < 0)
                            {
                                message = "Can not reduce rights period as it is already syndicated";
                                return message;
                            }
                        }
                    }
                    else
                    {
                        message = "Can not reduce rights period as it is already syndicated";
                        return message;
                    }
                }

                if (!string.IsNullOrEmpty(objPage_Properties.SyndicatedTitlesCode))
                {
                    Count = GetExceptValues(Tit_Codes, objPage_Properties.SyndicatedTitlesCode);
                    if (Count > 0)
                    {
                        message = "Can not remove title as it is already syndicated";
                        return message;
                    }
                }

                string Syn_Country_Code = "";
                List<string> lst_Syn_Country_Code = new List<string>();
                lst_Syn_Country_Code.AddRange(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Mapping_Countries(objPage_Properties.RCODE));

                if (lst_Syn_Country_Code.Count() > 0)
                    Syn_Country_Code = lst_Syn_Country_Code[0].ToString();

                if (Syn_Country_Code != "")
                {
                    if (Reg_Type == "I")
                        Count = GetExceptValues(Reg_Codes, Syn_Country_Code.Trim(','));
                    else
                    {
                        string[] territory_Codes = Reg_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        string Selected_Country_Codes = string.Join(",", new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(i => territory_Codes.Contains(i.Territory_Code.ToString()))
                                                            .SelectMany(j => j.Territory_Details
                                                                            .Where(TD => territory_Codes.Contains(TD.Territory_Code.ToString()))
                                                                            .Select(TD => TD.Country_Code)
                                                                            .Distinct()
                                                                        ).Distinct().ToArray()
                                                                   );
                        Count = GetExceptValues(Selected_Country_Codes, Syn_Country_Code.Trim(','));
                    }
                    if (Count > 0)
                    {
                        message = "Can not remove region as it is already syndicated";
                        return message;
                    }
                }
                string[] arr_Acq_Edit_Subtitling_Lang_Code = objPage_Properties.Acquired_Subtitling_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                string Syn_Rights_Code = string.Join(",", objPage_Properties.obj_lst_Syn_Rights.Select(i => i.Syn_Deal_Rights_Code).Distinct().ToArray());
                List<USP_Get_Mapping_SubTitling_Dubbing_Languages_Result> lst_mapp = (new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Mapping_SubTitling_Dubbing_Languages(Syn_Rights_Code, objPage_Properties.Acquired_Subtitling_Codes, objPage_Properties.Acquired_Dubbing_Codes)).ToList<USP_Get_Mapping_SubTitling_Dubbing_Languages_Result>();
                string Syn_Sub_Lang_Code = "";
                string Syn_Dub_Lang_Code = "";

                if (lst_mapp != null && lst_mapp.Count() > 0)
                    foreach (USP_Get_Mapping_SubTitling_Dubbing_Languages_Result obj in lst_mapp)
                    {
                        Syn_Sub_Lang_Code = lst_mapp[0].Mapped_SubTitling_Language_Codes == null ? "" : lst_mapp[0].Mapped_SubTitling_Language_Codes;
                        Syn_Dub_Lang_Code = lst_mapp[0].Mapped_Dubbing_Language_Codes == null ? "" : lst_mapp[0].Mapped_Dubbing_Language_Codes;
                    }

                if (Syn_Sub_Lang_Code != "")
                    if (Sub_Type == "L")
                        Count = GetExceptValues(Sub_Codes, Syn_Sub_Lang_Code);
                    else
                    {
                        string Selected_Sub_Lang_Codes = "";
                        if (Sub_Codes != "")
                            Selected_Sub_Lang_Codes = GetLangCodes(Sub_Codes);
                        Count = GetExceptValues(Selected_Sub_Lang_Codes, Syn_Sub_Lang_Code);
                    }

                if (Count > 0)
                {
                    message = "Can not remove subtitling as it is already syndicated";
                    return message;
                }

                string[] arr_Acq_Edit_Dubb_Lang_Code = objPage_Properties.Acquired_Dubbing_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                if (Syn_Dub_Lang_Code != "")
                    if (Dub_Type == "L")
                        Count = GetExceptValues(Dub_Codes, Syn_Dub_Lang_Code);
                    else
                    {
                        string Selected_Dubb_Lang_Codes = "";
                        if (Dub_Codes != "")
                            Selected_Dubb_Lang_Codes = GetLangCodes(Dub_Codes);
                        Count = GetExceptValues(Selected_Dubb_Lang_Codes, Syn_Dub_Lang_Code);
                    }

                if (Count > 0)
                {
                    message = "Can not remove dubbing as it is already syndicated";
                    return message;
                }
            }
            List<USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode_Result> objScheduleDates = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode(objPage_Properties.RCODE).ToList();
            if (objScheduleDates.Count > 0)
            {
                if (objScheduleDates[0].Start_Date != null && objScheduleDates[0].End_Date != null)
                {
                    DateTime Min_R_SDate = objScheduleDates[0].Start_Date.Value;
                    if (Right_Start_Date != "")
                    {
                        int result = DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(Right_Start_Date)), Min_R_SDate);
                        if (result <= 0)
                        {
                            if (Right_End_Date != "" && Right_End_Date != null)
                            {
                                DateTime Max_R_EDate = objScheduleDates[0].End_Date.Value;
                                result = DateTime.Compare(Convert.ToDateTime(GlobalUtil.MakedateFormat(Right_End_Date)), Max_R_EDate);
                                if (result < 0)
                                {
                                    message = "Can not reduce rights period as run Scheduled for selected title";
                                    return message;
                                }
                            }
                        }
                        else
                        {
                            message = "Can not reduce rights period as run Scheduled for selected title";
                            return message;
                        }
                    }
                }
            }
            return message;
        }

        public string Validate_Acq_Right_Title_Platform(string hdnPlatform, string hdnMMovies, string Right_Type, string Is_Tentative, string Start_Date,
            string End_Date, string milestoneNoOfUnit, string milestoneUnitType)
        {
            string Message = "";
            if (objPage_Properties.RMODE != GlobalParams.DEAL_MODE_CLONE)
            {
                Platform_Service objPservice = new Platform_Service(objLoginEntity.ConnectionStringName);
                List<string> lstPlatformCode = objPservice.SearchFor(p => p.Is_No_Of_Run == "Y").Select(p => p.Platform_Code.ToString()).ToList();
                Acq_Deal_Service objDealService = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal objDeal = objDealService.GetById(objDeal_Schema.Deal_Code);
                List<Title_List> lstDealMovie = new List<Title_List>();
                int platformcount = (from s in lstPlatformCode
                                     where hdnPlatform.Split(',').ToArray().Contains(s)
                                     select s).Count();

                if (platformcount > 0)
                {
                    List<int> lstTitlecode = (from objRun in objDeal.Acq_Deal_Run
                                              from objRunTitle in objRun.Acq_Deal_Run_Title
                                              where objRun.Acq_Deal_Code == objDeal_Schema.Deal_Code && objRun.Is_Yearwise_Definition == "Y"
                                              && objRun.Run_Type != "U"
                                              select objRunTitle.Title_Code.Value).ToList();

                    int count = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();

                    List<int> arrTitleCode = new List<int>();

                    lstDealMovie = objDeal.Acq_Deal_Movie.Where(m => hdnMMovies.Split(',').Contains(
                        (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program ||
                        objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music) ? m.Acq_Deal_Movie_Code.ToString() : m.Title_Code.ToString())
                    ).Select(m => new Title_List
                    {
                        Title_Code = m.Title_Code.Value,
                        Episode_From = m.Episode_Starts_From.Value,
                        Episode_To = m.Episode_End_To.Value,
                        Acq_Deal_Movie_Code = m.Acq_Deal_Movie_Code
                    }).ToList();

                    string[] str1 = new string[2] { "S", "D" };
                    if (objDeal_Schema.Rights_View == "G" || (objDeal_Schema.Deal_Type_Condition.ToUpper() != "DEAL_MOVIE" && str1.Contains(objDeal_Schema.Rights_View)))
                    {
                        var h = (from run in objDeal.Acq_Deal_Run
                                 from runtitle in run.Acq_Deal_Run_Title
                                 where !lstDealMovie.Any(m => m.Title_Code == runtitle.Title_Code && m.Episode_From == runtitle.Episode_From && m.Episode_To == runtitle.Episode_To)
                                 select runtitle).ToList();

                        if (h.Count() > 0)
                        {
                            var r = from rights in objDeal.Acq_Deal_Rights
                                    from rightsTitle in rights.Acq_Deal_Rights_Title
                                    where (rights.Acq_Deal_Rights_Code != objAcq_Deal_Rights.Acq_Deal_Rights_Code || (
                                    objPage_Properties.TCODE > 0 && lstDealMovie.Where(l => l.Title_Code == objPage_Properties.TCODE &&
                                        (l.Episode_From == objPage_Properties.Episode_From || objPage_Properties.Episode_From == 0) &&
                                        (l.Episode_To == objPage_Properties.Episode_From || objPage_Properties.Episode_To == 0)).Count() > 0
                                    )) &&
                                     h.Any(t => t.Title_Code == rightsTitle.Title_Code && t.Episode_From == rightsTitle.Episode_From && t.Episode_To == rightsTitle.Episode_To) &&
                                    rights.Acq_Deal_Rights_Platform.Any(p => p.Platform.Is_No_Of_Run == "Y")
                                    select rightsTitle;

                            if (r.Count() == 0)
                                return "Can not change rights title as Run Definition is already added. To change rights period, delete Run Definition first.";
                        }
                    }
                    else
                    {
                        var q = (from run in objDeal.Acq_Deal_Run
                                 from runtitle in run.Acq_Deal_Run_Title
                                 where lstDealMovie.Any(m => m.Title_Code == runtitle.Title_Code && m.Episode_From == runtitle.Episode_From && m.Episode_To == runtitle.Episode_To)
                                 select runtitle).ToList();

                        #region added by akshay

                        List<Acq_Deal_Rights_Title> RemovedTitle_List = new List<Acq_Deal_Rights_Title>();
                        List<Title_List> AddTitle_List = new List<Title_List>();

                        foreach (Title_List objTL in lstDealMovie)
                        {
                            if (q.Where(x => x.Episode_From == objTL.Episode_From && x.Episode_To == objTL.Episode_To && x.Title_Code == objTL.Title_Code).Count() == 0)
                                AddTitle_List.Add(objTL);
                        }

                        if (lstDealMovie.Count() < objAcq_Deal_Rights.Acq_Deal_Rights_Title.Count())
                        {
                            foreach (Acq_Deal_Rights_Title objTL in objAcq_Deal_Rights.Acq_Deal_Rights_Title)
                            {

                                if (q.Where(x => x.Episode_From == objTL.Episode_From && x.Episode_To == objTL.Episode_To && x.Title_Code == objTL.Title_Code).Count() == 0)
                                    RemovedTitle_List.Add(objTL);
                            }
                        }
                        #endregion added by akshay

                        if (q.Count() > 0)
                        {
                            var r = from rights in objDeal.Acq_Deal_Rights
                                    from rightsTitle in rights.Acq_Deal_Rights_Title
                                    where (rights.Acq_Deal_Rights_Code != objAcq_Deal_Rights.Acq_Deal_Rights_Code || (
                                    objPage_Properties.TCODE > 0 && lstDealMovie.Where(l => l.Title_Code == objPage_Properties.TCODE &&
                                        (l.Episode_From == objPage_Properties.Episode_From || objPage_Properties.Episode_From == 0) &&
                                        (l.Episode_To == objPage_Properties.Episode_From || objPage_Properties.Episode_To == 0)).Count() > 0
                                    )) &&
                                    q.Any(t => t.Title_Code == rightsTitle.Title_Code && t.Episode_From == rightsTitle.Episode_From && t.Episode_To == rightsTitle.Episode_To) &&
                                    rights.Acq_Deal_Rights_Platform.Any(p => p.Platform.Is_No_Of_Run == "Y")
                                    select rightsTitle;

                            if (r.Count() == 0 && AddTitle_List.Count == 0 && RemovedTitle_List.Count() == 0)
                                return "Can not change rights title as Run Definition is already added. To change rights period, delete Run Definition first.";
                        }
                    }
                    List<Acq_Deal_Budget> lstBudget = (from objBudget in objDeal.Acq_Deal_Budget
                                                       where objBudget.Acq_Deal_Code == objDeal_Schema.Deal_Code && !lstDealMovie.Any(m => m.Title_Code == objBudget.Title_Code && m.Episode_From == objBudget.Episode_From && m.Episode_To == objBudget.Episode_To)
                                                       select objBudget).ToList();
                    if (lstBudget.Count > 0)
                    {
                        var r = from rights in objDeal.Acq_Deal_Rights
                                from rightsTitle in rights.Acq_Deal_Rights_Title
                                where rights.Acq_Deal_Rights_Code != objAcq_Deal_Rights.Acq_Deal_Rights_Code &&
                                lstBudget.Any(t => t.Title_Code == rightsTitle.Title_Code && t.Episode_From == rightsTitle.Episode_From && t.Episode_To == rightsTitle.Episode_To) &&
                                rights.Acq_Deal_Rights_Platform.Any(p => p.Platform.Is_No_Of_Run == "Y")
                                select rightsTitle;

                        if (r.Count() == 0)
                            return "Can not change rights title as Budget is already added. To change rights period, delete Budget first.";
                    }
                    if (Right_Type == objAcq_Deal_Rights.Right_Type)
                    {
                        int Count_Acq_Deal_Run_Code = (from run in objDeal.Acq_Deal_Run
                                                       from runtitle in run.Acq_Deal_Run_Title
                                                       where run.Run_Type != "U" && lstDealMovie.Any(m => m.Title_Code == runtitle.Title_Code && m.Episode_From == runtitle.Episode_From && m.Episode_To == runtitle.Episode_To)
                                                       select runtitle.Acq_Deal_Run_Code ?? 0).FirstOrDefault();

                        if (objAcq_Deal_Rights.Right_Type == "Y")
                        {
                            bool isTentative = (objAcq_Deal_Rights.Is_Tentative == "Y") ? true : false;
                            if (count > 0 && isTentative != Convert.ToBoolean(Is_Tentative))
                                return "Can not change Tentative state as Run Definition is already added. To change rights period, delete Run Definition first.";

                            try
                            {
                                if (count > 0 && (objAcq_Deal_Rights.Right_Start_Date != Convert.ToDateTime(GlobalUtil.MakedateFormat(Start_Date)) || objAcq_Deal_Rights.Right_End_Date != Convert.ToDateTime(GlobalUtil.MakedateFormat(End_Date))))
                                {
                                    if (Count_Acq_Deal_Run_Code > 0)
                                        return "Can not change rights period as Run Definition is already added. To change rights period, delete Run Definition first.";
                                }
                            }
                            catch (Exception) { }
                        }
                        else if (objAcq_Deal_Rights.Right_Type == "M")
                        {
                            if (!string.IsNullOrEmpty(objAcq_Deal_Rights.Milestone_Start_Date) && !string.IsNullOrEmpty(objAcq_Deal_Rights.Milestone_End_Date))
                            {
                                if (count > 0 && (Convert.ToDateTime(GlobalUtil.MakedateFormat(objAcq_Deal_Rights.Milestone_Start_Date)) != Convert.ToDateTime(GlobalUtil.MakedateFormat(Start_Date))
                                    || Convert.ToDateTime(GlobalUtil.MakedateFormat(objAcq_Deal_Rights.Milestone_End_Date)) != Convert.ToDateTime(GlobalUtil.MakedateFormat(End_Date))))
                                    return "Can not change Milestone term/type as Run Definition is already added. To change Milestone term/type, delete Run Definition first.";
                            }
                            else
                            {
                                if (count > 0 && (objAcq_Deal_Rights.Milestone_No_Of_Unit != Convert.ToInt32(milestoneNoOfUnit) || Convert.ToInt32(milestoneUnitType) != 4))
                                    return "Can not change Milestone term/type as Run Definition is already added. To change Milestone term/type, delete Run Definition first.";
                            }

                        }
                    }

                    else
                    {
                        if (count > 0)
                            return "Can not change rights period type as Run Definition is already added. To change rights period, delete Run Definition first.";
                    }
                }
                else
                {
                    List<int> lstTitlecodeWithoutYearWise = (from objRun in objDeal.Acq_Deal_Run
                                                             from objRunTitle in objRun.Acq_Deal_Run_Title
                                                             where objRun.Acq_Deal_Code == objDeal_Schema.Deal_Code
                                                             select objRunTitle.Title_Code.Value).ToList();

                    int count = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(t => lstTitlecodeWithoutYearWise.Contains(t.Title_Code.Value)).Count();

                    //List<int> lstTitleCodeOfCurrentRight = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(t => t.Title_Code.Value).ToList();
                    var lstTitleCodeOfCurrentRight = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(t => new { t.Title_Code, t.Episode_From, t.Episode_To }).ToList();
                    List<Current_Deal_Right1> lstDealRights = new List<Current_Deal_Right1>();
                    foreach (var item in lstTitleCodeOfCurrentRight)
                    {
                        Current_Deal_Right1 obj = new Current_Deal_Right1();
                        obj.EpsFrom = item.Episode_From;
                        obj.EpsTo = item.Episode_To;
                        obj.TitleCode = item.Title_Code;
                        lstDealRights.Add(obj);
                    }


                    bool IsCableExistInOtherRightWithSameTitle = false;
                    if (objPage_Properties.PCODE > 0)
                    {
                        IsCableExistInOtherRightWithSameTitle = objDeal.Acq_Deal_Rights.Where(w => w.Acq_Deal_Rights_Code == objAcq_Deal_Rights.Acq_Deal_Rights_Code).
                            SelectMany(s => s.Acq_Deal_Rights_Platform).Any(w => w.Platform_Code != objPage_Properties.PCODE && w.Platform.Is_No_Of_Run == "Y");
                    }
                    if (!IsCableExistInOtherRightWithSameTitle)
                    {
                        IsCableExistInOtherRightWithSameTitle = objDeal.Acq_Deal_Rights.Any(r =>
                             r.Acq_Deal_Rights_Code != objAcq_Deal_Rights.Acq_Deal_Rights_Code &&
                             r.Acq_Deal_Rights_Title.Any(t => lstDealRights.Where(l => l.TitleCode == t.Title_Code && l.EpsFrom == t.Episode_From && l.EpsTo == t.Episode_To).Count() > 0)
                             && r.Acq_Deal_Rights_Platform.Any(p => lstPlatformCode.Contains(p.Platform_Code.ToString()))
                             );
                    }
                    if (count > 0 && !IsCableExistInOtherRightWithSameTitle)
                        return "Please select at least 1 cable right as Run Definition is already added. To deselect cable rights, delete Run Definition first.";
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

            return PartialView("_Acq_Validation_Popup", lstDuplicates);
        }

        public ActionResult ChangeTabFromView(string hdnTabName = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }

        public JsonResult CheckHBRegionWithRightsRegion(string region_type, string region_Code)
        {
            List<int> lstRegionNotExist = new List<int>();
            List<int> countryList = new List<int>();
            List<int> territoryList;
            List<int> filterTerritory = null;

            foreach (Acq_Deal_Rights_Holdback objHB in objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(h => h.EntityState != State.Deleted))
            {
                countryList.AddRange(objHB.Acq_Deal_Rights_Holdback_Territory.Where(s => s.EntityState != State.Deleted).Select(t => t.Country_Code.Value));
            }

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
            foreach (Acq_Deal_Rights_Holdback objHB in objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(h => h.EntityState != State.Deleted))
            {
                languageList.AddRange(objHB.Acq_Deal_Rights_Holdback_Subtitling.Where(s => s.EntityState != State.Deleted).Select(t => t.Language_Code.Value));
            }
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
            foreach (Acq_Deal_Rights_Holdback objHB in objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(h => h.EntityState != State.Deleted))
            {
                languageList.AddRange(objHB.Acq_Deal_Rights_Holdback_Dubbing.Where(s => s.EntityState != State.Deleted).Select(t => t.Language_Code.Value));
            }
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

        public JsonResult ChkRightsDuplication(int acqDealCode)
        {
            string Message = "VALID";
            var acq_deal_obj = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == acqDealCode).FirstOrDefault();
            var objParameter_Value = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Own_Production").Select(x => x.Parameter_Value).SingleOrDefault();
            string[] ErrorChk = { "W", "E", "P" };
            List<Acq_Deal_Rights> ObjRightsNew = new List<Acq_Deal_Rights>();
            ObjRightsNew = acq_deal_obj.Acq_Deal_Rights.ToList();

            bool ChkDealStatus = ObjRightsNew.Any(w => ErrorChk.Contains(w.Right_Status));
            if (ChkDealStatus)
            {
                Message = "Err";
            }

            if (acq_deal_obj.Role_Code == Convert.ToInt32(objParameter_Value))
            {
                foreach (Acq_Deal_Rights objRights in acq_deal_obj.Acq_Deal_Rights)
                {
                    #region -----Fill UDT FOR RIGHTS DUPLICATION VALIDATION --------------
                    Deal_Rights_UDT objDRUDT = new Deal_Rights_UDT();

                    objDRUDT.Title_Code = 0;
                    objDRUDT.Platform_Code = 0;
                    objDRUDT.Deal_Rights_Code = objRights.Acq_Deal_Rights_Code;
                    objDRUDT.Deal_Code = objRights.Acq_Deal_Code;
                    objDRUDT.Is_Exclusive = objRights.Is_Exclusive;

                    objDRUDT.Is_Theatrical_Right = objRights.Is_Theatrical_Right;
                    objDRUDT.Is_Title_Language_Right = objRights.Is_Title_Language_Right;
                    objDRUDT.Sub_License_Code = objRights.Sub_License_Code;
                    objDRUDT.Is_Sub_License = objRights.Is_Sub_License;
                    objDRUDT.Right_Type = objRights.Right_Type;
                    objDRUDT.Term = objRights.Term;
                    objDRUDT.Milestone_Type_Code = objRights.Milestone_Type_Code;
                    objDRUDT.Milestone_No_Of_Unit = objRights.Milestone_No_Of_Unit;
                    objDRUDT.Milestone_Unit_Type = objRights.Milestone_Unit_Type;
                    objDRUDT.Is_Tentative = objRights.Is_Tentative;
                    objDRUDT.Right_Start_Date = objRights.Right_Start_Date;
                    objDRUDT.Right_End_Date = objRights.Right_End_Date;
                    objDRUDT.Is_ROFR = objRights.Is_ROFR;
                    objDRUDT.ROFR_Date = objRights.ROFR_Date;
                    objDRUDT.Restriction_Remarks = objRights.Restriction_Remarks;
                    objDRUDT.Buyback_Syn_Rights_Code = objRights.Buyback_Syn_Rights_Code;

                    objRights.LstDeal_Rights_UDT = new List<Deal_Rights_UDT>();
                    objRights.LstDeal_Rights_UDT.Add(objDRUDT);

                    objRights.LstDeal_Rights_Title_UDT.Clear();
                    foreach (Acq_Deal_Rights_Title objTitle in objRights.Acq_Deal_Rights_Title)
                    {
                        if (objTitle.EntityState != State.Deleted)
                        {
                            Deal_Rights_Title_UDT objDeal_Rights_Title_UDT = new Deal_Rights_Title_UDT();
                            objDeal_Rights_Title_UDT.Deal_Rights_Code = (objTitle.Acq_Deal_Rights_Code == null) ? 0 : objTitle.Acq_Deal_Rights_Code;
                            objDeal_Rights_Title_UDT.Title_Code = (objTitle.Title_Code == null) ? 0 : objTitle.Title_Code;
                            objDeal_Rights_Title_UDT.Episode_From = objTitle.Episode_From;
                            objDeal_Rights_Title_UDT.Episode_To = objTitle.Episode_To;
                            objRights.LstDeal_Rights_Title_UDT.Add(objDeal_Rights_Title_UDT);
                        }
                    }

                    objRights.LstDeal_Rights_Platform_UDT = new List<Deal_Rights_Platform_UDT>(
                                    objRights.Acq_Deal_Rights_Platform.Where(t => t.EntityState != State.Deleted).Select(x =>
                                    new Deal_Rights_Platform_UDT
                                    {
                                        Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                        Platform_Code = (x.Platform_Code == null) ? 0 : x.Platform_Code
                                    }));

                    objRights.LstDeal_Rights_Territory_UDT = new List<Deal_Rights_Territory_UDT>(
                                    objRights.Acq_Deal_Rights_Territory.Where(t => t.EntityState != State.Deleted).Select(x =>
                                    new Deal_Rights_Territory_UDT
                                    {
                                        Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                        Territory_Code = (x.Territory_Code == null) ? 0 : x.Territory_Code,
                                        Country_Code = (x.Country_Code == null) ? 0 : x.Country_Code,
                                        Territory_Type = (x.Territory_Type == null) ? "I" : x.Territory_Type
                                    }));

                    objRights.LstDeal_Rights_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>(
                                    objRights.Acq_Deal_Rights_Subtitling.Where(t => t.EntityState != State.Deleted).Select(x =>
                                    new Deal_Rights_Subtitling_UDT
                                    {
                                        Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                        Subtitling_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                        Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                        Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                                    }));

                    objRights.LstDeal_Rights_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>(
                                    objRights.Acq_Deal_Rights_Dubbing.Where(t => t.EntityState != State.Deleted).Select(x =>
                                    new Deal_Rights_Dubbing_UDT
                                    {
                                        Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                        Dubbing_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                        Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                        Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                                    }));
                    #endregion

                    USP_Service objValidateService = new USP_Service(objLoginEntity.ConnectionStringName);
                    dynamic resultSet = "";
                    IEnumerable<USP_Validate_Rights_Duplication_UDT> objResult = objValidateService.USP_Validate_Rights_Duplication_UDT(
                       objRights.LstDeal_Rights_UDT,
                       objRights.LstDeal_Rights_Title_UDT,
                       objRights.LstDeal_Rights_Platform_UDT,
                       objRights.LstDeal_Rights_Territory_UDT,
                       objRights.LstDeal_Rights_Subtitling_UDT,
                       objRights.LstDeal_Rights_Dubbing_UDT
                       , "AR");

                    resultSet = objResult;
                    lstDupRecords.Clear();
                    lstDupRecords = resultSet;
                    if (lstDupRecords.Count > 0)
                    {
                        Message = "DUPLICATE";
                        break;
                    }
                }
            }

            return Json(Message);
        }

        //, string hdnTitle_Code, string hdnTVCodes, string Rights_Period, string Term_YY, string Term_MM, string Perpetuity_Date
        public string Save_Rights(Acq_Deal_Rights objRights, FormCollection form)
        {
            if (TempData["QueryString_Rights"] != null)
                TempData["QueryString_Rights"] = null;
            objRights.Buyback_Syn_Rights_Code = form["hdnBuyback_Syn_Rights_Code"];
            string message = string.Empty;
            var Is_Valid = SaveDealRight(objRights, form);
            string strPlatform = string.Join(",", (objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Where(p => p.EntityState != State.Deleted).Select(i => i.Platform_Code).Distinct().ToList()));
            objAcq_Deal_Rights.Platform_Codes = strPlatform;
            SetSelectedCodesToObject();
            ViewBag.ShowPopup = "";
            ViewBag.Message = "";
            ViewBag.MessageFrom = "SV";
            ViewBag.MODE = "E";
            string tabName = form["hdnTabName"];
            


            if (!Is_Valid)
                message = "ERROR";
            else
            {
                string Is_Acq_rights_delay_validation = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName)
                   .SearchFor(x => x.Parameter_Name == "Is_Acq_rights_delay_validation")
                   .FirstOrDefault().Parameter_Value;

                if (Is_Acq_rights_delay_validation != "Y")
                {
                    #region Check Linear Rights
                    Acq_Deal_Service objService = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                    Acq_Deal objAcq_Deal = objService.GetById(objDeal_Schema.Deal_Code);
                    string DealCompleteFlag = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Deal_Complete_Flag").Select(x => x.Parameter_Value).FirstOrDefault();
                    List<USP_List_Acq_Linear_Title_Status_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName)
                                                                      .USP_List_Acq_Linear_Title_Status(objDeal_Schema.Deal_Code).ToList();

                    int RunPending = DealCompleteFlag.Replace(" ", "") == "R,R" || DealCompleteFlag.Replace(" ", "") == "R,R,C" ? lst.Where(x => x.Title_Added == "Yes~").Count() : 0;
                    int RightsPending = lst.Where(x => x.Title_Added == "No").Count();

                    if (RunPending > 0 && RightsPending > 0)
                        objAcq_Deal.Deal_Workflow_Status = "RR";
                    else if (RunPending > 0 && RightsPending == 0)
                        objAcq_Deal.Deal_Workflow_Status = "RP";
                    else
                        objAcq_Deal.Deal_Workflow_Status = "N";

                    objAcq_Deal.EntityState = State.Modified;
                    dynamic resultSet;
                    bool isValid = objService.Save(objAcq_Deal, out resultSet);
                    #endregion
                }
                if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_EDIT)
                    message = "Right updated successfully";
                else
                    message = "Right saved successfully";
            }

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            else
                ViewBag.Record_Locking_Code = 0;

            return message;
        }

        private bool SaveDealRight(Acq_Deal_Rights objRights, FormCollection form)
        {
            // Material_Medium
            bool IsValid = true;
            //if (obj_lst_Syn_Rights.Count() > 0 && Is_Syn_Acq_Mapp == "Y")
            //    IsValid = Validate_Acq_Rights(objRights, form);

            if (IsValid)
            {
                bool IsSameAsGroup = false;

                if (objPage_Properties.TCODE > 0 || objPage_Properties.PCODE > 0)
                {
                    Acq_Deal objDeal = new Acq_Deal();
                    Acq_Deal_Service objADS = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                    objDeal = objADS.GetById(objAcq_Deal_Rights.Acq_Deal_Code);
                    Acq_Deal_Rights objExistingRight = objDeal.Acq_Deal_Rights.Where(t => t.Acq_Deal_Rights_Code == objPage_Properties.RCODE).FirstOrDefault();

                    if (objExistingRight.Acq_Deal_Rights_Title.Count == 1 && objPage_Properties.TCODE > 0 && objExistingRight.Acq_Deal_Rights_Platform.Count == 1 && objPage_Properties.PCODE > 0)
                        IsSameAsGroup = true;
                    else if (objExistingRight.Acq_Deal_Rights_Title.Count == 1 && objPage_Properties.TCODE > 0 && objPage_Properties.PCODE == 0)
                        IsSameAsGroup = true;
                    else
                    {
                        //This is the new object to be save
                        Acq_Deal_Rights objFirstRight = new Acq_Deal_Rights();
                        objFirstRight.Actual_Right_Start_Date = objExistingRight.Actual_Right_Start_Date;
                        objFirstRight.Actual_Right_End_Date = objExistingRight.Actual_Right_End_Date;
                        objDeal.Acq_Deal_Rights.Add(objFirstRight);

                        #region =========== Assign Platform and Holdback to Second Object ===========
                        objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.ToList<Acq_Deal_Rights_Holdback>().ForEach(t =>
                        {
                            if (t.EntityState != State.Deleted)
                            {
                                Acq_Deal_Rights_Holdback objH = new Acq_Deal_Rights_Holdback();
                                objH.Holdback_Type = t.Holdback_Type;
                                objH.HB_Run_After_Release_No = t.HB_Run_After_Release_No;
                                objH.HB_Run_After_Release_Units = t.HB_Run_After_Release_Units;
                                objH.Holdback_On_Platform_Code = t.Holdback_On_Platform_Code;
                                objH.Holdback_Release_Date = t.Holdback_Release_Date;
                                objH.Holdback_Comment = t.Holdback_Comment;
                                objH.Is_Title_Language_Right = t.Is_Title_Language_Right;
                                objH.EntityState = State.Added;
                                t.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Holdback_Platform objP = new Acq_Deal_Rights_Holdback_Platform();
                                        objP.Platform_Code = x.Platform_Code;
                                        objP.EntityState = State.Added;
                                        objH.Acq_Deal_Rights_Holdback_Platform.Add(objP);
                                    }
                                });
                                t.Acq_Deal_Rights_Holdback_Territory.ToList<Acq_Deal_Rights_Holdback_Territory>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Holdback_Territory objTer = new Acq_Deal_Rights_Holdback_Territory();
                                        objTer.Territory_Code = x.Territory_Code;
                                        objTer.Territory_Type = x.Territory_Type;
                                        objTer.Country_Code = x.Country_Code;
                                        objTer.EntityState = State.Added;
                                        objH.Acq_Deal_Rights_Holdback_Territory.Add(objTer);
                                    }
                                });
                                t.Acq_Deal_Rights_Holdback_Subtitling.ToList<Acq_Deal_Rights_Holdback_Subtitling>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Holdback_Subtitling objS = new Acq_Deal_Rights_Holdback_Subtitling();
                                        objS.Language_Code = x.Language_Code;
                                        objS.EntityState = State.Added;
                                        objH.Acq_Deal_Rights_Holdback_Subtitling.Add(objS);
                                    }
                                });
                                t.Acq_Deal_Rights_Holdback_Dubbing.ToList<Acq_Deal_Rights_Holdback_Dubbing>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Holdback_Dubbing objD = new Acq_Deal_Rights_Holdback_Dubbing();
                                        objD.Language_Code = x.Language_Code;
                                        objD.EntityState = State.Added;
                                        objH.Acq_Deal_Rights_Holdback_Dubbing.Add(objD);
                                    }
                                });
                                objFirstRight.Acq_Deal_Rights_Holdback.Add(objH);
                            }
                        });
                        objAcq_Deal_Rights.Acq_Deal_Rights_Blackout.ToList<Acq_Deal_Rights_Blackout>().ForEach(t =>
                        {
                            if (t.EntityState != State.Deleted)
                            {
                                Acq_Deal_Rights_Blackout objB = new Acq_Deal_Rights_Blackout();
                                objB.Start_Date = t.Start_Date;
                                objB.End_Date = t.End_Date;
                                objB.EntityState = State.Added;
                                t.Acq_Deal_Rights_Blackout_Platform.ToList<Acq_Deal_Rights_Blackout_Platform>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Blackout_Platform objP = new Acq_Deal_Rights_Blackout_Platform();
                                        objP.Platform_Code = x.Platform_Code;
                                        objP.EntityState = State.Added;
                                        objB.Acq_Deal_Rights_Blackout_Platform.Add(objP);
                                    }
                                });
                                t.Acq_Deal_Rights_Blackout_Territory.ToList<Acq_Deal_Rights_Blackout_Territory>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Blackout_Territory objTer = new Acq_Deal_Rights_Blackout_Territory();
                                        objTer.Territory_Code = x.Territory_Code;
                                        objTer.Territory_Type = x.Territory_Type;
                                        objTer.Country_Code = x.Country_Code;
                                        objTer.EntityState = State.Added;
                                        objB.Acq_Deal_Rights_Blackout_Territory.Add(objTer);
                                    }
                                });
                                t.Acq_Deal_Rights_Blackout_Subtitling.ToList<Acq_Deal_Rights_Blackout_Subtitling>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Blackout_Subtitling objS = new Acq_Deal_Rights_Blackout_Subtitling();
                                        objS.Language_Code = x.Language_Code;
                                        objS.EntityState = State.Added;
                                        objB.Acq_Deal_Rights_Blackout_Subtitling.Add(objS);
                                    }
                                });
                                t.Acq_Deal_Rights_Blackout_Dubbing.ToList<Acq_Deal_Rights_Blackout_Dubbing>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Blackout_Dubbing objD = new Acq_Deal_Rights_Blackout_Dubbing();
                                        objD.Language_Code = x.Language_Code;
                                        objD.EntityState = State.Added;
                                        objB.Acq_Deal_Rights_Blackout_Dubbing.Add(objD);
                                    }
                                });
                                objFirstRight.Acq_Deal_Rights_Blackout.Add(objB);
                            }
                        });

                        objAcq_Deal_Rights.Acq_Deal_Rights_Promoter.ToList<Acq_Deal_Rights_Promoter>().ForEach(t =>
                        {
                            if (t.EntityState != State.Deleted)
                            {
                                Acq_Deal_Rights_Promoter objPromoter = new Acq_Deal_Rights_Promoter();
                                objPromoter.EntityState = State.Added;
                                t.Acq_Deal_Rights_Promoter_Group.ToList<Acq_Deal_Rights_Promoter_Group>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Promoter_Group objG = new Acq_Deal_Rights_Promoter_Group();
                                        objG.Promoter_Group_Code = x.Promoter_Group_Code;
                                        objG.EntityState = State.Added;
                                        objPromoter.Acq_Deal_Rights_Promoter_Group.Add(objG);
                                    }
                                });
                                t.Acq_Deal_Rights_Promoter_Remarks.ToList<Acq_Deal_Rights_Promoter_Remarks>().ForEach(x =>
                                {
                                    if (x.EntityState != State.Deleted)
                                    {
                                        Acq_Deal_Rights_Promoter_Remarks objR = new Acq_Deal_Rights_Promoter_Remarks();
                                        objR.Promoter_Remarks_Code = x.Promoter_Remarks_Code;
                                        objR.EntityState = State.Added;
                                        objPromoter.Acq_Deal_Rights_Promoter_Remarks.Add(objR);
                                    }
                                });

                                objFirstRight.Acq_Deal_Rights_Promoter.Add(objPromoter);
                            }
                        });

                        Lst_Acq_Deal_Rights_Promoter = new List<Acq_Deal_Rights_Promoter>();
                        foreach (Acq_Deal_Rights_Promoter objADPR in objAcq_Deal_Rights.Acq_Deal_Rights_Promoter)
                        {
                            Lst_Acq_Deal_Rights_Promoter.Add(objADPR);
                        }
                        #endregion

                        objFirstRight = CreateRightObject(objFirstRight, objRights, form);
                        objFirstRight.EntityState = State.Added;
                        objExistingRight.EntityState = State.Modified;
                        bool isMovieDelete = true;
                        if (objExistingRight.Acq_Deal_Rights_Title.Count > 1)
                            objExistingRight.Acq_Deal_Rights_Title.Where(t => t.Title_Code == objPage_Properties.TCODE && t.Episode_From == objPage_Properties.Episode_From && t.Episode_To == objPage_Properties.Episode_To).ToList<Acq_Deal_Rights_Title>().ForEach(x => { x.EntityState = State.Deleted; });
                        else
                            isMovieDelete = false;

                        if (objPage_Properties.PCODE > 0)
                        {
                            if (!isMovieDelete)
                            {
                                objExistingRight.Acq_Deal_Rights_Platform.ToList<Acq_Deal_Rights_Platform>().ForEach(t => { if (t.Platform_Code == objPage_Properties.PCODE) t.EntityState = State.Deleted; });
                                // Set Delet for Holdback platform
                                objExistingRight.Acq_Deal_Rights_Holdback.ToList<Acq_Deal_Rights_Holdback>().ForEach(t =>
                                {
                                    t.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(p =>
                                    {
                                        if (p.Platform_Code == objPage_Properties.PCODE) p.EntityState = State.Deleted;
                                    });

                                });
                            }
                            else if (objExistingRight.Acq_Deal_Rights_Platform.Count > 1)
                            {
                                Acq_Deal_Rights objSecondRight = SetNewAcqDealRight(objExistingRight, objPage_Properties.TCODE, objPage_Properties.Episode_From, objPage_Properties.Episode_To, objPage_Properties.PCODE);
                                objDeal.Acq_Deal_Rights.Add(objSecondRight);
                            }
                        }
                        objDeal.SaveGeneralOnly = false;
                        objDeal.EntityState = State.Modified;

                        dynamic resultSet;
                        objADS.Save(objDeal, out resultSet);

                        UpdateDealRightProcess(objAcq_Deal_Rights.Acq_Deal_Rights_Code);

                        if (objPage_Properties.obj_lst_Syn_Rights.Count() > 0)
                        {
                            string str_Affected_Acq_Rights_Code = string.Join(",", objDeal.Acq_Deal_Rights.Where(i => i.EntityState == State.Added || i.EntityState == State.Modified).Select(s => s.Acq_Deal_Rights_Code).Distinct().ToArray());
                            string str_Syn_Rights_Code = string.Join(",", objPage_Properties.obj_lst_Syn_Rights.Select(i => i.Syn_Deal_Rights_Code).Distinct().ToArray());
                            new USP_Service(objLoginEntity.ConnectionStringName).USP_Update_Syn_Acq_Mapping(objDeal.Acq_Deal_Code, str_Affected_Acq_Rights_Code, str_Syn_Rights_Code);
                        }
                        return ShowValidationPopup(resultSet);
                    }
                }
                else
                    IsSameAsGroup = true;

                int Count = 0;
                if (IsSameAsGroup)
                {
                    Lst_Acq_Deal_Rights_Holdback = null;
                    Lst_Acq_Deal_Rights_Holdback = new List<Acq_Deal_Rights_Holdback>();
                    foreach (Acq_Deal_Rights_Holdback objADRHB in objAcq_Deal_Rights.Acq_Deal_Rights_Holdback)
                    {
                        //string acqDealMovieCode = form["hdnTitle_Code"];
                        //string[] ADMCode = acqDealMovieCode.Split(',');
                        //string[] title_Code = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => ADMCode.Contains(x.Acq_Deal_Movie_Code.ToString())).Select(y => y.Title.Title_Code.ToString()).ToArray();
                        //string tempcode = "";
                        //if (title_Code.Count() == 1)
                        //{
                        //    tempcode = title_Code.ElementAt(0);
                        //}
                        //else if (title_Code.Count() > 1)
                        //{
                        //    for (int i = 0; i < title_Code.Count(); i++)
                        //    {
                        //        tempcode = title_Code.ElementAt(i);
                        //        int titleCode = Convert.ToInt32(tempcode);
                        //        //tempcode = tempcode.Remove(tempcode.Length - 1);
                        //        Count = new USP_Service().USP_Acq_Deal_Rights_Holdback_Validation(objADRHB.Acq_Deal_Rights_Holdback_Code.ToString(), objADRHB.strPlatformCodes, objADRHB.strCountryCodes, tempcode).FirstOrDefault().Rec_Count;
                        //        if (Count > 0)
                        //        {
                        //            Acq_Deal_Rights_Holdback_Validation objADRHV = new Acq_Deal_Rights_Holdback_Validation();
                        //            objADRHV.Title_Name = new Title_Service().SearchFor(x => x.Title_Code == titleCode).Select(x => x.Title_Name).FirstOrDefault();
                        //            string[] platforCode = objADRHB.strPlatformCodes.Split(',');
                        //            string[] platforms = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => platforCode.Contains(x.Platform_Code.ToString())).Select(x => x.Platform_Name).ToArray();
                        //            objADRHV.Platform =  string.Join("", platforms);
                        //            string[] countryCode = objADRHB.strCountryCodes.Split(',');
                        //            string[] countrys = new Country_Service().SearchFor(x => countryCode.Contains(x.Country_Code.ToString())).Select(x => x.Country_Name).ToArray();
                        //            objADRHV.Region = string.Join("", countrys);
                        //            lstADRHV.Add(objADRHV);
                        //         }
                        //    }
                        //}

                        //if (Count == 0)
                        Lst_Acq_Deal_Rights_Holdback.Add(objADRHB);
                    }
                    //if (lstADRHV.Count > 0)
                    //    showHoldbackValidationPopup(lstADRHV);

                    Lst_Acq_Deal_Rights_Blackout = null;
                    Lst_Acq_Deal_Rights_Blackout = new List<Acq_Deal_Rights_Blackout>();
                    foreach (Acq_Deal_Rights_Blackout objADRHB in objAcq_Deal_Rights.Acq_Deal_Rights_Blackout)
                    {
                        Lst_Acq_Deal_Rights_Blackout.Add(objADRHB);
                    }

                    Lst_Acq_Deal_Rights_Promoter = null;
                    Lst_Acq_Deal_Rights_Promoter = new List<Acq_Deal_Rights_Promoter>();
                    foreach (Acq_Deal_Rights_Promoter objADPR in objAcq_Deal_Rights.Acq_Deal_Rights_Promoter)
                    {
                        Lst_Acq_Deal_Rights_Promoter.Add(objADPR);
                    }

                    Acq_Deal_Rights_Service objADRS = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
                    if (objAcq_Deal_Rights.Acq_Deal_Rights_Code > 0)
                    {
                        objAcq_Deal_Rights = objADRS.GetById(objAcq_Deal_Rights.Acq_Deal_Rights_Code);
                        objAcq_Deal_Rights.EntityState = State.Modified;
                        objAcq_Deal_Rights.Is_Verified = "Y";
                    }
                    else
                    {
                        objAcq_Deal_Rights.Acq_Deal_Code = objDeal_Schema.Deal_Code;
                        objAcq_Deal_Rights.EntityState = State.Added;
                    }
                    objAcq_Deal_Rights.Promoter_Flag = Convert.ToString(form["hdnPromoter"]);

                    objRights.Restriction_Remarks = objRights.Restriction_Remarks != null ? objRights.Restriction_Remarks.Replace("\r\n", "\n") : "";


                    objAcq_Deal_Rights = CreateRightObject(objAcq_Deal_Rights, objRights, form);
                    dynamic resultSet;

                    string Is_Allow_Perpetual_Date_Logic = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Allow_Perpetual_Date_Logic").FirstOrDefault().Parameter_Value;
                    List<Title_Perpetuity_Date> lstTPD = new List<Title_Perpetuity_Date>();
                    if (Is_Allow_Perpetual_Date_Logic == "Y" && objAcq_Deal_Rights.Right_Type == "U")
                    {
                        var titleCodes = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(x => x.Title_Code).ToList();
                        var lstTitleCode = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(x => titleCodes.Contains(x.Title_Code)).Select(x => x.Title_Code).Distinct().ToList();
                        var TitleCodeNo_Release_Date = titleCodes.Except(lstTitleCode);

                        foreach (var item in TitleCodeNo_Release_Date)
                        {
                            Acq_Deal_Rights_Title obj = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Where(x => x.Title_Code == item).FirstOrDefault();
                            Deal_Rights_Title_UDT objUdt = objAcq_Deal_Rights.LstDeal_Rights_Title_UDT.Where(x => x.Title_Code == item).FirstOrDefault();
                            objAcq_Deal_Rights.Acq_Deal_Rights_Title.Remove(obj);
                            objAcq_Deal_Rights.LstDeal_Rights_Title_UDT.Remove(objUdt);
                        }

                        if (objAcq_Deal_Rights.Acq_Deal_Rights_Title.Count == 0)
                            return false;

                        lstTPD = Calculate_Perpetuity_Logic(lstTitleCode.ToArray(), ((DateTime)objAcq_Deal_Rights.Actual_Right_Start_Date).ToString("dd/MM/yyyy")).ToList();

                        //else if (objAcq_Deal_Rights.Acq_Deal_Rights_Title.Count == 1)
                        //{
                        //    Title_Perpetuity_Date  obj = Calculate_Perpetuity_Logic(lstTitleCode.ToArray(), ((DateTime)objAcq_Deal_Rights.Actual_Right_Start_Date).ToString("dd/MM/yyyy")).FirstOrDefault();
                        //    objAcq_Deal_Rights.Actual_Right_End_Date = obj.Perpetuity_Date;
                        //}

                    }
                    objAcq_Deal_Rights.Buyback_Syn_Rights_Code = objRights.Buyback_Syn_Rights_Code;

                    objADRS.Save(objAcq_Deal_Rights, out resultSet);
                    int res = 0;
                    if (resultSet.Count != 0)
                    {
                        res = resultSet.Count;
                    }
                    //int res = resultSet.Count;
                    if (Is_Allow_Perpetual_Date_Logic == "Y" && objAcq_Deal_Rights.Right_Type == "U" && res == 0)
                    {
                        Acq_Deal_Rights_Perpetuity_Service ADRPS = new Acq_Deal_Rights_Perpetuity_Service(objLoginEntity.ConnectionStringName);
                        dynamic resultSetADRP;
                        for (int i = 0; i < objAcq_Deal_Rights.Acq_Deal_Rights_Title.Count; i++)
                        {
                            var NewAcq_Deal_Rights_Code = (dynamic)null;
                            if (i > 0)
                            {

                                int? TCode = objAcq_Deal_Rights.Acq_Deal_Rights_Title.ElementAt(i).Title_Code;
                                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                                {
                                    int ADRTCode = objAcq_Deal_Rights.Acq_Deal_Rights_Title.ElementAt(i).Acq_Deal_Rights_Title_Code;
                                    NewAcq_Deal_Rights_Code = new USP_Service(objLoginEntity.ConnectionStringName)
                                   .USP_Acq_Deal_Right_Clone(objAcq_Deal_Rights.Acq_Deal_Code, objAcq_Deal_Rights.Acq_Deal_Rights_Code, ADRTCode, TCode, "Y").FirstOrDefault();
                                }
                                else
                                {
                                    NewAcq_Deal_Rights_Code = new USP_Service(objLoginEntity.ConnectionStringName)
                                    .USP_Acq_Deal_Right_Clone(objAcq_Deal_Rights.Acq_Deal_Code, objAcq_Deal_Rights.Acq_Deal_Rights_Code, 0, TCode, "N").FirstOrDefault();
                                }

                                Deal_Rights_Process_Service DRPService = new Deal_Rights_Process_Service(objLoginEntity.ConnectionStringName);
                                Deal_Rights_Process DRP = new Deal_Rights_Process();
                                DRP.Deal_Code = objAcq_Deal_Rights.Acq_Deal_Code;
                                DRP.Deal_Rights_Code = Convert.ToInt32(NewAcq_Deal_Rights_Code);
                                DRP.Module_Code = 30;
                                DRP.Record_Status = "P";
                                DRP.Inserted_On = System.DateTime.Now;
                                DRP.User_Code = objLoginUser.Users_Code;
                                DRP.EntityState = State.Added;

                                dynamic resultSetDRP;
                                DRPService.Save(DRP, out resultSetDRP);
                            }

                            Acq_Deal_Rights objADR;
                            if (i == 0)
                            {
                                objADR = ADRPS.GetById(objAcq_Deal_Rights.Acq_Deal_Rights_Code);
                            }
                            else
                            {
                                objADR = ADRPS.GetById(Convert.ToInt32(NewAcq_Deal_Rights_Code));
                            }

                            objADR.EntityState = State.Modified;
                            int? TitCode = objADR.Acq_Deal_Rights_Title.ElementAt(0).Title_Code;
                            objADR.Actual_Right_End_Date = lstTPD.Where(x => x.TitleCode == TitCode).Select(x => x.Perpetuity_Date).FirstOrDefault();
                            ADRPS.Save(objADR, out resultSetADRP);

                        }

                    }
                    string Is_Acq_rights_delay_validation = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName)
                           .SearchFor(x => x.Parameter_Name == "Is_Acq_rights_delay_validation")
                           .FirstOrDefault().Parameter_Value;

                    if (Is_Acq_rights_delay_validation == "Y")
                    {
                        Deal_Rights_Process_Service DRPService = new Deal_Rights_Process_Service(objLoginEntity.ConnectionStringName);
                        Deal_Rights_Process DRP = new Deal_Rights_Process();
                        DRP.Deal_Code = objAcq_Deal_Rights.Acq_Deal_Code;
                        DRP.Deal_Rights_Code = objAcq_Deal_Rights.Acq_Deal_Rights_Code;
                        DRP.Module_Code = 30;
                        DRP.Record_Status = "P";
                        DRP.Inserted_On = System.DateTime.Now;
                        DRP.User_Code = objLoginUser.Users_Code;
                        DRP.EntityState = State.Added;

                        dynamic resultSetDRP;
                        DRPService.Save(DRP, out resultSetDRP);

                        return true;
                    }
                   else
                    {
                        UpdateDealRightProcess(objAcq_Deal_Rights.Acq_Deal_Rights_Code);
                        return ShowValidationPopup(resultSet);
                    }
                }
            }
            else
            {
                return false;
            }
            return true;
        }
        public void UpdateDealRightProcess(int rightCode = 0)
        {
            Acq_Deal_Rights_Error_Details_Service objADREDSer = new Acq_Deal_Rights_Error_Details_Service(objLoginEntity.ConnectionStringName);
            Deal_Rights_Process_Service objDRPSer = new Deal_Rights_Process_Service(objLoginEntity.ConnectionStringName);

            var Rights_Bulk_Update_Code = objDRPSer.SearchFor(x => x.Deal_Code == objAcq_Deal_Rights.Acq_Deal_Code && x.Deal_Rights_Code == rightCode && x.Record_Status == "E")
                             .OrderByDescending(x => x.Deal_Rights_Process_Code).Select(x => x.Rights_Bulk_Update_Code).FirstOrDefault();

            var lst_TitleCode = objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(x => x.Title_Code).ToList();

            var lst_Title = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lst_TitleCode.Contains(x.Title_Code)).Select(x => x.Title_Name).ToList();

            List<Deal_Rights_Process> lstDRP = objDRPSer.SearchFor(x => x.Rights_Bulk_Update_Code == Rights_Bulk_Update_Code).ToList();
            foreach (Deal_Rights_Process item in lstDRP)
            {
                if (lst_TitleCode.Where(x => x.Value == item.Title_Code).Count() > 0)
                {
                    item.EntityState = State.Modified;
                    item.Record_Status = "D";
                    dynamic resultSet;
                    objDRPSer.Update(item, out resultSet);
                }
            }

            List<Acq_Deal_Rights_Error_Details> lstADRED = objADREDSer.SearchFor(x => x.Acq_Deal_Rights_Code == rightCode).ToList();
            foreach (Acq_Deal_Rights_Error_Details item in lstADRED)
            {
                if (lst_Title.Where(x => x == item.Title_Name).Count() > 0)
                {
                    item.EntityState = State.Deleted;
                    dynamic resultSet;
                    objADREDSer.Delete(item, out resultSet);
                }
            }
        }

        public ActionResult showHoldbackValidationPopup(string acqdealMovieCode)
        {
            lstADRHV = null;
            string deletedHBCodes = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.EntityState == State.Deleted).Select(s => s.Acq_Deal_Rights_Holdback_Code).ToArray());
            foreach (Acq_Deal_Rights_Holdback objADRHB in objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.EntityState != State.Deleted))
            {
                int Count = 0;
                string acqDealMovieCode = acqdealMovieCode;
                string[] ADMCode = acqDealMovieCode.Split(',');
                string[] titleCode = new string[] { };

                string ignorableHBCode = ((string.IsNullOrEmpty(deletedHBCodes) ? "" : deletedHBCodes + ",") + objADRHB.Acq_Deal_Rights_Holdback_Code.ToString());
                Count = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Deal_Rights_Holdback_Validation(ignorableHBCode, objADRHB.strPlatformCodes, objADRHB.strCountryCodes, acqDealMovieCode, objDeal_Schema.Deal_Type_Code, objADRHB.Is_Title_Language_Right, objADRHB.strDubbingCodes, objADRHB.strSubtitlingCodes, objDeal_Schema.Rights_Is_Exclusive).FirstOrDefault().Rec_Count;
                if (Count > 0)
                {
                    Syn_Deal_Rights_Holdback_Validation objSDRHV = new Syn_Deal_Rights_Holdback_Validation();
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        titleCode = objDeal_Schema.Title_List.Where(w => ADMCode.Contains(w.Acq_Deal_Movie_Code.ToString())).Select(s => s.Title_Code.ToString()).ToArray();
                    else
                        titleCode = ADMCode;
                    Acq_Deal_Rights_Holdback_Validation objADRHV = new Acq_Deal_Rights_Holdback_Validation();
                    objADRHV.Title_Name = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => titleCode.Contains(x.Title_Code.ToString())).Select(x => x.Title_Name).FirstOrDefault();
                    string[] platforCode = objADRHB.strPlatformCodes.Split(',');
                    string[] platforms = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => platforCode.Contains(x.Platform_Code.ToString())).Select(x => x.Platform_Name).ToArray();
                    objADRHV.Platform = string.Join(", ", platforms);
                    string[] countryCode = objADRHB.strCountryCodes.Split(',');
                    string[] countrys = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => countryCode.Contains(x.Country_Code.ToString())).Select(x => x.Country_Name).ToArray();
                    objADRHV.Region = string.Join(", ", countrys);
                    lstADRHV.Add(objADRHV);
                }
                if (Count == 0)
                    lstADRHV = null;
            }
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_Holdback_Validation_Popup.cshtml", lstADRHV);

        }

        public Acq_Deal_Rights SetNewAcqDealRight(Acq_Deal_Rights objExistingRight, int Title_Code, int Episode_From, int Episode_To, int Platform_Code)
        {
            Acq_Deal_Rights objSecondRight = new Acq_Deal_Rights();

            Acq_Deal_Rights_Title objT = new Acq_Deal_Rights_Title();
            objT.Title_Code = Title_Code;
            objT.Episode_From = Episode_From;
            objT.Episode_To = Episode_To;
            objT.EntityState = State.Added;
            objSecondRight.Acq_Deal_Rights_Title.Add(objT);

            objExistingRight.Acq_Deal_Rights_Platform.ToList<Acq_Deal_Rights_Platform>().ForEach(t =>
            {
                if (t.Platform_Code != Platform_Code)
                {
                    Acq_Deal_Rights_Platform objP = new Acq_Deal_Rights_Platform();
                    objP.Platform_Code = t.Platform_Code;
                    objP.EntityState = State.Added;
                    objSecondRight.Acq_Deal_Rights_Platform.Add(objP);
                }
            });
            objExistingRight.Acq_Deal_Rights_Territory.ToList<Acq_Deal_Rights_Territory>().ForEach(t =>
            {
                Acq_Deal_Rights_Territory objTer = new Acq_Deal_Rights_Territory();
                objTer.Territory_Code = t.Territory_Code;
                objTer.Territory_Type = t.Territory_Type;
                objTer.Country_Code = t.Country_Code;
                objTer.EntityState = State.Added;
                objSecondRight.Acq_Deal_Rights_Territory.Add(objTer);
            });
            objExistingRight.Acq_Deal_Rights_Subtitling.ToList<Acq_Deal_Rights_Subtitling>().ForEach(t =>
            {
                Acq_Deal_Rights_Subtitling objS = new Acq_Deal_Rights_Subtitling();
                objS.Language_Code = t.Language_Code;
                objS.Language_Type = t.Language_Type;
                objS.Language_Group_Code = t.Language_Group_Code;
                objS.EntityState = State.Added;
                objSecondRight.Acq_Deal_Rights_Subtitling.Add(objS);
            });
            objExistingRight.Acq_Deal_Rights_Dubbing.ToList<Acq_Deal_Rights_Dubbing>().ForEach(t =>
            {
                Acq_Deal_Rights_Dubbing objD = new Acq_Deal_Rights_Dubbing();
                objD.Language_Code = t.Language_Code;
                objD.Language_Type = t.Language_Type;
                objD.Language_Group_Code = t.Language_Group_Code;
                objD.EntityState = State.Added;
                objSecondRight.Acq_Deal_Rights_Dubbing.Add(objD);
            });

            objExistingRight.Acq_Deal_Rights_Holdback.ToList<Acq_Deal_Rights_Holdback>().ForEach(t =>
            {
                Acq_Deal_Rights_Holdback objH = new Acq_Deal_Rights_Holdback();
                objH.Holdback_Type = t.Holdback_Type;
                objH.HB_Run_After_Release_No = t.HB_Run_After_Release_No;
                objH.HB_Run_After_Release_Units = t.HB_Run_After_Release_Units;
                objH.Holdback_On_Platform_Code = t.Holdback_On_Platform_Code;
                objH.Holdback_Release_Date = t.Holdback_Release_Date;
                objH.Holdback_Comment = t.Holdback_Comment;
                objH.Is_Title_Language_Right = t.Is_Title_Language_Right;
                objH.EntityState = State.Added;
                t.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(x =>
                {
                    if (x.Platform_Code != Platform_Code)
                    {
                        Acq_Deal_Rights_Holdback_Platform objP = new Acq_Deal_Rights_Holdback_Platform();
                        objP.Platform_Code = x.Platform_Code;
                        objP.EntityState = State.Added;
                        objH.Acq_Deal_Rights_Holdback_Platform.Add(objP);
                    }
                });
                t.Acq_Deal_Rights_Holdback_Territory.ToList<Acq_Deal_Rights_Holdback_Territory>().ForEach(x =>
                {
                    Acq_Deal_Rights_Holdback_Territory objTer = new Acq_Deal_Rights_Holdback_Territory();
                    objTer.Territory_Code = x.Territory_Code;
                    objTer.Territory_Type = x.Territory_Type;
                    objTer.Country_Code = x.Country_Code;
                    objTer.EntityState = State.Added;
                    objH.Acq_Deal_Rights_Holdback_Territory.Add(objTer);
                });
                t.Acq_Deal_Rights_Holdback_Subtitling.ToList<Acq_Deal_Rights_Holdback_Subtitling>().ForEach(x =>
                {
                    Acq_Deal_Rights_Holdback_Subtitling objS = new Acq_Deal_Rights_Holdback_Subtitling();
                    objS.Language_Code = x.Language_Code;
                    objS.EntityState = State.Added;
                    objH.Acq_Deal_Rights_Holdback_Subtitling.Add(objS);
                });
                t.Acq_Deal_Rights_Holdback_Dubbing.ToList<Acq_Deal_Rights_Holdback_Dubbing>().ForEach(x =>
                {
                    Acq_Deal_Rights_Holdback_Dubbing objD = new Acq_Deal_Rights_Holdback_Dubbing();
                    objD.Language_Code = x.Language_Code;
                    objD.EntityState = State.Added;
                    objH.Acq_Deal_Rights_Holdback_Dubbing.Add(objD);
                });
                objSecondRight.Acq_Deal_Rights_Holdback.Add(objH);
            });

            objExistingRight.Acq_Deal_Rights_Blackout.ToList<Acq_Deal_Rights_Blackout>().ForEach(t =>
            {
                Acq_Deal_Rights_Blackout objB = new Acq_Deal_Rights_Blackout();
                objB.Start_Date = t.Start_Date;
                objB.End_Date = t.End_Date;
                objB.EntityState = State.Added;
                t.Acq_Deal_Rights_Blackout_Platform.ToList<Acq_Deal_Rights_Blackout_Platform>().ForEach(x =>
                {
                    Acq_Deal_Rights_Blackout_Platform objP = new Acq_Deal_Rights_Blackout_Platform();
                    objP.Platform_Code = x.Platform_Code;
                    objP.EntityState = State.Added;
                    objB.Acq_Deal_Rights_Blackout_Platform.Add(objP);
                });
                t.Acq_Deal_Rights_Blackout_Territory.ToList<Acq_Deal_Rights_Blackout_Territory>().ForEach(x =>
                {
                    Acq_Deal_Rights_Blackout_Territory objTer = new Acq_Deal_Rights_Blackout_Territory();
                    objTer.Territory_Code = x.Territory_Code;
                    objTer.Territory_Type = x.Territory_Type;
                    objTer.Country_Code = x.Country_Code;
                    objTer.EntityState = State.Added;
                    objB.Acq_Deal_Rights_Blackout_Territory.Add(objTer);
                });
                t.Acq_Deal_Rights_Blackout_Subtitling.ToList<Acq_Deal_Rights_Blackout_Subtitling>().ForEach(x =>
                {
                    Acq_Deal_Rights_Blackout_Subtitling objS = new Acq_Deal_Rights_Blackout_Subtitling();
                    objS.Language_Code = x.Language_Code;
                    objS.EntityState = State.Added;
                    objB.Acq_Deal_Rights_Blackout_Subtitling.Add(objS);
                });
                t.Acq_Deal_Rights_Blackout_Dubbing.ToList<Acq_Deal_Rights_Blackout_Dubbing>().ForEach(x =>
                {
                    Acq_Deal_Rights_Blackout_Dubbing objD = new Acq_Deal_Rights_Blackout_Dubbing();
                    objD.Language_Code = x.Language_Code;
                    objD.EntityState = State.Added;
                    objB.Acq_Deal_Rights_Blackout_Dubbing.Add(objD);
                });
                objSecondRight.Acq_Deal_Rights_Blackout.Add(objB);
            });

            objExistingRight.Acq_Deal_Rights_Promoter.ToList<Acq_Deal_Rights_Promoter>().ForEach(t =>
            {
                Acq_Deal_Rights_Promoter objPromoter = new Acq_Deal_Rights_Promoter();
                objPromoter.EntityState = State.Added;
                t.Acq_Deal_Rights_Promoter_Group.ToList<Acq_Deal_Rights_Promoter_Group>().ForEach(x =>
                {
                    Acq_Deal_Rights_Promoter_Group objG = new Acq_Deal_Rights_Promoter_Group();
                    objG.Promoter_Group_Code = x.Promoter_Group_Code;
                    objG.EntityState = State.Added;
                    objPromoter.Acq_Deal_Rights_Promoter_Group.Add(objG);
                });
                t.Acq_Deal_Rights_Promoter_Remarks.ToList<Acq_Deal_Rights_Promoter_Remarks>().ForEach(x =>
                {
                    Acq_Deal_Rights_Promoter_Remarks objR = new Acq_Deal_Rights_Promoter_Remarks();
                    objR.Promoter_Remarks_Code = x.Promoter_Remarks_Code;
                    objR.EntityState = State.Added;
                    objPromoter.Acq_Deal_Rights_Promoter_Remarks.Add(objR);
                });

                objSecondRight.Acq_Deal_Rights_Promoter.Add(objPromoter);
            });

            objSecondRight.Acq_Deal_Code = objExistingRight.Acq_Deal_Code;
            objSecondRight.Is_Exclusive = objExistingRight.Is_Exclusive;
            objSecondRight.Is_Under_Production = objExistingRight.Is_Under_Production;
            objSecondRight.Is_Title_Language_Right = objExistingRight.Is_Title_Language_Right;
            objSecondRight.Is_Sub_License = objExistingRight.Is_Sub_License;
            objSecondRight.Sub_License_Code = objExistingRight.Sub_License_Code;
            objSecondRight.Is_Theatrical_Right = objExistingRight.Is_Theatrical_Right;
            objSecondRight.Right_Type = objExistingRight.Right_Type;
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
            objSecondRight.EntityState = State.Added;

            return objSecondRight;
        }

        private Acq_Deal_Rights CreateRightObject(Acq_Deal_Rights objExistingRights, Acq_Deal_Rights objMVCRights, FormCollection form)
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
            if (Lst_Acq_Deal_Rights_Holdback == null)
                Lst_Acq_Deal_Rights_Holdback = new List<Acq_Deal_Rights_Holdback>();

            if (Lst_Acq_Deal_Rights_Blackout == null)
                Lst_Acq_Deal_Rights_Blackout = new List<Acq_Deal_Rights_Blackout>();

            if (Lst_Acq_Deal_Rights_Promoter == null)
                Lst_Acq_Deal_Rights_Promoter = new List<Acq_Deal_Rights_Promoter>();

            string Is_Acq_rights_delay_validation = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName)
                .SearchFor(x => x.Parameter_Name == "Is_Acq_rights_delay_validation")
                .FirstOrDefault().Parameter_Value;
            if (Is_Acq_rights_delay_validation == "Y")
            {

            }
            if (objExistingRights.Acq_Deal_Rights_Code > 0)
            {
                objExistingRights.Acq_Deal_Rights_Title.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Platform.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Territory.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Subtitling.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Dubbing.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Holdback.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Blackout.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Promoter.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Last_Updated_Time = DateTime.Now;
                objExistingRights.Last_Action_By = objLoginUser.Users_Code;
                objExistingRights.Right_Status = Is_Acq_rights_delay_validation == "Y" ? "P" : "C";
            }
            else if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_CLONE)
            {
                objExistingRights.Acq_Deal_Rights_Title.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Platform.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Territory.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Subtitling.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Dubbing.ToList().ForEach(i => i.EntityState = State.Deleted);
                objExistingRights.Acq_Deal_Rights_Holdback.Clear();
                objExistingRights.Acq_Deal_Rights_Blackout.Clear();
                objExistingRights.Acq_Deal_Rights_Promoter.Clear();
                objExistingRights.Inserted_On = DateTime.Now;
                objExistingRights.Inserted_By = objLoginUser.Users_Code;
                objExistingRights.Right_Status = Is_Acq_rights_delay_validation == "Y" ? "P" : "C";
            }
            else
            {
                // Changed by Abhay, because on detail level if we split any rigts so holdback get deleted for that particular platform
                if (Lst_Acq_Deal_Rights_Holdback.Count > 0)
                    objExistingRights.Acq_Deal_Rights_Holdback.Clear();

                objExistingRights.Acq_Deal_Rights_Blackout.Clear();
                objExistingRights.Acq_Deal_Rights_Promoter.Clear();
                objExistingRights.Inserted_On = DateTime.Now;
                objExistingRights.Inserted_By = objLoginUser.Users_Code;
                objExistingRights.Right_Status = Is_Acq_rights_delay_validation == "Y" ? "P" : "C";
            }

            string Region_Type = form["hdnRegion_Type"];
            string Sub_Type = form["hdnSub_Type"];
            string Dub_Type = form["hdnDub_Type"];

            string Title_Codes = form["hdnTitle_Code"].Replace(" ", "");
            string Platform_Codes = form["hdnTVCodes"].Replace(" ", "");
            string Region_Codes = form["hdnRegion_Code"].Replace(" ", "");
            string Sub_Codes = form["hdnSub_Code"].Replace(" ", "");
            string Dub_Codes = form["hdnDub_Code"].Replace(" ", "");
            //bool IsExclusive = Convert.ToBoolean(form["hdnIs_Exclusive"]);
            string IsExclusive = Convert.ToString(form["hdnIs_Exclusive"]);
            string Is_Under_Production = Convert.ToString(form["Is_Under_Production"]) == "false" ? "N" : "Y";
            bool Is_Theatrical_Right = Convert.ToBoolean(form["hdnIs_Theatrical_Right"]);
            bool IsTitleLanguageRight = Convert.ToBoolean(form["hdnIs_Title_Language_Right"]);
            string Buyback_Syn_Rights_Code =  Convert.ToString(form["hdnBuyback_Syn_Rights_Code"]);




            objExistingRights.Region_Type = Region_Type;
            objExistingRights.Sub_Type = Sub_Type;
            objExistingRights.Dub_Type = Dub_Type;
            objExistingRights.Platform_Codes = Platform_Codes;
            objExistingRights.Buyback_Syn_Rights_Code = Buyback_Syn_Rights_Code;

            Deal_Rights_UDT objDRUDT = new Deal_Rights_UDT();

            #region ========= Title object creation =========

            ICollection<Acq_Deal_Rights_Title> selectTitleList = new HashSet<Acq_Deal_Rights_Title>();

            if (Title_Codes != "")
            {

                string[] titCodes = Title_Codes.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string titleCode in titCodes)
                {
                    Acq_Deal_Rights_Title objT = new Acq_Deal_Rights_Title();

                    int code = Convert.ToInt32((string.IsNullOrEmpty(titleCode)) ? "0" : titleCode);

                    int EpStart = 1, EpEnd = 1;
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        Title_List objTL = null;
                        //if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        //    objTL = objDeal_Schema.Title_List.Where(x => x.Title_Code == code).FirstOrDefault();
                        //else
                        objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();
                        EpStart = objTL.Episode_From;
                        EpEnd = objTL.Episode_To;
                        code = objTL.Title_Code;
                    }


                    objT = (Acq_Deal_Rights_Title)objExistingRights.Acq_Deal_Rights_Title.Where(t => t.Title_Code == Convert.ToInt32(code) && t.Episode_From == EpStart && t.Episode_To == EpEnd).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Acq_Deal_Rights_Title();

                    if (objT.Acq_Deal_Rights_Title_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.Episode_From = EpStart;
                        objT.Episode_To = EpEnd;
                        objT.Title_Code = code;
                        objT.EntityState = State.Added;
                        //objExistingRights.Acq_Deal_Rights_Title.Add(objT);
                    }
                    selectTitleList.Add(objT);
                }
            }

            IEqualityComparer<Acq_Deal_Rights_Title> ComparerRepeat = new LambdaComparer<Acq_Deal_Rights_Title>((x, y) => x.Title_Code == y.Title_Code && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To && x.EntityState != State.Deleted);
            var Deleted_Acq_Deal_Rights_Title = new List<Acq_Deal_Rights_Title>();
            var Updated_Acq_Deal_Rights_Title = new List<Acq_Deal_Rights_Title>();
            var Added_Acq_Deal_Rights_Title = CompareLists<Acq_Deal_Rights_Title>(selectTitleList.ToList(), objExistingRights.Acq_Deal_Rights_Title.ToList(), ComparerRepeat, ref Deleted_Acq_Deal_Rights_Title, ref Updated_Acq_Deal_Rights_Title);

            Added_Acq_Deal_Rights_Title.ToList<Acq_Deal_Rights_Title>().ForEach(t => objExistingRights.Acq_Deal_Rights_Title.Add(t));
            Deleted_Acq_Deal_Rights_Title.ToList<Acq_Deal_Rights_Title>().ForEach(t => t.EntityState = State.Deleted);

            #endregion

            #region ========= Save Platform =====

            if (Platform_Codes.Trim() != "")
            {
                objExistingRights.Acq_Deal_Rights_Platform.Where(w => w.EntityState == State.Added).ToList().
                    ForEach(t => objExistingRights.Acq_Deal_Rights_Platform.Remove(t));

                Platform_Codes = Platform_Codes.Replace("_", "").Trim().Replace("_", "").Replace(" ", "").Replace("_0", "").Trim(); ;
                string[] PTitle_Codes = Platform_Codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Distinct().ToArray();
                foreach (string platformCode in PTitle_Codes)
                {
                    if (platformCode != "" && platformCode != "0")
                    {
                        Acq_Deal_Rights_Platform objADRP = new Acq_Deal_Rights_Platform();

                        Acq_Deal_Rights_Platform objP = objExistingRights.Acq_Deal_Rights_Platform.Where(t => t.Platform_Code == Convert.ToInt32(platformCode)).Select(i => i).FirstOrDefault();
                        if (objP == null)
                            objP = new Acq_Deal_Rights_Platform();

                        if (objP.Acq_Deal_Rights_Platform_Code > 0)
                        {
                            objP.EntityState = State.Unchanged;
                        }
                        else
                        {
                            objADRP.Platform_Code = objP.Platform_Code = Convert.ToInt32(platformCode);
                            objP.EntityState = State.Added;
                        }
                        objExistingRights.Acq_Deal_Rights_Platform.Add(objP);
                    }
                }
            }

            #endregion

            #region ========= Country / Territory object creation =========

            if (Region_Codes.Trim() != "")
            {
                objExistingRights.Acq_Deal_Rights_Territory.Where(w => w.EntityState == State.Added).ToList().
                    ForEach(t => objExistingRights.Acq_Deal_Rights_Territory.Remove(t));

                string[] TC_Codes = Region_Codes.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string CtrCode in TC_Codes)
                {
                    Acq_Deal_Rights_Territory objT = objExistingRights.Acq_Deal_Rights_Territory.Where(t =>
                            (t.Country_Code == Convert.ToInt32(CtrCode) && t.Territory_Type == Region_Type) ||
                            (t.Territory_Code == Convert.ToInt32(CtrCode) && t.Territory_Type == Region_Type)
                        ).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Acq_Deal_Rights_Territory();

                    if (objT.Acq_Deal_Rights_Territory_Code > 0)
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

                    objExistingRights.Acq_Deal_Rights_Territory.Add(objT);
                }
            }

            #endregion

            #region ========= SubTitle object creation =========

            if (Sub_Codes.Trim() != "")
            {
                objExistingRights.Acq_Deal_Rights_Subtitling.Where(w => w.EntityState == State.Added).ToList().
                    ForEach(t => objExistingRights.Acq_Deal_Rights_Subtitling.Remove(t));

                string[] ST_Codes = Sub_Codes.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string lngCode in ST_Codes)
                {
                    Acq_Deal_Rights_Subtitling objSub = objExistingRights.Acq_Deal_Rights_Subtitling.Where(t =>
                            (t.Language_Code == Convert.ToInt32(lngCode) && t.Language_Type == Sub_Type) ||
                            (t.Language_Group_Code == Convert.ToInt32(lngCode) && t.Language_Type == Sub_Type)
                        ).Select(i => i).FirstOrDefault();

                    if (objSub == null)
                        objSub = new Acq_Deal_Rights_Subtitling();

                    if (objSub.Acq_Deal_Rights_Subtitling_Code > 0)
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

                    objExistingRights.Acq_Deal_Rights_Subtitling.Add(objSub);
                }
            }

            #endregion

            #region ========= Dubbing object creation =========

            if (Dub_Codes.Trim() != "")
            {
                objExistingRights.Acq_Deal_Rights_Dubbing.Where(w => w.EntityState == State.Added).ToList().
                    ForEach(t => objExistingRights.Acq_Deal_Rights_Dubbing.Remove(t));

                string[] ST_Codes = Dub_Codes.Split(new char[] { ',' }, StringSplitOptions.None);
                foreach (string lngCode in ST_Codes)
                {
                    Acq_Deal_Rights_Dubbing objDub = objExistingRights.Acq_Deal_Rights_Dubbing.Where(t =>
                            (t.Language_Code == Convert.ToInt32(lngCode) && t.Language_Type == Dub_Type) ||
                            (t.Language_Group_Code == Convert.ToInt32(lngCode) && t.Language_Type == Dub_Type)
                        ).Select(i => i).FirstOrDefault();

                    if (objDub == null)
                        objDub = new Acq_Deal_Rights_Dubbing();

                    if (objDub.Acq_Deal_Rights_Dubbing_Code > 0)
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

                    objExistingRights.Acq_Deal_Rights_Dubbing.Add(objDub);
                }
            }

            #endregion

            objDRUDT.Title_Code = objPage_Properties.TCODE;
            objDRUDT.Platform_Code = objPage_Properties.PCODE;
            //objDRUDT.Deal_Rights_Code = objPage_Properties.TCODE > 0 ? 0 : objPage_Properties.RCODE; //objExistingRights.Acq_Deal_Rights_Code;
            objDRUDT.Deal_Rights_Code = objPage_Properties.RCODE;
            objDRUDT.Deal_Code = objExistingRights.Acq_Deal_Code = objDeal_Schema.Deal_Code;
            //objDRUDT.Is_Exclusive = objExistingRights.Is_Exclusive = IsExclusive ? "Y" : "N";
            objDRUDT.Is_Exclusive = objExistingRights.Is_Exclusive = IsExclusive;
            objExistingRights.Is_Under_Production = Is_Under_Production;
            objDRUDT.Is_Theatrical_Right = objExistingRights.Is_Theatrical_Right = Is_Theatrical_Right ? "Y" : "N";

            objDRUDT.Is_Title_Language_Right = objExistingRights.Is_Title_Language_Right = IsTitleLanguageRight ? "Y" : "N";
            //objDRUDT.Sub_License_Code = objMVCRights.Sub_License_Code;
            //objDRUDT.Is_Sub_License = objExistingRights.Is_Sub_License = chkSubLicensing.Checked ? "Y" : "N";

            //if (objMVCRights.Sub_License_Code > 0)
            if (form["hdnSub_License_Code"] != "0" && form["hdnSub_License_Code"] != null && form["hdnSub_License_Code"] != "" && form["hdnSub_License_Code"] != "-1")
            {
                objDRUDT.Sub_License_Code = objExistingRights.Sub_License_Code = Convert.ToInt32(form["hdnSub_License_Code"]);
                objDRUDT.Is_Sub_License = objExistingRights.Is_Sub_License = "Y";
            }
            else
            {
                objDRUDT.Sub_License_Code = objExistingRights.Sub_License_Code = null;
                objDRUDT.Is_Sub_License = objExistingRights.Is_Sub_License = "N";
            }

            //objDRUDT.Is_Theatrical_Right = objExistingRights.Is_Theatrical_Right = objMVCRights.Is_Theatrical_Right.ToUpper() == "TRUE" ? "Y" : "N";
            if (objMVCRights.Right_Type == "M" && (objAcq_Deal_Rights.Right_Type == "Y" || objAcq_Deal_Rights.Right_Type == "U"))
                objExistingRights.Actual_Right_Start_Date = objExistingRights.Actual_Right_End_Date = objExistingRights.Right_Start_Date = objExistingRights.Right_End_Date = null;

            objDRUDT.Right_Type = objExistingRights.Right_Type = objMVCRights.Right_Type;
            objExistingRights.Original_Right_Type = objMVCRights.Original_Right_Type;
            objDRUDT.Term = objExistingRights.Term = "";
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
                        dtSD = dtSD.AddDays(Convert.ToInt32(objMVCRights.Term_DD));
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
                    //objDRUDT.Original_Right_Type = 
                    objExistingRights.Original_Right_Type = "U";

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
                objDRUDT.Is_Tentative = objExistingRights.Is_Tentative = "N";
                objExistingRights.ROFR_Code = null;


                objExistingRights.Effective_Start_Date = objExistingRights.Right_Start_Date;
                objExistingRights.Actual_Right_Start_Date = objExistingRights.Right_Start_Date;
                objExistingRights.Actual_Right_End_Date = objExistingRights.Right_End_Date;
            }
            else if (objMVCRights.Original_Right_Type == "M")
            {
                if (objExistingRights.Is_Tentative == null || objExistingRights.Actual_Right_Start_Date == null || objExistingRights.Actual_Right_End_Date == null)
                    objExistingRights.Is_Tentative = "";

                if (objMVCRights.Milestone_Start_Date != null && objMVCRights.Milestone_End_Date != null)
                {
                    objDRUDT.Right_Start_Date = objExistingRights.Actual_Right_Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(objMVCRights.Milestone_Start_Date));
                    objDRUDT.Right_End_Date = objExistingRights.Actual_Right_End_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(objMVCRights.Milestone_End_Date));
                }
                else
                {
                    objDRUDT.Right_Start_Date = objExistingRights.Actual_Right_Start_Date;
                    objDRUDT.Right_End_Date = objExistingRights.Actual_Right_End_Date;
                }

                if (objExistingRights.Is_Tentative == "Y" || objExistingRights.Is_Tentative == "")
                    objDRUDT.Is_Tentative = objExistingRights.Is_Tentative = "Y";
                else
                    objDRUDT.Is_Tentative = objExistingRights.Is_Tentative = "N";

                objDRUDT.Milestone_Type_Code = objExistingRights.Milestone_Type_Code = objMVCRights.Milestone_Type_Code;
                objDRUDT.Milestone_No_Of_Unit = objExistingRights.Milestone_No_Of_Unit = objMVCRights.Milestone_No_Of_Unit;
                objDRUDT.Milestone_Unit_Type = objExistingRights.Milestone_Unit_Type = objMVCRights.Milestone_Unit_Type;

                if (objMVCRights.ROFR_Code > 0 && objPage_Properties.Is_ROFR_Type_Visible == "Y")
                    objExistingRights.ROFR_Code = objMVCRights.ROFR_Code;
            }

            objDRUDT.Is_ROFR = objExistingRights.Is_ROFR = "N";
            objDRUDT.ROFR_Date = objExistingRights.ROFR_Date = null;

            if (!string.IsNullOrEmpty(objMVCRights.ROFR_DT))
            {
                objExistingRights.ROFR_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(objMVCRights.ROFR_DT));
                objDRUDT.Is_ROFR = objExistingRights.Is_ROFR = "Y";
            }

            objDRUDT.Restriction_Remarks = objExistingRights.Restriction_Remarks = objMVCRights.Restriction_Remarks;
            objDRUDT.Buyback_Syn_Rights_Code = objExistingRights.Buyback_Syn_Rights_Code;

            objExistingRights.LstDeal_Rights_UDT = new List<Deal_Rights_UDT>();
            objExistingRights.LstDeal_Rights_UDT.Add(objDRUDT);

            //objExistingRights.LstDeal_Rights_Title_UDT = new List<Deal_Rights_Title_UDT>(
            //        objExistingRights.Acq_Deal_Rights_Title.Where(t => t.EntityState != State.Deleted).Select(x =>
            //        new Deal_Rights_Title_UDT
            //        {
            //            Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
            //            Title_Code = (x.Title_Code == null) ? 0 : x.Title_Code,
            //            Episode_From = x.Episode_From,
            //            Episode_To = x.Episode_To
            //        }
            //    )
            //);

            bool newTitle = false;
            objExistingRights.LstDeal_Rights_Title_UDT.Clear();
            foreach (Acq_Deal_Rights_Title objTitle in objExistingRights.Acq_Deal_Rights_Title)
            {
                //if (objTitle.Title_Code == objPage_Properties.TCODE
                //    && objTitle.Episode_From == objPage_Properties.Episode_From && objTitle.Episode_To == objPage_Properties.Episode_To) { }
                //else if (objTitle.EntityState != State.Deleted)
                if (objTitle.EntityState != State.Deleted)
                {
                    Deal_Rights_Title_UDT objDeal_Rights_Title_UDT = new Deal_Rights_Title_UDT();
                    objDeal_Rights_Title_UDT.Deal_Rights_Code = (objTitle.Acq_Deal_Rights_Code == null) ? 0 : objTitle.Acq_Deal_Rights_Code;
                    objDeal_Rights_Title_UDT.Title_Code = (objTitle.Title_Code == null) ? 0 : objTitle.Title_Code;
                    objDeal_Rights_Title_UDT.Episode_From = objTitle.Episode_From;
                    objDeal_Rights_Title_UDT.Episode_To = objTitle.Episode_To;
                    objExistingRights.LstDeal_Rights_Title_UDT.Add(objDeal_Rights_Title_UDT);
                    newTitle = true;
                }
            }

            objExistingRights.LstDeal_Rights_Platform_UDT = new List<Deal_Rights_Platform_UDT>(
                            objExistingRights.Acq_Deal_Rights_Platform.Where(t => t.EntityState != State.Deleted && (t.Platform_Code != objPage_Properties.PCODE || newTitle)).Select(x =>
                            new Deal_Rights_Platform_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Platform_Code = (x.Platform_Code == null) ? 0 : x.Platform_Code
                            }));

            objExistingRights.LstDeal_Rights_Territory_UDT = new List<Deal_Rights_Territory_UDT>(
                            objExistingRights.Acq_Deal_Rights_Territory.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Territory_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Territory_Code = (x.Territory_Code == null) ? 0 : x.Territory_Code,
                                Country_Code = (x.Country_Code == null) ? 0 : x.Country_Code,
                                Territory_Type = (x.Territory_Type == null) ? "I" : x.Territory_Type
                            }));

            objExistingRights.LstDeal_Rights_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>(
                            objExistingRights.Acq_Deal_Rights_Subtitling.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Subtitling_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Subtitling_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));

            objExistingRights.LstDeal_Rights_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>(
                            objExistingRights.Acq_Deal_Rights_Dubbing.Where(t => t.EntityState != State.Deleted).Select(x =>
                            new Deal_Rights_Dubbing_UDT
                            {
                                Deal_Rights_Code = (x.Acq_Deal_Rights_Code == null) ? 0 : x.Acq_Deal_Rights_Code,
                                Dubbing_Code = (x.Language_Code == null) ? 0 : x.Language_Code,
                                Language_Type = (x.Language_Type == null) ? "L" : x.Language_Type,
                                Language_Group_Code = (x.Language_Group_Code == null) ? 0 : x.Language_Group_Code
                            }));

            //Lst_Acq_Deal_Rights_Holdback = objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.ToList();

            #region --- Holdback ---
            Lst_Acq_Deal_Rights_Holdback.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Acq_Deal_Rights_Holdback objH = new Acq_Deal_Rights_Holdback();
                    objH.Holdback_Type = t.Holdback_Type;
                    objH.HB_Run_After_Release_No = t.HB_Run_After_Release_No;
                    objH.HB_Run_After_Release_Units = t.HB_Run_After_Release_Units;
                    objH.Holdback_On_Platform_Code = t.Holdback_On_Platform_Code;
                    objH.Holdback_Release_Date = t.Holdback_Release_Date;
                    objH.Holdback_Comment = t.Holdback_Comment;
                    objH.Is_Title_Language_Right = t.Is_Title_Language_Right;
                    objH._DummyProp = t._DummyProp;
                    if (objH.Acq_Deal_Rights_Holdback_Code > 0)
                        objH.EntityState = State.Modified;
                    else
                        objH.EntityState = State.Added;
                    t.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Holdback_Platform objP = new Acq_Deal_Rights_Holdback_Platform();
                            objP.Platform_Code = x.Platform_Code;
                            objP.EntityState = State.Added;
                            objH.Acq_Deal_Rights_Holdback_Platform.Add(objP);
                        }
                    });
                    t.Acq_Deal_Rights_Holdback_Territory.ToList<Acq_Deal_Rights_Holdback_Territory>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Holdback_Territory objTer = new Acq_Deal_Rights_Holdback_Territory();
                            objTer.Territory_Code = x.Territory_Code;
                            objTer.Territory_Type = x.Territory_Type;
                            objTer.Country_Code = x.Country_Code;
                            objTer.EntityState = State.Added;
                            objH.Acq_Deal_Rights_Holdback_Territory.Add(objTer);
                        }
                    });
                    t.Acq_Deal_Rights_Holdback_Subtitling.ToList<Acq_Deal_Rights_Holdback_Subtitling>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Holdback_Subtitling objS = new Acq_Deal_Rights_Holdback_Subtitling();
                            objS.Language_Code = x.Language_Code;
                            objS.EntityState = State.Added;
                            objH.Acq_Deal_Rights_Holdback_Subtitling.Add(objS);
                        }
                    });
                    t.Acq_Deal_Rights_Holdback_Dubbing.ToList<Acq_Deal_Rights_Holdback_Dubbing>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Holdback_Dubbing objD = new Acq_Deal_Rights_Holdback_Dubbing();
                            objD.Language_Code = x.Language_Code;
                            objD.EntityState = State.Added;
                            objH.Acq_Deal_Rights_Holdback_Dubbing.Add(objD);
                        }
                    });
                    objExistingRights.Acq_Deal_Rights_Holdback.Add(objH);
                }
            });
            #endregion

            #region --- Blackout ---
            Lst_Acq_Deal_Rights_Blackout.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Acq_Deal_Rights_Blackout objB = new Acq_Deal_Rights_Blackout();
                    objB.Start_Date = t.Start_Date;
                    objB.End_Date = t.End_Date;
                    if (objB.Acq_Deal_Rights_Blackout_Code > 0)
                        objB.EntityState = State.Modified;
                    else
                        objB.EntityState = State.Added;
                    objExistingRights.Acq_Deal_Rights_Blackout.Add(objB);
                }
            });
            #endregion

            #region -----Promoter
            Lst_Acq_Deal_Rights_Promoter.ForEach(t =>
            {
                if (t.EntityState != State.Deleted)
                {
                    Acq_Deal_Rights_Promoter objP = new Acq_Deal_Rights_Promoter();
                    objP.Last_Action_By = objLoginUser.Users_Code;
                    objP.Last_Updated_Time = System.DateTime.Now;

                    if (objP.Acq_Deal_Rights_Promoter_Code > 0)
                        objP.EntityState = State.Modified;
                    else
                        objP.EntityState = State.Added;

                    t.Acq_Deal_Rights_Promoter_Group.ToList<Acq_Deal_Rights_Promoter_Group>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Promoter_Group objG = new Acq_Deal_Rights_Promoter_Group();
                            objG.Promoter_Group_Code = x.Promoter_Group_Code;
                            objG.EntityState = State.Added;
                            objP.Acq_Deal_Rights_Promoter_Group.Add(objG);
                        }
                    });

                    t.Acq_Deal_Rights_Promoter_Remarks.ToList<Acq_Deal_Rights_Promoter_Remarks>().ForEach(x =>
                    {
                        if (x.EntityState != State.Deleted)
                        {
                            Acq_Deal_Rights_Promoter_Remarks objR = new Acq_Deal_Rights_Promoter_Remarks();
                            objR.Promoter_Remarks_Code = x.Promoter_Remarks_Code;
                            objR.EntityState = State.Added;
                            objP.Acq_Deal_Rights_Promoter_Remarks.Add(objR);
                        }
                    });

                    objExistingRights.Acq_Deal_Rights_Promoter.Add(objP);
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
            objAcq_Deal_Rights = null;
            objPage_Properties = null;
            lstDupRecords = null;
            objSyn_Deal_Rights_Buyback = null;
            return Json(objDeal_Schema.PageNo);
            //return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(GlobalParams.Page_From_Rights, objDeal_Schema.PageNo);
        }

        private void SetSyndication_Object()
        {
            //Call From Page Load in Edit Mode
            int[] arr_Syn_Rights_Code = (new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Deal_Rights_Code == objPage_Properties.RCODE).Select(i => i.Syn_Deal_Rights_Code).Distinct().ToArray());
            objPage_Properties.obj_lst_Syn_Rights = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(i => arr_Syn_Rights_Code.Contains(i.Syn_Deal_Rights_Code)).Select(i => i).ToList();

            if (objPage_Properties.Is_Syn_Acq_Mapp == "Y")
            {
                objAcq_Deal_Rights.Disable_SubLicensing = "Y";
                objAcq_Deal_Rights.Disable_Tentative = "Y";
                objAcq_Deal_Rights.Disable_Thetrical = "Y";
                objAcq_Deal_Rights.Disable_RightType = "Y";
                objAcq_Deal_Rights.Existing_RightType = objAcq_Deal_Rights.Right_Type;

                if (objAcq_Deal_Rights.Is_Exclusive == "Y" && objPage_Properties.obj_lst_Syn_Rights.Where(i => i.Is_Exclusive == "Y").Select(i => i.Is_Exclusive.ToString()).FirstOrDefault() == "Y")
                    objAcq_Deal_Rights.Disable_IsExclusive = "Y";
                if (objAcq_Deal_Rights.Is_Title_Language_Right == "Y" && objPage_Properties.obj_lst_Syn_Rights.Where(i => i.Is_Title_Language_Right == "Y").Select(i => i.Is_Title_Language_Right.ToString()).FirstOrDefault() == "Y")
                    objAcq_Deal_Rights.Disable_TitleRights = "Y";
                if (objPage_Properties.obj_lst_Syn_Rights.Where(w => w.Right_Type == "U").Count() > 0)
                    objAcq_Deal_Rights.Disable_RightType = "U";


                //Disabled_Checkbox(chkTentative, "");
                //Disabled_Checkbox(chkThetrical, "");
                //rdoRightPeriod.Enabled = false;

                #region -- Code Added by Abhay ---
                List<Title_List> lstSynTL = objPage_Properties.obj_lst_Syn_Rights.SelectMany(s => s.Syn_Deal_Rights_Title).Select(s => new Title_List
                {
                    Title_Code = (int)s.Title_Code,
                    Episode_From = (int)s.Episode_From,
                    Episode_To = (int)s.Episode_To
                }).ToList();
                #endregion

                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Movie)
                {
                    objPage_Properties.SyndicatedTitlesCode = string.Join(",", ((from objSynTL in lstSynTL
                                                                                 from objRT in objAcq_Deal_Rights.Acq_Deal_Rights_Title
                                                                                 where objSynTL.Title_Code == objRT.Title_Code
                                                                                 select objRT.Title_Code).Distinct().ToArray()));
                }
                else
                {
                    objPage_Properties.SyndicatedTitlesCode = string.Join(",", ((from objSynTL in lstSynTL
                                                                                 from objAcqTL in objDeal_Schema.Title_List
                                                                                 from objRT in objAcq_Deal_Rights.Acq_Deal_Rights_Title
                                                                                 where objAcqTL.Title_Code == objSynTL.Title_Code && objAcqTL.Title_Code == objRT.Title_Code &&
                                                                                 (
                                                                                    (objSynTL.Episode_From >= objAcqTL.Episode_From && objSynTL.Episode_From <= objAcqTL.Episode_To) ||
                                                                                    (objSynTL.Episode_To >= objAcqTL.Episode_From && objSynTL.Episode_To <= objAcqTL.Episode_To) ||
                                                                                    (objAcqTL.Episode_From >= objSynTL.Episode_From && objAcqTL.Episode_From <= objSynTL.Episode_To) ||
                                                                                    (objAcqTL.Episode_To >= objSynTL.Episode_From && objAcqTL.Episode_To <= objSynTL.Episode_To)
                                                                                 )
                                                                                 select objAcqTL.Acq_Deal_Movie_Code).Distinct().ToArray()));
                }
            }
        }

        private void SetRunDefinition_Object()
        {
            Platform_Service objPservice = new Platform_Service(objLoginEntity.ConnectionStringName);
            List<string> lstPlatformCode = objPservice.SearchFor(p => p.Is_No_Of_Run == "Y").Select(p => p.Platform_Code.ToString()).ToList();
            Acq_Deal_Service objDealService = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal objDeal = objDealService.GetById(objDeal_Schema.Deal_Code);

            int platformcount = objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Where(p => lstPlatformCode.Contains(Convert.ToString(p.Platform_Code))).Count();
            if (platformcount > 0)
            {
                List<int> lstTitlecode = (from objRun in objDeal.Acq_Deal_Run
                                          from objRunTitle in objRun.Acq_Deal_Run_Title
                                          where objRun.Acq_Deal_Code == objDeal_Schema.Deal_Code && objRun.Is_Yearwise_Definition == "Y" &&
                                          objAcq_Deal_Rights.Acq_Deal_Rights_Title.Any(t => t.Title_Code == objRunTitle.Title_Code && t.Episode_From == objRunTitle.Episode_From && t.Episode_To == objRunTitle.Episode_To)
                                          select objRunTitle.Title_Code.Value).ToList();

                if (lstTitlecode.Count > 0)
                    objAcq_Deal_Rights.Disable_RightType = "R";
            }
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

        public JsonResult ApplyTemplate(int ARTCode = 0)
        {
            Acq_Rights_Template_Service objService = new Acq_Rights_Template_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Acq_Rights_Template objAcq_Rights_Template = null;
            if (ARTCode > 0)
            {
                objAcq_Rights_Template = objService.GetById(ARTCode);
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("objAcq_Rights_Template", objAcq_Rights_Template);
            return Json(obj);
        }

        private void ClearSession_Is_Buyback()
        {
            Session["Is_Buyback"] = null;
        }

        private bool GET_DATA_FOR_APPROVED_TITLES(string titles, string platforms, string Platform_Type, string Region_Type, string Subtitling_Type, string Dubbing_Type, string CallFrom = "")
        {
            // Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
            platforms = string.Join(",", platforms.Split(',').Where(p => p != "0"));
            List<USP_GET_DATA_FOR_APPROVED_TITLES_Buyback_Result> objList = new List<USP_GET_DATA_FOR_APPROVED_TITLES_Buyback_Result>();
            if (titles != "" && titles != "0")
                objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_DATA_FOR_APPROVED_TITLES_Buyback(titles, platforms, Platform_Type, Region_Type, Subtitling_Type, Dubbing_Type, objSyn_Deal_Rights_Buyback.Syn_Deal_Code).ToList();
            else
                AllCountry_Territory_Codes = AllPlatform_Codes = SubTitle_Lang_Codes = Dubb_Lang_Codes = "";
            if (Platform_Type == "PL" || Platform_Type == "TPL")
                AllPlatform_Codes = objList.Select(i => i.RequiredCodes).FirstOrDefault();
            else
            {
                foreach (USP_GET_DATA_FOR_APPROVED_TITLES_Buyback_Result obj in objList)
                {
                    AllCountry_Territory_Codes = obj.RequiredCodes;
                    SubTitle_Lang_Codes = obj.SubTitle_Lang_Code;
                    Dubb_Lang_Codes = obj.Dubb_Lang_Code;
                }
            }
            return true;
        }

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
            lst_USP_Get_Acq_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Rights_PreReq(objSyn_Deal_Rights_Buyback.Syn_Deal_Code,
                                                                                                   objDeal_Schema.Deal_Type_Code,
                                                                   Data_For, str_Type, AllCountry_Territory_Codes, SubTitle_Lang_Codes, Dubb_Lang_Codes).ToList();
            return lst_USP_Get_Acq_PreReq_Result;
        }
    }

    public class Rights_Page_Properties
    {
        public Rights_Page_Properties() { }

        #region ========== PAGE PROPERTIES ==========

        private List<Syn_Deal_Rights> _obj_lst_Syn_Rights;
        public List<Syn_Deal_Rights> obj_lst_Syn_Rights
        {
            get
            {
                if (_obj_lst_Syn_Rights == null)
                    _obj_lst_Syn_Rights = new List<Syn_Deal_Rights>();
                return (List<Syn_Deal_Rights>)_obj_lst_Syn_Rights;
            }
            set { _obj_lst_Syn_Rights = value; }
        }

        private List<Acq_Deal_Rights> _Obj_Acq_Deal_Rights;
        public List<Acq_Deal_Rights> Obj_Acq_Deal_Rights
        {
            get
            {
                if (_Obj_Acq_Deal_Rights == null)
                    _Obj_Acq_Deal_Rights = new List<Acq_Deal_Rights>();
                return (List<Acq_Deal_Rights>)_Obj_Acq_Deal_Rights;
            }
            set { _Obj_Acq_Deal_Rights = value; }
        }


        private string _SyndicatedTitlesCode = "";
        public string SyndicatedTitlesCode
        {
            get { return _SyndicatedTitlesCode; }
            set { _SyndicatedTitlesCode = value; }
        }
        private string _Is_Syn_Acq_Mapp = "N";
        public string Is_Syn_Acq_Mapp
        {
            get { return _Is_Syn_Acq_Mapp; }
            set { _Is_Syn_Acq_Mapp = value; }
        }

        private string _RMODE = "";
        public string RMODE
        {
            get { return _RMODE; }
            set { _RMODE = value; }
        }

        private int _RCODE = 0;
        public int RCODE
        {
            get { return _RCODE; }
            set { _RCODE = value; }
        }

        private int _TCODE = 0;
        public int TCODE
        {
            get { return _TCODE; }
            set { _TCODE = value; }
        }

        private int _PCODE = 0;
        public int PCODE
        {
            get { return _PCODE; }
            set { _PCODE = value; }
        }

        private int _PGCODE = 0;
        public int PGCODE
        {
            get { return _PGCODE; }
            set { _PGCODE = value; }
        }

        private int _Episode_From = 0;
        public int Episode_From
        {
            get { return _Episode_From; }
            set { _Episode_From = value; }
        }

        private int _Episode_To = 0;
        public int Episode_To
        {
            get { return _Episode_To; }
            set { _Episode_To = value; }
        }

        private string _Acquired_Title_Codes = "0";
        public string Acquired_Title_Codes
        {
            get { return _Acquired_Title_Codes; }
            set { _Acquired_Title_Codes = value; }
        }

        private string _Acquired_Platform_Codes = "0";
        public string Acquired_Platform_Codes
        {
            get { return _Acquired_Platform_Codes; }
            set { _Acquired_Platform_Codes = value; }
        }


        private string _Acquired_Promoter_Codes = "0";
        public string Acquired_Promoter_Codes
        {
            get { return _Acquired_Promoter_Codes; }
            set { _Acquired_Promoter_Codes = value; }
        }


        private string _Acquired_Region_Codes = "0";
        public string Acquired_Region_Codes
        {
            get { return _Acquired_Region_Codes; }
            set { _Acquired_Region_Codes = value; }
        }


        private string _Acquired_Subtitling_Codes = "0";
        public string Acquired_Subtitling_Codes
        {
            get { return _Acquired_Subtitling_Codes; }
            set { _Acquired_Subtitling_Codes = value; }
        }

        private string _Acquired_Dubbing_Codes = "0";
        public string Acquired_Dubbing_Codes
        {
            get { return _Acquired_Dubbing_Codes; }
            set { _Acquired_Dubbing_Codes = value; }
        }

        private string _Is_ROFR_Type_Visible = "N";
        public string Is_ROFR_Type_Visible
        {
            get { return _Is_ROFR_Type_Visible; }
            set { _Is_ROFR_Type_Visible = value; }
        }

        private string _IsHB = "0";
        public string IsHB
        {
            get { return _IsHB; }
            set { _IsHB = value; }
        }

        //public List<Syn_Deal_Rights> obj_lst_Syn_Rights { get; set; }
        //public string Is_Syn_Acq_Mapp { get; set; }
        //public string RMODE { get; set; }
        //public int RCODE { get; set; }
        //public int TCODE { get; set; }
        //public int PCODE { get; set; }
        //public int Episode_From { get; set; }
        //public int Episode_To { get; set; }
        //public string Acquired_Title_Codes { get; set; }
        //public string Acquired_Platform_Codes { get; set; }
        //public string Acquired_Region_Codes { get; set; }
        //public string Acquired_Subtitling_Codes { get; set; }
        //public string Acquired_Dubbing_Codes { get; set; }
        //public string Is_ROFR_Type_Visible { get; set; }
        //public string IsHB { get; set; }

        #endregion
    }
    public class Acq_Deal_Rights_Holdback_Validation
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

    public class Title_Perpetuity_Date
    {
        public int? TitleCode { get; set; }
        public DateTime Release_Date { get; set; }
        public DateTime Perpetuity_Date { get; set; }
    }

    internal class Current_Deal_Right
    {
        public int? TitleCode { get; set; }
        public int? EpsFrom { get; set; }
        public int? EpsTo { get; set; }
    }
}