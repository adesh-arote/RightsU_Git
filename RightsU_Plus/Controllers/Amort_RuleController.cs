using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using System.Data;
using System.Data.OleDb;
using System.Data.Entity.Core.Objects;
using System.Web.Script.Services;
using System.Globalization;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI;
using UTOFrameWork.FrameworkClasses;
using System.Net;
using System.Net.Mime;

namespace RightsU_Plus.Controllers
{
    public class Amort_RuleController : BaseController
    {
        //
        // GET: /Amort_Rule/

        public int moduleCode = 180;

        public int PageNo
        {
            get
            {
                if (Session["AmortPageNo"] == null)
                    Session["AmortPageNo"] = 0;
                return (int)Session["AmortPageNo"];
            }
            set { Session["AmortPageNo"] = value; }
        }

        public int PageSize
        {
            get
            {
                if (Session["AmortPageSize"] == null)
                    Session["AmortPageSize"] = 0;
                return (int)Session["AmortPageSize"];
            }
            set { Session["AmortPageSize"] = value; }
        }

        public Amort_Rule_Search objPage_Properties
        {
            get
            {
                if (Session["Amort_Rule_Search_Page_Properties"] == null)
                    Session["Amort_Rule_Search_Page_Properties"] = new Amort_Rule_Search();
                return (Amort_Rule_Search)Session["Amort_Rule_Search_Page_Properties"];
            }
            set { Session["Amort_Rule_Search_Page_Properties"] = value; }
        }

        public RightsU_Entities.Amort_Rule objAmortRule
        {
            get
            {
                if (Session["Session_Amort_Rule"] == null)
                    Session["Session_Amort_Rule"] = new RightsU_Entities.Amort_Rule();
                return (RightsU_Entities.Amort_Rule)Session["Session_Amort_Rule"];
            }
            set { Session["Session_Amort_Rule"] = value; }
        }

        public ActionResult Index()
        {
            string IsMenu1 = "";
            Dictionary<string, string> obj_Dic_Layout = new Dictionary<string, string>();
            if (TempData["QS_LayOut"] != null)
            {
                obj_Dic_Layout = TempData["QS_LayOut"] as Dictionary<string, string>;
                IsMenu1 = obj_Dic_Layout["IsMenu"];
                //TempData.Keep("QS_LayOut");
            }
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(moduleCode), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.AddVisibility = c;
            string IsMenu = "";
            if (Request.QueryString["IsMenu"] != null)
                IsMenu = Request.QueryString["IsMenu"];
            if (IsMenu == "Y")
            {
                objPage_Properties = null;
            }
            ViewBag.Rule_No = objPage_Properties.Rule_No;
            ViewBag.Rule_TypeList = BindRuleType();
            return View();
        }

        public ActionResult List()
        {
            int Page_No = 0, Page_Size = 0;
            Page_No = Convert.ToInt32(TempData["Page_No"]);
            Page_Size = Convert.ToInt32(TempData["Page_Size"]);
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(moduleCode), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.AddVisibility = c;
            if (Page_No > 0)
                PageNo = Page_No;

            if (Page_No != 0)
                ViewBag.Query_String_Page_No = PageNo - 1;
            else
                ViewBag.Query_String_Page_No = 0;
            ViewBag.PageSize = Page_Size;
            ViewBag.Rule_TypeList = BindRuleType();
            ViewBag.Rule_No = objPage_Properties.Rule_No;
            return View();
        }

        private SelectList BindRuleType()
        {
            return new SelectList(new[] 
                {
                    new { Value = "", Text = "Rule Type" },
                    new { Value = "R", Text = "Run"},
	                new { Value = "P", Text = "Period"  },
	                new { Value = "O", Text = "Other" },
	                new { Value = "C", Text = "Premier/Show Premier" }
                   },
           "Value", "Text", objPage_Properties.Rule_Type);
        }

        public PartialViewResult BindGrid(string Rule_No = "", string Rule_Type = "", int PageIndex = 0, string IsShowAll = "", int pageSize = 10)
        {
            ViewBag.PageSize = pageSize;
            PageSize = pageSize;
            PageNo = PageIndex + 1;
            if (IsShowAll != "Y")
            {
                objPage_Properties.Rule_No = Rule_No;
                objPage_Properties.Rule_Type = Rule_Type;
            }
            else
            {
                objPage_Properties.Rule_Type = string.Empty;
                objPage_Properties.Rule_No = string.Empty;
            }

            if (Rule_No == string.Empty && IsShowAll == "N")
                Rule_No = objPage_Properties.Rule_No;
            if (Rule_Type == string.Empty && IsShowAll == "N")
                Rule_Type = objPage_Properties.Rule_Type;

            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            string StrSearch = string.Empty;
            if (Rule_No != string.Empty)
                StrSearch += " And Rule_No like N'%" + Rule_No + "%'";
            if (Rule_Type != string.Empty)
                StrSearch += " And Rule_Type=N'" + Rule_Type + "'";
            string orderByCndition = "Last_Updated_Time DESC ,Inserted_On DESC";
            List<USP_List_Amort_Rule_Result> AmortRuleList = objUSP.USP_List_Amort_Rule(StrSearch, PageNo, orderByCndition, "Y", PageSize, objRecordCount, moduleCode, Convert.ToString(objLoginUser.Users_Code)).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;

            if (PageNo <= 0)
                ViewBag.PageNo = 1;
            else
                ViewBag.PageNo = PageNo;
            ViewBag.Rule_No = Rule_No;
            return PartialView("_List_Amort_Rule", AmortRuleList);
        }

        public PartialViewResult AddAmortDetail(string RuleType = "", string RunType = "", string commandName = "", int Index = 0, Amort_Rule_Details objJson = null, int code = 0)
        {
            if (commandName == "Add")
            {
                ViewBag.AmortDetailCommand = commandName;
                ViewBag.RuleType = RuleType;
                ViewBag.TableIndex = Index;
                objAmortRule.Amort_Rule_Details.Clear();
                Amort_Rule_Details objAmortRuleDetails = new Amort_Rule_Details();
                objAmortRuleDetails.From_Range = 1;
                objAmortRuleDetails.Month = 0;
                objAmortRuleDetails.To_Range = objJson.To_Range;
                objAmortRuleDetails.Per_Cent = 0.00m;
                objAmortRule.Amort_Rule_Details.Add(objAmortRuleDetails);
                if (RuleType == "C")
                {
                    Amort_Rule_Details objARD = new Amort_Rule_Details();
                    objARD.From_Range = 1;
                    objARD.Month = 0;
                    objARD.To_Range = objJson.To_Range;
                    objARD.Per_Cent = 0.00m;
                    objAmortRule.Amort_Rule_Details.Add(objARD);
                }
            }
            else if (commandName == "Edit")
            {
                ViewBag.AmortDetailCommand = "Add";
                ViewBag.RuleType = RuleType;
                ViewBag.TableIndex = Index + 1;
                Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
                objAmortRule = objAmortRuleService.GetById(code);
                ViewBag.nos = Convert.ToString(objAmortRule.Nos);
            }

            return PartialView("_Amort_Details", objAmortRule.Amort_Rule_Details);
        }

        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public PartialViewResult ADDNewRow(string RuleType = "", string RunType = "", string commandName = "", int Index = 0, int deleteIndex = 0, List<Amort_Rule_Details> lstAmortRuleDetails = null)
        {
            if (commandName == "Add")
            {
                ViewBag.AmortDetailCommand = commandName;
                ViewBag.RuleType = RuleType;
                ViewBag.TableIndex = Index + 1;
                int? To_Range = 0;
                int i = 0;
                for (i = 0; i < lstAmortRuleDetails.Count; i++)
                {
                    Amort_Rule_Details objAmortRuleDetail = new Amort_Rule_Details();
                    if (i < objAmortRule.Amort_Rule_Details.Count)
                    {
                        objAmortRuleDetail = objAmortRule.Amort_Rule_Details.ElementAt(i);
                        objAmortRuleDetail.EntityState = State.Modified;
                    }
                    objAmortRuleDetail.From_Range = lstAmortRuleDetails[i].From_Range;
                    To_Range = objAmortRuleDetail.To_Range = lstAmortRuleDetails[i].To_Range;
                    objAmortRuleDetail.Per_Cent = lstAmortRuleDetails[i].Per_Cent;
                    objAmortRuleDetail.Month = lstAmortRuleDetails[i].Month;
                    objAmortRuleDetail.Year = lstAmortRuleDetails[i].Year;
                    objAmortRuleDetail.Period_Type = lstAmortRuleDetails[i].Period_Type;
                }
                if (i >= lstAmortRuleDetails.Count)
                {
                    Amort_Rule_Details obj = new Amort_Rule_Details();
                    obj.From_Range = Convert.ToInt32(To_Range) + 1;
                    obj.Month = 0;
                    obj.Per_Cent = 0.00m;
                    objAmortRule.Amort_Rule_Details.Add(obj);
                }
            }
            else if (commandName == "Cancel")
            {
                ViewBag.AmortDetailCommand = "Add";
                ViewBag.RuleType = RuleType;
                ViewBag.TableIndex = Index - 1;
                Amort_Rule_Details objAmortRuleDetails = new Amort_Rule_Details();
                objAmortRuleDetails = objAmortRule.Amort_Rule_Details.ElementAt(deleteIndex);
                objAmortRuleDetails.EntityState = State.Deleted;
                objAmortRule.Amort_Rule_Details.Remove(objAmortRuleDetails);
            }
            ViewBag.ListCount = objAmortRule.Amort_Rule_Details.Count;
            return PartialView("_Amort_Details", objAmortRule.Amort_Rule_Details.Where(i => i.EntityState != State.Deleted));
        }

        public PartialViewResult PeriodEquallyDistributeCheck(string RuleType = "", string RunType = "", int Index = 0, bool status = true)
        {
            objAmortRule.Amort_Rule_Details.Clear();
            Amort_Rule_Details obj = new Amort_Rule_Details();
            if (status == true)
            {
                obj.From_Range = 1;
                obj.Per_Cent = 100m;
                objAmortRule.Amort_Rule_Details.Add(obj);
            }
            else
            {
                obj.From_Range = 1;
                obj.Per_Cent = 0.00m; ;
                objAmortRule.Amort_Rule_Details.Add(obj);
            }

            ViewBag.AmortDetailCommand = "Add";
            ViewBag.RuleType = RuleType;
            ViewBag.TableIndex = 1;
            return PartialView("_Amort_Details", objAmortRule.Amort_Rule_Details);
        }

        public ActionResult Save(Amort_Rule objAmortRule_MVC, FormCollection objFormCollection)
        {
            string Action = "C";
            string status = "S";
            int AmortCode = Convert.ToInt32(objFormCollection["Amort_Rule_Code"].Trim());
            Amort_Rule objAmortRule = new Amort_Rule();
            Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
            if (AmortCode != 0)
            {
                objAmortRule = objAmortRuleService.GetById(AmortCode);
            }
            string distributeType = objFormCollection["PeriodType_Dist"];
            objAmortRule.Rule_Type = objAmortRule_MVC.Rule_Type = objFormCollection["Ruletype"];
            objAmortRule.Rule_No = objAmortRule_MVC.Rule_No = objFormCollection["txt_RuleNo"];

            objAmortRule.Rule_Desc = objAmortRule_MVC.Rule_Desc = objFormCollection["txt_RuleDescription"];
            if (objAmortRule_MVC.Rule_Type == "R")
            {
                objAmortRule.Distribution_Type = objAmortRule_MVC.Distribution_Type = objFormCollection["RunType_Dist"];
                objAmortRule.Period_For = objAmortRule_MVC.Period_For = Convert.ToString(objFormCollection["RunType_Dist"]);
                objAmortRule.Nos = objAmortRule_MVC.Nos = Convert.ToInt32(objFormCollection["NoRun"]);
                if (objAmortRule.Distribution_Type == "E")
                    objAmortRule_MVC.Amort_Rule_Details.Clear();
            }
            else if (objAmortRule_MVC.Rule_Type == "P")
            {
                objAmortRule.Period_For = objAmortRule_MVC.Period_For = Convert.ToString(objFormCollection["PeriodType_Dist"]);
                objAmortRule.Distribution_Type = objAmortRule_MVC.Distribution_Type = Convert.ToString(objFormCollection["chk_equ"]);
                if (objFormCollection["NoMonth"].Trim() != "")
                    objAmortRule.Nos = objAmortRule_MVC.Nos = Convert.ToInt32(objFormCollection["NoMonth"]);
                else
                    objAmortRule.Nos = null;
            }
            else if (objAmortRule_MVC.Rule_Type == "C")
            {
                objAmortRule.Year_Type = objAmortRule_MVC.Year_Type = objFormCollection["year"];
                objAmortRule.Nos = objAmortRule_MVC.Nos = Convert.ToInt32(objFormCollection["Nos"]);
                objAmortRule.Period_For = objAmortRule_MVC.Period_For = null;
                objAmortRule.Distribution_Type = objAmortRule_MVC.Distribution_Type = null;
            }

            objAmortRule.Amort_Rule_Details.ToList().ForEach(x => x.EntityState = State.Deleted);
            for (int i = 0; i < objAmortRule_MVC.Amort_Rule_Details.Count; i++)
            {
                Amort_Rule_Details objAmortRuleDetail = new Amort_Rule_Details();
                objAmortRuleDetail.EntityState = State.Added;
                bool isAdd = true;

                if (i < objAmortRule.Amort_Rule_Details.Count)
                {
                    objAmortRuleDetail = objAmortRule.Amort_Rule_Details.ElementAt(i);
                    objAmortRuleDetail.EntityState = State.Modified;
                    isAdd = false;
                }
                objAmortRuleDetail.From_Range = objAmortRule_MVC.Amort_Rule_Details.ToList()[i].From_Range;
                objAmortRuleDetail.To_Range = objAmortRule_MVC.Amort_Rule_Details.ToList()[i].To_Range;
                objAmortRuleDetail.Per_Cent = objAmortRule_MVC.Amort_Rule_Details.ToList()[i].Per_Cent;
                objAmortRuleDetail.Month = objAmortRule_MVC.Amort_Rule_Details.ToList()[i].Month;
                objAmortRuleDetail.Year = objAmortRule_MVC.Amort_Rule_Details.ToList()[i].Year;
                objAmortRuleDetail.Period_Type = objAmortRule_MVC.Amort_Rule_Details.ToList()[i].Period_Type;
                if (isAdd)
                    objAmortRule.Amort_Rule_Details.Add(objAmortRuleDetail);
            }
            if (objAmortRule_MVC.Amort_Rule_Code > 0)
            {
                objAmortRule.EntityState = objAmortRule_MVC.EntityState = State.Modified;
                objAmortRule.Last_Updated_Time = objAmortRule_MVC.Last_Updated_Time = DateTime.Now;
                status = "U";
                Action = "U";
            }
            else
            {
                objAmortRule.EntityState = objAmortRule_MVC.EntityState = State.Added;
                objAmortRule.Inserted_On = objAmortRule_MVC.Inserted_On = DateTime.Now;
                objAmortRule.Is_Active = "Y";
                objAmortRule.Inserted_By = objAmortRule_MVC.Inserted_By = objLoginUser.Users_Code;
                objAmortRule.Last_Updated_Time = objAmortRule_MVC.Last_Updated_Time = DateTime.Now;
                Action = "C";
            }
            objAmortRuleService.Save(objAmortRule);
            string msg = string.Empty;
            if (status.Equals("S"))
            {
                msg = "Amort Rule Details saved successfully.";
            }
            else
            {
                msg = "Amort Rule Details updated successfully";
            }

            try
            {
                string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objAmortRule);
                bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForAmortRule), Convert.ToInt32(objAmortRule.Amort_Rule_Code), LogData, Action, objLoginUser.Users_Code);
            }
            catch (Exception ex)
            {

            }

            ViewBag.Message = msg;
            PageNo = (PageNo == 0) ? 1 : PageNo;
            //return msg;

            if (PageNo != 0)
                ViewBag.Query_String_Page_No = PageNo - 1;
            else
                ViewBag.Query_String_Page_No = 0;
            ViewBag.PageSize = PageSize;
            ViewBag.Rule_Type = objPage_Properties.Rule_Type;
            ViewBag.Rule_No = objPage_Properties.Rule_No;
            ViewBag.Rule_TypeList = BindRuleType();
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(moduleCode), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.AddVisibility = c;
            return View("Index");
        }

        public ActionResult CancelData()
        {
            if (TempData["TempId"] != null)
            {
                TempData["TempId"] = null;
            }
            PageNo = (PageNo == 0) ? 1 : PageNo;
            if (PageNo != 0)
                ViewBag.Query_String_Page_No = PageNo - 1;
            else
                ViewBag.Query_String_Page_No = 0;
            ViewBag.PageSize = PageSize;
            ViewBag.Rule_Type = objPage_Properties.Rule_Type;
            ViewBag.Rule_No = objPage_Properties.Rule_No;
            ViewBag.Rule_TypeList = BindRuleType();
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(moduleCode), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.AddVisibility = c;
            return View("Index");
        }

        public ActionResult View(int id)
        {
            Amort_Rule objAR = new Amort_Rule();
            Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
            objAR = objAmortRuleService.GetById(id);
            return View("View", objAR);
        }

        public ActionResult ShowAmort()
        {
            int id = 0;
            if (TempData["TempId"] != null)
            {
                Dictionary<string, string> obj_Dictionary_Title = new Dictionary<string, string>();
                obj_Dictionary_Title = TempData["TempId"] as Dictionary<string, string>;

                id = Convert.ToInt32(obj_Dictionary_Title["id"]);
                TempData.Keep("TempId");
            }
            Amort_Rule objAR = new Amort_Rule();
            Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
            objAR = objAmortRuleService.GetById(id);
            return View("View", objAR);
        }

        public ActionResult AddAmortRule(string commandName)
        {
            if (commandName == "Add")
            {
                ViewBag.AmortCode = 0;
                if (AmongstRightsPeriod())
                    ViewBag.PeriodForDisable = "N";
                else
                    ViewBag.PeriodForDisable = "Y";
                return View("Create", new Amort_Rule());
            }
            return View();
        }

        public ActionResult Edit()
        {
            int id = 0;
            if (TempData["TempId"] != null)
            {
                Dictionary<string, string> obj_Dictionary_Title = new Dictionary<string, string>();
                obj_Dictionary_Title = TempData["TempId"] as Dictionary<string, string>;

                id = Convert.ToInt32(obj_Dictionary_Title["id"]);
                TempData.Keep("TempId");
            }
            Amort_Rule objAR = new Amort_Rule();
            Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
            ViewBag.CommandAction = "Edit";
            objAmortRule = objAR = objAmortRuleService.GetById(id);
            ViewBag.RuleType = objAmortRule.Rule_Type;
            ViewBag.AmortDetailCommand = "Add";
            ViewBag.AmortCode = objAR.Amort_Rule_Code;
            if(objAR.Period_For!="A")
            if (AmongstRightsPeriod())
                ViewBag.PeriodForDisable="N";
            else
                ViewBag.PeriodForDisable = "Y";
            return View("Create", objAR);
        }

        public Boolean AmongstRightsPeriod()
        {
            Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
            List<Amort_Rule> lstAmortRule = new List<Amort_Rule>();
            lstAmortRule = objAmortRuleService.SearchFor(p => p.Period_For=="A").ToList();
            if (lstAmortRule.Count > 0)
                return false;
            return true;

        }

        public void EditRecord(int id)
        {
            Dictionary<string, string> obj = new Dictionary<string, string>();
            obj.Add("id", Convert.ToString(id));
            TempData["TempId"] = obj;
        }

        public JsonResult DelactivateData(int id)
        {
            string Action = "A";
            string message = "";
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            Amort_Rule objAR = new Amort_Rule();
            Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
            objAmortRule = objAR = objAmortRuleService.GetById(id);
            if (objAmortRule.Is_Active == "Y")
            {
                objAmortRule.Is_Active = "N";
                message = "Deactivated Successfully";
                Action = "DA";
            }
            else
            {
                objAmortRule.Is_Active = "Y";
                message = "Activated Successfully";
                Action = "A";
            }
            objAmortRule.EntityState =State.Modified;
            objAmortRuleService.Save(objAmortRule);
            objJson.Add("Message", message);
            objJson.Add("Error", "");

            try
            {
                string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objAmortRule);
                bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForAmortRule), Convert.ToInt32(objAmortRule.Amort_Rule_Code), LogData, Action, objLoginUser.Users_Code);
            }
            catch (Exception ex)
            {

            }

            return Json(objJson);
        }

        public JsonResult DuplicateData(int id = 0, string ruleno = "", int noOfMonth = 0, string periodType="")
        {
            string message = "";
            string errortype = "";
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            Amort_Rule objAR = new Amort_Rule();
            Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
            List<Amort_Rule> lstAmortRule = new List<Amort_Rule>();
                if (id > 0)
                {
                    lstAmortRule = objAmortRuleService.SearchFor(p => p.Rule_No == ruleno.Trim() && p.Amort_Rule_Code != id).ToList();
                }
                else
                {
                    lstAmortRule = objAmortRuleService.SearchFor(p => p.Rule_No == ruleno.Trim()).ToList();
                }
                if (lstAmortRule.Count != 0)
                {
                    message = "Rule No. is already Exist";
                    errortype = "RuleNo";
                }
                else
                {
                    lstAmortRule = objAmortRuleService.SearchFor(p => p.Amort_Rule_Code != id && p.Distribution_Type == periodType && 
                        (p.Rule_Type == "R" || p.Rule_Type == "P") && p.Nos == noOfMonth).ToList();
                    if (lstAmortRule.Count > 0)
                        message = "No.of Runs already exists for this Equally Distribute";
                    errortype = "NoOfRuns";
                }
            objJson.Add("Message", message);
            objJson.Add("errortype", errortype);
            objJson.Add("Error", "");
            return Json(objJson);
        }

        public void ExportToExcel(string hdnRuleNo = "", string hdnRuleType = "")
        {
            string StrSearch = string.Empty;
            if (hdnRuleNo != string.Empty)
                StrSearch += " And Rule_No like '%" + hdnRuleNo + "%'";
            if (hdnRuleType != string.Empty)
                StrSearch += " And Rule_Type='" + hdnRuleType + "'";
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            var AmortRuleList = objUSP.USP_List_Amort_Rule(StrSearch, PageNo, "Amort_Rule_Code", "N", PageSize, objRecordCount, moduleCode, Convert.ToString(objLoginUser.Users_Code)).ToList();
            System.Web.UI.WebControls.GridView gridvw = new System.Web.UI.WebControls.GridView();
            gridvw.AutoGenerateColumns = false;
            gridvw.Columns.Add(new BoundField { HeaderText = "Rule No", DataField = "Rule_No" });
            gridvw.Columns.Add(new BoundField { HeaderText = "Rule Description", DataField = "Rule_Desc" });
            gridvw.Columns.Add(new BoundField { HeaderText = "Rule Type", DataField = "Rule_Type" });
            gridvw.Columns.Add(new BoundField { HeaderText = "Period For", DataField = "Period_For" });
            gridvw.Columns.Add(new BoundField { HeaderText = "Year Type", DataField = "Year_Type" });
            gridvw.DataSource = AmortRuleList.ToList(); 
            gridvw.DataBind();
            Response.ClearContent();
            Response.AddHeader("content-disposition", "attachment;filename=AmortRuleList.xlsx");
            Response.ContentType = "application/excel";
            StringWriter swr = new StringWriter();
            HtmlTextWriter tw = new HtmlTextWriter(swr);
            gridvw.RenderControl(tw);
            if (AmortRuleList.Count == 0)
                Response.Write("No Record Found");
            else
            {
                Response.Write("<b>Amort Rule List</b><br/>");
                Response.Write("<b>Total Records: " + AmortRuleList.Count.ToString() + "</b>");
                Response.Write(swr.ToString());
            }
            Response.End();
        }
    }

    public partial class Amort_Rule_Search
    {
        public Amort_Rule_Search() { }

        #region ========== PAGE PROPERTIES ==========

        public string Rule_No { get; set; }
        public string Rule_Type { get; set; }

        #endregion
    }

}
