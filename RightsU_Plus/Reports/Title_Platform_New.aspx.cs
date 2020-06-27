using Microsoft.Reporting.WebForms;
using RightsU_BLL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;
using RightsU_Entities;

namespace RightsU_Plus.Reports
{
    public partial class Title_Platform_New : ParentPage
    {
        
        #region --- Properties ---
        protected string MaxSelectedOption;
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
        public int TotalPages
        {
            get
            {
                if (ViewState["TotalPages"] == null)
                    ViewState["TotalPages"] = 1;
                return (int)ViewState["TotalPages"];
            }
            set { ViewState["TotalPages"] = value; }
        }
        private List<int> lstTitleCode
        {
            get
            {
                if (Session["lstTitleCode"] == null)
                    Session["lstTitleCode"] = new List<int>();
                return (List<int>)Session["lstTitleCode"];
            }
            set
            {
                Session["lstTitleCode"] = value;
            }

        }
        public string Is_Restriction_Remarks
        {
            get
            {
                if (ViewState["Is_Restriction_Remarks"] == null)
                    ViewState["Is_Restriction_Remarks"] = string.Empty;
                return (string)ViewState["Is_Restriction_Remarks"];
            }
            set { ViewState["Is_Restriction_Remarks"] = value; }
        }
        private string gridViewSortExpression
        {
            get
            {
                if (Session["TitleSortExpression"] == null)
                    Session["TitleSortExpression"] = "Last_UpDated_Time";

                return (string)Session["TitleSortExpression"];
            }
            set { Session["TitleSortExpression"] = value; }
        }
        public string gridViewSortDirection
        {
            get
            {
                if (Session["TitleSortDirection"] == null)
                    Session["TitleSortDirection"] = "Desc";

                return (string)Session["TitleSortDirection"];
            }
            set { Session["TitleSortDirection"] = value; }
        }
        #endregion

        public User objLoginedUser { get; set; }
        #region --- Page Events ---
        protected void Page_Load(object sender, EventArgs e)
        {
            objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
            if (!IsPostBack)
            {
                AddAttributes();
                BindAllListBox();
                lstTitleCode = new List<int>();
                string strTodaysDate = DBUtil.getServerDate().ToString("dd/MM/yyyy");
                txtfrom.Text = strTodaysDate;
                txtYears.Text = "1";
                btnPlatformTab.Attributes.Add("class", "tabCountry");
                btnPlatformGroupTab.Attributes.Add("class", "tabTerritory");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "InitializeStartDate", "InitializeStartDate();", true);
                hdnIsCriteriaChange.Value = "N";
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "T", "AssignChosenJQuery();", true);
            }

            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            MaxSelectedOption = objSystemParamService.SearchFor(p => p.Parameter_Name == "MaxSelectedOption").ToList().FirstOrDefault().Parameter_Value;
            Is_Restriction_Remarks = objSystemParamService.SearchFor(p => p.Parameter_Name == "Is_Restriction_Remarks").ToList().FirstOrDefault().Parameter_Value;
            if (Is_Restriction_Remarks == "Y")
            {
                chkRestRemarks.Checked = true;
                chkRestRemarks.Enabled = false;
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "toolbarCss", "Assign_Css();", true);
        }
        #endregion

        #region --- Tab Click Events ----
        protected void imgCriteria_Click(object sender, ImageClickEventArgs e)
        {
            imgCriteriaOn.Visible = true;
            imgCriteria.Visible = false;
            imgResultsOn.Visible = false;
            imgResults.Visible = true;
        }
        protected void imgResults_Click(object sender, ImageClickEventArgs e)
        {
            imgCriteriaOn.Visible = false;
            imgCriteria.Visible = true;
            imgResultsOn.Visible = true;
            imgResults.Visible = false;
            if (hdnIsCriteriaChange.Value == "Y")
            {
                ShowResults();
                hdnIsCriteriaChange.Value = "N";
            }
        }
        #endregion

        #region --- Binding and Normal Methods ---
        private void BindAllListBox()
        {
            #region --- Bind SubL icensing ---
            Sub_License_Service subLicenseServiceInstance = new Sub_License_Service(ObjLoginEntity.ConnectionStringName);
            var sublicList = subLicenseServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Sub_License_Name, Value = l.Sub_License_Code.ToString() }).ToList();
            lbSubLicense.DataSource = sublicList;
            lbSubLicense.DataTextField = "Text";
            lbSubLicense.DataValueField = "Value";
            lbSubLicense.DataBind();
            #endregion

            #region --- Bind Business Unit ---
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            string SelectedBU = objSystemParamService.SearchFor(p => p.Parameter_Name == "PlatformWise_Neo_BU").ToList().FirstOrDefault().Parameter_Value;
            string[] arr_BU_Codes = SelectedBU.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            ddlBusinessUnit.DataSource = new Business_Unit_Service(ObjLoginEntity.ConnectionStringName).SearchFor(b => b.Users_Business_Unit.Any(UB => UB.Business_Unit_Code == b.Business_Unit_Code) // && UB.Users_Code == objLoginUser.IntCode, Commented by Abhay
                && arr_BU_Codes.Contains(b.Business_Unit_Code.ToString())).Select(R => new { Business_Unit_Code = R.Business_Unit_Code, Business_Unit_Name = R.Business_Unit_Name }).ToList();
            ddlBusinessUnit.DataTextField = "Business_Unit_Name";
            ddlBusinessUnit.DataValueField = "Business_Unit_Code";
            ddlBusinessUnit.DataBind();
            #endregion

            BindListMovie(); // getting called from multiple place

            #region --- Bind Territory ---
            Territory_Service territoryServiceInstance = new Territory_Service(ObjLoginEntity.ConnectionStringName);
            ddlTerritory.DataSource = territoryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Thetrical == "N").Select(c => new ListItem { Text = c.Territory_Name, Value = "T" + c.Territory_Code }).ToList();
            ddlTerritory.DataTextField = "Text";
            ddlTerritory.DataValueField = "Value";
            ddlTerritory.DataBind();
            ddlTerritory.Items.Insert(0, new ListItem { Text = "--Please Select", Value = "0" });
            #endregion

            #region --- Bind Country ---
            Country_Service countryServiceInstance = new Country_Service(ObjLoginEntity.ConnectionStringName);
            var countryList = countryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Theatrical_Territory == "N").Select(c => new ListItem { Text = c.Country_Name, Value = c.Country_Code.ToString() }).OrderBy(l => l.Text).ToList();
            lstLTerritory.DataSource = countryList;
            lstLTerritory.DataTextField = "Text";
            lstLTerritory.DataValueField = "Value";
            lstLTerritory.DataBind();
            #endregion

            Language_Service objLanguage_Service = new Language_Service(ObjLoginEntity.ConnectionStringName);

            #region --- Bind Title Language ---
            Title_Service objTitle_Service = new Title_Service(ObjLoginEntity.ConnectionStringName);
            List<int> lstTitleLanguageCode = objTitle_Service.SearchFor(t => t.Title_Language_Code != null).Select(t => t.Title_Language_Code.Value).Distinct().ToList();
            var langList = objLanguage_Service.SearchFor(l => l.Is_Active == "Y" && lstTitleLanguageCode.Contains(l.Language_Code)).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }).ToList();
            lbTitleLang.DataSource = langList;
            lbTitleLang.DataTextField = "Text";
            lbTitleLang.DataValueField = "Value";
            lbTitleLang.DataBind();
            #endregion

            #region --- Bind Sub Title Language ---
            lbSubtitling.DataSource = objLanguage_Service.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Name, Value = "L" + l.Language_Code }).OrderBy(l => l.Text).ToList();
            lbSubtitling.DataTextField = "Text";
            lbSubtitling.DataValueField = "Value";
            lbSubtitling.DataBind();
            #endregion

            #region --- Bind Dub Language ---
            lbDubbing.DataSource = lbSubtitling.DataSource;
            lbDubbing.DataTextField = "Text";
            lbDubbing.DataValueField = "Value";
            lbDubbing.DataBind();
            #endregion

            BindPlatform(""); // getting called from multiple place

            #region --- Bind Platform Group ---
            ddlPlatformGroup.DataSource = new Platform_Group_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Platform_Group_Code != 0 && p.Is_Active == "Y").Select(R => new { Platform_Group_Value = R.Platform_Group_Code, Platform_Group_Name = R.Platform_Group_Name }).Distinct().ToList();
            ddlPlatformGroup.DataTextField = "Platform_Group_Name";
            ddlPlatformGroup.DataValueField = "Platform_Group_Value";
            ddlPlatformGroup.DataBind();
            ddlPlatformGroup.Items.Insert(0, new ListItem { Text = "--Please Select--", Value = "0" });
            #endregion
        }
        private void BindPlatform(string strSearch)
        {
            int[] arrPlatform;
            arrPlatform = new Platform_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y"
                                                                               && (p.Platform_Hiearachy.Contains(strSearch) || strSearch == ""))
                                                                              .Select(p => p.Platform_Code).Distinct().ToArray();
            if (arrPlatform.Count() > 0)
            {
                uctabPTV.PlatformCodes_Display = string.Join(",", arrPlatform);
                uctabPTV.PlatformCodes_Selected = hdnPlatform.Value.Split(',');
            }
            else
                uctabPTV.PlatformCodes_Display = "0";

            uctabSelectedplt.PlatformCodes_Display = "0";
            uctabPTV.PopulateTreeNode("N", strSearch);
            uctabSelectedplt.PopulateTreeNode("N", strSearch);
        }
        private void BindListMovie()
        {
            int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
            Title_Service titleService = new Title_Service(ObjLoginEntity.ConnectionStringName);

            var obj_Title = titleService.SearchFor(T => false).ToList();

            if (ddlReportFor.SelectedValue == "A")
            {

                obj_Title = titleService.SearchFor(T => T.Is_Active == "Y" &&
                                                        T.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code && AM.Acq_Deal.Is_Master_Deal == "Y")
                                                        ).OrderBy(t => t.Title_Name).ToList();
            }
            else
            {
                obj_Title = titleService.SearchFor(T => T.Is_Active == "Y" &&
                                        T.Syn_Deal_Movie.Any(SDM => SDM.Syn_Deal.Business_Unit_Code == BU_Code)
                                        ).OrderBy(t => t.Title_Name).ToList();
            }

            lsMovie.DataSource = obj_Title;
            lsMovie.DataTextField = "Title_Name";
            lsMovie.DataValueField = "Title_Code";
            lsMovie.DataBind();
        }
        private void BindGridMovie()
        {
            int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
            string SearchString = "";
            Title objTitle = new Title();
            Criteria objCrt = new Criteria();

            objCrt.ClassRef = objTitle;
            objCrt.IsPagingRequired = false;
            objCrt.IsSubClassRequired = true;
            string strSearch = "";
            SearchString = " AND IS_Active='Y' AND Title_Code IN (SELECT adm.Title_Code FROM Acq_Deal_Movie adm INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adm.Acq_Deal_Code WHERE ad.Is_Master_Deal='Y' AND ad.Business_Unit_Code=" + BU_Code + ")";

            if (!txtSearch.Text.Contains(","))
            {
                strSearch = txtSearch.Text.Trim();
                SearchString += " AND ((Title_Name like '%" + strSearch + "%') OR (Year_Of_Production like '%" + strSearch + "%') ";
                SearchString += " OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg INNER JOIN Genres g on  g.Genres_Code = tg.Genres_Code where g.Genres_Name like '%" + strSearch + "%')";
                SearchString += " OR Title_Code IN (Select tt.Title_Code from Title_Talent tt INNER JOIN Talent t on t.Talent_Code = tt.Talent_Code WHERE t.Talent_Name like '%" + strSearch + "%')";
                SearchString += " OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN "
                                  + " (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv WHERE ecv.Columns_Value LIKE '%" + strSearch + "%'))";
                SearchString += " )";
            }
            else
                if (txtSearch.Text != string.Empty)
                {
                    strSearch = "Select number from dbo.fn_Split_withdelemiter('" + txtSearch.Text.Trim() + "',',')";
                    SearchString += " AND ((Title_Name IN (" + strSearch + ")) OR (Year_Of_Production IN (" + strSearch + " where ISNUMERIC(number) = 1)) ";
                    SearchString += " OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg INNER JOIN Genres g on  g.Genres_Code = tg.Genres_Code where g.Genres_Name IN (" + strSearch + "))";
                    SearchString += " OR Title_Code IN (Select tt.Title_Code from Title_Talent tt INNER JOIN Talent t on t.Talent_Code = tt.Talent_Code WHERE t.Talent_Name IN (" + strSearch + "))";
                    SearchString += " OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN "
                                      + " (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv WHERE ecv.Columns_Value IN (" + strSearch + ")))";
                    SearchString += " )";
                }

            int RecordPerPage = 10;
            object[] arr = objCrt.Execute(SearchString).ToArray();
            int RecordCount = arr.Count();
            TotalPages = RecordCount / RecordPerPage;
            TotalPages = TotalPages + (((RecordCount % RecordPerPage) > 0) ? 1 : 0);
            GlobalUtil.ShowBatchWisePaging(SearchString, 10, 5, lblTotal_ErrorPopup, PageNo, dtLst_ErrorPopup, RecordCount);

            objCrt.RecordCount = RecordCount;
            objCrt.PageNo = 1;

            objTitle.OrderByColumnName = gridViewSortExpression;
            objTitle.OrderByCondition = gridViewSortDirection;


            int noOfRecordSkip = RecordPerPage * (PageNo - 1);
            int noOfRecordTake = 0;
            if (RecordCount < (noOfRecordSkip + RecordPerPage))
                noOfRecordTake = RecordCount - noOfRecordSkip;
            else
                noOfRecordTake = RecordPerPage;

            gvTitle.DataSource = arr.Skip(noOfRecordSkip).Take(noOfRecordTake);
            gvTitle.DataBind();

            if (gvTitle.Rows.Count == 0)
            {
                DBUtil.AddDummyRowIfDataSourceEmpty(gvTitle, new Title());
                CreateMessageAlert("No records found");
            }
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "SelectTitles", "SelectTitles();", true);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);
        }

        private void AddAttributes()
        {
            txtSearch.Attributes.Add("OnKeyPress", "doNotAllowTag();fnEnterKey('" + btnSearch_tit.ClientID + "');");
        }
        protected void ResetSelectedPlatform()
        {
            uctabSelectedplt.PlatformCodes_Display = "0";
            uctabSelectedplt.PopulateTreeNode("N", "");
            chkExact.SelectedIndex = -1;
            upExact.Update();
            upSelectedPlatform.Update();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        #endregion

        #region --- Index Changed Events ---
        protected void ddlBusinessUnit_SelectedIndexChanged(object sender, EventArgs e)
        {
            hdnIsCriteriaChange.Value = "Y";
            BindListMovie();
        }
        protected void ddlReportFor_SelectedIndexChanged(object sender, EventArgs e)
        {
            hdnIsCriteriaChange.Value = "Y";
            BindListMovie();

            if (ddlReportFor.SelectedValue == "A")
                chkIncludeSubDeal.Visible = true;
            else
                chkIncludeSubDeal.Visible = false;
        }
        protected void ddlPlatformGroup_SelectedIndexChanged(object sender, EventArgs e)
        {
            divPlatformGroup.Attributes.Add("style", "display:block;");
            divPlatformFilter.Attributes.Add("style", "display:none;");
            if (ddlPlatformGroup.SelectedValue != "0")
            {
                int ddlPlatformGroupValue = Convert.ToInt32(ddlPlatformGroup.SelectedValue);
                //List<string> platformGroupId = new Platform_Module_Config_Service().SearchFor(p => p.Platform_Type == ddlPlatformGroup.SelectedValue).Select(p => p.Platform_Code.Value.ToString()).ToList();
                List<string> platformGroupId = new Platform_Group_Details_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Platform_Group_Code == ddlPlatformGroupValue)
                                                                            .Select(p => p.Platform_Code.ToString()).Distinct().ToList();
                uctabPTV.PlatformCodes_Display = string.Join(",", platformGroupId);
                uctabPTV.PlatformCodes_Selected = platformGroupId.ToArray();
            }
            else
                uctabPTV.PlatformCodes_Display = "0";

            uctabPTV.PopulateTreeNode("N", txtSelectedPlatformSearch.Text.Trim());
            ResetSelectedPlatform();
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        protected void chkExact_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedPlatform = uctabPTV.PlatformCodes_Selected_Out;
            if (selectedPlatform != "")
                uctabSelectedplt.PlatformCodes_Display = selectedPlatform;
            else
                uctabSelectedplt.PlatformCodes_Display = "0";
            if (chkExact.SelectedValue == "MH")
                uctabSelectedplt.PopulateTreeNode("N", txtSelectedPlatformSearch.Text.Trim());
            else
                uctabSelectedplt.PopulateTreeNode("Y", txtSelectedPlatformSearch.Text.Trim());

            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        #endregion

        #region --- Button Click Events ---
        protected void lbSelectTitles_Click(object sender, EventArgs e)
        {
            txtSearch.Focus();
            hdnTitleCodes.Value = hdnTitleCodes.Value.Trim(',');
            lstTitleCode = new List<int>();
            if (hdnTitleCodes.Value != "")
            {
                foreach (string s in hdnTitleCodes.Value.Split(','))
                {
                    lstTitleCode.Add(Convert.ToInt32(s));
                }
            }
            if (txtSearch.Text != "")
                BindGridMovie();
            else
                DBUtil.AddDummyRowIfDataSourceEmpty(gvTitle, new Title());
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);

        }
        protected void btnSaveTitle_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow gvrow in gvTitle.Rows)
            {
                CheckBox myCheckBox = (CheckBox)gvrow.FindControl("chkSelect");
                Label lblIntCode = (Label)gvrow.FindControl("lblIntCode");
                int code = Convert.ToInt32(lblIntCode.Text);
                if (myCheckBox.Checked)
                {
                    if (!lstTitleCode.Contains(code))
                        lstTitleCode.Add(code);

                }
                else
                {
                    if (lstTitleCode.Contains(code))
                        lstTitleCode.Remove(code);
                }
            }

            if (lstTitleCode.Count != 0)
            {
                hdnTitleCodes.Value = string.Join(",", lstTitleCode);
                hdnIsCriteriaChange.Value = "Y";
                upTitle.Update();
                string strMessage = String.Empty;

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertKey", "ClosePopup();", true);
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);
                CreateMessageAlert("Please select title");
            }
        }
        protected void btnSearch_tit_Click(object sender, EventArgs e)
        {
            PageNo = 1;
            if (txtSearch.Text != "")
            {
                BindGridMovie();
            }
        }
        protected void btnShowAll_tit_Click(object sender, EventArgs e)
        {
            PageNo = 1;
            txtSearch.Text = "";
            BindGridMovie();
        }

        protected void btnSearchPlatform_Click(object sender, EventArgs e)
        {
            if (txtPlatformSearch.Text != "")
            {
                BindPlatform(txtPlatformSearch.Text.Trim());
            }
            divPlatformFilter.Attributes.Add("style", "display:block;");
            divPlatformGroup.Attributes.Add("style", "display:none;");
            ddlPlatformGroup.SelectedValue = "0";
            ResetSelectedPlatform();
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        protected void btnShowAllPlatform_Click(object sender, EventArgs e)
        {
            txtPlatformSearch.Text = "";
            BindPlatform("");
            divPlatformFilter.Attributes.Add("style", "display:block;");
            divPlatformGroup.Attributes.Add("style", "display:none;");
            ddlPlatformGroup.SelectedValue = "0";
            ResetSelectedPlatform();
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        protected void btnShowAllPlatform_Selected_Click(object sender, EventArgs e)
        {
            txtSelectedPlatformSearch.Text = "";
            string selectedPlatform = uctabPTV.PlatformCodes_Selected_Out;
            if (selectedPlatform != "")
                uctabSelectedplt.PlatformCodes_Display = selectedPlatform;
            else
                uctabSelectedplt.PlatformCodes_Display = "0";
            if (chkExact.SelectedValue == "MH")
                uctabSelectedplt.PopulateTreeNode("N", "");
            else
                uctabSelectedplt.PopulateTreeNode("Y", "");
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        protected void btnSearchPlatform_Selected_Click(object sender, EventArgs e)
        {

            List<int> lstPlatforms = (uctabPTV.PlatformCodes_Selected_Out != "") ? uctabPTV.PlatformCodes_Selected_Out.Split(',').Select(s => Convert.ToInt32(s)).ToList() : new List<int>();
            int[] arrPlatform;
            arrPlatform = new Platform_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y"
                                                                               && (p.Platform_Hiearachy.Contains(txtSelectedPlatformSearch.Text.Trim()) || txtSelectedPlatformSearch.Text.Trim() == "") && lstPlatforms.Contains(p.Platform_Code))
                                                                              .Select(p => p.Platform_Code).Distinct().ToArray();
            if (arrPlatform.Length != 0)
                uctabSelectedplt.PlatformCodes_Display = string.Join(",", arrPlatform);
            else
                uctabSelectedplt.PlatformCodes_Display = "0";
            if (chkExact.SelectedValue == "MH")
                uctabSelectedplt.PopulateTreeNode("N", txtSelectedPlatformSearch.Text.Trim());
            else
                uctabSelectedplt.PopulateTreeNode("Y", txtSelectedPlatformSearch.Text.Trim());
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        protected void btnPlatformTab_Click(object sender, EventArgs e)
        {
            txtPlatformSearch.Text = "";
            BindPlatform("");
            divPlatformFilter.Attributes.Add("style", "display:block;");
            divPlatformGroup.Attributes.Add("style", "display:none;");
            ddlPlatformGroup.SelectedIndex = -1;
            btnPlatformTab.Attributes.Add("class", "tabCountry");
            btnPlatformGroupTab.Attributes.Remove("class");
            btnPlatformGroupTab.Attributes.Add("class", "tabTerritory");
            upMainPlatform.Update();

            ResetSelectedPlatform();
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        protected void btnPlatformGroupTab_Click(object sender, EventArgs e)
        {
            ddlPlatformGroup.SelectedIndex = -1;
            uctabPTV.PlatformCodes_Display = "0";
            uctabPTV.PopulateTreeNode("N", txtSelectedPlatformSearch.Text.Trim());
            divPlatformFilter.Attributes.Add("style", "display:none;");
            divPlatformGroup.Attributes.Add("style", "display:block;");
            btnPlatformGroupTab.Attributes.Add("class", "tabCountry");
            btnPlatformTab.Attributes.Remove("class");
            btnPlatformTab.Attributes.Add("class", "tabTerritory");
            upMainPlatform.Update();
            ResetSelectedPlatform();
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }
        #endregion

        #region --- Bind Report ---
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
        protected void ShowResults()
        {
            StringBuilder sbMovie = new StringBuilder("0");
            StringBuilder sbTitleLanguage = new StringBuilder("0");
            StringBuilder sbTerritory = new StringBuilder("0");
            StringBuilder sbSublicensing = new StringBuilder("0");
            // StringBuilder sbDubbingSubtitling = new StringBuilder("0");
            StringBuilder sbDubbingLanguage = new StringBuilder("0");
            StringBuilder sbSubtitlingLanguage = new StringBuilder("0");
            // StringBuilder sbExludedCountries = new StringBuilder("0");
            // StringBuilder sbMustHaveCountries = new StringBuilder("0");

            string StartDate, EndDate, StartMonth, EndYear;
            string Dubbing_Subtitling = "0";

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

            //Get Selected Platform
            string SelectedPlatform = hdnPlatform.Value; ;
            if (SelectedPlatform == string.Empty)
                SelectedPlatform = "0";

            //Get Title Language
            int[] selected_Title_Language = lbTitleLang.GetSelectedIndices();
            if (selected_Title_Language.Length > 0)
            {
                foreach (int index in selected_Title_Language)
                {
                    int titleLanguageCode = Convert.ToInt32(lbTitleLang.Items[index].Value);
                    if (sbTitleLanguage.Length == 0)
                        sbTitleLanguage.Append(titleLanguageCode);
                    else
                        sbTitleLanguage.Append("," + titleLanguageCode);
                }
            }

            if (rblPeriodType.SelectedValue != "MI")
            {
                StartDate = txtfrom.Text;
                EndDate = (txtto.Text == "DD/MM/YYYY" || txtto.Text == "") ? DateTime.MaxValue.ToString("dd/MM/yyyy") : txtto.Text;
                StartMonth = "0";
                EndYear = "0";
            }
            else
            {
                StartDate = spStartDate.Text;
                EndDate = spEndDate.Text;
                StartMonth = "0";
                EndYear = "0";
            }

            //Get Sublicensing
            int[] selected_Sublicensing = lbSubLicense.GetSelectedIndices();
            if (selected_Sublicensing.Length > 0)
            {
                foreach (int index in selected_Sublicensing)
                {
                    int sublicenseCode = Convert.ToInt32(lbSubLicense.Items[index].Value);
                    if (sbSublicensing.Length == 0)
                        sbSublicensing.Append(sublicenseCode);
                    else
                        sbSublicensing.Append("," + sublicenseCode);
                }
            }

            //Get selected Dubbing Language
            int[] selected_Sub_Language = lbSubtitling.GetSelectedIndices();
            if (selected_Sub_Language.Length > 0)
            {
                foreach (int index in selected_Sub_Language)
                {
                    string languageCode = lbSubtitling.Items[index].Value;
                    if (sbSubtitlingLanguage.Length == 0)
                        sbSubtitlingLanguage.Append(languageCode);
                    else
                        sbSubtitlingLanguage.Append("," + languageCode);
                }
            }

            //Get selected Dubbing Language
            int[] selected_Language = lbDubbing.GetSelectedIndices();
            if (selected_Language.Length > 0)
            {
                foreach (int index in selected_Language)
                {
                    string languageCode = lbDubbing.Items[index].Value;
                    if (sbDubbingLanguage.Length == 0)
                        sbDubbingLanguage.Append(languageCode);
                    else
                        sbDubbingLanguage.Append("," + languageCode);
                }
            }

            //Set Dubbing_Subtitling Type
            if (Dubbing_Subtitling == "0")
                Dubbing_Subtitling = (sbSubtitlingLanguage.ToString() != "0") ? "S" : "0";

            if (Dubbing_Subtitling == "0")
                Dubbing_Subtitling = (sbDubbingLanguage.ToString() != "0") ? "D" : "0";
            else
            {
                if (sbDubbingLanguage.ToString() != "0")
                    Dubbing_Subtitling = Dubbing_Subtitling + "," + "D";
            }

            //Get selected countries
            if (hdnRegionType.Value == "T")
            {
                if (ddlTerritory.SelectedIndex != -1)
                {
                    sbTerritory.Clear();
                    sbTerritory.Append(ddlTerritory.SelectedValue);
                }
            }
            else
            {
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
                if (selected_Movie.Length == 0 && selected_Country.Length == 0 && selected_Country.Length == 0 && SelectedPlatform == "0")
                {
                    CreateMessageAlert("Please select atleast one Title, Region or Platform .");
                    return;
                }
            }

            int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
            ReportCredential();

            ReportParameter[] parm = new ReportParameter[30];
            parm[0] = new ReportParameter("Title_Code", sbMovie.ToString());
            parm[1] = new ReportParameter("Platform_Code", uctabPTV.PlatformCodes_Selected_Out);
            parm[2] = new ReportParameter("Country_Code", sbTerritory.ToString());
            parm[3] = new ReportParameter("Is_Original_Language", chkIsOriginalLanguage.Checked.ToString());
            parm[4] = new ReportParameter("Title_Language_Code", sbTitleLanguage.ToString());
            parm[5] = new ReportParameter("Date_Type", rblPeriodType.SelectedValue);
            parm[6] = new ReportParameter("StartDate", GlobalUtil.MakedateFormat(StartDate));
            parm[7] = new ReportParameter("EndDate", GlobalUtil.MakedateFormat(EndDate));
            parm[8] = new ReportParameter("StartMonth", StartMonth);
            parm[9] = new ReportParameter("EndYear", EndYear);
            parm[10] = new ReportParameter("RestrictionRemarks", chkRestRemarks.Checked.ToString());
            parm[11] = new ReportParameter("OthersRemarks", chkOtherRemarks.Checked.ToString());
            parm[12] = new ReportParameter("Platform_ExactMatch", (chkExact.SelectedValue == "") ? "False" : chkExact.SelectedValue);
            parm[13] = new ReportParameter("MustHave_Platform", (chkExact.SelectedValue == "MH") ? uctabSelectedplt.PlatformCodes_Selected_Out : "0");
            parm[14] = new ReportParameter("Exclusivity", ddlExclusive.SelectedValue);
            parm[15] = new ReportParameter("SubLicense_Code", sbSublicensing.ToString());
            parm[16] = new ReportParameter("Region_ExactMatch", (chkRegion.SelectedValue == "") ? "False" : chkRegion.SelectedValue);
            parm[17] = new ReportParameter("Region_MustHave", hdnMustHaveRegionCode.Value);
            parm[18] = new ReportParameter("Subtit_Language_Code", sbSubtitlingLanguage.ToString());
            parm[19] = new ReportParameter("Dubbing_Subtitling", Dubbing_Subtitling);
            parm[20] = new ReportParameter("Region_Exclusion", hdnExclusionRegionCode.Value);
            parm[21] = new ReportParameter("Dubbing_Language_Code", sbDubbingLanguage.ToString());
            parm[22] = new ReportParameter("Created_By", objLoginedUser.First_Name + " " + objLoginedUser.Last_Name);
            parm[23] = new ReportParameter("BU_Code", BU_Code.ToString());
            parm[24] = new ReportParameter("Is_SubLicense", "");
            parm[25] = new ReportParameter("Is_Approved", "A");
            parm[26] = new ReportParameter("Episode_From", txtEFrom.Text);
            parm[27] = new ReportParameter("Episode_To", txtETo.Text);
            parm[28] = new ReportParameter("CallFrom", "3");
            if (ddlReportFor.SelectedValue == "S")
                parm[29] = new ReportParameter("Include_Sub_Deal", "N");
            else
                parm[29] = new ReportParameter("Include_Sub_Deal", (chkIncludeSubDeal.Checked) ? "Y" : "N");

            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                if (ddlReportFor.SelectedValue == "A")
                    ReportViewer1.ServerReport.ReportPath = objRS.GetReport("Title_Platform_Acq_New");
                else
                    ReportViewer1.ServerReport.ReportPath = objRS.GetReport("Title_Platform_Syn_New");
            }
            ReportViewer1.ServerReport.SetParameters(parm);
            ReportViewer1.ServerReport.Refresh();
        }
        #endregion

        #region --- Title Gridview Events ---
        protected void gvTitle_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.Header && e.Row.DataItem != null)
            {
                var q = e.Row.DataItem;
                int TitleCode = ((UTOFrameWork.FrameworkClasses.Persistent)(q)).IntCode;
                CheckBox myCheckBox = (CheckBox)e.Row.FindControl("chkSelect");
                if (lstTitleCode.Contains(TitleCode))
                    myCheckBox.Checked = true;
            }
        }
        protected void dtLst_ErrorPopup_ItemCommand(object source, DataListCommandEventArgs e)
        {
            foreach (GridViewRow gvrow in gvTitle.Rows)
            {
                CheckBox myCheckBox = (CheckBox)gvrow.FindControl("chkSelect");
                Label lblIntCode = (Label)gvrow.FindControl("lblIntCode");
                int code = Convert.ToInt32(lblIntCode.Text);
                if (myCheckBox.Checked)
                {
                    if (!lstTitleCode.Contains(code))
                        lstTitleCode.Add(code);

                }
                else
                {
                    if (lstTitleCode.Contains(code))
                        lstTitleCode.Remove(code);
                }
            }
            PageNo = Convert.ToInt32(e.CommandArgument);
            BindGridMovie();
        }
        protected void dtLst_ErrorPopup_ItemDataBound(object sender, DataListItemEventArgs e)
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
        #endregion 
    }
}