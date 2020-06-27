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
    public class Acq_Rights_HoldbackController : BaseController
    {
        #region ============= SESSION DECLARATION ============
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
        #endregion

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
        public string Title_Codes
        {
            get
            {
                if (Session["Title_Codes"] == null)
                    Session["Title_Codes"] = "";
                return (string)Session["Title_Codes"];
            }
            set { Session["Title_Codes"] = value; }
        }

        //
        // GET: /Acq_Rights_Holdback/
        public ActionResult Index()
        {
            return View();
        }
        #region =============Validate Holdback ============
        private bool ValidateduplicateHoldback(string strSelectedPlatformCode, string strSelectedCountryTerritory_HBCode, string strTitleLanguage, string strSelectedSubTitling, string strSelectedubbing, Acq_Deal_Rights_Holdback objRHB)
        {
            bool IsValidate = true;
            string IsBreak = "N";
            int count = 0;
            string AcqRightsHoldbackCode = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.EntityState == State.Deleted).Select(s => s.Acq_Deal_Rights_Holdback_Code));
            if (AcqRightsHoldbackCode != "")
            {
                AcqRightsHoldbackCode = AcqRightsHoldbackCode + "," + objRHB.Acq_Deal_Rights_Holdback_Code.ToString();
            }
            else
            {
                AcqRightsHoldbackCode = objRHB.Acq_Deal_Rights_Holdback_Code.ToString();
            }

            count = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Deal_Rights_Holdback_Validation(AcqRightsHoldbackCode, strSelectedPlatformCode, strSelectedCountryTerritory_HBCode, Title_Codes, objDeal_Schema.Deal_Type_Code, strTitleLanguage, strSelectedubbing, strSelectedSubTitling, objDeal_Schema.Rights_Is_Exclusive).FirstOrDefault().Rec_Count;
            if (count > 0)
            {
                IsBreak = "Y";
            }
            if (objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted).Count() > 0)
            {
                try
                {
                    var vHoldback = from Acq_Deal_Rights_Holdback objHB in objAcq_Deal_Rights.Acq_Deal_Rights_Holdback
                                    where objHB != objRHB && objHB.EntityState != State.Deleted
                                    select objHB;

                    string[] arrSelectedPlatformCode = strSelectedPlatformCode.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    string[] arrSelectedCountryTerritoryCode = strSelectedCountryTerritory_HBCode.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    string[] arrSelectedSubTitling = strSelectedSubTitling.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    string[] arrSelectedDubbingCodes = strSelectedubbing.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);


                    foreach (Acq_Deal_Rights_Holdback objHB in vHoldback)
                    {

                        var arrWrapperPlatform = (from Acq_Deal_Rights_Holdback_Platform objPlatform in objHB.Acq_Deal_Rights_Holdback_Platform
                                                  where objPlatform.EntityState != State.Deleted
                                                  select objPlatform.Platform_Code.ToString()).ToArray();

                        var listCommon = arrWrapperPlatform.Where(arrSelectedPlatformCode.Contains);

                        if (listCommon.Count() > 0)
                        {
                            var arrWrapperCountryTerritory = (from Acq_Deal_Rights_Holdback_Territory objTerritory in objHB.Acq_Deal_Rights_Holdback_Territory where objTerritory.EntityState != State.Deleted select objTerritory.Country_Code.ToString()).ToArray();
                            var listCommonCountry = arrWrapperCountryTerritory.Where(arrSelectedCountryTerritoryCode.Contains);

                            if (listCommonCountry.Count() > 0)
                            {
                                if (strTitleLanguage == "Y" && objHB.Is_Title_Language_Right == "Y")
                                {
                                    IsBreak = "Y";
                                    break;
                                }

                                if (arrSelectedSubTitling.Length > 0)
                                {
                                    var arrWrapperSubtitlingCodes = (from Acq_Deal_Rights_Holdback_Subtitling objSubTitling in objHB.Acq_Deal_Rights_Holdback_Subtitling where objSubTitling.EntityState != State.Deleted select objSubTitling.Language_Code.ToString()).ToArray();
                                    var listCommonSubtitling = arrWrapperSubtitlingCodes.Where(arrSelectedSubTitling.Contains);

                                    if (listCommonSubtitling.Count() > 0)
                                    {
                                        IsBreak = "Y";
                                        break;
                                    }
                                }

                                if (arrSelectedDubbingCodes.Length > 0)
                                {
                                    var arrWrapperDubbingCodes = (from Acq_Deal_Rights_Holdback_Dubbing objDubbing in objHB.Acq_Deal_Rights_Holdback_Dubbing where objDubbing.EntityState != State.Deleted select objDubbing.Language_Code.ToString()).ToArray();
                                    var listCommonDubbing = arrWrapperDubbingCodes.Where(arrSelectedDubbingCodes.Contains);
                                    if (listCommonDubbing.Count() > 0)
                                    {
                                        IsBreak = "Y";
                                        break;
                                    }
                                }
                            }
                        }
                    }

                    if (IsBreak == "Y")
                        IsValidate = false;
                }

                catch (Exception e)
                { }
            }

            if (IsBreak == "Y")
                IsValidate = false;
            //if (!IsValidate)
            //CreateMessageAlert("Holdback combination already added.");

            return IsValidate;
        }
        #endregion
        #region==================Edit Holdback=======================
        public PartialViewResult Edit_Holdback(string R_Type, string SL_Type, string DL_Type, string R_Code, string SL_Code, string DL_Code, string DummyProperty, string Titles, string Period, string IsTentative, string PeriodTerm, string strPlatform, string title_Code, string Is_Exclusive)
        {
            Title_Codes = title_Code;
            string regionCodes = "";
            int countP = 0;
            var countC = 0;
            var countT = 0;
            objDeal_Schema.Rights_Is_Exclusive = Is_Exclusive;
            USP_Service objService = new USP_Service(objLoginEntity.ConnectionStringName);
            //    objService.USP_CheckIfTitleReleaseDateExist()

            string platcode = "";
            ViewBag.CommandName_HB = GlobalParams.DEAL_MODE_EDIT;
            ViewBag.DummyProperty = DummyProperty;
            ViewBag.IsAddEditMode = "Y";
            Acq_Deal_Rights_Holdback obj = objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
            if (obj != null)
            {
                Set_AllViewBag(obj, R_Type, SL_Type, DL_Type, R_Code, SL_Code, DL_Code, DummyProperty);
            }
            if (obj.Holdback_On_Platform_Code != null)
                ViewBag.HoldbackOnPlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Applicable_For_Holdback == "Y").ToList(), "Platform_Code", "Platform_Name", obj.Holdback_On_Platform_Code.Value.ToString().Split(','));
            else
                ViewBag.HoldbackOnPlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Applicable_For_Holdback == "Y").ToList(), "Platform_Code", "Platform_Name");

            ViewBag.Title = Titles;
            ViewBag.Period = Period;
            ViewBag.IsTentative = IsTentative;
            ViewBag.PeriodTerm = PeriodTerm;

            if (obj.Holdback_Type == "R")
            {
                int?[] Title_Code = new Acq_Deal_Rights_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Rights_Code == (int)obj.Acq_Deal_Rights_Code).Select(x => (int?)x.Title_Code).ToArray();
                int?[] Title_Release_Code = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(x => Title_Code.Contains(x.Title_Code)).Select(x => (int?)x.Title_Release_Code).ToArray();
                //string ReleaseType = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == Title_Code).Select(x => x.Release_Type).FirstOrDefault();
                string[] platformCount = new Title_Release_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => Title_Release_Code.Contains(x.Title_Release_Code)).Select(x => x.Platform_Code.ToString()).ToArray();

                int?[] TerritoryCount = new Title_Release_Region_Service(objLoginEntity.ConnectionStringName).SearchFor(x => Title_Release_Code.Contains(x.Title_Release_Code)).Select(x => x.Territory_Code).ToArray();

                int?[] CountryCount = new Title_Release_Region_Service(objLoginEntity.ConnectionStringName).SearchFor(x => Title_Release_Code.Contains(x.Title_Release_Code)).Select(x => x.Country_Code).ToArray();

                string[] Territorycountrycode = new Territory_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => TerritoryCount.Contains(x.Territory_Code)).Select(x => x.Country_Code.ToString()).ToArray();
                string[] RegionCode = obj.Acq_Deal_Rights_Holdback_Territory.Where(x => CountryCount.Contains(x.Country_Code)).Select(x => x.Country_Code.ToString()).ToArray();
                string[] Territorycountrycode1 = obj.Acq_Deal_Rights_Holdback_Territory.Where(x => Territorycountrycode.Contains(x.Country_Code.ToString())).Select(x => x.Country_Code.ToString()).ToArray();

                string HPCode = obj.Holdback_On_Platform_Code.ToString();

                if (platformCount.Count() == 1)
                {
                    platcode = platformCount.ElementAt(0);
                }
                else if (platformCount.Count() > 1)
                {
                    for (int i = 0; i < platformCount.Count(); i++)
                    {
                        platcode = platcode + platformCount.ElementAt(i) + ",";
                    }
                    platcode = platcode.Remove(platcode.Length - 1);
                }
                var count = platcode.Contains(HPCode);

                if (RegionCode.Count() == 1)
                {
                    regionCodes = RegionCode.ElementAt(0);
                }
                else if (RegionCode.Count() > 1)
                {
                    for (int i = 0; i < RegionCode.Count(); i++)
                    {
                        regionCodes = regionCodes + RegionCode.ElementAt(i) + ",";
                    }
                    regionCodes = regionCodes.Remove(regionCodes.Length - 1);
                }
                if (Territorycountrycode1.Count() == 1)
                {
                    regionCodes = Territorycountrycode1.ElementAt(0);
                }
                else if (Territorycountrycode1.Count() > 1)
                {
                    regionCodes = "";
                    for (int i = 0; i < Territorycountrycode1.Count(); i++)
                    {
                        regionCodes = regionCodes + Territorycountrycode1.ElementAt(i) + ",";
                    }
                    regionCodes = regionCodes.Remove(regionCodes.Length - 1);
                }
                if (count == true)
                {
                    countP = 1;
                }
                //if (HPCode == platcode.Contains(HPCode).)
                //{
                //    count = 1;
                //}
                //var count = obj.Where(x => platformCount.Contains(x.Platform_Code)).Count();

                if (Territorycountrycode.Count() > 0)
                {
                    countT = obj.Acq_Deal_Rights_Holdback_Territory.Where(x => Territorycountrycode.Contains(x.Country_Code.ToString())).Count();
                }
                if (RegionCode.Count() > 0)
                {
                    countC = obj.Acq_Deal_Rights_Holdback_Territory.Where(x => CountryCount.Contains(x.Country_Code)).Count();
                }
            }
            if (countP > 0 && (countC > 0 || countT > 0))
            {
                ViewBag.RegionCode = 1;
            }
            else
            {
                ViewBag.RegionCode = null;
            }
            //}
            //else
            //{
            //    ViewBag.RegionCode = null;
            //}
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            //string strPlatform = "";
            //strPlatform = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Where(t => t.EntityState != State.Deleted).Select(t => t.Platform_Code.ToString()));
            string[] strSelectedPlatform = obj.Acq_Deal_Rights_Holdback_Platform.Where(t => t.EntityState != State.Deleted).Select(t => t.Platform_Code.ToString()).ToArray();
            objPTV.PlatformCodes_Display = strPlatform;
            objPTV.PlatformCodes_Selected = strSelectedPlatform;
            //if (count > 0 && (countC > 0 || countT > 0))
            //{
            //    ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            //}
            //else
            //{
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            // }
            if (obj.Holdback_On_Platform_Code != null)
            {
                ViewBag.Holdback_On_Platform_Code = obj.Holdback_On_Platform_Code.Value.ToString();
            }
            else
            {
                ViewBag.Holdback_On_Platform_Code = 0;
            }
            ViewBag.TreeId = "Rights_HB_Platform";
            ViewBag.TreeValueId = "hdnPlatform_Codes_HB";
            ViewBag.SelectedPlatForm = string.Join(",", strSelectedPlatform);
            ViewBag.CountryCode = string.Join(",", obj.strCountryCodes);
            ViewBag.RegionCode = regionCodes;
            ViewBag.Key = "U";
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_Holdback_Popup.cshtml", obj);
        }
        public PartialViewResult View_Holdback(string DummyProperty)
        {
            USP_Service objService = new USP_Service(objLoginEntity.ConnectionStringName);

            ViewBag.DummyProperty = DummyProperty;
            ViewBag.IsAddEditMode = "Y";
            Acq_Deal_Rights_Holdback obj = objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
            string AcqDealHoldbackCode = obj.Acq_Deal_Rights_Holdback_Code.ToString();
            List<USP_Acq_Deal_Rights_Holdback_Release_Result> lstADRH = new List<USP_Acq_Deal_Rights_Holdback_Release_Result>();
            lstADRH = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Deal_Rights_Holdback_Release(AcqDealHoldbackCode).ToList();
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_Holdback_Release_Popup.cshtml", lstADRH);
        }
        #region==================Delete Holdback=======================
        public JsonResult Delete_Holdback(string DummyProperty)
        {
            string msg = "D";
            Acq_Deal_Rights_Holdback objRHB = objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
            objRHB.EntityState = State.Deleted;
            if (objRHB.Acq_Deal_Rights_Holdback_Code > 0)
                SetDeleteObject_HB(objRHB);
            else
                objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Remove(objRHB);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("status", msg);
            obj.Add("count", objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Count());
            return Json(obj);
        }
        #endregion
        private void SetDeleteObject_HB(Acq_Deal_Rights_Holdback objRHB)
        {
            foreach (Acq_Deal_Rights_Holdback_Platform objADRHP in objRHB.Acq_Deal_Rights_Holdback_Platform) objADRHP.EntityState = State.Deleted;
            foreach (Acq_Deal_Rights_Holdback_Subtitling objADRS in objRHB.Acq_Deal_Rights_Holdback_Subtitling) objADRS.EntityState = State.Deleted;
            foreach (Acq_Deal_Rights_Holdback_Dubbing objADRHD in objRHB.Acq_Deal_Rights_Holdback_Dubbing) objADRHD.EntityState = State.Deleted;
            foreach (Acq_Deal_Rights_Holdback_Territory objADRHT in objRHB.Acq_Deal_Rights_Holdback_Territory) objADRHT.EntityState = State.Deleted;
        }
        #endregion
        #region==================Add Holdback=======================
        private void Set_AllViewBag(Acq_Deal_Rights_Holdback obj, string R_Type, string SL_Type, string DL_Type, string R_Code, string SL_Code, string DL_Code, string DummyProperty)
        {
            ViewBag.Territory_List_HB = R_Type == "G" || R_Type == "T" ? BindCountry_UsingTerritoryCodes_List(objAcq_Deal_Rights.Is_Theatrical_Right, obj.strCountryCodes, R_Code) : BindCountry_List(objAcq_Deal_Rights.Is_Theatrical_Right, obj.strCountryCodes, R_Code);
            int Selected_HB_Run_After_Release_Unit = (obj.HB_Run_After_Release_Units == null || obj.HB_Run_After_Release_Units == "") ? 0 : Convert.ToInt32(obj.HB_Run_After_Release_Units);
            ViewBag.HB_Run_After_Release_Unit = Bind_HB_Run_After_Release_Unit(Selected_HB_Run_After_Release_Unit);
            ViewBag.SL_List_HB = SL_Type == "SG" || SL_Type == "G" ? BindLang_UsingLangGroupCodes_List(obj.strSubtitlingCodes, SL_Code) : BindLanguage_List(obj.strSubtitlingCodes, SL_Code);
            ViewBag.DL_List_HB = DL_Type == "DG" || DL_Type == "G" ? BindLang_UsingLangGroupCodes_List(obj.strDubbingCodes, DL_Code) : BindLanguage_List(obj.strDubbingCodes, DL_Code);
            if (obj.strCountryCodes != "")
                ViewBag.RCountHB = obj.strCountryCodes.Split(',').Count();
        }
        public PartialViewResult Add_Holdback(string R_Type, string SL_Type, string DL_Type, string R_Code, string SL_Code, string DL_Code, string Titles, string Period, string IsTentative, string PeriodTerm, string strPlatform, string title_Code, string Is_Exclusive)
        {
            Title_Codes = title_Code;
            ViewBag.CommandName_HB = "ADD";
            ViewBag.IsAddEditMode = "Y";
            Set_AllViewBag(new Acq_Deal_Rights_Holdback(), R_Type, SL_Type, DL_Type, R_Code, SL_Code, DL_Code, "");
            ViewBag.HoldbackOnPlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Applicable_For_Holdback == "Y").ToList(), "Platform_Code", "Platform_Name");
            ViewBag.Title = Titles;
            ViewBag.Period = Period;
            ViewBag.IsTentative = IsTentative;
            ViewBag.PeriodTerm = PeriodTerm;
            ViewBag.Key = "A";
            ViewBag.Holdback_On_Platform_Code = "";
            objDeal_Schema.Rights_Is_Exclusive = Is_Exclusive;
            if (!string.IsNullOrEmpty(strPlatform))
            {
                Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
                objPTV.PlatformCodes_Display = strPlatform;
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
                ViewBag.DummyProperty = "0";
                ViewBag.TreeId = "Rights_HB_Platform";
                ViewBag.TreeValueId = "hdnPlatform_Codes_HB";
            }
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_Holdback_Popup.cshtml", new Acq_Deal_Rights_Holdback());
        }

        public JsonResult Bind_Ddl_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            var lst_HoldbackOnPlatform = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Applicable_For_Holdback == "Y").ToList();
            MultiSelectList HoldbackOnPlatform = new MultiSelectList(lst_HoldbackOnPlatform.Select(i => new { Display_Value = i.Platform_Code, Display_Text = i.Platform_Name + '~' + i.Platform_Hiearachy }),
                "Display_Value", "Display_Text");
            objJson.Add("HoldbackOnPlatform", HoldbackOnPlatform);
            return Json(objJson);
        }
        #endregion
        #region==================Save Holdback=======================
        // string hdn_Is_Title_Language_Right_HB, string hdnCountry_Territory_HB, string hdnSubtitling_HB, string hdnDubbing_HB
        public JsonResult Save_Holdback(string hdnCounter, string hdnHoldback_Platform_Code, string Regions, string chk_Is_Title_Language_Right, string hdn_Sub_LanguageList, string hdn_Dubb_LanguageList, string HoldbackType, string HB_Run_After_Release_No, string lstReleaseUnit, string hdnHoldBackOnPlatform, string Holdback_Release_Date, string Holdback_Comment)
        {
            string msg = string.Empty;
            Acq_Deal_Rights_Holdback objRHB = null;
            if (hdnCounter != "0")
            {
                msg = "U";
                objRHB = objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.strDummyProp == hdnCounter).FirstOrDefault();
                if (objRHB.Acq_Deal_Rights_Holdback_Code > 0)
                    objRHB.EntityState = State.Modified;
            }
            else
            {
                objRHB = new Acq_Deal_Rights_Holdback();
                objRHB.EntityState = State.Added;
                msg = "A";
            }
            // Acq_Deal_Rights_Holdback objRHB = objAcqDealRights.Acq_Deal_Rights_Holdback.Where(t => t.strDummyProp == strDummyProp).FirstOrDefault();

            if (ValidateduplicateHoldback(hdnHoldback_Platform_Code, Regions, chk_Is_Title_Language_Right, hdn_Sub_LanguageList, hdn_Dubb_LanguageList, objRHB))
            {

                //if (objRHB != null && hdnCounter != "0")
                //    SetDeleteObject_HB(objRHB);
                if (hdnHoldback_Platform_Code != "")
                {
                    hdnHoldback_Platform_Code = hdnHoldback_Platform_Code.Trim().Replace("_", "").Replace(" ", "").Replace("_0", "").Trim();
                    string[] PtCodes = hdnHoldback_Platform_Code.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Distinct().ToArray();
                    ICollection<Acq_Deal_Rights_Holdback_Platform> selectPlatformList = new HashSet<Acq_Deal_Rights_Holdback_Platform>();
                    foreach (string platformCode in PtCodes)
                    {
                        int pltCode = Convert.ToInt32(platformCode);
                        if (pltCode > 0)
                        {
                            Acq_Deal_Rights_Holdback_Platform objP = new Acq_Deal_Rights_Holdback_Platform();
                            objP.Platform_Code = Convert.ToInt32(platformCode);
                            objP.EntityState = State.Added;
                            selectPlatformList.Add(objP);
                        }
                    }

                    IEqualityComparer<Acq_Deal_Rights_Holdback_Platform> comparerSub = new LambdaComparer<Acq_Deal_Rights_Holdback_Platform>((x, y) => x.Platform_Code == y.Platform_Code && x.EntityState != State.Deleted);
                    var Deleted_Acq_Deal_Rights_Holdback_Platform = new List<Acq_Deal_Rights_Holdback_Platform>();
                    var Updated_Acq_Deal_Rights_Holdback_Platform = new List<Acq_Deal_Rights_Holdback_Platform>();
                    var Added_Acq_Deal_Rights_Holdback_Platform = CompareLists<Acq_Deal_Rights_Holdback_Platform>(selectPlatformList.ToList<Acq_Deal_Rights_Holdback_Platform>(), objRHB.Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>(), comparerSub, ref Deleted_Acq_Deal_Rights_Holdback_Platform, ref Updated_Acq_Deal_Rights_Holdback_Platform);
                    Added_Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(t => objRHB.Acq_Deal_Rights_Holdback_Platform.Add(t));
                    Deleted_Acq_Deal_Rights_Holdback_Platform.ToList<Acq_Deal_Rights_Holdback_Platform>().ForEach(t => t.EntityState = State.Deleted);
                }
                if (Regions != "")
                {
                    ICollection<Acq_Deal_Rights_Holdback_Territory> selectTerritoryList = new HashSet<Acq_Deal_Rights_Holdback_Territory>();
                    string[] countryCodes = Regions.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string platformCode in countryCodes)
                    {
                        Acq_Deal_Rights_Holdback_Territory objT = new Acq_Deal_Rights_Holdback_Territory();
                        objT.Country_Code = Convert.ToInt32(platformCode);
                        objT.Territory_Type = "I";
                        objT.EntityState = State.Added;
                        selectTerritoryList.Add(objT);
                    }

                    IEqualityComparer<Acq_Deal_Rights_Holdback_Territory> comparer_Territory = new LambdaComparer<Acq_Deal_Rights_Holdback_Territory>((x, y) => x.Country_Code == y.Country_Code && x.Territory_Type == y.Territory_Type && x.EntityState != State.Deleted);
                    var Deleted_Acq_Deal_Rights_Holdback_Territory = new List<Acq_Deal_Rights_Holdback_Territory>();
                    var Updated_Acq_Deal_Rights_Holdback_Territory = new List<Acq_Deal_Rights_Holdback_Territory>();
                    var Added_Acq_Deal_Rights_Holdback_Territory = CompareLists<Acq_Deal_Rights_Holdback_Territory>(selectTerritoryList.ToList<Acq_Deal_Rights_Holdback_Territory>(), objRHB.Acq_Deal_Rights_Holdback_Territory.ToList<Acq_Deal_Rights_Holdback_Territory>(), comparer_Territory, ref Deleted_Acq_Deal_Rights_Holdback_Territory, ref Updated_Acq_Deal_Rights_Holdback_Territory);
                    Added_Acq_Deal_Rights_Holdback_Territory.ToList<Acq_Deal_Rights_Holdback_Territory>().ForEach(t => objRHB.Acq_Deal_Rights_Holdback_Territory.Add(t));
                    Deleted_Acq_Deal_Rights_Holdback_Territory.ToList<Acq_Deal_Rights_Holdback_Territory>().ForEach(t => t.EntityState = State.Deleted);
                }


                ICollection<Acq_Deal_Rights_Holdback_Subtitling> selectSubtitlingList = new HashSet<Acq_Deal_Rights_Holdback_Subtitling>();
                if (!string.IsNullOrEmpty(hdn_Sub_LanguageList))
                {
                    string[] subtitlingCodes = hdn_Sub_LanguageList.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string languageCode in subtitlingCodes)
                    {
                        Acq_Deal_Rights_Holdback_Subtitling objSL = new Acq_Deal_Rights_Holdback_Subtitling();
                        objSL.Language_Code = Convert.ToInt32(languageCode);
                        objSL.EntityState = State.Added;
                        selectSubtitlingList.Add(objSL);
                    }
                }

                IEqualityComparer<Acq_Deal_Rights_Holdback_Subtitling> comparer_Subtitling = new LambdaComparer<Acq_Deal_Rights_Holdback_Subtitling>((x, y) => x.Language_Code == y.Language_Code && x.EntityState != State.Deleted);
                var Deleted_Acq_Deal_Rights_Holdback_Subtitling = new List<Acq_Deal_Rights_Holdback_Subtitling>();
                var Updated_Acq_Deal_Rights_Holdback_Subtitling = new List<Acq_Deal_Rights_Holdback_Subtitling>();
                var Added_Acq_Deal_Rights_Holdback_Subtitling = CompareLists<Acq_Deal_Rights_Holdback_Subtitling>(selectSubtitlingList.ToList<Acq_Deal_Rights_Holdback_Subtitling>(), objRHB.Acq_Deal_Rights_Holdback_Subtitling.ToList<Acq_Deal_Rights_Holdback_Subtitling>(), comparer_Subtitling, ref Deleted_Acq_Deal_Rights_Holdback_Subtitling, ref Updated_Acq_Deal_Rights_Holdback_Subtitling);
                Added_Acq_Deal_Rights_Holdback_Subtitling.ToList<Acq_Deal_Rights_Holdback_Subtitling>().ForEach(t => objRHB.Acq_Deal_Rights_Holdback_Subtitling.Add(t));
                Deleted_Acq_Deal_Rights_Holdback_Subtitling.ToList<Acq_Deal_Rights_Holdback_Subtitling>().ForEach(t => t.EntityState = State.Deleted);

                ICollection<Acq_Deal_Rights_Holdback_Dubbing> selectDubbingList = new HashSet<Acq_Deal_Rights_Holdback_Dubbing>();
                if (!string.IsNullOrEmpty(hdn_Dubb_LanguageList))
                {
                    string[] dubbingCodes = hdn_Dubb_LanguageList.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string languageCode in dubbingCodes)
                    {
                        Acq_Deal_Rights_Holdback_Dubbing objDL = new Acq_Deal_Rights_Holdback_Dubbing();
                        objDL.Language_Code = Convert.ToInt32(languageCode);
                        objDL.EntityState = State.Added;
                        selectDubbingList.Add(objDL);
                    }
                }


                IEqualityComparer<Acq_Deal_Rights_Holdback_Dubbing> comparerDub = new LambdaComparer<Acq_Deal_Rights_Holdback_Dubbing>((x, y) => x.Language_Code == y.Language_Code && x.EntityState != State.Deleted);
                var Deleted_Acq_Deal_Rights_Holdback_Dubbing = new List<Acq_Deal_Rights_Holdback_Dubbing>();
                var Updated_Acq_Deal_Rights_Holdback_Dubbing = new List<Acq_Deal_Rights_Holdback_Dubbing>();
                var Added_Acq_Deal_Rights_Holdback_Dubbing = CompareLists<Acq_Deal_Rights_Holdback_Dubbing>(selectDubbingList.ToList<Acq_Deal_Rights_Holdback_Dubbing>(), objRHB.Acq_Deal_Rights_Holdback_Dubbing.ToList<Acq_Deal_Rights_Holdback_Dubbing>(), comparerDub, ref Deleted_Acq_Deal_Rights_Holdback_Dubbing, ref Updated_Acq_Deal_Rights_Holdback_Dubbing);
                Added_Acq_Deal_Rights_Holdback_Dubbing.ToList<Acq_Deal_Rights_Holdback_Dubbing>().ForEach(t => objRHB.Acq_Deal_Rights_Holdback_Dubbing.Add(t));
                Deleted_Acq_Deal_Rights_Holdback_Dubbing.ToList<Acq_Deal_Rights_Holdback_Dubbing>().ForEach(t => t.EntityState = State.Deleted);

                objRHB.Is_Title_Language_Right = chk_Is_Title_Language_Right;
                objRHB.Holdback_Type = HoldbackType;
                objRHB.HB_Run_After_Release_No = null;
                objRHB.HB_Run_After_Release_Units = null;
                objRHB.Holdback_On_Platform_Code = null;
                objRHB.Holdback_Release_Date = null;

                if (HoldbackType == "R")
                {
                    if (!string.IsNullOrEmpty(HB_Run_After_Release_No))
                        objRHB.HB_Run_After_Release_No = Convert.ToInt32(HB_Run_After_Release_No);
                    objRHB.HB_Run_After_Release_Units = lstReleaseUnit;
                    if (!string.IsNullOrEmpty(hdnHoldBackOnPlatform))
                        objRHB.Holdback_On_Platform_Code = Convert.ToInt32(hdnHoldBackOnPlatform);
                }
                else
                {
                    if (Holdback_Release_Date != "")
                        objRHB.Holdback_Release_Date = Convert.ToDateTime(Holdback_Release_Date);
                }
                objRHB.Holdback_Comment = Holdback_Comment;
                objRHB.Acq_Deal_Rights_Code = objAcq_Deal_Rights.Acq_Deal_Rights_Code;
                if (hdnCounter == "0")
                    objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Add(objRHB);
            }
            else
                msg = "D";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", msg);
            return Json(obj);
        }
        #endregion
        #region===============Bind Dropdown==============
        public PartialViewResult BindPlatform_HB(string hdnPlatform_Codes_HB = "", string dummyProperty = "0", string CallFrom = "")
        {
            SetPlatform_HB(hdnPlatform_Codes_HB, dummyProperty, CallFrom);
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            return PartialView("_TV_Platform");
        }
        private void SetPlatform_HB(string hdnPlatform_Codes_HB, string dummyProperty, string CallFrom)
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string strPlatform = "";
            if (CallFrom != "LIST")
            {
                strPlatform = string.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Where(t => t.EntityState != State.Deleted).Select(t => t.Platform_Code.ToString()));
                objPTV.PlatformCodes_Selected = hdnPlatform_Codes_HB.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                objPTV.PlatformCodes_Display = strPlatform;
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            }
            else
            {
                objPTV.PlatformCodes_Selected = hdnPlatform_Codes_HB.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                objPTV.PlatformCodes_Display = hdnPlatform_Codes_HB;
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            }

            ViewBag.TreeId = "Rights_HB_Platform_View";
            ViewBag.TreeValueId = "hdnPlatform_Codes_HB_View";
        }

        public PartialViewResult BindHoldback()
        {

            if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_VIEW || objPage_Properties.RMODE == GlobalParams.DEAL_MODE_APPROVE)
                ViewBag.CommandName_HB = objPage_Properties.RMODE;
            else
                ViewBag.CommandName_HB = "LIST";

            if (objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted && t.Is_Title_Language_Right == "Y").Count() > 0)
                ViewBag.Title_Language_Added_For_Holdback = "Y";
            else
                ViewBag.Title_Language_Added_For_Holdback = "N";


            var Title_Code = new Acq_Deal_Rights_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Rights_Code == (int)objAcq_Deal_Rights.Acq_Deal_Rights_Code).Select(x => x.Title_Code).FirstOrDefault();
            int Title_Release_Code = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == Title_Code).Select(x => x.Title_Release_Code).FirstOrDefault();

            var platformCount = new Title_Release_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Release_Code == Title_Release_Code).Select(x => x.Platform_Code).ToArray();
            var count = objAcq_Deal_Rights.Acq_Deal_Rights_Platform.Where(x => platformCount.Contains(x.Platform_Code)).Count();
            if (count > 0)
                ViewBag.Count = count;

            //ViewBag.HoldBackOnPlatform = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s =>  objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault()).ToList();

            objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted);
            return PartialView("~/Views/Acq_Deal/_Acq_Rights_Holdback.cshtml", new Acq_Deal_Rights_Holdback());
        }

        private MultiSelectList BindCountry_List(string Is_Thetrical = "N", string Selected_Country_Code = "", string Search_Country_Code = "")
        {
            string[] arr = new string[] { "" };
            if (Search_Country_Code != null && Search_Country_Code.Trim() != "")
                arr = Search_Country_Code.Split(',');
            MultiSelectList arr_Title_List = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(i => (i.Is_Active == "Y" && i.Is_Theatrical_Territory == Is_Thetrical) && (arr.Contains(i.Country_Code.ToString())))
                .Select(i => new { Country_Code = i.Country_Code, Country_Name = i.Country_Name }).ToList(), "Country_Code", "Country_Name", Selected_Country_Code.Split(','));
            ViewBag.CountryCode = Selected_Country_Code;
            return arr_Title_List;
        }
        private MultiSelectList BindCountry_UsingTerritoryCodes_List(string Is_Thetrical = "N", string Selected_Country_Code = "", string Search_Territory_Code = "")
        {
            string[] arr_Terr = new string[] { "" };
            if (Search_Territory_Code != null && Search_Territory_Code.Trim() != "")
                arr_Terr = Search_Territory_Code.Split(',');
            MultiSelectList arr_country = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName)
                                                                .SearchFor(x =>
                                                                            x.Territory_Details
                                                                            .Any(y => y.Country_Code == x.Country_Code && arr_Terr
                                                                            .Contains(y.Territory_Code.ToString()))
                                                                            && x.Is_Theatrical_Territory == Is_Thetrical
                                                                           )
                                                                .Select(i => new { Country_Code = i.Country_Code, Country_Name = i.Country_Name })
                                                                .OrderBy(t => t.Country_Name).ToList(), "Country_Code", "Country_Name", Selected_Country_Code.Split(',')
                                                                );
            return arr_country;
        }
        private MultiSelectList BindLang_UsingLangGroupCodes_List(string Selected_Language_Code = "", string Search_Lang_Code = "")
        {
            string[] arr_Language_Group_Code = new string[] { "" };
            if (Search_Lang_Code != null && Search_Lang_Code.Trim() != "")
                arr_Language_Group_Code = Search_Lang_Code.Split(',');
            MultiSelectList arr_lang = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName)
                                 .SearchFor(x => x.Language_Group_Details
                                             .Any(y => y.Language_Code == x.Language_Code && arr_Language_Group_Code.Contains(y.Language_Group_Code.ToString()))
                                           )
                                 .Select(i => new { Language_Code = i.Language_Code, Language_Name = i.Language_Name })
                                 .OrderBy(t => t.Language_Name).ToList(), "Language_Code", "Language_Name", Selected_Language_Code.Split(',')
                                 );
            return arr_lang;
        }
        private MultiSelectList BindLanguage_List(string Selected_Language_Code = "", string Search_Lang_Code = "")
        {
            string[] arr = new string[] { "" };
            if (Search_Lang_Code != null && Search_Lang_Code.Trim() != "")
                arr = Search_Lang_Code.Split(',');
            MultiSelectList arr_Title_List = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(i => (i.Is_Active == "Y") &&
                (arr.Contains(i.Language_Code.ToString()))).
                Select(i => new { Language_Code = i.Language_Code, Language_Name = i.Language_Name }).ToList(), "Language_Code", "Language_Name", Selected_Language_Code.Split(','));
            return arr_Title_List;
        }
        private SelectList Bind_HB_Run_After_Release_Unit(int selected_HB_Run_After_Release_Unit)
        {
            return new SelectList(new[]
                {
                    new { ID = "0", Name = "--Select--" },
                    new { ID = "1", Name = "Days" },
                    new { ID = "2", Name = "Weeks" },
                    new { ID = "3", Name = "Months"},
                    new { ID = "4", Name = "Years"}
                },
           "ID", "Name", selected_HB_Run_After_Release_Unit);
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
        #endregion

        public void ClearHoldbackGrid(string Is_Theatrical)
        {
            objAcq_Deal_Rights.Is_Theatrical_Right = Is_Theatrical;
            foreach (Acq_Deal_Rights_Holdback objADRH in objAcq_Deal_Rights.Acq_Deal_Rights_Holdback)
            {
                SetDeleteObject_HB(objADRH);
                objADRH.EntityState = State.Deleted;
            }
        }

        [HttpGet]
        public int? CheckIfTitleReleaseDateExist(string DummyProperty)
        {
            string holdBack_Code = string.Empty, holdBack_Country_Code = string.Empty, title_Code = string.Empty, Holdback_On_Platform_Code = string.Empty;
            Acq_Deal_Rights_Holdback obj = objAcq_Deal_Rights.Acq_Deal_Rights_Holdback.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();

            //holdBack_Code = Convert.ToString(obj.Acq_Deal_Rights_Holdback_Code);
            Holdback_On_Platform_Code = Convert.ToString(obj.Holdback_On_Platform_Code);
            holdBack_Country_Code = String.Join(",", obj.Acq_Deal_Rights_Holdback_Territory.Select(p => p.Country_Code.ToString()).ToArray());
            title_Code = String.Join(",", objAcq_Deal_Rights.Acq_Deal_Rights_Title.Select(p => p.Title_Code).ToArray());

            USP_Service objService = new USP_Service(objLoginEntity.ConnectionStringName);
            int? i = Convert.ToInt32(objService.USP_CheckIfTitleReleaseDateExist(title_Code, holdBack_Country_Code, Holdback_On_Platform_Code).ToList().FirstOrDefault().Value);
            return i;
        }


    }
}
