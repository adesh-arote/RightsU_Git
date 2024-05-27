using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;
using System.Linq;
using System.Data.Entity.Core.Objects;

namespace RightsU_Plus.Controllers
{
    public class Syn_DigitalController : BaseController
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

        public Syn_Deal_Digital objSyn_Deal_Digital
        {
            get
            {
                if (Session["Syn_Digital"] == null)
                    Session["Syn_Digital"] = new Syn_Deal_Digital();
                return (Syn_Deal_Digital)Session["Syn_Digital"];
            }
            set { Session["Syn_Digital"] = value; }
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
            objDeal_Schema.Page_From = GlobalParams.Page_From_Digital;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;

            objSyn_Deal_Digital = null;
            Session["DigitalDetail"] = null;

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

            //ViewBag.RecordCount = 50;
            if (TempData["page_size"] != null)
            {
                ViewBag.page_size = TempData["page_size"];
            }
            if (TempData["page_index"] != null)
            {
                ViewBag.page_index = TempData["page_index"];
            }
            return PartialView("~/Views/Syn_Deal/_Syn_Digital.cshtml");
        }

        public JsonResult BindDigital(int page_index, int page_size)
        {
            int PageNo = page_index <= 0 ? 1 : page_index + 1;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", 0);

            List<USP_Syn_Deal_Digital_List_Result> objDigital_List = objUspService.USP_Syn_Deal_Digital_List(objDeal_Schema.Deal_Code, "", page_index, page_size, objRecordCount).ToList();
            //int Count = objUspService.USP_Syn_Deal_Supplementary_List(objDeal_Schema.Deal_Code, "").Count();

            List<string> Digital_Tab_Heders = objDigital_List.Select(x => x.Digital_Tab_Description).Distinct().ToList();
            List<string> Digital_Tab_Title = objDigital_List.Select(x => x.title_name).Distinct().ToList();

            ViewBag.RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.PageNo = PageNo;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            string strList = "";
            strList = "<Table class=\"table table-bordered table-hover\">";
            strList = strList + "<TR><TH>Title Name</TH>";
            //strList = strList + "<TR><TH>Title Name</TH><TH>IP Details</TH><TH>Miscellaneous</TH><TH>Excluded Rights</TH><TH>Business Statement</TH><TH>Action</TH></TR>";
            foreach (string sh in Digital_Tab_Heders)
            {

                strList = strList + "<TH>" + sh + "</TH>";
                //strList = strList + "<TR><TD>" + sl.title_name + "</TD><TD>" + sl.SocialMedia + "</TD><TD>" + sl.Commitments + "</TD><TD>" + sl.OpeningClosingCredits + "</TD><TD>" + sl.EssentialClauses + "</TD><TD><a title=\"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"Edit(" + Convert.ToString(sl.Supplementary_code) + "," + Convert.ToString(sl.title_code) + ",'');\" ></a><a title=\"Edit\" class=\"glyphicon glyphicon-eye-open\" onclick=\"Edit(" + Convert.ToString(sl.Supplementary_code) + "," + Convert.ToString(sl.title_code) + ",'VIEW');\" ></a><a title=\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"Delete(" + Convert.ToString(sl.Supplementary_code) + ',' + Convert.ToString(sl.title_code) + ");\"></a></TD></Tr>";
            }
            strList = strList + "<TH>Action</TH></TR>";

            foreach (string slttl in Digital_Tab_Title)
            {

                List<USP_Syn_Deal_Digital_List_Result> objDigital_ListtitleData = objDigital_List.Where(x => x.title_name == slttl).ToList();
                strList = strList + "<TR><TD>" + slttl + "</TD>";
                string Title_Code = ""; string Syn_Deal_Digital_Code = "";
                foreach (USP_Syn_Deal_Digital_List_Result ds in objDigital_ListtitleData)
                {
                    Title_Code = ds.Title_Code.ToString();
                    Syn_Deal_Digital_Code = ds.Syn_Deal_Digital_Code.ToString();
                    strList = strList + "<TD>" + ds.Remarks + "</TD>";

                }
                if (objDeal_Schema.Mode != "V" && objDeal_Schema.Mode != "APRV")
                {
                    strList = strList + "<TD><a title=\"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"Edit(" + Convert.ToString(Syn_Deal_Digital_Code) + "," + Convert.ToString(Title_Code) + ",'');\" ></a><a title=\"VIEW\" class=\"glyphicon glyphicon-eye-open\" onclick=\"Edit(" + Convert.ToString(Syn_Deal_Digital_Code) + "," + Convert.ToString(Title_Code) + ",'VIEW');\" ></a><a title=\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"ValidateDelete(" + Convert.ToString(Syn_Deal_Digital_Code) + ',' + Convert.ToString(Title_Code) + ");\"></a></TD></Tr>";
                }
                else
                {
                    strList = strList + "<TD><a title=\"VIEW\" class=\"glyphicon glyphicon-eye-open\" onclick=\"Edit(" + Convert.ToString(Syn_Deal_Digital_Code) + "," + Convert.ToString(Title_Code) + ",'VIEW');\" ></a></TD></Tr>";
                }
            }
            //foreach (USP_Syn_Deal_Supplementary_List_Result sl in objSupplementary_List)
            //{
            //    if (objDeal_Schema.Mode != "V" && objDeal_Schema.Mode != "APRV")
            //    {
            //        strList = strList + "<TR><TD>" + sl.title_name + "</TD><TD><div class=\"SuppRemarks\"> " + sl.IPDetails + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.Miscellaneous + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.ExcludedRights + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.BusinessStatement + "</div></TD><TD style=\"text-align: center;\"><a title=\"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"Edit(" + Convert.ToString(sl.Supplementary_code) + "," + Convert.ToString(sl.title_code) + ",'');\" ></a><a title=\"Edit\" class=\"glyphicon glyphicon-eye-open\" onclick=\"Edit(" + Convert.ToString(sl.Supplementary_code) + "," + Convert.ToString(sl.title_code) + ",'VIEW');\" ></a><a title=\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"Delete(" + Convert.ToString(sl.Supplementary_code) + ',' + Convert.ToString(sl.title_code) + ");\"></a></TD></Tr>";
            //    }
            //    else
            //    {
            //        strList = strList + "<TR><TD>" + sl.title_name + "</TD><TD><div class=\"SuppRemarks\"> " + sl.IPDetails + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.Miscellaneous + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.ExcludedRights + "</div></TD><TD><div class=\"SuppRemarks\"> " + sl.BusinessStatement + "</div></TD><TD style=\"text-align: center;\"><a title=\"Edit\" class=\"glyphicon glyphicon-eye-open\" onclick=\"Edit(" + Convert.ToString(sl.Supplementary_code) + "," + Convert.ToString(sl.title_code) + ",'VIEW');\" ></a></TD></Tr>";
            //    }
            //}
            strList = strList + "</Table>";
            obj.Add("List", strList);
            obj.Add("TCount", objRecordCount.Value);
            return Json(obj);
        }
        public PartialViewResult AddEditDigi()
        {
            return PartialView("~/Views/Syn_Deal/_Syn_Digital_Add.cshtml");
        }

        public JsonResult BindAllPreReq_Async()
        {
            int digital_Code = 0, title_code = 0, page_size = 0, page_index = 0;
            string Operation = "";
            Dictionary<string, string> obj_Dictionary_RList = (Dictionary<string, string>)TempData["QueryString_Rights"];
            digital_Code = Convert.ToInt32(obj_Dictionary_RList["Digital_code"]);
            title_code = Convert.ToInt32(obj_Dictionary_RList["title_code"]);
            page_size = Convert.ToInt32(obj_Dictionary_RList["page_size"]);
            page_index = Convert.ToInt32(obj_Dictionary_RList["page_index"]);

            Digital_Tab_Service objService = new Digital_Tab_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Digital_Tab> objDigital_Tab = objService.SearchFor(x => x.Module_Code.Value == GlobalParams.ModuleCodeForSynDeal).Where(x => x.Is_Show == "Y" || x.Is_Show == "N").OrderBy(a => a.Order_No).ToList();

            //Digital_Data_Service objDataService = new Digital_Data_Service(objLoginEntity.ConnectionStringName);
            //List<RightsU_Entities.Digital_Data> objDigital_Data = objDataService.SearchFor(a => true).ToList();
            Music_Title_Service objMusicTitleService = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Music_Title> objMusic_Title = new List<Music_Title>();
            if (title_code > 0)
            {
                objMusic_Title = objMusicTitleService.SearchFor(a => a.Title_Code == title_code).ToList();
            }

            //Syn_Deal_Supplementary_Detail_Service objTransactionDetailService = new Syn_Deal_Supplementary_Detail_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Digital_Service objTransactionService = new Syn_Deal_Digital_Service(objLoginEntity.ConnectionStringName);

            Syn_Deal_Digital objDigital = new Syn_Deal_Digital();
            objDigital = objTransactionService.GetById(digital_Code);
            if (objDigital == null)
            {
                objDigital = new Syn_Deal_Digital();
            }

            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                title_code = objDeal_Schema.Title_List.Where(x => x.Title_Code == objDigital.Title_code && x.Episode_From == objDigital.Episode_From && x.Episode_To == objDigital.Episode_To).Select(s => s.Acq_Deal_Movie_Code).FirstOrDefault();
            }

            Operation = obj_Dictionary_RList["MODE"];

            List<USP_Get_Title_For_Syn_Digital_Result> titleList = objUspService.USP_Get_Title_For_Syn_Digital(objDeal_Schema.Deal_Code, title_code).ToList();

            Dictionary<string, object> obj = new Dictionary<string, object>();

            string strSyn_Deal_Digital_Title_Multiselect = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Syn_Deal_Digital_Title_Multiselect").Select(x => x.Parameter_Value).SingleOrDefault();
            obj.Add("Syn_Deal_Digital_Title_Multiselect", strSyn_Deal_Digital_Title_Multiselect);

            if (strSyn_Deal_Digital_Title_Multiselect == "N")
            {
                titleList.Insert(0, new USP_Get_Title_For_Syn_Digital_Result { Title_Code = 0, Title_Name = "Select Title" });
            }
            
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
            foreach (Digital_Tab ST in objDigital_Tab)
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
                strTabs = strTabs + "<a data - toggle = \"tab\" href = \"#tab" + ST.Short_Name + "\" role = \"tab\" > " + ST.Digital_Tab_Description + " </ a >";
                strTabs = strTabs + "</li>";
                if (i != 1)
                {
                    tabTable = tabTable + "<div class=\"tab - pane active\" style=\"display:none;\" id=\"tblMain" + ST.Short_Name + "\">";
                }
                else
                {
                    tabTable = tabTable + "<div class=\"tab - pane active\" id=\"tblMain" + ST.Short_Name + "\">";
                }

                strtableHeader = GetTableHeader(ST.Digital_Tab_Code, ST.Short_Name, objMusic_Title, ST.EditWindowType, ViewOperation);
                List<USP_Syn_Deal_Digital_Details_Data_Result> rowList = objUspService.USP_Syn_Deal_Digital_Details_Data(ST.Digital_Tab_Code, digital_Code, ViewOperation).ToList(); //string.Join(",", titleList.Select(a => a.Title_Code).ToList())

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
            objSyn_Deal_Digital = objDigital;
            Session["Digital_Service"] = objTransactionService;
            //Session["SupplementaryDetail"] = lstDetailObj;

            obj.Add("tabNames", tabNames);
            obj.Add("Tabs", strTabs);
            obj.Add("Divs", tabTable);
            obj.Add("dropdown", dropcount);
            obj.Add("FieldList", _fieldList.TrimEnd(','));
            obj.Add("Remarks", objDigital.Remarks);
            obj.Add("ViewOperation", ViewOperation);
            obj.Add("page_size", page_size);
            obj.Add("page_index", page_index);
            TempData["page_size"] = page_size;
            TempData["page_index"] = page_index;
            return Json(obj);
        }

        public string GetTableHeader(int tabCode, string Short_Name, List<Music_Title> ListMusic_Title, string WindowType, string ViewOperation)
        {
            string strPrevHeader = "";
            string strtableHeader = "<tr>";
            string strAddRow = "<tr id = \"add" + Short_Name + "\" style=\"display:none;\">";

            List<USP_Get_Digital_Config_Result> columnList = objUspService.USP_Get_Digital_Config(tabCode).ToList();
            int i = 1, j = 1, k = 1, l = 1, m = 1, n = 1;
            double width = 0, viewWidth = 5;
            if (ViewOperation != "VIEW")
                width = 100 / columnList.Count() - 10;
            else
            {
                viewWidth = columnList.Count > 5 ? 5 : 10;
                width = (100 - viewWidth) / columnList.Count();
            }

            width = Math.Round(width);
            foreach (USP_Get_Digital_Config_Result ST in columnList)
            {
                if (strPrevHeader != "" && strPrevHeader == ST.Digital_Name)
                {
                    strtableHeader = strtableHeader.Replace("UTOsplTag", " colspan=2 ");
                }
                else
                {
                    strtableHeader = strtableHeader.Replace("UTOsplTag", "");
                    strtableHeader = strtableHeader + "<th style=\"width:" + width + "%\" UTOsplTag> " + ST.Digital_Name + "</th>";
                    strPrevHeader = ST.Digital_Name;
                }
                if (WindowType == "inLine")
                {
                    strAddRow = strAddRow + "<td style=\"width:" + width + "%\">";
                    if (ST.Control_Type == "TXTDDL" && ST.Is_Multiselect == "Y")
                    {
                        strAddRow = strAddRow + getDDL(ListMusic_Title, Short_Name, i, ST.Whr_Criteria, "", "A", "multiple", ST.Digital_Config_Code);
                        i++;
                    }
                    else if (ST.Control_Type == "TXTDDL" && ST.Is_Multiselect == "N")
                    {
                        strAddRow = strAddRow + getDDL(ListMusic_Title, Short_Name, i, ST.Whr_Criteria, "", "A", "", ST.Digital_Config_Code);
                        i++;
                    }
                    else if (ST.Control_Type == "TXTAREA")
                    {
                        strAddRow = strAddRow + getTXTArea("", Short_Name, j, "A", ST.Digital_Config_Code, ST.Max_Length.ToString());
                        j++;
                    }
                    else if (ST.Control_Type == "DATE")
                    {
                        strAddRow = strAddRow + getDATE("", Short_Name, k, "A", ST.Digital_Config_Code);
                        k++;
                    }
                    else if (ST.Control_Type == "INT")
                    {
                        strAddRow = strAddRow + getNumber("", Short_Name, l, "A", ST.Digital_Config_Code, ST.Max_Length.ToString());
                        l++;
                    }
                    else if (ST.Control_Type == "DBL")
                    {
                        strAddRow = strAddRow + getDBL("", Short_Name, l, "A", ST.Digital_Config_Code);
                        l++;
                    }
                    else if (ST.Control_Type == "CHK")
                    {
                        strAddRow = strAddRow + getCheckbox("", Short_Name, m, "A", ST.Digital_Config_Code);
                        m++;
                    }
                    else if (ST.Control_Type == "RDB")
                    {
                        strAddRow = strAddRow + getRadio("", Short_Name, n, "A", ST.Digital_Config_Code, ST.Default_Values);
                        n++;
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
                        _fieldList = _fieldList + Short_Name + "ddDigi" + i.ToString() + "~" + ST.Digital_Config_Code.ToString() + ",";
                        i++;
                    }
                    else if (ST.Control_Type == "TXTAREA")
                    {
                        _fieldList = _fieldList + Short_Name + "txtAreaDigi" + j.ToString() + "~" + ST.Digital_Config_Code.ToString() + ",";
                        j++;
                    }
                    else if (ST.Control_Type == "DATE")
                    {
                        _fieldList = _fieldList + Short_Name + "dtDigi" + k.ToString() + "~" + ST.Digital_Config_Code.ToString().ToString() + ",";
                        k++;
                    }
                    else if (ST.Control_Type == "INT")
                    {
                        _fieldList = _fieldList + Short_Name + "numDigi" + l.ToString() + "~" + ST.Digital_Config_Code.ToString() + ",";
                        l++;
                    }
                    else if (ST.Control_Type == "DBL")
                    {
                        _fieldList = _fieldList + Short_Name + "numDigi" + l.ToString() + "~" + ST.Digital_Config_Code.ToString() + ",";
                        l++;
                    }
                    else if (ST.Control_Type == "CHK")
                    {
                        _fieldList = _fieldList + Short_Name + "chkDigi" + m.ToString() + "~" + ST.Digital_Config_Code.ToString() + ",";
                        m++;
                    }
                    else if (ST.Control_Type == "RDB")
                    {
                        _fieldList = _fieldList + Short_Name + "rdbDigi" + ST.Digital_Config_Code.ToString() + "~" + ST.Digital_Config_Code.ToString() + ",";
                        n++;
                    }

                }
            }
            strtableHeader = strtableHeader.Replace("UTOsplTag", "");
            if (ViewOperation != "VIEW")
            {
                strtableHeader = strtableHeader + "<th style=\"width:" + viewWidth + "%\"> "+ objMessageKey.Action + " </th>";
            }
            strtableHeader = strtableHeader + "</tr>";

            if (WindowType == "inLine")
            {
                strAddRow = strAddRow + "<td style=\"text-align: center;\"><a class=\"glyphicon glyphicon-ok-circle\" onclick = \"SaveDigi(this,0);\" style=\"padding: 3px;\"></a><a class=\"glyphicon glyphicon-remove-circle\" onclick = \"hideadddigi();\"></a></td>";
                strAddRow = strAddRow + "</tr>";
                strtableHeader = strtableHeader + strAddRow;
            }
            else
            {
                i = columnList.Count(a => a.Control_Type == "TXTDDL") + 1;
            }

            return strtableHeader + "~" + (i - 1).ToString();
        }
        public string getDDL(List<Music_Title> ListDigital_Data, string Short_Name, int i, string whrCond, string SelectedValues, string Operation, string multiple, int ConfigCode)
        {
            string[] SelectedList = SelectedValues.Split(',');
            string strDDL;
            if (multiple == "")
            {
                strDDL = "<select style=\"width:300px !important\" placeholder=\"Please Select\" id=\"" + Operation + Short_Name + "ddDigi" + i.ToString() + "\" name=\"" + Operation + Short_Name + "ddDigi" + i.ToString() + "\">";
                strDDL = strDDL + "<option value=\"''\" disabled selected style=\"display: none !important;\">Please Select</option>";
            }
            else
            {
                strDDL = "<select style=\"width:300px !important\" placeholder=\"Please Select\" id=\"" + Operation + Short_Name + "ddDigi" + i.ToString() + "\" name=\"" + Operation + Short_Name + "ddDigi" + i.ToString() + "\" " + multiple + ">";
            }
            //strDDL = strDDL + "<option value=\"\" selected disabled hidden> Please Select</option>";
            //foreach (Digital_Data LSD in ListDigital_Data.Where(a => a.Digital_Type == whrCond))
            foreach (Music_Title LSD in ListDigital_Data)
            {
                if (SelectedList.Contains(LSD.Music_Title_Code.ToString()))
                {
                    strDDL = strDDL + "<option value=" + LSD.Music_Title_Code + " selected>" + LSD.Music_Title_Name + "</option>";
                }
                else
                {
                    strDDL = strDDL + "<option value=" + LSD.Music_Title_Code + ">" + LSD.Music_Title_Name + "</option>";
                }
            }
            strDDL = strDDL + "</select>";

            _fieldList = _fieldList + Short_Name + "ddDigi" + i.ToString() + "~" + ConfigCode.ToString() + ",";

            return strDDL;
        }
        public string getTXT()
        {
            string strTXT = "";
            return strTXT;
        }
        public string getTXTArea(string User_Value, string Short_Name, int i, string Operation, int ConfigCode, string MaxLength)
        {
            string strTXTArea = "<textarea cols=\"1\" maxlength=\"" + MaxLength + "\" id=\"" + Operation + Short_Name + "txtAreaDigi" + i.ToString() + "\" name=\"" + Operation + Short_Name + "txtAreaDigi" + i.ToString() + "\" rows=\"1\" style=\"min-height: 31px !important;\">" + User_Value + "</textarea>";
            _fieldList = _fieldList + Short_Name + "txtAreaDigi" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return strTXTArea;
        }
        public string getDATE(string User_Value, string Short_Name, int i, string Operation, int ConfigCode)
        {
            if (User_Value != null && User_Value != "") { User_Value = (Convert.ToDateTime(User_Value)).ToString("yyyy-MM-dd"); }
            else { User_Value = ""; }
            string getDATE = "<input type =\"date\"  data-val=\"true\" id =\"" + Operation + Short_Name + "dtDigi" + i.ToString() + "\" name=\"" + Operation + Short_Name + "dtDigi" + i.ToString() + "\" style=\"height: 31px; \" value=\"" + User_Value + "\">";
            _fieldList = _fieldList + Short_Name + "dtDigi" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getDATE;
        }
        public string getNumber(string User_Value, string Short_Name, int i, string Operation, int ConfigCode, string MaxLength)
        {
            string getNumber = "<input type=\"number\" data-max-length=\"" + MaxLength + "\" min=\"0\" onkeypress=\"return !(event.charCode == 46)\" value=\"" + User_Value + "\" id=\"" + Operation + Short_Name + "numDigi" + i.ToString() + "\" name=\"" + Operation + Short_Name + "numDigi" + i.ToString() + "\">";
            _fieldList = _fieldList + Short_Name + "numDigi" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getNumber;
        }
        public string getDBL(string User_Value, string Short_Name, int i, string Operation, int ConfigCode)
        {
            string getNumber = "<input type=\"number\" value=\"" + User_Value + "\" placeholder=\"0.00\" step=\"0.01\" min=\"0\" value=\"" + User_Value + "\" id=\"" + Operation + Short_Name + "numDigi" + i.ToString() + "\" name=\"" + Operation + Short_Name + "numDigi" + i.ToString() + "\">";
            _fieldList = _fieldList + Short_Name + "numDigi" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getNumber;
        }
        public string getCheckbox(string User_Value, string Short_Name, int i, string Operation, int ConfigCode)
        {
            string strChecked = "";

            if (User_Value == "" || User_Value.ToUpper() == "NO")
            {
                strChecked = "";
            }
            else
                strChecked = " checked ";

            if (User_Value == "") User_Value = "YES";

            string getCheckbox = "<input type=\"checkbox\" value=\"" + User_Value + "\" id=\"" + Operation + Short_Name + "chkDigi" + i.ToString() + "\" name=\"" + Operation + Short_Name + "chkDigi" + i.ToString() + "\" style=\"margin-left: 4px;\"" + strChecked + ">";
            _fieldList = _fieldList + Short_Name + "chkDigi" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getCheckbox;
        }
        public string getRadio(string User_Value, string Short_Name, int i, string Operation, int ConfigCode, string DefaultValues)
        {
            string strChecked = "";

            //if (User_Value == "" || User_Value.ToUpper() == "NO")
            //{
            //    strChecked = "";
            //}
            //else
            strChecked = " checked ";

            if (User_Value == "") User_Value = "YES";

            string getCheckbox = string.Empty;
            var radioCountArr = DefaultValues.Split('~');
            for (int j = 0; j < radioCountArr.Length; j++)
            {
                if (radioCountArr[j].ToUpper() == User_Value.ToUpper())
                {
                    getCheckbox += "<input type=\"radio\" value=\"" + radioCountArr[j] + "\" id=\"" + Operation + Short_Name + "rdbDigi" + ConfigCode.ToString() + "\" name=\"" + Operation + Short_Name + "rdbDigi" + ConfigCode.ToString() + "\" style=\"margin-left: 4px;width: 10%;\"" + strChecked + "><label for=\"" + Operation + Short_Name + "rdbDigi" + ConfigCode.ToString() + "\" style=\"vertical-align:2px\">" + radioCountArr[j] + "</label>";
                    //_fieldList = _fieldList + Short_Name + "rdbDigi" + ConfigCode.ToString() + "~" + ConfigCode.ToString() + ",";
                }
                else
                {
                    getCheckbox += "<input type=\"radio\" value=\"" + radioCountArr[j] + "\" id=\"" + Operation + Short_Name + "rdbDigi" + ConfigCode.ToString() + "\" name=\"" + Operation + Short_Name + "rdbDigi" + ConfigCode.ToString() + "\" style=\"margin-left: 4px;width: 10%;\"><label for=\"" + Operation + Short_Name + "rdbDigi" + ConfigCode.ToString() + "\" style=\"vertical-align:2px\">" + radioCountArr[j] + "</label>";
                    //_fieldList = _fieldList + Short_Name + "rdbDigi" + ConfigCode.ToString() + "~" + ConfigCode.ToString() + ",";
                }
            }

            _fieldList = _fieldList + Short_Name + "rdbDigi" + ConfigCode.ToString() + "~" + ConfigCode.ToString() + ",";

            return getCheckbox;
        }

        //public string getTXTDDL()
        //{
        //    return "";
        //}

        public JsonResult digitalEdit(int title_Code, int digital_Code, int rowno, int num, string Short_Name, string View)
        {
            Dictionary<string, object> Jsonobj = new Dictionary<string, object>();

            List<USP_Get_Syn_Deal_Digital_Edit_Result> EditRowList = new List<USP_Get_Syn_Deal_Digital_Edit_Result>();
            List<Syn_Deal_Digital_Detail> lstDetailObj = new List<Syn_Deal_Digital_Detail>();

            Digital_Tab_Service objTabService = new Digital_Tab_Service(objLoginEntity.ConnectionStringName);
            int TabCode = (int)objTabService.SearchFor(a => a.Short_Name == Short_Name).Select(b => b.Digital_Tab_Code).FirstOrDefault();

            Digital_Config_Service objConfigService = new Digital_Config_Service(objLoginEntity.ConnectionStringName);

            //if (supplementary_Code != 0)
            //{
            //    EditRowList = objUspService.USP_Get_Syn_Deal_Supplementary_Edit_Result(supplementary_Code, rowno, Short_Name).ToList();
            //}
            //else
            //{
            lstDetailObj = (List<Syn_Deal_Digital_Detail>)((Syn_Deal_Digital)objSyn_Deal_Digital).Syn_Deal_Digital_Detail.ToList();

            lstDetailObj = lstDetailObj.Where(a => a.Row_Num == rowno && a.Digital_Tab_Code == TabCode).ToList();

            foreach (Syn_Deal_Digital_Detail obj in lstDetailObj)
            {
                USP_Get_Syn_Deal_Digital_Edit_Result objEditRow = new USP_Get_Syn_Deal_Digital_Edit_Result();
                objEditRow.Digital_Data_Code = obj.Digital_Data_Code;
                objEditRow.User_Value = obj.User_Value;
                objEditRow.Row_Num = obj.Row_Num;
                objEditRow.Digital_Tab_Code = obj.Digital_Tab_Code;
                objEditRow.Digital_Config_Code = obj.Digital_Config_Code;

                Digital_Config objSC = objConfigService.SearchFor(a => a.Digital_Config_Code == obj.Digital_Config_Code).FirstOrDefault();

                objEditRow.Digital_Code = objSC.Digital.Digital_Code;
                objEditRow.Control_Type = objSC.Control_Type;
                objEditRow.Is_Mandatory = objSC.Is_Mandatory;
                objEditRow.Is_Multiselect = objSC.Is_Multiselect;
                objEditRow.Max_Length = objSC.Max_Length;
                objEditRow.Control_Field_Order = objSC.Control_Field_Order;
                objEditRow.View_Name = objSC.View_Name;
                objEditRow.Whr_Criteria = objSC.Whr_Criteria;
                objEditRow.Default_Values = objSC.Default_Values;

                EditRowList.Add(objEditRow);
            }
            //}
            //Digital_Data_Service objDataService = new Digital_Data_Service(objLoginEntity.ConnectionStringName);
            //List<RightsU_Entities.Digital_Data> objDigital_Data = objDataService.SearchFor(a => true).ToList();
            Music_Title_Service objMusic_TitleService = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Music_Title> objMusic_Title = new List<Music_Title>();
            if (title_Code > 0)
            {
                objMusic_Title = objMusic_TitleService.SearchFor(a => a.Title_Code == title_Code).ToList();
            }


            string strAddRow = "<tr id=\"Edit" + Short_Name + "\" name=" + Short_Name + rowno.ToString() + ">";
            foreach (USP_Get_Syn_Deal_Digital_Edit_Result ED in EditRowList)
            {
                strAddRow = strAddRow + "<td>";
                int i = 1, j = 1, k = 1, l = 1, m = 1, n = 1;
                if (ED.Control_Type == "TXTDDL" && ED.Is_Multiselect == "Y")
                {
                    strAddRow = strAddRow + getDDL(objMusic_Title, Short_Name, i, ED.Whr_Criteria, ED.Digital_Data_Code, "E", "multiple", Convert.ToInt32(ED.Digital_Config_Code));
                    i++;
                }
                else if (ED.Control_Type == "TXTDDL" && ED.Is_Multiselect == "N")
                {
                    strAddRow = strAddRow + getDDL(objMusic_Title, Short_Name, i, ED.Whr_Criteria, ED.Digital_Data_Code, "E", "", Convert.ToInt32(ED.Digital_Config_Code));
                    i++;
                }
                else if (ED.Control_Type == "TXTAREA")
                {
                    strAddRow = strAddRow + getTXTArea(ED.User_Value, Short_Name, j, "E", Convert.ToInt32(ED.Digital_Config_Code), ED.Max_Length.ToString());
                    j++;
                }
                else if (ED.Control_Type == "DATE")
                {
                    strAddRow = strAddRow + getDATE("", Short_Name, k, "E", Convert.ToInt32(ED.Digital_Config_Code));
                    k++;
                }
                else if (ED.Control_Type == "INT")
                {
                    strAddRow = strAddRow + getNumber(ED.User_Value, Short_Name, l, "E", Convert.ToInt32(ED.Digital_Config_Code), ED.Max_Length.ToString());
                    l++;
                }
                else if (ED.Control_Type == "DBL")
                {
                    strAddRow = strAddRow + getDBL(ED.User_Value, Short_Name, l, "E", Convert.ToInt32(ED.Digital_Config_Code));
                    l++;
                }
                else if (ED.Control_Type == "CHK")
                {
                    strAddRow = strAddRow + getCheckbox(ED.User_Value, Short_Name, m, "E", Convert.ToInt32(ED.Digital_Config_Code));
                    m++;
                }
                else if (ED.Control_Type == "RDB")
                {
                    strAddRow = strAddRow + getRadio(ED.User_Value, Short_Name, n, "E", Convert.ToInt32(ED.Digital_Config_Code), ED.Default_Values);
                    n++;
                }
                strAddRow = strAddRow + "</td>";
            }
            if (View != "View")
            {
                strAddRow = strAddRow + "<td style=\"text-align: center;\"><a class=\"glyphicon glyphicon-ok-circle\" id=\"A" + Short_Name + rowno.ToString() + "\" onclick = \"SaveDigi(this,'" + rowno.ToString() + "');\" style=\"padding: 3px;\"></a><a class=\"glyphicon glyphicon-remove-circle\" onclick = \"closeEdit(" + num + ");\"></a></td>";
            }
            strAddRow = strAddRow + "</tr>";

            Jsonobj.Add("EditRow", strAddRow);

            return Json(Jsonobj);
        }
        public JsonResult digitalDelete(int digital_Code, int rowno, int TabCode)
        {
            List<Syn_Deal_Digital_Detail> lstDetailObj = new List<Syn_Deal_Digital_Detail>();

            if (objSyn_Deal_Digital != null)
            {
                lstDetailObj = (List<Syn_Deal_Digital_Detail>)((Syn_Deal_Digital)objSyn_Deal_Digital).Syn_Deal_Digital_Detail.ToList();
            }

            List<Syn_Deal_Digital_Detail> objDelete = new List<Syn_Deal_Digital_Detail>();

            objDelete = lstDetailObj.Where(a => a.Row_Num == rowno && a.Digital_Tab_Code == TabCode).ToList();

            foreach (Syn_Deal_Digital_Detail objDel in objDelete)
            {
                objDel.EntityState = State.Deleted;
            }

            ((Syn_Deal_Digital)objSyn_Deal_Digital).Syn_Deal_Digital_Detail = lstDetailObj;

            Dictionary<string, object> obj = new Dictionary<string, object>();

            obj.Add("ErrorCode", "100");
            obj.Add("ErrorMsg", "Deal Deleted successfully");

            return Json(obj);
        }

        public string DeleteDigital(int digital_Code, int page_index, int page_size)
        {
            objUspService.USP_Delete_Syn_Digital(digital_Code);
            //var Mode = "A";
            BindDigital(page_index, page_size);

            TempData["page_size"] = page_size;
            TempData["page_index"] = page_index;

            string success = "201";
            return success;
        }
        public string digitalDialogue(int title_Code, int digital_Code, int rowno, string Short_Name, int num)
        {
            string Operation = "A";
            if (rowno > 0) Operation = "E";

            Digital_Tab_Service objService = new Digital_Tab_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Digital_Tab objDigital_Tab = objService.SearchFor(a => a.Short_Name == Short_Name).ToList().FirstOrDefault();

            List<USP_Get_Syn_Deal_Digital_Edit_Result> EditRowList = new List<USP_Get_Syn_Deal_Digital_Edit_Result>();
            List<Syn_Deal_Digital_Detail> lstDetailObj = new List<Syn_Deal_Digital_Detail>();

            if (Operation == "E")
            {
                int TabCode = (int)objDigital_Tab.Digital_Tab_Code;

                Digital_Config_Service objConfigService = new Digital_Config_Service(objLoginEntity.ConnectionStringName);

                lstDetailObj = (List<Syn_Deal_Digital_Detail>)((Syn_Deal_Digital)objSyn_Deal_Digital).Syn_Deal_Digital_Detail.ToList();

                lstDetailObj = lstDetailObj.Where(a => a.Row_Num == rowno && a.Digital_Tab_Code == TabCode).ToList();

                foreach (Syn_Deal_Digital_Detail obj in lstDetailObj)
                {
                    USP_Get_Syn_Deal_Digital_Edit_Result objEditRow = new USP_Get_Syn_Deal_Digital_Edit_Result();
                    objEditRow.Digital_Data_Code = obj.Digital_Data_Code;
                    objEditRow.User_Value = obj.User_Value;
                    objEditRow.Row_Num = obj.Row_Num;
                    objEditRow.Digital_Tab_Code = obj.Digital_Tab_Code;
                    objEditRow.Digital_Config_Code = obj.Digital_Config_Code;

                    Digital_Config objSC = objConfigService.SearchFor(a => a.Digital_Config_Code == obj.Digital_Config_Code).FirstOrDefault();

                    objEditRow.Digital_Code = objSC.Digital.Digital_Code;
                    objEditRow.Control_Type = objSC.Control_Type;
                    objEditRow.Is_Mandatory = objSC.Is_Mandatory;
                    objEditRow.Is_Multiselect = objSC.Is_Multiselect;
                    objEditRow.Max_Length = objSC.Max_Length;
                    objEditRow.Control_Field_Order = objSC.Control_Field_Order;
                    objEditRow.View_Name = objSC.View_Name;
                    objEditRow.Whr_Criteria = objSC.Whr_Criteria;
                    objEditRow.Default_Values = objSC.Default_Values;

                    EditRowList.Add(objEditRow);
                }
            }

            List<USP_Get_Digital_Config_Result> columnList = objUspService.USP_Get_Digital_Config(objDigital_Tab.Digital_Tab_Code).ToList();

            //Digital_Data_Service objDataService = new Digital_Data_Service(objLoginEntity.ConnectionStringName);
            //List<RightsU_Entities.Digital_Data> objDigital_Data = objDataService.SearchFor(a => true).ToList();

            Music_Title_Service objMusic_TitleService = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            List<Music_Title> objMusic_Title = new List<Music_Title>();
            if (title_Code > 0)
            {
                objMusic_Title = objMusic_TitleService.SearchFor(x => x.Title_Code == title_Code).ToList();
            }

            string strAddRow = "";

            strAddRow = "<Table class=\"table table-bordered table-hover\" style=\"padding:10px;\">";

            string prevRowTitle = "";
            int i = 1, j = 1, k = 1, l = 1, m = 1, n = 1;

            foreach (USP_Get_Digital_Config_Result CM in columnList)
            {
                string utospltag = "";
                string user_Value = "";
                string digital_Data_Code = "";

                USP_Get_Syn_Deal_Digital_Edit_Result obj = new USP_Get_Syn_Deal_Digital_Edit_Result();

                if (Operation == "E")
                {
                    obj = EditRowList.Where(a => a.Digital_Config_Code == CM.Digital_Config_Code).FirstOrDefault();
                    user_Value = obj.User_Value;
                    digital_Data_Code = obj.Digital_Data_Code;
                }

                if (prevRowTitle != "" && prevRowTitle == CM.Digital_Name)
                {
                    if (CM.Control_Type == "TXTDDL" && CM.Is_Multiselect == "Y")
                    {
                        utospltag = getDDL(objMusic_Title, Short_Name, i, CM.Whr_Criteria, digital_Data_Code, Operation, "multiple", CM.Digital_Config_Code);
                        i++;
                    }
                    else if (CM.Control_Type == "TXTDDL" && CM.Is_Multiselect == "N")
                    {
                        utospltag = getDDL(objMusic_Title, Short_Name, i, CM.Whr_Criteria, digital_Data_Code, Operation, "", CM.Digital_Config_Code);
                        i++;
                    }
                    else if (CM.Control_Type == "TXTAREA")
                    {
                        utospltag = getTXTArea(user_Value, Short_Name, j, Operation, CM.Digital_Config_Code, CM.Max_Length.ToString());
                        j++;
                    }
                    else if (CM.Control_Type == "DATE")
                    {
                        utospltag = getDATE(user_Value, Short_Name, k, Operation, CM.Digital_Config_Code);
                        k++;
                    }
                    else if (CM.Control_Type == "INT")
                    {
                        utospltag = getNumber(user_Value, Short_Name, l, Operation, CM.Digital_Config_Code, CM.Max_Length.ToString());
                        l++;
                    }
                    else if (CM.Control_Type == "DBL")
                    {
                        utospltag = getDBL(user_Value, Short_Name, l, Operation, CM.Digital_Config_Code);
                        l++;
                    }
                    else if (CM.Control_Type == "CHK")
                    {
                        utospltag = getCheckbox(user_Value, Short_Name, m, Operation, CM.Digital_Config_Code);
                        m++;
                    }
                    else if (CM.Control_Type == "RDB")
                    {
                        utospltag = getRadio(user_Value, Short_Name, n, Operation, CM.Digital_Config_Code, CM.Default_Values);
                        n++;
                    }

                    strAddRow = strAddRow.Replace("utospltag", utospltag);
                }
                else
                {
                    strAddRow = strAddRow.Replace("utospltag", "");
                    strAddRow = strAddRow + "<tr>";
                    strAddRow = strAddRow + "<td style=\"width: 40%;\">";
                    strAddRow = strAddRow + CM.Digital_Name;
                    strAddRow = strAddRow + "</td>";
                    strAddRow = strAddRow + "<td>";
                    prevRowTitle = CM.Digital_Name;

                    if (CM.Control_Type == "TXTDDL" && CM.Is_Multiselect == "Y")
                    {
                        strAddRow = strAddRow + getDDL(objMusic_Title, Short_Name, i, CM.Whr_Criteria, digital_Data_Code, Operation, "multiple", CM.Digital_Config_Code);
                        i++;
                    }
                    else if (CM.Control_Type == "TXTDDL" && CM.Is_Multiselect == "N")
                    {
                        strAddRow = strAddRow + getDDL(objMusic_Title, Short_Name, i, CM.Whr_Criteria, digital_Data_Code, Operation, "", CM.Digital_Config_Code);
                        i++;
                    }
                    else if (CM.Control_Type == "TXTAREA")
                    {
                        strAddRow = strAddRow + getTXTArea(user_Value, Short_Name, j, Operation, CM.Digital_Config_Code, CM.Max_Length.ToString());
                        j++;
                    }
                    else if (CM.Control_Type == "DATE")
                    {
                        strAddRow = strAddRow + getDATE(user_Value, Short_Name, k, Operation, CM.Digital_Config_Code);
                        k++;
                    }
                    else if (CM.Control_Type == "INT")
                    {
                        strAddRow = strAddRow + getNumber(user_Value, Short_Name, l, Operation, CM.Digital_Config_Code, CM.Max_Length.ToString());
                        l++;
                    }
                    else if (CM.Control_Type == "DBL")
                    {
                        strAddRow = strAddRow + getDBL(user_Value, Short_Name, l, Operation, CM.Digital_Config_Code);
                        l++;
                    }
                    else if (CM.Control_Type == "CHK")
                    {
                        strAddRow = strAddRow + getCheckbox(user_Value, Short_Name, m, Operation, CM.Digital_Config_Code);
                        m++;
                    }
                    else if (CM.Control_Type == "RDB")
                    {
                        strAddRow = strAddRow + getRadio(user_Value, Short_Name, n, Operation, CM.Digital_Config_Code, CM.Default_Values);
                        n++;
                    }
                    //else if (CM.Control_Type == "TXTDDL")
                    //{
                    //    strAddRow = strAddRow + getTXTDDL();
                    //}
                    strAddRow = strAddRow + " utospltag </td></tr>";
                }
            }
            strAddRow = strAddRow.Replace("utospltag", "");
            strAddRow = strAddRow + "<TR><td style=\"text-align: center;\" colspan=2><input type=\"submit\" id=\"btnSaveDeal\" class=\"btn btn-primary\" value=\"Save\" style=\"margin-right: 4px;\" onclick=\"return SaveDigi(this,'" + rowno.ToString() + "'); \"><input type=\"submit\" id=\"btnSaveDeal\" class=\"btn btn-primary\" value=\"Cancel\" onclick=\"closeEdit(" + num + "); \"></td></TR>";

            strAddRow = strAddRow + "</Table>";
            return strAddRow;

        }
        public JsonResult DigiButtonEvents(int Digital_code, int title_code, string View, string MODE, int? RCode, int? PCode, int? TCode, int? Episode_From, int? Episode_To, string IsHB, int page_size, int page_index, string Is_Syn_Syn_Mapp = "")
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
            obj_Dictionary_RList.Add("Digital_code", Digital_code.ToString());
            obj_Dictionary_RList.Add("title_code", title_code.ToString());
            obj_Dictionary_RList.Add("page_size", page_size.ToString());
            obj_Dictionary_RList.Add("page_index", page_index.ToString());
            if (View != null)
            {
                obj_Dictionary_RList.Add("View", View.ToString());
            }
            else
            {
                obj_Dictionary_RList.Add("View", "");
            }
            TempData["QueryString_Rights"] = obj_Dictionary_RList;
            string tabName = GlobalParams.Page_From_Digital_AddEdit;
            //if (MODE == GlobalParams.DEAL_MODE_VIEW || MODE == GlobalParams.DEAL_MODE_APPROVE || MODE == GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
            //    tabName = GlobalParams.Page_From_Rights_Detail_View;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("TabName", tabName);
            return Json(obj);
        }
        public bool digitalDupliValidation(string Value_list, string Short_Name, int Row_No, string Operation)
        {
            List<Syn_Deal_Digital_Detail> lstDetailObj = new List<Syn_Deal_Digital_Detail>();
            Syn_Deal_Digital objDigital = new Syn_Deal_Digital();

            Dictionary<string, object> obj = new Dictionary<string, object>();

            objDigital = (Syn_Deal_Digital)objSyn_Deal_Digital;
            lstDetailObj = (List<Syn_Deal_Digital_Detail>)objDigital.Syn_Deal_Digital_Detail.ToList();

            Digital_Config_Service objConfigService = new Digital_Config_Service(objLoginEntity.ConnectionStringName);

            Digital_Tab_Service objTabService = new Digital_Tab_Service(objLoginEntity.ConnectionStringName);
            int TabCode = (int)objTabService.SearchFor(a => a.Short_Name == Short_Name).Select(b => b.Digital_Tab_Code).FirstOrDefault();
            int config_Code = 0;
            String ErrorCode = "";
            Value_list = Value_list.Substring(0, Value_list.Length - 2);
            string[] columnValueList = Value_list.Split(new string[] { "¿ï" }, StringSplitOptions.None);
            int[] dtextval;


            int CountNoOfDDL = 0;
            foreach (var str in columnValueList)
            {
                string[] vals = str.Split(new string[] { "ï¿" }, StringSplitOptions.None);
                config_Code = Convert.ToInt32(vals[1]);
                string ControlType = objConfigService.SearchFor(a => a.Digital_Config_Code == config_Code).Select(b => b.Control_Type).FirstOrDefault();
                if (ControlType == "TXTDDL")
                {
                    CountNoOfDDL++;
                }

            }


            List<CurrentValues> lstCurrentValues = new List<CurrentValues>();
            List<SavedValues> lstSavedValues = new List<SavedValues>();

            List<string> lstSavedString = new List<string>();

            foreach (var str in columnValueList)
            {
                string[] vals = str.Split(new string[] { "ï¿" }, StringSplitOptions.None);
                config_Code = Convert.ToInt32(vals[1]);

                string ControlType = objConfigService.SearchFor(a => a.Digital_Config_Code == config_Code).Select(b => b.Control_Type).FirstOrDefault();
                if (ControlType == "TXTDDL")
                {
                    dtextval = Array.ConvertAll(vals[0].Split('-'), x => int.Parse(x));
                    var DetailsCode = lstDetailObj.Where(S => S.Digital_Tab_Code == TabCode &&
                                                                           S.Digital_Config_Code == config_Code &&
                                                                           S.Row_Num.Value != Row_No &&
                                                                           S.EntityState != State.Deleted).Select(K => new { K.Digital_Data_Code, K.Row_Num }).ToList();

                    foreach (var values in dtextval)
                    {
                        CurrentValues objCurrentValues = new CurrentValues();
                        objCurrentValues.configColNum = Convert.ToString(config_Code);//Convert.ToString(values);
                        objCurrentValues.configCode = Convert.ToString(values); //Convert.ToString(config_Code);
                        lstCurrentValues.Add(objCurrentValues);
                    }

                    if (DetailsCode.Count() > 0)
                    {

                        foreach (var item in DetailsCode)
                        {
                            string[] SavedCodes = item.Digital_Data_Code.Split(',');
                            string RowNum = item.Row_Num.ToString();

                            foreach (var savedCode in SavedCodes)
                            {
                                SavedValues objSavedValues = new SavedValues();
                                objSavedValues.configColNum = Convert.ToString(config_Code);//savedCode;
                                objSavedValues.configCode = savedCode;//Convert.ToString(config_Code);
                                objSavedValues.RowNo = Convert.ToInt32(RowNum);
                                lstSavedValues.Add(objSavedValues);
                            }

                        }
                    }

                }


            }


            string currentString = "";
            List<string> strValidationList_Current = new List<string>();

            var lstUniqueRowNumbers = lstSavedValues.Select(x => x.RowNo).Distinct().ToList();

            List<string> strValidationList = new List<string>();

            foreach (var uniqueRowNumber in lstUniqueRowNumbers)
            {
                string savedString = "";
                var lstSavedValues_uniqueRowNumber = lstSavedValues.Where(x => x.RowNo == uniqueRowNumber).ToList();

                for (int i = 0; i < lstSavedValues_uniqueRowNumber.Count(); i++)
                {
                    if (CountNoOfDDL == 1)
                    {
                        savedString = lstSavedValues_uniqueRowNumber[i].configCode + "~" + lstSavedValues_uniqueRowNumber[i].configColNum;
                        lstSavedString.Add(savedString);
                    }
                    else
                    {
                        if (savedString == "")
                        {
                            savedString = lstSavedValues_uniqueRowNumber[i].configCode;
                        }
                        else
                        {
                            savedString = savedString + "~" + lstSavedValues_uniqueRowNumber[i].configCode;
                        }
                    }
                }
                lstSavedString.Add(savedString);
            }

            foreach (var currentValue in lstCurrentValues)
            {
                if (CountNoOfDDL == 1)
                {
                    currentString = currentValue.configCode + "~" + currentValue.configColNum;

                    if (lstSavedString.Contains(currentString))
                    {
                        return true;
                    }
                }
                else
                {
                    if (currentString == "")
                    {
                        currentString = currentValue.configCode;
                    }
                    else
                    {
                        currentString = currentString + "~" + currentValue.configCode;
                    }
                }
            }

            if (lstSavedString.Contains(currentString))
            {
                return true;
            }



            //foreach (string str in columnValueList)
            //{
            //    //string[] vals = str.Split('~');
            //    string[] vals = str.Split(new string[] { "ï¿" }, StringSplitOptions.None);
            //    config_Code = Convert.ToInt32(vals[1]);
            //    string tempVal = "";

            //    string ControlType = objConfigService.SearchFor(a => a.Supplementary_Config_Code == config_Code).Select(b => b.Control_Type).FirstOrDefault();
            //    if (ControlType == "TXTDDL")
            //    {
            //        if (vals[0] != "")
            //        {
            //            dtextval = Array.ConvertAll(vals[0].Split('-'), x => int.Parse(x));

            //            List<string> selectedDrp = lstDetailObj.Where(S => S.Supplementary_Tab_Code == TabCode &&
            //                                                               S.Supplementary_Config_Code == config_Code &&
            //                                                               S.Row_Num.Value != Row_No &&
            //                                                               S.EntityState != State.Deleted).Select(K => K.Supplementary_Data_Code).ToList();

            //            tempVal = string.Join(",", selectedDrp);

            //            int i = 1;
            //            //if (Operation != "E")
            //            //{
            //            foreach (int dt in dtextval)
            //            {
            //                if (tempVal.IndexOf(dt.ToString(), 0) > -1)
            //                {
            //                    return true;

            //                }
            //                i++;
            //            }
            //            //}
            //            //else
            //            //{
            //            //    List<string> selectedDrponRoIdx = lstDetailObj.Where(S => S.Supplementary_Tab_Code == TabCode && S.Supplementary_Config_Code == config_Code && S.Row_Num == Row_No).Select(K => K.Supplementary_Data_Code).ToList();

            //            //}
            //        }
            //    }
            //}
            ////obj.Add("ErrorCode", ErrorCode);
            ////obj.Add("ErrorMsg", "Duplicate Value Not allowed");
            return false;
        }
        public string digitalSave(string Value_list, string Short_Name, string Operation, int Row_No, string rwIndex)
        {
            //check for duplicate
            if (digitalDupliValidation(Value_list, Short_Name, Row_No, Operation))
            {
                return "Duplicate";
            }

            List<Syn_Deal_Digital_Detail> lstDetailObj = new List<Syn_Deal_Digital_Detail>();
            Syn_Deal_Digital objDigital = new Syn_Deal_Digital();

            objDigital = (Syn_Deal_Digital)objSyn_Deal_Digital;
            lstDetailObj = (List<Syn_Deal_Digital_Detail>)objDigital.Syn_Deal_Digital_Detail.ToList();

            //"1~1,sai~2,"
            Digital_Tab_Service objTabService = new Digital_Tab_Service(objLoginEntity.ConnectionStringName);
            int TabCode = (int)objTabService.SearchFor(a => a.Short_Name == Short_Name).Select(b => b.Digital_Tab_Code).FirstOrDefault();

            Music_Title_Service objMusic_TitleService = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            Digital_Config_Service objConfigService = new Digital_Config_Service(objLoginEntity.ConnectionStringName);

            int rowNum = 0;
            if (lstDetailObj.Count(b => b.Digital_Tab_Code == TabCode) != 0 && Operation == "A")
            {
                rowNum = (int)lstDetailObj.Where(b => b.Digital_Tab_Code == TabCode).Max(a => a.Row_Num).Value;
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
                Syn_Deal_Digital_Detail obj = new Syn_Deal_Digital_Detail();
                //string[] vals = str.Split('~');
                string[] vals = str.Split(new string[] { "ï¿" }, StringSplitOptions.None);
                int config_Code = Convert.ToInt32(vals[1]);
                string ControlType = objConfigService.SearchFor(a => a.Digital_Config_Code == config_Code).Select(b => b.Control_Type).FirstOrDefault();

                if (Operation == "E")
                    obj = lstDetailObj.Where(a => a.Digital_Config_Code == config_Code && a.Digital_Tab_Code == TabCode && a.Row_Num == rowNum).FirstOrDefault();

                if (ControlType == "TXTDDL")
                {
                    if (vals[0] != "")
                    {
                        int[] dtextval = Array.ConvertAll(vals[0].Split('-'), x => int.Parse(x));
                        string t = string.Join(",", objMusic_TitleService.SearchFor(a => dtextval.Contains(a.Music_Title_Code)).Select(b => b.Music_Title_Name).ToList());
                        Output = Output + "<td>" + t + "</td>";
                    }
                    else
                    {
                        Output = Output + "<td>&nbsp;</td>";
                    }
                    obj.Digital_Data_Code = vals[0].Replace('-', ',');
                }
                if (ControlType == "TXTAREA" || ControlType == "INT" || ControlType == "DBL" || ControlType == "DATE" || ControlType == "CHK" || ControlType == "RDB")
                {
                    Output = Output + "<td><div class=\"DigiRemarks\">" + vals[0] + "</div></td>";
                    obj.User_Value = vals[0];
                }

                if (Operation == "A")
                {
                    obj.Row_Num = rowNum + 1;
                    obj.Digital_Config_Code = Convert.ToInt32(vals[1]);
                    obj.Digital_Tab_Code = TabCode;
                    obj.EntityState = State.Added;
                    lstDetailObj.Add(obj);
                }
                else if (Operation == "E" && obj.Syn_Deal_Digital_Detail_Code > 0)
                {
                    objDigital.EntityState = State.Modified;
                    obj.EntityState = State.Modified;
                }
            }
            if (Operation == "A")
            {
                Output = Output + "<td style=\"text-align:center;\"><a title = \"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"DigiEdit(this,'0','" + Convert.ToString(rowNum + 1) + "','" + Convert.ToString(rowNum + 1) + "','" + TabCode + "');\"></a><a title =\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"DigiDelete(this,'0','" + Convert.ToString(rowNum + 1) + "','" + Convert.ToString(rowNum + 1) + "','" + TabCode + "','" + Short_Name + "' );\"></a></td>";
            }
            else if (Operation == "E")
            {
                Output = Output + "<td style=\"text-align:center;\"><a title = \"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"DigiEdit(this,'0','" + Convert.ToString(rowNum) + "','" + Convert.ToString(rowNum) + "','" + TabCode + "');\"></a><a title =\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"DigiDelete(this,'0','" + Convert.ToString(rowNum) + "','" + Convert.ToString(rowNum) + "','" + TabCode + "','" + Short_Name + "');\"></a></td>";
            }
            Output = Output + "</tr>";

            objDigital.Syn_Deal_Digital_Detail = lstDetailObj;
            objSyn_Deal_Digital = objDigital;
            return Output;
        }
        public JsonResult digitalSaveDB(string Title_List, string Remarks, int page_size, int page_index)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            Syn_Deal_Digital objDigitalTemp = (Syn_Deal_Digital)objSyn_Deal_Digital;
            List<Syn_Deal_Digital_Detail> lstDetailObj = (List<Syn_Deal_Digital_Detail>)objDigitalTemp.Syn_Deal_Digital_Detail.ToList();
            Syn_Deal_Digital_Service objTransactionService = new Syn_Deal_Digital_Service(objLoginEntity.ConnectionStringName);

            if (objSyn_Deal_Digital == null)
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
                    Syn_Deal_Digital objDigital = null;

                    if (titleCode == objDigitalTemp.Title_code && episodeFrom == objDigitalTemp.Episode_From && episodeTo == objDigitalTemp.Episode_To)
                    {
                        objDigital = objDigitalTemp;
                        objTransactionService = (Syn_Deal_Digital_Service)Session["Digital_Service"];
                    }
                    else
                    {
                        objTransactionService = new Syn_Deal_Digital_Service(objLoginEntity.ConnectionStringName);
                    }

                    if (objDigital == null)
                    {
                        objDigital = new Syn_Deal_Digital();

                        objDigital.Title_code = titleCode;
                        objDigital.Episode_From = episodeFrom;
                        objDigital.Episode_To = episodeTo;
                        objDigital.Remarks = Remarks;
                        objDigital.Syn_Deal_Code = objDeal_Schema.Deal_Code;
                        objDigital.EntityState = State.Added;

                        foreach (Syn_Deal_Digital_Detail objD in lstDetailObj)
                        {
                            Syn_Deal_Digital_Detail objTemp = new Syn_Deal_Digital_Detail();

                            objTemp.Row_Num = objD.Row_Num;
                            objTemp.Digital_Config_Code = objD.Digital_Config_Code;
                            objTemp.Digital_Data_Code = objD.Digital_Data_Code;
                            objTemp.Digital_Tab_Code = objD.Digital_Tab_Code;
                            objTemp.User_Value = objD.User_Value;
                            objTemp.EntityState = objD.EntityState;
                            if (objTemp.EntityState != State.Deleted)
                            {
                                objDigital.Syn_Deal_Digital_Detail.Add(objTemp);
                            }
                        }
                    }
                    else
                    {
                        objDigital.Remarks = Remarks;
                        objDigital.EntityState = State.Modified;
                    }
                    objTransactionService.Save(objDigital, out resultSet);

                    //lstDetailObjTemp = null;
                    objTransactionService = null;
                    objDigital = null;
                }

                obj.Add("ErrorCode", "100");
                obj.Add("ErrorMsg", "Deal Saved successfully");
                obj.Add("page_size", page_size);
                obj.Add("page_index", page_index);
                TempData["page_size"] = page_size;
                TempData["page_index"] = page_index;
                return Json(obj);
            }
        }

        public JsonResult digitalValidation()
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            int count = objSyn_Deal_Digital.Syn_Deal_Digital_Detail.Where(x => x.EntityState != State.Deleted).Count();
            obj.Add("detailsCnt", count);
            return Json(obj);
        }

        public JsonResult BindMusicTrack(int title_Code, bool multiple)
        {
            Dictionary<string, object> Jsonobj = new Dictionary<string, object>();

            Music_Title_Service objMusicTitleService = new Music_Title_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Music_Title> objMusic_Title = new List<Music_Title>();
            if (title_Code > 0)
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                {
                    Title_List objTL = null;
                    objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == title_Code).FirstOrDefault();
                    title_Code = objTL.Title_Code;
                }
                
                objMusic_Title = objMusicTitleService.SearchFor(a => a.Title_Code == title_Code).ToList();
            }

            //if (!multiple)
            //{
            //    objMusic_Title.Insert(0, new Music_Title { Music_Title_Code = 0, Music_Title_Name = "Select Title" });
            //}

            Jsonobj.Add("Music_Title_List", new SelectList(objMusic_Title, "Music_Title_Code", "Music_Title_Name"));

            //Jsonobj.Add("SelectedMusicTrack", Music_Title_Code);
            return Json(Jsonobj);
        }

        public class CurrentValues
        {
            public string configColNum { get; set; }
            public string configCode { get; set; }
            public int RowNo { get; set; }
        }

        public class SavedValues
        {
            public string configColNum { get; set; }
            public string configCode { get; set; }
            public int RowNo { get; set; }
        }
    }
}