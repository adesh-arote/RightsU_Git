using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;


namespace RightsU_Plus.Controllers
{
    public class Acq_Run_ListController : BaseController
    {
        #region --- Attributes & Properties ---
        public Acq_Deal objAcq_Deal
        {
            get
            {
                if (Session[RightsU_Session.SESS_DEAL] == null)
                    Session[RightsU_Session.SESS_DEAL] = new Acq_Deal();
                return (Acq_Deal)Session[RightsU_Session.SESS_DEAL];
            }
            set { Session[RightsU_Session.SESS_DEAL] = value; }
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
        public int PageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = 0;
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }
        private int _recordPerPage = 10;
        public int recordPerPage
        {
            get { return _recordPerPage; }
            set { _recordPerPage = value; }
        }
        private RightsU_Entities.Acq_Deal_Run objAcqDealRun
        {
            get
            {
                if (Session["objAcqDealRun"] == null)
                    Session["objAcqDealRun"] = new RightsU_Entities.Acq_Deal_Run();
                return (RightsU_Entities.Acq_Deal_Run)Session["objAcqDealRun"];
            }
            set { Session["objAcqDealRun"] = value; }
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
        #endregion

        #region --- Page Load ---
        public PartialViewResult Index(string hdnTitleCode = "", int? Security_Group_Code = 0, int UserCode = 0)
        {
            if (objDeal_Schema.Run_Titles != "0" && objDeal_Schema.Run_Titles != null)
                hdnTitleCode = objDeal_Schema.Run_Titles;
            if (TempData["QueryString_Run"] != null)
                TempData["QueryString_Run"] = null;
            objDeal_Schema.Page_From = GlobalParams.Page_From_Run;
            USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
            var result = objUsp.USP_Validate_RIGHT_FOR_RUN(objDeal_Schema.Deal_Code);
            objAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            ViewBag.IsRightsAdded = result.ElementAt(0).ToString();
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objDeal_Schema.Deal_Type_Code);
            Acq_Deal_Movie_Service objADMS = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName);
            var titleList = from Adm in objAcq_Deal.Acq_Deal_Movie
                            from adr in objAcq_Deal.Acq_Deal_Run
                            from adrt in adr.Acq_Deal_Run_Title
                            where Adm.Acq_Deal_Code == adr.Acq_Deal_Code && adr.Acq_Deal_Run_Code == adrt.Acq_Deal_Run_Code && adrt.Title_Code == Adm.Title_Code
                            select new { Title_Code = Adm.Acq_Deal_Movie_Code, Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, Adm.Title.Title_Name, Adm.Episode_Starts_From, Adm.Episode_End_To) };
            ViewBag.TitleList = new MultiSelectList(titleList.ToList().Distinct(), "Title_Code", "Title_Name", hdnTitleCode.Split(','));

            //var titleList = objUsp.USP_GET_TITLE_FOR_RUN(objDeal_Schema.Deal_Code);
            //ViewBag.TitleList = new MultiSelectList(titleList, "Title_Code", "Title_Name", hdnTitleCode.Split(','));
            List<Channel_Cluster> lstChannelCluster = new Channel_Cluster_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y").ToList();
            lstChannelCluster.Insert(0, new Channel_Cluster { Channel_Cluster_Code = 0, Channel_Cluster_Name = objMessageKey.PleaseSelect });
            ViewBag.ChannelClusterList = new MultiSelectList(lstChannelCluster, "Channel_Cluster_Code", "Channel_Cluster_Name", Convert.ToString(objAcq_Deal.Channel_Cluster_Code).Split(','));

            if (objAcq_Deal.Channel_Cluster_Code != null)
                ViewBag.ChannelClusterName = objAcq_Deal.Channel_Cluster.Channel_Cluster_Name;
            else
                ViewBag.ChannelClusterName = "NA";
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;

            USP_Service objUsp1 = new USP_Service(objLoginEntity.ConnectionStringName);
            if (hdnTitleCode == null || hdnTitleCode == "")
                hdnTitleCode = "0";

            List<USP_Acq_List_Runs_Result> pagedListNew = objUsp1.USP_Acq_List_Runs(objDeal_Schema.Deal_Code, hdnTitleCode, "", "").Where(w => w.Run_Type == "U").ToList();

            Security_Group_Code = Security_Group_Code == 0 ? objLoginUser.Security_Group_Code : Security_Group_Code;
            UserCode = UserCode == 0 ? objLoginUser.Users_Code : UserCode;

            ObjectResult<string> resultAR = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForAcqDeal, Security_Group_Code, UserCode);
            var addRights = resultAR.ToList();
            bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForBulkUpdateRun) + "~");

            bool srchDeleteRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForBulkDeleteRun) + "~");

            ViewBag.ButtonVisibility = srchaddRights;
            ViewBag.ButtonVisibility_BLK_DEL = srchDeleteRights;

            ViewBag.RecordCount = pagedListNew.Count;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            Session["FileName"] = "";
            Session["FileName"] = "acq_RunDefinition";
            return PartialView("~/Views/Acq_Deal/_Acq_Run_List.cshtml");
        }
        public PartialViewResult BindRun(string hdnTitleCode = "", int PageNumber = 0, int PageSize = 50, string lbChannel = "", int lbChannelCluster = 0)
        {

            string ChannelCodeList = string.Join(",", new Channel_Category_Details_Service(objLoginEntity.ConnectionStringName)
                .SearchFor(x => x.Channel_Category_Code == lbChannelCluster).Select(x => x.Channel_Code).ToList());

                lbChannel = lbChannel + "," + ChannelCodeList;

            lbChannel = lbChannel == "," ? "" : lbChannel;
           
            
            USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
            if (hdnTitleCode == null || hdnTitleCode == "")
            {
                //hdnTitleCode = lbChannel == "," && lbChannelCluster == 0 ? "0" : "";
                hdnTitleCode = "0";
            }

            List<USP_Acq_List_Runs_Result> pagedList = objUsp.USP_Acq_List_Runs(objDeal_Schema.Deal_Code, hdnTitleCode, lbChannel, "").ToList();
            List<USP_Acq_List_Runs_Result> list;
            PageNo = PageNumber + 1;
            if (PageNo == 1)
                list = pagedList.Take(PageSize).ToList();
            else
                list = pagedList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

            ViewBag.RecordCount = pagedList.Count;
            ViewBag.PageNo = PageNo;

            objDeal_Schema.Run_PageNo = PageNumber;
            objDeal_Schema.Run_PageSize = PageSize;
            objDeal_Schema.Run_Titles = hdnTitleCode;
            return PartialView("~/Views/Acq_Deal/_List_Run.cshtml", list);
        }
        #endregion

        #region --- Other Actions ---
        [HttpPost]
        public ActionResult Search(string titleCode)
        {
            TempData["TitleCodes"] = titleCode;
            return RedirectToAction("Index");
        }
        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }
        public ActionResult Cancel()
        {
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
        public JsonResult ButtonEvents(int? id)
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            obj_Dictionary.Add("Acq_Deal_Run_Code", id.ToString());
            TempData["QueryString_Run"] = obj_Dictionary;

            string tabName = GlobalParams.Page_From_Run_Detail_AddEdit;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_VIEW || objDeal_Schema.Mode == GlobalParams.DEAL_MODE_APPROVE)
                tabName = GlobalParams.Page_From_Run_Detail_View;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("TabName", tabName);
            return Json(obj);
        }

        public ActionResult Commit(string remarks, string Mode)
        {
            if (remarks != "")
                objUSP_Service.USP_Edit_Without_Approval(objDeal_Schema.Deal_Code, Mode, objLoginUser.Users_Code, remarks);
            //return RedirectToAction("Index", "Acq_List");
            //return Cancel();
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            objDeal_Schema = null;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            //if (TempData["TitleData"] != null)
            //{
            //    return RedirectToAction("View", "Title");
            //}
            //else
            //{
            return RedirectToAction("Index", "Acq_List");
            //}
        }
        public JsonResult Delete(int id)
        {
            Acq_Deal_Run_Service objADRS = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Run objAcq_DR = objADRS.GetById(id);
            if (objAcq_DR != null)
            {
                objAcq_DR.Acq_Deal_Run_Title.ToList<Acq_Deal_Run_Title>().ForEach(t => t.EntityState = State.Deleted);
                if (objAcq_DR.Acq_Deal_Run_Yearwise_Run.Count() > 0)
                {
                    foreach (Acq_Deal_Run_Yearwise_Run objADRYR in objAcq_DR.Acq_Deal_Run_Yearwise_Run)
                    {
                        objADRYR.EntityState = State.Deleted;
                    }
                }
                if (objAcq_DR.Acq_Deal_Run_Repeat_On_Day.Count() > 0)
                {
                    foreach (Acq_Deal_Run_Repeat_On_Day objADRR in objAcq_DR.Acq_Deal_Run_Repeat_On_Day)
                    {
                        objADRR.EntityState = State.Deleted;
                    }
                }
                if (objAcq_DR.Acq_Deal_Run_Channel.Count() > 0)
                {
                    foreach (Acq_Deal_Run_Channel objADRC in objAcq_DR.Acq_Deal_Run_Channel)
                    {
                        objADRC.EntityState = State.Deleted;
                    }
                }
                if (objAcq_DR.Acq_Deal_Run_Shows.Count() > 0)
                {
                    foreach (Acq_Deal_Run_Shows objADRSS in objAcq_DR.Acq_Deal_Run_Shows)
                    {
                        objADRSS.EntityState = State.Deleted;
                    }
                }
                objAcq_DR.EntityState = State.Deleted;
            }
            dynamic resultSet;
            objADRS.Save(objAcq_DR, out resultSet);

            objAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            var titleList = from Adm in objAcq_Deal.Acq_Deal_Movie
                            from adr in objAcq_Deal.Acq_Deal_Run
                            from adrt in adr.Acq_Deal_Run_Title
                            where Adm.Acq_Deal_Code == adr.Acq_Deal_Code && adr.Acq_Deal_Run_Code == adrt.Acq_Deal_Run_Code && adrt.Title_Code == Adm.Title_Code
                            select new { Title_Code = Adm.Acq_Deal_Movie_Code, Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, Adm.Title.Title_Name, Adm.Episode_Starts_From, Adm.Episode_End_To) };
            var titleCodes = titleList.Select(s => s.Title_Code).Distinct().ToArray();

            Acq_Deal_Service objService = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal objAcq = objService.GetById(objDeal_Schema.Deal_Code);

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

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Success", "Success");
            obj.Add("Title", new MultiSelectList(titleList.ToList().Distinct(), "Title_Code", "Title_Name"));
            obj.Add("TitleCodes", titleCodes);
            return Json(obj);
        }
        public JsonResult IsRightAdded()
        {
            USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
            var result = objUsp.USP_Validate_RIGHT_FOR_RUN(objDeal_Schema.Deal_Code);
            return Json(result.ElementAt(0).ToString());
        }
        public JsonResult SaveChannelCluster(int Channel_Cluster_Code, string hdnReopenMode = "")
        {
            dynamic resultSet; string status = "S", mode = "";
            if (hdnReopenMode == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;

            if (mode == GlobalParams.DEAL_MODE_REOPEN)
            {
                objDeal_Schema.Deal_Workflow_Flag = objAcq_Deal.Deal_Workflow_Status = Convert.ToString(mode).Trim();
            }
            Acq_Deal_Service objAcqDealService = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            objAcq_Deal = objAcqDealService.GetById(objDeal_Schema.Deal_Code);
            if (Channel_Cluster_Code != 0)
                objAcq_Deal.Channel_Cluster_Code = Channel_Cluster_Code;
            else
                objAcq_Deal.Channel_Cluster_Code = null;
            objAcq_Deal.EntityState = State.Modified;
            objAcqDealService.Save(objAcq_Deal, out resultSet);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            TempData["RedirectAcqDeal"] = objAcq_Deal;
            obj.Add("Status", status);
            obj.Add("Success_Message", "Success");
            return Json(obj);
        }
        #endregion

        #region --- Link Show ---
        public PartialViewResult Link_Show(int selected_Acq_Deal_Run_Code, string txtSearchPopup)
        {
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_Link_Show_List.cshtml");
        }
        public PartialViewResult Search_Shows(Nullable<int> selected_Acq_Deal_Run_Code, string txtSearchPopup, string ChannelCode, string UnCheck_Run_Shows_Code = "", string Selected_Acq_Deal_Movie_Code = "0", string checkedRadio = "", string Selected_Title_Codes = "0")
        {
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            int[] arrSelectedShows = { };
            List<USP_Search_Run_Shows_Result> lstShows;
            ViewBag.DataFor = checkedRadio;
            lstShows = new USP_Service(objLoginEntity.ConnectionStringName).USP_Search_Run_Shows(txtSearchPopup, checkedRadio, Selected_Acq_Deal_Movie_Code, ChannelCode, Selected_Title_Codes, UnCheck_Run_Shows_Code, selected_Acq_Deal_Run_Code).ToList();
            if (ViewBag.DataFor == "" || ViewBag.DataFor == null)
                if (lstShows.Count > 0)
                    ViewBag.DataFor = lstShows.FirstOrDefault().Data_For;
            return PartialView("~/Views/Acq_Deal/_Link_Show_Create.cshtml", lstShows);
        }
        public void Save_List_Shows(List<USP_Search_Run_Shows_Result> lst, int hdn_Acq_Deal_Run_Code = 0, string hdn_Data_For = "")
        {
            int acq_Deal_Run_Code = hdn_Acq_Deal_Run_Code;
            ICollection<Acq_Deal_Run_Shows> selectRunShowsList = new HashSet<Acq_Deal_Run_Shows>();
            if (lst != null)
            {
                foreach (USP_Search_Run_Shows_Result obj in lst)
                {
                    if (obj.Is_Select.ToUpper() == "TRUE")
                    {
                        Acq_Deal_Run_Shows objADR_Shows = new Acq_Deal_Run_Shows();
                        int Title_Code = obj.Title_Code ?? 0;
                        int Deal_Movie_Code = obj.Acq_Deal_Movie_Code ?? 0;
                        int Episode_From = obj.Episode_From ?? 0;
                        int Episode_To = obj.Episode_To ?? 0;
                        objADR_Shows.Data_For = hdn_Data_For;
                        objADR_Shows.EntityState = State.Added;
                        objADR_Shows.Inserted_By = objLoginUser.Users_Code;
                        objADR_Shows.Inserted_On = DateTime.Now;
                        objADR_Shows.Acq_Deal_Run_Code = obj.Acq_Deal_Run_Code;
                        objADR_Shows.Acq_Deal_Movie_Code = obj.Acq_Deal_Movie_Code;
                        objADR_Shows.Title_Code = Title_Code;
                        objADR_Shows.Episode_From = Episode_From;
                        objADR_Shows.Episode_To = Episode_To;
                        selectRunShowsList.Add(objADR_Shows);
                    }
                }
            }
            else if (hdn_Data_For == "A" && lst == null)
            {
                List<USP_Search_Run_Shows_Result> lstAllShow = new List<USP_Search_Run_Shows_Result>();
                selectRunShowsList.Add(new Acq_Deal_Run_Shows
                {
                    Data_For = hdn_Data_For,
                    EntityState = State.Added,
                    Inserted_By = objLoginUser.Users_Code,
                    Inserted_On = DateTime.Now,
                    Acq_Deal_Run_Code = hdn_Acq_Deal_Run_Code,
                    Acq_Deal_Movie_Code = 0,
                    Title_Code = 0,
                    Episode_From = 0,
                    Episode_To = 0
                });
            }
            Save_Link_Shows(selectRunShowsList, acq_Deal_Run_Code);
        }
        public JsonResult GetAcq_Deal_Shows_Count(int Acq_Deal_Run_Code)
        {
            var j = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Acq_Deal_Run_Shows.Any(a => a.Acq_Deal_Run_Code == Acq_Deal_Run_Code)).Count();
            return Json(j, JsonRequestBehavior.AllowGet);
        }
        public void Save_Link_Shows(ICollection<Acq_Deal_Run_Shows> selectRunShowsList, int Acq_Deal_Run_Code)
        {
            Acq_Deal_Run_Service objAcq_Deal_Run_Service = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName);
            dynamic resultSet;
            bool isValid;
            Acq_Deal_Run objAcq_DR = objAcq_Deal_Run_Service.GetById(Acq_Deal_Run_Code);
            IEqualityComparer<Acq_Deal_Run_Shows> comparerT = new LambdaComparer<Acq_Deal_Run_Shows>((x, y) => x.Acq_Deal_Movie_Code == y.Acq_Deal_Movie_Code
                                                                                                                && x.Title_Code == y.Title_Code
                                                                                                                && x.Episode_From == y.Episode_From
                                                                                                                && x.Episode_To == y.Episode_To
                                                                                                                && x.EntityState != State.Deleted);
            var Deleted_Acq_Deal_Run_Shows = new List<Acq_Deal_Run_Shows>();
            var Added_Acq_Deal_Run_Shows = CompareLists<Acq_Deal_Run_Shows>(selectRunShowsList.ToList<Acq_Deal_Run_Shows>(),
                                                                                objAcq_DR.Acq_Deal_Run_Shows.ToList<Acq_Deal_Run_Shows>(), comparerT,
                                                                                ref Deleted_Acq_Deal_Run_Shows
                                                                           );
            Added_Acq_Deal_Run_Shows.ToList<Acq_Deal_Run_Shows>().ForEach(t => objAcq_DR.Acq_Deal_Run_Shows.Add(t));
            Deleted_Acq_Deal_Run_Shows.ToList<Acq_Deal_Run_Shows>().ForEach(t => t.EntityState = State.Deleted);
            objAcq_DR.EntityState = State.Modified;
            isValid = objAcq_Deal_Run_Service.Save(objAcq_DR, out resultSet);
        }

        public void Delete_Link_Show(int Acq_Deal_Run_Code)
        {
            Acq_Deal_Run_Service objAcq_Deal_Run_Service = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Run objAcq_DR = objAcq_Deal_Run_Service.GetById(Acq_Deal_Run_Code);
            dynamic resultSet;
            objAcq_DR.Acq_Deal_Run_Shows.Where(p => p.Acq_Deal_Run_Code == Acq_Deal_Run_Code).ToList().ForEach(t => t.EntityState = State.Deleted);
            objAcq_DR.EntityState = State.Modified;
            objAcq_Deal_Run_Service.Save(objAcq_DR, out resultSet);
        }
        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult) where T : class
        {
            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);
            DelResult = DeleteResult.ToList<T>();
            return AddResult.ToList<T>();
        }
        #endregion

        #region --- Other Methods ---
        public void ResetMessageSession()
        {
            Session["Message"] = string.Empty;
        }
        #endregion

        #region------------Bulk Update for run---------
        public PartialViewResult BulkUpdateForRun(string callFor = "BLK_RUN")
        {
            ViewBag.callFor = callFor;
            var titleList = from Adm in objAcq_Deal.Acq_Deal_Movie
                            from adr in objAcq_Deal.Acq_Deal_Run
                            from adrt in adr.Acq_Deal_Run_Title
                            where Adm.Acq_Deal_Code == adr.Acq_Deal_Code && adr.Acq_Deal_Run_Code == adrt.Acq_Deal_Run_Code && adrt.Title_Code == Adm.Title_Code
                            select new { Title_Code = Adm.Acq_Deal_Movie_Code, Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, Adm.Title.Title_Name, Adm.Episode_Starts_From, Adm.Episode_End_To) };
            ViewBag.TitleList = new MultiSelectList(titleList.ToList().Distinct(), "Title_Code", "Title_Name");
            List<RightsU_Entities.Channel> lstChannel = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y").ToList();
            // lstChannel.Insert(0, new RightsU_Entities.Channel { Channel_Code = 0, Channel_Name = objMessageKey.PleaseSelect });         
            ViewBag.ChannelList = new MultiSelectList(lstChannel, "Channel_Code", "Channel_Name", Convert.ToString(objAcq_Deal.Channel_Cluster_Code).Split(','));
            return PartialView("~/Views/Acq_Deal/_Bulk_Update_ForRun.cshtml");
        }

        public PartialViewResult BulkUpdateForRunList(string SearchText, string hdnTitleCode = "", string ChannelCode = "", string SelectedAcqDealRunCodes = "", int PageNumber = 0, int PageSize = 50, string callFor = "BLK_RUN")
        {
            USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
            if (hdnTitleCode == null || hdnTitleCode == "")
                hdnTitleCode = "0";
            int TotalSceduleRuns = 0, TotalRuns = 0;
            var titleList = from Adm in objAcq_Deal.Acq_Deal_Movie
                            from adr in objAcq_Deal.Acq_Deal_Run
                            from adrt in adr.Acq_Deal_Run_Title
                            where Adm.Acq_Deal_Code == adr.Acq_Deal_Code && adr.Acq_Deal_Run_Code == adrt.Acq_Deal_Run_Code && adrt.Title_Code == Adm.Title_Code
                            select new { Title_Code = Adm.Acq_Deal_Movie_Code, Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, Adm.Title.Title_Name, Adm.Episode_Starts_From, Adm.Episode_End_To) };
            ViewBag.TitleList = new MultiSelectList(titleList.ToList().Distinct(), "Title_Code", "Title_Name", hdnTitleCode.Split(','));

            List<USP_Acq_List_Runs_Result> pagedList = new List<USP_Acq_List_Runs_Result>();
            if (callFor == "BLK_RUN")
            {
                pagedList = objUsp.USP_Acq_List_Runs(objDeal_Schema.Deal_Code, hdnTitleCode, ChannelCode, SelectedAcqDealRunCodes).Where(w => w.Run_Type == "U").ToList();
                ViewBag.ShowCheckAll = pagedList.Count == 0 ? "HIDE" : "SHOW";
            }
            else
            {
                pagedList = objUsp.USP_Acq_List_Runs(objDeal_Schema.Deal_Code, hdnTitleCode, ChannelCode, SelectedAcqDealRunCodes).ToList();

                TotalSceduleRuns = pagedList.Where(x => x.No_Of_Runs_Sched > 0).ToList().Count();
                TotalRuns = pagedList.ToList().Count();
                ViewBag.ShowCheckAll = TotalRuns == TotalSceduleRuns ? "HIDE" : "SHOW";
            }

            List<USP_Acq_List_Runs_Result> list;
            PageNo = PageNumber + 1;
            if (PageNo == 1)
                list = pagedList.Take(PageSize).ToList();
            else
                list = pagedList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

            //List<USP_Acq_List_Runs_Result> objlist = pagedList.Select(s => s.ChannelNames).ToList();

            ViewBag.RecordCount = pagedList.Count;
            ViewBag.PageNo = PageNo;
            ViewBag.Callfor = callFor;
            ViewBag.SelectedAcqDealRunCodes = SelectedAcqDealRunCodes.TrimStart(',');

            objDeal_Schema.Run_PageNo = PageNumber;
            objDeal_Schema.Run_PageSize = PageSize;
            //objDeal_Schema.Run_Titles = hdnTitleCode;
            return PartialView("~/Views/Acq_Deal/_Bulk_Update_ForRun_List.cshtml", list);
        }

        public JsonResult BindChangeDropdown()
        {
            List<SelectListItem> lst = new SelectList(new[]
                {
                    new { Value = "0", Text = "Please Select" },
                    new { Value = "C", Text = "Channel" }
                },
                 "Value", "Text", 0
             ).ToList();
            var arr = lst;
            return Json(arr, JsonRequestBehavior.AllowGet);
        }

        public JsonResult ChannelCategoryChanged(int category_Code)
        {
            var PrimaryChannelClusterList = new Channel_Category_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Channel_Category_Code == category_Code).Select(s => s.Channel).ToList();
            List<RightsU_Entities.Channel> channelList = new List<RightsU_Entities.Channel>();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Channel_Cluster_Primary_List", new SelectList(PrimaryChannelClusterList, "Channel_Code", "Channel_Name"));
            return Json(obj);
        }

        public JsonResult Bind_JSON_ListBox(string str_Type, string selectedCodes)
        {
            // C - Channel

            if (str_Type == "C")
            {
                var arr = BindChannel_List_New(selectedCodes);
                return Json(arr, JsonRequestBehavior.AllowGet);

            }

            return Json("", JsonRequestBehavior.AllowGet);
        }
        //private MultiSelectList BindChannel(string Selected_Channel_Code = "")
        //{
        //    return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindChannel_List_New(Selected_Channel_Code);
        //}

        public MultiSelectList BindChannel_List_New(string Selected_Channel_Code = "")
        {
            string[] Run_Codes = Selected_Channel_Code.Split(',');
            var lstAcqDealRun = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).Select(s => s.Acq_Deal_Run).ToList();

            string chn_Codes = string.Empty;
            int? Tit_Codes = 0;

            foreach (var item in Run_Codes)
            {
                if (!string.IsNullOrEmpty(item))
                {
                    int Acq_Deal_Run_Code = Convert.ToInt32(item);
                    var lstAcqDealRunChn = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Run_Code == Acq_Deal_Run_Code).ToList();

                    if (lstAcqDealRunChn.Count > 0)
                    {
                        foreach (var AcqRun in lstAcqDealRunChn)
                        {
                            // var b = item.Select(x => x.Acq_Deal_Run_Channel.Select(y => y.Channel_Code)).ToList();
                            chn_Codes = chn_Codes + String.Join(",", AcqRun.Acq_Deal_Run_Channel.Select(y => y.Channel_Code).Distinct().ToArray()) + ",";
                            Tit_Codes = AcqRun.Acq_Deal_Run_Title.Select(s => s.Title_Code).FirstOrDefault();

                            var selectTit_Codesmatch = lstAcqDealRun.ElementAt(0).Where(x =>
                                x.Acq_Deal_Run_Title.Where(y => y.Title_Code == Tit_Codes).Select(s => s.Title_Code).FirstOrDefault() == Tit_Codes
                                 && x.Acq_Deal_Run_Code != Acq_Deal_Run_Code).Select(x => new { x.Acq_Deal_Run_Channel, x.Acq_Deal_Run_Title }).ToList();

                            if (selectTit_Codesmatch.Count > 0)
                            {
                                foreach (var obj in selectTit_Codesmatch)
                                {
                                    chn_Codes = chn_Codes + String.Join(",", obj.Acq_Deal_Run_Channel.Select(y => y.Channel_Code).Distinct().ToArray()) + ",";
                                }
                            }
                        }
                    }
                }
            }

            //foreach (var item in Run_Codes)
            //{
            //    if (!string.IsNullOrEmpty(item))
            //    {
            //        int Acq_Deal_Run_Code = Convert.ToInt32(item);
            //        var lstAcqDealRunChn = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Run_Code == Acq_Deal_Run_Code).ToList();
            //        var lstAcqDealRunnew = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).ToList();
            //        if (lstAcqDealRunChn.Count > 0)
            //        {
            //            foreach (var AcqRun in lstAcqDealRunnew)
            //            {
            //                // var b = item.Select(x => x.Acq_Deal_Run_Channel.Select(y => y.Channel_Code)).ToList();
            //                chn_Codes = chn_Codes + String.Join(",", AcqRun.Acq_Deal_Run_Channel.Select(y => y.Channel_Code).Distinct().ToArray()) + ",";
            //                Tit_Codes = Tit_Codes + String.Join(",", AcqRun.Acq_Deal_Run_Title.Select(s => s.Title_Code).Distinct().ToArray()) + ",";
            //                foreach (var AcqRunChan in lstAcqDealRunChn)
            //                {
            //                    var query = from fac in lstAcqDealRunnew
            //                                join zxa in AcqRun.Acq_Deal_Run on fac.Acq_Deal_Code equals zxa.Acq_Deal_Code
            //                                join sem in AcqRunChan.Acq_Deal_Run_Channel on zxa.Acq_Deal_Run_Code equals sem.Acq_Deal_Run_Code
            //                                join car in AcqRunChan.Acq_Deal_Run_Title on zxa.Acq_Deal_Run_Code equals car.Acq_Deal_Run_Code
            //                                where car.Title_Code == 27368
            //                                select new { chan = sem.Channel_Code };
            //                }

            //            }
            //        }
            //    }
            //}


            chn_Codes = chn_Codes.TrimEnd(',');
            List<int> lstChnNew = chn_Codes.Split(',').Select(int.Parse).Distinct().ToList();

            List<int> lstChn = new Channel_Service(objLoginEntity.ConnectionStringName)
                .SearchFor(i => i.Is_Active == "Y")
                .Select(i => i.Channel_Code)
                .ToList();

            var result = lstChn.Except(lstChnNew).ToList();


            MultiSelectList arr_Title_List = new MultiSelectList(
              new Channel_Service(objLoginEntity.ConnectionStringName)
              .SearchFor(i => i.Is_Active == "Y" && result.Contains(i.Channel_Code))
              .Select(i => new { Channel_Code = i.Channel_Code, Channel_Name = i.Channel_Name })
              .OrderBy(x => x.Channel_Name)
              .ToList(),
              "Channel_Code", "Channel_Name", Selected_Channel_Code.Split(','));

            return arr_Title_List;
        }

        public JsonResult BulkSave(string SelectedRightCodes, string SelectedCodes, string ChangeFor)
        {
            string Message = string.Empty;
            string status = "";
            dynamic resultSet;
            Acq_Deal_Run objRun = new Acq_Deal_Run();

            string[] Run_Codes = SelectedRightCodes.Split(',');
            string[] Channel_Code = SelectedCodes.Split(',');
            foreach (var item in Run_Codes)
            {
                if (!string.IsNullOrEmpty(item))
                {
                    int RunCode = Convert.ToInt32(item);
                    objAcqDealRun = null;
                    objAcqDealRun = objADRS.GetById(RunCode);



                    if (objAcqDealRun.Channel_Type == "C")
                    {
                        foreach (var strChannelCode in Channel_Code)
                        {
                            int ChannelCode = Convert.ToInt32(strChannelCode);
                            List<int?> intlistChannel = objAcqDealRun.Acq_Deal_Run_Channel.Select(W => W.Channel_Code).ToList();
                            List<int?> intlistTitle = objAcqDealRun.Acq_Deal_Run_Title.Select(S => S.Title_Code).ToList();
                            //string[] DupChannelCodes = Exist_Channel_Code.Split(',');
                            bool IsChannelCode = intlistChannel.IndexOf(ChannelCode) == 0;

                            if (IsChannelCode == true)
                            {
                                Message = "Channel Already added in the run defination";
                                status = "E";
                            }
                            else
                            {
                                Acq_Deal_Run_Channel objDRunChnl = new Acq_Deal_Run_Channel();
                                objDRunChnl.Channel_Code = Convert.ToInt32(ChannelCode);
                                objDRunChnl.EntityState = State.Added;
                                objAcqDealRun.Acq_Deal_Run_Channel.Add(objDRunChnl);
                                Message = "Run Definition Updated Successfully";
                                status = "S";
                            }
                        }
                    }
                    if (objAcqDealRun.Acq_Deal_Run_Code > 0)
                    {
                        objAcqDealRun.Last_updated_Time = DateTime.Now;
                        objAcqDealRun.Last_action_By = objLoginUser.Users_Code;
                        objAcqDealRun.EntityState = State.Modified;
                    }

                    objADRS.Save(objAcqDealRun, out resultSet);
                }

            }


            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", Message);
            obj.Add("status", status);
            return Json(obj);

        }

        public JsonResult BulkDelete(string SelectedRightCodes)
        {
            string Message = string.Empty;
            string status = "";
            dynamic resultSet;

            Acq_Deal_Run objRun = new Acq_Deal_Run();
            Acq_Deal_Run_Service objADRS = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName);

            string[] Run_Codes = SelectedRightCodes.Split(',');

            foreach (var item in Run_Codes)
            {
                if (!string.IsNullOrEmpty(item))
                {
                    int RunCode = Convert.ToInt32(item);
                    objAcqDealRun = null;
                    objAcqDealRun = objADRS.GetById(RunCode);

                    if (objAcqDealRun != null)
                    {
                        objAcqDealRun.Acq_Deal_Run_Title.ToList<Acq_Deal_Run_Title>().ForEach(t => t.EntityState = State.Deleted);
                        if (objAcqDealRun.Acq_Deal_Run_Yearwise_Run.Count() > 0)
                        {
                            foreach (Acq_Deal_Run_Yearwise_Run objADRYR in objAcqDealRun.Acq_Deal_Run_Yearwise_Run)
                            {
                                objADRYR.EntityState = State.Deleted;
                            }
                        }
                        if (objAcqDealRun.Acq_Deal_Run_Repeat_On_Day.Count() > 0)
                        {
                            foreach (Acq_Deal_Run_Repeat_On_Day objADRR in objAcqDealRun.Acq_Deal_Run_Repeat_On_Day)
                            {
                                objADRR.EntityState = State.Deleted;
                            }
                        }
                        if (objAcqDealRun.Acq_Deal_Run_Channel.Count() > 0)
                        {
                            foreach (Acq_Deal_Run_Channel objADRC in objAcqDealRun.Acq_Deal_Run_Channel)
                            {
                                objADRC.EntityState = State.Deleted;
                            }
                        }
                        if (objAcqDealRun.Acq_Deal_Run_Shows.Count() > 0)
                        {
                            foreach (Acq_Deal_Run_Shows objADRSS in objAcqDealRun.Acq_Deal_Run_Shows)
                            {
                                objADRSS.EntityState = State.Deleted;
                            }
                        }
                        objAcqDealRun.EntityState = State.Deleted;
                    }

                    objADRS.Save(objAcqDealRun, out resultSet);
                    Message = "Run Definition Deleted Successfully";
                    status = "S";
                }
            }


            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", Message);
            obj.Add("status", status);
            return Json(obj);

        }
        #endregion
    }
}
