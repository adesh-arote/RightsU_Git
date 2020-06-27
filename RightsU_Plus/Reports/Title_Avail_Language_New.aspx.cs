using Microsoft.Reporting.WebForms;
using RightsU_BLL;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;
using RightsU_Entities;
using System.IO;
using System.Data.Entity.Core.Objects;
using System.Web.Mvc;

public partial class Title_Avail_Language_New : ParentPage
{
    public int PageNo
    {
        get
        {
            if (ViewState["PageNo"] == null)
                ViewState["PageNo"] = 1;
            return (int)ViewState["PageNo"];
        }
        set { ViewState["PageNo"] = value; }
    }
    public User objLoginedUser { get; set; }
    public static string Report_Folder { get; set; }
    protected string MaxSelectedOption;
    protected void Page_Load(object sender, EventArgs e)
    {
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
        ((Home)this.Page.Master).setVal("TitleAvailabilityReport");
        if (!IsPostBack)
        {
            Page.Header.DataBind();
            AddAttributes();
            string strTodaysDate = DBUtil.getServerDate().ToString("dd/MM/yyyy");
            Report_Folder = GlobalUtil.GetCurrentLoggedInEntity(objLoginUser);
            BindListBoxes();
            txtfrom.Text = strTodaysDate;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "InitializeStartDate", "InitializeStartDate();", true);
            ScheduleLi.Attributes["class"] = "active";
            BindGridView("S");
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "T", "AssignChosenJQuery();", true);
        }
        System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
        MaxSelectedOption = "1000";// objSystemParamService.SearchFor(p => p.Parameter_Name == "MaxSelectedOption").ToList().FirstOrDefault().Parameter_Value;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "sliceOption", "sliceOption();", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "sliceLanguageOption", "sliceLanguageOption();", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "toolbarCss", "Assign_Css();", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "chkAddYear", "chkAddYear();", true);
    }

    private void BindListBoxes()
    {
        BindddlBusiness_Unit();
        BindListMovie();
        BindTerritoryList();
        BindLanguageList();
    }
    private void BindddlBusiness_Unit()
    {
        ddlBusinessUnit.DataSource = new Business_Unit_Service(ObjLoginEntity.ConnectionStringName).SearchFor(b => b.Users_Business_Unit.Any(UB => UB.Business_Unit_Code == b.Business_Unit_Code && UB.Users_Code == objLoginedUser.Users_Code)).Select(R => new { Business_Unit_Code = R.Business_Unit_Code, Business_Unit_Name = R.Business_Unit_Name }).ToList();
        ddlBusinessUnit.DataTextField = "Business_Unit_Name";
        ddlBusinessUnit.DataValueField = "Business_Unit_Code";
        ddlBusinessUnit.DataBind();
    }
    private void AddAttributes()
    {
        txtSearch.Attributes.Add("OnKeyPress", "doNotAllowTag();fnEnterKey('" + btnSearch_plt.ClientID + "');");
    }

    protected void lnkbtnPltform_Click(object sender, EventArgs e)
    {
        txtSearch.Focus();
        txtSearch.Text = "";
        BindPlatform("");
        BindGridView(hdnTabVal.Value, false);
    }
    private void BindPlatform(string strSearch)
    {
        int[] arrPlatform = new Platform_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y"
                                                            && (p.Platform_Hiearachy.Contains(txtSearch.Text) || txtSearch.Text.Trim() == ""))
                                                            .Select(p => p.Platform_Code).Distinct().ToArray();
        if (arrPlatform.Count() > 0)
        {
            uctabPTV.PlatformCodes_Display = string.Join(",", arrPlatform);
            uctabPTV.PlatformCodes_Selected = hdnPlatform.Value.Split(',');
        }
        else
            uctabPTV.PlatformCodes_Display = "0";
        uctabPTV.PopulateTreeNode("N", txtSearch.Text.Trim());
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);
        //var rslt = string.Empty;
        //Platform_Service objPlatformService = new Platform_Service(objLoginEntity.ConnectionStringName);
        //rslt = string.Join(",", objPlatformService.SearchFor(p => p.Is_Active == "Y" && (p.Platform_Hiearachy.Contains(txtSearch.Text) || txtSearch.Text.Trim() == "")).Select(p => p.Platform_Code));
        //string[] selectedPlatforms = hdnPlatform.Value.Split(',');

        //uctabPTV.PlatformCodes_Selected = selectedPlatforms;
        //uctabPTV.PlatformCodes_Display = rslt;
        //btnSavePlatform.Visible = true;
        //uctabPTV.PopulateTreeNode("N", strSearch);
        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);

        //if (!string.IsNullOrEmpty(rslt))
        //{
        //    CreateMessageAlert("Please select atleast one platform");
        //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);
        //    return;
        //}
    }

    protected void btnSavePlatform_Click(object sender, EventArgs e)
    {
        hdnPlatform.Value = uctabPTV.PlatformCodes_Selected_Out;
        //if (hdnPlatform.Value == "" || hdnPlatform.Value.Trim() == "Platform / Rights")
        //{
        //    CreateMessageAlert("Please select atleast one platform");
        //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);
        //    return;
        //}
        if (!string.IsNullOrEmpty(uctabPTV.PlatformCodes_Selected_Out))
            lnkbtnPltform.Text = uctabPTV.PlatformCodes_Selected_Out.Split(',').Count() + " selected";
        else
            lnkbtnPltform.Text = "Select Platforms";
        //UpPlatformPopup.Update();
        upGridView.Update();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertKey", "ClosePopup();", true);
    }

    private void BindListMovie()
    {

        int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
        Title_Service titleService = new Title_Service(ObjLoginEntity.ConnectionStringName);
        var obj_Title = titleService.SearchFor(T => T.Is_Active == "Y" &&
                                                T.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code && AM.Acq_Deal.Is_Master_Deal == "Y")
                                                ).ToList();

        lsMovie.DataSource = obj_Title;
        lsMovie.DataTextField = "Title_Name";
        lsMovie.DataValueField = "Title_Code";
        lsMovie.DataBind();
    }

    public void BindTerritoryList()
    {
        Territory_Service territoryServiceInstance = new Territory_Service(ObjLoginEntity.ConnectionStringName);
        var countryList = territoryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Thetrical == "N").Select(c => new ListItem { Text = c.Territory_Name, Value = "T" + c.Territory_Code }).ToList();
        Country_Service countryServiceInstance = new Country_Service(ObjLoginEntity.ConnectionStringName);
        countryList.AddRange(countryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Theatrical_Territory == "N").Select(c => new ListItem { Text = c.Country_Name, Value = "C" + c.Country_Code }).ToList());
        lstLTerritory.DataSource = countryList;
        lstLTerritory.DataTextField = "Text";
        lstLTerritory.DataValueField = "Value";
        lstLTerritory.DataBind();
    }

    public void BindLanguageList()
    {
        Language_Group_Service langGroupServiceInstance = new Language_Group_Service(ObjLoginEntity.ConnectionStringName);
        var langList = langGroupServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Group_Name, Value = "G" + l.Language_Group_Code }).ToList();
        Language_Service langServiceInstance = new Language_Service(ObjLoginEntity.ConnectionStringName);
        langList.AddRange(langServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Name, Value = "L" + l.Language_Code }).ToList());
        lbLanguage.DataSource = langList;
        lbLanguage.DataTextField = "Text";
        lbLanguage.DataValueField = "Value";
        lbLanguage.DataBind();

    }

    protected void btnSearch_plt_Click(object sender, EventArgs e)
    {
        if (txtSearch.Text != "")
        {
            BindPlatform(txtSearch.Text.Trim());
        }
    }
    protected void btnShowAll_plt_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        BindPlatform("");
    }


    protected void dtLst_ItemCommand(object source, DataListCommandEventArgs e)
    {
        gvSchedule.EditIndex = -1;
        PageNo = Convert.ToInt32(e.CommandArgument);

        BindGridView(hdnTabVal.Value);

        //if (imgBtnSchedule.ImageUrl.ToUpper() == "../IMAGES/R_SCHEDULEDREPORT.JPG")
        //    BindGridView("S");
        //else
        //    BindGridView("Q");
    }
    protected void dtLst_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
        {
            Button btnPage = (Button)e.Item.FindControl("btnPager");
            if (PageNo == Convert.ToInt32(btnPage.CommandArgument))
            {
                btnPage.Enabled = false;
                btnPage.CssClass = "pagingbtn";
            }
        }
    }


    protected void gvSchedule_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            string intCode = gvSchedule.DataKeys[e.RowIndex].Values[0].ToString();

            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", 10);
            USP_Service objUSP = new USP_Service(ObjLoginEntity.ConnectionStringName);
           // objUSP.USP_Get_Title_Avail_Language_Data("D", objLoginedUser.Users_Code, intCode, 0, "", "", 0, objRecordCount, "", "", "");

            BindGridView("S");
        }
        catch (Exception) { }

    }

    protected void gvSchedule_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "DOWNLOAD":
                GridViewRow gvRow = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                string hlnkFileName = ((LinkButton)gvRow.FindControl("hlnkFileName")).Text;
                DownLoadFile(hlnkFileName);
                break;
            case "GENERATE":
                int rowIndex = int.Parse(e.CommandArgument.ToString());
                string intCode = gvSchedule.DataKeys[rowIndex]["Avail_Report_Schedule_Code"].ToString();
                RegenerateQuery(intCode);
                break;
        }
    }

    private void RegenerateQuery(string intCode)
    {
        try
        {
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", 10);
            USP_Service objUSP = new USP_Service(ObjLoginEntity.ConnectionStringName);
           // objUSP.USP_Get_Title_Avail_Language_Data("R", objLoginedUser.Users_Code, intCode, 0, "", "", 0, objRecordCount, "", "", "");
            CreateMessageAlert("Criteria queued successfully");
        }
        catch (Exception) { }

    }

    private void DownLoadFile(string fileName)
    {
        try
        {
            //System.IO.FileInfo flinf = new System.IO.FileInfo(Request.ServerVariables["APPL_PHYSICAL_PATH"].ToString() + "FileUpload" + "//" + folderNm + "/" + filePath);

            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            string filePath = objSystemParamService.SearchFor(p => p.Parameter_Name == "Title_Avail_Language_Report_DestinationFolder").ToList().FirstOrDefault().Parameter_Value;
            System.IO.FileInfo flinf = new System.IO.FileInfo(filePath + "\\" + fileName);
            if (flinf.Exists)
            {
                Response.Clear();
                Response.AppendHeader("content-disposition", "attachment; filename=" + fileName);
                Response.TransmitFile(flinf.FullName);
                Response.Flush();
                Response.End();
            }
            else
            {
                CreateMessageAlert(this, "Sorry, file is moved");
            }
        }
        catch (Exception ex)
        {
            CreateMessageAlert(this, ex.Message);
        }
    }

    private void BindGridView(string type, bool showNorecAlert = true)
    {
        if (PageNo == 0)
            PageNo = 1;

        hdnTabVal.Value = type;

        int pageSize = 10;
        int RecordCount = 0;
        string isPaging = "Y";
        string orderByCndition = "Acq_Deal_Code desc";

        ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
        USP_Service objUSP = new USP_Service(ObjLoginEntity.ConnectionStringName);

        string strFilter = " AND Report_Status <> 'X' AND User_Code = " + objLoginedUser.Users_Code;

        if (hdnTabVal.Value == "Q")
            strFilter = " AND User_Code = " + objLoginedUser.Users_Code + " AND ISNULL(ReportName, '') <> ''";

        //gvSchedule.DataSource = objUSP.USP_Get_Title_Avail_Language_Data("F", objLoginedUser.Users_Code, strFilter, PageNo, "", isPaging, pageSize, objRecordCount, "PR", "", "").ToList();
        RecordCount = Convert.ToInt32(objRecordCount.Value);
        GlobalUtil.ShowBatchWisePaging("", pageSize, 5, lblTotal, PageNo, dtLst, RecordCount);
        lblTotal.Text = RecordCount.ToString();
        gvSchedule.DataBind();

        if (RecordCount == 0 && showNorecAlert)
            CreateMessageAlert("No records found");

        if (hdnTabVal.Value == "Q")
        {
            gvSchedule.Columns[0].Visible = true;
            gvSchedule.Columns[11].Visible = false;
            gvSchedule.Columns[12].Visible = false;
            gvSchedule.Columns[13].Visible = false;
        }
        else
        {
            gvSchedule.Columns[0].Visible = false;
            gvSchedule.Columns[11].Visible = true;
            gvSchedule.Columns[12].Visible = true;
            gvSchedule.Columns[13].Visible = true;
        }

        //if (PageNo == 0)
        //    PageNo = 1;
        //Criteria objCri = new Criteria();
        //AvailReportSchedule objAvailReportSchedule = new AvailReportSchedule();

        //objCri.ClassRef = objAvailReportSchedule;
        //recordPerPage = 10;
        //objCri.IsPagingRequired = true;
        //objCri.RecordPerPage = recordPerPage;
        //objCri.RecordCount = GlobalUtil.ShowBatchWisePaging(objAvailReportSchedule, "", objCri.RecordPerPage, 5, lblTotal, PageNo, dtLst);
        //objCri.PageNo = PageNo;


        //ArrayList arr = objCri.Execute("");
        //gvSchedule.DataSource = arr;
        //gvSchedule.DataBind();
        //DBUtil.AddDummyRowIfDataSourceEmpty(gvSchedule, new AvailReportSchedule());
        upGridView.Update();
    }


    protected void btnSubmitReport_Click(object sender, EventArgs e)
    {
        StringBuilder sbMovie = new StringBuilder("");
        StringBuilder sbTerritory = new StringBuilder("");
        StringBuilder sbDubbingSubtitling = new StringBuilder("");
        StringBuilder sbLanguage = new StringBuilder("");

        //Get selected movies
        int[] selected_Movie = lsMovie.GetSelectedIndices();
        if (selected_Movie.Length > 0)
        {
            foreach (int index in selected_Movie)
            {
                int titleCode = Convert.ToInt32(lsMovie.Items[index].Value);
                if (sbMovie.Length == 0)
                    sbMovie.Append(titleCode);
                else
                    sbMovie.Append("," + titleCode);
            }
        }

        if (rblDateCriteria.SelectedValue == "FL") { tdAddYear.Style.Add("display", "block"); }
        else { tdAddYear.Style.Add("display", "none"); }


        //if (selected_Movie.Length == 0)
        //{
        //    CreateMessageAlert("Please select atleast one title.");
        //    return;
        //}

        if (!chkIsOriginalLanguage.Checked && chkDubbingSubtitling.SelectedIndex == -1)
        {
            CreateMessageAlert("Please select atleast one language type.");
            return;
        }

        //Get Selected Platform
        string SelectedPlatform = uctabPTV.PlatformCodes_Selected_Out;

        if (SelectedPlatform == string.Empty)
            SelectedPlatform = "";

        //Get selected countries
        int[] selected_Country = lstLTerritory.GetSelectedIndices();
        if (selected_Country.Length > 0)
        {
            foreach (int index in selected_Country)
            {
                string countryCode = lstLTerritory.Items[index].Value;
                if (sbTerritory.Length == 0)
                    sbTerritory.Append(countryCode);
                else
                    sbTerritory.Append("," + countryCode);
            }
        }

        //Get selected Language
        int[] selected_Language = lbLanguage.GetSelectedIndices();
        if (selected_Language.Length > 0)
        {
            foreach (int index in selected_Language)
            {
                string languageCode = lbLanguage.Items[index].Value;
                if (sbLanguage.Length == 0)
                    sbLanguage.Append(languageCode);
                else
                    sbLanguage.Append("," + languageCode);
            }
        }

        bool IsOriginalLanguage = chkIsOriginalLanguage.Checked;

        foreach (ListItem lst in chkDubbingSubtitling.Items)
        {
            if (lst.Selected)
            {
                if (sbMovie.Length == 0)
                    sbDubbingSubtitling.Append(lst.Value);
                else
                    sbDubbingSubtitling.Append("," + lst.Value);
            }
        }

        string startDate = string.Empty, endDate = string.Empty;
        startDate = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtfrom.Text.Trim()).ToString().Trim('\'')).ToString("yyyy-MM-dd");

        if (!string.IsNullOrEmpty(txtto.Text) && !txtto.Text.Trim().Equals("DD/MM/YYYY"))
            endDate = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtto.Text.Trim()).ToString().Trim('\'')).ToString("yyyy-MM-dd");
        else
            endDate = DateTime.MaxValue.ToString("yyyy-MM-dd");

        string strReportName = "";
        if (rdQueryYes.Checked)
            strReportName = txtReportName.Text.Trim();

        string strInsertVal = "'" + sbMovie.ToString() + "', '" + SelectedPlatform + "', '" + sbTerritory.ToString() + "', '" + IsOriginalLanguage.ToString() + "', '"
                                  + sbDubbingSubtitling.ToString() + "', '" + rdbGroupBy.SelectedValue + "', '" + rdlNode.SelectedValue + "', '"
                                  + sbLanguage.ToString() + "', '" + rblDateCriteria.SelectedValue + "', '" + startDate + "', '" + endDate + "', '"
                                  + objLoginedUser.Users_Code + "', GETDATE(), 'P', '', '"
                                  + chkShowRemarks.Checked.ToString() + "', 'N', 'PR', '" + strReportName + "'";

        try
        {
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", 10);
            USP_Service objUSP = new USP_Service(ObjLoginEntity.ConnectionStringName);
            //objUSP.USP_Get_Title_Avail_Language_Data("A", objLoginedUser.Users_Code, strInsertVal, 0, "", "", 0, objRecordCount, "", "", "");
        }
        catch (Exception) { }

        CreateMessageAlert("Criteria queued successfully");

        if (rdQueryYes.Checked)
        {
            BindGridView("Q");
            //imgBtnSchedule.ImageUrl = "../images/ScheduledReport.jpg";
            //imgBtnQuery.ImageUrl = "../images/r_SavedReport.jpg";
        }
        else
        {
            BindGridView("S");
            //imgBtnSchedule.ImageUrl = "../images/r_ScheduledReport.jpg";
            //imgBtnQuery.ImageUrl = "../images/SavedReport.jpg";
        }
    }

    protected void btnSearch_Click_OLD(object sender, EventArgs e)
    {
        StringBuilder sbMovie = new StringBuilder("0");
        StringBuilder sbTerritory = new StringBuilder("0");
        StringBuilder sbDubbingSubtitling = new StringBuilder("0");
        StringBuilder sbLanguage = new StringBuilder("0");

        //Get selected movies
        int[] selected_Movie = lsMovie.GetSelectedIndices();
        if (selected_Movie.Length > 0)
        {
            foreach (int index in selected_Movie)
            {
                int titleCode = Convert.ToInt32(lsMovie.Items[index].Value);
                if (sbMovie.Length == 0)
                    sbMovie.Append(titleCode);
                else
                    sbMovie.Append("," + titleCode);
            }
        }

        if (selected_Movie.Length == 0)
        {
            CreateMessageAlert("Please select atleast one title.");
            return;
        }

        if (!chkIsOriginalLanguage.Checked && chkDubbingSubtitling.SelectedIndex == -1)
        {
            CreateMessageAlert("Please select atleast one language type.");
            return;
        }

        //Get Selected Platform
        string SelectedPlatform = uctabPTV.PlatformCodes_Selected_Out;

        if (SelectedPlatform == string.Empty)
            SelectedPlatform = "0";

        //Get selected countries
        int[] selected_Country = lstLTerritory.GetSelectedIndices();
        if (selected_Country.Length > 0)
        {
            foreach (int index in selected_Country)
            {
                string countryCode = lstLTerritory.Items[index].Value;
                if (sbTerritory.Length == 0)
                    sbTerritory.Append(countryCode);
                else
                    sbTerritory.Append("," + countryCode);
            }
        }

        //Get selected Language
        int[] selected_Language = lbLanguage.GetSelectedIndices();
        if (selected_Language.Length > 0)
        {
            foreach (int index in selected_Language)
            {
                string languageCode = lbLanguage.Items[index].Value;
                if (sbLanguage.Length == 0)
                    sbLanguage.Append(languageCode);
                else
                    sbLanguage.Append("," + languageCode);
            }
        }

        bool IsOriginalLanguage = chkIsOriginalLanguage.Checked;

        foreach (ListItem lst in chkDubbingSubtitling.Items)
        {
            if (lst.Selected)
            {
                if (sbMovie.Length == 0)
                    sbDubbingSubtitling.Append(lst.Value);
                else
                    sbDubbingSubtitling.Append("," + lst.Value);
            }
        }

        string startDate = string.Empty, endDate = string.Empty;
        startDate = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtfrom.Text.Trim()).ToString().Trim('\'')).ToString("yyyy-MM-dd");

        if (!string.IsNullOrEmpty(txtto.Text) && !txtto.Text.Trim().Equals("DD/MM/YYYY"))
            endDate = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtto.Text.Trim()).ToString().Trim('\'')).ToString("yyyy-MM-dd");
        else
        {
            if (rblDateCriteria.SelectedValue == "FL" && chkAddYear.Checked)
                endDate = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtfrom.Text.Trim()).ToString().Trim('\'')).AddYears(1).ToString("yyyy-MM-dd");
            else
                endDate = DateTime.MaxValue.ToString("yyyy-MM-dd");
        }

        ReportCredential();
        ReportParameter[] parm = new ReportParameter[12];

        parm[0] = new ReportParameter("Title_Code", sbMovie.ToString());
        parm[1] = new ReportParameter("Platform_Code", SelectedPlatform);
        parm[2] = new ReportParameter("Country_Code", sbTerritory.ToString());
        parm[3] = new ReportParameter("Is_Original_Language", IsOriginalLanguage.ToString());
        parm[4] = new ReportParameter("Dubbing_Subtitling", sbDubbingSubtitling.ToString());
        parm[5] = new ReportParameter("GroupBy", rdbGroupBy.SelectedValue);
        parm[6] = new ReportParameter("Node", rdlNode.SelectedValue);
        parm[7] = new ReportParameter("Language_Code", sbLanguage.ToString());
        parm[8] = new ReportParameter("Date_Type", rblDateCriteria.SelectedValue);
        parm[9] = new ReportParameter("StartDate", startDate);
        parm[10] = new ReportParameter("EndDate", endDate);
        parm[11] = new ReportParameter("ShowRemark", chkShowRemarks.Checked.ToString());

        ReportViewer1.ServerReport.ReportPath = string.Empty;
        if (ReportViewer1.ServerReport.ReportPath == "")
        {
            ReportSetting objRS = new ReportSetting();
            ReportViewer1.ServerReport.ReportPath = objRS.GetReport("Title_Availability_Languagewise");
        }
        ReportViewer1.ServerReport.SetParameters(parm);
        ReportViewer1.ServerReport.Refresh();
    }

    public void ReportCredential()
    {
        var rptCredetialList = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

        string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
        string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

        if (IsCredentialRequired.ToUpper() == "TRUE")
        {
            string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
            string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
            string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];

            ReportViewer1.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
        }

        ReportViewer1.Visible = true;
        ReportViewer1.ServerReport.Refresh();
        ReportViewer1.ProcessingMode = ProcessingMode.Remote;
        if (ReportViewer1.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
        {
            ReportViewer1.ServerReport.ReportServerUrl = new Uri(ReportingServer);
        }
    }

    protected void btnback_Click(object sender, EventArgs e)
    {
        Response.Redirect("~\\Dashboard.aspx");
    }

    protected void ddlBusinessUnit_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindListMovie();
    }

    protected void chkAddYear_CheckedChanged(object sender, EventArgs e)
    {
        if (rblDateCriteria.SelectedValue == "FL" && chkAddYear.Checked)
            txtto.Text = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtfrom.Text.Trim()).ToString().Trim('\'')).AddYears(1).ToString("dd/MM/yyyy");
        else
            txtto.Text = string.Empty;
    }

    protected void gvSchedule_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
           (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
        {
            LinkButton hlnkFileName = e.Row.FindControl("hlnkFileName") as LinkButton;
            ScriptManager.GetCurrent(this).RegisterPostBackControl(hlnkFileName);

            Label lblAvail_Report_Schedule_Code = e.Row.FindControl("lblAvail_Report_Schedule_Code") as Label;
            Label lblReport_Status = e.Row.FindControl("lblReport_Status") as Label;
            Label lblFileName = e.Row.FindControl("lblFileName") as Label;
            Label lblMailSent = e.Row.FindControl("lblMailSent") as Label;

            string intCode = gvSchedule.DataKeys[e.Row.RowIndex].Values[0].ToString();

            //if (hdnTabVal.Value == "S")
            //{
            //    string strScript = "refreshStatus('" + lblReport_Status.ClientID + "', '" + lblFileName.ClientID + "', '" + lblMailSent.ClientID + "', " + intCode + ", '" + lblAvail_Report_Schedule_Code.ClientID + "');";
            //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertKey" + intCode, strScript, true);
            //}

            Button btnDelete = e.Row.FindControl("btnDelete") as Button;
            Button btnGenerate = e.Row.FindControl("btnGenerate") as Button;

            if (hdnTabVal.Value == "Q")
            {
                btnGenerate.Visible = true;
                btnDelete.Visible = false;
            }
            else
            {
                btnDelete.Visible = true;
                btnGenerate.Visible = false;
            }
        }
    }

    protected void rblDateCriteria_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rblDateCriteria.SelectedValue.ToUpper() == "FI")
        {
            chkAddYear.Checked = false;
            chkAddYear.Enabled = false;
        }
        else
            chkAddYear.Enabled = true;

        BindGridView(hdnTabVal.Value, false);
        upGridView.Update();
    }

    protected void imgBtnSchedule_Click(object sender, EventArgs e)
    {
        PageNo = 1;
        hdnTabVal.Value = "S";
        BindGridView("S");
        //imgBtnSchedule.ImageUrl = "../images/r_ScheduledReport.jpg";
        //imgBtnQuery.ImageUrl = "../images/SavedReport.jpg";
    }

    protected void imgBtnQuery_Click(object sender, EventArgs e)
    {
        PageNo = 1;
        hdnTabVal.Value = "Q";
        BindGridView("Q");
        //imgBtnSchedule.ImageUrl = "../images/ScheduledReport.jpg";
        //imgBtnQuery.ImageUrl = "../images/r_SavedReport.jpg";
    }

    protected void btnSchedule_Click(object sender, EventArgs e)
    {
        PageNo = 1;
        hdnTabVal.Value = "S";
        BindGridView("S");
        ScheduleLi.Attributes["class"] = "active";
        QueryLi.Attributes.Remove("class");
    }

    protected void btnQuery_Click(object sender, EventArgs e)
    {
        PageNo = 1;
        hdnTabVal.Value = "Q";
        BindGridView("Q");
        QueryLi.Attributes["class"] = "active";
        ScheduleLi.Attributes.Remove("class");
    }

    //protected void Timer1_Tick(object sender, EventArgs e)
    //{
    //    BindGridView();
    //}

}
