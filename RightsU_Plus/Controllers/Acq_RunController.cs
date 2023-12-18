using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_RunController : BaseController
    {
        //
        // GET: /Acq_Run/
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

        public Acq_Deal_Run_Service objADRS
        {
            get
            {
                if (TempData["Acq_Deal_Run_Service"] == null)
                    TempData["Acq_Deal_Run_Service"] = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Run_Service)TempData["Acq_Deal_Run_Service"];
            }
            set { TempData["Acq_Deal_Run_Service"] = value; }
        }

        public ICollection<Acq_Deal_Rights> arrobjAcqDealRights
        {
            get
            {
                if (TempData["ACQ_DEAL_RUN_RIGHTS"] == null)
                    TempData["ACQ_DEAL_RUN_RIGHTS"] = new HashSet<Acq_Deal_Rights>();
                return (ICollection<Acq_Deal_Rights>)TempData["ACQ_DEAL_RUN_RIGHTS"];
            }
            set { TempData["ACQ_DEAL_RUN_RIGHTS"] = value; }
        }

        public Acq_Deal_Run objDealMovieRightsRun_PageLevel
        {
            get
            {
                if (TempData["objDealMovieRightsRun_PageLevel"] == null)
                    TempData["objDealMovieRightsRun_PageLevel"] = new Acq_Deal_Run();
                return (Acq_Deal_Run)TempData["objDealMovieRightsRun_PageLevel"];
            }
            set { TempData["objDealMovieRightsRun_PageLevel"] = value; }
        }

        public Acq_Deal_Run objAcq_Deal_Run
        {
            get
            {
                if (Session["Acq_Deal_Run"] == null)
                    Session["Acq_Deal_Run"] = new Acq_Deal_Run();
                return (Acq_Deal_Run)Session["Acq_Deal_Run"];
            }
            set { Session["Acq_Deal_Run"] = value; }
        }

        public Acq_Deal_Run_Shows objAcq_Deal_Run_Shows
        {
            get
            {
                if (Session["Acq_Deal_Run_Shows"] == null)
                    Session["Acq_Deal_Run_Shows"] = new Acq_Deal_Run_Shows();
                return (Acq_Deal_Run_Shows)Session["Acq_Deal_Run_Shows"];
            }
            set { Session["Acq_Deal_Run_Shows"] = value; }
        }

        public Acq_Deal objAcq_Deal
        {
            get
            {
                if (Session[UtoSession.SESS_DEAL] == null)
                    Session[UtoSession.SESS_DEAL] = new Acq_Deal();
                return (Acq_Deal)Session[UtoSession.SESS_DEAL];
            }
            set { Session[UtoSession.SESS_DEAL] = value; }
        }

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

        private List<MatrixData> lstMatrixDataFinal
        {
            get
            {
                if (Session["lstMatrixDataFinal"] == null)
                    Session["lstMatrixDataFinal"] = new List<MatrixData>();
                return (List<MatrixData>)Session["lstMatrixDataFinal"];
            }
            set { Session["lstMatrixDataFinal"] = value; }
        }

        //public string Message
        //{
        //    get
        //    {
        //        if (Session["Message"] == null)
        //            Session["Message"] = string.Empty;
        //        return (string)Session["Message"];
        //    }
        //    set { Session["Message"] = value; }
        //}
        public JsonResult CheckIfShowLinked(int Acq_Deal_Run_Code, int selectedChannel) //, int[] ExistingChannels
        {
            objAcq_Deal_Run = objADRS.GetById(Acq_Deal_Run_Code);
            //int count = 0;
            //int i = ExistingChannels.Length;

            var Acq_Deal_Run_Channel = objAcq_Deal_Run.Acq_Deal_Run_Channel.Where(p => p.Channel_Code == selectedChannel).ToList();
            var Count = objAcq_Deal_Run.Acq_Deal_Run_Shows.Where(x => x.Data_For != "A").Join(Acq_Deal_Run_Channel, p => p.Acq_Deal_Run_Code, adrc => adrc.Acq_Deal_Run_Code, (p, adrc) => new { p }).Count();
            //objAcq_Deal_Run.Acq_Deal_Run_Channel.ToList().ForEach(p =>
            //    {
            //        if (p.Channel_Code == selectedChannel[i])
            //        {
            //            Acq_Deal_Run_Code = Convert.ToInt32(p.Acq_Deal_Run_Code);
            //            i -= 1;
            //            //count += 0;
            //        }
            //    }
            //);
            //var x = objAcq_Deal_Run.Acq_Deal_Run_Channel.Where(x => x.Channel_Code.ToString().Contains(selectedChannel));
            //var j = objAcq_Deal_Run.Acq_Deal_Run_Shows.Where(x => x.Data_For != "A").Join(objAcq_Deal_Run.Acq_Deal_Run_Channel.Where(x => x.), p => p.Acq_Deal_Run_Code, x => x.Acq_Deal_Run_Code, (p, x) => new { p });
            //return Json(j);
            return Json(Count);
        }
        public PartialViewResult Index()
        {
            try
            {
                int id = 0;
                Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
                if (TempData["QueryString_Run"] != null)
                {
                    obj_Dictionary = TempData["QueryString_Run"] as Dictionary<string, string>;
                    id = Convert.ToInt32(obj_Dictionary["Acq_Deal_Run_Code"]);
                    TempData.Keep("QueryString_Run");
                }
                objAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
                objDeal_Schema.Page_From = GlobalParams.Page_From_Run;
                if (id > 0)
                {
                    objAcq_Deal_Run = objADRS.GetById(id);

                    var a = objAcq_Deal_Run.Acq_Deal_Run_LP.ToList();
                    objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run = objAcq_Deal_Run.Acq_Deal_Run_Yearwise_Run;

                    if (objAcq_Deal_Run.Prime_Run > 0)
                    {
                        string lblPrimeScheduledRuns = string.Empty;
                        string lblPrimeBalanceRuns = string.Empty;
                        lblPrimeScheduledRuns = "Scheduled Runs : ";
                        lblPrimeBalanceRuns = "  Balance Runs : ";
                        lblPrimeScheduledRuns += Convert.ToString(objAcq_Deal_Run.Prime_Time_Provisional_Run_Count == null ? 0 : objAcq_Deal_Run.Prime_Time_Provisional_Run_Count);
                        lblPrimeBalanceRuns += Convert.ToString(objAcq_Deal_Run.Prime_Time_Balance_Count == null ? 0 : objAcq_Deal_Run.Prime_Time_Balance_Count);

                        ViewBag.PrimeScheduledRuns = lblPrimeScheduledRuns;
                        ViewBag.PrimeBalanceRuns = lblPrimeBalanceRuns;
                    }

                    if (objAcq_Deal_Run.Off_Prime_Run > 0)
                    {
                        string lblOffPrimeScheduledRuns = string.Empty;
                        string lblOffPrimeBalanceRuns = string.Empty;
                        lblOffPrimeScheduledRuns = "Scheduled Runs : ";
                        lblOffPrimeBalanceRuns = "  Balance Runs : ";
                        lblOffPrimeScheduledRuns += Convert.ToString(objAcq_Deal_Run.Off_Prime_Time_Provisional_Run_Count == null ? 0 : objAcq_Deal_Run.Off_Prime_Time_Provisional_Run_Count);
                        lblOffPrimeBalanceRuns += Convert.ToString(objAcq_Deal_Run.Off_Prime_Time_Balance_Count == null ? 0 : objAcq_Deal_Run.Off_Prime_Time_Balance_Count);
                        ViewBag.OffPrimeScheduledRuns = lblOffPrimeScheduledRuns;
                        ViewBag.OffPrimeBalanceRuns = lblOffPrimeBalanceRuns;
                    }
                }
                else
                {
                    objAcq_Deal_Run = new Acq_Deal_Run();
                }
                System_Parameter_New objSysParameterNew = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "RUN_DISABLE_CHANNELWISE").FirstOrDefault();
                ViewBag.RUN_DISABLE_CHANNELWISE = objSysParameterNew.Parameter_Value;
                ViewBag.No_Of_Run = (objAcq_Deal_Run.No_Of_Runs == null ? 0 : objAcq_Deal_Run.No_Of_Runs) + (objAcq_Deal_Run.Syndication_Runs == null ? 0 : objAcq_Deal_Run.Syndication_Runs);
                ViewBag.ChannelDefnList = GlobalParams.runDefinationArrayList();
                ViewBag.DaysList = GlobalParams.daysArrayList();

                // ViewBag.ChannelCluster = new SelectList(new Channel_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Type == "A").OrderBy(o => o.Channel_Category_Name).ToList(), "Channel_Category_Code", "Channel_Category_Name");

                if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                    ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
                else
                    ViewBag.Record_Locking_Code = 0;

                ViewBag.AllowPeriodInRunDefinition =  new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "AllowPeriodInRunDefinition").Select(x => x.Parameter_Value).FirstOrDefault();

                Session["FileName"] = "";
                Session["FileName"] = "acq_RunDefinition.html";
                return PartialView("~/Views/Acq_Deal/_Acq_Run.cshtml", objAcq_Deal_Run);
            }
            catch
            {
                Session["FileName"] = "";
                Session["FileName"] = "acq_RunDefinition";
                return PartialView("~/Views/Acq_Deal/_Acq_Run.cshtml");
            }
        }

        public PartialViewResult View()
        {
            int id = 0;
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString_Run"] != null)
            {
                obj_Dictionary = TempData["QueryString_Run"] as Dictionary<string, string>;
                id = Convert.ToInt32(obj_Dictionary["Acq_Deal_Run_Code"]);
                TempData.Keep("QueryString_Run");
            }
            objAcq_Deal = null;
            objAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            objDeal_Schema.Page_From = GlobalParams.Page_From_Run;
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objAcq_Deal.Deal_Type_Code.Value);
            objAcq_Deal_Run = null;
            objADRS = null;
            if (id > 0)
            {
                objAcq_Deal_Run = objADRS.GetById(id);

                if (objAcq_Deal_Run.Prime_Run > 0)
                {
                    string lblPrimeScheduledRuns = string.Empty;
                    string lblPrimeBalanceRuns = string.Empty;
                    lblPrimeScheduledRuns = "Scheduled Runs : ";
                    lblPrimeBalanceRuns = "  Balance Runs : ";
                    lblPrimeScheduledRuns += Convert.ToString(objAcq_Deal_Run.Prime_Time_Provisional_Run_Count == null ? 0 : objAcq_Deal_Run.Prime_Time_Provisional_Run_Count);
                    lblPrimeBalanceRuns += Convert.ToString(objAcq_Deal_Run.Prime_Time_Balance_Count == null ? 0 : objAcq_Deal_Run.Prime_Time_Balance_Count);

                    ViewBag.PrimeScheduledRuns = lblPrimeScheduledRuns;
                    ViewBag.PrimeBalanceRuns = lblPrimeBalanceRuns;
                }

                if (objAcq_Deal_Run.Off_Prime_Run > 0)
                {
                    string lblOffPrimeScheduledRuns = string.Empty;
                    string lblOffPrimeBalanceRuns = string.Empty;
                    lblOffPrimeScheduledRuns = "Scheduled Runs : ";
                    lblOffPrimeBalanceRuns = "  Balance Runs : ";
                    lblOffPrimeScheduledRuns += Convert.ToString(objAcq_Deal_Run.Off_Prime_Time_Provisional_Run_Count == null ? 0 : objAcq_Deal_Run.Off_Prime_Time_Provisional_Run_Count);
                    lblOffPrimeBalanceRuns += Convert.ToString(objAcq_Deal_Run.Off_Prime_Time_Balance_Count == null ? 0 : objAcq_Deal_Run.Off_Prime_Time_Balance_Count);
                    ViewBag.OffPrimeScheduledRuns = lblOffPrimeScheduledRuns;
                    ViewBag.OffPrimeBalanceRuns = lblOffPrimeBalanceRuns;
                }
            }
            string EDIT_Mode_Repeat_OnDay = string.Empty;
            if (objAcq_Deal_Run.Repeat_Within_Days_Hrs == "D")
            {
                foreach (AttribValue obj_attrib in GlobalParams.daysArrayList())
                {
                    int chkCode = Convert.ToInt32(obj_attrib.Val);
                    int countForItem = (int)(from Acq_Deal_Run_Repeat_On_Day obj in objAcq_Deal_Run.Acq_Deal_Run_Repeat_On_Day where obj.Day_Code == chkCode select obj).Count();
                    if (countForItem > 0)
                    {
                        EDIT_Mode_Repeat_OnDay += obj_attrib.Attrib + ",";
                    }
                }
            }
            ViewBag.RepearOnDays = EDIT_Mode_Repeat_OnDay.Trim(',');

            string hdnChannel = string.Join(",", objAcq_Deal_Run.Acq_Deal_Run_Channel.Select(c => c.Channel_Code));
            Channel_Service objCS = new Channel_Service(objLoginEntity.ConnectionStringName);
            IQueryable<RightsU_Entities.Channel> arrQuerableChannel = objCS.SearchFor(x => hdnChannel.Contains(x.Channel_Code.ToString()));
            string Channel_Names_Run = "";
            string primaryChannelName = "";
            foreach (Acq_Deal_Run_Channel objRunChannel in objAcq_Deal_Run.Acq_Deal_Run_Channel)
            {
                string ChannelName = (from RightsU_Entities.Channel obj in arrQuerableChannel where obj.Channel_Code == objRunChannel.Channel_Code select obj.Channel_Name).FirstOrDefault();
                if (objRunChannel.Channel_Code == objAcq_Deal_Run.Primary_Channel_Code)
                    primaryChannelName = ChannelName;
                objRunChannel.ChannelNames = ChannelName.ToString();
                Channel_Names_Run += ChannelName.ToString() + ", ";
            }
            Channel_Names_Run = Channel_Names_Run.Trim(' ').Trim(',');
            if (!string.IsNullOrEmpty(primaryChannelName))
                ViewBag.PrimaryChannel = primaryChannelName;
            else
                ViewBag.PrimaryChannel = "NA";


            if (Channel_Names_Run.Trim().Trim(' ') == String.Empty)
                Channel_Names_Run = "NA";
            ViewBag.Channel = Channel_Names_Run;

            if (objAcq_Deal_Run.Run_Definition_Type.Trim(' ') == GlobalParams.CHANNEL_WISE)
            {
                ViewBag.RunDefinitionType = "CHANNEL WISE";
            }
            else if (objAcq_Deal_Run.Run_Definition_Type.Trim(' ') == GlobalParams.CHANNEL_WISE_SHARED)
            {
                ViewBag.RunDefinitionType = "CHANNEL WISE SHARED";
            }
            else if (objAcq_Deal_Run.Run_Definition_Type.Trim(' ') == GlobalParams.CHANNEL_WISE_ALL)
            {
                ViewBag.RunDefinitionType = "CHANNEL WISE ALL";
            }
            else if (objAcq_Deal_Run.Run_Definition_Type.Trim(' ') == GlobalParams.CHANNEL_SHARED)
            {
                ViewBag.RunDefinitionType = "CHANNEL SHARED";
            }
            else
            {
                ViewBag.RunDefinitionType = "NA";
            }
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_APPROVE)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            else
                ViewBag.Record_Locking_Code = 0;

            string selectedTitleCode = "";
            if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                selectedTitleCode = string.Join(",", (from objTitle in objAcq_Deal_Run.Acq_Deal_Run_Title
                                                      from objDealMovie in objAcq_Deal.Acq_Deal_Movie
                                                      where objDealMovie.Title_Code == objTitle.Title_Code && objDealMovie.Episode_Starts_From == objTitle.Episode_From
                                                      && objDealMovie.Episode_End_To == objTitle.Episode_To
                                                      select objDealMovie.Acq_Deal_Movie_Code.ToString()).ToArray());
            }
            else
                selectedTitleCode = string.Join(",", objAcq_Deal_Run.Acq_Deal_Run_Title.Select(t => t.Title_Code.ToString()).ToArray());
            ViewBag.SelectedTitleCode = selectedTitleCode;
            ViewBag.Channel_Cluster = new Channel_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Channel_Category_Code == objAcq_Deal_Run.Channel_Category_Code).Select(s => s.Channel_Category_Name).FirstOrDefault();
            ViewBag.No_Of_Run = (objAcq_Deal_Run.No_Of_Runs == null ? 0 : objAcq_Deal_Run.No_Of_Runs) + (objAcq_Deal_Run.Syndication_Runs == null ? 0 : objAcq_Deal_Run.Syndication_Runs);
            return PartialView("~/Views/Acq_Deal/_Acq_Run_View.cshtml", objAcq_Deal_Run);
        }
        public JsonResult ChannelCategory_Changed(int channelCategoryCode)
        {
            List<RightsU_Entities.Channel> channelList = new List<RightsU_Entities.Channel>();
            if (channelCategoryCode == 0)
            {
                channelList = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y").ToList();
            }
            else
            {
                channelList = new Channel_Category_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Channel_Category_Code == channelCategoryCode).Select(s => s.Channel).ToList();
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Channel_List", new SelectList(channelList, "Channel_Code", "Channel_Name"));
            return Json(obj);
        }
        public JsonResult ChannelChanged()
        {
            List<RightsU_Entities.Channel> channelList = new List<RightsU_Entities.Channel>();

            channelList = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y").ToList();
            var ChannelClusterList = new Channel_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Type == "A").OrderBy(o => o.Channel_Category_Name).ToList();
            ChannelClusterList.Insert(0, new Channel_Category { Channel_Category_Code = 0, Channel_Category_Name = objMessageKey.PleaseSelect });
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Channel_Cluster_List", new SelectList(ChannelClusterList, "Channel_Category_Code", "Channel_Category_Name"));
            obj.Add("Channel_List", new SelectList(channelList, "Channel_Code", "Channel_Name"));
            return Json(obj);
        }
        public JsonResult ChannelCategoryChanged(int category_Code)
        {
            var PrimaryChannelClusterList = new Channel_Category_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Channel_Category_Code == category_Code).Select(s => s.Channel).ToList();
            PrimaryChannelClusterList.Insert(0, new RightsU_Entities.Channel { Channel_Code = 0, Channel_Name = objMessageKey.PleaseSelect });
            List<RightsU_Entities.Channel> channelList = new List<RightsU_Entities.Channel>();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Channel_Cluster_Primary_List", new SelectList(PrimaryChannelClusterList, "Channel_Code", "Channel_Name"));
            return Json(obj);
        }
        public JsonResult BindAllPreReq_Async()
        {
            var titleList = objUspService.USP_GET_TITLE_FOR_RUN(objAcq_Deal.Acq_Deal_Code);
            string selectedTitleCode = "";
            int? selectedChanelClusterCode = 0;
            int? selectedPrimaryChannelCode = 0;
            List<RightsU_Entities.Channel> PrimarychannelList = new List<RightsU_Entities.Channel>();
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objAcq_Deal.Deal_Type_Code.Value);
            if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                selectedTitleCode = string.Join(",", (from objTitle in objAcq_Deal_Run.Acq_Deal_Run_Title
                                                      from objDealMovie in objAcq_Deal.Acq_Deal_Movie
                                                      where objDealMovie.Title_Code == objTitle.Title_Code && objDealMovie.Episode_Starts_From == objTitle.Episode_From
                                                      && objDealMovie.Episode_End_To == objTitle.Episode_To
                                                      select objDealMovie.Acq_Deal_Movie_Code.ToString()).ToArray());
            }
            else
                selectedTitleCode = string.Join(",", objAcq_Deal_Run.Acq_Deal_Run_Title.Select(t => t.Title_Code.ToString()).ToArray());

            string selectedChannelCodes = "";
            if (objAcq_Deal_Run.Acq_Deal_Run_Channel.Count > 0)
                selectedChannelCodes = string.Join(",", objAcq_Deal_Run.Acq_Deal_Run_Channel.Select(c => c.Channel_Code.ToString()).ToArray());

            var channelList = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y").ToList();
            var rightRuleList = new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(r => r.Is_Active == "Y").ToList();
            rightRuleList.Insert(0, new Right_Rule { Right_Rule_Code = 0, Right_Rule_Name = objMessageKey.PleaseSelect });

            if (objAcq_Deal_Run.Channel_Category_Code > 0)
                selectedChanelClusterCode = objAcq_Deal_Run.Channel_Category_Code;
            var ChannelClusterList = new Channel_Category_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Type == "A").OrderBy(o => o.Channel_Category_Name).ToList();
            ChannelClusterList.Insert(0, new Channel_Category { Channel_Category_Code = 0, Channel_Category_Name = objMessageKey.PleaseSelect });

            if (objAcq_Deal_Run.Channel_Type == "G")
            {
                if (objAcq_Deal_Run.Primary_Channel_Code > 0)
                    selectedPrimaryChannelCode = objAcq_Deal_Run.Primary_Channel_Code;
                //PrimarychannelList = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Channel_Category_Code == objAcq_Deal_Run.Channel_Category_Code).OrderBy(o => o.Channel_Name).ToList();
                PrimarychannelList = new Channel_Category_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Channel_Category_Code == objAcq_Deal_Run.Channel_Category_Code).Select(s => s.Channel).ToList();

            }
            // PrimarychannelList.Insert(0, new RightsU_Entities.Channel { Channel_Code = 0, Channel_Name = "Please Select" });

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Title_List", new SelectList(titleList, "Title_Code", "Title_Name"));
            obj.Add("Selected_Title_Codes", selectedTitleCode);
            obj.Add("Channel_List", new SelectList(channelList, "Channel_Code", "Channel_Name"));
            obj.Add("Selected_Channel_Codes", selectedChannelCodes);
            obj.Add("Channel_Cluster_List", new SelectList(ChannelClusterList, "Channel_Category_Code", "Channel_Category_Name"));
            obj.Add("PrimarychannelList", new SelectList(PrimarychannelList, "Channel_Code", "Channel_Name"));
            obj.Add("Selected_Channel_Cluster_Codes", selectedChanelClusterCode);
            obj.Add("RightRule_List", new SelectList(rightRuleList, "Right_Rule_Code", "Right_Rule_Name"));
            obj.Add("Right_Rule_Code", objAcq_Deal_Run.Right_Rule_Code ?? 0);
            obj.Add("CheckChannelOrCategory", objAcq_Deal_Run.Channel_Type);

            if (selectedTitleCode != "")
                obj.Add("Is_SubLic", CheckSubLicen(selectedTitleCode));
            else
                obj.Add("Is_SubLic", null);
            return Json(obj);
        }
        public Boolean CheckSubLicen(string TitleCodes)
        {
            arrobjAcqDealRights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).ToList();
            string[] isSubLicen;
            bool isSubLicenflag = false;
            string[] arrCodes = TitleCodes.Split(new char[] { ',' }, StringSplitOptions.None);
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objAcq_Deal.Deal_Type_Code.Value);
            foreach (var item in arrCodes)
            {
                int code = Convert.ToInt32(item);
                if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    isSubLicen = (
                                               from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                               from Acq_Deal_Movie objTL in objAcq_Deal.Acq_Deal_Movie
                                               from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                               where objTL.Acq_Deal_Movie_Code == code && objTL.Title_Code == objDMRT.Title_Code
                                               //select objDMR.Right_Start_Date
                                               && objTL.Episode_Starts_From == objDMRT.Episode_From && objTL.Episode_End_To == objDMRT.Episode_To
                                               && objDMR.Acq_Deal_Rights_Code == objDMRT.Acq_Deal_Rights_Code
                                               && objDMR.Is_Sub_License == "Y"
                                               select objDMR.Is_Sub_License
                                           ).ToArray();
                }
                else
                {
                    isSubLicen = (
                                               from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                               from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                               from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                               where objDMRT.Title_Code == code && CheckPlatformForRun(objDMRP.Platform_Code.Value)
                                               && objDMR.Is_Sub_License == "Y"
                                               && objDMR.Acq_Deal_Rights_Code == objDMRT.Acq_Deal_Rights_Code
                                               select objDMR.Is_Sub_License
                                           ).ToArray();
                }
                if (isSubLicen.Count() == 0)
                    return false;
            }
            return true;
        }
        [AllowAnonymous]
        public PartialViewResult GetYearWiseRun(string TitleCodes, string txtNoOfRun)
        {
            int term = 0;
            //  CultureInfoFunction();
            arrobjAcqDealRights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).ToList();
            string strMode = objAcq_Deal.Year_Type;
            string dtStartDate = "", dtEndDate = "";

            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objAcq_Deal.Deal_Type_Code.Value);
            if (ValidateTitles(TitleCodes))
            {

                if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    string[] arrCodes = TitleCodes.Split(new char[] { ',' }, StringSplitOptions.None);
                    dtStartDate =
                                        (
                                           from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                           from Acq_Deal_Movie objTL in objAcq_Deal.Acq_Deal_Movie
                                           from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                           where arrCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString()) && objTL.Title_Code == objDMRT.Title_Code
                                           && objTL.Episode_Starts_From == objDMRT.Episode_From && objTL.Episode_End_To == objDMRT.Episode_To
                                           select objDMR.Right_Start_Date
                                       ).Min().ToString();

                    dtEndDate =
                                       (
                                           from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                           from Acq_Deal_Movie objTL in objAcq_Deal.Acq_Deal_Movie
                                           from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                           where arrCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString()) && objTL.Title_Code == objDMRT.Title_Code
                                           && objTL.Episode_Starts_From == objDMRT.Episode_From && objTL.Episode_End_To == objDMRT.Episode_To
                                           select objDMR.Right_End_Date
                                      ).Max().ToString();
                }
                else
                {
                    dtStartDate =
                                        (
                                           from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                           from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                           from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                           where ("," + TitleCodes.Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value)
                                           select objDMR.Right_Start_Date
                                       ).Min().ToString();
                    dtEndDate =
                                       (
                                          from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                          from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                          from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                          where ("," + TitleCodes.Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value)
                                          select objDMR.Right_End_Date
                                      ).Max().ToString();
                }

                if (dtStartDate == string.Empty && dtEndDate == string.Empty)
                {
                    dtStartDate =
                                          (
                                             from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                             from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                             from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                             where ("," + TitleCodes.ToString().Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value) && objDMR.Right_Type == "M" && objDMR.Milestone_Unit_Type == 4
                                             select objDMR.Actual_Right_Start_Date
                                         ).Min().ToString();
                    dtEndDate =
                                       (
                                          from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                          from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                          from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                          where ("," + TitleCodes.ToString().Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value) && objDMR.Right_Type == "M" && objDMR.Milestone_Unit_Type == 4
                                          select objDMR.Actual_Right_End_Date
                                      ).Max().ToString();

                    if (dtStartDate == string.Empty & dtEndDate == string.Empty)
                    {
                        if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                        {
                            term = (from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                    from Acq_Deal_Movie objTL in objAcq_Deal.Acq_Deal_Movie
                                    from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                    from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                    where ("," + TitleCodes.ToString().Replace('~', ',').Trim(',') + ",").Contains("," + objTL.Acq_Deal_Movie_Code.ToString() + ",") && objTL.Title_Code == objDMRT.Title_Code
                                           && objTL.Episode_Starts_From == objDMRT.Episode_From && objTL.Episode_End_To == objDMRT.Episode_To && CheckPlatformForRun(objDMRP.Platform_Code.Value) && objDMR.Right_Type == "M" && objDMR.Milestone_Unit_Type == 4
                                    select objDMR.Milestone_No_Of_Unit.Value).FirstOrDefault();
                        }
                        else
                        {
                            term = (from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                    from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                    from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                    where ("," + TitleCodes.ToString().Replace('~', ',').Trim(',') + ",").Contains("," + objDMRT.Title_Code.ToString() + ",") && CheckPlatformForRun(objDMRP.Platform_Code.Value) && objDMR.Right_Type == "M" && objDMR.Milestone_Unit_Type == 4
                                    select objDMR.Milestone_No_Of_Unit.Value).FirstOrDefault();
                        }
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

                    if (objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run != null && objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run.Count != 0)
                        objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run.Clear();

                    objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run = new HashSet<Acq_Deal_Run_Yearwise_Run>();
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

                        Acq_Deal_Run_Yearwise_Run obj = new Acq_Deal_Run_Yearwise_Run();

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
                        objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run.Add(obj);
                    }
                    ViewBag.RightType = "Y";
                }
                else
                    if (term != 0)
                {
                    if (objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run != null && objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run.Count != 0)
                        objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run.Clear();

                    objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run = new HashSet<Acq_Deal_Run_Yearwise_Run>();
                    int noOfRunPerYear = 0;
                    int sumOfRun = 0;
                    if (!string.IsNullOrEmpty(txtNoOfRun))
                        noOfRunPerYear = Convert.ToInt32(Math.Round((Convert.ToDecimal(txtNoOfRun) / term)));
                    else
                        txtNoOfRun = "0";
                    for (int i = 1; i <= term; i++)
                    {
                        Acq_Deal_Run_Yearwise_Run obj = new Acq_Deal_Run_Yearwise_Run();
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
                        objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run.Add(obj);
                    }
                    ViewBag.RightType = "M";
                }
                else
                {
                    return PartialView("_Run_Yearwise", null);
                }
                return PartialView("_Run_Yearwise", objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run.ToList());
            }
            else
            {
                return PartialView("_Run_Yearwise", null);
            }

        }

        public PartialViewResult PartialYearWiseList()
        {
            return PartialView("_Run_Yearwise", objAcq_Deal_Run.Acq_Deal_Run_Yearwise_Run.ToList());
        }

        [HttpPost]
        public PartialViewResult PartialChannelList(string channelCodes, string channelDefinitionType, string txtNoOfRun, string ChannelCategoryChecked)
        {
            Acq_Deal_Run objRun = new Acq_Deal_Run();
            if (ChannelCategoryChecked == "C")
            {
                string[] arr = channelCodes.Split(',');
                List<RightsU_Entities.Channel> lstChannel = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(c => arr.Contains(c.Channel_Code.ToString())).ToList();

                objRun.Run_Definition_Type = channelDefinitionType;
                foreach (RightsU_Entities.Channel objChannel in lstChannel)
                {
                    Acq_Deal_Run_Channel objDRRunChannel = new Acq_Deal_Run_Channel();
                    objDRRunChannel.Channel_Code = objChannel.Channel_Code;
                    objDRRunChannel.ChannelNames = objChannel.Channel_Name;
                    objDRRunChannel.EntityState = State.Added;
                    objRun.Acq_Deal_Run_Channel.Add(objDRRunChannel);
                }

                if (channelDefinitionType == GlobalParams.CHANNEL_WISE)
                {
                    List<Acq_Deal_Run_Channel> lstRunChannel = objRun.Acq_Deal_Run_Channel.ToList();
                    int noOfRunPerYear = 0;
                    int sumOfRun = 0;
                    if (!string.IsNullOrEmpty(txtNoOfRun))
                        noOfRunPerYear = Convert.ToInt32(Math.Round((Convert.ToDecimal(txtNoOfRun) / lstRunChannel.Count)));
                    for (int i = 0; i < lstRunChannel.Count; i++)
                    {
                        Acq_Deal_Run_Channel obj = lstRunChannel[i];
                        if (noOfRunPerYear != 0)
                        {
                            if (sumOfRun < Convert.ToInt32(txtNoOfRun))
                            {
                                if (i == (lstRunChannel.Count - 1))
                                    obj.Min_Runs = Convert.ToInt32(txtNoOfRun) - (noOfRunPerYear * (lstRunChannel.Count - 1));
                                else
                                    obj.Min_Runs = noOfRunPerYear;
                                sumOfRun = sumOfRun + obj.Min_Runs.Value;
                            }
                            else
                                obj.Min_Runs = 0;
                        }
                    }
                }
            }
            else
            {
                int channelCategoryCode = Convert.ToInt32(channelCodes);
                string[] arrchannel = new Channel_Category_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Channel_Category_Code == channelCategoryCode).Select(s => s.Channel_Code.ToString()).ToArray();
                //string[] arr = channelCodes.Split(',');
                List<RightsU_Entities.Channel> lstChannel = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(c => arrchannel.Contains(c.Channel_Code.ToString())).ToList();

                objRun.Run_Definition_Type = channelDefinitionType;
                foreach (RightsU_Entities.Channel objChannel in lstChannel)
                {
                    Acq_Deal_Run_Channel objDRRunChannel = new Acq_Deal_Run_Channel();
                    objDRRunChannel.Channel_Code = objChannel.Channel_Code;
                    objDRRunChannel.ChannelNames = objChannel.Channel_Name;
                    objDRRunChannel.EntityState = State.Added;
                    objRun.Acq_Deal_Run_Channel.Add(objDRRunChannel);
                }

                if (channelDefinitionType == GlobalParams.CHANNEL_WISE)
                {
                    List<Acq_Deal_Run_Channel> lstRunChannel = objRun.Acq_Deal_Run_Channel.ToList();
                    int noOfRunPerYear = 0;
                    int sumOfRun = 0;
                    if (!string.IsNullOrEmpty(txtNoOfRun))
                        noOfRunPerYear = Convert.ToInt32(Math.Round((Convert.ToDecimal(txtNoOfRun) / lstRunChannel.Count)));
                    for (int i = 0; i < lstRunChannel.Count; i++)
                    {
                        Acq_Deal_Run_Channel obj = lstRunChannel[i];
                        if (noOfRunPerYear != 0)
                        {
                            if (sumOfRun < Convert.ToInt32(txtNoOfRun))
                            {
                                if (i == (lstRunChannel.Count - 1))
                                    obj.Min_Runs = Convert.ToInt32(txtNoOfRun) - (noOfRunPerYear * (lstRunChannel.Count - 1));
                                else
                                    obj.Min_Runs = noOfRunPerYear;
                                sumOfRun = sumOfRun + obj.Min_Runs.Value;
                            }
                            else
                                obj.Min_Runs = 0;
                        }
                    }
                }
            }
            return PartialView("_Run_Channelwise", objRun);
        }

        [HttpPost]
        public PartialViewResult PartialChannelList1(string Acq_Deal_Run_Code)
        {
            Channel_Service objChannel_Service = new Channel_Service(objLoginEntity.ConnectionStringName);
            objAcq_Deal_Run.Acq_Deal_Run_Channel.ToList().ForEach(c =>
            {
                RightsU_Entities.Channel objChannel = new Channel_Service(objLoginEntity.ConnectionStringName).GetById(c.Channel_Code.Value);
                c.ChannelNames = objChannel.Channel_Name;
            });
            return PartialView("_Run_Channelwise", objAcq_Deal_Run);
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

        public JsonResult GetRightRule(string RightRuleCode)
        {
            int code = Convert.ToInt32(RightRuleCode);
            var objRightRule = new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(r => r.Right_Rule_Code == code).Select(r => new { r.Start_Time, r.Play_Per_Day, r.No_Of_Repeat, r.Duration_Of_Day });
            return Json(objRightRule);
        }
        public void SetEntityStateRunTitle(string hdnTitleRunDefinition, Acq_Deal_Run objDR)
        {
            ICollection<Acq_Deal_Run_Title> selectedTitle = new HashSet<Acq_Deal_Run_Title>();
            string[] arrtitle = hdnTitleRunDefinition.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string str in arrtitle)
            {
                if (str != String.Empty)
                {
                    Acq_Deal_Run_Title objART = new Acq_Deal_Run_Title();

                    int code = Convert.ToInt32((string.IsNullOrEmpty(str)) ? "0" : str);

                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        Title_List objTL = null;
                        objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();
                        objART.Episode_From = objTL.Episode_From;
                        objART.Episode_To = objTL.Episode_To;
                        objART.Title_Code = objTL.Title_Code;
                    }
                    else
                    {
                        objART.Episode_From = 1;
                        objART.Episode_To = 1;
                        objART.Title_Code = code;
                    }

                    selectedTitle.Add(objART);
                }
            }

            IEqualityComparer<Acq_Deal_Run_Title> ComparerRepeat = null;
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                ComparerRepeat = new LambdaComparer<Acq_Deal_Run_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To);
            else
                ComparerRepeat = new LambdaComparer<Acq_Deal_Run_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Run_Title = new List<Acq_Deal_Run_Title>();
            var Updated_Acq_Deal_Run_Title = new List<Acq_Deal_Run_Title>();
            var Added_Acq_Deal_Run_Title = CompareLists<Acq_Deal_Run_Title>(selectedTitle.ToList(), objDR.Acq_Deal_Run_Title.ToList(), ComparerRepeat, ref Deleted_Acq_Deal_Run_Title, ref Updated_Acq_Deal_Run_Title);

            Deleted_Acq_Deal_Run_Title.ToList<Acq_Deal_Run_Title>().ForEach(t => t.EntityState = State.Deleted);
        }
        public JsonResult Save(Acq_Deal_Run objRun, FormCollection objFormCollection, List<Acq_Deal_Run_Yearwise_Run> lstYearwiseRun, string[] lbChannel, string lbChannelCluster, string ddlPrimaryChannel, string ddlPrimaryChannelCluster, string[] ddlPTitle,
          string Is_Prime_OffPrime_Defn, string Prime_Start_Time, string Prime_End_Time, string Prime_Run, string Off_Prime_Start_Time, string Off_Prime_End_Time, string Off_Prime_Run
           , string txtTimeLag, string hdnDays, string hdnIs_Channel_Definition_Rights, string hdnIs_Yearwise_Definition, string hdnTabName = "")
        {
            bool IsValidRunPeriod = true;
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objAcq_Deal.Deal_Type_Code.Value);
            DateTime MinStartDate = DateTime.Now, MaxEndDate = DateTime.Now;
            string MinMaxPeriod = objFormCollection["ddlPeriod"];
            if (MinMaxPeriod != null)
            {
                IsValidRunPeriod = ValidateRunPeriod(MinMaxPeriod);

                string[] lstMinMaxPeriod = MinMaxPeriod.Split(',');
                var lstPeriodRange = lstMinMaxPeriod.Select(s => s.Split('~')).ToList();

                List<DateTime> DT = new List<DateTime>();
                foreach (var item in lstPeriodRange)
                {
                    foreach (var it in item)
                    {
                        DT.Add(Convert.ToDateTime(it));
                    }
                }


                MinStartDate = DT.Min();
                MaxEndDate = DT.Max();
            }
            else if (hdnIs_Yearwise_Definition == "Y")
            {
                List<DateTime> DTNew = new List<DateTime>();

                MinStartDate = lstYearwiseRun.Select(s => Convert.ToDateTime(s.Start_Date_Str)).Min();
                MaxEndDate = lstYearwiseRun.Select(s => Convert.ToDateTime(s.End_Date_Str)).Max();
                //foreach (var item in lstYearwiseRun)
                //{
                //    DTNew.Add();
                //}
            }
            else
            {
                if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    arrobjAcqDealRights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).ToList();
                    string[] arrayCodes = ddlPTitle;
                    string dtSDate =
                                           (
                                              from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                              from Acq_Deal_Movie objTL in objAcq_Deal.Acq_Deal_Movie
                                              from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                              where arrayCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString()) && objTL.Title_Code == objDMRT.Title_Code
                                              && objTL.Episode_Starts_From == objDMRT.Episode_From && objTL.Episode_End_To == objDMRT.Episode_To
                                              select objDMR.Right_Start_Date
                                          ).Min().ToString();

                    string dtEDate =
                                       (
                                           from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                           from Acq_Deal_Movie objTL in objAcq_Deal.Acq_Deal_Movie
                                           from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                           where arrayCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString()) && objTL.Title_Code == objDMRT.Title_Code
                                           && objTL.Episode_Starts_From == objDMRT.Episode_From && objTL.Episode_End_To == objDMRT.Episode_To
                                           select objDMR.Right_End_Date
                                      ).Max().ToString();

                    MinStartDate = Convert.ToDateTime(dtSDate);
                    MaxEndDate = Convert.ToDateTime(dtEDate);

                    string JoinTitCode = String.Join(",", ddlPTitle);
                    IsValidRunPeriod = ValidateTitles(JoinTitCode);
                }
                else
                {
                    arrobjAcqDealRights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).ToList();
                    string[] arrayCodes = ddlPTitle;
                    string dtSDate =
                                               (
                                                   from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                                   from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                                   from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                                   where arrayCodes.Contains(objDMRT.Title_Code.ToString()) && CheckPlatformForRun(objDMRP.Platform_Code.Value)
                                                   select objDMR.Right_Start_Date
                                               ).Min().ToString();

                    string dtEDate =
                                        (
                                                  from Acq_Deal_Rights objDMR in arrobjAcqDealRights
                                                  from Acq_Deal_Rights_Title objDMRT in objDMR.Acq_Deal_Rights_Title
                                                  from Acq_Deal_Rights_Platform objDMRP in objDMR.Acq_Deal_Rights_Platform
                                                  where arrayCodes.Contains(objDMRT.Title_Code.ToString()) && CheckPlatformForRun(objDMRP.Platform_Code.Value)
                                                  select objDMR.Right_End_Date
                                              ).Max().ToString();
                    MinStartDate = Convert.ToDateTime(dtSDate);
                    MaxEndDate = Convert.ToDateTime(dtEDate);

                    string JoinTitCode = String.Join(",", ddlPTitle);
                    IsValidRunPeriod = ValidateTitles(JoinTitCode);
                }
            }


            string RunDefType = objFormCollection["Run_Definition_Type"];

            if (RunDefType == "S" || RunDefType == "N")
            {
                lstMatrixDataFinal.Clear();
            }

            string validMatrix = "", validChannelYear = "";
            if (hdnIs_Yearwise_Definition == "Y" && objRun.Acq_Deal_Run_Channel.ToList().Count > 0)
            {

                if (lstMatrixDataFinal.Count == 0 && objRun.Acq_Deal_Run_Code == 0 && RunDefType == "C")
                {
                    validMatrix = "M";
                }
                //if (lstMatrixDataFinal.Count == 0 && objRun.Acq_Deal_Run_Code > 0)
                //{
                //    validMatrix = "Edit";
                //}
            }
            if (hdnIs_Yearwise_Definition == "Y" && objRun.Acq_Deal_Run_Channel.ToList().Count > 0 && RunDefType == GlobalParams.CHANNEL_WISE && lstMatrixDataFinal.Count == 0)
            {
                validMatrix = "M";
            }
            else if (hdnIs_Yearwise_Definition == "Y" && objRun.Acq_Deal_Run_Channel.ToList().Count > 0)
            {
                validChannelYear = ValidateRunWithMatrix(lstYearwiseRun, objRun.Acq_Deal_Run_Channel.ToList(), lstMatrixDataFinal);
            }
            else
            {
                validChannelYear = "true";

            }
            if (objDeal_Schema.Deal_Type_Condition == "SPORTSTYPE")
            {
                List<RightsU_Entities.Channel> lstChannel = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(c => lbChannel.Contains(c.Channel_Code.ToString())).ToList();

                foreach (RightsU_Entities.Channel objChannel in lstChannel)
                {
                    Acq_Deal_Run_Channel objDRRunChannel = new Acq_Deal_Run_Channel();
                    objDRRunChannel.Channel_Code = objChannel.Channel_Code;
                    objDRRunChannel.ChannelNames = objChannel.Channel_Name;
                    objDRRunChannel.EntityState = State.Added;
                    objRun.Acq_Deal_Run_Channel.Add(objDRRunChannel);
                }
            }

            List<USP_Validate_Run_UDT> lstUSP_Validate_Run_UDT = ValidateRunWithScheduleRun(ddlPTitle, hdnIs_Yearwise_Definition, lstYearwiseRun, hdnIs_Channel_Definition_Rights, objRun.Acq_Deal_Run_Channel.ToList());

            if (lstUSP_Validate_Run_UDT.Count == 0)
            {
                string Message = string.Empty;
                dynamic resultSet;
                if (objRun.Acq_Deal_Run_Code == 0)
                    objAcq_Deal_Run = new Acq_Deal_Run();
                else
                {
                    objAcq_Deal_Run = null;
                    objAcq_Deal_Run = objADRS.GetById(objRun.Acq_Deal_Run_Code);
                }

                //string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(((Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA]).Deal_Type_Code);
                List<string> strTitleCodes = ddlPTitle.ToList();

                int Count = 0;
                if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    Count = (from objADRT in objAcq_Deal_Run.Acq_Deal_Run_Title
                             join objTL in objAcq_Deal.Acq_Deal_Movie
                             on objADRT.Title_Code equals objTL.Title_Code
                             where strTitleCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString()) && objTL.Episode_Starts_From == objADRT.Episode_From && objTL.Episode_End_To == objADRT.Episode_To
                             select objADRT
                     ).Count();
                }
                else
                    Count = objAcq_Deal_Run.Acq_Deal_Run_Title.Where(rt => strTitleCodes.Contains(rt.Title_Code.ToString())).Count();



                if (Count == 1)
                {
                    string tCode = string.Empty;

                    if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                    {

                        tCode = (from Acq_Deal_Run_Title objADRT in objAcq_Deal_Run.Acq_Deal_Run_Title
                                 join objTL in objAcq_Deal.Acq_Deal_Movie
                                 on objADRT.Title_Code equals objTL.Title_Code
                                 where strTitleCodes.Contains(objTL.Acq_Deal_Movie_Code.ToString()) && objTL.Episode_Starts_From == objADRT.Episode_From && objTL.Episode_End_To == objADRT.Episode_To
                                 select objTL.Acq_Deal_Movie_Code.ToString()
                             ).FirstOrDefault();
                    }
                    else
                        tCode = objAcq_Deal_Run.Acq_Deal_Run_Title.SingleOrDefault(rt => strTitleCodes.Contains(rt.Title_Code.ToString())).Title_Code.ToString();

                    strTitleCodes.Remove(tCode);
                    strTitleCodes.Insert(0, tCode);
                }
                else
                    Count = 1;

                foreach (string strTitleCode in strTitleCodes)
                {
                    int code = string.IsNullOrEmpty(strTitleCode) ? 0 : Convert.ToInt32(strTitleCode);

                    Acq_Deal_Movie objTL = null;
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        objTL = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();

                    if (objAcq_Deal_Run.Acq_Deal_Run_Code == 0)
                        objAcq_Deal_Run = new Acq_Deal_Run();

                    int titleCount = 0;
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        titleCount = objAcq_Deal_Run.Acq_Deal_Run_Title.Where(x => x.Title_Code == objTL.Title_Code && x.Episode_From == objTL.Episode_Starts_From &&
                            x.Episode_To == objTL.Episode_End_To).Count();
                    }
                    else
                        titleCount = objAcq_Deal_Run.Acq_Deal_Run_Title.Where(x => x.Title_Code == code).Count();

                    if (strTitleCodes.Count > 1 && titleCount == 0 && objAcq_Deal_Run.Acq_Deal_Run_Code > 0 && Count != 1)
                    {
                        objAcq_Deal_Run = new Acq_Deal_Run();
                    }

                    //Acq_Deal_Movie objTL = null;
                    //if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                    //    objTL = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();


                    objAcq_Deal_Run.Acq_Deal_Code = objAcq_Deal.Acq_Deal_Code;
                    //objAcq_Deal_Run.Acq_Deal_Run_Code = objRun.Acq_Deal_Run_Code;
                    objAcq_Deal_Run.Is_Channel_Definition_Rights = hdnIs_Channel_Definition_Rights;//objRun.Is_Channel_Definition_Rights;
                    objAcq_Deal_Run.Is_Rule_Right = objRun.Is_Rule_Right;
                    if (!string.IsNullOrEmpty(hdnIs_Yearwise_Definition))
                        objAcq_Deal_Run.Is_Yearwise_Definition = hdnIs_Yearwise_Definition;
                    else
                        objAcq_Deal_Run.Is_Yearwise_Definition = "N";
                    objAcq_Deal_Run.No_Of_Days_Hrs = objRun.No_Of_Days_Hrs;
                    objAcq_Deal_Run.No_Of_Runs = objRun.No_Of_Runs;
                    objAcq_Deal_Run.Syndication_Runs = objRun.Syndication_Runs;
                    objAcq_Deal_Run.Primary_Channel_Code = objRun.Primary_Channel_Code;
                    objAcq_Deal_Run.Repeat_Within_Days_Hrs = objRun.Repeat_Within_Days_Hrs;
                    objAcq_Deal_Run.Right_Rule_Code = objRun.Right_Rule_Code;
                    objAcq_Deal_Run.Run_Definition_Type = objRun.Run_Definition_Type;
                    objAcq_Deal_Run.Run_Type = objRun.Run_Type;
                    objAcq_Deal_Run.Time_Lag_Simulcast = objRun.Time_Lag_Simulcast;
                    objAcq_Deal_Run.Channel_Type = objRun.Channel_Type;
                    if (objRun.Channel_Type == "G")
                        objAcq_Deal_Run.Channel_Category_Code = Convert.ToInt32(lbChannelCluster);
                    else
                        objAcq_Deal_Run.Channel_Category_Code = null;

                    objAcq_Deal_Run.Start_Date = MinStartDate;
                    objAcq_Deal_Run.End_Date = MaxEndDate;

                    #region -- SAVE PRIME/OFF-PRIME DETAILS

                    if (Is_Prime_OffPrime_Defn == "N" || Is_Prime_OffPrime_Defn == null)
                    {
                        objAcq_Deal_Run.Off_Prime_Start_Time = null;
                        objAcq_Deal_Run.Off_Prime_End_Time = null;
                        objAcq_Deal_Run.Off_Prime_Run = null;
                        objAcq_Deal_Run.Prime_Start_Time = null;
                        objAcq_Deal_Run.Prime_End_Time = null;
                        objAcq_Deal_Run.Prime_Run = null;
                    }
                    else
                        if (objAcq_Deal_Run.No_Of_Runs.ToString() == Prime_Run)
                    {
                        if (!string.IsNullOrEmpty(Prime_Start_Time))
                            objAcq_Deal_Run.Prime_Start_Time = Convert.ToDateTime(Prime_Start_Time).TimeOfDay;
                        else
                            objAcq_Deal_Run.Prime_Start_Time = null;

                        if (!string.IsNullOrEmpty(Prime_End_Time))
                            objAcq_Deal_Run.Prime_End_Time = Convert.ToDateTime(Prime_End_Time).TimeOfDay;
                        else
                            objAcq_Deal_Run.Prime_End_Time = null;

                        if (!string.IsNullOrEmpty(Prime_Run))
                            objAcq_Deal_Run.Prime_Run = Convert.ToInt32(Prime_Run);
                        else
                            objAcq_Deal_Run.Prime_Run = null;
                        objAcq_Deal_Run.Off_Prime_Start_Time = null;
                        objAcq_Deal_Run.Off_Prime_End_Time = null;
                        objAcq_Deal_Run.Off_Prime_Run = null;
                    }
                    else
                            if (objAcq_Deal_Run.No_Of_Runs.ToString() == Off_Prime_Run)
                    {
                        if (!string.IsNullOrEmpty(Off_Prime_Start_Time))
                            objAcq_Deal_Run.Off_Prime_Start_Time = Convert.ToDateTime(Off_Prime_Start_Time).TimeOfDay;
                        else
                            objAcq_Deal_Run.Off_Prime_Start_Time = null;

                        if (!string.IsNullOrEmpty(Off_Prime_End_Time))
                            objAcq_Deal_Run.Off_Prime_End_Time = Convert.ToDateTime(Off_Prime_End_Time).TimeOfDay;
                        else
                            objAcq_Deal_Run.Off_Prime_End_Time = null;

                        if (!string.IsNullOrEmpty(Off_Prime_Run))
                            objAcq_Deal_Run.Off_Prime_Run = Convert.ToInt32(Off_Prime_Run);
                        else
                            objAcq_Deal_Run.Off_Prime_Run = null;
                        objAcq_Deal_Run.Prime_Start_Time = null;
                        objAcq_Deal_Run.Prime_End_Time = null;
                        objAcq_Deal_Run.Prime_Run = null;
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(Prime_Start_Time))
                            objAcq_Deal_Run.Prime_Start_Time = Convert.ToDateTime(Prime_Start_Time).TimeOfDay;
                        else
                            objAcq_Deal_Run.Prime_Start_Time = null;

                        if (!string.IsNullOrEmpty(Prime_End_Time))
                            objAcq_Deal_Run.Prime_End_Time = Convert.ToDateTime(Prime_End_Time).TimeOfDay;
                        else
                            objAcq_Deal_Run.Prime_End_Time = null;

                        if (!string.IsNullOrEmpty(Prime_Run))
                            objAcq_Deal_Run.Prime_Run = Convert.ToInt32(Prime_Run);
                        else
                            objAcq_Deal_Run.Prime_Run = null;

                        if (!string.IsNullOrEmpty(Off_Prime_Start_Time))
                            objAcq_Deal_Run.Off_Prime_Start_Time = Convert.ToDateTime(Off_Prime_Start_Time).TimeOfDay;
                        else
                            objAcq_Deal_Run.Off_Prime_Start_Time = null;

                        if (!string.IsNullOrEmpty(Off_Prime_End_Time))
                            objAcq_Deal_Run.Off_Prime_End_Time = Convert.ToDateTime(Off_Prime_End_Time).TimeOfDay;
                        else
                            objAcq_Deal_Run.Off_Prime_End_Time = null;

                        if (!string.IsNullOrEmpty(Off_Prime_Run))
                            objAcq_Deal_Run.Off_Prime_Run = Convert.ToInt32(Off_Prime_Run);
                        else
                            objAcq_Deal_Run.Off_Prime_Run = null;
                    }

                    #endregion

                    objAcq_Deal_Run.Prime_Time_Balance_Count = Convert.ToInt32(string.IsNullOrEmpty(Prime_Run) ? "0" : Prime_Run) -
                                                   (objAcq_Deal_Run.Prime_Time_Provisional_Run_Count == null ? 0 : objAcq_Deal_Run.Prime_Time_Provisional_Run_Count);
                    objAcq_Deal_Run.Off_Prime_Time_Balance_Count = Convert.ToInt32(string.IsNullOrEmpty(Off_Prime_Run) ? "0" : Off_Prime_Run) -
                                                        (objAcq_Deal_Run.Off_Prime_Time_Provisional_Run_Count == null ? 0 : objAcq_Deal_Run.Off_Prime_Time_Provisional_Run_Count);

                    #region ----- SAVE YEARWISE RUN DEFINITION -----
                    //if (objAcq_Deal_Run.Is_Yearwise_Definition == "Y")
                    //{
                    ICollection<Acq_Deal_Run_Yearwise_Run> selectedYearwiseRuns = new HashSet<Acq_Deal_Run_Yearwise_Run>();

                    if (lstYearwiseRun != null)
                        foreach (Acq_Deal_Run_Yearwise_Run objRunYearWise in lstYearwiseRun)
                        {
                            Acq_Deal_Run_Yearwise_Run objYRun = new Acq_Deal_Run_Yearwise_Run();
                            if (objRunYearWise.Start_Date_Str != null)
                                objYRun.Start_Date = Convert.ToDateTime(objRunYearWise.Start_Date_Str);
                            if (objRunYearWise.End_Date_Str != null)
                                objYRun.End_Date = Convert.ToDateTime(objRunYearWise.End_Date_Str);
                            objYRun.No_Of_Runs = objRunYearWise.No_Of_Runs;
                            objYRun.Year_No = objRunYearWise.Year_No;
                            objYRun.EntityState = State.Added;
                            selectedYearwiseRuns.Add(objYRun);
                        }

                    IEqualityComparer<Acq_Deal_Run_Yearwise_Run> ComparerYearwiseRun = new LambdaComparer<Acq_Deal_Run_Yearwise_Run>((x, y)
                        => x.End_Date == y.End_Date && x.No_Of_AsRuns == y.No_Of_AsRuns && x.No_Of_Runs == y.No_Of_Runs && x.No_Of_Runs_Sched
                        == y.No_Of_Runs_Sched && x.Start_Date == y.Start_Date && x.Year_No == y.Year_No && x.EntityState != State.Deleted);
                    var Deleted_Deal_Run_Yearwise_Run = new List<Acq_Deal_Run_Yearwise_Run>();
                    var Updated_Deal_Run_Yearwise_Run = new List<Acq_Deal_Run_Yearwise_Run>();
                    var Added_Deal_Run_Yearwise_Run = CompareLists<Acq_Deal_Run_Yearwise_Run>(selectedYearwiseRuns.ToList(), objAcq_Deal_Run.Acq_Deal_Run_Yearwise_Run.ToList(), ComparerYearwiseRun, ref Deleted_Deal_Run_Yearwise_Run, ref Updated_Deal_Run_Yearwise_Run);

                    Added_Deal_Run_Yearwise_Run.ToList<Acq_Deal_Run_Yearwise_Run>().ForEach(t => objAcq_Deal_Run.Acq_Deal_Run_Yearwise_Run.Add(t));
                    Deleted_Deal_Run_Yearwise_Run.ToList<Acq_Deal_Run_Yearwise_Run>().ForEach(t => t.EntityState = State.Deleted);
                    //}

                    #endregion

                    #region -- SAVE DEAL RUN TITLE DATA --
                    if (objAcq_Deal_Run.Acq_Deal_Run_Title.Count() > 0)
                    {
                        SetEntityStateRunTitle(strTitleCode, objAcq_Deal_Run);
                    }
                    //objAcq_Deal_Run.Acq_Deal_Run_Title.ToList().ForEach(t => t.EntityState = State.Deleted);
                    Acq_Deal_Run_Title objDealRunTitle;
                    if (objAcq_Deal_Run.Acq_Deal_Run_Code == 0)
                    {
                        objDealRunTitle = new Acq_Deal_Run_Title();
                        if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                        {
                            objDealRunTitle.Title_Code = objTL.Title_Code;
                            objDealRunTitle.Episode_From = objTL.Episode_Starts_From;
                            objDealRunTitle.Episode_To = objTL.Episode_End_To;
                        }
                        else
                        {
                            objDealRunTitle.Title_Code = code;
                            objDealRunTitle.Episode_From = 1;
                            objDealRunTitle.Episode_To = 1;
                        }

                        objDealRunTitle.EntityState = State.Added;
                        objAcq_Deal_Run.Acq_Deal_Run_Title.Add(objDealRunTitle);
                    }
                    else
                    {
                        if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                            objDealRunTitle = objAcq_Deal_Run.Acq_Deal_Run_Title.Where(x => x.Title_Code == objTL.Title_Code
                                && x.Episode_From == objTL.Episode_Starts_From && x.Episode_To == objTL.Episode_End_To).FirstOrDefault();
                        else
                            objDealRunTitle = objRun.Acq_Deal_Run_Title.Where(x => x.Title_Code == code).FirstOrDefault();
                        //if (objDealRunTitle.Acq_Deal_Run_Title_Code > 0)
                        //    objDealRunTitle.EntityState = State.Modified;
                        //else
                        //    objDealRunTitle.EntityState = State.Added;
                        if (objDealRunTitle == null)
                        {
                            objDealRunTitle = new Acq_Deal_Run_Title();
                            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                            {
                                objDealRunTitle.Title_Code = objTL.Title_Code;
                                objDealRunTitle.Episode_From = objTL.Episode_Starts_From;
                                objDealRunTitle.Episode_To = objTL.Episode_End_To;
                            }
                            else
                            {
                                objDealRunTitle.Title_Code = code;
                                objDealRunTitle.Episode_From = 1;
                                objDealRunTitle.Episode_To = 1;
                            }
                            objDealRunTitle.EntityState = State.Added;
                            objAcq_Deal_Run.Acq_Deal_Run_Title.Add(objDealRunTitle);
                        }
                        //else
                        //    objDealRunTitle.EntityState = State.Unchanged;

                    }

                    #endregion

                    #region -- SAVE DEAL RULE RIGHT DATA --

                    if (objRun.Is_Rule_Right == "Y")
                    {

                        ICollection<Acq_Deal_Run_Repeat_On_Day> selectedRuns = new HashSet<Acq_Deal_Run_Repeat_On_Day>();
                        if (objRun.Repeat_Within_Days_Hrs == "D")
                        {
                            if (!string.IsNullOrEmpty(hdnDays))
                            {
                                List<string> lstDays = hdnDays.Split(',').ToList();
                                for (int i = 0; i < lstDays.Count; i++)
                                {
                                    Acq_Deal_Run_Repeat_On_Day objARROD = new Acq_Deal_Run_Repeat_On_Day();
                                    objARROD.Day_Code = Convert.ToInt32(lstDays[i]);
                                    objARROD.EntityState = State.Added;
                                    selectedRuns.Add(objARROD);
                                }
                            }
                        }

                        IEqualityComparer<Acq_Deal_Run_Repeat_On_Day> ComparerRepeat = new LambdaComparer<Acq_Deal_Run_Repeat_On_Day>((x, y) => x.Day_Code == y.Day_Code && x.EntityState != State.Deleted);
                        var Deleted_Deal_Run_Repeat_On_Day = new List<Acq_Deal_Run_Repeat_On_Day>();
                        var Updated_Deal_Run_Repeat_On_Day = new List<Acq_Deal_Run_Repeat_On_Day>();
                        var Added_Deal_Run_Repeat_On_Day = CompareLists<Acq_Deal_Run_Repeat_On_Day>(selectedRuns.ToList(), objAcq_Deal_Run.Acq_Deal_Run_Repeat_On_Day.ToList(), ComparerRepeat, ref Deleted_Deal_Run_Repeat_On_Day, ref Updated_Deal_Run_Repeat_On_Day);

                        Added_Deal_Run_Repeat_On_Day.ToList<Acq_Deal_Run_Repeat_On_Day>().ForEach(t => objAcq_Deal_Run.Acq_Deal_Run_Repeat_On_Day.Add(t));
                        Deleted_Deal_Run_Repeat_On_Day.ToList<Acq_Deal_Run_Repeat_On_Day>().ForEach(t => t.EntityState = State.Deleted);
                    }

                    #endregion



                    if (objAcq_Deal_Run.Is_Channel_Definition_Rights == "Y")
                    {
                        if (objAcq_Deal_Run.Channel_Type == "C")
                        {
                            if (!string.IsNullOrEmpty(ddlPrimaryChannel) && ddlPrimaryChannel != "0")
                                objAcq_Deal_Run.Primary_Channel_Code = Convert.ToInt32(ddlPrimaryChannel);
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(ddlPrimaryChannelCluster) && ddlPrimaryChannelCluster != "0")
                                objAcq_Deal_Run.Primary_Channel_Code = Convert.ToInt32(ddlPrimaryChannelCluster);
                        }

                        ICollection<Acq_Deal_Run_Channel> selectedChannels = new HashSet<Acq_Deal_Run_Channel>();
                        objRun.Acq_Deal_Run_Channel.ToList().ForEach(c =>
                        {
                            Acq_Deal_Run_Channel objChannel = new Acq_Deal_Run_Channel();
                            objChannel.Acq_Deal_Run_Channel_Code = c.Acq_Deal_Run_Channel_Code;
                            objChannel.Acq_Deal_Run_Code = c.Acq_Deal_Run_Code;
                            objChannel.Channel_Code = c.Channel_Code;
                            objChannel.Do_Not_Consume_Rights = c.Do_Not_Consume_Rights;
                            objChannel.Max_Runs = c.Max_Runs;
                            objChannel.Min_Runs = c.Min_Runs;
                            objChannel.EntityState = State.Added;
                            selectedChannels.Add(objChannel);
                        });

                        if (selectedChannels.Count == 0)
                            if (objAcq_Deal_Run.Channel_Type == "C")
                            {
                                foreach (string strChannelCode in lbChannel)
                                {
                                    Acq_Deal_Run_Channel objDRunChnl = new Acq_Deal_Run_Channel();
                                    objDRunChnl.Channel_Code = Convert.ToInt32(strChannelCode);
                                    objDRunChnl.EntityState = State.Added;
                                    selectedChannels.Add(objDRunChnl);
                                }
                            }
                            else
                            {
                                int channelCategoryCode = Convert.ToInt32(lbChannelCluster);
                                string[] arrchannel = new Channel_Category_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Channel_Category_Code == channelCategoryCode).Select(s => s.Channel_Code.ToString()).ToArray();

                                foreach (string strChannelCode in arrchannel)
                                {
                                    Acq_Deal_Run_Channel objDRunChnl = new Acq_Deal_Run_Channel();
                                    objDRunChnl.Channel_Code = Convert.ToInt32(strChannelCode);
                                    objDRunChnl.EntityState = State.Added;
                                    selectedChannels.Add(objDRunChnl);
                                }
                            }
                        IEqualityComparer<Acq_Deal_Run_Channel> ComparerChannel = new LambdaComparer<Acq_Deal_Run_Channel>((x, y) => x.Channel_Code == y.Channel_Code && x.Do_Not_Consume_Rights == y.Do_Not_Consume_Rights && x.Is_Primary == y.Is_Primary && x.Max_Runs == y.Max_Runs && x.Min_Runs == y.Min_Runs && x.EntityState != State.Deleted);
                        var Deleted_Deal_Run_Channel = new List<Acq_Deal_Run_Channel>();
                        var Updated_Deal_Run_Channel = new List<Acq_Deal_Run_Channel>();
                        var Added_Deal_Run_Channel = CompareLists<Acq_Deal_Run_Channel>(selectedChannels.ToList(), objAcq_Deal_Run.Acq_Deal_Run_Channel.ToList(), ComparerChannel, ref Deleted_Deal_Run_Channel, ref Updated_Deal_Run_Channel);

                        Added_Deal_Run_Channel.ToList<Acq_Deal_Run_Channel>().ForEach(t => objAcq_Deal_Run.Acq_Deal_Run_Channel.Add(t));
                        Deleted_Deal_Run_Channel.ToList<Acq_Deal_Run_Channel>().ForEach(t => t.EntityState = State.Deleted);
                    }
                    else
                    {
                        objAcq_Deal_Run.Run_Definition_Type = GlobalParams.CHANNEL_NA;
                        objAcq_Deal_Run.Acq_Deal_Run_Channel.ToList().ForEach(t => t.EntityState = State.Deleted);
                    }

                    #region ---- Acq_Deal_Run_LP

                   

                    string period = objFormCollection["ddlPeriod"];
                    ICollection<Acq_Deal_Run_LP> selectedLP = new HashSet<Acq_Deal_Run_LP>();
                    if (period != null)
                    {
                        string[] lstPeriod = period.Split(',');
                        foreach (string item in lstPeriod)
                        {
                            Acq_Deal_Run_LP objRunLP = new Acq_Deal_Run_LP();
                            string[] SDED = item.Split('~');
                            DateTime SDATE = Convert.ToDateTime(SDED[0]);
                            DateTime EDATE = Convert.ToDateTime(SDED[1]);
                            objRunLP.Acq_Deal_Run_Code = objRun.Acq_Deal_Run_Code;
                            objRunLP.Year_Start = SDATE;
                            objRunLP.Year_End = EDATE;
                            objRunLP.EntityState = State.Added;
                            selectedLP.Add(objRunLP);
                        }
                    }
                    else
                    {
                        if (lstYearwiseRun != null)
                            foreach (Acq_Deal_Run_Yearwise_Run objRunYearWise in lstYearwiseRun)
                            {
                                Acq_Deal_Run_LP objRunLPN = new Acq_Deal_Run_LP();
                                if (objRunYearWise.Start_Date_Str != null)
                                    objRunLPN.Year_Start = Convert.ToDateTime(objRunYearWise.Start_Date_Str);
                                if (objRunYearWise.End_Date_Str != null)
                                    objRunLPN.Year_End = Convert.ToDateTime(objRunYearWise.End_Date_Str);
                                objRunLPN.Acq_Deal_Run_Code = objRun.Acq_Deal_Run_Code;
                                objRunLPN.EntityState = State.Added;
                                selectedLP.Add(objRunLPN);
                            }
                        else
                        {
                            string TITCODE = String.Join(",", ddlPTitle);
                            var PDATE = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_LP(objDeal_Schema.Deal_Code, TITCODE, 1, 1, 30).ToList();

                            foreach (var item in PDATE)
                            {
                                Acq_Deal_Run_LP objRunLPD = new Acq_Deal_Run_LP();
                                objRunLPD.Year_Start = Convert.ToDateTime(item.RightsStartDate);
                                objRunLPD.Year_End = Convert.ToDateTime(item.RightsEndDate);
                                objRunLPD.Acq_Deal_Run_Code = objRun.Acq_Deal_Run_Code;
                                objRunLPD.EntityState = State.Added;
                                selectedLP.Add(objRunLPD);
                            }

                        }

                    }
                    IEqualityComparer<Acq_Deal_Run_LP> ComparerLP = new LambdaComparer<Acq_Deal_Run_LP>((x, y) => x.Year_Start == y.Year_Start && x.Year_End == y.Year_End && x.EntityState != State.Deleted);
                    var Deleted_Deal_Run_LP = new List<Acq_Deal_Run_LP>();
                    var Updated_Deal_Run_LP = new List<Acq_Deal_Run_LP>();
                    var Added_Deal_Run_LP = CompareLists<Acq_Deal_Run_LP>(selectedLP.ToList(), objAcq_Deal_Run.Acq_Deal_Run_LP.ToList(), ComparerLP, ref Deleted_Deal_Run_LP, ref Updated_Deal_Run_LP);

                    Added_Deal_Run_LP.ToList<Acq_Deal_Run_LP>().ForEach(t => objAcq_Deal_Run.Acq_Deal_Run_LP.Add(t));
                    Deleted_Deal_Run_LP.ToList<Acq_Deal_Run_LP>().ForEach(t => t.EntityState = State.Deleted);

                    #endregion --- Acq_Deal_Run_LP

                    if (objAcq_Deal_Run.Acq_Deal_Run_Code > 0)
                    {
                        objAcq_Deal_Run.Last_updated_Time = DateTime.Now;
                        objAcq_Deal_Run.Last_action_By = objLoginUser.Users_Code;
                        objAcq_Deal_Run.EntityState = State.Modified;
                        Message = objMessageKey.RunDefinitionUpdatedSuccessfully;
                    }
                    else
                    {
                        objAcq_Deal_Run.Inserted_On = DateTime.Now;
                        objAcq_Deal_Run.Inserted_By = objLoginUser.Users_Code;
                        objAcq_Deal_Run.EntityState = State.Added;
                        Message = objMessageKey.RunDefinitionAddedSuccessfully;
                    }

                    objADRS.Save(objAcq_Deal_Run, out resultSet);
                    #region Check Linear Rights
                    Acq_Deal_Service objService = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                    Acq_Deal objAcq = objService.GetById(objDeal_Schema.Deal_Code);

                    /* List<int> lstTRightsTitleCodeLR = new List<int>();
                     foreach (var item in objAcq.Acq_Deal_Rights)
                     {
                         if (item.Acq_Deal_Rights_Platform.Where(x => x.Platform.Base_Platform_Code == 35).Count() > 0)
                         {
                             lstTRightsTitleCodeLR.Add(item.Acq_Deal_Rights_Title.Select(x => Convert.ToInt32(x.Title_Code)).Distinct().FirstOrDefault());
                         }
                     }

                     List<int> lstRunDefTitleCode = new List<int>();
                     var lst = objAcq.Acq_Deal_Run.Select(x => x.Acq_Deal_Run_Title.Select(y => y.Title_Code).FirstOrDefault()).ToList();

                     foreach (int item in lst.Distinct())
                     {
                         lstRunDefTitleCode.Add(item);
                     }
                     var result = lstTRightsTitleCodeLR.Distinct().Except(lstRunDefTitleCode).ToList();*/


                    string DealCompleteFlag = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Deal_Complete_Flag").Select(x => x.Parameter_Value).FirstOrDefault();
                    List<USP_List_Acq_Linear_Title_Status_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName)
                                                                 .USP_List_Acq_Linear_Title_Status(objDeal_Schema.Deal_Code).ToList();

                    int RunPending = DealCompleteFlag.Replace(" ", "") == "R,R" || DealCompleteFlag.Replace(" ", "") == "R,R,C" ? lst.Where(x => x.Title_Added == "Yes~").Count() : 0;
                    int RightsPending = lst.Where(x => x.Title_Added == "No").Count();

                    if (RunPending > 0 && RightsPending > 0)
                    {
                        objAcq.Deal_Workflow_Status = "RR";
                    }
                    else if (RunPending > 0 && RightsPending == 0)
                    {
                        objAcq.Deal_Workflow_Status = "RP";
                    }
                    else
                    {
                        objAcq.Deal_Workflow_Status = "N";
                    }

                    // objAcq.Deal_Workflow_Status = result.Count > 0 ? "RR" : "N";
                    objAcq.EntityState = State.Modified;
                    dynamic resultSet1;
                    bool isValid = objService.Save(objAcq, out resultSet1);

                    #endregion
                    if (objAcq_Deal_Run.Acq_Deal_Run_Code > 0 && Count == 1)
                    {
                        Title_List objTItleList;
                        if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                            objTItleList = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();
                        else
                            objTItleList = objDeal_Schema.Title_List.Where(x => x.Title_Code == code).FirstOrDefault();
                        // new USP_Service(objLoginEntity.ConnectionStringName).usp_Schedule_RUN_SAVE_Process(objAcq_Deal_Run.Acq_Deal_Run_Code, objTItleList.Title_Code, objTItleList.Acq_Deal_Movie_Code);
                    }

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
            else
            {
                return Json(lstUSP_Validate_Run_UDT);
            }

            //if (!string.IsNullOrEmpty(hdnTabName))
            //    return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo);
            //else
            //    return RedirectToAction("Index", "Acq_Run_List");
        }

        public List<USP_Validate_Run_UDT> ValidateRunWithScheduleRun(string[] hdnTitleRunDefinition, string IsYearwiseRunDefn, List<Acq_Deal_Run_Yearwise_Run> lstYearwiseRun, string IsChannelDefn, List<Acq_Deal_Run_Channel> lstChannel)
        {
            #region Fill Run Title UDT
            List<Deal_Run_Title_UDT> lstDeal_Run_Title = new List<Deal_Run_Title_UDT>();
            List<string> strTitleCodes = hdnTitleRunDefinition.ToList();

            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                objDeal_Schema.Title_List.Where(x => strTitleCodes.Contains(x.Acq_Deal_Movie_Code.ToString())).ToList().ForEach(t =>
                {
                    lstDeal_Run_Title.Add(new Deal_Run_Title_UDT { Deal_Run_Code = objAcq_Deal_Run.Acq_Deal_Run_Code, Title_Code = t.Title_Code, Episode_From = t.Episode_From, Episode_To = t.Episode_To });
                });
            }
            else
            {
                objDeal_Schema.Title_List.Where(x => strTitleCodes.Contains(x.Title_Code.ToString())).ToList().ForEach(t =>
                {
                    lstDeal_Run_Title.Add(new Deal_Run_Title_UDT { Deal_Run_Code = objAcq_Deal_Run.Acq_Deal_Run_Code, Title_Code = t.Title_Code, Episode_From = t.Episode_From, Episode_To = t.Episode_To });
                });
            }
            #endregion

            #region Fill Run Yearwise UDT
            List<Deal_Run_Yearwise_Run_UDT> lstDeal_Run_Yearwise_Run = new List<Deal_Run_Yearwise_Run_UDT>();

            if (IsYearwiseRunDefn == YesNo.Y.ToString())
            {
                if (lstYearwiseRun != null)
                {

                    lstYearwiseRun.ForEach(y =>
                    {
                        if (y.Start_Date_Str != null && y.End_Date_Str != null)
                        {
                            Deal_Run_Yearwise_Run_UDT objYRun = new Deal_Run_Yearwise_Run_UDT();
                            objYRun.Start_Date = Convert.ToDateTime(y.Start_Date_Str);
                            objYRun.End_Date = Convert.ToDateTime(y.End_Date_Str);
                            objYRun.No_Of_Runs = y.No_Of_Runs;
                            objYRun.Deal_Run_Code = y.Acq_Deal_Run_Code;
                            lstDeal_Run_Yearwise_Run.Add(objYRun);
                        }
                    });
                }
            }
            #endregion

            #region Fill Run Channel UDT
            List<Deal_Run_Channel_UDT> lstDeal_Run_Channel = new List<Deal_Run_Channel_UDT>();

            if (IsChannelDefn == YesNo.Y.ToString())
            {
                lstChannel.ForEach(c =>
                {
                    Deal_Run_Channel_UDT objDRunChnl = new Deal_Run_Channel_UDT();
                    objDRunChnl.Channel_Code = c.Channel_Code;
                    objDRunChnl.Min_Runs = c.Min_Runs;
                    objDRunChnl.Inserted_By = c.Inserted_By;
                    objDRunChnl.Last_action_By = c.Last_action_By;
                    objDRunChnl.Deal_Run_Code = objAcq_Deal_Run.Acq_Deal_Run_Code;
                    lstDeal_Run_Channel.Add(objDRunChnl);
                });
            }

            #endregion

            var arrInvalidData = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Run_Udt(lstDeal_Run_Title, lstDeal_Run_Yearwise_Run, lstDeal_Run_Channel, objDeal_Schema.Deal_Code).ToList();

            return arrInvalidData;
        }

        public ActionResult ChangeTabFromView(string hdnTabName = "")
        {
            if (TempData["QueryString_Run"] != null)
                TempData["QueryString_Run"] = null;
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
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

        public bool ValidateTitles(string titleCodes)
        {
            arrobjAcqDealRights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).ToList();
            USP_Service objUS = null;
            objUS = new USP_Service(objLoginEntity.ConnectionStringName);
            List<USP_VALIDATE_TITLES_FOR_YEARWISE_RUN_Result> objTitleCnt = objUS.USP_VALIDATE_TITLES_FOR_YEARWISE_RUN(titleCodes.Replace('~', ',').Trim(','), objAcq_Deal.Acq_Deal_Code).ToList();
            int result_count = objTitleCnt.Count;
            string[] strTitleCodes = titleCodes.ToString().Split(new char[] { ',' }, StringSplitOptions.None);

            if (result_count != strTitleCodes.Count())
                return false;
            return true;
        }

        public string ValidateRunWithMatrix(List<Acq_Deal_Run_Yearwise_Run> lstYearwiseRun, List<Acq_Deal_Run_Channel> lstChannel, List<MatrixData> lstMatrix)
        {
            string channelValid = "", yearValid = "", valid = "true";
            #region Fill Run Yearwise UDT
            List<Deal_Run_Yearwise_Run_UDT> lstDeal_Run_Yearwise_Run = new List<Deal_Run_Yearwise_Run_UDT>();

            if (lstYearwiseRun != null)
            {
                lstYearwiseRun.ForEach(y =>
                {
                    if (y.Start_Date_Str != null && y.End_Date_Str != null)
                    {
                        Deal_Run_Yearwise_Run_UDT objYRun = new Deal_Run_Yearwise_Run_UDT();
                        objYRun.Start_Date = Convert.ToDateTime(y.Start_Date_Str);
                        objYRun.End_Date = Convert.ToDateTime(y.End_Date_Str);
                        objYRun.No_Of_Runs = y.No_Of_Runs;
                        objYRun.Deal_Run_Code = y.Acq_Deal_Run_Code;
                        lstDeal_Run_Yearwise_Run.Add(objYRun);
                    }
                });
            }

            #endregion
            #region Fill Run Channel UDT
            List<Deal_Run_Channel_UDT> lstDeal_Run_Channel = new List<Deal_Run_Channel_UDT>();

            lstChannel.ForEach(c =>
            {
                Deal_Run_Channel_UDT objDRunChnl = new Deal_Run_Channel_UDT();
                objDRunChnl.Channel_Code = c.Channel_Code;
                objDRunChnl.Min_Runs = c.Min_Runs;
                objDRunChnl.Inserted_By = c.Inserted_By;
                objDRunChnl.Last_action_By = c.Last_action_By;
                objDRunChnl.Deal_Run_Code = objAcq_Deal_Run.Acq_Deal_Run_Code;
                lstDeal_Run_Channel.Add(objDRunChnl);
            });


            #endregion
            #region Fill Matrix Data
            List<MatrixData> lstMatrixRun = new List<MatrixData>();
            lstMatrix.ForEach(m =>
            {
                MatrixData objData = new MatrixData();
                objData.acqDealRunCode = m.acqDealRunCode;
                objData.Start_Date = m.Start_Date;
                objData.End_Date = m.End_Date;
                objData.Channel_Code = m.Channel_Code;
                objData.Channel_Name = m.Channel_Name;
                objData.Runs = m.Runs;
                lstMatrixRun.Add(objData);

            });
            #endregion

            List<MatrixData> result = lstMatrixDataFinal.GroupBy(l => l.Channel_Code).Select(cl => new MatrixData
            {
                Channel_Code = cl.First().Channel_Code,
                Runs = cl.Sum(c => c.Runs),
            }).ToList();

            List<MatrixData> resultYear = lstMatrixDataFinal.GroupBy(l => l.Start_Date).Select(cl => new MatrixData
            {
                Start_Date = cl.First().Start_Date,
                Runs = cl.Sum(c => c.Runs),
            }).ToList();
            foreach (var item in result)
            {
                foreach (var channel in lstDeal_Run_Channel)
                {
                    if (channel.Channel_Code == item.Channel_Code)
                    {
                        if (channel.Min_Runs != item.Runs)
                        {
                            valid = "C";
                            channelValid = "C";
                        }
                    }
                }
            }
            foreach (var item in resultYear)
            {
                foreach (var year in lstYearwiseRun)
                {
                    if (year.Start_Date_Str == item.Start_Date.ToString("dd/MM/yyyy"))
                    {
                        if (year.No_Of_Runs != item.Runs)
                        {
                            valid = "Y";
                            yearValid = "Y";
                        }
                    }
                }
            }
            if (channelValid != "" && yearValid != "")
            {
                valid = "CY";
            }

            return valid;

        }
        public JsonResult ValidateTitleOnSave(int Acq_Deal_Run_Code, string titleCodes)
        {
            string invalidMessage = "Valid";
            List<USP_VALIDATE_TITLES_FOR_YEARWISE_RUN_Result> objTitleCnt = new USP_Service(objLoginEntity.ConnectionStringName).USP_VALIDATE_TITLES_FOR_YEARWISE_RUN(titleCodes.Replace('~', ',').Trim(','), objAcq_Deal.Acq_Deal_Code).ToList();
            int result_count = objTitleCnt.Count;
            string[] strTitleCodes = titleCodes.ToString().Split(new char[] { ',' }, StringSplitOptions.None);

            if (result_count != strTitleCodes.Count())
            {
                invalidMessage = objMessageKey.Invalidavailableperiodforyearwiserun;//Invalid available period for yearwise run
                return Json(invalidMessage);
            }

            var minStDate = (
                                    from Acq_Deal_Run_Yearwise_Run objYrRun in objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run
                                    select objYrRun.Start_Date
                                  ).Min();

            var maxEnDate =
                            (
                                    from Acq_Deal_Run_Yearwise_Run objYrRun in objDealMovieRightsRun_PageLevel.Acq_Deal_Run_Yearwise_Run
                                    select objYrRun.End_Date
                                  ).Max();


            ObjectResult<USP_Validate_YEARWISE_RIGHT_FOR_RUN_Result> objInvalidData = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_YEARWISE_RIGHT_FOR_RUN(
                                                                               objAcq_Deal.Acq_Deal_Code
                                                                               , Acq_Deal_Run_Code
                                                                               , titleCodes.ToString().Replace('~', ',').Trim(',')
                                                                              , minStDate
                                                                              , maxEnDate
                                                                           );
            var arrInvalidData = objInvalidData.ToList();
            if (arrInvalidData.Count() > 0)
            {
                return Json(arrInvalidData);
            }
            return Json(invalidMessage);
        }

        public JsonResult ValidateDuplication(int Acq_Deal_Run_Code, string titleCodes, string IsYearWiseRunDefn, string IsRuleRight, string IsChannelDefnRight,
            string channelCodes, string channelchecked)
        {
            int channelCategoryCode = 0;
            string invalidMessage = "Valid";
            if (channelchecked == "G")
            {
                channelCategoryCode = Convert.ToInt32(channelCodes);
                string channelCode = string.Join(",", new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Channel_Category_Code == channelCategoryCode).Select(s => s.Channel_Code));
                channelCodes = channelCode;
            }
            string[] strTitleCodes = titleCodes.ToString().Split(new char[] { ',' }, StringSplitOptions.None);
            USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
            List<USP_Validate_Run_Result> objInvalidData = new List<USP_Validate_Run_Result>();
            foreach (string strTitleCode in strTitleCodes)
            {
                objInvalidData.AddRange(objUS.USP_Validate_Run(
                                                                                   strTitleCode// hdnTitleRunDefinition.Value.ToString().Replace('~', ',').Trim(',')
                                                                                   , "N"
                                                                                   , IsYearWiseRunDefn
                                                                                   , IsRuleRight
                                                                                   , IsChannelDefnRight
                                                                                   , channelCodes.ToString().Replace('~', ',').Trim(',')
                                                                                   , Acq_Deal_Run_Code
                                                                                   , objAcq_Deal.Acq_Deal_Code
                                                                                ).ToList());
            }

            var arrInvalidData = objInvalidData;
            if (arrInvalidData.Count() > 0)
            {
                return Json(arrInvalidData);
            }

            return Json(invalidMessage);
        }

        public string ValidateTime(string No_Of_Runs, string Run_Type, string Is_Prime_OffPrime_Defn, string Prime_Start_Time, string Prime_End_Time, string Prime_Run, string Off_Prime_Start_Time, string Off_Prime_End_Time, string Off_Prime_Run)
        {
            //if (rdoNoRunsLimited.Checked)
            string Message = "Success";
            if (Is_Prime_OffPrime_Defn == "N")
                return Message;
            if ((Run_Type == "C") && (Prime_Start_Time == "" && Prime_End_Time == "" && Prime_Run == "" && Off_Prime_Start_Time == "" && Off_Prime_End_Time == "" && Off_Prime_Run == ""))
                return Message;
            if (Run_Type == "C")
            {
                if (No_Of_Runs == Prime_Run)
                {
                    if (string.IsNullOrEmpty(Prime_Start_Time) || string.IsNullOrEmpty(Prime_End_Time))
                    {
                        Message = objMessageKey.PleasespecifyPrimeTime;
                        return Message;
                    }
                    else
                        if ((Convert.ToDateTime(Prime_Start_Time).TimeOfDay == Convert.ToDateTime(Prime_End_Time).TimeOfDay))
                    {
                        Message = objMessageKey.PrimeStartTimeandPrimeEndTimecantbeequal;
                        return Message;
                    }
                }
                else
                    if (No_Of_Runs == Off_Prime_Run)
                {
                    if (string.IsNullOrEmpty(Off_Prime_Start_Time) || string.IsNullOrEmpty(Off_Prime_End_Time))
                    {
                        Message = objMessageKey.PleasespecifyOffPrimeTime;
                        return Message;
                    }
                    else
                        if ((Convert.ToDateTime(Off_Prime_Start_Time).TimeOfDay == Convert.ToDateTime(Off_Prime_End_Time).TimeOfDay))
                    {
                        Message = objMessageKey.OffPrimeStartTimeandEndTimecantbeequal;
                        return Message;
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(Prime_Start_Time) || string.IsNullOrEmpty(Prime_End_Time) || string.IsNullOrEmpty(Off_Prime_Start_Time) || string.IsNullOrEmpty(Off_Prime_End_Time))
                    {
                        Message = objMessageKey.PleasespecifyPrimeTimeandOffPrimeTime;
                        return Message;
                    }
                    else
                        if ((Convert.ToDateTime(Prime_Start_Time).TimeOfDay <= Convert.ToDateTime(Off_Prime_Start_Time).TimeOfDay) && (Convert.ToDateTime(Off_Prime_Start_Time).TimeOfDay <= Convert.ToDateTime(Prime_End_Time).TimeOfDay))
                    {
                        Message = objMessageKey.PrimeTimeandOffPrimeTimecantbeoverlap;
                        return Message;
                    }
                    else
                            if ((Convert.ToDateTime(Prime_Start_Time).TimeOfDay <= Convert.ToDateTime(Off_Prime_End_Time).TimeOfDay) && (Convert.ToDateTime(Off_Prime_End_Time).TimeOfDay <= Convert.ToDateTime(Prime_End_Time).TimeOfDay))
                    {
                        Message = objMessageKey.PrimeTimeandOffPrimeTimecantbeoverlap;
                        return Message;
                    }
                    else
                                if ((Convert.ToDateTime(Off_Prime_Start_Time).TimeOfDay <= Convert.ToDateTime(Prime_Start_Time).TimeOfDay) && (Convert.ToDateTime(Prime_Start_Time).TimeOfDay <= Convert.ToDateTime(Off_Prime_End_Time).TimeOfDay))
                    {
                        Message = objMessageKey.PrimeTimeandOffPrimeTimecantbeoverlap;
                        return Message;
                    }
                    else
                                    if ((Convert.ToDateTime(Off_Prime_Start_Time).TimeOfDay <= Convert.ToDateTime(Prime_End_Time).TimeOfDay) && (Convert.ToDateTime(Prime_End_Time).TimeOfDay <= Convert.ToDateTime(Off_Prime_End_Time).TimeOfDay))
                    {
                        Message = objMessageKey.PrimeTimeandOffPrimeTimecantbeoverlap;
                        return Message;
                    }
                    else
                                        if (Prime_Start_Time != string.Empty && Prime_End_Time != string.Empty && Prime_Run == string.Empty)
                    {
                        Message = objMessageKey.Pleasespecifyprimeruns;
                        return Message;
                    }
                    else
                                            if (Off_Prime_Start_Time != string.Empty && Off_Prime_End_Time != string.Empty && Off_Prime_Run == string.Empty)
                    {
                        Message = objMessageKey.Pleasespecifyoffprimeruns;
                        return Message;
                    }
                    else
                                                if ((Convert.ToInt32(Prime_Run) + Convert.ToInt32(Off_Prime_Run)) != Convert.ToInt32(No_Of_Runs))
                    {
                        Message = objMessageKey.SumofPrimeRunandOffPrimeRunmustbeequaltolimitednumberofruns;
                        return Message;
                    }
                }
            }
            return Message;
        }
        public string VisibilityFlag(string selectedTitle = "")
        {
            string[] lstTitle = selectedTitle.Split(',');
            string IsSubTitle = "false";
            foreach (var item in lstTitle)
            {
            }
            return "";
        }

        public JsonResult CalcRunLP(string TitleCode)
        {
            string selectedValue = "";
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objAcq_Deal.Deal_Type_Code.Value);
            if (TitleCode == "0" && objDeal_Schema.Mode != "A")
            {
                if (Deal_Type_Condition == GlobalParams.Deal_Program || Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    TitleCode = (from objTitle in objAcq_Deal_Run.Acq_Deal_Run_Title
                                 from objDealMovie in objAcq_Deal.Acq_Deal_Movie
                                 where objDealMovie.Title_Code == objTitle.Title_Code && objDealMovie.Episode_Starts_From == objTitle.Episode_From
                                 && objDealMovie.Episode_End_To == objTitle.Episode_To
                                 select objDealMovie.Acq_Deal_Movie_Code.ToString()).FirstOrDefault();
                }
                //else if (Deal_Type_Condition == GlobalParams.SPORTSTYPE)
                //{
                //    TitleCode = objAcq_Deal_Run.Acq_Deal_Run_Title.Select(s => s.Acq_Deal_Movie_Code.ToString()).FirstOrDefault();
                //}
                else
                    TitleCode = objAcq_Deal_Run.Acq_Deal_Run_Title.Select(s => s.Title_Code.ToString()).FirstOrDefault();
            }
            //int titleCd = Convert.ToInt32(TitleCode);
            var PeriodRange = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_LP(objDeal_Schema.Deal_Code, TitleCode, 1, 1, 30).ToList();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            List<PeriodRange> lstPeriodRanges = new List<PeriodRange>();
            foreach (var item in PeriodRange)
            {
                PeriodRange objPR = new PeriodRange();

                string startDT = item.RightsStartDate.ToString("dd-MMM-yyyy");
                string endDT = item.RightsEndDate.ToString("dd-MMM-yyyy");
                //DateTime d = DateTime.Now;
                //string s = d.ToString("dd/MM/yyyy");
                objPR.PeriodCode = item.RightsStartDate + "~" + item.RightsEndDate;
                objPR.PeriodText = startDT + " - " + endDT;
                lstPeriodRanges.Add(objPR);
            }
            if (objAcq_Deal_Run.Acq_Deal_Run_Code > 0)
            {
                string YearStart = ""; string YearEnd = "";
                List<string> SelectedPeriod = new List<string>();
                List<Acq_Deal_Run_LP> objADRL = objAcq_Deal_Run.Acq_Deal_Run_LP.ToList();
                List<Acq_Deal_Run_Yearwise_Run> objADRYR = objAcq_Deal_Run.Acq_Deal_Run_Yearwise_Run.ToList();
                if (objAcq_Deal_Run.Is_Yearwise_Definition == "Y")
                {
                    selectedValue = String.Join(",", objADRYR.Select(s => s.Start_Date).Min() + "~" + objADRYR.Select(w => w.End_Date).Max());
                }
                else
                {
                    foreach (var item in objADRL)
                    {
                        selectedValue += String.Join(",", item.Year_Start + "~" + item.Year_End) + ",";
                    }
                }
            }
            //PeriodRange.Select(s => s.RightsStartDate);

            obj.Add("Period_List", new SelectList(lstPeriodRanges, "PeriodCode", "PeriodText"));
            obj.Add("SelectedPeriod", selectedValue);

            return Json(obj);
        }

        public bool ValidateRunPeriod(string MinMaxPeriods)
        {
            bool ReturnString = true; int Diff = 0;
            DateTime PrevDate, NextDate;
            string[] lstMinMaxPeriods = MinMaxPeriods.Split(',');
            var lstPeriodRanges = lstMinMaxPeriods.Select(s => s.Split('~')).ToList();

            List<DateValidation> lstDV = new List<DateValidation>();
            for (int i = 0; i < lstPeriodRanges.Count(); i++)
            {
                DateValidation DV = new DateValidation();
                DV.startDate = Convert.ToDateTime(lstPeriodRanges[i][0]);
                DV.endDate = Convert.ToDateTime(lstPeriodRanges[i][1]);
                lstDV.Add(DV);
            }
            int CNT = 0;

            for (int i = 0; i < lstDV.Count(); i++)
            {
                if (CNT > 0)
                {
                    PrevDate = lstDV[i - 1].endDate;
                    NextDate = lstDV[i].startDate;
                    Diff = Convert.ToInt32((NextDate - PrevDate).TotalDays);
                    if (Diff > 1)
                    {
                        ReturnString = false;
                        break;
                    }
                }
                CNT++;
            }
            return ReturnString;
        }
        public class MatrixData
        {
            public int acqDealRunCode { get; set; }
            public DateTime Start_Date { get; set; }
            public DateTime End_Date { get; set; }
            public string Channel_Name { get; set; }
            public int Channel_Code { get; set; }
            public string Yearwise { get; set; }
            public int Runs { get; set; }

        }
        public class PeriodRange
        {
            public string PeriodCode { get; set; }
            public string PeriodText { get; set; }
        }
        public class DateValidation
        {
            public DateTime startDate { get; set; }
            public DateTime endDate { get; set; }
            public int DateDiff { get; set; }
            public string Flag { get; set; }
        }

    }
}