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

namespace RightsU_Plus.Controllers
{
    public class TATSLAController : BaseController
    {

        private List<RightsU_Entities.USPTATSLAList_Result> lstSLAList
        {
            get
            {
                if (Session["lstSLAlist"] == null)
                    Session["lstSLAlist"] = new List<RightsU_Entities.USPTATSLAList_Result>();
                return (List<RightsU_Entities.USPTATSLAList_Result>)Session["lstSLAList"];
            }
            set
            { Session["lstSLAList"] = value; }
        }
        private TATSLAUDT objTATSLAUDT
        {
            get
            {
                if (Session["objTATSLAUDT"] == null)
                    Session["objTATSLAUDT"] = new TATSLAUDT();
                return (TATSLAUDT)Session["objTATSLAUDT"];
            }
            set
            { Session["objTATSLAUDT"] = value; }
        }
        private List<RightsU_Entities.TATSLAUDT> lstTATSLAUDT
        {
            get
            {
                if (Session["lstTATSLAUDT"] == null)
                    Session["lstTATSLAUDT"] = new List<RightsU_Entities.TATSLAUDT>();
                return (List<RightsU_Entities.TATSLAUDT>)Session["lstTATSLAUDT"];
            }
            set
            { Session["lstTATSLAUDT"] = value; }
        }
        private TATSLA objT
        {
            get
            {
                if (Session["objT"] == null)
                    Session["objT"] = new TATSLA();
                return (TATSLA)Session["objT"];
            }
            set { Session["objT"] = value; }
        }
        private List<RightsU_Entities.TATSLA> lstTATSLA
        {
            get
            {
                if (Session["lstTATSLA"] == null)
                    Session["lstTATSLA"] = new List<RightsU_Entities.TATSLA>();
                return (List<RightsU_Entities.TATSLA>)Session["lstTATSLA"];
            }
            set { Session["lstTATSLA"] = value; }
        }
        public ActionResult Index()
        {
            objT = null;
            return View();
        }
        public PartialViewResult BindSLAList(string Key = "", int tatSLAcode = 0)
        {
            TATSLA_Service objTATSLA_Service = new TATSLA_Service(objLoginEntity.ConnectionStringName);
            if (Key == "List")
            {
                lstTATSLA = new TATSLA_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).ToList();
            }
            return PartialView("~/Views/TATSLA/_ListTATSLA.cshtml", lstTATSLA);
        }
        public PartialViewResult AddEditSLA(string Key = "", int tatSLACode = 0)
        {
            if (Key == "Edit" || Key == "List")
            {
                RightsU_Entities.TATSLA objTATSLA = lstTATSLA.Where(x => x.TATSLACode == tatSLACode).FirstOrDefault();
                List<RightsU_Entities.Business_Unit> lstBusinessUnit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                var businessUnitCodes = objTATSLA.BusinessUnitCode;
                ViewBag.BusinessUnit = new SelectList(lstBusinessUnit, "Business_Unit_Code", "Business_Unit_Name", businessUnitCodes);

                List<RightsU_Entities.Deal_Type> lstDealType = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                var dealTypeCodes = objTATSLA.DealTypeCode;
                ViewBag.DealTypeCodes = new SelectList(lstDealType, "Deal_Type_Code", "Deal_Type_Name", dealTypeCodes);

                ViewBag.SLAName = lstTATSLA.Where(x => x.TATSLACode == tatSLACode).Select(t => t.TATSLAName).FirstOrDefault();
                ViewBag.TATSLACode = tatSLACode;
            }
            if (Key == "Add")
            {
                List<RightsU_Entities.Business_Unit> lstBusinessUnit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                ViewBag.BusinessUnit = new SelectList(lstBusinessUnit, "Business_Unit_Code", "Business_Unit_Name");

                List<RightsU_Entities.Deal_Type> lstDealType = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).ToList();
                ViewBag.DealTypeCodes = new SelectList(lstDealType, "Deal_Type_Code", "Deal_Type_Name");
            }
            ViewBag.CommandName = Key;
            ViewBag.tatSLACode = tatSLACode;
            lstSLAList = new USP_Service(objLoginEntity.ConnectionStringName).USPTATSLAList(tatSLACode, Key).ToList();
            return PartialView("~/Views/TATSLA/_AddEditSLA.cshtml", lstSLAList);
        }
        public PartialViewResult BindSLAMatrix(string StatusName = "", int TATSLACode = 0, string CommandName = "")
        {
            string Key = "List";
            if (CommandName == "Add")
            {
                List<RightsU_Entities.TATSLAStatus> lstStatus = new TATSLAStatus_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.IsActive == "Y" && x.IsSLAEmail == "Y").ToList();
                ViewBag.SLAStatus = new SelectList(lstStatus, "TATSLAStatusCode", "TATSLAStatusName");
                List<RightsU_Entities.User> lstUsers = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                ViewBag.lstUsers = new MultiSelectList(lstUsers, "Users_Code", "First_Name");
            }
            if (CommandName == "Edit")
            {
                List<int> SLA1Users = new List<int>();
                List<int> SLA2Users = new List<int>();
                List<int> SLA3Users = new List<int>();
                List<RightsU_Entities.User> lstUsers = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                ViewBag.StatusName = StatusName;
                USPTATSLAList_Result obj = lstSLAList.Where(x => x.TATSLAStatusName == StatusName).FirstOrDefault();
                if (obj.SLA1Users != null)
                {
                    string[] Users1 = obj.SLA1Users.Split(',');
                    foreach (var item in Users1)
                    {
                        int i = lstUsers.Where(x => x.First_Name == item).Select(t => t.Users_Code).FirstOrDefault();
                        SLA1Users.Add(i);
                    }
                }
                if (obj.SLA2Users != null)
                {
                    string[] Users2 = obj.SLA2Users.Split(',');
                    foreach (var item in Users2)
                    {
                        int i = lstUsers.Where(x => x.First_Name == item).Select(t => t.Users_Code).FirstOrDefault();
                        SLA2Users.Add(i);
                    }
                }
                if (obj.SLA3Users != null)
                {
                    string[] Users3 = obj.SLA3Users.Split(',');
                    foreach (var item in Users3)
                    {
                        int i = lstUsers.Where(x => x.First_Name == item).Select(t => t.Users_Code).FirstOrDefault();
                        SLA3Users.Add(i);
                    }
                }
                List<RightsU_Entities.TATSLAStatus> lstStatus = new TATSLAStatus_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.IsActive == "Y" && x.IsSLAEmail == "Y").ToList();
                var StatusCode = lstStatus.Where(x => x.TATSLAStatusName == StatusName).Select(t => t.TATSLAStatusCode).FirstOrDefault();
                ViewBag.SLAStatus = new SelectList(lstStatus, "TATSLAStatusCode", "TATSLAStatusName", StatusCode);
                ViewBag.lstUsers1 = new MultiSelectList(lstUsers, "Users_Code", "First_Name", SLA1Users);
                ViewBag.lstUsers2 = new MultiSelectList(lstUsers, "Users_Code", "First_Name", SLA2Users);
                ViewBag.lstUsers3 = new MultiSelectList(lstUsers, "Users_Code", "First_Name", SLA3Users);
            }
            ViewBag.CommandName = CommandName;
            if (lstSLAList.Count == 0)
                lstSLAList = new USP_Service(objLoginEntity.ConnectionStringName).USPTATSLAList(TATSLACode, Key).ToList();
            return PartialView("~/Views/TATSLA/_SLAMatrics.cshtml", lstSLAList);
        }
        public JsonResult SaveSLAMatrix(string Action, string MatrixCodes, int TATSLACode, string[] SLA1Users, string[] SLA2Users, string[] SLA3Users, int SLA1FromDays = 0, int SLA1ToDays = 0, int SLA2FromDays = 0,
                                        int SLA2ToDays = 0, int SLA3FromDays = 0, int SLA3toDays = 0, int Status = 0)
        {
            List<USPTATSLAList_Result> list = lstSLAList;
            USPTATSLAList_Result obj = new USPTATSLAList_Result();
            string SLA1User = "", SLA2User = "", SLA3User = "";
            if (SLA1Users != null)
                SLA1User = string.Join(",", SLA1Users);

            if (SLA2Users != null)
                SLA2User = string.Join(",", SLA2Users);

            if (SLA3Users != null)
                SLA3User = string.Join(",", SLA3Users);

            RightsU_Entities.TATSLAUDT objTATSLAUDT = new TATSLAUDT();
            objTATSLAUDT.WorkflowStatus = Status;
            if (MatrixCodes != "")
            {
                if (Action == "Edit" || Action == "Delete")
                {
                    String[] MatrixCodesArray = MatrixCodes.Split(',');
                    objTATSLAUDT.TATSLAMatrix1Code = Convert.ToInt32(MatrixCodesArray[0]);
                    objTATSLAUDT.TATSLAMatrix2Code = Convert.ToInt32(MatrixCodesArray[1]);
                    objTATSLAUDT.TATSLAMatrix3Code = Convert.ToInt32(MatrixCodesArray[2]);
                }
                objTATSLAUDT.SLA1FromDays = SLA1FromDays;
                objTATSLAUDT.SLA1ToDays = SLA1ToDays;
                objTATSLAUDT.SLA1Users = SLA1User;
                objTATSLAUDT.SLA2FromDays = SLA2FromDays;
                objTATSLAUDT.SLA2ToDays = SLA2ToDays;
                objTATSLAUDT.SLA2Users = SLA2User;
                objTATSLAUDT.SLA3FromDays = SLA3FromDays;
                objTATSLAUDT.SLA3ToDays = SLA3toDays;
                objTATSLAUDT.SLA3Users = SLA3User;
                objTATSLAUDT.TATSLACode = TATSLACode;
                objTATSLAUDT.Action = Action;
                lstTATSLAUDT.Add(objTATSLAUDT);
                if (Action != "Delete")
                {
                    string Users1 = "", Users2 = "", Users3 = "", Name = "";
                    List<string> lstNames1 = new List<string>();
                    List<string> lstNames2 = new List<string>();
                    List<string> lstNames3 = new List<string>();
                    List<RightsU_Entities.User> lstUsers = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                    if (SLA1Users != null)
                    {
                        foreach (var item in SLA1Users)
                        {
                            Name = lstUsers.Where(x => x.Users_Code == Convert.ToInt32(item)).Select(t => t.First_Name).FirstOrDefault();
                            lstNames1.Add(Name);
                        }
                    }
                    if (SLA2Users != null)
                    {
                        foreach (var item in SLA2Users)
                        {
                            Name = lstUsers.Where(x => x.Users_Code == Convert.ToInt32(item)).Select(t => t.First_Name).FirstOrDefault();
                            lstNames2.Add(Name);
                        }
                    }
                    if (SLA3Users != null)
                    {
                        foreach (var item in SLA3Users)
                        {
                            Name = lstUsers.Where(x => x.Users_Code == Convert.ToInt32(item)).Select(t => t.First_Name).FirstOrDefault();
                            lstNames3.Add(Name);
                        }
                    }
                    Users1 = string.Join(",", lstNames1);
                    Users2 = string.Join(",", lstNames2);
                    Users3 = string.Join(",", lstNames3);
                    if (Action == "Edit")
                        obj = list.Where(x => x.TATSLAMatixCodes == MatrixCodes).FirstOrDefault();
                    foreach (var item in lstTATSLAUDT)
                    {
                        string StatusName = new TATSLAStatus_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.TATSLAStatusCode == Status).Select(x => x.TATSLAStatusName).FirstOrDefault();
                        obj.SLA1FromDays = objTATSLAUDT.SLA1FromDays;
                        obj.SLA1ToDays = objTATSLAUDT.SLA1ToDays;
                        obj.SLA1Users = Users1;
                        obj.SLA2FromDays = objTATSLAUDT.SLA2FromDays;
                        obj.SLA2ToDays = objTATSLAUDT.SLA2ToDays;
                        obj.SLA2Users = Users2;
                        obj.SLA3FromDays = objTATSLAUDT.SLA3FromDays;
                        obj.SLA3ToDays = objTATSLAUDT.SLA3ToDays;
                        obj.SLA3Users = Users3;
                        obj.TATSLAStatusName = StatusName;
                        if (Action == "Edit")
                            lstSLAList = list;
                    }
                    if (Action == "Add")
                        lstSLAList.Add(obj);
                }
                else
                {
                    obj = list.Where(x => x.TATSLAMatixCodes == MatrixCodes).FirstOrDefault();
                    list.Remove(obj);
                    lstSLAList = list;
                }
            }
            if (Action == "Delete" && MatrixCodes == "")
            {
                objTATSLAUDT = lstTATSLAUDT.Where(x => x.Action != "Delete" && x.TATSLAMatrix1Code == 0).FirstOrDefault();
                lstTATSLAUDT.Remove(objTATSLAUDT);
                obj = list.Where(x => x.TATSLAMatixCodes == null).FirstOrDefault();
                list.Remove(obj);
                lstSLAList = list;
            }
            Dictionary<string, object> objdic = new Dictionary<string, object>();
            objdic.Add("Message", "Data Saved Successfully");
            return Json(objdic);
        }
        public JsonResult SaveSLA(int TATSLACode = 0, string SLAName = "", int BUCode = 0, int DealTypeCode = 0)
        {
            dynamic resultSet;
            TATSLA_Service objTService = new TATSLA_Service(objLoginEntity.ConnectionStringName);
            if (TATSLACode > 0)
                objT = objTService.GetById(TATSLACode);
            else
                objT = new TATSLA();
            objT.TATSLAName = SLAName;
            objT.BusinessUnitCode = BUCode;
            objT.DealTypeCode = DealTypeCode;
            if (lstTATSLAUDT.Count != 0)
            {
                objTATSLAUDT = lstTATSLAUDT.Last();
                if (objT.TATSLACode == 0)
                {
                    objT.IsActive = "Y";
                    objT.InsertedBy = objLoginUser.Users_Code;
                    objT.InsertedOn = DateTime.Now;
                    objT.EntityState = State.Added;
                    objTService.Save(objT, out resultSet);
                    objTATSLAUDT.TATSLACode = objT.TATSLACode;
                }
                else
                {
                    objT.UpdatedBy = objLoginUser.Users_Code;
                    objT.UpdatedOn = DateTime.Now;
                    objT.EntityState = State.Modified;
                    objTService.Save(objT, out resultSet);
                }
                USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
                objUSP.USPSaveSLAMatrixUDT(lstTATSLAUDT, objLoginUser.Users_Code);
                lstTATSLAUDT.Clear();
            }
            else
            {
                objT.UpdatedBy = objLoginUser.Users_Code;
                objT.UpdatedOn = DateTime.Now;
                objT.EntityState = State.Modified;
                objTService.Save(objT, out resultSet);
            }
            Dictionary<string, object> objdic = new Dictionary<string, object>();
            objdic.Add("Message", "Data Saved Successfully");
            return Json(objdic);
        }
        public JsonResult ActiveDeactiveSLA(int TATSLACode, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully";

            TATSLA_Service objService = new TATSLA_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.TATSLA objSLA = objService.GetById(TATSLACode);
            objSLA.IsActive = doActive;
            objSLA.EntityState = State.Modified;
            dynamic resultSet;
            bool isValid = objService.Save(objSLA, out resultSet);
            if (isValid)
            {
                lstTATSLA.Where(w => w.TATSLACode == TATSLACode).First().IsActive = doActive;
            }
            else
            {
                status = "E";
            }
            if (doActive == "Y")
                if (status == "E")
                    message = objMessageKey.CouldNotActivatedRecord;
                else
                    message = objMessageKey.Recordactivatedsuccessfully;
            else
            {
                if (status == "E")
                    message = objMessageKey.CouldNotDeactivatedRecord;
                else
                    message = objMessageKey.Recorddeactivatedsuccessfully;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
    }
}
