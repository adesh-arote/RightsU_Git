using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;
using System.Data.Entity.Core.Objects;

namespace RightsU_Plus.Controllers
{
    public class TATController : BaseController
    {
        public ActionResult Index()
        {
            return View();
        }
        public PartialViewResult BindGrid(int PageNo = 1, int PageSize = 10)
        {
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            List<USPTATList_Result> lstTAT = objUSP_Service.USPTATList(PageNo, PageSize, objRecordCount).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.PageSize = PageSize;
            ViewBag.PageNo = PageNo;
            ViewBag.RecordCount = RecordCount;
            return PartialView("~/Views/TAT/_ListTAT.cshtml", lstTAT);
        }
        public PartialViewResult AssignTAT(int TATCode)
        {
            TAT_Service objTATService = new TAT_Service(objLoginEntity.ConnectionStringName);
            TAT objTAT = objTATService.GetById(TATCode);
            Binddl(objTAT);

            ViewBag.Status = new TATSLAStatus_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.TATSLAStatusCode == objTAT.TATSLAStatusCode).Select(x => x.TATSLAStatusName).FirstOrDefault();
            if(objTAT.Type == "A")
                ViewBag.AgreementNo = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objTAT.DealCode).Select(x => x.Agreement_No).FirstOrDefault();
            if (objTAT.Type == "S")
                ViewBag.AgreementNo = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objTAT.DealCode).Select(x => x.Agreement_No).FirstOrDefault();
            return PartialView("~/Views/TAT/_AssignTAT.cshtml", objTAT);
        }
        public void Binddl(TAT objTAT)
        {
            Business_Unit_Service objBuS = new Business_Unit_Service(objLoginEntity.ConnectionStringName);
            User_Service objUserS = new User_Service(objLoginEntity.ConnectionStringName);
            Deal_Type_Service objDtS = new Deal_Type_Service(objLoginEntity.ConnectionStringName);
            TATSLA_Service objTATSLAS = new TATSLA_Service(objLoginEntity.ConnectionStringName);
            List<SelectListItem> lstBu = new SelectList(objBuS.SearchFor(x => x.Business_Unit_Code != 0).ToList(), "Business_Unit_Code", "Business_Unit_Name", objTAT.BusinessUnitCode).ToList();
            List<SelectListItem> lstUser = new SelectList(objUserS.SearchFor(x => x.Users_Code != 0).ToList(), "Users_Code", "First_Name",objTAT.UserCode).ToList();
            List<SelectListItem> lstDealType = new SelectList(objDtS.SearchFor(x => x.Deal_Type_Code != 0).ToList(), "Deal_Type_Code", "Deal_Type_Name",objTAT.DealType).ToList();
            List<SelectListItem> lstTATSLA = new SelectList(objTATSLAS.SearchFor(x => x.TATSLACode != 0).ToList(), "TATSLACode", "TATSLAName",objTAT.TATSLACode).ToList();
            lstBu.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            lstUser.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            lstDealType.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            lstTATSLA.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            ViewBag.BusinessUnit = lstBu;
            ViewBag.User = lstUser;
            ViewBag.DealFormat = lstDealType;
            ViewBag.SLA = lstTATSLA;
        }
        public JsonResult ButtonEvent(string action, int TATCode = 0, int BuCode = 0, int UserCode = 0, string Type = "", string IsAmend = "", int DealType = 0,
            string AgreementNo = "", int TATSLACode = 0)
        {
            dynamic resultset;
            dynamic resultsetlog;
            bool Isvalid = true;
            string message = "";
            string MessageType = "S";
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            TAT_Service TATservice = new TAT_Service(objLoginEntity.ConnectionStringName);
            TATStatusLog_Service objLogservice = new TATStatusLog_Service(objLoginEntity.ConnectionStringName);
            TAT objTAT = TATservice.SearchFor(x => x.TATCode == TATCode).FirstOrDefault();
            List<TATSLAStatus> lstStatus = new TATSLAStatus_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.TATSLAStatusCode != 1).ToList();

            List<TATSLAStatus> lstSeekStatus = new TATSLAStatus_Service(objLoginEntity.ConnectionStringName)
                .SearchFor(x => x.TATSLAStatusName == "Seek Clarification" || x.TATSLAStatusName == "Complete Clarification").ToList();

            if (action == "Assign")
            {
                objTAT.TATSLACode = TATSLACode;
                objTAT.BusinessUnitCode = BuCode;
                objTAT.UserCode = UserCode;
                objTAT.Type = (Type == "Acq" ? "A" : "S");
                objTAT.IsAmend = IsAmend;
                objTAT.DealType = DealType;
                objTAT.TATSLAStatusCode = lstStatus.Where(x => x.TATSLAStatusName == "Pending FLR").Select(x => x.TATSLAStatusCode).FirstOrDefault();
                message = "Deal has been assigned successfully";
            }
            if (action == "Send For QC")
            {
                int Deal_Code = 0;
                if (Type == "Acq")
                    Deal_Code = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Agreement_No == AgreementNo).Select(x => x.Acq_Deal_Code).FirstOrDefault();
                else
                    Deal_Code = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Agreement_No == AgreementNo).Select(x => x.Syn_Deal_Code).FirstOrDefault();

                if (Deal_Code == null || Deal_Code == 0)
                {
                    Isvalid = false;
                    message = "Deal Number is not valid";
                }
                else
                {
                    message = "Deal has been sent for QC";
                    objTAT.DealCode = Deal_Code;
                }

                objTAT.TATSLAStatusCode = lstStatus.Where(x => x.TATSLAStatusName == "Pending QC").Select(x => x.TATSLAStatusCode).FirstOrDefault(); ;
            }

            if (action == "Seek Clarification")
            {
                objTAT.TATSLAStatusCode = lstStatus.Where(x => x.TATSLAStatusName == "Pending External Clarification").Select(x => x.TATSLAStatusCode).FirstOrDefault();
                message = "Deal has been assigned successfully";
            }

            if (action == "Complete Clarification")
            {
                TATStatusLog objTATStatusLog = objLogservice.SearchFor(x=>x.TATCode == TATCode && x.TATSLAStatus.TATSLAStatusName != "Pending External Clarification" ).OrderByDescending(x=>x.TATStatusLogCode).FirstOrDefault();
                objTAT.TATSLAStatusCode = objTATStatusLog.TATSLAStatusCode;
                message = "Clarification Completed";
            }
            if(action == "QC Completed")
            {
                objTAT.TATSLAStatusCode = lstStatus.Where(x => x.TATSLAStatusName == "QC Completed").Select(x => x.TATSLAStatusCode).FirstOrDefault();
                message = "QC Completed";
            }
            if (Isvalid)
            {
                objTAT.EntityState = State.Modified;
                TATservice.Save(objTAT, out resultset);
                TATStatusLog objTATStatusLog = new TATStatusLog();
                objTATStatusLog.TATCode = objTAT.TATCode;
                objTATStatusLog.TATSLAStatusCode = objTAT.TATSLAStatusCode;
                objTATStatusLog.StatusChangedOn = DateTime.Now;
                objTATStatusLog.StatusChangedBy = objLoginUser.Users_Code;
                objTATStatusLog.EntityState = State.Added;
                objLogservice.Save(objTATStatusLog, out resultsetlog);
            }
            else
            {
                MessageType = "E";
            }
            objJson.Add("Message", message);
            objJson.Add("MessageType", MessageType);
            return Json(objJson);
        }
    }
}
