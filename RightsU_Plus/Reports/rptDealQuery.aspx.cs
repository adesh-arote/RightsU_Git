using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Microsoft.Reporting.WebForms;
using RightsU_Entities;
using RightsU_BLL;
using System.Linq;

public partial class Reports_rptDealQuery : ParentPage
{
    public User objLoginedUser { get; set; }
    #region ------ Attributes -------

    private ReportQuery rptMain
    {
        get
        {
            return (ReportQuery)Session["rptMain"];
        }
        set
        {
            Session["rptMain"] = value;
        }
    }

    //ArrayList arrUserRight;
    Users objUser = new Users();
    int loginUserId;

    private string curVW
    {
        get
        {
            if (ViewState["VIEW"] == null || Convert.ToString(ViewState["VIEW"]) == "")
                ViewState["VIEW"] = Request["view"];
            if (ViewState["VIEW"] == null || Convert.ToString(ViewState["VIEW"]) == "")
                return "VW_ACQ_DEALS";
            return Convert.ToString(ViewState["VIEW"]);
        }
        set
        {
            ViewState["VIEW"] = value;
        }
    }
    private string SelectedBusinessUnit
    {
        get
        {
            if (ViewState["SelectedBusinessUnit"] == null)
                ViewState["SelectedBusinessUnit"] = "";
            return ViewState["SelectedBusinessUnit"].ToString();
        }
        set
        {
            ViewState["SelectedBusinessUnit"] = value;
        }
    }
    private bool ExpiredDeals
    {
        get
        {
            if (ViewState["ExpiredDeals"] == null)
                ViewState["ExpiredDeals"] = false;
            return Convert.ToBoolean(ViewState["ExpiredDeals"]);
        }
        set
        {
            ViewState["ExpiredDeals"] = value;
        }
    }
    public bool TheatricalTerritory
    {
        get
        {
            if (ViewState["TheatricalTerritory"] == null)
                ViewState["TheatricalTerritory"] = false;
            return Convert.ToBoolean(ViewState["TheatricalTerritory"]);
        }
        set
        {
            ViewState["TheatricalTerritory"] = value;
        }
    }

    #endregion

    #region ------ Event Handlers ------

    protected override void OnInit(EventArgs e)
    {
        IsReqLoadingPanel = "N";
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
        base.OnInit(e);
        Page pi = (ParentPage)this;

        if (Page.IsPostBack)
        {
            if (rptMain != null)
                bindColNameList();
        }
        else
        {
            curVW = Request["View_Name"];
            GetReportQuery();
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        /**
          *IN THIS PAGE NOT POSSIBLE TO SHOW AJAX CALENDAR EXTENDER BECAUSE THIS TABLE IS IS GENERATE THROUGH JAVASCRIPT 
          *AND IT IS NOT POSSIBLE TO CREATE THE SERVER CONTROL THROUGH JAVASCRIPT SO CALENDER EXTENDER IS NOT POSSIBLE IN
          *THIS QUERY MODULE AS WELL AS FLOOR QUERY REPORT.
          */

        curVW = Request["View_Name"];

        if (curVW.ToUpper() == "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*I")
            hdnReportType.Value = "IA"; // International Availaibility
        else if (curVW.ToUpper() == "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*D")
            hdnReportType.Value = "DA"; // Domestic Availaibility

        loginUserId = objLoginedUser.Users_Code;
        lblVwType.Text = GetDisplayNameForView(curVW);

        if (!Page.IsPostBack)
        {
            string temp = "", isEdit = "N";
            this.PopulateAlternateLanguage();
            Page.Header.DataBind();
            if (Request.QueryString["BusinessUnitCode"] != null)
                SelectedBusinessUnit = Request.QueryString["BusinessUnitCode"].ToString();

            if (Request.QueryString["Expired"] != null)
                ExpiredDeals = Convert.ToBoolean(Request.QueryString["Expired"]);

            if (Request.QueryString["Theatrical"] != null)
                TheatricalTerritory = Convert.ToBoolean(Request.QueryString["Theatrical"]);

            #region --- View data of saved query --
            string Query_Id = Convert.ToString(Request.QueryString["Query_Id"]);

            if (string.IsNullOrEmpty(Query_Id))
                Query_Id = "0";

            int queryID = Convert.ToInt32(Query_Id);

            if (queryID > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "loadingGif", "showLoading();", true);
                rptMain.IntCode = queryID;
                rptMain.FetchDeep();
                ExpiredDeals = rptMain.Expired_Deals == "Y" ? true : false;
                TheatricalTerritory = rptMain.Theatrical_Territory == "Y" ? true : false;
                SelectedBusinessUnit = rptMain.Business_Unit_Code.ToString();
                this.hdnQID.Value = rptMain.IntCode.ToString();
                this.hdnQName.Value = rptMain.QueryName;
                rblVisibility.SelectedValue = rptMain.Visibility;
                temp = rptMain.Alternate_Config_Code;
                if (temp != null)
                {
                    if (temp != "")
                    {
                        string[] strArray = temp.Split(',');
                        foreach (var item in strArray)
                        {
                            for (int i = 0; i < chkAlternateLanguage.Items.Count; i++)
                            {
                                if (chkAlternateLanguage.Items[i].Value == item)
                                {
                                    chkAlternateLanguage.Items[i].Selected = true;
                                }
                            }
                        }
                    }
                }
                if (objLoginedUser.Users_Code != rptMain.InsertedBy)
                {
                    rblVisibility.Enabled = false;
                    btnSaveQuery.Visible = false;
                }

                showResult(false, "Y");
            }
            #endregion

            if (hdnFlag.Value == "true")
            {
                isEdit = "Y";
                hdnFlag.Value = "false";
                bindColNameList();
            }
            else
                BindData(true);

            ddlcolList.Focus();

            if (isEdit == "N")
                BindListbox();
            else
            {
                if (temp != null)
                {
                    if (temp != "")
                    {
                        temp = temp.TrimEnd(',');
                        string curVWList = "'" + curVW + "'";
                        if (curVW.Contains("*"))
                            curVWList = curVWList + ",'" + curVW.Substring(0, curVW.IndexOf("*")) + "'";
                        string selectedCol = hdnCol.Value.ToString().Replace("~", ",").Trim(',');
                        string strLCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N'  and view_Name in (" + curVWList + ") And  (Alternate_Config_Code is null or Alternate_Config_Code  in  (" + temp + ")) ",
                            strRCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N'  and view_Name in (" + curVWList + ") ";
                        strLCol += " AND Column_code NOT IN (" + (selectedCol == string.Empty ? "0" : selectedCol) + ")   ";
                        strRCol += " AND Column_code IN (" + (selectedCol == string.Empty ? "0" : selectedCol) + ")  ";
                        DataSet Ds = DatabaseBroker.ProcessSelectDirectly(strLCol);
                        lsCol.DataSource = Ds;
                        lsCol.DataTextField = "display_Name";
                        lsCol.DataValueField = "Column_code";
                        lsCol.DataBind();
                        BindLST(lsrCol, strRCol, selectedCol);
                    }
                    else
                        BindListbox();
                }
                else
                    BindListbox();
            }
        }
        else
        {
            string strhidID = hidID.Value;
            string strhidUserText = hidUserText.Value;
            string strhidStringAllCond = hidStringAllCond.Value;
        }
        if (rptMain != null)
        {
            RegisterJS();
            ReportColumn rpc = rptMain._arrRptColumn[rptMain._arrRptColumn.Count - 1];
            hdnColCount.Value = rpc.compID.ToString();
        }

        //ScriptManager.RegisterStartupScript(this, this.GetType(), "toolbarCss", "AssignReportViewerCSS();", true);
    }

    protected void imgresults_Click(object sender, ImageClickEventArgs e)
    {

        //ScriptManager.RegisterStartupScript(this, this.GetType(), "loadingGif", "showLoading();", true);
        showResult(true);

        string selected_listItemCode = "";
        foreach (ListItem aListItem in chkAlternateLanguage.Items)
        {
            if (aListItem.Selected)
            {
                selected_listItemCode = selected_listItemCode + aListItem.Value.ToString() + ',';
            }
        }
        selected_listItemCode = selected_listItemCode.TrimEnd(',');

        if (selected_listItemCode != "")
        {
            string curVWList = "'" + curVW + "'";

            if (curVW.Contains("*"))
                curVWList = curVWList + ",'" + curVW.Substring(0, curVW.IndexOf("*")) + "'";

            string selectedCol = hdnCol.Value.ToString().Replace("~", ",").Trim(',');
            string strLCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N'  and view_Name in (" + curVWList + ") And  (Alternate_Config_Code is null or Alternate_Config_Code  in  (" + selected_listItemCode + ")) ",
                strRCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N'  and view_Name in (" + curVWList + ") ";

            strLCol += " AND Column_code NOT IN (" + (selectedCol == string.Empty ? "0" : selectedCol) + ")   ";
            strRCol += " AND Column_code IN (" + (selectedCol == string.Empty ? "0" : selectedCol) + ")  ";

            DataSet Ds = DatabaseBroker.ProcessSelectDirectly(strLCol);
            lsCol.DataSource = Ds;
            lsCol.DataTextField = "display_Name";
            lsCol.DataValueField = "Column_code";
            lsCol.DataBind();

            BindLST(lsrCol, strRCol, selectedCol);
        }
        else
        {
            bindColNameList();
            BindListbox();

        }
    }

    protected void GVResult_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow && e.Row.RowState == DataControlRowState.Normal)
        {
            e.Row.Attributes.Add("onMouseOver", "this.className='highlight'");
            e.Row.Attributes.Add("onMouseOut", "this.className='border'");
        }
        else if (e.Row.RowState == DataControlRowState.Alternate)
        {
            e.Row.Attributes.Add("onMouseOver", "this.className='highlight'");
            e.Row.Attributes.Add("onMouseOut", "this.className='border'");
        }
    }

    protected void btnSaveQuery_Click(object sender, EventArgs e)
    {
        if (txtQName.Text.Trim() == "")
        {
            txtQName.Text = "";
            txtQName.Focus();
            CreateMessageAlert(this.Page, "Please enter Query Name.");
        }
        else
        {
            string Alternate_Config_Code = "";
            for (int i = 0; i < chkAlternateLanguage.Items.Count; i++)
            {
                if (chkAlternateLanguage.Items[i].Selected == true)
                {
                    Alternate_Config_Code = Alternate_Config_Code + chkAlternateLanguage.Items[i].Value + ",";
                }
            }
            Alternate_Config_Code = Alternate_Config_Code.TrimEnd(',');
            if (Alternate_Config_Code != "")
                rptMain.Alternate_Config_Code = Alternate_Config_Code;
            rptMain.IntCode = (txtQid.Text.Trim() == "" ? 0 : Convert.ToInt32(txtQid.Text));
            rptMain.QueryName = txtQName.Text;
            rptMain.Business_Unit_Code = Convert.ToInt32(SelectedBusinessUnit);
            rptMain.InsertedBy = objLoginedUser.Users_Code;
            rptMain.Visibility = rblVisibility.SelectedValue;
            rptMain.Expired_Deals = ExpiredDeals ? "Y" : "N";
            rptMain.Theatrical_Territory = TheatricalTerritory ? "Y" : "N";
            rptMain.Security_Group_Code = objLoginedUser.Security_Group_Code.Value;

            if (rptMain.IntCode > 0)
                rptMain.IsDirty = true;

            try
            {
                rptMain.Save();
                rptMain = null;
                TransferAlertMessage("Query saved successfully.", "ReportList.aspx?View_Name=" + curVW + "&BusinessUnitCode=" + SelectedBusinessUnit
                    + "&Expired=" + ExpiredDeals + "&Theatrical=" + TheatricalTerritory);
            }
            catch (Exception ex)
            {
                if (ex.Message == "Duplicate Query Name")
                {
                    CreateMessageAlert(btnSaveQuery, "Duplicate Query Found!");
                    return;
                }
                else
                {
                    CreateMessageAlert(btnSaveQuery, "Sorry, unable to save query!");
                    return;
                }
            }
        }
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        rptMain = null;
        Response.Redirect("ReportList.aspx?View_Name=" + curVW + "&BusinessUnitCode=" + SelectedBusinessUnit
            + "&Expired=" + ExpiredDeals + "&Theatrical=" + TheatricalTerritory);
    }

    #endregion

    #region ------ Methods -----



    private void BindData(bool showSelectTbl)
    {
        try
        {
            BindCondtionList();

            StringBuilder sbHidID = new StringBuilder();
            StringBuilder sbHidUserText = new StringBuilder();
            StringBuilder sbHidStringAllCond = new StringBuilder();

            rptMain.AddGUI(htblCrit, sbHidID, sbHidUserText, sbHidStringAllCond, SelectedBusinessUnit, TheatricalTerritory, objLoginedUser.Users_Code);

            this.hidID.Value = sbHidID.ToString();
            this.hidStringAllCond.Value = sbHidStringAllCond.ToString();
            this.hidUserText.Value = sbHidUserText.ToString();
            this.txtQid.Text = rptMain.IntCode.ToString() == "0" ? hdnQID.Value : rptMain.IntCode.ToString();
            this.txtQName.Text = rptMain.QueryName == null ? hdnQName.Value : rptMain.QueryName;

            if (showSelectTbl)
                bindColNameList();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    private void bindColNameList()
    {
        if (hdnCol.Value != "")
            return;

        rptMain.GetColNameList();
        hdnCol.Value = "";

        List<ReportColumn> arrCols = rptMain._arrRptColumn;
        List<ReportColumn> arrRight = new List<ReportColumn>();

        for (int i = 0; i < arrCols.Count; i++)
        {
            ReportColumn objReportColumn = (ReportColumn)arrCols[i];
            AddDisplayColList(arrCols[i]);
        }

        if (txtQid.Text.Trim() == "")
            cbSelAll.Checked = true;
    }
    private void BindCondtionList()
    {
        ddlcolList.DataSource = rptMain.GetConditionList();
        ddlcolList.DataValueField = "attrib";
        ddlcolList.DataTextField = "val";
        ddlcolList.DataBind();
    }
    private void BindListbox()
    {
        string curVWList = "'" + curVW + "'";

        if (curVW.Contains("*"))
            curVWList = curVWList + ",'" + curVW.Substring(0, curVW.IndexOf("*")) + "'";

        string selectedCol = hdnCol.Value.ToString().Replace("~", ",").Trim(',');

        string strLCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N' and Alternate_Config_Code is null and view_Name in (" + curVWList + ") ",
               strRCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N'  and view_Name in (" + curVWList + ") ";

        strLCol += " AND Column_code NOT IN (" + (selectedCol == string.Empty ? "0" : selectedCol) + ")   ";
        strRCol += " AND Column_code IN (" + (selectedCol == string.Empty ? "0" : selectedCol) + ")  ";

        BindLST(lsCol, strLCol);
        BindLST(lsrCol, strRCol, selectedCol);
    }
    private void BindLST(ListBox lst, string Qry)
    {
        DataSet Ds = DatabaseBroker.ProcessSelectDirectly(Qry);
        lst.DataSource = Ds;
        lst.DataTextField = "display_Name";
        lst.DataValueField = "Column_code";
        lst.DataBind();
    }
    private void BindLST(ListBox lst, string Qry, string selectedCol)
    {
        string[] arrCol = selectedCol.Split(new char[] { ',' });

        if (arrCol.Length < 1)
        {
            BindLST(lst, Qry);
            return;
        }

        DataSet Ds = DatabaseBroker.ProcessSelectDirectly(Qry);
        List<AttribValue> arrAV = new List<AttribValue>();

        if (Ds.Tables.Count < 1 || Ds.Tables[0].Rows.Count < 1)
        {
            BindLST(lst, Qry);
            return;
        }

        foreach (string curID in arrCol)
        {
            foreach (DataRow ro in Ds.Tables[0].Rows)
            {
                if (curID == Convert.ToString(ro["Column_code"]))
                {
                    AttribValue av = new AttribValue(curID, Convert.ToString(ro["display_Name"]));
                    arrAV.Add(av);
                    break;
                }
            }
        }

        lst.DataSource = arrAV;
        lst.DataTextField = "Val";
        lst.DataValueField = "Attrib";
        lst.DataBind();
    }
    public void BindReport(ReportViewer rptViewer)
    {
        var rptCredetialList = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

        string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
        string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

        if (IsCredentialRequired.ToUpper() == "TRUE")
        {
            string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
            string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
            string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];

            rptViewer.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
        }

        rptViewer.Visible = true;
        rptViewer.ServerReport.Refresh();
        rptViewer.ProcessingMode = ProcessingMode.Remote;

        if (rptViewer.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
            rptViewer.ServerReport.ReportServerUrl = new Uri(ReportingServer);
    }

    private void AddDisplayHeader()
    {
        HtmlTableRow tr = new HtmlTableRow();
        tr.Style.Add("class", "tdHead");

        HtmlTableCell tdtxtDummy = new HtmlTableCell();
        tdtxtDummy.InnerHtml = "";
        tr.Cells.Add(tdtxtDummy);

        HtmlTableCell tdCb = new HtmlTableCell();
        tdCb.InnerHtml = "Select";
        tdCb.Style.Add("font-weight", "bold");
        tr.Cells.Add(tdCb);

        HtmlTableCell tdDispOrd = new HtmlTableCell();
        tdDispOrd.InnerHtml = "Select Order";
        tdDispOrd.Style.Add("font-weight", "bold");
        tr.Cells.Add(tdDispOrd);

        HtmlTableCell tdName = new HtmlTableCell();
        tdName.InnerHtml = "Column";
        tdName.Style.Add("font-weight", "bold");
        tr.Cells.Add(tdName);

        htblDisp.Rows.Add(tr);
    }
    private void AddDisplayColList(ReportColumn rc, int selectOrd, ref int selectOrdOnAdd)
    {
        HtmlTableRow tr = new HtmlTableRow();

        TextBox lblIntCode = new TextBox();
        lblIntCode.ID = "lbl_" + rc.NameInDb;
        lblIntCode.Text = rc.IntCode.ToString();
        lblIntCode.Style.Add("Display", "None");
        AddControlToTR(tr, lblIntCode);

        CheckBox cb = new CheckBox();
        cb.Text = "";
        cb.ID = "cb_" + rc.NameInDb;
        cb.Checked = rc.IsSelect;
        AddControlToTR(tr, cb);

        TextBox txtDispOrd = new TextBox();
        txtDispOrd.Width = Unit.Pixel(75);
        txtDispOrd.CssClass = "text1";
        txtDispOrd.ID = "txtdOrd_" + rc.NameInDb;

        if (txtQid.Text.Trim() == "")
            txtDispOrd.Text = selectOrdOnAdd.ToString();
        else
            if (rc.IntCode > 0)
            txtDispOrd.Text = rc.DisplayOrd.ToString();

        AddControlToTR(tr, txtDispOrd);

        Label lblColName = new Label();
        lblColName.Text = rc.DisplayName;
        AddControlToTR(tr, lblColName);

        if (rc.IsPartofSelectonly != "N")
        {
            tr.Visible = true;
            selectOrdOnAdd++;

            if (txtQid.Text.Trim() == "")
                cb.Checked = true;
        }
        else
        {
            tr.Visible = false;
        }

        htblDisp.Rows.Add(tr);
    }
    private void AddDisplayColList(ReportColumn rc)
    {
        if (rc.IsSelect)
            hdnCol.Value += rc.columnCode + "~";
    }
    private void AddControlToTR(HtmlTableRow tr, Control c)
    {
        HtmlTableCell tdCb = new HtmlTableCell();
        tdCb.Controls.Add(c);
        tr.Cells.Add(tdCb);
    }

    protected int GetDisplayOrder(ref int Display, ReportColumn RC)
    {
        foreach (ListItem IT in lsrCol.Items)
        {
            if (Convert.ToInt32(IT.Value) == RC.columnCode)
            {
                Display++;
                return Display;
            }
        }
        return 0;
    }
    private string GetDisplayNameForView(string vw_name)
    {
        if (vw_name.ToUpper() == "VW_ACQ_DEALS")
            return "Acquisition Deals";

        if (vw_name.ToUpper() == "VW_SYN_DEALS")
            return "Syndication Deal";

        if (vw_name.ToUpper() == "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*I")
            return "Availabilty";

        if (vw_name.ToUpper() == "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*D")
            return "Theatrical Availabilty";

        return vw_name;
    }
    private void GetReportQuery()
    {
        if (curVW.ToUpper() == "VW_MOVIE_RIGHTS_STATUS_AVAILABLE_REPORT*D")
            rptMain = new DomesticAvailQuery(curVW);
        else
            rptMain = new ReportQuery(curVW);
    }

    private void RegisterJS()
    {
        ddlcolList.Attributes.Add("onchange", "changedDivView(this)");


        if (Page.IsPostBack)
        {
            rptMain.Initialize(false);
            PopulateFromGUI();
        }

        litGetWidIDListForFocus.Text = rptMain.GetWidIDListForFocus();
        cbSelAll.Attributes.Add("onclick", "ToggleAll('" + cbSelAll.ClientID + "','" + htblDisp.ClientID + "')");


    }

    private void showResult(bool isTabChange, string isSort = "N")
    {
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
        string Err_filename = "WebPage_Log.txt";
        CommonUtil.WriteErrorLog("query report start show result", Err_filename);
        try
        {
            hdnFlag.Value = "true";
            imgresults.Attributes.Add("disabled", "true");
            imgresults.ImageUrl = "../images/resultOn.png";
            imgcriteria.Src = "../images/criteriaOff.png";
            imgcolumns.Src = "../images/columnsOff.png";

            try
            {
                string strSelect = "";
                string ColColumns = "";
                string strWhere1 = "'AND Business_Unit_Code = " + SelectedBusinessUnit + "'";

                string strOfGEC = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                var arrayStrGEC = strOfGEC.Split(',');
                var strGEC = String.Join(",", new Business_Unit_Service(ObjLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginedUser.Users_Code) && arrayStrGEC.Contains(x.Business_Unit_Code.ToString())).Select(x => x.Business_Unit_Code).ToList());

                string strWhere = string.Empty;
                if (SelectedBusinessUnit == "0")
                     strWhere = " AND Business_Unit_Code IN ( " + strGEC + ")";
                else
                     strWhere = " AND Business_Unit_Code = " + SelectedBusinessUnit;
                int ColCount = 0;
                DataSet ds = new DataSet();

                strSelect = rptMain.GetSelectedColumnList(isSort, out ColCount, out ColColumns);
                strWhere = rptMain.GetWhereCondition(strWhere);

                ColCount++;

                if (!ExpiredDeals)
                    strWhere += " AND Expired='N'";

                if (TheatricalTerritory)
                    strWhere += " AND Is_Theatrical_Right='Y'";
                else
                    strWhere += " AND Is_Theatrical_Right='N'";

                this.BindReport(ReportViewer1);
                ReportParameter[] parm = null;

                string ReportFolder = Convert.ToString(new GlobalParams().objLoginEntity.ReportingServerFolder);
                if (curVW.ToUpper() == "VW_ACQ_DEALS")
                {
                    parm = new ReportParameter[13];
                    parm[0] = new ReportParameter("Sql_Select", strSelect);
                    parm[1] = new ReportParameter("Sql_Where", strWhere);
                    parm[2] = new ReportParameter("Column_Count", ColCount.ToString());
                    parm[3] = new ReportParameter("Column_Names", ColColumns.ToString());
                    parm[4] = new ReportParameter("Is_Debug", "N");
                    // parm[5] = new ReportParameter("Report_Query_Code", isTabChange ? "0" : rptMain.IntCode.ToString());
                    parm[5] = new ReportParameter("Report_Query_Code", "0");
                    parm[6] = new ReportParameter("Subtitling_Codes", rptMain.Subtitle_Lang == "" ? " " : rptMain.Subtitle_Lang);
                    parm[7] = new ReportParameter("Dubbing_Codes", rptMain.Dubbing_Lang == "" ? " " : rptMain.Dubbing_Lang);
                    parm[8] = new ReportParameter("Country_Codes", rptMain.Country_Codes == "" ? " " : rptMain.Country_Codes);
                    parm[9] = new ReportParameter("Report_Header", "Acquisition Query Report");
                    parm[10] = new ReportParameter("Channel_Codes", rptMain.Channel_Codes == "" ? " " : rptMain.Channel_Codes);
                    parm[11] = new ReportParameter("Category_Codes", rptMain.Cat_Codes == "" ? " " : rptMain.Cat_Codes);
                    parm[12] = new ReportParameter("CBFCRating_Codes", rptMain.CBFC_Ratings_Codes == "" ? " " : rptMain.CBFC_Ratings_Codes);

                    if (ReportViewer1.ServerReport.ReportPath == "")
                    {
                        ReportViewer1.ServerReport.ReportPath = ReportFolder + "/rptAcquisition_Query";
                    }
                }
                else if (curVW.ToUpper() == "VW_SYN_DEALS")
                {
                    parm = new ReportParameter[11];
                    parm[0] = new ReportParameter("Sql_SELECT", strSelect);
                    parm[1] = new ReportParameter("Sql_WHERE", strWhere);
                    parm[2] = new ReportParameter("Column_Count", ColCount.ToString());
                    parm[3] = new ReportParameter("Column_Names", ColColumns.ToString());
                    parm[4] = new ReportParameter("Is_Debug", "N");
                    parm[5] = new ReportParameter("Report_Query_Code", isTabChange ? "0" : rptMain.IntCode.ToString());
                    parm[6] = new ReportParameter("Subtitling_Codes", rptMain.Subtitle_Lang == "" ? " " : rptMain.Subtitle_Lang);
                    parm[7] = new ReportParameter("Dubbing_Codes", rptMain.Dubbing_Lang == "" ? " " : rptMain.Dubbing_Lang);
                    parm[8] = new ReportParameter("Country_Codes", rptMain.Country_Codes == "" ? " " : rptMain.Country_Codes);
                    //parm[9] = new ReportParameter("Report_Header", "Syndication Query Report");
                    parm[9] = new ReportParameter("Category_Codes", rptMain.Cat_Codes == "" ? " " : rptMain.Cat_Codes);
                    parm[10] = new ReportParameter("CBFCRating_Codes", rptMain.CBFC_Ratings_Codes == "" ? " " : rptMain.CBFC_Ratings_Codes);

                    if (ReportViewer1.ServerReport.ReportPath == "")
                    {
                        ReportViewer1.ServerReport.ReportPath = ReportFolder + "/rptSyndication_Query";
                    }
                }

                CommonUtil.WriteErrorLog( "Report path = " + ReportFolder + "/rptSyndication_Query", Err_filename);
                ReportViewer1.ServerReport.SetParameters(parm);
                CommonUtil.WriteErrorLog("SetParameters", Err_filename);
                ReportViewer1.ServerReport.Refresh();
                CommonUtil.WriteErrorLog("Refresh", Err_filename);
            }
            catch (Exception ex)
            {
                lblrecordcount.Text = "Invalid query";
                lblrecordcount.ForeColor = System.Drawing.Color.Black;
            }

            BindData(false);
        }
        catch (Exception)
        {
            CreateMessageAlert(ddlcolList, "You do not have rights to execute this query");
            lblrecordcount.Visible = false;
        }
    }

    private void PopulateFromGUI()
    {
        rptMain.Initialize(false);
        List<ReportColumn> arrCols = rptMain._arrRptColumn;
        ReportColumn rc;
        int Displayorder = arrCols.Count;
        int dispOrd = 0;
        int sortOrd = 0;

        for (int i = 0; i < arrCols.Count; i++)
        {
            rc = arrCols[i];
            bool isEdit;
            bool isSel = ("~" + hdnCol.Value + "~").Contains("~" + rc.columnCode + "~");
            string strAgg = "";
            string tmpStr = "U";   // unsorted
            TextBox txt = (TextBox)Page.FindControl("txtdOrd_" + rc.NameInDb);

            if (isSel)
                dispOrd = ("~" + hdnCol.Value + "~").IndexOf("~" + rc.columnCode + "~");  //Shriyal 20110328

            if (txtQid.Text.Trim() == "0" || txtQid.Text.Trim() == "")
                isEdit = false;
            else
                isEdit = true;
            //public void Setup(bool pIsSelect, int pDisplayOrd, string pSortType, int pSortOrd, string pAggFunction, bool isEdit, int code)

            for (int SortCnt = 0; SortCnt < lsrCol.Items.Count; SortCnt++)
            {
                int tmpcount = 0;
                tmpcount = SortCnt;

                if (lsrCol.Items[SortCnt].Value == rc.columnCode.ToString())
                    sortOrd = tmpcount + 1;
            }

            arrCols[i].Setup(isSel, dispOrd, tmpStr, sortOrd, strAgg, isEdit, rc.IntCode);  //Abhaysingh 20142304 
        }

        rptMain._arrRptColumn = arrCols;//tushar
        rptMain.AddCondtionFromGUI(hidStringAllCond.Value);
    }

    private void PopulateAlternateLanguage()
    {
        string parameter_value = DatabaseBroker.ProcessScalarReturnString("select parameter_value from System_Parameter_New where parameter_name = 'Is_Allow_Multilanguage'");
        if (parameter_value == "Y")
        {
            DataSet Ds = DatabaseBroker.ProcessSelectDirectly("select Alternate_Config_Code , Alternate_Name from  Alternate_Config where Is_Active = 'Y'");
            foreach (DataTable table in Ds.Tables)
            {
                foreach (DataRow dr in table.Rows)
                {
                    ListItem item = new ListItem();
                    item.Text = dr["Alternate_Name"].ToString();
                    item.Value = dr["Alternate_Config_Code"].ToString();
                    // item.Selected = Convert.ToBoolean(dr["IsSelected"]);
                    chkAlternateLanguage.Items.Add(item);
                }
            }
        }
    }

    protected void chkAlternateLanguage_SelectedIndexChanged(object sender, EventArgs e)
    {
        string myCheckBoxes = string.Empty;

        foreach (ListItem aListItem in chkAlternateLanguage.Items)
        {
            if (aListItem.Selected)
            {
                myCheckBoxes = myCheckBoxes + aListItem.Value.ToString() + ',';
            }
        }
        myCheckBoxes = myCheckBoxes.TrimEnd(',');

        if (myCheckBoxes != "")
        {
            if (hdnCol.Value != "")
                hdnCol.Value = "";
            rptMain.GetAlternateColNameList(myCheckBoxes);
            hdnCol.Value = "";
            List<ReportColumn> arrCols = rptMain._arrRptColumn;
            List<ReportColumn> arrRight = new List<ReportColumn>();

            for (int i = 0; i < arrCols.Count; i++)
            {
                ReportColumn objReportColumn = (ReportColumn)arrCols[i];
                AddDisplayColList(arrCols[i]);
            }
            if (txtQid.Text.Trim() == "")
                cbSelAll.Checked = true;
            string curVWList = "'" + curVW + "'";
            if (curVW.Contains("*"))
                curVWList = curVWList + ",'" + curVW.Substring(0, curVW.IndexOf("*")) + "'";
            string selectedCol = hdnCol.Value.ToString().Replace("~", ",").Trim(',');
            string strLCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N'  and view_Name in (" + curVWList + ") And (Alternate_Config_Code is null or Alternate_Config_Code  in  (" + myCheckBoxes + "))",
                   strRCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N'  and view_Name in (" + curVWList + ") ";

            //strLCol += " AND Column_code NOT IN (" + (selectedCol == string.Empty ? "0" : selectedCol) + ")   ";
            //strRCol += " AND Column_code IN (" + (selectedCol == string.Empty ? "0" : selectedCol) + ")  ";
            DataSet Ds = DatabaseBroker.ProcessSelectDirectly(strLCol);
            lsCol.DataSource = Ds;
            lsCol.DataTextField = "display_Name";
            lsCol.DataValueField = "Column_code";
            lsCol.DataBind();

            if (lsrCol.Items.Count > 0)
                lsrCol.Items.Clear();

            lsrCol.DataSource = null;
            lsrCol.DataTextField = "display_Name";
            lsrCol.DataValueField = "Column_code";
            lsrCol.DataBind();

        }
        else
        {
            string curVWList = "'" + curVW + "'";
            if (curVW.Contains("*"))
                curVWList = curVWList + ",'" + curVW.Substring(0, curVW.IndexOf("*")) + "'";

            string selectedCol = hdnCol.Value.ToString().Replace("~", ",").Trim(',');
            string strLCol = " select *  from Report_Column_setup where 1=1 and IsPartofSelectOnly !='N' and Alternate_Config_Code is null and view_Name in (" + curVWList + ") ";
            BindLST(lsCol, strLCol);

            if (lsrCol.Items.Count > 0)
                lsrCol.Items.Clear();
            lsrCol.DataSource = null;
            lsrCol.DataTextField = "display_Name";
            lsrCol.DataValueField = "Column_code";
            lsrCol.DataBind();
        }
    }
    #endregion

}
