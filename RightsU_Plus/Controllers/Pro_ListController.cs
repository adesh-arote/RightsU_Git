using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using System.Data.Entity.Core.Objects;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Collections;

namespace RightsU_Plus.Controllers
{
    public class Pro_ListController : BaseController
    {
        #region --------------- ATTRIBUTES AND PROPERTIES---------------
        private Pro_Deal_Search objPro_Deal_Search
        {
            get
            {
                if (Session["objPro_Deal_Search"] == null)
                    Session["objPro_Deal_Search"] = new Pro_Deal_Search();
                return (Pro_Deal_Search)Session["objPro_Deal_Search"];
            }
            set
            {
                Session["objPro_Deal_Search"] = value;
            }

        }

        private Provisional_Deal objPD_Session
        {
            get
            {
                if (Session[RightsU_Session.PRO_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.PRO_DEAL_SCHEMA] = new Provisional_Deal();

                return (Provisional_Deal)Session[RightsU_Session.PRO_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.PRO_DEAL_SCHEMA] = value; }
        }

        private List<RightsU_Entities.Provisional_Deal_Run> lstProvisional_Deal_Run
        {
            get
            {
                if (Session["lstProvisional_Deal_Run"] == null)
                    Session["lstProvisional_Deal_Run"] = new List<RightsU_Entities.Provisional_Deal_Run>();
                return (List<RightsU_Entities.Provisional_Deal_Run>)Session["lstProvisional_Deal_Run"];
            }
            set { Session["lstProvisional_Deal_Run"] = value; }
        }

        private Provisional_Deal_Services objProDealService
        {
            get
            {
                if (Session["objProDealService"] == null)
                    Session["objProDealService"] = new Provisional_Deal_Services(objLoginEntity.ConnectionStringName);

                return (Provisional_Deal_Services)Session["objProDealService"];
            }
            set { Session["objProDealService"] = value; }
        }

        #endregion

        #region---------------Index & Bind-------------

        public ActionResult Index(string Message = "", string ReleaseRecord = "")
        {
            lstProvisional_Deal_Run.Clear();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForProvisionalDeal);
            return View("~/Views/Pro_List/Index.cshtml");
        }
        public PartialViewResult BindPartialPages(string key, int PDCode, string Mode, int RecLockCode = 0)
        {
            if (key == "LIST")
            {
                if (Mode == "B")
                {
                    TempData["IsMenu"] = "N";
                    objPD_Session = null;
                    objProDealService = null;
                }
                ViewBag.PDCode = PDCode;

                string isMenu = "Y";
                if (TempData["IsMenu"] != null)
                    isMenu = TempData["IsMenu"].ToString();

                string searchType = "", searchText = "";
                int pageNo = 1, recordPerPage = 10;
                int RecordLockingCode = objPro_Deal_Search.RecordLockingCode;
                if (isMenu == "Y")
                    objPro_Deal_Search = null;
                else
                {
                    pageNo = objPro_Deal_Search.PageNo;
                    recordPerPage = objPro_Deal_Search.RecordPerPage;
                    if (!string.IsNullOrEmpty(objPro_Deal_Search.IsAdvance_Search))
                    {
                        if (objPro_Deal_Search.IsAdvance_Search == "Y")
                            searchType = "A";
                        else if (objPro_Deal_Search.SearchText != "")
                        {
                            searchType = "C";
                            searchText = objPro_Deal_Search.SearchText;
                        }
                    }
                }
                if (RecordLockingCode > 0)
                {
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(RecordLockingCode, objLoginEntity.ConnectionStringName);
                }
                ViewBag.UserModuleRights = GetUserModuleRights();
                ViewBag.SearchType = searchType;
                ViewBag.SearchText = searchText;
                ViewBag.PageNo = pageNo;
                ViewBag.RecordPerPage = recordPerPage;
                ViewBag.BusineesUnitList = BindBUList();
                ViewBag.BUCode = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
                return PartialView("~/Views/Pro_List/_Pro_Layout.cshtml");
            }
            else if (key == "ADD_DEAL")
            {
                objPD_Session = null;
                TempData.Remove("View");
                TempData.Remove("_message");
                if (PDCode > 0)
                {
                    ViewBag.RecordLockingCode = RecLockCode;
                    dynamic resultset = "";
                    if (Mode == GlobalParams.DEAL_MODE_CLONE)
                    {
                        objPD_Session = Clone(PDCode);
                        TempData["_message"] = "Deal Added Successfully";
                        TempData.Keep();
                    }
                    else if (Mode == GlobalParams.dealWorkFlowStatus_Approved)
                    {
                        objPD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Approved;
                        objPD_Session = objProDealService.GetById(PDCode);
                        string titleCodes = string.Join(",", objPD_Session.Provisional_Deal_Title.Select(x => x.Title_Code.ToString()).Distinct().ToArray());
                        ViewBag.TitleCode = titleCodes;
                        TempData["_message"] = "Deal Updated Successfully";
                        TempData.Keep();
                    }

                    else if (Mode == GlobalParams.DEAL_MODE_VIEW)
                    {
                        objProDealService = null;
                        objPD_Session = objProDealService.GetById(PDCode);
                        objPD_Session.Provisional_Deal_Licensor.ToList().ForEach(f =>
                        {
                            if (f.Vendor == null)
                            {
                                Vendor_Service objVendorService = new Vendor_Service(objLoginEntity.ConnectionStringName);
                                f.Vendor = objVendorService.GetById((int)f.Vendor_Code);
                                objVendorService = null;
                            }
                        });

                        objPD_Session.Provisional_Deal_Title.ToList().ForEach(f =>
                        {
                            if (f.Title == null)
                            {
                                Title_Service objTitleService = new Title_Service(objLoginEntity.ConnectionStringName);
                                f.Title = objTitleService.GetById((int)f.Title_Code);
                                objTitleService = null;
                            }
                        });

                        ViewBag.DealTypeCode = objPD_Session.Deal_Type_Code;
                        TempData["View"] = GlobalParams.DEAL_MODE_VIEW;
                        TempData.Keep();
                        ViewBag.AgreementNo = objPD_Session.Agreement_No;
                        ViewBag.VersionNo = objPD_Session.Version;
                        ViewBag.DealTypeCode = objPD_Session.Deal_Type_Code;
                        return PartialView("~/Views/Pro_List/View.cshtml", objPD_Session);
                    }
                    else
                    {
                        objPD_Session = objProDealService.GetById(PDCode);
                        string titleCodes = string.Join(",", objPD_Session.Provisional_Deal_Title.Select(x => x.Title_Code.ToString()).Distinct().ToArray());
                        ViewBag.TitleCode = titleCodes;
                        TempData["_message"] = "Deal Updated Successfully";
                        TempData.Keep();
                    }
                    ViewBag.Mode = Mode;
                    ViewBag.DealTypeCode = objPD_Session.Deal_Type_Code;
                    string vendorCodes = string.Join(",", objPD_Session.Provisional_Deal_Licensor.Select(x => x.Vendor_Code.ToString()).Distinct().ToArray());
                    ViewBag.VendorCodes = vendorCodes;
                    ViewBag.BindLicensor = new MultiSelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("VEN", "GEN", objLoginUser.Users_Code, 0, 0, 0), "Display_Value", "Display_Text", vendorCodes.Split(','));
                    ViewBag.BindLincense = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("ENT", "GEN", objLoginUser.Users_Code, 0, 0, 0), "Display_Value", "Display_Text", objPD_Session.Entity_Code);
                    ViewBag.Deal_For_List = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("DTP", "PRO", objLoginUser.Users_Code, 0, 0, 0), "Display_Value", "Display_Text", objPD_Session.Deal_Type_Code);
                    ViewBag.BusineesUnitList = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").
                    SelectMany(s => s.Users_Business_Unit).Where(w => w.Users_Code == objLoginUser.Users_Code).Select(s => s.Business_Unit).ToList(), "Business_Unit_Code", "Business_Unit_Name");
                    ViewBag.Mode_Acquisition_list = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("ROL", "GEN", objLoginUser.Users_Code, 0, 0, 0), "Display_Value", "Display_Text").ToList();
                    ViewBag.AgreementNo = objPD_Session.Agreement_No;
                    ViewBag.VersionNo = objPD_Session.Version;
                }
                else
                {
                    ViewBag.RecordLockingCode = RecLockCode;
                    ViewBag.BusineesUnitList = BindBUList();
                    ViewBag.BindLincense = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("ENT", "GEN", objLoginUser.Users_Code, 0, 0, 0), "Display_Value", "Display_Text");
                    ViewBag.BindLicensor = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("VEN", "GEN", objLoginUser.Users_Code, 0, 0, 0), "Display_Value", "Display_Text");
                    ViewBag.Mode_Acquisition_list = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("ROL", "GEN", objLoginUser.Users_Code, 0, 0, 0), "Display_Value", "Display_Text").ToList();
                    ViewBag.Deal_For_List = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("DTP", "PRO", objLoginUser.Users_Code, 0, 0, 0), "Display_Value", "Display_Text").ToList();
                    if (ViewBag.Mode_Acquisition_list.Count > 0)
                        ViewBag.Mode_Acquisition_list[0].Selected = true;
                }
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForProvisionalDeal);
                return PartialView("~/Views/Pro_List/_Add_Edit_ProDeal.cshtml", objPD_Session);
            }
            return PartialView("~/Views/Pro_List/_Pro_Layout.cshtml");//TEMPORARY
        }
        public PartialViewResult BindMusicDealList(int pageNo, int recordPerPage, string SearchText, string Agreement_No, DateTime? StartDate, DateTime? EndDate, int Deal_Type_Code,
              int Business_Unit_Code, string Vendor_Codes, string Title_Codes, string IsAdvance_Search)
        {
            USP_Service objService = new USP_Service(objLoginEntity.ConnectionStringName);
            int recordCount = 0;
            ObjectParameter objPageNo = new ObjectParameter("PageNo", pageNo);
            ObjectParameter objTotalRecord = new ObjectParameter("RecordCount", recordCount);
            List<USP_List_Provisional_Deal_Result> lstProvisional_Deal = objService.USP_List_Provisional_Deal(
                SearchText, Agreement_No, StartDate, EndDate, Deal_Type_Code, Business_Unit_Code,
                 Vendor_Codes, Title_Codes, IsAdvance_Search,
                objLoginUser.Users_Code, objPageNo, recordPerPage, objTotalRecord
            ).ToList();

            recordCount = Convert.ToInt32(objTotalRecord.Value);
            pageNo = Convert.ToInt32(objPageNo.Value);
            ViewBag.RecordCount = recordCount;
            ViewBag.PageNo = pageNo;
            ViewBag.UserModuleRights = GetUserModuleRights();

            #region --- Maintain Search Criteria ---
            objPro_Deal_Search.PageNo = pageNo;
            objPro_Deal_Search.RecordPerPage = recordPerPage;
            objPro_Deal_Search.SearchText = SearchText;
            objPro_Deal_Search.Agreement_No = Agreement_No;
            if (StartDate != null)
                objPro_Deal_Search.StartDate = ((DateTime)StartDate).ToString(GlobalParams.DateFormat);
            if (EndDate != null)
                objPro_Deal_Search.EndDate = ((DateTime)EndDate).ToString(GlobalParams.DateFormat);
            objPro_Deal_Search.Deal_Type_Code = Deal_Type_Code;
            objPro_Deal_Search.Business_Unit_Code = Business_Unit_Code;

            objPro_Deal_Search.Vendor_Codes = Vendor_Codes;
            objPro_Deal_Search.Titles_Codes = Title_Codes;
            objPro_Deal_Search.IsAdvance_Search = IsAdvance_Search;
            #endregion

            return PartialView("~/Views/Pro_List/_Pro_List.cshtml", lstProvisional_Deal);

        }
        public JsonResult BindAdvanceSearch(string CallFrom)
        {
            #region --- Business Unit List ---
            List<SelectListItem> lstBusinessUnit = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").
                SelectMany(s => s.Users_Business_Unit).Where(w => w.Users_Code == objLoginUser.Users_Code).
                Select(s => s.Business_Unit).ToList(), "Business_Unit_Code", "Business_Unit_Name").OrderBy(o => o.Text).ToList();
            #endregion --- Business Unit List ---

            #region --- Deal Type List ---
            string[] arrDealTypeCodes = { "1", "11", "22" };
            List<SelectListItem> lstDealType = new SelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                (arrDealTypeCodes.Contains(x.Deal_Type_Code.ToString()))).ToList(),
              "Deal_Type_Code", "Deal_Type_Name").OrderBy(o => o.Text).ToList();
            lstDealType.Insert(0, new SelectListItem() { Text = "Please Select", Value = "0" });
            #endregion --- Deal Type List ---

            List<SelectListItem> lstVendor = new SelectList(new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y"
                                                  && T.Provisional_Deal_Licensor.Any(AM => AM.Vendor_Code == T.Vendor_Code))
                       .Select(R => new { Vendor_Name = R.Vendor_Name, Vendor_Code = R.Vendor_Code }), "Vendor_Code", "Vendor_Name").OrderBy(o => o.Text).ToList();

            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            int BuCode = Convert.ToInt32(lstBusinessUnit.ElementAt(0).Value);
            List<SelectListItem> lstTitle = new SelectList(objTS.SearchFor(T => T.Is_Active == "Y"
                                                  && T.Provisional_Deal_Title.Any(AM => AM.Title_Code == T.Title_Code && AM.Provisional_Deal.Business_Unit_Code == BuCode))
                       .Select(R => new { Title_Name = R.Title_Name, Title_Code = R.Title_Code }), "Title_Code", "Title_Name").OrderBy(o => o.Text).ToList();

            Dictionary<string, object> objDictionary = new Dictionary<string, object>();
            objDictionary.Add("Deal_Type_List", lstDealType);
            objDictionary.Add("Business_Unit_List", lstBusinessUnit);
            objDictionary.Add("Vendor_List", lstVendor);
            objDictionary.Add("Title_List", lstTitle);


            if (CallFrom == "PGL")
                objDictionary.Add("objPro_Deal_Search", objPro_Deal_Search);

            return Json(objDictionary);
        }
        public JsonResult DeleteProDeal(int PDCode, string Mode, int Record_Locking_Code = 0)
        {
            bool isLocked = true;
            string status = "S", message = "";
            if (Record_Locking_Code == 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(PDCode, GlobalParams.ModuleCodeForProvisionalDeal, objLoginUser.Users_Code, out Record_Locking_Code, out message, objLoginEntity.ConnectionStringName);
            }
            if (isLocked)
            {
                dynamic resultset = "";
                if (PDCode > 0)
                {
                    if (Mode == GlobalParams.DEAL_MODE_DELETE)
                    {
                        objPD_Session = objProDealService.GetById(PDCode);
                        bool isValid = objProDealService.Delete(objPD_Session, out resultset);
                        if (isValid)
                        {
                            message = "Record Deleted Successfully";
                            TempData["_message"] = "Deal Deleted Successfully";
                            TempData.Keep();
                        }
                    }
                }
            }
            else
                status = "E";

            if (Record_Locking_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(Record_Locking_Code, objLoginEntity.ConnectionStringName);
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);             
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForProvisionalDeal), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
        }
        public JsonResult CheckRecordLock(int Pro_Deal_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Pro_Deal_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Pro_Deal_Code, GlobalParams.ModuleCodeForProvisionalDeal, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }
            if (isLocked)
                objPro_Deal_Search.RecordLockingCode = RLCode;

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult CheckRecordCurrentStatus(int Pro_Deal_Code)
        {
            string message = "";
            int RLCode = 0;
            bool isLocked = false;

            int count = new Provisional_Deal_Services(objLoginEntity.ConnectionStringName).SearchFor(s => s.Provisional_Deal_Code == Pro_Deal_Code && (s.Deal_Workflow_Status == "A" || s.Deal_Workflow_Status == "W")).Count();
            if (count > 0)
                message = "The deal is already processed by another Approver";
            else if (Pro_Deal_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Pro_Deal_Code, GlobalParams.ModuleCodeForProvisionalDeal, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);
            }
            var obj = new
            {
                BindList = (count > 0) ? "Y" : "N",
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = message,
                Record_Locking_Code = RLCode
            };

            return Json(obj);
        }
        #endregion

        #region ---------------BIND DROPDOWNS---------------

        public JsonResult OnChangeBindTitle(int? dealTypeCode, int? BUCode)
        {
            return Json(BindTitle(dealTypeCode, BUCode), JsonRequestBehavior.AllowGet);
        }
        private MultiSelectList BindTitle(int? Deal_Type_Code, int? BUCode)
        {
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            dynamic lstTitle = null;

            if (Deal_Type_Code != 0)
            {
                lstTitle = new MultiSelectList(objTS.SearchFor(T => T.Is_Active == "Y" &&
                                  T.Provisional_Deal_Title.Any(AM => AM.Provisional_Deal.Business_Unit_Code == BUCode && AM.Title_Code == T.Title_Code)
                                    && (T.Deal_Type_Code == Deal_Type_Code)
                                            )
                      .Select(R => new { Title_Name = R.Title_Name, Title_Code = R.Title_Code }), "Title_Code", "Title_Name");
            }
            else if (Deal_Type_Code == 0)
            {
                lstTitle = new MultiSelectList(objTS.SearchFor(T => T.Is_Active == "Y" &&
                                   T.Provisional_Deal_Title.Any(AM => AM.Provisional_Deal.Business_Unit_Code == BUCode && AM.Title_Code == T.Title_Code)
                                             )
                       .Select(R => new { Title_Name = R.Title_Name, Title_Code = R.Title_Code }), "Title_Code", "Title_Name");
            }
            MultiSelectList list = lstTitle;
            return list;

        }
        private SelectList BindBUList()
        {
            return new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").
                SelectMany(s => s.Users_Business_Unit).Where(w => w.Users_Code == objLoginUser.Users_Code).
                Select(s => s.Business_Unit).ToList(), "Business_Unit_Code", "Business_Unit_Name");
        }

        #endregion

        #region--------------Add EDIT RUN DEFINATION ------------------
        public PartialViewResult BindRunDef(string DummyCode, string key, string is_AddEdit = "")
        {
            if (is_AddEdit == "ADD")
                lstProvisional_Deal_Run.Clear();

            if (key == "EDIT_RD_MOVIE")
            {
                MultiSelectList lstChannel = new MultiSelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y")
                                       .Select(R => new { Channel_Name = R.Channel_Name, Channel_Code = R.Channel_Code }), "Channel_Code", "Channel_Name");
                List<SelectListItem> lstRightRule = new SelectList(new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y")
                                      .Select(R => new { Right_Rule_Name = R.Right_Rule_Name, Right_Rule_Code = R.Right_Rule_Code }), "Right_Rule_Code", "Right_Rule_Name").OrderBy(o => o.Text).ToList();
                ViewBag.lstChannel = lstChannel;
                lstRightRule.Insert(0, new SelectListItem() { Text = "Please Select", Value = "0" });
                ViewBag.lstRightRule = lstRightRule;
                Session["Provisional_Deal_Run_List"] = null;
                List<Provisional_Deal_Run> lst_PDR = new List<Provisional_Deal_Run>();
                foreach (var item in lstProvisional_Deal_Run.Where(x => x.EntityState != State.Deleted).ToList())
                {
                    Provisional_Deal_Run objPDR = new Provisional_Deal_Run();
                    objPDR._Dummy_Guid = item._Dummy_Guid;
                    objPDR.EntityState = item.EntityState;
                    objPDR.No_Of_Runs = item.No_Of_Runs;
                    objPDR.Off_Prime_Runs = item.Off_Prime_Runs;
                    objPDR.Prime_Runs = item.Prime_Runs;
                    objPDR.Provisional_Deal_Run_Code = item.Provisional_Deal_Run_Code;
                    objPDR.Provisional_Deal_Title_Code = item.Provisional_Deal_Title_Code;
                    objPDR.Right_Rule_Code = item.Right_Rule_Code;
                    objPDR.Run_Type = item.Run_Type;
                    objPDR.Simulcast_Time_lag = item.Simulcast_Time_lag;
                    foreach (var objChannel in item.Provisional_Deal_Run_Channel)
                    {
                        Provisional_Deal_Run_Channel objPDRC = new Provisional_Deal_Run_Channel();
                        objPDRC._Dummy_Guid = objChannel._Dummy_Guid;
                        objPDRC.Channel_Code = objChannel.Channel_Code;
                        objPDRC.EntityState = objChannel.EntityState;
                        objPDRC.Provisional_Deal_Run_Channel_Code = objChannel.Provisional_Deal_Run_Channel_Code;
                        objPDRC.Provisional_Deal_Run_Code = objChannel.Provisional_Deal_Run_Code;
                        objPDRC.Right_End_Date = objChannel.Right_End_Date;
                        objPDRC.Right_Start_Date = objChannel.Right_Start_Date;
                        objPDR.Provisional_Deal_Run_Channel.Add(objPDRC);
                    }
                    lst_PDR.Add(objPDR);
                }
                Session["Provisional_Deal_Run_List"] = lst_PDR;
            }
            else if (key == "ADD_RD")
            {
                MultiSelectList lstChannel = new MultiSelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y")
                                       .Select(R => new { Channel_Name = R.Channel_Name, Channel_Code = R.Channel_Code }), "Channel_Code", "Channel_Name");
                List<SelectListItem> lstRightRule = new SelectList(new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y")
                                      .Select(R => new { Right_Rule_Name = R.Right_Rule_Name, Right_Rule_Code = R.Right_Rule_Code }), "Right_Rule_Code", "Right_Rule_Name").OrderBy(o => o.Text).ToList();
                ViewBag.lstChannel = lstChannel;
                lstRightRule.Insert(0, new SelectListItem() { Text = "Please Select", Value = "0" });
                ViewBag.lstRightRule = lstRightRule;
            }
            else if (key == "EDIT_RD")
            {
                Provisional_Deal_Run objPDR = lstProvisional_Deal_Run.Where(x => x.Dummy_Guid == DummyCode).FirstOrDefault();
                dynamic channel_code = objPDR.Provisional_Deal_Run_Channel.Select(x => x.Channel_Code).ToArray();
                MultiSelectList lstChannel_AddCHN = new MultiSelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y")
                                       .Select(R => new { Channel_Name = R.Channel_Name, Channel_Code = R.Channel_Code }), "Channel_Code", "Channel_Name");
                List<SelectListItem> lstRightRule = new SelectList(new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y")
                                      .Select(R => new { Right_Rule_Name = R.Right_Rule_Name, Right_Rule_Code = R.Right_Rule_Code }), "Right_Rule_Code", "Right_Rule_Name", objPDR.Right_Rule_Code).OrderBy(o => o.Text).ToList();
                ViewBag.lstChannel_AddCHN = lstChannel_AddCHN;
                lstRightRule.Insert(0, new SelectListItem() { Text = "Please Select", Value = "0" });
                ViewBag.lstRightRule = lstRightRule;
            }
            else if (key == "CLONE_RD")
            {
                Provisional_Deal_Run objPDR = lstProvisional_Deal_Run.Where(x => x.Dummy_Guid == DummyCode).FirstOrDefault();
                Provisional_Deal_Run obj_NEW_PDR = new Provisional_Deal_Run();

                obj_NEW_PDR.No_Of_Runs = objPDR.No_Of_Runs;
                obj_NEW_PDR.Off_Prime_Runs = objPDR.Off_Prime_Runs;
                obj_NEW_PDR.Prime_Runs = objPDR.Prime_Runs;
                obj_NEW_PDR.Right_Rule_Code = objPDR.Right_Rule_Code;
                obj_NEW_PDR.Simulcast_Time_lag = objPDR.Simulcast_Time_lag;
                lstProvisional_Deal_Run.Add(obj_NEW_PDR);
                MultiSelectList lstChannel_Edit = new MultiSelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y")
                                      .Select(R => new { Channel_Name = R.Channel_Name, Channel_Code = R.Channel_Code }), "Channel_Code", "Channel_Name");
                List<SelectListItem> lstRightRule = new SelectList(new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y")
                                     .Select(R => new { Right_Rule_Name = R.Right_Rule_Name, Right_Rule_Code = R.Right_Rule_Code }), "Right_Rule_Code", "Right_Rule_Name", obj_NEW_PDR.Right_Rule_Code).OrderBy(o => o.Text).ToList();
                ViewBag.lstChannel_Edit = lstChannel_Edit;
                lstRightRule.Insert(0, new SelectListItem() { Text = "Please Select", Value = "0" });
                ViewBag.lstRightRule = lstRightRule;
                TempData["IsClone"] = "Y";
                TempData["Action"] = "EDIT_RUN_CHANNEL";
                TempData["idRUN_CHANNEL"] = obj_NEW_PDR.Dummy_Guid;
            }
            else if (key == "DELETE_RD")
            {
                Session["Remove_ShowAll"] = null;
                Provisional_Deal_Run objPDR = lstProvisional_Deal_Run.Where(x => x.Dummy_Guid == DummyCode).FirstOrDefault();
                objPDR.EntityState = State.Deleted;
            }
            if (key == "SHOW_ALL")
            {
                #region
                string[] chnCode = (string[])Session["Remove_ShowAll"];
                if (chnCode != null)
                {
                    foreach (var item in lstProvisional_Deal_Run)
                    {
                        foreach (var objchannel in item.Provisional_Deal_Run_Channel.Where(x => chnCode.Contains(x.Channel_Code.ToString())).ToList())
                        {
                            if (objchannel.EntityState == State.Deleted)
                            {
                                objchannel.EntityState = State.Added;
                            }

                        }
                    }
                }
                else
                {
                    foreach (var item in lstProvisional_Deal_Run)
                    {
                        foreach (var objchannel in item.Provisional_Deal_Run_Channel.Where(x => x.Dummy_Guid == DummyCode).ToList())
                        {
                            if (objchannel.EntityState == State.Deleted)
                            {
                                objchannel.EntityState = State.Added;
                            }

                        }
                    }
                }
                #endregion
            }
            return PartialView("~/Views/Pro_List/_AddEdit_RunDefn.cshtml", lstProvisional_Deal_Run.Where(x => x.EntityState != State.Deleted).ToList());
        }

        public JsonResult AddEditRunChannel(string RunChannelDummyguid, string commandName, string ChannelDummyGuid = "")
        {
            string status = "S";
            TempData["IsClone"] = "N";
            TempData["Action"] = "";
            TempData["Action_Channel"] = "";
            if (commandName == "ADD_RC")
            {
                TempData["Action"] = "ADD_RUN_CHANNEL";
            }
            else if (commandName == "EDIT_RC")
            {
                Provisional_Deal_Run objPDR = lstProvisional_Deal_Run.Where(x => x.Dummy_Guid == RunChannelDummyguid && x.EntityState != State.Deleted).FirstOrDefault();
                Session["Remove_ShowAll"] = null;
                Session["Remove_ShowAll"] = objPDR.Provisional_Deal_Run_Channel.Where(x => x.EntityState != State.Deleted).Select(x => x.Channel_Code.ToString()).ToArray();
                TempData["IsClone"] = "N";
                TempData["Action"] = "EDIT_RUN_CHANNEL";
                TempData["idRUN_CHANNEL"] = objPDR.Dummy_Guid;
            }
            else if (commandName == "DELETE_EDIT_CHN")
            {
                Provisional_Deal_Run objPDR = lstProvisional_Deal_Run.Where(x => x.Dummy_Guid == RunChannelDummyguid && x.EntityState != State.Deleted).FirstOrDefault();
                Provisional_Deal_Run_Channel objPDRC = objPDR.Provisional_Deal_Run_Channel.Where(x => x.Dummy_Guid == ChannelDummyGuid).FirstOrDefault();
                objPDRC.EntityState = State.Deleted;
                TempData["Action"] = "EDIT_RUN_CHANNEL";
                TempData["idRUN_CHANNEL"] = objPDR.Dummy_Guid;
            }
            var obj = new
            {
                Status = status
            };
            return Json(obj);
        }

        public JsonResult BindSingleTitle(string DummyCode)
        {
            Provisional_Deal_Title objPDT = objPD_Session.Provisional_Deal_Title.Where(x => x.Dummy_Guid == DummyCode).FirstOrDefault();
            lstProvisional_Deal_Run.Clear();
            lstProvisional_Deal_Run = objPDT.Provisional_Deal_Run.Where(x => x.EntityState != State.Deleted).ToList();
            if (lstProvisional_Deal_Run.Where(x => x._Dummy_Guid == null).ToList().Count() > 0)
            {
                foreach (var item in lstProvisional_Deal_Run.Where(x => x._Dummy_Guid == null).ToList())
                {
                    item._Dummy_Guid = item.Dummy_Guid;
                }
            }
            string displayPrime_Start_Time = "", displayPrime_End_Time = "", displayOff_Prime_Start_Time = "", displayOff_Prime_End_Time = "";
            if (objPDT.Prime_Start_Time != null)
            {
                DateTime Prime_Start_Time = DateTime.Today.Add(objPDT.Prime_Start_Time.Value);
                DateTime Prime_End_Time = DateTime.Today.Add(objPDT.Prime_End_Time.Value);
                DateTime Off_Prime_Start_Time = DateTime.Today.Add(objPDT.Off_Prime_Start_Time.Value);
                DateTime Off_Prime_End_Time = DateTime.Today.Add(objPDT.Off_Prime_End_Time.Value);

                displayPrime_Start_Time = Prime_Start_Time.ToString("hh:mm tt");
                displayPrime_End_Time = Prime_End_Time.ToString("hh:mm tt");
                displayOff_Prime_Start_Time = Off_Prime_Start_Time.ToString("hh:mm tt");
                displayOff_Prime_End_Time = Off_Prime_End_Time.ToString("hh:mm tt");
            }
            string TitleName = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == objPDT.Title_Code).Select(x => x.Title_Name.ToString()).FirstOrDefault();

            if (objPD_Session.Deal_Type_Code != GlobalParams.Deal_Type_Movie)
            {
                if (objPDT.Episode_From != null)
                {
                    TitleName = TitleName + " ( " + objPDT.Episode_From + " - " + objPDT.Episode_To + " ) ";
                }
            }

            string Right_Start_date = objPDT.Right_Start_Date.ToString();
            string Right_End_date = objPDT.Right_End_Date.ToString();

            Dictionary<string, object> objDictionary = new Dictionary<string, object>();
            objDictionary.Add("Unique_ID", objPDT.Dummy_Guid.ToString());
            objDictionary.Add("Title_Name", TitleName);
            objDictionary.Add("Right_Start_date", Right_Start_date);
            objDictionary.Add("Right_End_date", Right_End_date);
            objDictionary.Add("Prime_Start_Time", displayPrime_Start_Time);
            objDictionary.Add("Prime_End_Time", displayPrime_End_Time);
            objDictionary.Add("Off_Prime_Start_Time", displayOff_Prime_Start_Time);
            objDictionary.Add("Off_Prime_End_Time", displayOff_Prime_End_Time);
            objDictionary.Add("dummyTitleCode", DummyCode);
            return Json(objDictionary);
        }

        public JsonResult BindAddChannel(string item_GUID, string key = "")
        {
            Provisional_Deal_Run objPDR = lstProvisional_Deal_Run.Where(x => x.Dummy_Guid == item_GUID).FirstOrDefault();
            string[] arrchannel_code = objPDR.Provisional_Deal_Run_Channel.Select(x => x.Channel_Code.ToString()).ToArray();
            List<SelectListItem> lstChannel_AddCHN = new SelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(T => T.Is_Active == "Y" &&
                !arrchannel_code.Contains(T.Channel_Code.ToString()))
                .Select(R => new { Channel_Name = R.Channel_Name, Channel_Code = R.Channel_Code }), "Channel_Code", "Channel_Name").ToList();

            Provisional_Deal_Run_Channel objPDRC = objPDR.Provisional_Deal_Run_Channel.FirstOrDefault();

            Dictionary<string, object> objDictionary = new Dictionary<string, object>();
            objDictionary.Add("lstChannel_AddCHN", lstChannel_AddCHN);
            objDictionary.Add("Right_Start_Date", objPDRC.Right_Start_Date.ToString());
            objDictionary.Add("Right_End_Date", objPDRC.Right_End_Date.ToString());
            return Json(objDictionary);
        }

        public JsonResult SaveUpdate_RUN_CHANNEL(FormCollection objFormCollection)
        {
            bool isError = false;
            string Overlap_Channel_Name = "";
            string status = "S", message = "";
            string dummy_GUID = objFormCollection["dummy_GUID"];

            bool is_UN;
            string ddlChannel;
            DateTime Start_Date, End_Date;
            int Run, ddlRightRule, Prime, Off_Prime;
            TimeSpan txtSimulcast;
            string[] Start_Date_Edit, End_Date_Edit;
            string ddlChannel_chn;
            DateTime Start_Date_chn, End_Date_chn;



            if (dummy_GUID != "")
            {
                Provisional_Deal_Run objProvisional_Deal_Run = lstProvisional_Deal_Run.Where(x => x.Dummy_Guid == dummy_GUID && x.EntityState != State.Deleted).FirstOrDefault();
                string isClone = objFormCollection["isClone"].ToString();
                is_UN = Convert.ToBoolean(objFormCollection["Chk_Run_Type_Edit"]);

                Start_Date_Edit = objFormCollection["Start_Date_Edit"].Split(',');
                End_Date_Edit = objFormCollection["End_Date_Edit"].Split(',');
                int Counter = Convert.ToInt32(objFormCollection["counter"]);

                if (objFormCollection["txtSimulcast_Edit"].ToString() != "")
                {
                    txtSimulcast = TimeSpan.Parse(objFormCollection["txtSimulcast_Edit"].ToString());
                    objProvisional_Deal_Run.Simulcast_Time_lag = txtSimulcast;
                }
                else
                    objProvisional_Deal_Run.Simulcast_Time_lag = TimeSpan.Zero;

                dynamic channelarray = null;
                dynamic channel_DummyIDarray = null;
                //Provisional_Deal_Run del_obj = lstProvisional_Deal_Run.Where(x => x.Dummy_Guid == dummy_GUID).FirstOrDefault();
                if (objProvisional_Deal_Run != null)
                {
                    channelarray = objProvisional_Deal_Run.Provisional_Deal_Run_Channel.Where(x => x.EntityState != State.Deleted).Select(x => x.Channel_Code).ToArray();
                    channel_DummyIDarray = objProvisional_Deal_Run.Provisional_Deal_Run_Channel.Where(x => x.EntityState != State.Deleted).Select(x => x.Dummy_Guid).ToArray();
                    // lstProvisional_Deal_Run.Remove(objProvisional_Deal_Run);
                    Session["channel_array"] = channelarray;
                    Session["channel_DummyIDarray"] = channel_DummyIDarray;
                }
                else
                {
                    channelarray = Session["channel_array"];
                    channel_DummyIDarray = Session["channel_DummyIDarray"];
                }
                #region ------ Validation channel Name And Date
                if (isClone != "Y")
                {
                    foreach (var objPDRC in lstProvisional_Deal_Run.Where(x => x.Dummy_Guid != dummy_GUID && x.EntityState != State.Deleted).ToList())
                    {
                        foreach (var item in objPDRC.Provisional_Deal_Run_Channel.Where(x => x.EntityState != State.Deleted).ToList())
                        {
                            int i = 0;
                            foreach (var ddlChannel_code in channelarray)
                            {
                                if (item.Channel_Code == Convert.ToInt32(ddlChannel_code))
                                {
                                    var channelName = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Code == item.Channel_Code).Select(x => x.Channel_Name).FirstOrDefault();
                                    if ((item.Right_Start_Date <= Convert.ToDateTime(Start_Date_Edit.ElementAt(i)) && Convert.ToDateTime(Start_Date_Edit.ElementAt(i)) <= item.Right_End_Date) ||
                                        (item.Right_Start_Date <= Convert.ToDateTime(End_Date_Edit.ElementAt(i)) && Convert.ToDateTime(End_Date_Edit.ElementAt(i)) <= item.Right_End_Date))
                                    {

                                        isError = true;
                                        if (!Overlap_Channel_Name.Split(',').Contains(channelName.ToString()))
                                            Overlap_Channel_Name = Overlap_Channel_Name + channelName + ",";
                                    }
                                    else if (item.Right_Start_Date >= Convert.ToDateTime(Start_Date_Edit.ElementAt(i)))
                                    {
                                        if (item.Right_Start_Date <= Convert.ToDateTime(End_Date_Edit.ElementAt(i)) && Convert.ToDateTime(End_Date_Edit.ElementAt(i)) >= item.Right_End_Date)
                                        {
                                            isError = true;
                                            if (!Overlap_Channel_Name.Split(',').Contains(channelName.ToString()))
                                                Overlap_Channel_Name = Overlap_Channel_Name + channelName + ",";
                                        }
                                    }
                                }
                                i++;
                            }
                        }
                    }

                    if (objFormCollection["cmd"] == "NEW_CHN")
                    {
                        ddlChannel_chn = objFormCollection["ddlChannel_chn"];
                        Start_Date_chn = Convert.ToDateTime(objFormCollection["Start_Date_chn"]);
                        End_Date_chn = Convert.ToDateTime(objFormCollection["End_Date_chn"]);

                        string[] values = ddlChannel_chn.Split(',');

                        foreach (var objPDRC in lstProvisional_Deal_Run.Where(x => x.Dummy_Guid != dummy_GUID && x.EntityState != State.Deleted).ToList())
                        {
                            foreach (var item in objPDRC.Provisional_Deal_Run_Channel.Where(x => x.EntityState != State.Deleted).ToList())
                            {
                                foreach (var ddlChannel_code in values)
                                {
                                    if (item.Channel_Code == Convert.ToInt32(ddlChannel_code))
                                    {
                                        var channelName = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Code == item.Channel_Code).Select(x => x.Channel_Name).FirstOrDefault();
                                        if ((item.Right_Start_Date <= Start_Date_chn && Start_Date_chn <= item.Right_End_Date) || (item.Right_Start_Date <= End_Date_chn && End_Date_chn <= item.Right_End_Date))
                                        {
                                            isError = true;
                                            if (!Overlap_Channel_Name.Split(',').Contains(channelName.ToString()))
                                                Overlap_Channel_Name = Overlap_Channel_Name + channelName + ",";
                                        }
                                        else if (item.Right_Start_Date >= Start_Date_chn)
                                        {
                                            if (item.Right_Start_Date <= End_Date_chn && End_Date_chn >= item.Right_End_Date)
                                            {
                                                isError = true;
                                                if (!Overlap_Channel_Name.Split(',').Contains(channelName.ToString()))
                                                    Overlap_Channel_Name = Overlap_Channel_Name + channelName + ",";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (isClone == "Y")
                {
                    ddlChannel = objFormCollection["ddlChannel_Edit"];
                    string[] values = ddlChannel.Split(',');
                    foreach (var objPDRC in lstProvisional_Deal_Run.Where(x => x.Dummy_Guid != dummy_GUID && x.EntityState != State.Deleted).ToList())
                    {
                        foreach (var item in objPDRC.Provisional_Deal_Run_Channel.Where(x => x.EntityState != State.Deleted).ToList())
                        {
                            foreach (var ddlChannel_code in values)
                            {
                                if (item.Channel_Code == Convert.ToInt32(ddlChannel_code))
                                {
                                    var channelName = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Code == item.Channel_Code).Select(x => x.Channel_Name).FirstOrDefault();
                                    if ((item.Right_Start_Date <= Convert.ToDateTime(Start_Date_Edit.ElementAt(0)) && Convert.ToDateTime(Start_Date_Edit.ElementAt(0)) <= item.Right_End_Date) ||
                                        (item.Right_Start_Date <= Convert.ToDateTime(End_Date_Edit.ElementAt(0)) && Convert.ToDateTime(End_Date_Edit.ElementAt(0)) <= item.Right_End_Date))
                                    {
                                        isError = true;
                                        if (!Overlap_Channel_Name.Split(',').Contains(channelName.ToString()))
                                            Overlap_Channel_Name = Overlap_Channel_Name + channelName + ",";
                                    }
                                    else if (item.Right_Start_Date >= Convert.ToDateTime(Start_Date_Edit.ElementAt(0)))
                                    {
                                        if (item.Right_Start_Date <= Convert.ToDateTime(End_Date_Edit.ElementAt(0)) && Convert.ToDateTime(End_Date_Edit.ElementAt(0)) >= item.Right_End_Date)
                                        {
                                            isError = true;
                                            if (!Overlap_Channel_Name.Split(',').Contains(channelName.ToString()))
                                                Overlap_Channel_Name = Overlap_Channel_Name + channelName + ",";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                #endregion

                if (!isError)
                {
                    if (!is_UN)
                    {
                        Run = Convert.ToInt32(objFormCollection["run_Edit"]);

                        if (objFormCollection["Prime_Edit"] == "")
                            Prime = 0;
                        else
                            Prime = Convert.ToInt32(objFormCollection["Prime_Edit"]);
                        if (objFormCollection["Off_Prime_Edit"] == "")
                            Off_Prime = 0;
                        else
                            Off_Prime = Convert.ToInt32(objFormCollection["Off_Prime_Edit"]);

                        objProvisional_Deal_Run.No_Of_Runs = Run;
                        objProvisional_Deal_Run.Off_Prime_Runs = Off_Prime;
                        objProvisional_Deal_Run.Prime_Runs = Prime;
                        objProvisional_Deal_Run.Run_Type = "L";
                    }
                    else
                    {
                        objProvisional_Deal_Run.No_Of_Runs = null;
                        objProvisional_Deal_Run.Off_Prime_Runs = null;
                        objProvisional_Deal_Run.Prime_Runs = null;
                        objProvisional_Deal_Run.Run_Type = "U";
                    }

                    if (objFormCollection["ddlRightRule_Edit"] != "")
                    {
                        if (Convert.ToInt32(objFormCollection["ddlRightRule_Edit"]) != 0)
                        {
                            objProvisional_Deal_Run.Right_Rule_Code = Convert.ToInt32(objFormCollection["ddlRightRule_Edit"]);
                        }
                        else
                        {
                            objProvisional_Deal_Run.Right_Rule_Code = null;
                        }
                    }

                    objProvisional_Deal_Run.EntityState = State.Modified;
                    if (isClone == "Y")
                    {
                        ddlChannel = objFormCollection["ddlChannel_Edit"];
                        string[] values = ddlChannel.Split(',');
                        foreach (var item in values)
                        {
                            Provisional_Deal_Run_Channel objPDRC = new Provisional_Deal_Run_Channel();
                            objPDRC.Channel_Code = Convert.ToInt32(item);
                            objPDRC.Right_Start_Date = Convert.ToDateTime(Start_Date_Edit.ElementAt(0));
                            objPDRC.Right_End_Date = Convert.ToDateTime(End_Date_Edit.ElementAt(0));
                            objPDRC.EntityState = State.Added;
                            objProvisional_Deal_Run.Provisional_Deal_Run_Channel.Add(objPDRC);
                        }
                    }
                    else
                    {
                        int i = 0;
                        string[] temp = channel_DummyIDarray;
                        foreach (var ddlChannel_code in channelarray)
                        {
                            Provisional_Deal_Run_Channel objPDRC = objProvisional_Deal_Run.Provisional_Deal_Run_Channel.Where(x => x.Dummy_Guid == temp.ElementAt(i).ToString()).FirstOrDefault();
                            objPDRC.Channel_Code = Convert.ToInt32(ddlChannel_code);
                            objPDRC.Right_Start_Date = Convert.ToDateTime(Start_Date_Edit.ElementAt(i));
                            objPDRC.Right_End_Date = Convert.ToDateTime(End_Date_Edit.ElementAt(i));
                            if (!(objPDRC.Provisional_Deal_Run_Channel_Code == 0 && objPDRC.EntityState == State.Added))
                            {
                                objPDRC.EntityState = State.Modified;
                            }
                            i++;
                        }
                    }
                    if (objFormCollection["cmd"] == "NEW_CHN")
                    {
                        ddlChannel_chn = objFormCollection["ddlChannel_chn"];
                        Start_Date_chn = Convert.ToDateTime(objFormCollection["Start_Date_chn"]);
                        End_Date_chn = Convert.ToDateTime(objFormCollection["End_Date_chn"]);

                        string[] values = ddlChannel_chn.Split(',');
                        foreach (var item in values)
                        {
                            Provisional_Deal_Run_Channel objPDRC = new Provisional_Deal_Run_Channel();
                            objPDRC.Channel_Code = Convert.ToInt32(item);
                            objPDRC.Right_Start_Date = Start_Date_chn;
                            objPDRC.Right_End_Date = End_Date_chn;
                            objPDRC.EntityState = State.Added;
                            objProvisional_Deal_Run.Provisional_Deal_Run_Channel.Add(objPDRC);
                        }
                    }
                }
            }
            else
            {
                Provisional_Deal_Run objProvisional_Deal_Run = new Provisional_Deal_Run();
                is_UN = Convert.ToBoolean(objFormCollection["Chk_Run_Type"]);
                ddlChannel = objFormCollection["ddlChannel"];
                Start_Date = Convert.ToDateTime(objFormCollection["Start_Date"]);
                End_Date = Convert.ToDateTime(objFormCollection["End_Date"]);
                if (objFormCollection["txtSimulcast"].ToString() != "")
                {
                    txtSimulcast = TimeSpan.Parse(objFormCollection["txtSimulcast"].ToString());
                    objProvisional_Deal_Run.Simulcast_Time_lag = txtSimulcast;
                }
                else
                    objProvisional_Deal_Run.Simulcast_Time_lag = TimeSpan.Zero;

                string[] values = ddlChannel.Split(',');
                foreach (var objPDRC in lstProvisional_Deal_Run.Where(x => x.EntityState != State.Deleted).ToList())
                {
                    foreach (var item in objPDRC.Provisional_Deal_Run_Channel.Where(x => x.EntityState != State.Deleted).ToList())
                    {
                        foreach (var ddlChannel_code in values)
                        {
                            if (item.Channel_Code == Convert.ToInt32(ddlChannel_code))
                            {
                                var channelName = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Code == item.Channel_Code).Select(x => x.Channel_Name).FirstOrDefault();
                                if ((item.Right_Start_Date <= Start_Date && Start_Date <= item.Right_End_Date) || (item.Right_Start_Date <= End_Date && End_Date <= item.Right_End_Date))
                                {
                                    isError = true;
                                    if (!Overlap_Channel_Name.Split(',').Contains(channelName.ToString()))
                                        Overlap_Channel_Name = Overlap_Channel_Name + channelName + ",";
                                }
                                else if (item.Right_Start_Date >= Start_Date)
                                {
                                    if (item.Right_Start_Date <= End_Date && End_Date >= item.Right_End_Date)
                                    {
                                        isError = true;
                                        if (!Overlap_Channel_Name.Split(',').Contains(channelName.ToString()))
                                            Overlap_Channel_Name = Overlap_Channel_Name + channelName + ",";
                                    }
                                }
                            }
                        }
                    }
                }
                if (!isError)
                {
                    if (!is_UN)
                    {
                        Run = Convert.ToInt32(objFormCollection["run"]);

                        if (objFormCollection["Prime"] == "")
                            Prime = 0;
                        else
                            Prime = Convert.ToInt32(objFormCollection["Prime"]);
                        if (objFormCollection["Off_Prime"] == "")
                            Off_Prime = 0;
                        else
                            Off_Prime = Convert.ToInt32(objFormCollection["Off_Prime"]);

                        objProvisional_Deal_Run.No_Of_Runs = Run;
                        objProvisional_Deal_Run.Off_Prime_Runs = Off_Prime;
                        objProvisional_Deal_Run.Prime_Runs = Prime;
                        objProvisional_Deal_Run.Run_Type = "L";
                    }
                    else
                    {
                        objProvisional_Deal_Run.No_Of_Runs = null;
                        objProvisional_Deal_Run.Off_Prime_Runs = null;
                        objProvisional_Deal_Run.Prime_Runs = null;
                        objProvisional_Deal_Run.Run_Type = "U";
                    }

                    if (objFormCollection["ddlRightRule"] != "")
                    {
                        if (Convert.ToInt32(objFormCollection["ddlRightRule"]) != 0)
                        {
                            objProvisional_Deal_Run.Right_Rule_Code = Convert.ToInt32(objFormCollection["ddlRightRule"]);
                        }
                    }

                    objProvisional_Deal_Run.EntityState = State.Added;
                    foreach (var item in values)
                    {
                        Provisional_Deal_Run_Channel objPDRC = new Provisional_Deal_Run_Channel();
                        objPDRC.Channel_Code = Convert.ToInt32(item);
                        objPDRC.Right_Start_Date = Start_Date;
                        objPDRC.Right_End_Date = End_Date;
                        objPDRC.EntityState = State.Added;
                        objProvisional_Deal_Run.Provisional_Deal_Run_Channel.Add(objPDRC);
                    }
                    lstProvisional_Deal_Run.Add(objProvisional_Deal_Run);
                }
            }

            if (isError)
            {
                Overlap_Channel_Name = Overlap_Channel_Name.Remove(Overlap_Channel_Name.Length - 1);
                message = "Dates are getting overlapped for " + Overlap_Channel_Name;
                status = "E";
            }
            else
            {
                Session["Remove_ShowAll"] = null;
                Session["channel_array"] = null;
                Session["channel_DummyIDarray"] = null;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult Save_Update_Run_Defination(FormCollection objFormCollection)
        {
            string status = "S", message = "";
            if (!(lstProvisional_Deal_Run.Where(x => x.EntityState != State.Deleted).ToList().Count > 0))
            {
                status = "E";
                message = "Channel Must be included";
            }
            if (status == "S")
            {
                if (objFormCollection["isEdit_rundefn"] == "EDIT_RD_MOVIE")
                {
                    Provisional_Deal_Title objPDT = objPD_Session.Provisional_Deal_Title.Where(x => x.Dummy_Guid == objFormCollection["Unique_ID"].ToString()).FirstOrDefault();
                    DateTime Prime_Start_Time = DateTime.Now, Prime_End_Time = DateTime.Now, Off_Prime_Start_Time = DateTime.Now, Off_Prime_End_Time = DateTime.Now;
                    if (objFormCollection["Prime_Start_Time"] != "" &&
                      objFormCollection["Prime_End_Time"] != "" &&
                      objFormCollection["Off_Prime_Start_Time"] != "" &&
                      objFormCollection["Off_Prime_End_Time"] != "")
                    {

                        Prime_Start_Time = Convert.ToDateTime(objFormCollection["Prime_Start_Time"]);
                        Prime_End_Time = Convert.ToDateTime(objFormCollection["Prime_End_Time"]);
                        Off_Prime_Start_Time = Convert.ToDateTime(objFormCollection["Off_Prime_Start_Time"]);
                        Off_Prime_End_Time = Convert.ToDateTime(objFormCollection["Off_Prime_End_Time"]);

                        objPDT.Prime_Start_Time = Prime_Start_Time.TimeOfDay;
                        objPDT.Prime_End_Time = Prime_End_Time.TimeOfDay;
                        objPDT.Off_Prime_Start_Time = Off_Prime_Start_Time.TimeOfDay;
                        objPDT.Off_Prime_End_Time = Off_Prime_End_Time.TimeOfDay;
                    }
                    else if (objFormCollection["Prime_Start_Time"] == "" &&
                      objFormCollection["Prime_End_Time"] == "" &&
                      objFormCollection["Off_Prime_Start_Time"] == "" &&
                      objFormCollection["Off_Prime_End_Time"] == "")
                    {
                        //Prime_Start_Time = Convert.ToDateTime(objFormCollection["Prime_Start_Time"]);
                        //Prime_End_Time = Convert.ToDateTime(objFormCollection["Prime_End_Time"]);
                        //Off_Prime_Start_Time = Convert.ToDateTime(objFormCollection["Off_Prime_Start_Time"]);
                        //Off_Prime_End_Time = Convert.ToDateTime(objFormCollection["Off_Prime_End_Time"]);

                        objPDT.Prime_Start_Time = null;
                        objPDT.Prime_End_Time = null;
                        objPDT.Off_Prime_Start_Time = null;
                        objPDT.Off_Prime_End_Time = null;

                    }

                    foreach (var item in lstProvisional_Deal_Run)
                    {
                        Provisional_Deal_Run objPDR = new Provisional_Deal_Run();
                        if (item.Provisional_Deal_Run_Code == 0)
                        {
                            objPDR = objPDT.Provisional_Deal_Run.Where(x => x.Provisional_Deal_Run_Code == item.Provisional_Deal_Run_Code && x.Dummy_Guid == item.Dummy_Guid).FirstOrDefault();
                        }
                        else
                        {
                            objPDR = objPDT.Provisional_Deal_Run.Where(x => x.Provisional_Deal_Run_Code == item.Provisional_Deal_Run_Code).FirstOrDefault();
                        }
                        if (objPDR == null)
                        {
                            Provisional_Deal_Run objRun = new Provisional_Deal_Run();
                            objRun.No_Of_Runs = item.No_Of_Runs;
                            objRun.Off_Prime_Runs = item.Off_Prime_Runs;
                            objRun.Prime_Runs = item.Prime_Runs;
                            objRun.Right_Rule_Code = item.Right_Rule_Code;
                            objRun.Simulcast_Time_lag = item.Simulcast_Time_lag;
                            objRun.Run_Type = item.Run_Type;

                            foreach (var PDRC in item.Provisional_Deal_Run_Channel)
                            {
                                Provisional_Deal_Run_Channel objChannel = new Provisional_Deal_Run_Channel();
                                objChannel.Channel_Code = PDRC.Channel_Code;
                                objChannel.Right_Start_Date = PDRC.Right_Start_Date;
                                objChannel.Right_End_Date = PDRC.Right_End_Date;
                                objRun.Provisional_Deal_Run_Channel.Add(objChannel);
                            }
                            objPDT.Provisional_Deal_Run.Add(objRun);
                        }
                        else
                        {
                            if (objPDR.Provisional_Deal_Run_Code == 0)
                            {
                                if (objPDR.EntityState != State.Deleted)
                                {
                                    objPDR.EntityState = State.Added;
                                }
                                foreach (var objPDRC in objPDR.Provisional_Deal_Run_Channel)
                                {
                                    if (objPDRC.Provisional_Deal_Run_Code == 0 || objPDRC.Provisional_Deal_Run_Code == null)
                                    {
                                        if (objPDRC.EntityState != State.Deleted)
                                        {
                                            objPDRC.EntityState = State.Added;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    string ddlRunDefTitle = objFormCollection["ddlRunDefTitle"].ToString();
                    string[] title_Codes = ddlRunDefTitle.Split(',').ToArray();

                    DateTime Prime_Start_Time = DateTime.Now, Prime_End_Time = DateTime.Now, Off_Prime_Start_Time = DateTime.Now, Off_Prime_End_Time = DateTime.Now;

                    if (objFormCollection["Prime_Start_Time"] != "" &&
                        objFormCollection["Prime_End_Time"] != "" &&
                        objFormCollection["Off_Prime_Start_Time"] != "" &&
                        objFormCollection["Off_Prime_End_Time"] != "")
                    {
                        Prime_Start_Time = Convert.ToDateTime(objFormCollection["Prime_Start_Time"]);
                        Prime_End_Time = Convert.ToDateTime(objFormCollection["Prime_End_Time"]);
                        Off_Prime_Start_Time = Convert.ToDateTime(objFormCollection["Off_Prime_Start_Time"]);
                        Off_Prime_End_Time = Convert.ToDateTime(objFormCollection["Off_Prime_End_Time"]);
                    }

                    foreach (var titleCode in title_Codes)
                    {
                        Provisional_Deal_Title objPDT = new Provisional_Deal_Title();
                        if (objPD_Session.Deal_Type_Code != GlobalParams.Deal_Type_Movie)
                            objPDT = objPD_Session.Provisional_Deal_Title.Where(x => x.Dummy_Guid == titleCode.ToString()).FirstOrDefault();
                        else
                            objPDT = objPD_Session.Provisional_Deal_Title.Where(x => x.Title_Code == Convert.ToInt32(titleCode)).FirstOrDefault();

                        if (objFormCollection["Prime_Start_Time"] != "" &&
                            objFormCollection["Prime_End_Time"] != "" &&
                            objFormCollection["Off_Prime_Start_Time"] != "" &&
                            objFormCollection["Off_Prime_End_Time"] != "")
                        {
                            objPDT.Prime_Start_Time = Prime_Start_Time.TimeOfDay;
                            objPDT.Prime_End_Time = Prime_End_Time.TimeOfDay;
                            objPDT.Off_Prime_Start_Time = Off_Prime_Start_Time.TimeOfDay;
                            objPDT.Off_Prime_End_Time = Off_Prime_End_Time.TimeOfDay;
                        }

                        foreach (var item in lstProvisional_Deal_Run)
                        {
                            Provisional_Deal_Run objRun = new Provisional_Deal_Run();
                            objRun.No_Of_Runs = item.No_Of_Runs;
                            objRun.Off_Prime_Runs = item.Off_Prime_Runs;
                            objRun.Prime_Runs = item.Prime_Runs;
                            objRun.Right_Rule_Code = item.Right_Rule_Code;
                            objRun.Simulcast_Time_lag = item.Simulcast_Time_lag;
                            objRun.Run_Type = item.Run_Type;

                            foreach (var PDRC in item.Provisional_Deal_Run_Channel)
                            {
                                Provisional_Deal_Run_Channel objChannel = new Provisional_Deal_Run_Channel();
                                objChannel.Channel_Code = PDRC.Channel_Code;
                                objChannel.Right_Start_Date = PDRC.Right_Start_Date;
                                objChannel.Right_End_Date = PDRC.Right_End_Date;
                                objRun.Provisional_Deal_Run_Channel.Add(objChannel);
                            }
                            objPDT.Provisional_Deal_Run.Add(objRun);
                        }
                    }
                }
                lstProvisional_Deal_Run.Clear();
                message = "Record Saved Successfully";
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult Cancel_Run_Defination(string Title_dummycode)
        {
            if (Title_dummycode != null)
            {
                List<Provisional_Deal_Run> lst_PDR = new List<Provisional_Deal_Run>();
                lst_PDR = (List<Provisional_Deal_Run>)Session["Provisional_Deal_Run_List"];
                if (lst_PDR != null)
                {
                    Provisional_Deal_Title objPDT = objPD_Session.Provisional_Deal_Title.Where(x => x.Dummy_Guid == Title_dummycode).FirstOrDefault();

                    //objPDT.Provisional_Deal_Run.Clear();
                    int i = 0;
                    foreach (var item in lst_PDR)
                    {

                        Provisional_Deal_Run objPDR = objPDT.Provisional_Deal_Run.Where(x => x.Dummy_Guid == item.Dummy_Guid).FirstOrDefault();

                        if (objPDR != null)
                        {

                            // objPDR._Dummy_Guid = item._Dummy_Guid;
                            objPDR.EntityState = item.EntityState;
                            objPDR.No_Of_Runs = item.No_Of_Runs;
                            objPDR.Off_Prime_Runs = item.Off_Prime_Runs;
                            objPDR.Prime_Runs = item.Prime_Runs;
                            objPDR.Provisional_Deal_Run_Code = item.Provisional_Deal_Run_Code;
                            objPDR.Provisional_Deal_Title_Code = item.Provisional_Deal_Title_Code;
                            objPDR.Right_Rule_Code = item.Right_Rule_Code;
                            objPDR.Run_Type = item.Run_Type;
                            objPDR.Simulcast_Time_lag = item.Simulcast_Time_lag;


                            if (objPDR.Provisional_Deal_Run_Channel.Count > item.Provisional_Deal_Run_Channel.Count)
                            {
                                string[] arr_chnCode = item.Provisional_Deal_Run_Channel.Select(x => x.Channel_Code.ToString()).ToArray();
                                foreach (var item1 in objPDT.Provisional_Deal_Run.ElementAt(i).Provisional_Deal_Run_Channel.Where(x => !arr_chnCode.Contains(x.Channel_Code.ToString())).ToList())
                                {
                                    objPDT.Provisional_Deal_Run.ElementAt(i).Provisional_Deal_Run_Channel.Remove(item1);
                                }
                            }

                            int j = 0;
                            foreach (var objChannel in item.Provisional_Deal_Run_Channel)
                            {
                                Provisional_Deal_Run_Channel objPDRC = objPDR.Provisional_Deal_Run_Channel.ElementAt(j);
                                // objPDRC._Dummy_Guid = objChannel._Dummy_Guid;
                                objPDRC.Channel_Code = objChannel.Channel_Code;
                                objPDRC.EntityState = objChannel.EntityState;
                                objPDRC.Provisional_Deal_Run_Channel_Code = objChannel.Provisional_Deal_Run_Channel_Code;
                                objPDRC.Provisional_Deal_Run_Code = objChannel.Provisional_Deal_Run_Code;
                                objPDRC.Right_End_Date = objChannel.Right_End_Date;
                                objPDRC.Right_Start_Date = objChannel.Right_Start_Date;
                                objPDR.Provisional_Deal_Run_Channel.Add(objPDRC);
                                j++;
                            }
                            //         var dupes = item.Provisional_Deal_Run_Channel.GroupBy(x => new { x.Channel_Code, x.Right_End_Date , x.Right_Start_Date })
                            //                     .Where(x => x.Skip(1).Any());
                            //         var hasDupes = item.Provisional_Deal_Run_Channel.GroupBy(x => new { x.Channel_Code, x.Right_End_Date, x.Right_Start_Date })
                            //.Where(x => x.Skip(1).Any()).Any();

                            // objPDT.Provisional_Deal_Run.Add(objPDR);
                        }
                        //else
                        //{
                        // Provisional_Deal_Run objPDR_new = objPDT.Provisional_Deal_Run.Where(x => x.Dummy_Guid == item.Dummy_Guid).FirstOrDefault();

                        //    objPDR_new.EntityState = item.EntityState;
                        //    objPDR_new.No_Of_Runs = item.No_Of_Runs;
                        //    objPDR_new.Off_Prime_Runs = item.Off_Prime_Runs;
                        //    objPDR_new.Prime_Runs = item.Prime_Runs;
                        //    objPDR_new.Provisional_Deal_Run_Code = item.Provisional_Deal_Run_Code;
                        //    objPDR_new.Provisional_Deal_Title_Code = item.Provisional_Deal_Title_Code;
                        //    objPDR_new.Right_Rule_Code = item.Right_Rule_Code;
                        //    objPDR_new.Run_Type = item.Run_Type;
                        //    objPDR_new.Simulcast_Time_lag = item.Simulcast_Time_lag;
                        //    foreach (var objChannel in item.Provisional_Deal_Run_Channel)
                        //    {
                        //        Provisional_Deal_Run_Channel objPDRC = new Provisional_Deal_Run_Channel();
                        //        objPDRC._Dummy_Guid = objChannel._Dummy_Guid;
                        //        objPDRC.Channel_Code = objChannel.Channel_Code;
                        //        objPDRC.EntityState = objChannel.EntityState;
                        //        objPDRC.Provisional_Deal_Run_Channel_Code = objChannel.Provisional_Deal_Run_Channel_Code;
                        //        objPDRC.Provisional_Deal_Run_Code = objChannel.Provisional_Deal_Run_Code;
                        //        objPDRC.Right_End_Date = objChannel.Right_End_Date;
                        //        objPDRC.Right_Start_Date = objChannel.Right_Start_Date;
                        //        objPDR_new.Provisional_Deal_Run_Channel.Add(objPDRC);
                        //    }
                        //    objPDT.Provisional_Deal_Run.Add(objPDR_new);
                        //}
                        i++;
                    }
                }
            }
            Session["Provisional_Deal_Run_List"] = null;
            string status = "S";
            lstProvisional_Deal_Run.Clear();

            var obj = new
            {
                Status = status
            };
            return Json(obj);
        }

        #endregion

        #region ------------ADD EDIT PROVISIONAL DEAL---------------------------
        static List<Provisional_Deal> listProvisional_Deal = new List<Provisional_Deal>();
        #endregion

        #region ------------ADD EDIT TITLE---------------------------
        public ActionResult GetProDealTitles(int DealForCode, string searchString)
        {
            List<USP_Get_Provisional_Deal_Title_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Provisional_Deal_Title(DealForCode, searchString).ToList();
            return Json(lst);
        }

        public ActionResult GetProDealTitlesNotIn(int DealForCode, string searchString, string removeTitleCode, string action)
        {
            List<USP_Get_Provisional_Deal_Title_Result> list = new List<USP_Get_Provisional_Deal_Title_Result>();
            string[] HoldTitleCode = objPD_Session.Provisional_Deal_Title.Select(x => x.Title_Code.ToString()).ToArray();
            if (HoldTitleCode.Count() > 0)
            {
                list = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Provisional_Deal_Title(DealForCode, searchString).ToList().Where(x => !HoldTitleCode.Contains(x.Title_Code.ToString())).ToList();
            }
            else
            {
                list = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Provisional_Deal_Title(DealForCode, searchString).ToList();
            }
            return Json(list);
        }

        public ActionResult SaveTitle(string titleCodes, int dealTypeCode, string startdate, string enddate, int year, int month)
        {
            string[] arrTitleCodes;
            if (GlobalParams.Deal_Type_Movie == objPD_Session.Deal_Type_Code)
            {
                // objPD_Session.Provisional_Deal_Title.Clear();
                arrTitleCodes = titleCodes.Split(',').Distinct().ToArray();
            }
            else
            {
                arrTitleCodes = titleCodes.Split(',');
            }

            foreach (string item in arrTitleCodes)
            {
                Provisional_Deal_Title objProvisional_Deal_Title = new Provisional_Deal_Title();
                int titleCode = Convert.ToInt32(item);
                objProvisional_Deal_Title.Title_Code = titleCode;
                objProvisional_Deal_Title.Right_Start_Date = Convert.ToDateTime(startdate);
                objProvisional_Deal_Title.EntityState = State.Added;
                objProvisional_Deal_Title.Right_End_Date = Convert.ToDateTime(enddate);
                objProvisional_Deal_Title.Term = year + "." + month;
                objProvisional_Deal_Title._Dummy_Guid = objProvisional_Deal_Title.Dummy_Guid;
                objPD_Session.Provisional_Deal_Title.Add(objProvisional_Deal_Title);
            }
            objPD_Session.Deal_Type_Code = dealTypeCode;
            ViewBag.TitleCode = titleCodes;
            string status = "S", message = "";
            if (objPD_Session == null)
            {
                status = "E";
                message = "Error while saving";
            }

            var returnObj = new
            {
                Status = status,
                Message = message,
                TitleCode = string.Join(",", titleCodes)
            };
            return Json(returnObj);
        }

        public PartialViewResult BindListTitle(int row, string action)
        {
            ViewBag.Row = row;
            ViewBag.Action = action;
            ViewBag.DealTypeCode = objPD_Session.Deal_Type_Code;
            if (TempData["View"] != null)
            {
                TempData["View"] = GlobalParams.DEAL_MODE_VIEW;
                TempData.Keep();
            }
            return PartialView("~/Views/Pro_List/_List_Title.cshtml", objPD_Session.Provisional_Deal_Title.ToList());
        }

        public JsonResult BindRunDefTitle()
        {
            List<Provisional_Deal_Title> List = objPD_Session.Provisional_Deal_Title.Where(y => y.Provisional_Deal_Run.Count == 0).ToList();

            string[] arrTitle_code = List.Select(x => x.Title_Code.ToString()).ToArray();
            var listTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrTitle_code.Contains(x.Title_Code.ToString())).ToList();

            Dictionary<string, object> objDictionary = new Dictionary<string, object>();
            if (objPD_Session.Deal_Type_Code != 1)
            {
                var a = from title in listTitle
                        join pd_Title in List on title.Title_Code equals pd_Title.Title_Code
                        where title.Title_Code == pd_Title.Title_Code
                        select new
                        {
                            Title_Name = title.Title_Name,
                            Ep_From = pd_Title.Episode_From,
                            Ep_To = pd_Title.Episode_To,
                            sd = pd_Title.Right_Start_Date,
                            ed = pd_Title.Right_End_Date,
                            Title_Code = pd_Title.Dummy_Guid
                        };

                List<SelectListItem> lst_ddlRunDefTitle = new SelectList(a.
                    Select(R => new
                    {
                        Title_Name = R.Title_Name + " ( " + R.Ep_From + " - " + R.Ep_To + " ) (" + Convert.ToDateTime(R.sd).ToShortDateString() + " - " + Convert.ToDateTime(R.ed).ToShortDateString() + ")",
                        Title_Code = R.Title_Code
                    }), "Title_Code", "Title_Name").ToList();
                objDictionary.Add("lst_ddlRunDefTitle", lst_ddlRunDefTitle);

            }
            else
            {
                var a = from title in listTitle
                        join pd_Title in List on title.Title_Code equals pd_Title.Title_Code
                        where title.Title_Code == pd_Title.Title_Code
                        select new { Title_Name = title.Title_Name, sd = pd_Title.Right_Start_Date, ed = pd_Title.Right_End_Date, Title_Code = title.Title_Code };

                List<SelectListItem> lst_ddlRunDefTitle = new SelectList(a.
                    Select(R => new { Title_Name = R.Title_Name + " (" + Convert.ToDateTime(R.sd).ToShortDateString() + " - " + Convert.ToDateTime(R.ed).ToShortDateString() + ")", Title_Code = R.Title_Code }), "Title_Code", "Title_Name").ToList();
                objDictionary.Add("lst_ddlRunDefTitle", lst_ddlRunDefTitle);

            }

            return Json(objDictionary);
        }

        public ActionResult UpdateTitle(string guid, string Start_Date, string End_Date, int? Episode_From, int? Episode_To, int Term_YY, int Term_MM)
        {
            string status = "S", message = "";
            Provisional_Deal_Title objProDealTitle = objPD_Session.Provisional_Deal_Title.Where(m => m._Dummy_Guid == guid).FirstOrDefault();
            if (objProDealTitle != null)
            {
                objProDealTitle.Right_Start_Date = Convert.ToDateTime(Start_Date);
                objProDealTitle.Right_End_Date = Convert.ToDateTime(End_Date);
                objProDealTitle.Term = Term_YY + "." + Term_MM;
                objProDealTitle.Episode_From = Episode_From;
                objProDealTitle.Episode_To = Episode_To;
                message = "Data updated successfully";
            }
            else
            {
                status = "E";
                message = "Title not found";
            }

            var returnObj = new
            {
                Status = status,
                Message = message
            };
            return Json(returnObj);
        }

        public ActionResult DeleteTitle(string guid)
        {
            Provisional_Deal_Title objPDT = objPD_Session.Provisional_Deal_Title.Where(m => m._Dummy_Guid == guid).FirstOrDefault();
            if (objPDT != null)
            {
                if (objPDT.Provisional_Deal_Title_Code == 0 || objPDT.Provisional_Deal_Code != 0)
                    objPD_Session.Provisional_Deal_Title.Remove(objPDT);
                else
                    objPDT.EntityState = State.Modified;
            }
            return Json("");
        }

        private string GetTitleLabel(int dealTypeCode)
        {
            string Title_Label = "";
            if (dealTypeCode == GlobalParams.Deal_Type_Movie)
                Title_Label = "Movie";
            else if (dealTypeCode == GlobalParams.Deal_Type_Content)
                Title_Label = "Program";
            else if (dealTypeCode == GlobalParams.Deal_Type_Event)
                Title_Label = "Event";
            return Title_Label;
        }

        #endregion

        public JsonResult Save(Provisional_Deal objTempProDeal, FormCollection objForm)
        {
            dynamic resultset;
            if (objPD_Session.Provisional_Deal_Code > 0)
            {
                objPD_Session.EntityState = State.Modified;
                objPD_Session.Last_Action_By = objLoginUser.Users_Code;
                if (objForm["IsSubmitted"].ToString().Equals("Y"))
                {
                    if (objPD_Session.Deal_Workflow_Status == GlobalParams.dealWorkFlowStatus_Approved)
                    {
                        objPD_Session.Version = (Convert.ToInt32(objPD_Session.Version) + 1).ToString("0000");
                    }
                    else if (objPD_Session.Deal_Workflow_Status == GlobalParams.dealWorkFlowStatus_Ammended)
                    {
                        // objPD_Session.Version = (Convert.ToInt32(objPD_Session.Version) + 1).ToString("0000");
                        objPD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Approved;
                    }
                    else
                    {
                        objPD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Approved;
                    }
                }
                if (objForm["IsSubmitted"].ToString().Equals("N"))
                {
                    if (objPD_Session.Deal_Workflow_Status == GlobalParams.dealWorkFlowStatus_Approved)
                    {
                        objPD_Session.Version = (Convert.ToInt32(objPD_Session.Version) + 1).ToString("0000");
                        objPD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Ammended;
                    }
                    else
                    {
                        objPD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
                    }
                }
            }
            else
            {
                objPD_Session.Version = "0001";
                objPD_Session.EntityState = State.Added;
                objPD_Session.Inserted_By = objLoginUser.Users_Code;
                objPD_Session.Inserted_On = DateTime.Now;
                objPD_Session.Is_Active = "Y";
                if (objForm["IsSubmitted"].ToString().Equals("Y"))
                {
                    objPD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Approved;
                    TempData["_message"] = "Deal Added Successfully";
                    TempData.Keep();
                }
                else
                {
                    objPD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
                    TempData["_message"] = "Deal Added Successfully";
                    TempData.Keep();
                }
            }
            objPD_Session.Deal_Desc = objForm["Deal_Desc"].Trim();
            objPD_Session.Deal_Type_Code = Convert.ToInt32(objForm["hdnDeal_Type_Code"]);
            objPD_Session.Business_Unit_Code = Convert.ToInt32(objTempProDeal.Business_Unit_Code);
            objPD_Session.Content_Type = objForm["Content_Type"];
            objPD_Session.Entity_Code = Convert.ToInt32(objForm["LicenseeList"]);
            objPD_Session.Right_Start_Date = Convert.ToDateTime(objForm["Start_Date"]);
            objPD_Session.Right_End_Date = Convert.ToDateTime(objForm["End_Date"]);
            objPD_Session.Term = objForm["Term_YY"] + '.' + objForm["Term_MM"];
            objPD_Session.Agreement_Date = Convert.ToDateTime(objForm["Agreement_Date"]).Date;
            objPD_Session.Remarks = objForm["Remarks"].ToString().Replace("\r\n", "\n");
            #region -- Update Title Data --
            if (GlobalParams.Deal_Program == GlobalUtil.GetDealTypeCondition((int)objPD_Session.Deal_Type_Code) || GlobalParams.Deal_Type_Movie == objPD_Session.Deal_Type_Code)
            {
                objTempProDeal.Provisional_Deal_Title.ToList().ForEach(f =>
                {
                    Provisional_Deal_Title objPDT = objPD_Session.Provisional_Deal_Title.Where(w => w.Dummy_Guid == f.Dummy_Guid).FirstOrDefault();
                    if (objPDT != null)
                    {
                        if (objPD_Session.Deal_Type_Code == GlobalParams.Deal_Type_Movie)
                        {
                            objPDT.Episode_From = 1;
                            objPDT.Episode_To = 1;
                        }
                        else
                        {
                            objPDT.Episode_From = f.Episode_From ?? 0;
                            objPDT.Episode_To = f.Episode_To ?? 0;
                        }
                    }
                });
            }
            objPD_Session.Provisional_Deal_Title.ToList().ForEach(f =>
            {
                f.EntityState = (f.Provisional_Deal_Title_Code > 0 && f.EntityState != State.Deleted) ? State.Modified : State.Added;
            });
            #endregion

            #region -- Add Edit Licensor --
            objPD_Session.Provisional_Deal_Licensor.ToList().ForEach(f =>
            {
                f.EntityState = (f.Provisional_Deal_Licensor_Code > 0 && f.EntityState != State.Deleted) ? State.Modified : State.Added;
            });

            string licensorList = objForm["Provisional_Deal_Licensor"];
            string[] licensorCodeList = (licensorList ?? "").Split(',');

            ICollection<Provisional_Deal_Licensor> selectLicensor = new HashSet<Provisional_Deal_Licensor>();
            foreach (string licensorCode in licensorCodeList)
            {
                if (licensorCode != "")
                {
                    Provisional_Deal_Licensor objPDL = new Provisional_Deal_Licensor();
                    objPDL.EntityState = State.Added;
                    objPDL.Vendor_Code = Convert.ToInt32(licensorCode);
                    selectLicensor.Add(objPDL);
                }
            }
            IEqualityComparer<Provisional_Deal_Licensor> compareProDealLicensor = new LambdaComparer<Provisional_Deal_Licensor>((x, y) => x.Vendor_Code == y.Vendor_Code && x.EntityState != State.Deleted);
            var Deleted_Provisional_Deal_Licensor = new List<Provisional_Deal_Licensor>();
            var Added_Provisional_Deal_Licensor = CompareLists<Provisional_Deal_Licensor>(selectLicensor.ToList<Provisional_Deal_Licensor>(), objPD_Session.Provisional_Deal_Licensor.ToList<Provisional_Deal_Licensor>(), compareProDealLicensor, ref Deleted_Provisional_Deal_Licensor);
            Added_Provisional_Deal_Licensor.ToList<Provisional_Deal_Licensor>().ForEach(t => objPD_Session.Provisional_Deal_Licensor.Add(t));
            Deleted_Provisional_Deal_Licensor.ToList<Provisional_Deal_Licensor>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            string status = "S";
            if (!objProDealService.Save(objPD_Session, out resultset))
            {
                status = "E";
                TempData["_message"] = resultset;
                TempData.Keep();
            }

            var returnObj = new
            {
                Status = status,
                Message = TempData["_message"].ToString()
            };
            TempData["IsMenu"] = "N";
            return Json(returnObj);
        }

        public JsonResult GetEpF_EpT_ForRunDef(List<Provisional_Deal_Title> titleList)
        {
            string status = "S", message = "";
            if (titleList != null)
            {
                if (GlobalParams.Deal_Program == GlobalUtil.GetDealTypeCondition((int)objPD_Session.Deal_Type_Code))
                {
                    foreach (Provisional_Deal_Title objPD_MVC in titleList)
                    {
                        Provisional_Deal_Title objPDT = objPD_Session.Provisional_Deal_Title.Where(w => w.EntityState != State.Deleted && w.Dummy_Guid == objPD_MVC.Dummy_Guid).FirstOrDefault();
                        if (objPDT != null)
                        {
                            if (objPD_MVC.Episode_From != null && objPD_MVC.Episode_To != null)
                            {
                                objPDT.Episode_From = objPD_MVC.Episode_From;
                                objPDT.Episode_To = objPD_MVC.Episode_To;
                            }
                        }
                    }

                }
            }
            var returnObj = new
            {
                Status = status,
                Message = message
            };
            return Json(returnObj);
        }

        private Provisional_Deal Clone(int proDealCode)
        {
            Provisional_Deal objNew = new Provisional_Deal();
            Provisional_Deal objExisting = objProDealService.GetById(proDealCode);
            RightsU_BLL.Title_Service objTitle_Service = new RightsU_BLL.Title_Service(objLoginEntity.ConnectionStringName);
            objNew.Provisional_Deal_Code = 0;
            objNew.Agreement_Date = objExisting.Agreement_Date;
            objNew.Agreement_No = objExisting.Agreement_No;
            objNew.Business_Unit_Code = objExisting.Business_Unit_Code;
            objNew.Content_Type = objExisting.Content_Type;
            objNew.Deal_Desc = objExisting.Deal_Desc;
            objNew.Deal_Type_Code = objExisting.Deal_Type_Code;
            objNew.Deal_Workflow_Status = objExisting.Deal_Workflow_Status;
            objNew.Entity_Code = objExisting.Entity_Code;
            objExisting.Provisional_Deal_Title.ToList().ForEach(f =>
            {
                Provisional_Deal_Title objPDT = objExisting.Provisional_Deal_Title.Where(w => w.Dummy_Guid == f.Dummy_Guid).FirstOrDefault();
                if (objPDT != null)
                {
                    Provisional_Deal_Title objPDTNew = new Provisional_Deal_Title();
                    objPDTNew.Provisional_Deal_Code = 0;
                    objPDTNew.Title_Code = objPDT.Title_Code;
                    objPDT.Title = objTitle_Service.GetById((int)objPDT.Title_Code);
                    objPDTNew.Episode_From = objPDT.Episode_From ?? 0;
                    objPDTNew.Episode_To = objPDT.Episode_To ?? 0;
                    objPDTNew.Term = objPDT.Term;
                    objPDTNew.Right_End_Date = objPDT.Right_End_Date;
                    objPDTNew.Right_Start_Date = objPDT.Right_Start_Date;
                    objPDTNew.EntityState = State.Added;
                    objNew.Provisional_Deal_Title.Add(objPDTNew);
                }
            });
            objExisting.Provisional_Deal_Licensor.ToList().ForEach(f =>
            {
                Provisional_Deal_Licensor objPDL = objExisting.Provisional_Deal_Licensor.Where(w => w.Provisional_Deal_Licensor_Code == f.Provisional_Deal_Licensor_Code).FirstOrDefault();
                if (objPDL != null)
                {
                    Provisional_Deal_Licensor objPDLNew = new Provisional_Deal_Licensor();
                    objPDLNew.Provisional_Deal_Code = 0;
                    objPDLNew.Vendor_Code = objPDL.Vendor_Code;
                    objPDLNew.EntityState = State.Added;
                    objNew.Provisional_Deal_Licensor.Add(objPDLNew);
                }
            });
            objNew.Provisional_Deal_Type_Code = objExisting.Provisional_Deal_Type_Code;
            objNew.Remarks = objExisting.Remarks;
            objNew.Right_End_Date = objExisting.Right_End_Date;
            objNew.Right_Start_Date = objExisting.Right_Start_Date;
            objNew.Term = objExisting.Term;
            objNew.Version = objExisting.Version;
            objNew.Inserted_By = objExisting.Inserted_By;
            objProDealService = null;
            return objNew;
        }

        public JsonResult OnKeyupEpisodes(string guid, string callFrom, int EpFrom = 0, int EpTo = 0)
        {

            Provisional_Deal_Title objProTitle = objPD_Session.Provisional_Deal_Title.Where(x => x._Dummy_Guid == guid).FirstOrDefault();
            if (callFrom == "F")
            {
                objProTitle.Episode_From = EpFrom;
            }
            if (callFrom == "T")
            {
                objProTitle.Episode_To = EpTo;
            }
            return Json(objProTitle.Episode_From);
        }

        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult) where T : class
        {

            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);

            DelResult = DeleteResult.ToList<T>();

            return AddResult.ToList<T>();
        }
    }

    public class Pro_Deal_Search
    {
        public int PageNo { get; set; }
        public int RecordPerPage { get; set; }
        public string SearchText { get; set; }
        public string Agreement_No { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int Deal_Type_Code { get; set; }
        public int Business_Unit_Code { get; set; }
        public string Vendor_Codes { get; set; }
        public string Titles_Codes { get; set; }
        public string IsAdvance_Search { get; set; }
        public int RecordLockingCode { get; set; }
    }
}
