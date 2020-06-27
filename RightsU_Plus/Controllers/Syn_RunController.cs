using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_RunController : BaseController
    {
        #region "--------------- Objects ---------------"

        public USP_Service objUspService
        {
            get
            {
                if (TempData["USP_Service"] == null)
                    TempData["USP_Service"] = new USP_Service(objLoginEntity.ConnectionStringName);
                return (USP_Service)TempData["USP_Service"];
            }
            set { TempData["USP_Service"] = value; }
        }

        public Syn_Deal_Run_Service objSDRS
        {
            get
            {
                if (TempData["Syn_Deal_Run_Service"] == null)
                    TempData["Syn_Deal_Run_Service"] = new Syn_Deal_Run_Service(objLoginEntity.ConnectionStringName);
                return (Syn_Deal_Run_Service)TempData["Syn_Deal_Run_Service"];
            }
            set { TempData["Syn_Deal_Run_Service"] = value; }
        }

        public ICollection<Syn_Deal_Rights> arrobjAcqDealRights
        {
            get
            {
                if (TempData["SYN_DEAL_RUN_RIGHTS"] == null)
                    TempData["SYN_DEAL_RUN_RIGHTS"] = new HashSet<Syn_Deal_Rights>();
                return (ICollection<Syn_Deal_Rights>)TempData["SYN_DEAL_RUN_RIGHTS"];
            }
            set { TempData["SYN_DEAL_RUN_RIGHTS"] = value; }
        }

        public Syn_Deal_Run objDealMovieRightsRun_PageLevel
        {
            get
            {
                if (TempData["objDealMovieRightsRun_PageLevel"] == null)
                    TempData["objDealMovieRightsRun_PageLevel"] = new Syn_Deal_Run();
                return (Syn_Deal_Run)TempData["objDealMovieRightsRun_PageLevel"];
            }
            set { TempData["objDealMovieRightsRun_PageLevel"] = value; }
        }

        public Syn_Deal_Run objSyn_Deal_Run
        {
            get
            {
                if (Session["Syn_Deal_Run"] == null)
                    Session["Syn_Deal_Run"] = new Syn_Deal_Run();
                return (Syn_Deal_Run)Session["Syn_Deal_Run"];
            }
            set { Session["Syn_Deal_Run"] = value; }
        }

        public Syn_Deal objSyn_Deal
        {
            get
            {
                if (Session[RightsU_Session.SESS_SYNDEAL] == null)
                    Session[RightsU_Session.SESS_SYNDEAL] = new Syn_Deal();
                return (Syn_Deal)Session[RightsU_Session.SESS_SYNDEAL];
            }
            set { Session[RightsU_Session.SESS_SYNDEAL] = value; }
        }

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

        #endregion

        #region "--------------- Actions ---------------"

        public ActionResult Index()
        {
            try
            {
                int id = 0;
                Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
                if (TempData["QueryString_Run"] != null)
                {
                    obj_Dictionary = TempData["QueryString_Run"] as Dictionary<string, string>;
                    id = Convert.ToInt32(obj_Dictionary["Syn_Deal_Run_Code"]);
                    TempData.Keep("QueryString_Run");
                }
                List<string> selectedTitle;
                List<string> selectedPlatforms;
               
                objSyn_Deal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
                objDeal_Schema.Page_From = GlobalParams.Page_From_Run;

                string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objSyn_Deal.Deal_Type_Code.Value);
                if (id > 0)
                {
                    objSyn_Deal_Run = objSDRS.GetById(id);
                    objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run = objSyn_Deal_Run.Syn_Deal_Run_Yearwise_Run;
                 
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        selectedTitle = objDeal_Schema.Title_List.Where(x => objSyn_Deal_Run.Title_Code == x.Title_Code && objSyn_Deal_Run.Episode_From == x.Episode_From && objSyn_Deal_Run.Episode_To == x.Episode_To).Select(s => s.Acq_Deal_Movie_Code.ToString()).ToList();
                    }
                    else
                    {
                        selectedTitle = new List<string>();
                        selectedTitle.Add(objSyn_Deal_Run.Title_Code.Value.ToString());
                    }

                    selectedPlatforms  = new List<string>();
                    foreach (Syn_Deal_Run_Platform objPlatform in objSyn_Deal_Run.Syn_Deal_Run_Platform)
                    {
                        selectedPlatforms.Add(objPlatform.Platform_Code.ToString());
                    }

                    List<RightsU_Entities.Platform> PlatformList = BindPlatformList(selectedTitle, selectedPlatforms);
                    ViewBag.PlatformList = new MultiSelectList(PlatformList.ToList(), "Platform_Code", "Platform_Hiearachy", selectedPlatforms);
                }
                else
                {
                    objSyn_Deal_Run = new Syn_Deal_Run();
                    selectedTitle = new List<string>();

                    selectedPlatforms = new List<string>();
                    List<RightsU_Entities.Platform> PlatformList = new List<RightsU_Entities.Platform>();
                    PlatformList = PlatformList.ToList();
                    ViewBag.PlatformList = new MultiSelectList(PlatformList, "Platform_Code", "Platform_Hiearachy", selectedPlatforms);
                }
                
                var titleList = objUspService.USP_GET_TITLE_FOR_SYN_RUN(objSyn_Deal.Syn_Deal_Code);
                var rightRuleList = new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(r => r.Is_Active == "Y").ToList();
                ViewBag.DaysList = GlobalParams.daysArrayList();
                rightRuleList.Insert(0, new Right_Rule { Right_Rule_Code = 0, Right_Rule_Name = objMessageKey.PleaseselectRule });
                ViewBag.TitleList = new MultiSelectList(titleList, "Title_Code", "Title_Name", selectedTitle);
                ViewBag.RightRule = new MultiSelectList(rightRuleList, "Right_Rule_Code", "Right_Rule_Name");
             
                if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                {
                    ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
                }
                else
                    ViewBag.Record_Locking_Code = 0;
                //return View(objSyn_Deal_Run);
                Session["FileName"] = "";
                Session["FileName"] = "syn_RunDefinition";
                return PartialView("~/Views/Syn_Deal/_Syn_Run.cshtml", objSyn_Deal_Run);
            }
            catch
            {
                Session["FileName"] = "";
                Session["FileName"] = "syn_RunDefinition";
                return RedirectToAction("Index", "Syn_Run_List");
            }
        }

        public PartialViewResult View()
        {
            int id = 0;
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString_Run"] != null)
            {
                obj_Dictionary = TempData["QueryString_Run"] as Dictionary<string, string>;
                id = Convert.ToInt32(obj_Dictionary["Syn_Deal_Run_Code"]);
                TempData.Keep("QueryString_Run");
            }
            objSyn_Deal = null;
            objSyn_Deal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            objDeal_Schema.Page_From = GlobalParams.Page_From_Run;
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objSyn_Deal.Deal_Type_Code.Value);
            objSyn_Deal_Run = null;
            objSDRS = null;
            if (id > 0)
            {
                objSyn_Deal_Run = objSDRS.GetById(id);
            }
            string EDIT_Mode_Repeat_OnDay = string.Empty;
            if (objSyn_Deal_Run.Repeat_Within_Days_Hrs == "D")
            {
                foreach (AttribValue obj_attrib in GlobalParams.daysArrayList())
                {
                    int chkCode = Convert.ToInt32(obj_attrib.Val);
                    int countForItem = (int)(from Syn_Deal_Run_Repeat_On_Day obj in objSyn_Deal_Run.Syn_Deal_Run_Repeat_On_Day where obj.Day_Code == chkCode select obj).Count();
                    if (countForItem > 0)
                    {
                        EDIT_Mode_Repeat_OnDay += obj_attrib.Attrib + ",";
                    }
                }
            }
            ViewBag.RepearOnDays = EDIT_Mode_Repeat_OnDay.Trim(',');
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_APPROVE)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            else
                ViewBag.Record_Locking_Code = 0;
            //return View(objSyn_Deal_Run);
            return PartialView("~/Views/Syn_Deal/_Syn_Run_View.cshtml", objSyn_Deal_Run);
        }

        public JsonResult Save(Syn_Deal_Run objRun, List<Syn_Deal_Run_Yearwise_Run> lstYearwiseRun, string[] ddlPTitle,
           string hdnDays, string hdnIs_Yearwise_Definition, string hdnPlatformList = "", string hdnTabName = "")
        {

            string Message = string.Empty;
            dynamic resultSet;
            if (objRun.Syn_Deal_Run_Code == 0)
                objSyn_Deal_Run = new Syn_Deal_Run();
            else
            {
                objSyn_Deal_Run = null;
                objSyn_Deal_Run = objSDRS.GetById(objRun.Syn_Deal_Run_Code);
            }

            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(((Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA]).Deal_Type_Code);
            List<string> strTitleCodes = ddlPTitle.ToList();
            int Count = 0;

            if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                Count = (from Title_List objTL in objDeal_Schema.Title_List
                         where strTitleCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString()) &&
                         objTL.Title_Code == objSyn_Deal_Run.Title_Code && objTL.Episode_From == objSyn_Deal_Run.Episode_From && objTL.Episode_To == objSyn_Deal_Run.Episode_To
                         select objSyn_Deal_Run
                  ).Count();
            }
            else
                Count = (from s in strTitleCodes
                         where s == objSyn_Deal_Run.Title_Code.ToString()
                         select s).Count();

            if (Count == 1)
            {

                string tCode = string.Empty;

                if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                {

                    tCode = (from Title_List objTL in objDeal_Schema.Title_List
                             where strTitleCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString()) &&
                             objTL.Title_Code == objSyn_Deal_Run.Title_Code && objTL.Episode_From == objSyn_Deal_Run.Episode_From && objTL.Episode_To == objSyn_Deal_Run.Episode_To
                             select objTL.Acq_Deal_Movie_Code.ToString()
                         ).FirstOrDefault();
                }
                else
                    tCode = (from s in strTitleCodes
                             where s == objSyn_Deal_Run.Title_Code.ToString()
                             select s).FirstOrDefault();

                strTitleCodes.Remove(tCode);
                strTitleCodes.Insert(0, tCode);
            }
            else
                Count = 1;

            foreach (string strTitleCode in strTitleCodes)
            {
                int code = string.IsNullOrEmpty(strTitleCode) ? 0 : Convert.ToInt32(strTitleCode);
                Title_List objTL = null;
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();

                if (objSyn_Deal_Run.Syn_Deal_Run_Code == 0)
                    objSyn_Deal_Run = new Syn_Deal_Run();

                if (strTitleCodes.Count > 1 && objSyn_Deal_Run.Syn_Deal_Run_Code > 0 && Count != 1)
                {
                    objSyn_Deal_Run = new Syn_Deal_Run();
                }

                objSyn_Deal_Run.Syn_Deal_Code = objSyn_Deal.Syn_Deal_Code;

                objSyn_Deal_Run.Is_Rule_Right = objRun.Is_Rule_Right;
                if (!string.IsNullOrEmpty(hdnIs_Yearwise_Definition))
                    objSyn_Deal_Run.Is_Yearwise_Definition = hdnIs_Yearwise_Definition;
                else
                    objSyn_Deal_Run.Is_Yearwise_Definition = "N";

                if(objSyn_Deal_Run.Is_Yearwise_Definition == "N")
                    objSyn_Deal_Run.Syn_Deal_Run_Yearwise_Run.ToList<Syn_Deal_Run_Yearwise_Run>().ForEach(t => t.EntityState = State.Deleted);

                objSyn_Deal_Run.No_Of_Days_Hrs = objRun.No_Of_Days_Hrs;
                objSyn_Deal_Run.No_Of_Runs = objRun.No_Of_Runs;

                objSyn_Deal_Run.Repeat_Within_Days_Hrs = objRun.Repeat_Within_Days_Hrs;
                objSyn_Deal_Run.Right_Rule_Code = objRun.Right_Rule_Code;

                objSyn_Deal_Run.Run_Type = objRun.Run_Type;

                #region ----- SAVE YEARWISE RUN DEFINITION -----
                if (objSyn_Deal_Run.Is_Yearwise_Definition == "Y")
                {
                    ICollection<Syn_Deal_Run_Yearwise_Run> selectedYearwiseRuns = new HashSet<Syn_Deal_Run_Yearwise_Run>();

                    foreach (Syn_Deal_Run_Yearwise_Run objRunYearWise in lstYearwiseRun)
                    {
                        Syn_Deal_Run_Yearwise_Run objYRun = new Syn_Deal_Run_Yearwise_Run();
                        if (objRunYearWise.Start_Date_Str != null)
                            objYRun.Start_Date = Convert.ToDateTime(objRunYearWise.Start_Date_Str);
                        if (objRunYearWise.End_Date_Str != null)
                            objYRun.End_Date = Convert.ToDateTime(objRunYearWise.End_Date_Str);
                        objYRun.No_Of_Runs = objRunYearWise.No_Of_Runs;
                        objYRun.Year_No = objRunYearWise.Year_No;
                        objYRun.EntityState = State.Added;
                        selectedYearwiseRuns.Add(objYRun);
                    }

                    IEqualityComparer<Syn_Deal_Run_Yearwise_Run> ComparerYearwiseRun = new LambdaComparer<Syn_Deal_Run_Yearwise_Run>((x, y) => x.End_Date == y.End_Date && x.No_Of_Runs == y.No_Of_Runs && x.Start_Date == y.Start_Date && x.Year_No == y.Year_No && x.EntityState != State.Deleted);
                    var Deleted_Deal_Run_Yearwise_Run = new List<Syn_Deal_Run_Yearwise_Run>();
                    var Updated_Deal_Run_Yearwise_Run = new List<Syn_Deal_Run_Yearwise_Run>();
                    var Added_Deal_Run_Yearwise_Run = CompareLists<Syn_Deal_Run_Yearwise_Run>(selectedYearwiseRuns.ToList(), objSyn_Deal_Run.Syn_Deal_Run_Yearwise_Run.ToList(), ComparerYearwiseRun, ref Deleted_Deal_Run_Yearwise_Run, ref Updated_Deal_Run_Yearwise_Run);

                    Added_Deal_Run_Yearwise_Run.ToList<Syn_Deal_Run_Yearwise_Run>().ForEach(t => objSyn_Deal_Run.Syn_Deal_Run_Yearwise_Run.Add(t));
                    Deleted_Deal_Run_Yearwise_Run.ToList<Syn_Deal_Run_Yearwise_Run>().ForEach(t => t.EntityState = State.Deleted);
                }

                #endregion

                #region -------- Add Platform ----------
                ICollection<Syn_Deal_Run_Platform> selectedPlatform = new HashSet<Syn_Deal_Run_Platform>();

                foreach (string platformcode in hdnPlatformList.Split(','))
                {
                    Syn_Deal_Run_Platform objARROD = new Syn_Deal_Run_Platform();
                    objARROD.Platform_Code = Convert.ToInt32(platformcode);
                    selectedPlatform.Add(objARROD);
                }              
                IEqualityComparer<Syn_Deal_Run_Platform> ComparerRepeatPlatform = new LambdaComparer<Syn_Deal_Run_Platform>((x, y) => x.Platform_Code == y.Platform_Code && x.EntityState != State.Deleted);
                var Deleted_Syn_Deal_Run_Platform = new List<Syn_Deal_Run_Platform>();
                var Updated_Syn_Deal_Run_Platform = new List<Syn_Deal_Run_Platform>();
                var Added_Syn_Deal_Run_Platform = CompareLists<Syn_Deal_Run_Platform>(selectedPlatform.ToList(), objSyn_Deal_Run.Syn_Deal_Run_Platform.ToList(), ComparerRepeatPlatform, ref Deleted_Syn_Deal_Run_Platform, ref Updated_Syn_Deal_Run_Platform);

                Added_Syn_Deal_Run_Platform.ToList<Syn_Deal_Run_Platform>().ForEach(t => objSyn_Deal_Run.Syn_Deal_Run_Platform.Add(t));
                Deleted_Syn_Deal_Run_Platform.ToList<Syn_Deal_Run_Platform>().ForEach(t => t.EntityState = State.Deleted);
                #endregion

                #region -- SAVE DEAL RUN TITLE DATA --

                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    objSyn_Deal_Run.Title_Code = objTL.Title_Code;
                    objSyn_Deal_Run.Episode_From = objTL.Episode_From;
                    objSyn_Deal_Run.Episode_To = objTL.Episode_To;
                }
                else
                {
                    objSyn_Deal_Run.Title_Code = code;
                    objSyn_Deal_Run.Episode_From = 1;
                    objSyn_Deal_Run.Episode_To = 1;
                }

                #endregion

                #region -- SAVE DEAL RULE RIGHT DATA --

                if (objRun.Is_Rule_Right == "Y")
                {

                    ICollection<Syn_Deal_Run_Repeat_On_Day> selectedRuns = new HashSet<Syn_Deal_Run_Repeat_On_Day>();
                    if (objRun.Repeat_Within_Days_Hrs == "D")
                    {
                        if (!string.IsNullOrEmpty(hdnDays))
                        {
                            List<string> lstDays = hdnDays.Split(',').ToList();
                            for (int i = 0; i < lstDays.Count; i++)
                            {
                                Syn_Deal_Run_Repeat_On_Day objARROD = new Syn_Deal_Run_Repeat_On_Day();
                                objARROD.Day_Code = Convert.ToInt32(lstDays[i]);
                                objARROD.EntityState = State.Added;
                                selectedRuns.Add(objARROD);
                            }
                        }
                    }

                    IEqualityComparer<Syn_Deal_Run_Repeat_On_Day> ComparerRepeat = new LambdaComparer<Syn_Deal_Run_Repeat_On_Day>((x, y) => x.Day_Code == y.Day_Code && x.EntityState != State.Deleted);
                    var Deleted_Deal_Run_Repeat_On_Day = new List<Syn_Deal_Run_Repeat_On_Day>();
                    var Updated_Deal_Run_Repeat_On_Day = new List<Syn_Deal_Run_Repeat_On_Day>();
                    var Added_Deal_Run_Repeat_On_Day = CompareLists<Syn_Deal_Run_Repeat_On_Day>(selectedRuns.ToList(), objSyn_Deal_Run.Syn_Deal_Run_Repeat_On_Day.ToList(), ComparerRepeat, ref Deleted_Deal_Run_Repeat_On_Day, ref Updated_Deal_Run_Repeat_On_Day);

                    Added_Deal_Run_Repeat_On_Day.ToList<Syn_Deal_Run_Repeat_On_Day>().ForEach(t => objSyn_Deal_Run.Syn_Deal_Run_Repeat_On_Day.Add(t));
                    Deleted_Deal_Run_Repeat_On_Day.ToList<Syn_Deal_Run_Repeat_On_Day>().ForEach(t => t.EntityState = State.Deleted);
                }

                #endregion

                if (objSyn_Deal_Run.Syn_Deal_Run_Code > 0)
                {
                    objSyn_Deal_Run.Last_updated_Time = DateTime.Now;
                    objSyn_Deal_Run.Last_action_By = objLoginUser.Users_Code;
                    objSyn_Deal_Run.EntityState = State.Modified;
                    Message = objMessageKey.RunDefinitionUpdatedSuccessfully;
                }
                else
                {
                    objSyn_Deal_Run.Inserted_On = DateTime.Now;
                    objSyn_Deal_Run.Inserted_By = objLoginUser.Users_Code;
                    objSyn_Deal_Run.EntityState = State.Added;
                    Message = objMessageKey.RunDefinitionAddedSuccessfully;
                }
                objSDRS.Save(objSyn_Deal_Run, out resultSet);

                Count++;
            }

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            if (TempData["QueryString_Run"] != null)
                TempData["QueryString_Run"] = null;
            return Json(Message);
        }

        #endregion

        #region "--------------- Validate Methods---------------"

        public bool ValidateTitles(string titleCodes)
        {
            arrobjAcqDealRights = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objSyn_Deal.Syn_Deal_Code).ToList();
            USP_Service objUS = null;
            objUS = new USP_Service(objLoginEntity.ConnectionStringName);
            List<USP_VALIDATE_SYN_TITLES_Result> objTitleCnt = objUS.USP_VALIDATE_SYN_TITLES(titleCodes.Replace('~', ',').Trim(','), objSyn_Deal.Syn_Deal_Code).ToList();
            int result_count = objTitleCnt.Count;

            if (result_count > 1)
                return false;
            return true;
        }

        public JsonResult ValidateDuplication(int Syn_Deal_Run_Code, string titleCodes, string PlatformCodes)
        {
            string invalidMessage = "Valid";
            string[] strTitleCodes = titleCodes.ToString().Split(new char[] { ',' }, StringSplitOptions.None);

            USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
            List<USP_Validate_Duplicate_Syn_Run_Result> objInvalidData = new List<USP_Validate_Duplicate_Syn_Run_Result>();
            foreach (string strTitleCode in strTitleCodes)
            {
                objInvalidData.AddRange(objUS.USP_Validate_Duplicate_Syn_Run(
                                                                                 strTitleCode// hdnTitleRunDefinition.Value.ToString().Replace('~', ',').Trim(',')
                                                                                 , PlatformCodes
                                                                                 , Syn_Deal_Run_Code
                                                                                 , objSyn_Deal.Syn_Deal_Code
                                                                              ).ToList());
            }

            var arrInvalidData = objInvalidData;
            if (arrInvalidData.Count() > 0)
            {
                return Json(arrInvalidData);
            }

            return Json(invalidMessage);
        }

        public JsonResult ValidatePlatform(int Syn_Deal_Run_Code, string titleCodes, string PlatformCodes)
        {
            string invalidMessage = "Valid";
            string[] strTitleCode = titleCodes.ToString().Split(new char[] { ',' }, StringSplitOptions.None);

            Syn_Deal_Service objService = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal synDealInstance = objService.GetById(objDeal_Schema.Deal_Code);

            List<IEnumerable<RightsU_Entities.Platform>> listOfLists = new List<IEnumerable<RightsU_Entities.Platform>>();
            int rightsCount = 0;
            string CodeType = "TC";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                CodeType = "DMC";
                List<Title_List> lstTitle = (from Title_List objTL in objDeal_Schema.Title_List
                                             where strTitleCode.Contains(objTL.Acq_Deal_Movie_Code.ToString())
                                             select objTL).ToList();
                rightsCount = synDealInstance.Syn_Deal_Rights.Where(r => r.Syn_Deal_Rights_Title.Any(t => lstTitle.Any(lt => lt.Title_Code == t.Title_Code && lt.Episode_From == t.Episode_From && lt.Episode_To == t.Episode_To))).Count();                
            }
            else
                rightsCount = synDealInstance.Syn_Deal_Rights.Where(r => r.Syn_Deal_Rights_Title.Any(t => strTitleCode.Contains(t.Title_Code.ToString()))).Count();            
            if (rightsCount == 0)
            {
                invalidMessage = "Selected titles are invalid for selected platform";
                return Json(invalidMessage);
            }
            else
            {                
                string AllPlatform_Codes = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Platform_Code_For_Syn_Run(synDealInstance.Syn_Deal_Code, titleCodes, CodeType).First().ToString();
                if (AllPlatform_Codes == "")
                {
                    invalidMessage = "Selected titles are invalid for selected platform";
                    return Json(invalidMessage);
                }
            }
            return Json(invalidMessage);
        }

        public JsonResult ValidateTitleOnSave(int Syn_Deal_Run_Code, string titleCodes)
        {
            string invalidMessage = "Valid";

            if (!ValidateTitles(titleCodes))
            {
                invalidMessage = "Selected titles are invalid for yearwise run definition";
                return Json(invalidMessage);
            }
            return Json(invalidMessage);
        }

        #endregion
        
        public JsonResult BindPlatform(string titleCodes, string PlatformCodes)
        {
            string[] strTitleCode = titleCodes.ToString().Split(new char[] { ',' }, StringSplitOptions.None);
            string[] strPlatformCode = PlatformCodes.ToString().Split(new char[] { ',' }, StringSplitOptions.None);
            List<string> listTitleCodes = strTitleCode.Cast<string>().ToList();
            List<string> listPlatformCodes = strPlatformCode.Cast<string>().ToList();

            List<RightsU_Entities.Platform> PlatformList = BindPlatformList(listTitleCodes, listPlatformCodes);

            return Json(new MultiSelectList(PlatformList.ToList(), "Platform_Code", "Platform_Hiearachy", listPlatformCodes));
        }

        public List<RightsU_Entities.Platform> BindPlatformList(List<string> titleCodes, List<string> platformCodes)
        {   
            Syn_Deal_Service objService = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal synDealInstance = objService.GetById(objDeal_Schema.Deal_Code);
            string AllPlatform_Codes = string.Empty;
            string CodeType = "TC";
            List<IEnumerable<RightsU_Entities.Platform>> listOfLists = new List<IEnumerable<RightsU_Entities.Platform>>();
            int rightsCount = 0;
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                CodeType = "DMC";
                synDealInstance.Syn_Deal_Movie.Where(m => titleCodes.Contains(m.Title_Code.ToString()));

                List<Title_List> lstTitle = (from Title_List objTL in objDeal_Schema.Title_List
                                             where titleCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString())
                                             select objTL).ToList();                
                rightsCount = synDealInstance.Syn_Deal_Rights.Where(r => r.Syn_Deal_Rights_Title.Any(t => lstTitle.Any(lt => lt.Title_Code == t.Title_Code && lt.Episode_From == t.Episode_From && lt.Episode_To == t.Episode_To))).Count();
            }
            else
                rightsCount = synDealInstance.Syn_Deal_Rights.Where(r => r.Syn_Deal_Rights_Title.Any(t => titleCodes.Contains(t.Title_Code.ToString()))).Count();       
            if (rightsCount > 0)
            {
                AllPlatform_Codes = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Platform_Code_For_Syn_Run(synDealInstance.Syn_Deal_Code, string.Join(",",titleCodes), CodeType).First().ToString();//string.Join(",", intersection.ToList<RightsU_Entities.Platform>().Where(p => p.EntityState != State.Deleted && p.Is_Applicable_Syn_Run == "Y").Select(p => p.Platform_Code.ToString()));
                string[] AllPlatforms = AllPlatform_Codes.ToString().Split(new char[] { ',' }, StringSplitOptions.None);
                int[] AllPlatforms_Codes_Array = Array.ConvertAll(AllPlatforms, s => int.Parse(s));
                List<RightsU_Entities.Platform> Platforms_List_For_Syn = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(i => AllPlatforms_Codes_Array.Contains(i.Platform_Code)).ToList();
                return Platforms_List_For_Syn;
            }
            else
            {
                return new List<RightsU_Entities.Platform>();
            }
        }

        public PartialViewResult PartialYearWiseList()
        {            
            return PartialView("~/Views/Syn_Deal/_Syn_Run_Yearwise.cshtml", objSyn_Deal_Run.Syn_Deal_Run_Yearwise_Run.ToList());
        }

        public bool CheckPlatformForRun(int platformCode)
        {
            Platform_Service objPlatformService = new Platform_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Platform objPlatform = objPlatformService.GetById(platformCode);

            if (objPlatform.Is_No_Of_Run == "Y")
                return true;
            else
                return false;
        }

        [AllowAnonymous]
        public PartialViewResult GetYearWiseRun(string TitleCodes, string txtNoOfRun)
        {
            int term = 0;  
            arrobjAcqDealRights = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objSyn_Deal.Syn_Deal_Code).ToList();
            string strMode = objSyn_Deal.Year_Type;
            string dtStartDate = "", dtEndDate = "";
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objSyn_Deal.Deal_Type_Code.Value);
            if (ValidateTitles(TitleCodes))
            {
                if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    string[] arrCodes = TitleCodes.Split(new char[] { ',' }, StringSplitOptions.None);
                    dtStartDate =
                                        (
                                           from Syn_Deal_Rights objDMR in arrobjAcqDealRights
                                           from Syn_Deal_Movie objTL in objSyn_Deal.Syn_Deal_Movie
                                           from Syn_Deal_Rights_Title objDMRT in objDMR.Syn_Deal_Rights_Title
                                           where arrCodes.Contains(objTL.Syn_Deal_Movie_Code.ToString()) && objTL.Title_Code == objDMRT.Title_Code
                                           && objTL.Episode_From == objDMRT.Episode_From && objTL.Episode_End_To == objDMRT.Episode_To
                                           select objDMR.Right_Start_Date
                                       ).Min().ToString();

                    dtEndDate =
                                       (
                                           from Syn_Deal_Rights objDMR in arrobjAcqDealRights
                                           from Syn_Deal_Movie objTL in objSyn_Deal.Syn_Deal_Movie
                                           from Syn_Deal_Rights_Title objDMRT in objDMR.Syn_Deal_Rights_Title
                                           where arrCodes.Contains(objTL.Syn_Deal_Movie_Code.ToString()) && objTL.Title_Code == objDMRT.Title_Code
                                           && objTL.Episode_From == objDMRT.Episode_From && objTL.Episode_End_To == objDMRT.Episode_To
                                           select objDMR.Right_End_Date
                                      ).Max().ToString();
                }
                else
                {
                    dtStartDate =
                                        (
                                           from Syn_Deal_Rights objDMR in arrobjAcqDealRights
                                           from Syn_Deal_Rights_Title objDMRT in objDMR.Syn_Deal_Rights_Title
                                           from Syn_Deal_Rights_Platform objDMRP in objDMR.Syn_Deal_Rights_Platform
                                           where ("," + TitleCodes.Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value)
                                           select objDMR.Right_Start_Date
                                       ).Min().ToString();
                    dtEndDate =
                                       (
                                          from Syn_Deal_Rights objDMR in arrobjAcqDealRights
                                          from Syn_Deal_Rights_Title objDMRT in objDMR.Syn_Deal_Rights_Title
                                          from Syn_Deal_Rights_Platform objDMRP in objDMR.Syn_Deal_Rights_Platform
                                          where ("," + TitleCodes.Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value)
                                          select objDMR.Right_End_Date
                                      ).Max().ToString();
                }

                if (dtStartDate == string.Empty && dtEndDate == string.Empty)
                {
                    dtStartDate =
                                          (
                                             from Syn_Deal_Rights objDMR in arrobjAcqDealRights
                                             from Syn_Deal_Rights_Title objDMRT in objDMR.Syn_Deal_Rights_Title
                                             from Syn_Deal_Rights_Platform objDMRP in objDMR.Syn_Deal_Rights_Platform
                                             where ("," + TitleCodes.ToString().Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value) && objDMR.Right_Type == "M" && objDMR.Milestone_Unit_Type == 4
                                             select objDMR.Actual_Right_Start_Date
                                         ).Min().ToString();
                    dtEndDate =
                                       (
                                          from Syn_Deal_Rights objDMR in arrobjAcqDealRights
                                          from Syn_Deal_Rights_Title objDMRT in objDMR.Syn_Deal_Rights_Title
                                          from Syn_Deal_Rights_Platform objDMRP in objDMR.Syn_Deal_Rights_Platform
                                          where ("," + TitleCodes.ToString().Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value) && objDMR.Right_Type == "M" && objDMR.Milestone_Unit_Type == 4
                                          select objDMR.Actual_Right_End_Date
                                      ).Max().ToString();

                    if (dtStartDate == string.Empty & dtEndDate == string.Empty)
                    {
                        term = (from Syn_Deal_Rights objDMR in arrobjAcqDealRights
                                from Syn_Deal_Rights_Title objDMRT in objDMR.Syn_Deal_Rights_Title
                                from Syn_Deal_Rights_Platform objDMRP in objDMR.Syn_Deal_Rights_Platform
                                where ("," + TitleCodes.ToString().Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value) && objDMR.Right_Type == "M" && objDMR.Milestone_Unit_Type == 4
                                select objDMR.Milestone_No_Of_Unit.Value).FirstOrDefault();
                    }
                }

                if (dtEndDate != null && dtEndDate != string.Empty)
                {
                    string stdate = Convert.ToDateTime(dtStartDate).ToString("MM/dd/yyyy");
                    string endate = Convert.ToDateTime(dtEndDate).ToString("MM/dd/yyyy");

                    USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
                    DateTime StartDate = Convert.ToDateTime(dtStartDate);
                    DateTime EndDate = Convert.ToDateTime(dtEndDate);

                    List<USP_Generate_Deal_Type_Year_Result> objList = objUS.USP_Generate_Deal_Type_Year(strMode, StartDate, EndDate).ToList();

                    if (objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run != null && objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run.Count != 0)
                        objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run.Clear();

                    objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run = new HashSet<Syn_Deal_Run_Yearwise_Run>();
                    GlobalUtil objGlobalUtil = new GlobalUtil();
                    int noOfRunPerYear = 0;
                    int sumOfRun = 0;
                    if (!string.IsNullOrEmpty(txtNoOfRun))
                        noOfRunPerYear = Convert.ToInt32(Math.Round((Convert.ToDecimal(txtNoOfRun) / objList.Count)));
                    else
                        txtNoOfRun = "0";
                    for (int i = 0; i < objList.Count; i++)
                    {
                        USP_Generate_Deal_Type_Year_Result objResult = objList.ElementAt(i);

                        Syn_Deal_Run_Yearwise_Run obj = new Syn_Deal_Run_Yearwise_Run();

                        obj.Start_Date = Convert.ToDateTime(objResult.start_date);
                        obj.End_Date = Convert.ToDateTime(objResult.end_date);
                        if (Convert.ToInt32(txtNoOfRun) != 0)
                        {
                            if (sumOfRun < Convert.ToInt32(txtNoOfRun))
                            {
                                if (i == (objList.Count() - 1))
                                    obj.No_Of_Runs = Convert.ToInt32(txtNoOfRun) - (noOfRunPerYear * (objList.Count - 1));
                                else
                                    obj.No_Of_Runs = noOfRunPerYear;
                                sumOfRun = sumOfRun + obj.No_Of_Runs.Value;
                            }
                            else
                                obj.No_Of_Runs = 0;
                        }
                        objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run.Add(obj);
                    }
                    ViewBag.RightType = "Y";
                }
                else
                    if (term != 0)
                    {
                        if (objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run != null && objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run.Count != 0)
                            objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run.Clear();

                        objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run = new HashSet<Syn_Deal_Run_Yearwise_Run>();
                        int noOfRunPerYear = 0;
                        int sumOfRun = 0;
                        if (!string.IsNullOrEmpty(txtNoOfRun))
                            noOfRunPerYear = Convert.ToInt32(Math.Round((Convert.ToDecimal(txtNoOfRun) / term)));
                        else
                            txtNoOfRun = "0";
                        for (int i = 1; i <= term; i++)
                        {
                            Syn_Deal_Run_Yearwise_Run obj = new Syn_Deal_Run_Yearwise_Run();
                            obj.Year_No = i;
                            if (Convert.ToInt32(txtNoOfRun) != 0)
                            {
                                if (sumOfRun < Convert.ToInt32(txtNoOfRun))
                                {
                                    if (i == (term - 1))
                                        obj.No_Of_Runs = Convert.ToInt32(txtNoOfRun) - (noOfRunPerYear * (term - 1));
                                    else
                                        obj.No_Of_Runs = noOfRunPerYear;
                                    sumOfRun = sumOfRun + obj.No_Of_Runs.Value;

                                }
                                else
                                    obj.No_Of_Runs = 0;
                            }
                            objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run.Add(obj);
                        }
                        ViewBag.RightType = "M";
                    }
                    else
                    {
                        return PartialView("_Syn_Run_Yearwise", null);
                    }
                return PartialView("~/Views/Syn_Deal/_Syn_Run_Yearwise.cshtml", objDealMovieRightsRun_PageLevel.Syn_Deal_Run_Yearwise_Run.ToList());                
            }
            else
            {                
                return PartialView("~/Views/Syn_Deal/_Syn_Run_Yearwise.cshtml", null);
            }
        }

        public JsonResult GetRightRule(string RightRuleCode)
        {
            int code = Convert.ToInt32(RightRuleCode);
            var objRightRule = new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(r => r.Right_Rule_Code == code).Select(r => new { r.Start_Time, r.Play_Per_Day, r.No_Of_Repeat, r.Duration_Of_Day });
            return Json(objRightRule);
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

        public ActionResult ChangeTabFromView(string hdnTabName = "")
        {
            if (TempData["QueryString_Run"] != null)
                TempData["QueryString_Run"] = null;
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code,GlobalParams.ModuleCodeForSynDeal);
        }

    }
}
