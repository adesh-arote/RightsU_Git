using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;
using System.Linq;

namespace RightsU_Plus.Controllers
{
    public class Syn_SupplementaryController : BaseController
    {
        string _fieldList = "";
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.Syn_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.Syn_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA];
            }
            //get { return new Deal_Schema(); }
            set
            {
                Session[RightsU_Session.Syn_DEAL_SCHEMA] = value;
            }
        }

        public Syn_Deal_Supplementary objSyn_Deal_Supplementary
        {
            get
            {
                if (Session["Syn_Supplementary"] == null)
                    Session["Syn_Supplementary"] = new Syn_Deal_Supplementary();
                return (Syn_Deal_Supplementary)Session["Syn_Supplementary"];
            }
            set { Session["Syn_Supplementary"] = value; }
        }

        //public int Syn_Deal_Code
        //{
        //    get
        //    {
        //        if (Session["Syn_Deal_Code"] == null)
        //            Session["Syn_Deal_Code"] = "0";
        //        return Convert.ToInt32(Session["Syn_Deal_Code"]);
        //    }
        //    set { Session["Syn_Deal_Code"] = value; }
        //}
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
        // GET: Acq_Supplementary
        public PartialViewResult Index()
        {
            objDeal_Schema.Page_From = GlobalParams.Page_From_Supplementary;

            Session["SupplementaryDetail"] = null;
            objSyn_Deal_Supplementary = null;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;

            DateTime perpDate = new DateTime(9999, 12, 31);
            var lstSynRights = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName)
                        .SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code)
                        .Select(i => new { RightsStartDate = i.Actual_Right_Start_Date, RightsEndDate = (i.Actual_Right_End_Date == null ? perpDate : i.Actual_Right_End_Date) }).ToList();
            //.Select(x => x.Title_Objection_Code).ToList();
            if (lstSynRights != null && lstSynRights.Count > 0)
            {
                var startDate = lstSynRights.Select(x => x.RightsStartDate.Value).Min();
                var endDate = lstSynRights.Select(x => x.RightsEndDate.Value).Max();
                //var endDate = lstSynRights.Select(x => ((x.RightsEndDate.Value == null || x.RightsEndDate.Value == DateTime.MinValue) ? perpDate : x.RightsEndDate.Value)).Max();

                ViewBag.SynLP = Convert.ToDateTime(startDate).ToString("dd-MMM-yyyy") + " To " + (Convert.ToDateTime(endDate) == perpDate ? " Perpetuity" : Convert.ToDateTime(endDate).ToString("dd-MMM-yyyy"));
            }
            ViewBag.RecordCount = 50;
            return PartialView("~/Views/Syn_Deal/_Syn_Supplementary.cshtml");
        }

        public JsonResult BindSupplementary()
        {
            List<USP_Syn_Deal_Supplementary_List_Result> objSupplementary_List = objUspService.USP_Syn_Deal_Supplementary_List(objDeal_Schema.Deal_Code, "").ToList();
            int Count = objUspService.USP_Syn_Deal_Supplementary_List(objDeal_Schema.Deal_Code, "").Count();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            string strList = "";
            strList = "<Table class=\"table table-bordered table-hover\">";
            strList = strList + "<TR><TH>Title Name</TH><TH>IP Details</TH><TH>Miscellaneous</TH><TH>Excluded Rights</TH><TH>Business Statement</TH><TH>Action</TH></TR>";


            foreach (USP_Syn_Deal_Supplementary_List_Result sl in objSupplementary_List)
            {
                if (objDeal_Schema.Mode != "V" && objDeal_Schema.Mode != "APRV")
                {
                    strList = strList + "<TR><TD>" + sl.title_name + "</TD><TD><div class=\"SuppRemarks\"> " + sl.IPDetails + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.Miscellaneous + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.ExcludedRights + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.BusinessStatement + "</div></TD><TD style=\"text-align: center;\"><a title=\"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"Edit(" + Convert.ToString(sl.Supplementary_code) + "," + Convert.ToString(sl.title_code) + ",'');\" ></a><a title=\"Edit\" class=\"glyphicon glyphicon-eye-open\" onclick=\"Edit(" + Convert.ToString(sl.Supplementary_code) + "," + Convert.ToString(sl.title_code) + ",'VIEW');\" ></a><a title=\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"Delete(" + Convert.ToString(sl.Supplementary_code) + ',' + Convert.ToString(sl.title_code) + ");\"></a></TD></Tr>";
                }
                else
                {
                    strList = strList + "<TR><TD>" + sl.title_name + "</TD><TD><div class=\"SuppRemarks\"> " + sl.IPDetails + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.Miscellaneous + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.ExcludedRights + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.BusinessStatement + "</div></TD><TD style=\"text-align: center;\"><a title=\"Edit\" class=\"glyphicon glyphicon-eye-open\" onclick=\"Edit(" + Convert.ToString(sl.Supplementary_code) + "," + Convert.ToString(sl.title_code) + ",'VIEW');\" ></a></TD></Tr>";
                }
            }
            strList = strList + "</Table>";
            obj.Add("List", strList);
            obj.Add("TCount", Count);
            return Json(obj);
        }
        public PartialViewResult AddEditSupp()
        {
            return PartialView("~/Views/Syn_Deal/_Syn_Supplementary_Add.cshtml");
        }

        public JsonResult BindAllPreReq_Async()
        {
            int supplementary_Code = 0, title_code = 0;
            string Operation = "";
            Dictionary<string, string> obj_Dictionary_RList = (Dictionary<string, string>)TempData["QueryString_Rights"];
            supplementary_Code = Convert.ToInt32(obj_Dictionary_RList["Supplementary_code"]);
            title_code = Convert.ToInt32(obj_Dictionary_RList["title_code"]);

            Supplementary_Tab_Service objService = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Supplementary_Tab> objSupplementary_Tab = objService.SearchFor(x => x.Module_Code.Value == GlobalParams.ModuleCodeForSynDeal).OrderBy(a => a.Order_No).ToList();

            Supplementary_Data_Service objDataService = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Supplementary_Data> objSupplementary_Data = objDataService.SearchFor(a => true).ToList();

            //Syn_Deal_Supplementary_Detail_Service objTransactionDetailService = new Syn_Deal_Supplementary_Detail_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Supplementary_Service objTransactionService = new Syn_Deal_Supplementary_Service(objLoginEntity.ConnectionStringName);

            Syn_Deal_Supplementary objSupplementary = new Syn_Deal_Supplementary();
            objSupplementary = objTransactionService.GetById(supplementary_Code);
            if (objSupplementary == null)
            {
                objSupplementary = new Syn_Deal_Supplementary();
            }

            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                title_code = objDeal_Schema.Title_List.Where(x => x.Title_Code == objSupplementary.Title_code && x.Episode_From == objSupplementary.Episode_From && x.Episode_To == objSupplementary.Episode_To).Select(s => s.Acq_Deal_Movie_Code).FirstOrDefault();
            }

            Operation = obj_Dictionary_RList["MODE"];

            List<USP_Get_Title_For_Syn_Supplementary_Result> titleList = objUspService.USP_Get_Title_For_Syn_Supplementary(objDeal_Schema.Deal_Code, title_code).ToList();

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Title_List", new SelectList(titleList, "Title_Code", "Title_Name"));

            obj.Add("SelectedTitle", title_code);

            string strTabs = "<ul class=\"nav nav-tabs nav-tab pull-left\">";
            string tabTable = "";

            //int TabCode = (int)objSupplementary_Tab.Select(a => a.Supplementary_Tab_Code).FirstOrDefault();
            int dropcount = 0;
            var ViewOperation = "";
            if (obj_Dictionary_RList["View"] != "")
            {
                ViewOperation = obj_Dictionary_RList["View"];
            }
            else
            {
                ViewOperation = "";
            }

            string tabNames = "", strtableHeader = "";
            string[] arrStr;
            int i = 1;
            int j = 1;
            foreach (Supplementary_Tab ST in objSupplementary_Tab)
            {
                tabNames = tabNames + ST.Short_Name + ",";
                if (i == 1)
                {
                    strTabs = strTabs + "<li id = \"liCal" + ST.Short_Name + "\" class = \"active\" onclick = \"ChangeTab('" + ST.Short_Name + "');\" >";
                    obj.Add("TabName", ST.Short_Name);
                }
                else
                {
                    strTabs = strTabs + "<li id = \"liCal" + ST.Short_Name + "\" class = \"\" onclick = \"ChangeTab('" + ST.Short_Name + "');\" >";
                }
                strTabs = strTabs + "<a data - toggle = \"tab\" href = \"#tab" + ST.Short_Name + "\" role = \"tab\" > " + ST.Supplementary_Tab_Description + " </ a >";
                strTabs = strTabs + "</li>";
                if (i != 1)
                {
                    tabTable = tabTable + "<div class=\"tab - pane active\" style=\"display:none;\" id=\"tblMain" + ST.Short_Name + "\">";
                }
                else
                {
                    tabTable = tabTable + "<div class=\"tab - pane active\" id=\"tblMain" + ST.Short_Name + "\">";
                }

                strtableHeader = GetTableHeader(ST.Supplementary_Tab_Code, ST.Short_Name, objSupplementary_Data, ST.EditWindowType, ViewOperation);
                List<USP_Syn_Deal_Supplementary_Details_Data_Result> rowList = objUspService.USP_Syn_Deal_Supplementary_Details_Data(ST.Supplementary_Tab_Code, supplementary_Code, ViewOperation).ToList(); //string.Join(",", titleList.Select(a => a.Title_Code).ToList())

                arrStr = strtableHeader.Split('~');

                tabTable = tabTable + "<div class=\"scale_table_block\">";
                tabTable = tabTable + "<table class=\"table table-bordered table-hover\"  id=\"tbl" + ST.Short_Name + "\">" + arrStr[0] + rowList.Select(a => a.Tab).FirstOrDefault().ToString() + "</table>";

                tabTable = tabTable + "<input type=\"hidden\" name=\"hdn" + ST.Short_Name + "\" id=\"hdn" + ST.Short_Name + "\" Value='" + arrStr[1] + "'/>";
                tabTable = tabTable + "<input type=\"hidden\" name=\"hdnwt" + ST.Short_Name + "\" id=\"hdnwt" + ST.Short_Name + "\" Value='" + ST.EditWindowType + "'/>";

                tabTable = tabTable + "</div></div>";
                i++;
            }

            tabNames = tabNames.Substring(0, tabNames.Length - 1);

            strTabs = strTabs + "</ul>";

            //List<Syn_Deal_Supplementary_Detail> lstDetailObj = new List<Syn_Deal_Supplementary_Detail>();

            //if (Operation == "E")
            //{
            //    lstDetailObj = objSupplementary.Syn_Deal_Supplementary_Detail.ToList();//(List<Syn_Deal_Supplementary_Detail>)objTransactionDetailService.SearchFor(a => true).ToList();
            //    //lstDetailObj = lstDetailObj.Where(a => a.Syn_Deal_Supplementary_Code == supplementary_Code).ToList();
            //}
            objSyn_Deal_Supplementary = objSupplementary;
            Session["Supplementary_Service"] = objTransactionService;
            //Session["SupplementaryDetail"] = lstDetailObj;

            obj.Add("tabNames", tabNames);
            obj.Add("Tabs", strTabs);
            obj.Add("Divs", tabTable);
            obj.Add("dropdown", dropcount);
            obj.Add("FieldList", _fieldList.TrimEnd(','));
            obj.Add("Remarks", objSupplementary.Remarks);
            obj.Add("ViewOperation", ViewOperation);
            return Json(obj);
        }

        public string GetTableHeader(int tabCode, string Short_Name, List<Supplementary_Data> ListSupplementary_Data, string WindowType, string ViewOperation)
        {
            string strPrevHeader = "";
            string strtableHeader = "<tr>";
            string strAddRow = "<tr id = \"add" + Short_Name + "\" style=\"display:none;\">";

            List<USP_Get_Supplementary_Config_Result> columnList = objUspService.USP_Get_Supplementary_Config(tabCode).ToList();
            int i = 1, j = 1, k = 1, l = 1, m = 1;
            double width = 0, viewWidth = 5;
            if (ViewOperation != "VIEW")
                width = 100 / columnList.Count();
            else
            {
                viewWidth = columnList.Count > 5 ? 5 : 10;
                width = (100 - viewWidth) / columnList.Count();
            }

            width = Math.Round(width);
            foreach (USP_Get_Supplementary_Config_Result ST in columnList)
            {
                if (strPrevHeader != "" && strPrevHeader == ST.Supplementary_Name)
                {
                    strtableHeader = strtableHeader.Replace("UTOsplTag", " colspan=2 ");
                }
                else
                {
                    strtableHeader = strtableHeader.Replace("UTOsplTag", "");
                    strtableHeader = strtableHeader + "<th style=\"width:" + width + "%\" UTOsplTag> " + ST.Supplementary_Name + "</th>";
                    strPrevHeader = ST.Supplementary_Name;
                }
                if (WindowType == "inLine")
                {
                    strAddRow = strAddRow + "<td style=\"width:" + width + "%\">";
                    if (ST.Control_Type == "TXTDDL")
                    {
                        strAddRow = strAddRow + getDDL(ListSupplementary_Data, Short_Name, i, ST.Whr_Criteria, "", "A", ST.Is_Multiselect, ST.Supplementary_Config_Code);
                        i++;
                    }
                    else if (ST.Control_Type == "TXTAREA")
                    {
                        strAddRow = strAddRow + getTXTArea("", Short_Name, j, "A", ST.Supplementary_Config_Code, ST.Max_Length.ToString());
                        j++;
                    }
                    else if (ST.Control_Type == "DATE")
                    {
                        strAddRow = strAddRow + getDATE("", Short_Name, k, "A", ST.Supplementary_Config_Code);
                        k++;
                    }
                    else if (ST.Control_Type == "INT")
                    {
                        strAddRow = strAddRow + getNumber("", Short_Name, l, "A", ST.Supplementary_Config_Code);
                        l++;
                    }
                    else if (ST.Control_Type == "DBL")
                    {
                        strAddRow = strAddRow + getDBL("", Short_Name, l, "A", ST.Supplementary_Config_Code);
                        l++;
                    }
                    else if (ST.Control_Type == "CHK")
                    {
                        strAddRow = strAddRow + getCheckbox("", Short_Name, m, "A", ST.Supplementary_Config_Code);
                        m++;
                    }
                    //else if (ST.Control_Type == "TXTDDL")
                    //{
                    //    strAddRow = strAddRow + getTXTDDL();
                    //}
                    strAddRow = strAddRow + "</td>";
                }
                else
                {
                    if (ST.Control_Type == "TXTDDL")
                    {
                        _fieldList = _fieldList + Short_Name + "ddSupp" + i.ToString() + "~" + ST.Supplementary_Config_Code.ToString() + ",";
                        i++;
                    }
                    else if (ST.Control_Type == "TXTAREA")
                    {
                        _fieldList = _fieldList + Short_Name + "txtAreaSupp" + j.ToString() + "~" + ST.Supplementary_Config_Code.ToString() + ",";
                        j++;
                    }
                    else if (ST.Control_Type == "DATE")
                    {
                        _fieldList = _fieldList + Short_Name + "dtSupp" + k.ToString() + "~" + ST.Supplementary_Config_Code.ToString().ToString() + ",";
                        k++;
                    }
                    else if (ST.Control_Type == "INT")
                    {
                        _fieldList = _fieldList + Short_Name + "numSupp" + l.ToString() + "~" + ST.Supplementary_Config_Code.ToString() + ",";
                        l++;
                    }
                    else if (ST.Control_Type == "DBL")
                    {
                        _fieldList = _fieldList + Short_Name + "numSupp" + l.ToString() + "~" + ST.Supplementary_Config_Code.ToString() + ",";
                        l++;
                    }
                    else if (ST.Control_Type == "CHK")
                    {
                        _fieldList = _fieldList + Short_Name + "chkSupp" + m.ToString() + "~" + ST.Supplementary_Config_Code.ToString() + ",";
                        m++;
                    }

                }
            }
            strtableHeader = strtableHeader.Replace("UTOsplTag", "");
            if (ViewOperation != "VIEW")
            {
                strtableHeader = strtableHeader + "<th style=\"width:" + viewWidth + "%\"> Action </th>";
            }
            strtableHeader = strtableHeader + "</tr>";

            if (WindowType == "inLine")
            {
                strAddRow = strAddRow + "<td style=\"text-align: center;\"><a class=\"glyphicon glyphicon-ok\" onclick = \"SaveSupp(this,0);\" style=\"padding: 3px;\"></a><a class=\"glyphicon glyphicon-remove\" onclick = \"hideaddsupp();\"></a></td>";
                strAddRow = strAddRow + "</tr>";
                strtableHeader = strtableHeader + strAddRow;
            }
            else
            {
                i = columnList.Count(a => a.Control_Type == "TXTDDL") + 1;
            }

            return strtableHeader + "~" + (i - 1).ToString();
        }
        public string getDDL(List<Supplementary_Data> ListSupplementary_Data, string Short_Name, int i, string whrCond, string SelectedValues, string Operation, string multiple, int ConfigCode)
        {
            string[] SelectedList = SelectedValues.Split(',');
            string strDDL;
            if (multiple == "N")
            {
                strDDL = "<select style=\"width:300px !important\" placeholder=\"Please Select\" id=\"" + Operation + Short_Name + "ddSupp" + i.ToString() + "\" name=\"" + Operation + Short_Name + "ddSupp" + i.ToString() + "\">";
                strDDL = strDDL + "<option value=\"''\" disabled selected style=\"display: none !important;\">Please Select</option>";
            }
            else
            {
                multiple = "multiple";
                strDDL = "<select style=\"width:300px !important\" placeholder=\"Please Select\" id=\"" + Operation + Short_Name + "ddSupp" + i.ToString() + "\" name=\"" + Operation + Short_Name + "ddSupp" + i.ToString() + "\" " + multiple + ">";
            }
            //strDDL = strDDL + "<option value=\"\" selected disabled hidden> Please Select</option>";
            foreach (Supplementary_Data LSD in ListSupplementary_Data.Where(a => a.Supplementary_Type == whrCond))
            {
                if (SelectedList.Contains(LSD.Supplementary_Data_Code.ToString()))
                {
                    strDDL = strDDL + "<option value=" + LSD.Supplementary_Data_Code + " selected>" + LSD.Data_Description + "</option>";
                }
                else
                {
                    strDDL = strDDL + "<option value=" + LSD.Supplementary_Data_Code + ">" + LSD.Data_Description + "</option>";
                }
            }
            strDDL = strDDL + "</select>";

            _fieldList = _fieldList + Short_Name + "ddSupp" + i.ToString() + "~" + ConfigCode.ToString() + ",";

            return strDDL;
        }
        public string getTXT()
        {
            string strTXT = "";
            return strTXT;
        }
        public string getTXTArea(string User_Value, string Short_Name, int i, string Operation, int ConfigCode, string MaxLength)
        {
            string strTXTArea = "<textarea cols=\"1\" maxlength=\"" + MaxLength + "\" id=\"" + Operation + Short_Name + "txtAreaSupp" + i.ToString() + "\" name=\"" + Operation + Short_Name + "txtAreaSupp" + i.ToString() + "\" rows=\"1\" style=\"min-height: 31px !important;\">" + User_Value + "</textarea>";
            _fieldList = _fieldList + Short_Name + "txtAreaSupp" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return strTXTArea;
        }
        public string getDATE(string User_Value, string Short_Name, int i, string Operation, int ConfigCode)
        {
            if (User_Value != null && User_Value != "") { User_Value = (Convert.ToDateTime(User_Value)).ToString("yyyy-MM-dd"); }
            else { User_Value = ""; }
            string getDATE = "<input type =\"date\"  data-val=\"true\" id =\"" + Operation + Short_Name + "dtSupp" + i.ToString() + "\" name=\"" + Operation + Short_Name + "dtSupp" + i.ToString() + "\" style=\"height: 31px; \" value=\"" + User_Value + "\">";
            _fieldList = _fieldList + Short_Name + "dtSupp" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getDATE;
        }
        public string getNumber(string User_Value, string Short_Name, int i, string Operation, int ConfigCode)
        {
            string getNumber = "<input type=\"number\" min=\"0\" onkeypress=\"return !(event.charCode == 46)\" value=\"" + User_Value + "\" id=\"" + Operation + Short_Name + "numSupp" + i.ToString() + "\" name=\"" + Operation + Short_Name + "numSupp" + i.ToString() + "\">";
            _fieldList = _fieldList + Short_Name + "numSupp" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getNumber;
        }
        public string getDBL(string User_Value, string Short_Name, int i, string Operation, int ConfigCode)
        {
            string getNumber = "<input type=\"number\" value=\"0.00\" placeholder=\"0.00\" step=\"0.01\" min=\"0\" value=\"" + User_Value + "\" id=\"" + Operation + Short_Name + "numSupp" + i.ToString() + "\" name=\"" + Operation + Short_Name + "numSupp" + i.ToString() + "\">";
            _fieldList = _fieldList + Short_Name + "numSupp" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getNumber;
        }
        public string getCheckbox(string User_Value, string Short_Name, int i, string Operation, int ConfigCode)
        {
            string strChecked = "";

            if (User_Value == "" || User_Value == "NO")
            {
                strChecked = "";
            }
            else
                strChecked = " checked ";

            if (User_Value == "") User_Value = "YES";

            string getCheckbox = "<input type=\"checkbox\" value=\"" + User_Value + "\" id=\"" + Operation + Short_Name + "chkSupp" + i.ToString() + "\" name=\"" + Operation + Short_Name + "chkSupp" + i.ToString() + "\" style=\"margin-left: 4px;\"" + strChecked + ">";
            _fieldList = _fieldList + Short_Name + "chkSupp" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getCheckbox;
        }

        //public string getTXTDDL()
        //{
        //    return "";
        //}

        public JsonResult supplementaryEdit(int supplementary_Code, int rowno, int num, string Short_Name, string View)
        {
            Dictionary<string, object> Jsonobj = new Dictionary<string, object>();

            List<USP_Get_Syn_Deal_Supplementary_Edit_Result> EditRowList = new List<USP_Get_Syn_Deal_Supplementary_Edit_Result>();
            List<Syn_Deal_Supplementary_Detail> lstDetailObj = new List<Syn_Deal_Supplementary_Detail>();

            Supplementary_Tab_Service objTabService = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);
            int TabCode = (int)objTabService.SearchFor(a => a.Short_Name == Short_Name).Select(b => b.Supplementary_Tab_Code).FirstOrDefault();

            Supplementary_Config_Service objConfigService = new Supplementary_Config_Service(objLoginEntity.ConnectionStringName);

            //if (supplementary_Code != 0)
            //{
            //    EditRowList = objUspService.USP_Get_Syn_Deal_Supplementary_Edit_Result(supplementary_Code, rowno, Short_Name).ToList();
            //}
            //else
            //{
            lstDetailObj = (List<Syn_Deal_Supplementary_Detail>)((Syn_Deal_Supplementary)objSyn_Deal_Supplementary).Syn_Deal_Supplementary_Detail.ToList();

            lstDetailObj = lstDetailObj.Where(a => a.Row_Num == rowno && a.Supplementary_Tab_Code == TabCode).ToList();

            foreach (Syn_Deal_Supplementary_Detail obj in lstDetailObj)
            {
                USP_Get_Syn_Deal_Supplementary_Edit_Result objEditRow = new USP_Get_Syn_Deal_Supplementary_Edit_Result();
                objEditRow.Supplementary_Data_Code = obj.Supplementary_Data_Code;
                objEditRow.User_Value = obj.User_Value;
                objEditRow.Row_Num = obj.Row_Num;
                objEditRow.Supplementary_Tab_Code = obj.Supplementary_Tab_Code;
                objEditRow.Supplementary_Config_Code = obj.Supplementary_Config_Code;

                Supplementary_Config objSC = objConfigService.SearchFor(a => a.Supplementary_Config_Code == obj.Supplementary_Config_Code).FirstOrDefault();

                objEditRow.Supplementary_Code = objSC.Supplementary.Supplementary_Code;
                objEditRow.Control_Type = objSC.Control_Type;
                objEditRow.Is_Mandatory = objSC.Is_Mandatory;
                objEditRow.Is_Multiselect = objSC.Is_Multiselect;
                objEditRow.Max_Length = objSC.Max_Length;
                objEditRow.Control_Field_Order = objSC.Control_Field_Order;
                objEditRow.View_Name = objSC.View_Name;
                objEditRow.Whr_Criteria = objSC.Whr_Criteria;

                EditRowList.Add(objEditRow);
            }
            //}
            Supplementary_Data_Service objDataService = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Supplementary_Data> objSupplementary_Data = objDataService.SearchFor(a => true).ToList();

            string strAddRow = "<tr id=\"Edit" + Short_Name + "\" name=" + Short_Name + rowno.ToString() + ">";
            foreach (USP_Get_Syn_Deal_Supplementary_Edit_Result ED in EditRowList)
            {
                strAddRow = strAddRow + "<td>";
                int i = 1, j = 1, k = 1, l = 1, m = 1;
                if (ED.Control_Type == "TXTDDL")
                {
                    strAddRow = strAddRow + getDDL(objSupplementary_Data, Short_Name, i, ED.Whr_Criteria, ED.Supplementary_Data_Code, "E", ED.Is_Multiselect, Convert.ToInt32(ED.Supplementary_Config_Code));
                    i++;
                }
                else if (ED.Control_Type == "TXTAREA")
                {
                    strAddRow = strAddRow + getTXTArea(ED.User_Value, Short_Name, j, "E", Convert.ToInt32(ED.Supplementary_Config_Code), ED.Max_Length.ToString());
                    j++;
                }
                else if (ED.Control_Type == "DATE")
                {
                    strAddRow = strAddRow + getDATE("", Short_Name, k, "E", Convert.ToInt32(ED.Supplementary_Config_Code));
                    k++;
                }
                else if (ED.Control_Type == "INT")
                {
                    strAddRow = strAddRow + getNumber(ED.User_Value, Short_Name, l, "E", Convert.ToInt32(ED.Supplementary_Config_Code));
                    l++;
                }
                else if (ED.Control_Type == "DBL")
                {
                    strAddRow = strAddRow + getDBL(ED.User_Value, Short_Name, l, "E", Convert.ToInt32(ED.Supplementary_Config_Code));
                    l++;
                }
                else if (ED.Control_Type == "CHK")
                {
                    strAddRow = strAddRow + getCheckbox(ED.User_Value, Short_Name, m, "E", Convert.ToInt32(ED.Supplementary_Config_Code));
                    m++;
                }
                strAddRow = strAddRow + "</td>";
            }
            if (View != "View")
            {
                strAddRow = strAddRow + "<td style=\"text-align: center;\"><a class=\"glyphicon glyphicon-ok\" id=\"A" + Short_Name + rowno.ToString() + "\" onclick = \"SaveSupp(this,'" + rowno.ToString() + "');\" style=\"padding: 3px;\"></a><a class=\"glyphicon glyphicon-remove\" onclick = \"closeEdit(" + num + ");\"></a></td>";
            }
            strAddRow = strAddRow + "</tr>";

            Jsonobj.Add("EditRow", strAddRow);

            return Json(Jsonobj);
        }
        public JsonResult supplementaryDelete(int supplementary_Code, int rowno, int TabCode)
        {
            List<Syn_Deal_Supplementary_Detail> lstDetailObj = new List<Syn_Deal_Supplementary_Detail>();

            if (objSyn_Deal_Supplementary != null)
            {
                lstDetailObj = (List<Syn_Deal_Supplementary_Detail>)((Syn_Deal_Supplementary)objSyn_Deal_Supplementary).Syn_Deal_Supplementary_Detail.ToList();
            }

            List<Syn_Deal_Supplementary_Detail> objDelete = new List<Syn_Deal_Supplementary_Detail>();

            objDelete = lstDetailObj.Where(a => a.Row_Num == rowno && a.Supplementary_Tab_Code == TabCode).ToList();

            foreach (Syn_Deal_Supplementary_Detail objDel in objDelete)
            {
                objDel.EntityState = State.Deleted;
            }

            ((Syn_Deal_Supplementary)objSyn_Deal_Supplementary).Syn_Deal_Supplementary_Detail = lstDetailObj;

            Dictionary<string, object> obj = new Dictionary<string, object>();

            obj.Add("ErrorCode", "100");
            obj.Add("ErrorMsg", "Deal Deleted successfully");

            return Json(obj);
        }

        public string DeleteSupplementary(int supplementary_Code)
        {
            objUspService.USP_Delete_Syn_Supplementary(supplementary_Code);
            var Mode = "A";
            BindSupplementary();
            string success = "201";
            return success;
        }
        public string supplementaryDialogue(int supplementary_Code, int rowno, string Short_Name, int num)
        {
            string Operation = "A";
            if (rowno > 0) Operation = "E";

            Supplementary_Tab_Service objService = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Supplementary_Tab objSupplementary_Tab = objService.SearchFor(a => a.Short_Name == Short_Name).ToList().FirstOrDefault();

            List<USP_Get_Syn_Deal_Supplementary_Edit_Result> EditRowList = new List<USP_Get_Syn_Deal_Supplementary_Edit_Result>();
            List<Syn_Deal_Supplementary_Detail> lstDetailObj = new List<Syn_Deal_Supplementary_Detail>();

            if (Operation == "E")
            {
                int TabCode = (int)objSupplementary_Tab.Supplementary_Tab_Code;

                Supplementary_Config_Service objConfigService = new Supplementary_Config_Service(objLoginEntity.ConnectionStringName);

                lstDetailObj = (List<Syn_Deal_Supplementary_Detail>)((Syn_Deal_Supplementary)objSyn_Deal_Supplementary).Syn_Deal_Supplementary_Detail.ToList();

                lstDetailObj = lstDetailObj.Where(a => a.Row_Num == rowno && a.Supplementary_Tab_Code == TabCode).ToList();

                foreach (Syn_Deal_Supplementary_Detail obj in lstDetailObj)
                {
                    USP_Get_Syn_Deal_Supplementary_Edit_Result objEditRow = new USP_Get_Syn_Deal_Supplementary_Edit_Result();
                    objEditRow.Supplementary_Data_Code = obj.Supplementary_Data_Code;
                    objEditRow.User_Value = obj.User_Value;
                    objEditRow.Row_Num = obj.Row_Num;
                    objEditRow.Supplementary_Tab_Code = obj.Supplementary_Tab_Code;
                    objEditRow.Supplementary_Config_Code = obj.Supplementary_Config_Code;

                    Supplementary_Config objSC = objConfigService.SearchFor(a => a.Supplementary_Config_Code == obj.Supplementary_Config_Code).FirstOrDefault();

                    objEditRow.Supplementary_Code = objSC.Supplementary.Supplementary_Code;
                    objEditRow.Control_Type = objSC.Control_Type;
                    objEditRow.Is_Mandatory = objSC.Is_Mandatory;
                    objEditRow.Is_Multiselect = objSC.Is_Multiselect;
                    objEditRow.Max_Length = objSC.Max_Length;
                    objEditRow.Control_Field_Order = objSC.Control_Field_Order;
                    objEditRow.View_Name = objSC.View_Name;
                    objEditRow.Whr_Criteria = objSC.Whr_Criteria;

                    EditRowList.Add(objEditRow);
                }
            }

            List<USP_Get_Supplementary_Config_Result> columnList = objUspService.USP_Get_Supplementary_Config(objSupplementary_Tab.Supplementary_Tab_Code).ToList();

            Supplementary_Data_Service objDataService = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Supplementary_Data> objSupplementary_Data = objDataService.SearchFor(a => true).ToList();
            string strAddRow = "";

            strAddRow = "<Table class=\"table table-bordered table-hover\" style=\"padding:10px;\">";

            string prevRowTitle = "";
            int i = 1, j = 1, k = 1, l = 1, m = 1;

            foreach (USP_Get_Supplementary_Config_Result CM in columnList)
            {
                string utospltag = "";
                string user_Value = "";
                string supplementary_Data_Code = "";

                USP_Get_Syn_Deal_Supplementary_Edit_Result obj = new USP_Get_Syn_Deal_Supplementary_Edit_Result();

                if (Operation == "E")
                {
                    obj = EditRowList.Where(a => a.Supplementary_Config_Code == CM.Supplementary_Config_Code).FirstOrDefault();
                    user_Value = obj.User_Value;
                    supplementary_Data_Code = obj.Supplementary_Data_Code;
                }

                if (prevRowTitle != "" && prevRowTitle == CM.Supplementary_Name)
                {
                    if (CM.Control_Type == "TXTDDL")
                    {
                        utospltag = getDDL(objSupplementary_Data, Short_Name, i, CM.Whr_Criteria, supplementary_Data_Code, Operation, CM.Is_Multiselect, CM.Supplementary_Config_Code);
                        i++;
                    }
                    else if (CM.Control_Type == "TXTAREA")
                    {
                        utospltag = getTXTArea(user_Value, Short_Name, j, Operation, CM.Supplementary_Config_Code, CM.Max_Length.ToString());
                        j++;
                    }
                    else if (CM.Control_Type == "DATE")
                    {
                        utospltag = getDATE(user_Value, Short_Name, k, Operation, CM.Supplementary_Config_Code);
                        k++;
                    }
                    else if (CM.Control_Type == "INT")
                    {
                        utospltag = getNumber(user_Value, Short_Name, l, Operation, CM.Supplementary_Config_Code);
                        l++;
                    }
                    else if (CM.Control_Type == "DBL")
                    {
                        utospltag = getDBL(user_Value, Short_Name, l, Operation, CM.Supplementary_Config_Code);
                        l++;
                    }
                    else if (CM.Control_Type == "CHK")
                    {
                        utospltag = getCheckbox(user_Value, Short_Name, m, Operation, CM.Supplementary_Config_Code);
                        m++;
                    }

                    strAddRow = strAddRow.Replace("utospltag", utospltag);
                }
                else
                {
                    strAddRow = strAddRow.Replace("utospltag", "");
                    strAddRow = strAddRow + "<tr>";
                    strAddRow = strAddRow + "<td style=\"width: 40%;\">";
                    strAddRow = strAddRow + CM.Supplementary_Name;
                    strAddRow = strAddRow + "</td>";
                    strAddRow = strAddRow + "<td>";
                    prevRowTitle = CM.Supplementary_Name;

                    if (CM.Control_Type == "TXTDDL")
                    {
                        strAddRow = strAddRow + getDDL(objSupplementary_Data, Short_Name, i, CM.Whr_Criteria, supplementary_Data_Code, Operation, CM.Is_Multiselect, CM.Supplementary_Config_Code);
                        i++;
                    }
                    else if (CM.Control_Type == "TXTAREA")
                    {
                        strAddRow = strAddRow + getTXTArea(user_Value, Short_Name, j, Operation, CM.Supplementary_Config_Code, CM.Max_Length.ToString());
                        j++;
                    }
                    else if (CM.Control_Type == "DATE")
                    {
                        strAddRow = strAddRow + getDATE(user_Value, Short_Name, k, Operation, CM.Supplementary_Config_Code);
                        k++;
                    }
                    else if (CM.Control_Type == "INT")
                    {
                        strAddRow = strAddRow + getNumber(user_Value, Short_Name, l, Operation, CM.Supplementary_Config_Code);
                        l++;
                    }
                    else if (CM.Control_Type == "DBL")
                    {
                        strAddRow = strAddRow + getDBL(user_Value, Short_Name, l, Operation, CM.Supplementary_Config_Code);
                        l++;
                    }
                    else if (CM.Control_Type == "CHK")
                    {
                        strAddRow = strAddRow + getCheckbox(user_Value, Short_Name, m, Operation, CM.Supplementary_Config_Code);
                        m++;
                    }
                    //else if (CM.Control_Type == "TXTDDL")
                    //{
                    //    strAddRow = strAddRow + getTXTDDL();
                    //}
                    strAddRow = strAddRow + " utospltag </td></tr>";
                }
            }
            strAddRow = strAddRow.Replace("utospltag", "");
            strAddRow = strAddRow + "<TR><td style=\"text-align: center;\" colspan=2><input type=\"submit\" id=\"btnSaveDeal\" class=\"btn btn-primary\" value=\"Save\" style=\"margin-right: 4px;\" onclick=\"return SaveSupp(this,'" + rowno.ToString() + "'); \"><input type=\"submit\" id=\"btnSaveDeal\" class=\"btn btn-primary\" value=\"Cancel\" onclick=\"closeEdit(" + num + "); \"></td></TR>";

            strAddRow = strAddRow + "</Table>";
            return strAddRow;

        }
        public JsonResult SuppButtonEvents(int Supplementary_code, int title_code, string View, string MODE, int? RCode, int? PCode, int? TCode, int? Episode_From, int? Episode_To, string IsHB, string Is_Syn_Syn_Mapp = "")
        {
            Dictionary<string, string> obj_Dictionary_RList = new Dictionary<string, string>();
            obj_Dictionary_RList.Add("MODE", MODE);
            obj_Dictionary_RList.Add("RCode", RCode == null ? "0" : RCode.ToString());
            obj_Dictionary_RList.Add("PCode", PCode == null ? "0" : PCode.ToString());
            obj_Dictionary_RList.Add("TCode", TCode == null ? "0" : TCode.ToString());
            obj_Dictionary_RList.Add("Episode_From", Episode_From == null ? "0" : Episode_From.ToString());
            obj_Dictionary_RList.Add("Episode_To", Episode_To == null ? "0" : Episode_To.ToString());
            obj_Dictionary_RList.Add("IsHB", IsHB);
            obj_Dictionary_RList.Add("Is_Syn_Syn_Mapp", Is_Syn_Syn_Mapp);
            obj_Dictionary_RList.Add("Supplementary_code", Supplementary_code.ToString());
            obj_Dictionary_RList.Add("title_code", title_code.ToString());
            if (View != null)
            {
                obj_Dictionary_RList.Add("View", View.ToString());
            }
            else
            {
                obj_Dictionary_RList.Add("View", "");
            }
            TempData["QueryString_Rights"] = obj_Dictionary_RList;
            string tabName = GlobalParams.Page_From_Supplementary_AddEdit;
            //if (MODE == GlobalParams.DEAL_MODE_VIEW || MODE == GlobalParams.DEAL_MODE_APPROVE || MODE == GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
            //    tabName = GlobalParams.Page_From_Rights_Detail_View;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("TabName", tabName);
            return Json(obj);
        }
        public bool supplementaryDupliValidation(string Value_list, string Short_Name, int Row_No, string Operation)
        {
            List<Syn_Deal_Supplementary_Detail> lstDetailObj = new List<Syn_Deal_Supplementary_Detail>();
            Syn_Deal_Supplementary objSupplementary = new Syn_Deal_Supplementary();

            Dictionary<string, object> obj = new Dictionary<string, object>();

            objSupplementary = (Syn_Deal_Supplementary)objSyn_Deal_Supplementary;
            lstDetailObj = (List<Syn_Deal_Supplementary_Detail>)objSupplementary.Syn_Deal_Supplementary_Detail.ToList();

            Supplementary_Config_Service objConfigService = new Supplementary_Config_Service(objLoginEntity.ConnectionStringName);

            Supplementary_Tab_Service objTabService = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);
            int TabCode = (int)objTabService.SearchFor(a => a.Short_Name == Short_Name).Select(b => b.Supplementary_Tab_Code).FirstOrDefault();
            int config_Code = 0;
            String ErrorCode = "";
            Value_list = Value_list.Substring(0, Value_list.Length - 2);
            string[] columnValueList = Value_list.Split(new string[] { "¿ï" }, StringSplitOptions.None);
            int[] dtextval;

            foreach (string str in columnValueList)
            {
                //string[] vals = str.Split('~');
                string[] vals = str.Split(new string[] { "ï¿" }, StringSplitOptions.None);
                config_Code = Convert.ToInt32(vals[1]);
                string tempVal = "";

                string ControlType = objConfigService.SearchFor(a => a.Supplementary_Config_Code == config_Code).Select(b => b.Control_Type).FirstOrDefault();
                if (ControlType == "TXTDDL")
                {
                    if (vals[0] != "")
                    {
                        dtextval = Array.ConvertAll(vals[0].Split('-'), x => int.Parse(x));

                        List<string> selectedDrp = lstDetailObj.Where(S => S.Supplementary_Tab_Code == TabCode &&
                                                                           S.Supplementary_Config_Code == config_Code &&
                                                                           S.Row_Num.Value != Row_No &&
                                                                           S.EntityState != State.Deleted).Select(K => K.Supplementary_Data_Code).ToList();

                        tempVal = string.Join(",", selectedDrp);

                        int i = 1;
                        //if (Operation != "E")
                        //{
                        foreach (int dt in dtextval)
                        {
                            if (tempVal.IndexOf(dt.ToString(), 0) > -1)
                            {
                                return true;

                            }
                            i++;
                        }
                        //}
                        //else
                        //{
                        //    List<string> selectedDrponRoIdx = lstDetailObj.Where(S => S.Supplementary_Tab_Code == TabCode && S.Supplementary_Config_Code == config_Code && S.Row_Num == Row_No).Select(K => K.Supplementary_Data_Code).ToList();

                        //}
                    }
                }
            }
            //obj.Add("ErrorCode", ErrorCode);
            //obj.Add("ErrorMsg", "Duplicate Value Not allowed");
            return false;
        }
        public string supplementarySave(string Value_list, string Short_Name, string Operation, int Row_No, string rwIndex)
        {
            //check for duplicate
            if (supplementaryDupliValidation(Value_list, Short_Name, Row_No, Operation))
            {
                return "Duplicate";
            }

            List<Syn_Deal_Supplementary_Detail> lstDetailObj = new List<Syn_Deal_Supplementary_Detail>();
            Syn_Deal_Supplementary objSupplementary = new Syn_Deal_Supplementary();

            objSupplementary = (Syn_Deal_Supplementary)objSyn_Deal_Supplementary;
            lstDetailObj = (List<Syn_Deal_Supplementary_Detail>)objSupplementary.Syn_Deal_Supplementary_Detail.ToList();

            //"1~1,sai~2,"
            Supplementary_Tab_Service objTabService = new Supplementary_Tab_Service(objLoginEntity.ConnectionStringName);
            int TabCode = (int)objTabService.SearchFor(a => a.Short_Name == Short_Name).Select(b => b.Supplementary_Tab_Code).FirstOrDefault();

            Supplementary_Data_Service objDataService = new Supplementary_Data_Service(objLoginEntity.ConnectionStringName);
            Supplementary_Config_Service objConfigService = new Supplementary_Config_Service(objLoginEntity.ConnectionStringName);

            int rowNum = 0;
            if (lstDetailObj.Count(b => b.Supplementary_Tab_Code == TabCode) != 0 && Operation == "A")
            {
                rowNum = (int)lstDetailObj.Where(b => b.Supplementary_Tab_Code == TabCode).Max(a => a.Row_Num).Value;
            }
            else
            {
                rowNum = Row_No;
                //    lstDetailObj.RemoveAll(a => a.Row_Num == rowNum && a.Supplementary_Tab_Code == TabCode);
            }
            Value_list = Value_list.Substring(0, Value_list.Length - 2);
            string[] columnValueList = Value_list.Split(new string[] { "¿ï" }, StringSplitOptions.None);

            //string[] columnValueList = Value_list.TrimEnd(',').Split(',');
            string Output = "";
            if (rowNum == 0)
            {
                Output = "<tr id=\"" + Short_Name + (1).ToString() + "\"> ";
            }
            else
            {
                Output = "<tr id=\"" + Short_Name + (rowNum).ToString() + "\"> ";
            }
            foreach (string str in columnValueList)
            {
                Syn_Deal_Supplementary_Detail obj = new Syn_Deal_Supplementary_Detail();
                //string[] vals = str.Split('~');
                string[] vals = str.Split(new string[] { "ï¿" }, StringSplitOptions.None);
                int config_Code = Convert.ToInt32(vals[1]);
                string ControlType = objConfigService.SearchFor(a => a.Supplementary_Config_Code == config_Code).Select(b => b.Control_Type).FirstOrDefault();

                if (Operation == "E")
                    obj = lstDetailObj.Where(a => a.Supplementary_Config_Code == config_Code && a.Supplementary_Tab_Code == TabCode && a.Row_Num == rowNum).FirstOrDefault();

                if (ControlType == "TXTDDL")
                {
                    if (vals[0] != "")
                    {
                        int[] dtextval = Array.ConvertAll(vals[0].Split('-'), x => int.Parse(x));
                        string t = string.Join(",", objDataService.SearchFor(a => dtextval.Contains(a.Supplementary_Data_Code)).Select(b => b.Data_Description).ToList());
                        Output = Output + "<td>" + t + "</td>";
                    }
                    else
                    {
                        Output = Output + "<td>&nbsp;</td>";
                    }
                    obj.Supplementary_Data_Code = vals[0].Replace('-', ',');
                }
                if (ControlType == "TXTAREA" || ControlType == "INT" || ControlType == "DBL" || ControlType == "DATE" || ControlType == "CHK")
                {
                    Output = Output + "<td><div class=\"SuppRemarks\">" + vals[0] + "</div></td>";
                    obj.User_Value = vals[0];
                }

                if (Operation == "A")
                {
                    obj.Row_Num = rowNum + 1;
                    obj.Supplementary_Config_Code = Convert.ToInt32(vals[1]);
                    obj.Supplementary_Tab_Code = TabCode;
                    obj.EntityState = State.Added;
                    lstDetailObj.Add(obj);
                }
                else if (Operation == "E" && obj.Syn_Deal_Supplementary_Detail_Code > 0)
                {
                    objSupplementary.EntityState = State.Modified;
                    obj.EntityState = State.Modified;
                }
            }
            if (Operation == "A")
            {
                Output = Output + "<td style=\"text-align:center;\"><a title = \"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"SuppEdit(this,'0','" + Convert.ToString(rowNum + 1) + "','" + Convert.ToString(rowNum + 1) + "','" + TabCode + "');\"></a><a title =\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"SuppDelete(this,'0','" + Convert.ToString(rowNum + 1) + "','" + Convert.ToString(rowNum + 1) + "','" + TabCode + "','" + Short_Name + "' );\"></a></td>";
            }
            else if (Operation == "E")
            {
                Output = Output + "<td style=\"text-align:center;\"><a title = \"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"SuppEdit(this,'0','" + Convert.ToString(rowNum) + "','" + Convert.ToString(rowNum) + "','" + TabCode + "');\"></a><a title =\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"SuppDelete(this,'0','" + Convert.ToString(rowNum) + "','" + Convert.ToString(rowNum) + "','" + TabCode + "','" + Short_Name + "');\"></a></td>";
            }
            Output = Output + "</tr>";

            objSupplementary.Syn_Deal_Supplementary_Detail = lstDetailObj;
            objSyn_Deal_Supplementary = objSupplementary;
            return Output;
        }
        public JsonResult supplementarySaveDB(string Title_List, string Remarks)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            Syn_Deal_Supplementary objSupplementaryTemp = (Syn_Deal_Supplementary)objSyn_Deal_Supplementary;
            List<Syn_Deal_Supplementary_Detail> lstDetailObj = (List<Syn_Deal_Supplementary_Detail>)objSupplementaryTemp.Syn_Deal_Supplementary_Detail.ToList();
            Syn_Deal_Supplementary_Service objTransactionService = new Syn_Deal_Supplementary_Service(objLoginEntity.ConnectionStringName);

            if (objSyn_Deal_Supplementary == null)
            {
                obj.Add("ErrorCode", "440");
                obj.Add("ErrorMsg", "Session Expired, login again");

                return Json(obj);
            }
            if (Title_List == "")
            {
                obj.Add("ErrorCode", "500");
                obj.Add("ErrorMsg", "Title not selected");

                return Json(obj);
            }
            else
            {
                int[] titlecodes = Array.ConvertAll(Title_List.Split(','), x => int.Parse(x));

                //lstDetailObj = (List<Syn_Deal_Supplementary_Detail>)((Syn_Deal_Supplementary)objSyn_Deal_Supplementary).Syn_Deal_Supplementary_Detail.ToList();

                for (int t = 0; t < titlecodes.Length; t++)
                {
                    dynamic resultSet;
                    int titleCode = 0;
                    int episodeFrom = 1;
                    int episodeTo = 1;

                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    {
                        Title_List objTL = null;
                        objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == titlecodes[t]).FirstOrDefault();
                        episodeFrom = objTL.Episode_From;
                        episodeTo = objTL.Episode_To;
                        titleCode = objTL.Title_Code;
                    }
                    else
                        titleCode = titlecodes[t];

                    //List<Syn_Deal_Supplementary_Detail> lstDetailObjTemp = new List<Syn_Deal_Supplementary_Detail>();

                    //objSupplementaryTemp = (Syn_Deal_Supplementary)objTransactionService.SearchFor(a => a.Title_code == presId && a.Syn_Deal_Code == objDeal_Schema.Deal_Code).FirstOrDefault();
                    Syn_Deal_Supplementary objSupplementary = null;

                    if (titleCode == objSupplementaryTemp.Title_code && episodeFrom == objSupplementaryTemp.Episode_From && episodeTo == objSupplementaryTemp.Episode_To)
                    {
                        objSupplementary = objSupplementaryTemp;
                        objTransactionService = (Syn_Deal_Supplementary_Service)Session["Supplementary_Service"];
                    }
                    else
                    {
                        objTransactionService = new Syn_Deal_Supplementary_Service(objLoginEntity.ConnectionStringName);
                    }

                    if (objSupplementary == null)
                    {
                        objSupplementary = new Syn_Deal_Supplementary();

                        objSupplementary.Title_code = titleCode;
                        objSupplementary.Episode_From = episodeFrom;
                        objSupplementary.Episode_To = episodeTo;
                        objSupplementary.Remarks = Remarks;
                        objSupplementary.Syn_Deal_Code = objDeal_Schema.Deal_Code;
                        objSupplementary.EntityState = State.Added;

                        foreach (Syn_Deal_Supplementary_Detail objD in lstDetailObj)
                        {
                            Syn_Deal_Supplementary_Detail objTemp = new Syn_Deal_Supplementary_Detail();

                            objTemp.Row_Num = objD.Row_Num;
                            objTemp.Supplementary_Config_Code = objD.Supplementary_Config_Code;
                            objTemp.Supplementary_Data_Code = objD.Supplementary_Data_Code;
                            objTemp.Supplementary_Tab_Code = objD.Supplementary_Tab_Code;
                            objTemp.User_Value = objD.User_Value;
                            objTemp.EntityState = objD.EntityState;
                            if (objTemp.EntityState != State.Deleted)
                            {
                                objSupplementary.Syn_Deal_Supplementary_Detail.Add(objTemp);
                            }
                        }
                    }
                    else
                    {
                        objSupplementary.Remarks = Remarks;
                        objSupplementary.EntityState = State.Modified;
                    }
                    objTransactionService.Save(objSupplementary, out resultSet);

                    //lstDetailObjTemp = null;
                    objTransactionService = null;
                    objSupplementary = null;
                }

                obj.Add("ErrorCode", "100");
                obj.Add("ErrorMsg", "Deal Saved successfully");

                return Json(obj);
            }
        }

        public JsonResult supplementaryValidation()
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("detailsCnt", objSyn_Deal_Supplementary.Syn_Deal_Supplementary_Detail.Count);
            return Json(obj);
        }
    }
}