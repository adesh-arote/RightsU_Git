using System;
using RightsU_BLL;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Entities;
using RightsU_Dapper.Entity;
using UTOFrameWork.FrameworkClasses;
using System.Data.Entity.Core.Objects;
using RightsU_Dapper.BLL.Services;

namespace RightsU_Plus.Controllers
{
    public class Music_DealController : BaseController
    {
        private readonly Music_DealServices objMusic_Deal_Service = new Music_DealServices();
        private readonly System_Parameter_NewService objSPNService = new System_Parameter_NewService();
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.MUSIC_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.MUSIC_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.MUSIC_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.MUSIC_DEAL_SCHEMA] = value; }
        }
        private List<Music_Deal_Channel_Dapper> lstMDC
        {
            get
            {
                if (Session["lstMDC"] == null)
                    Session["lstMDC"] = new List<Music_Deal_Channel_Dapper>();
                return (List<Music_Deal_Channel_Dapper>)Session["lstMDC"];
            }
            set
            {
                Session["lstMDC"] = value;
            }
        }

        private List<Music_Deal_LinkShow_Dapper> lstMDLS
        {
            get
            {
                if (Session["lstMDLS"] == null)
                    Session["lstMDLS"] = new List<Music_Deal_LinkShow_Dapper>();
                return (List<Music_Deal_LinkShow_Dapper>)Session["lstMDLS"];
            }
            set
            {
                Session["lstMDLS"] = value;
            }
        }
        public Music_Deal_Dapper objMusicDeal
        {
            get
            {
                if (Session[RightsU_Session.SESS_MUSIC_DEAL] == null)
                    Session[RightsU_Session.SESS_MUSIC_DEAL] = new Music_Deal_Dapper();
                return (Music_Deal_Dapper)Session[RightsU_Session.SESS_MUSIC_DEAL];
            }
            set { Session[RightsU_Session.SESS_MUSIC_DEAL] = value; }
        }
        public string Mode
        {
            get
            {
                if (Session["Mode"] == null)
                    Session["Mode"] = string.Empty;
                return (string)Session["Mode"];
            }
            set { Session["Mode"] = value; }
        }
        private List<Music_Deal_Validation> lstMDV
        {
            get
            {
                if (Session["lstMDV"] == null)
                    Session["lstMDV"] = new List<Music_Deal_Validation>();
                return (List<Music_Deal_Validation>)Session["lstMDV"];
            }
            set
            {
                Session["lstMDV"] = value;
            }
        }

        public ActionResult Index()
        {
            ViewBag.Music_Platform_Tree = "";
            objMusicDeal = null;
            lstMDC = null;
            objDeal_Schema = null;
            ViewBag.Status_History = null;
            
            var MusicDealVersion = objSPNService.GetList()
                    .Where(s => s.Parameter_Name == "Music_Platform_Visibility")
                    .Select(w => w.Parameter_Value)
                    .SingleOrDefault();

            ViewBag.IsMuciVersionSPN = MusicDealVersion;
            var lstDealTag = new SelectList(new Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Deal_Tag_Code).ToList(), "Deal_Tag_Code", "Deal_Tag_Description");
            ViewBag.DealTagList = lstDealTag;

            Music_Deal_Service objservice = new Music_Deal_Service(objLoginEntity.ConnectionStringName);
            Mode = TempData["Mode"].ToString();
            TempData.Keep("Mode");
            ViewBag.RecordLockingCode = TempData["RecodLockingCode"];
            TempData.Keep("RecodLockingCode");
            int MusicDealCode = Convert.ToInt32(TempData["Music_Deal_Code"]);
            TempData.Keep("Music_Deal_Code");
            objDeal_Schema = null;

            if (MusicDealCode > 0)
            {
                Type[] RelationList = new Type[] { typeof(Music_Deal_DealType_Dapper)
                ,typeof(Music_Deal_Platform_Dapper)
                ,typeof(Music_Deal_Channel_Dapper)
                ,typeof(Music_Deal_Country_Dapper)
                ,typeof(Music_Deal_Language_Dapper)
                ,typeof(Music_Deal_LinkShow_Dapper)
                ,typeof(Music_Deal_Vendor_Dapper)
            };

                lstMDC = null;
                objMusicDeal = null;
                objMusicDeal = objMusic_Deal_Service.GetMusic_DealByID(MusicDealCode, RelationList);
                objDeal_Schema.Deal_Code = MusicDealCode;
                objDeal_Schema.Deal_Workflow_Flag = objMusicDeal.Deal_Workflow_Status;
                lstMDC.AddRange(objMusicDeal.Music_Deal_Channel);
                lstMDLS.AddRange(objMusicDeal.Music_Deal_LinkShow);
                string Music_Platform_Tree = string.Join(",", objMusicDeal.Music_Deal_Platform.Select(i => i.Music_Platform_Code).Distinct().ToList()); // Where(p => p.EntityState != State.Deleted)
                ViewBag.Music_Platform_Tree = Music_Platform_Tree;
            }

            if (string.IsNullOrEmpty(objMusicDeal.Channel_Or_Category))
                objMusicDeal.Channel_Or_Category = "C";

            if (Mode == GlobalParams.DEAL_MODE_AMENDMENT)
            {
                if (objMusicDeal.Deal_Workflow_Status == GlobalParams.dealWorkFlowStatus_Approved)
                {
                    objMusicDeal.Version = (Convert.ToInt32(Convert.ToDouble(objMusicDeal.Version)) + 1).ToString("0000");
                }
            }
            objDeal_Schema.Module_Rights_List = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objLoginUser.Security_Group_Code
                            && i.System_Module_Rights_Code == i.System_Module_Right.Module_Right_Code
                            && i.System_Module_Right.Module_Code == GlobalParams.ModuleCodeForMusicDeal)
                .Select(i => i.System_Module_Right.Right_Code).Distinct().ToList();

            ViewBag.EntityList = new SelectList(new Entity_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Entity_Code", "Entity_Name");

            string vendorCodes = string.Join(",", objMusicDeal.Music_Deal_Vendor.Select(x => x.Vendor_Code.ToString()).ToArray());
            ViewBag.VendorList = new MultiSelectList(new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Vendor_Name).ToList(), "Vendor_Code", "Vendor_Name", vendorCodes.Split(','));
            ViewBag.MusicLabelList = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Music_Label_Name).ToList(), "Music_Label_Code", "Music_Label_Name");

            string musicLangugaeCodes = string.Join(",", objMusicDeal.Music_Deal_Language.Select(x => x.Music_Language_Code.ToString()).ToArray());
            ViewBag.TrackLanguageList = new MultiSelectList(new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Language_Name).ToList(), "Music_Language_Code", "Language_Name", musicLangugaeCodes.Split(','));

            string channelCodes = string.Join(",", objMusicDeal.Music_Deal_Channel.Select(x => x.Channel_Code.ToString()).ToArray());
            ViewBag.ChannelList = new MultiSelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Channel_Name).ToList(), "Channel_Code", "Channel_Name", channelCodes.Split(','));

            string countryCodes = string.Join(",", objMusicDeal.Music_Deal_Country.Select(x => x.Country_Code.ToString()).ToArray());
            ViewBag.Country = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Country_Name).ToList(), "Country_Code", "Country_Name", countryCodes.Split(','));

            //string DealTypeCodes = string.Join(",", objMusicDeal.Music_Deal_DealType.Select(x => x.Deal_Type_Code.ToString()).ToArray());
            //ViewBag.DealTypeList = new MultiSelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName))

            ViewBag.ChannelCategoryList = new SelectList(new Channel_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y" && s.Type == "M").OrderBy(o => o.Channel_Category_Name).ToList(), "Channel_Category_Code", "Channel_Category_Name", objMusicDeal.Channel_Category_Code);

            //System_Parameter_New_Service objSPNService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);

            #region --- Business Unit List ---
            System_Parameter_New objSPN = objSPNService.GetList().Where(s => s.Parameter_Name == "BusinessUnitCodesForMusicDeal" && s.IsActive == "Y").FirstOrDefault();
            if (objSPN == null)
                objSPN = new System_Parameter_New();

            string strBuCodes = (objSPN.Parameter_Value ?? "");
            string[] arrBUCodes = strBuCodes.Split(',');

            ViewBag.BusinessUnitList = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"
               && (arrBUCodes.Contains(x.Business_Unit_Code.ToString()) || string.IsNullOrEmpty(strBuCodes))).
                SelectMany(s => s.Users_Business_Unit).Where(w => w.Users_Code == objLoginUser.Users_Code).
                Select(s => s.Business_Unit).ToList(), "Business_Unit_Code", "Business_Unit_Name");
            #endregion --- Business Unit List ---

            #region --- Deal Type List ---

            objSPN = objSPNService.GetList().Where(s => s.Parameter_Name == "DealTypeCodesForMusicDeal" && s.IsActive == "Y").FirstOrDefault();
            if (objSPN == null)
                objSPN = new System_Parameter_New();
            string strDealTypeCodes = string.Join(",", objSPN.Parameter_Value ?? "");
            string[] arrDealTypeCodes = strDealTypeCodes.Split(',');
            string dealTypeCodes = string.Join(",", objMusicDeal.Music_Deal_DealType.Select(x => x.Deal_Type_Code.ToString()).ToArray());

            ViewBag.DealTypeList = new MultiSelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                (arrDealTypeCodes.Contains(x.Deal_Type_Code.ToString()) || string.IsNullOrEmpty(strDealTypeCodes))).ToList(),
                "Deal_Type_Code", "Deal_Type_Name", dealTypeCodes.Split(','));


            //string channelCodes = string.Join(",", objMusicDeal.Music_Deal_Channel.Select(x => x.Channel_Code.ToString()).ToArray());
            //ViewBag.DealTypeList = new MultiSelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
            //    (arrDealTypeCodes.Contains(x.Deal_Type_Code.ToString()) || string.IsNullOrEmpty(strDealTypeCodes))).ToList(),
            //     "Deal_Type_Code", "Deal_Type_Name", channelCodes.Split(','));

            #endregion --- Deal Type List ---

            string Defaul_Right_Rule_Code = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Defaul_Right_Rule_Code" && x.IsActive == "Y").Select(x => x.Parameter_Value).FirstOrDefault();

            if (string.IsNullOrEmpty(Defaul_Right_Rule_Code))
                ViewBag.RightRule = new SelectList(new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Right_Rule_Name).ToList(), "Right_Rule_Code", "Right_Rule_Name");
            else
                ViewBag.RightRule = new SelectList(new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Right_Rule_Name).ToList(), "Right_Rule_Code", "Right_Rule_Name", Convert.ToInt32(Defaul_Right_Rule_Code));

            ViewBag.Status_History = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Status_History(MusicDealCode, GlobalParams.ModuleCodeForMusicDeal).ToList();
            int totalSeconds = Convert.ToInt32(objMusicDeal.Duration_Restriction);
            int second = totalSeconds % 60;
            int minutes = totalSeconds / 60;
            TimeSpan times = TimeSpan.Parse("00:" + minutes.ToString("00") + ":" + second.ToString("00") + "");
            //objMusicDeal.Duration = times;
            string viewPath = "~/Views/Music_Deal/Index.cshtml";
            string selectedCode = string.Join(",", objMusicDeal.Music_Deal_LinkShow.Select(s => s.Title_Code).ToArray());

            ViewBag.Mode = Mode;
            if (Mode == GlobalParams.DEAL_MODE_CLONE)
            {
                ViewBag.RecordLockingCode = 0;
                objMusicDeal.Music_Deal_Code = 0;
                objMusicDeal.Agreement_No = "";
                //objMusicDeal.Agreement_Date = DateTime.Now;
                objMusicDeal.Version = "0001";
                ViewBag.Status_History = new List<USP_List_Status_History_Result>();
                objMusicDeal.Music_Deal_Channel.Clear();
                objMusicDeal.Music_Deal_Country.Clear();
                objMusicDeal.Music_Deal_Language.Clear();
                objMusicDeal.Music_Deal_LinkShow.Clear();
                objMusicDeal.Music_Deal_Vendor.Clear();
            }
            else if (Mode == GlobalParams.DEAL_MODE_VIEW || Mode == GlobalParams.DEAL_MODE_APPROVE)
            {
                if (Mode == GlobalParams.DEAL_MODE_VIEW)
                    ViewBag.RecordLockingCode = 0;

                ViewBag.LinkShowList = GetLinkShowData(channelCodes, "", GlobalParams.DEAL_MODE_VIEW, selectedCode);
                viewPath = "~/Views/Music_Deal/View.cshtml";
            }
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicDeal);
            return View(viewPath, objMusicDeal);
        }
        public JsonResult GetRightRuleData(string rightRuleCode)
        {
            string dayStartTime = "", playPerday = "", durationOdDay = "", noOfRepeat = "";
            RightsU_Entities.Right_Rule objRightRule = new RightsU_Entities.Right_Rule();
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (rightRuleCode != "")
            {
                int RightRuleCode = Convert.ToInt32(rightRuleCode);
                objRightRule = new Right_Rule_Service(objLoginEntity.ConnectionStringName).GetById(RightRuleCode);
                if (objRightRule.IS_First_Air == true)
                    objRightRule.Start_Time = "From First Air";


                dayStartTime = objRightRule.Start_Time;
                playPerday = objRightRule.Play_Per_Day.ToString();
                durationOdDay = objRightRule.Duration_Of_Day.ToString();
                noOfRepeat = objRightRule.No_Of_Repeat.ToString();
            }
            objJson.Add("StartTime", dayStartTime);
            objJson.Add("PlayPerDay", playPerday);
            objJson.Add("Duration", durationOdDay);
            objJson.Add("NoofRepeat", noOfRepeat);
            return Json(objJson);
        }
        public JsonResult BindCountryList(string selectedCountryCodes)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            string[] arrChannelCode = lstMDC.Select(s => s.Channel_Code.ToString()).ToArray();
            dynamic lst = new Channel_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Where(x => arrChannelCode.Contains(x.Channel_Code.ToString()))
                .Select(x => new { Display_Value = x.Country.Country_Code, Display_Text = x.Country.Country_Name }).Distinct().ToList();
            obj.Add("Country", new SelectList(lst, "Display_Value", "Display_Text"));
            obj.Add("SelectedCode", selectedCountryCodes);
            return Json(obj);
        }
        public PartialViewResult BindChannelList()
        {
            return PartialView("~/Views/Music_Deal/_ChannelList.cshtml", lstMDC);
        }
        public PartialViewResult BindLinkShowList(string showName, string SelectedTitleCode, bool CalledOnLoad)
        {
            string strMode = Mode;
            if (Mode == GlobalParams.DEAL_MODE_APPROVE)
                strMode = GlobalParams.DEAL_MODE_VIEW;
            if (Mode == GlobalParams.DEAL_MODE_CLONE)
                strMode = GlobalParams.DEAL_MODE_ADD;

            string channelCode = string.Join(",", lstMDC.Select(s => s.Channel_Code).ToArray());

            if (CalledOnLoad)
                SelectedTitleCode = string.Join(",", lstMDLS.Select(s => s.Title_Code.ToString()).ToArray());
            lstMDLS = null;
            ViewBag.Mode = Mode;

            ViewBag.SelectedTitleCodes = SelectedTitleCode.Split(',');
            List<USP_Music_Deal_Link_Show_Result> objMDLSR = GetLinkShowData(channelCode, showName, strMode, SelectedTitleCode);
            return PartialView("~/Views/Music_Deal/_LinkShowList.cshtml", objMDLSR);
        }
        private List<USP_Music_Deal_Link_Show_Result> GetLinkShowData(string channelCode, string showName, string mode, string selectedTitleCodes)
        {
            List<USP_Music_Deal_Link_Show_Result> objMDLSR = objMusic_Deal_Service.USP_Music_Deal_Link_Show(channelCode, showName, mode, objMusicDeal.Music_Deal_Code, selectedTitleCodes).ToList();
            return objMDLSR;
        }
        public ActionResult SaveChannelWiseList(List<Music_Deal_Channel_Dapper> lst)
        {
            lstMDC = lst;
            return Json("S");
        }
        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult) where T : class
        {

            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);

            DelResult = DeleteResult.ToList<T>();

            return AddResult.ToList<T>();
        }


        public JsonResult Check_Platform(string Platform_Code)
        {
            bool isSelected = CheckPlatformConfig(Platform_Code);

            var obj = new
            {
                isError = isSelected
            };
            return Json(obj);
        }

        private bool CheckPlatformConfig(string PlatformCodes)
        {
            bool checkPFCodes = false;
            string[] PFCode = PlatformCodes.Split(',');
            string ConfigCodes = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Music_Deal_Platform_Codes").Select(s => s.Parameter_Value).FirstOrDefault();
            string[] ConfigPFCodes = ConfigCodes.Split(',');

            if (PFCode.Contains(ConfigPFCodes.ElementAt(0)) && PFCode.Contains(ConfigPFCodes.ElementAt(1)))
            {
                checkPFCodes = true;
            }
            //checkPFCodes = PFCode.Contains(ConfigPFCodes.ElementAt(0));

            //checkPFCodes = PFCode.Contains(ConfigPFCodes.ElementAt(0));
            if (PlatformCodes != "")
            {
                string[] ParentCode = new string[] { };
                if (!checkPFCodes)
                {
                    ParentCode = new Music_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => PFCode.Contains(s.Music_Platform_Code.ToString())).Select(s => s.Parent_Code.ToString()).ToArray();
                    if (ParentCode.Contains(ConfigPFCodes.ElementAt(0)) && ParentCode.Contains(ConfigPFCodes.ElementAt(1)))
                    {
                        checkPFCodes = true;
                    }
                    //checkPFCodes = ParentCode.Contains(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Music_Deal_Platform_Codes").ToList().FirstOrDefault().Parameter_Value);
                }

                if (!checkPFCodes && ParentCode.Length > 0)
                {
                    string ParentPlatformCode = string.Join(",", ParentCode.Distinct());
                    checkPFCodes = CheckPlatformConfig(ParentPlatformCode);
                }
            }

            return checkPFCodes;
        }



        public JsonResult Save(Music_Deal_Dapper objTempMusicDeal, FormCollection objForm)
        {
            string message = "";
            var MusicDealVersion = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "RU_Build").Select(w => w.Parameter_Value).SingleOrDefault();
            //ViewBag.IsMuciVersionSPN = MusicDealVersion;
            Music_Deal_Service objService = new Music_Deal_Service(objLoginEntity.ConnectionStringName);
            Music_Deal_Dapper objMusicDeal = new Music_Deal_Dapper();
            if (objTempMusicDeal.Music_Deal_Code > 0)
            {
                objMusicDeal = objMusic_Deal_Service.GetMusic_DealByID(objTempMusicDeal.Music_Deal_Code);
                //objMusicDeal.EntityState = State.Modified;
                if (objMusicDeal.Deal_Workflow_Status == GlobalParams.dealWorkFlowStatus_Approved)
                {
                    objMusicDeal.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Ammended;
                    objMusicDeal.Version = (Convert.ToInt32(Convert.ToDouble(objMusicDeal.Version)) + 1).ToString("0000");
                }
            }
            else
            {
                objMusicDeal.Version = "0001";
                //objMusicDeal.EntityState = State.Added;
                objMusicDeal.Inserted_By = objLoginUser.Users_Code;
                objMusicDeal.Inserted_On = DateTime.Now;
                objMusicDeal.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
            }

            if (objForm["hdnTVCodes"] != null && objForm["hdnTVCodes"] != "")
            {
                ICollection<Music_Deal_Platform_Dapper> MusicPlatformList = new HashSet<Music_Deal_Platform_Dapper>();
                string[] MusicPlatformCodes = objForm["hdnTVCodes"].Split(',').ToList<string>().ToArray();
                foreach (string Music_Platform_Code in MusicPlatformCodes)
                {
                    if (Music_Platform_Code != "0")
                    {
                        Music_Deal_Platform_Dapper obMDP = new Music_Deal_Platform_Dapper();
                        // obMDP.EntityState = State.Added;
                        obMDP.Music_Platform_Code = Convert.ToInt32(Music_Platform_Code);
                        MusicPlatformList.Add(obMDP);
                       
                    }
                }
                //Music_Deal_Platform_Dapper objnew = objMusicDeal.Music_Deal_Platform.Where(x => x.Music_Platform_Code == 68).FirstOrDefault();
                //objnew.Music_Platform_Code = 2;

                IEqualityComparer<Music_Deal_Platform_Dapper> comparerMusicPlatformGroup = new LambdaComparer<Music_Deal_Platform_Dapper>
                    ((x, y) => x.Music_Platform_Code == y.Music_Platform_Code);//&& x.EntityState != State.Deleted)
                var Deleted_MusicPlatform = new List<Music_Deal_Platform_Dapper>();
                var Updated_MusicPlatform = new List<Music_Deal_Platform_Dapper>();
                var Added_MusicPlatform = CompareLists<Music_Deal_Platform_Dapper>(MusicPlatformList.ToList<Music_Deal_Platform_Dapper>(), objMusicDeal.Music_Deal_Platform.ToList<Music_Deal_Platform_Dapper>(), comparerMusicPlatformGroup, ref Deleted_MusicPlatform, ref Updated_MusicPlatform);
                Added_MusicPlatform.ToList<Music_Deal_Platform_Dapper>().ForEach(t => objMusicDeal.Music_Deal_Platform.Add(t));
                //Deleted_MusicPlatform.ToList<Music_Deal_Platform>().ForEach(t => t.EntityState = State.Deleted);
                Deleted_MusicPlatform.ToList().ForEach(t => objMusicDeal.Music_Deal_Platform.Remove(t));
            }

            string primaryVendorCode = objForm["hdnPrimaryVendorCode"];
            string vendorCode = objForm["ddlLicensor"];
            string musicLanguageCode = objForm["ddlMusicLangugae"];
            string countryCode = objForm["ddlCountry"];
            string titleCodes = objForm["hdnTitleCodes"];
            string definedRunSong = objForm["txtSong"];
            string DealTypeCode = objForm["ddlDealTypeFor"];
            string RightRuleType = objForm["Right_Rule_Type"].ToString();

            objMusicDeal.Right_Rule_Type = RightRuleType;
            objMusicDeal.Description = objTempMusicDeal.Description;
            if (MusicDealVersion == "SPN")
                objMusicDeal.Deal_Tag_Code = null;
            else
                objMusicDeal.Deal_Tag_Code = objTempMusicDeal.Deal_Tag_Code;


            objMusicDeal.Reference_No = objTempMusicDeal.Reference_No;
            objMusicDeal.Entity_Code = objTempMusicDeal.Entity_Code;
            objMusicDeal.Agreement_Date = Convert.ToDateTime(objForm["Agreement_Date"]);
            if (primaryVendorCode != "")
                objMusicDeal.Primary_Vendor_Code = Convert.ToInt32(primaryVendorCode);

            objMusicDeal.Deal_Type_Code = objTempMusicDeal.Deal_Type_Code;
            objMusicDeal.Music_Label_Code = objTempMusicDeal.Music_Label_Code;
            objMusicDeal.Title_Type = objTempMusicDeal.Title_Type;
            if (objForm["Duration"] != null)
            {
                string duration_Restriction = objForm["Duration"];
                decimal seconds = Convert.ToDecimal(TimeSpan.Parse(duration_Restriction).TotalSeconds);
                objMusicDeal.Duration_Restriction = seconds;
            }
            else
                objMusicDeal.Duration_Restriction = null;
            int totalSeconds = Convert.ToInt32(objMusicDeal.Duration_Restriction);
            int second = totalSeconds % 60;
            int minutes = totalSeconds / 60;
            //int m = Convert.ToInt32(minutes.ToString().Substring(0, 1));
            TimeSpan times = TimeSpan.Parse("00:" + minutes.ToString("00") + ":" + second.ToString("00") + "");
            //objMusicDeal.Duration = times;
            objMusicDeal.Agreement_Cost = objTempMusicDeal.Agreement_Cost;
            if (objForm["Agreement_Cost"] != "")
                objMusicDeal.Agreement_Cost = Convert.ToDecimal(objForm["Agreement_Cost"]);

            objMusicDeal.Rights_Start_Date = Convert.ToDateTime(objForm["Start_Date"]);
            objMusicDeal.Rights_End_Date = Convert.ToDateTime(objForm["End_Date"]);
            objMusicDeal.Term = objForm["Term_YY"] + '.' + objForm["Term_MM"];
            objMusicDeal.Run_Type = objTempMusicDeal.Run_Type;
            objMusicDeal.Channel_Type = objTempMusicDeal.Channel_Type;
            if (objTempMusicDeal.Remarks == null)
                objTempMusicDeal.Remarks = "";
            objMusicDeal.Remarks = objTempMusicDeal.Remarks.Replace("\r\n", "\n");

            if (objMusicDeal.Run_Type == "U")
                objMusicDeal.No_Of_Songs = 0;
            else
                objMusicDeal.No_Of_Songs = objTempMusicDeal.No_Of_Songs;

            objMusicDeal.Channel_Or_Category = objTempMusicDeal.Channel_Or_Category;
            if (objMusicDeal.Channel_Or_Category == "G")
                objMusicDeal.Channel_Category_Code = objTempMusicDeal.Channel_Category_Code;
            else
                objMusicDeal.Channel_Category_Code = null;

            objMusicDeal.Right_Rule_Code = objTempMusicDeal.Right_Rule_Code;
            objMusicDeal.Link_Show_Type = objTempMusicDeal.Link_Show_Type;
            objMusicDeal.Business_Unit_Code = objTempMusicDeal.Business_Unit_Code;
            objMusicDeal.Last_Action_By = objLoginUser.Users_Code;
            objMusicDeal.Last_Updated_Time = DateTime.Now;

            #region -- Music Language--
            musicLanguageCode = string.IsNullOrEmpty(musicLanguageCode) ? "" : musicLanguageCode;
            string[] arrSelectedLanguage = musicLanguageCode.Split(',');
            ICollection<Music_Deal_Language_Dapper> selectLanguageCode = new HashSet<Music_Deal_Language_Dapper>();
            foreach (string languageCode in arrSelectedLanguage)
            {
                if (languageCode != "")
                {
                    Music_Deal_Language_Dapper objMDL = new Music_Deal_Language_Dapper();
                    //objMDL.EntityState = State.Added;
                    objMDL.Music_Language_Code = Convert.ToInt32(languageCode);
                    selectLanguageCode.Add(objMDL);
                }
            }
            IEqualityComparer<Music_Deal_Language_Dapper> comparerML = new LambdaComparer<Music_Deal_Language_Dapper>((x, y) => x.Music_Language_Code == y.Music_Language_Code);

            var Deleted_Music_Deal_Language = new List<Music_Deal_Language_Dapper>();
            var Added_Music_Deal_Language = CompareLists<Music_Deal_Language_Dapper>(selectLanguageCode.ToList<Music_Deal_Language_Dapper>(), objMusicDeal.Music_Deal_Language.ToList<Music_Deal_Language_Dapper>(), comparerML, ref Deleted_Music_Deal_Language);
            Added_Music_Deal_Language.ToList<Music_Deal_Language_Dapper>().ForEach(t => objMusicDeal.Music_Deal_Language.Add(t));
            //Deleted_Music_Deal_Language.ToList<Music_Deal_Language>().ForEach(t => t.EntityState = State.Deleted);
            Deleted_Music_Deal_Language.ToList().ForEach(t => objMusicDeal.Music_Deal_Language.Remove(t));
            #endregion

            #region -- Channel --
            objMusicDeal.Music_Deal_Channel.Join(lstMDC, x => x.Channel_Code, y => y.Channel_Code, (x, y) => new { x, y }).ToList().ForEach(v =>
            {
                v.x.Defined_Runs = v.y.Defined_Runs;
                //v.x.EntityState = State.Modified;
            });
            IEqualityComparer<Music_Deal_Channel_Dapper> comparerC = new LambdaComparer<Music_Deal_Channel_Dapper>((x, y) => x.Channel_Code == y.Channel_Code);
            var Deleted_Music_Deal_Channel = new List<Music_Deal_Channel_Dapper>();
            var Added_Music_Deal_Channel = CompareLists<Music_Deal_Channel_Dapper>(lstMDC.ToList<Music_Deal_Channel_Dapper>(), objMusicDeal.Music_Deal_Channel.ToList<Music_Deal_Channel_Dapper>(), comparerC, ref Deleted_Music_Deal_Channel);
            Added_Music_Deal_Channel.ToList<Music_Deal_Channel_Dapper>().ForEach(t => objMusicDeal.Music_Deal_Channel.Add(t));
            //Deleted_Music_Deal_Channel.ToList<Music_Deal_Channel>().ForEach(t => t.EntityState = State.Deleted);
            Deleted_Music_Deal_Channel.ToList().ForEach(t => objMusicDeal.Music_Deal_Channel.Remove(t));
            #endregion

            #region -- Country --
            countryCode = string.IsNullOrEmpty(countryCode) ? "" : countryCode;
            string[] arrSelectedCountry = countryCode.Split(',');
            ICollection<Music_Deal_Country_Dapper> selectCountryCode = new HashSet<Music_Deal_Country_Dapper>();
            foreach (string countryCodes in arrSelectedCountry)
            {
                if (countryCodes != "")
                {
                    Music_Deal_Country_Dapper objMDCO = new Music_Deal_Country_Dapper();
                    //objMDCO.EntityState = State.Added;
                    objMDCO.Country_Code = Convert.ToInt32(countryCodes);
                    selectCountryCode.Add(objMDCO);
                }
            }
            IEqualityComparer<Music_Deal_Country_Dapper> comparerCo = new LambdaComparer<Music_Deal_Country_Dapper>((x, y) => x.Country_Code == y.Country_Code);

            var Deleted_Music_Deal_Country = new List<Music_Deal_Country_Dapper>();
            var Added_Music_Deal_Country = CompareLists<Music_Deal_Country_Dapper>(selectCountryCode.ToList<Music_Deal_Country_Dapper>(), objMusicDeal.Music_Deal_Country.ToList<Music_Deal_Country_Dapper>(), comparerCo, ref Deleted_Music_Deal_Country);
            Added_Music_Deal_Country.ToList<Music_Deal_Country_Dapper>().ForEach(t => objMusicDeal.Music_Deal_Country.Add(t));
            // Deleted_Music_Deal_Country.ToList<Music_Deal_Country>().ForEach(t => t.EntityState = State.Deleted);
            Deleted_Music_Deal_Country.ToList().ForEach(t => objMusicDeal.Music_Deal_Country.Remove(t));
            #endregion

            #region --Deal Type--
            DealTypeCode = string.IsNullOrEmpty(DealTypeCode) ? "" : DealTypeCode;
            string[] arrSelectedDealType = DealTypeCode.Split(',');
            ICollection<Music_Deal_DealType_Dapper> selectDealTypeCode = new HashSet<Music_Deal_DealType_Dapper>();
            foreach (string DealTypeCodes in arrSelectedDealType)
            {
                if (DealTypeCodes != "")
                {
                    Music_Deal_DealType_Dapper objMDD = new Music_Deal_DealType_Dapper();
                    // objMDD.EntityState = State.Added;
                    objMDD.Deal_Type_Code = Convert.ToInt32(DealTypeCodes);
                    selectDealTypeCode.Add(objMDD);
                }
            }
            IEqualityComparer<Music_Deal_DealType_Dapper> comparerDT = new LambdaComparer<Music_Deal_DealType_Dapper>((x, y) => x.Deal_Type_Code == y.Deal_Type_Code);
            var Deleted_Music_Deal_DealType = new List<Music_Deal_DealType_Dapper>();
            var Added_Music_Deal_DealType = CompareLists<Music_Deal_DealType_Dapper>(selectDealTypeCode.ToList<Music_Deal_DealType_Dapper>(), objMusicDeal.Music_Deal_DealType.ToList<Music_Deal_DealType_Dapper>(), comparerDT, ref Deleted_Music_Deal_DealType);
            Added_Music_Deal_DealType.ToList<Music_Deal_DealType_Dapper>().ForEach(t => objMusicDeal.Music_Deal_DealType.Add(t));
            //Deleted_Music_Deal_DealType.ToList<Music_Deal_DealType>().ForEach(t => t.EntityState = State.Deleted);
            Deleted_Music_Deal_DealType.ToList().ForEach(t => objMusicDeal.Music_Deal_DealType.Remove(t));



            #endregion

            #region -- Vendor --
            string[] arrSelectedVendor = vendorCode.Split(',');
            ICollection<Music_Deal_Vendor_Dapper> selectVenodrCode = new HashSet<Music_Deal_Vendor_Dapper>();
            foreach (string VendorCodes in arrSelectedVendor)
            {
                if (VendorCodes != "")
                {
                    Music_Deal_Vendor_Dapper objMDV = new Music_Deal_Vendor_Dapper();
                    //objMDV.EntityState = State.Added;
                    objMDV.Vendor_Code = Convert.ToInt32(VendorCodes);
                    selectVenodrCode.Add(objMDV);
                }
            }
            IEqualityComparer<Music_Deal_Vendor_Dapper> comparerV = new LambdaComparer<Music_Deal_Vendor_Dapper>((x, y) => x.Vendor_Code == y.Vendor_Code);

            var Deleted_Music_Deal_Vendor = new List<Music_Deal_Vendor_Dapper>();
            var Added_Music_Deal_Vendor = CompareLists<Music_Deal_Vendor_Dapper>(selectVenodrCode.ToList<Music_Deal_Vendor_Dapper>(), objMusicDeal.Music_Deal_Vendor.ToList<Music_Deal_Vendor_Dapper>(), comparerV, ref Deleted_Music_Deal_Vendor);
            Added_Music_Deal_Vendor.ToList<Music_Deal_Vendor_Dapper>().ForEach(t => objMusicDeal.Music_Deal_Vendor.Add(t));
            //Deleted_Music_Deal_Vendor.ToList<Music_Deal_Vendor>().ForEach(t => t.EntityState = State.Deleted);
            Deleted_Music_Deal_Vendor.ToList().ForEach(t => objMusicDeal.Music_Deal_Vendor.Remove(t));
            #endregion

            #region -- Link Show--
            IEqualityComparer<Music_Deal_LinkShow_Dapper> comparerLS = new LambdaComparer<Music_Deal_LinkShow_Dapper>((x, y) => x.Title_Code == y.Title_Code);
            string[] arrTitleCode = titleCodes.Split(',');
            List<Music_Deal_LinkShow_Dapper> lstMusicDealLinkShow = new List<Music_Deal_LinkShow_Dapper>();
            foreach (string titleCode in arrTitleCode)
            {
                if (titleCode != "")
                {
                    Music_Deal_LinkShow_Dapper objMDLS = new Music_Deal_LinkShow_Dapper();
                    //  objMDLS.EntityState = State.Added;
                    objMDLS.Title_Code = Convert.ToInt32(titleCode);
                    lstMusicDealLinkShow.Add(objMDLS);
                }
            }

            var Deleted_Music_Deal_LinkShow = new List<Music_Deal_LinkShow_Dapper>();
            var Added_Music_Deal_LinkShow = CompareLists<Music_Deal_LinkShow_Dapper>(lstMusicDealLinkShow, objMusicDeal.Music_Deal_LinkShow.ToList(), comparerLS, ref Deleted_Music_Deal_LinkShow);
            Added_Music_Deal_LinkShow.ToList<Music_Deal_LinkShow_Dapper>().ForEach(t => objMusicDeal.Music_Deal_LinkShow.Add(t));
            // Deleted_Music_Deal_LinkShow_Dapper.ToList<Music_Deal_LinkShow_Dapper>().ForEach(t => t.EntityState = State.Deleted);
            Deleted_Music_Deal_LinkShow.ToList().ForEach(t => objMusicDeal.Music_Deal_LinkShow.Remove(t));

            #endregion
            int count = 0;
            dynamic resultset;
            bool isValid = false;
            Decimal version = Convert.ToDecimal(objMusicDeal.Version);
            string channel_codes = string.Join(",", lstMDC.Select(s => s.Channel_Code).ToArray());
            string startDate = Convert.ToDateTime(objForm["Start_Date"]).ToString(GlobalParams.DateFormat_Display);
            string endDate = Convert.ToDateTime(objForm["End_Date"]).ToString(GlobalParams.DateFormat_Display);
            List<USP_Music_Deal_Schedule_Validation_Result> objMDSV = new List<USP_Music_Deal_Schedule_Validation_Result>();
            if (objMusicDeal.Music_Deal_Code > 0 && version > 0001)
            {
                objMDSV = objMusic_Deal_Service.USP_Music_Deal_Schedule_Validation(objMusicDeal.Music_Deal_Code, channel_codes, startDate, endDate, titleCodes, objMusicDeal.Link_Show_Type).ToList();
                count = objMDSV.Count();

            }
            if (count > 0)
            {
                foreach (var item in objMDSV)
                {
                    Music_Deal_Validation objMDV = new Music_Deal_Validation();
                    objMDV.Error_SR_NO = item.Error_No;
                    objMDV.Title = item.Title;
                    objMDV.Schedule_Date = item.Schedule_Date;
                    objMDV.Error_Message = item.Error_Message;
                    lstMDV.Add(objMDV);
                }
            }
            else
            {
                if (objTempMusicDeal.Music_Deal_Code > 0)
                {
                    objMusic_Deal_Service.UpdateMusic_Deal(objMusicDeal);
                }
                else
                {
                    objMusic_Deal_Service.AddEntity(objMusicDeal);
                }
                //isValid = objService.Save(objMusicDeal, out resultset);
                isValid = true;
                if (isValid)
                {
                    objMusicDeal = null;
                    message = objMessageKey.DealSavedSuccessfully;
                    if (Mode == GlobalParams.DEAL_MODE_EDIT || Mode == GlobalParams.DEAL_MODE_AMENDMENT)
                        message = objMessageKey.DealUpdatedSuccessfully;

                    int recordLockingCode = Convert.ToInt32(objForm["hdnRecordLockingCode"]);
                    if (recordLockingCode > 0)
                        DBUtil.Release_Record(recordLockingCode);
                }
            }
            var obj = new
            {
                Status = isValid ? "S" : "E",
                //Message = isValid ? message : resultset,
                Message = isValid ? message : "",
                IsValidation = count > 0 ? "Y" : "N"
            };

            return Json(obj);
        }
        public ActionResult Cancel()
        {
            TempData["IsMenu"] = "N";
            objMusicDeal = null;
            return RedirectToAction("Index", "Music_Deal_List");
        }
        public JsonResult GetChannelNames(int ChannelCategoryCode)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            RightsU_Entities.Channel_Category objCC = new Channel_Category_Service(objLoginEntity.ConnectionStringName).GetById(ChannelCategoryCode);
            if (objCC != null)
            {
                obj.Add("ChannelNames", string.Join(", ", objCC.Channel_Category_Details.Select(s => s.Channel.Channel_Name).ToArray()));
                //.Channels.Select(s => s.Channel_Name).ToArray()));
                obj.Add("ChannelCodes", string.Join(",", objCC.Channel_Category_Details.Select(s => s.Channel.Channel_Code).ToArray()));
            }
            else
            {
                obj.Add("ChannelNames", "");
                obj.Add("ChannelCodes", "");
            }
            return Json(obj);
        }
        public PartialViewResult BindMusicScheduleValidationData()
        {
            List<Music_Deal_Validation> lsts = lstMDV;
            lstMDV = null;
            return PartialView("~/Views/Music_Deal/_Music_Schedule_Validation.cshtml", lsts);

        }
        public PartialViewResult BindMusicPlatformTree(string MusicPlatformCodes)
        {
            Music_Platform_Tree_View objMPG = new Music_Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string Music_Platform_Tree = string.Join(",", objMusicDeal.Music_Deal_Platform.Select(i => i.Music_Platform_Code).Distinct().ToList());//.Where(p => p.EntityState != State.Deleted)


            objMPG.MusicPlatformCodes_Selected = (MusicPlatformCodes ?? "0").Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            ViewBag.Music_Platform_Tree = Music_Platform_Tree;
            if (Mode == GlobalParams.DEAL_MODE_VIEW || Mode == GlobalParams.DEAL_MODE_APPROVE)
                ViewBag.TV_Platform = objMPG.PopulateTreeNode("Y");
            else
                ViewBag.TV_Platform = objMPG.PopulateTreeNode("N");

            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
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
        public class Music_Deal_Validation
        {
            public int Error_SR_NO { get; set; }
            public string Title { get; set; }
            public string Schedule_Date { get; set; }
            public string Error_Message { get; set; }

        }
    }
}
