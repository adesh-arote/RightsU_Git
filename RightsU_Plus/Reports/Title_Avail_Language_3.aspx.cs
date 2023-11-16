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

namespace RightsU_WebApp.Reports
{
    public partial class Title_Avail_Language_3 : ParentPage
    {
        protected string MaxSelectedOption;
        protected string strInsertVal;
        public User objLoginedUser { get; set; }
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

        public string Is_IFTA_Cluster
        {
            get
            {
                if (ViewState["Is_IFTA_Cluster"] == null)
                    ViewState["Is_IFTA_Cluster"] = string.Empty;
                return (string)ViewState["Is_IFTA_Cluster"];
            }
            set { ViewState["Is_IFTA_Cluster"] = value; }
        }

        protected override void OnInit(EventArgs e)
        {
            IsReqLoadingPanel = "N";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string Avail_Min_Date = "";
            objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
            //((Home)this.Page.Master).setVal("TitleAvailability3");
            ((Home)this.Page.Master).setVal("MovieAvailability");

            if (!IsPostBack)
            {
                IsReqLoadingPanel = "N";
                hdnTabVal.Value = "";
                hdnIsSaveQuery.Value = "";
                AddAttributes();
                BindListBoxes();
                lstTitleCode = new List<int>();
                //Date Initialize
                string strTodaysDate = DBUtil.getServerDate().ToString("dd/MM/yyyy");

                System_Parameter_New_Service objSystemParamservice = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
                Avail_Min_Date = objSystemParamservice.SearchFor(s => s.Parameter_Name == "Avail_Min_Date").ToList().FirstOrDefault().Parameter_Value;

                if (Avail_Min_Date.ToUpper() == "D")
                {
                    txtNextDays.Text = "1";
                }
                else if (Avail_Min_Date.ToUpper() == "Y")
                {
                    txtYears.Text = "1";
                }
                else if (Avail_Min_Date.ToUpper() == "Q")
                {
                    txtNextmonth.Text = "3";
                }
                else if (Avail_Min_Date.ToUpper() == "M")
                {
                    txtNextmonth.Text = "1";
                }

                txtfrom.Text = strTodaysDate;
                spPlatform.Attributes.Add("class", "tabCountry");
                spPlatformGroup.Attributes.Add("class", "tabTerritory");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "InitializeStartDate", "InitializeStartDate();", true);
                hdnIsCriteriaChange.Value = "N";
                //SavedQuery.Attributes["style"] = "display:none";
                Results.Attributes["style"] = "display:none";
                tblCriteria.Attributes["style"] = "display:none";
                BindGridView();
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "LoadPlatform", "LoadPlatform();", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "T", "AssignChosenJQuery();", true);
                //upMainPlatform.Visible = false;
                //upSelectedPlatform.Visible = false;
                //LoadControl("UC_Platform_Tree.ascx");
                //break;
                //LoadControl("UC_Platform_Tree_Selected.ascx");
                //return;
            }

            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            MaxSelectedOption = objSystemParamService.SearchFor(p => p.Parameter_Name == "MaxSelectedOption").ToList().FirstOrDefault().Parameter_Value;

            Is_Restriction_Remarks = objSystemParamService.SearchFor(p => p.Parameter_Name == "Is_Restriction_Remarks").ToList().FirstOrDefault().Parameter_Value;
            if (Is_Restriction_Remarks == "Y")
            {
                chkRestRemarks.Checked = true;
                chkRestRemarks.Enabled = false;
            }

            Is_IFTA_Cluster = objSystemParamService.SearchFor(p => p.Parameter_Name == "Is_IFTA_Cluster").ToList().FirstOrDefault().Parameter_Value;
            if (Is_IFTA_Cluster == "Y")
            {
                chkIFTACluster.Visible = true;
            }
            else
            {
                chkIFTACluster.Visible = false;
            }
            string Digital_Avail = objSystemParamService.SearchFor(p => p.Parameter_Name == "Digital_Avail").ToList().FirstOrDefault().Parameter_Value;
            if (Digital_Avail != "")
            {
                if (Digital_Avail == "Y")
                {
                    chkDigital.Visible = true;
                }
                else
                {
                    chkDigital.Visible = false;
                }
                hdnIsDidital.Value = Digital_Avail;
            }
            BindModeleName();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "toolbarCss", "Assign_Css();", true);
            //upMain.Update();
            //upSelectedPlatform.Update();
            //upMainPlatform.Update();
            //upMain.Update();
        }

        #region---------------------TAB-------------------------------------------
        protected void BindModeleName()
        {
            SystemModule objTitle = new SystemModule();
            objTitle.IntCode = 205;
            objTitle.Fetch();
            lblModuleName.Text = objTitle.moduleName;
        }
        protected void imgCriteria_Click(object sender, EventArgs e)
        {
            //liImgResults.Attributes["class"] = "";
            //liImgCriteria.Attributes["class"] = "active";
            //liImgSavedQuery.Attributes["class"] = "";
            //tblCriteria.Attributes["style"] = "";
            //SavedQuery.Attributes["style"] = "display:none";
            //Results.Attributes["style"] = "display:none";
            hdnTabName.Value = "Criteria";
            showHideTab();
            hdnDupQueryName.Value = "";
        }
        //protected void imgColumns_Click(object sender, EventArgs e)
        //{
        //    liImgResults.Attributes["class"] = "";
        //    liImgCriteria.Attributes["class"] = "";
        //    liImgSavedQuery.Attributes["class"] = "active";
        //    tblCriteria.Attributes["style"] = "display:none";
        //    SavedQuery.Attributes["style"] = "";
        //    Results.Attributes["style"] = "display:none";
        //    hdnDupQueryName.Value = "";
        //    // hdnIsCriteriaChange.Value = "Y";
        //}
        protected void imgResults_Click(object sender, EventArgs e)
        {
            //liImgResults.Attributes["class"] = "active";
            //liImgCriteria.Attributes["class"] = "";
            //liImgSavedQuery.Attributes["class"] = "";
            //tblCriteria.Attributes["style"] = "display:none";
            //SavedQuery.Attributes["style"] = "display:none";
            //Results.Attributes["style"] = "";
            hdnTabName.Value = "Result";
            showHideTab();
            if (hdnIsCriteriaChange.Value == "Y")
            {
                rblVisibility.SelectedValue = "PU";
                txtReportName.Text = "";
                hdnTitleCodes.Value = "";
                ShowResults("N");
                hdnIsCriteriaChange.Value = "N";
                //BindGridView();
            }

        }
        #endregion

        #region---------------------BIND DATA---------------------------------

        private void BindListBoxes()
        {
            BindTitleLanguage();
            BindSubLicensing();

            BindddlBusiness_Unit();
            BindListMovie();
            BindTerritoryList();
            BindLanguageList();
            //BindLanguageNewList();
            //BindLanguageNewList_dub();
            BindPlatform("");

            //ddlPlatformGroup.DataSource = new Platform_Module_Config_Service().SearchFor(p => p.Platform_Code != null).Select(p => p.Platform_Type).Distinct().ToList();
            ddlPlatformGroup.DataSource = new Platform_Group_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Platform_Group_Code != 0 && p.Is_Active == "Y").Select(R => new { Platform_Group_Value = R.Platform_Group_Code, Platform_Group_Name = R.Platform_Group_Name }).Distinct().ToList();
            ddlPlatformGroup.DataTextField = "Platform_Group_Name";
            ddlPlatformGroup.DataValueField = "Platform_Group_Value";
            ddlPlatformGroup.DataBind();
            ddlPlatformGroup.Items.Insert(0, new ListItem { Text = "--Please Select--", Value = "0" });
        }

        private void BindddlBusiness_Unit()
        {
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            string SelectedBU = objSystemParamService.SearchFor(p => p.Parameter_Name == "Title_Avail_BU").ToList().FirstOrDefault().Parameter_Value;
            string[] arr_BU_Codes = SelectedBU.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            ddlBusinessUnit.DataSource = new Business_Unit_Service(ObjLoginEntity.ConnectionStringName).SearchFor(b => b.Users_Business_Unit.Any(UB => UB.Business_Unit_Code == b.Business_Unit_Code && UB.Users_Code == objLoginedUser.Users_Code)
                && arr_BU_Codes.Contains(b.Business_Unit_Code.ToString())).Select(R => new { Business_Unit_Code = R.Business_Unit_Code, Business_Unit_Name = R.Business_Unit_Name }).ToList();

            ddlBusinessUnit.DataTextField = "Business_Unit_Name";
            ddlBusinessUnit.DataValueField = "Business_Unit_Code";
            ddlBusinessUnit.DataBind();
        }

        private void AddAttributes()
        {
            txtSearch.Attributes.Add("OnKeyPress", "doNotAllowTag();fnEnterKey('" + btnSearch_tit.ClientID + "');");
        }

        protected void ddlBusinessUnit_SelectedIndexChanged(object sender, EventArgs e)
        {
            hdnIsCriteriaChange.Value = "Y";
            HideShowAddYear();
            BindListMovie();
            BindGridView();
            showHideTab();
        }

        #endregion

        #region---------------------HEADER---------------------------------
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

        private void BindListMovie()
        {
            int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
            Title_Service titleService = new Title_Service(ObjLoginEntity.ConnectionStringName);
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            int Deal_Type_Movie = Convert.ToInt32(objSystemParamService.SearchFor(p => p.Parameter_Name == "Deal_Type_Movie").FirstOrDefault().Parameter_Value);
            var obj_Title = titleService.SearchFor(T => T.Is_Active == "Y" &&
                                                    T.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code && AM.Acq_Deal.Is_Master_Deal == "Y")
                                                    && T.Deal_Type_Code == Deal_Type_Movie)
                                                    .Select(l => new ListItem { Text = l.Title_Name, Value = l.Title_Code.ToString() })
                                                    .OrderBy(t => t.Value).ToList();

            lsMovie.DataSource = obj_Title;
            lsMovie.DataTextField = "Text";
            lsMovie.DataValueField = "Value";
            lsMovie.DataBind();
        }

        private void BindGridMovie()
        {
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            string Deal_Type_Movie = Convert.ToString(objSystemParamService.SearchFor(p => p.Parameter_Name == "Deal_Type_Movie").FirstOrDefault().Parameter_Value);
            int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
            int recCount, ipages;
            string SearchString = "";
            Title objTitle = new Title();
            Criteria objCrt = new Criteria();

            objCrt.ClassRef = objTitle;
            objCrt.IsPagingRequired = false;
            objCrt.IsSubClassRequired = true;
            string strSearch = "";
            SearchString = " AND IS_Active='Y' AND Deal_Type_Code IN(" + Deal_Type_Movie + ") AND Title_Code IN (SELECT adm.Title_Code FROM Acq_Deal_Movie adm INNER JOIN Acq_Deal ad ON ad.Acq_Deal_Code = adm.Acq_Deal_Code WHERE ad.Is_Master_Deal='Y' AND ad.Business_Unit_Code=" + BU_Code + ")";

            if (!txtSearch.Text.Contains(","))
            {
                strSearch = txtSearch.Text.Trim();
                SearchString += " AND ((Title_Name like N'%" + strSearch + "%') OR (Year_Of_Production like '%" + strSearch + "%') ";
                SearchString += " OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg INNER JOIN Genres g on  g.Genres_Code = tg.Genres_Code where g.Genres_Name like N'%" + strSearch + "%')";
                SearchString += " OR Title_Code IN (Select tt.Title_Code from Title_Talent tt INNER JOIN Talent t on t.Talent_Code = tt.Talent_Code WHERE t.Talent_Name like N'%" + strSearch + "%')";
                SearchString += " OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN "
                                  + " (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv WHERE ecv.Columns_Value LIKE N'%" + strSearch + "%'))";
                SearchString += " )";
            }
            else
                if (txtSearch.Text != string.Empty)
            {
                strSearch = "Select number from dbo.fn_Split_withdelemiter(N'" + txtSearch.Text.Trim() + "',',')";
                SearchString += " AND ((Title_Name IN (N" + strSearch + ")) OR (Year_Of_Production IN (" + strSearch + " where ISNUMERIC(number) = 1)) ";
                SearchString += " OR Title_Code IN (SELECT tg.Title_Code from Title_Geners tg INNER JOIN Genres g on  g.Genres_Code = tg.Genres_Code where g.Genres_Name IN (N" + strSearch + "))";
                SearchString += " OR Title_Code IN (Select tt.Title_Code from Title_Talent tt INNER JOIN Talent t on t.Talent_Code = tt.Talent_Code WHERE t.Talent_Name IN (N" + strSearch + "))";
                SearchString += " OR Title_Code IN (Select Record_Code from Map_Extended_Columns mec WHERE mec.Columns_Code =2 AND mec.Columns_Value_Code IN "
                                  + " (Select ecv.Columns_Value_Code from Extended_Columns_Value ecv WHERE ecv.Columns_Value IN (" + strSearch + ")))";
                SearchString += " )";
            }

            //ArrayList arrList = GlobalUtil.getArrBatchWisePaging(new Title(), SearchString, objCrt.RecordPerPage, objCrt.PagesPerBatch, lblTotal, 1, out ipages, out recCount);
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

        public void BindTitleLanguage()
        {
            Title_Service titleService = new Title_Service(ObjLoginEntity.ConnectionStringName);
            List<int> lstTitleLanguageCode = titleService.SearchFor(t => t.Title_Language_Code != null).Select(t => t.Title_Language_Code.Value).Distinct().ToList();
            Language_Service langServiceInstance = new Language_Service(ObjLoginEntity.ConnectionStringName);
            var langList = langServiceInstance.SearchFor(l => l.Is_Active == "Y" && lstTitleLanguageCode.Contains(l.Language_Code)).Select(l => new ListItem { Text = l.Language_Name, Value = l.Language_Code.ToString() }).ToList();
            lbTitleLang.DataSource = langList;
            lbTitleLang.DataTextField = "Text";
            lbTitleLang.DataValueField = "Value";
            lbTitleLang.DataBind();
        }

        public void BindSubLicensing()
        {
            Sub_License_Service subLicenseServiceInstance = new Sub_License_Service(ObjLoginEntity.ConnectionStringName);
            var sublicList = subLicenseServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Sub_License_Name, Value = l.Sub_License_Code.ToString() }).ToList();
            lbSubLicense.DataSource = sublicList;
            lbSubLicense.DataTextField = "Text";
            lbSubLicense.DataValueField = "Value";
            lbSubLicense.DataBind();
        }

        protected void lbSelectTitles_Click(object sender, EventArgs e)
        {
            HideShowAddYear();
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
            //if (txtSearch.Text != "")
            //    BindGridMovie();
            //else
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
                HideShowAddYear();
                upTitle.Update();
                //BindListMovie();
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
            HideShowAddYear();
            txtSearch.Text = "";
            BindGridMovie();
        }

        #endregion

        #region---------------------PLATFORM---------------------------------
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
                uctabPTV.Connection_Str = ObjLoginEntity.ConnectionStringName;
            }
            else
                uctabPTV.PlatformCodes_Display = "0";

            uctabSelectedplt.PlatformCodes_Display = "0";
            uctabPTV.PopulateTreeNode("N", strSearch);
            uctabSelectedplt.PopulateTreeNode("N", strSearch);
        }
        #endregion

        #region---------------------RESULTS---------------------------------

        protected void ShowResults(string isSaveQry, int intCode = 0)
        {
            #region -------------------------------Attributes----------------------------

            StringBuilder sbMovie = new StringBuilder("0");
            StringBuilder sbTitleLanguage = new StringBuilder("0");
            StringBuilder sbTerritory = new StringBuilder("0");
            StringBuilder sbSublicensing = new StringBuilder("0");
            StringBuilder sbDubbingLanguage = new StringBuilder("0");
            StringBuilder sbSubtitlingLanguage = new StringBuilder("0");

            string StartDate = "", EndDate = "", StartMonth, EndYear, Digital = "true";
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
                //EndDate = (txtto.Text == "DD/MM/YYYY" || txtto.Text == "") ? DateTime.MaxValue.ToString("dd/MM/yyyy") : txtto.Text;
                //EndDate = (txtto.Text == "DD/MM/YYYY" || txtto.Text == "") ? null : txtto.Text;
                EndDate = (txtto.Text == "DD/MM/YYYY") ? "" : txtto.Text;
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
            if (StartDate != "")
                hdnStartDate.Value = StartDate.Replace('-', '/');
            else
                hdnStartDate.Value = "";
            if (EndDate != "")
                hdnEndDate.Value = EndDate.Replace('-', '/');
            else
                hdnEndDate.Value = "";
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
            int[] selected_Language = lbLanguage.GetSelectedIndices();
            if (selected_Language.Length > 0)
            {
                foreach (int index in selected_Language)
                {
                    string languageCode = lbLanguage.Items[index].Value;
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
                if (selected_Movie.Length == 0 && selected_Country.Length == 0 && selected_Country.Length == 0 && SelectedPlatform == "0" && isSaveQry == "N")
                {
                    CreateMessageAlert("Please select atleast one Title, Region or Platform .");
                    return;
                }
            }

            if (hdnIsDidital.Value == "Y")
                if (chkDigital.Checked)
                {
                    Digital = "true";
                }
                else
                    Digital = "false";
            else
                Digital = "false";

            int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
            #endregion

            string platformCodes = uctabPTV.PlatformCodes_Selected_Out;
            string isOriginalLang = chkIsOriginalLanguage.Checked.ToString();
            string strPeriodType = rblPeriodType.SelectedValue;
            string strRestRemarks = chkRestRemarks.Checked.ToString();

            //if (isSaveQry == "Y")
            //{
            string strReportName = "";
            //if (rdQueryYes.Checked)
            strReportName = txtReportName.Text.Trim();
            USP_Service objUSP = new USP_Service(ObjLoginEntity.ConnectionStringName);
            string strPlt_EM = chkExact.SelectedValue.ToString() == "" ? "False" : chkExact.SelectedValue;
            string strPlt_MH = chkExact.SelectedValue.ToString() == "MH" ? uctabSelectedplt.PlatformCodes_Selected_Out : "0";
            string strRegion_EM = chkRegion.SelectedValue.ToString() == "" ? "False" : chkRegion.SelectedValue;


            strInsertVal = "'" + sbMovie.ToString() + "', '" + platformCodes + "','" + sbTerritory.ToString() + "','"
                                      + chkIsOriginalLanguage.Checked + "','"
                                      + Dubbing_Subtitling.ToString() + "','" + sbTitleLanguage.ToString() + "','" + rblPeriodType.SelectedValue + "','" + GlobalUtil.MakedateFormat(StartDate) + "','" + GlobalUtil.MakedateFormat(EndDate) + "','"
                                      + objLoginedUser.Users_Code + "', GETDATE(), '"
                                      + chkRestRemarks.Checked.ToString() + "','" + chkOtherRemarks.Checked.ToString() + "','" + strPlt_EM + "','"
                                      + strPlt_MH + "','" + ddlExclusive.SelectedValue + "','" + sbSublicensing.ToString() + "','" + strRegion_EM + "','"
                                      + hdnMustHaveRegionCode.Value + "','" + hdnExclusionRegionCode.Value + "','" + sbSubtitlingLanguage.ToString() + "','" + sbDubbingLanguage.ToString() + "','"
                                      + BU_Code.ToString() + "','SQ','Y','" + Digital + "','" + chkMetadata.Checked.ToString() + "'";
            hdnstrCriteria.Value = strInsertVal;
            List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
            Avail_Report_Schedule_UDT objAvail_Report_Schedule_UDT = new Avail_Report_Schedule_UDT();
            objAvail_Report_Schedule_UDT.Title_Code = string.Join(",", sbMovie.ToString());
            objAvail_Report_Schedule_UDT.Platform_Code = platformCodes;
            objAvail_Report_Schedule_UDT.Country_Code = sbTerritory.ToString();
            objAvail_Report_Schedule_UDT.Is_Original_Language = (chkIsOriginalLanguage.Checked == true ? "1" : "0");
            objAvail_Report_Schedule_UDT.Dubbing_Subtitling = Dubbing_Subtitling.ToString();
            objAvail_Report_Schedule_UDT.Language_Code = sbTitleLanguage.ToString();
            objAvail_Report_Schedule_UDT.Date_Type = rblPeriodType.SelectedValue;
            objAvail_Report_Schedule_UDT.StartDate = GlobalUtil.MakedateFormat(StartDate);
            objAvail_Report_Schedule_UDT.EndDate = GlobalUtil.MakedateFormat(EndDate);
            objAvail_Report_Schedule_UDT.UserCode = objLoginedUser.Users_Code;
            objAvail_Report_Schedule_UDT.Inserted_On = System.DateTime.Now;
            objAvail_Report_Schedule_UDT.Report_Status = "Y";
            objAvail_Report_Schedule_UDT.Visibility = "PR";
            // objAvail_Report_Schedule_UDT.ReportName = ReportName;
            objAvail_Report_Schedule_UDT.RestrictionRemark = chkRestRemarks.Checked.ToString();
            objAvail_Report_Schedule_UDT.OtherRemark = chkOtherRemarks.Checked.ToString();
            objAvail_Report_Schedule_UDT.Platform_ExactMatch = strPlt_EM;
            objAvail_Report_Schedule_UDT.MustHave_Platform = strPlt_MH;
            objAvail_Report_Schedule_UDT.Exclusivity = ddlExclusive.SelectedValue;
            objAvail_Report_Schedule_UDT.SubLicenseCode = sbSublicensing.ToString();
            objAvail_Report_Schedule_UDT.Region_ExactMatch = strRegion_EM;
            objAvail_Report_Schedule_UDT.Region_MustHave = hdnMustHaveRegionCode.Value;
            objAvail_Report_Schedule_UDT.Region_Exclusion = hdnExclusionRegionCode.Value;
            objAvail_Report_Schedule_UDT.Subtit_Language_Code = sbSubtitlingLanguage.ToString();
            objAvail_Report_Schedule_UDT.Dubbing_Language_Code = sbDubbingLanguage.ToString();
            objAvail_Report_Schedule_UDT.BU_Code = BU_Code;
            objAvail_Report_Schedule_UDT.Report_Type = "SQ";
            objAvail_Report_Schedule_UDT.Digital = false;
            objAvail_Report_Schedule_UDT.IncludeMetadata = chkMetadata.Checked.ToString();
            objAvail_Report_Schedule_UDT.Is_IFTA_Cluster = "";
            objAvail_Report_Schedule_UDT.Platform_Group_Code = "";
            objAvail_Report_Schedule_UDT.Subtitling_Group_Code = "";
            objAvail_Report_Schedule_UDT.Subtitling_ExactMatch = "";
            objAvail_Report_Schedule_UDT.Subtitling_MustHave = "";
            objAvail_Report_Schedule_UDT.Subtitling_Exclusion = "";
            objAvail_Report_Schedule_UDT.Dubbing_Group_Code = "";
            objAvail_Report_Schedule_UDT.Dubbing_ExactMatch = "";
            objAvail_Report_Schedule_UDT.Dubbing_MustHave = "";
            objAvail_Report_Schedule_UDT.Dubbing_Exclusion = "";
            objAvail_Report_Schedule_UDT.Territory_Code = "";
            objAvail_Report_Schedule_UDT.IndiaCast = "N";
            objAvail_Report_Schedule_UDT.Region_On = "IF";
            objAvail_Report_Schedule_UDT.Include_Ancillary = "N";
            objAvail_Report_Schedule_UDT.Promoter_Code = "";
            objAvail_Report_Schedule_UDT.Promoter_ExactMatch = "";
            objAvail_Report_Schedule_UDT.MustHave_Promoter = "";
            objAvail_Report_Schedule_UDT.Module_Code = Convert.ToInt32("205");
            objAvail_Report_Schedule_UDT.Episode_From = Convert.ToInt32("0");
            objAvail_Report_Schedule_UDT.Episode_To = Convert.ToInt32("0");
            objAvail_Report_Schedule_UDT.ReportName = txtReportName.Text.Trim();
            lst_Avail_Report_Schedule_UDT.Add(objAvail_Report_Schedule_UDT);
            //}
            if (isSaveQry == "R")
            {
                //if (hdnTabVal.Value != Convert.ToString(intCode))
                //{
                int RecordCount = 0;
                ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
                string strFilter = "";
                strFilter = " AND Avail_Report_Schedule_Code=" + intCode + "";
                //List<USP_Get_Title_Avail_Language_Data_Result> list = new List<USP_Get_Title_Avail_Language_Data_Result>();
                dynamic list;
                list= objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginedUser.Users_Code, "F",strFilter, PageNo, "", "N", 0).ToList();
                if (list.Count > 0)
                {
                    ddlBusinessUnit.SelectedValue = list[0].BU_Code.ToString();
                    BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
                    txtReportName.Text = list[0].ReportName;
                    rblVisibility.SelectedValue = list[0].Visibility;
                    hdnReportCode.Value = Convert.ToString(list[0].Avail_Report_Schedule_Code);
                    hdnTitleCode_SQ.Value = list[0].Title_Code.ToString();

                    hdnPlatform.Value = list[0].Platform_Code.ToString();
                    BindPlatform("");
                    int[] arrPlatform;
                    arrPlatform = new Platform_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y").Select(p => p.Platform_Code).Distinct().ToArray();
                    if (arrPlatform.Count() > 0)
                    {
                        uctabSelectedplt.PlatformCodes_Display = string.Join(",", arrPlatform);
                        uctabSelectedplt.PlatformCodes_Selected = list[0].MustHave_Platform.ToString().Split(',');
                    }
                    else
                        uctabSelectedplt.PlatformCodes_Display = "0";

                    string selectedMainPlatform = uctabPTV.PlatformCodes_Selected_Out;
                    if (selectedMainPlatform != "")
                        uctabSelectedplt.PlatformCodes_Display = selectedMainPlatform;
                    else
                        uctabSelectedplt.PlatformCodes_Display = "0";
                    if (list[0].Platform_ExactMatch.ToString().Trim().ToUpper() == "FALSE" || list[0].Platform_ExactMatch.ToString().Trim().ToUpper() == "")
                    {
                        chkExact.Items[0].Selected = false;
                        chkExact.Items[1].Selected = false;
                    }
                    else
                        chkExact.SelectedValue = list[0].Platform_ExactMatch.ToString().Trim();
                    if (chkExact.SelectedValue == "MH")
                        uctabSelectedplt.PopulateTreeNode("N", "");
                    else
                        uctabSelectedplt.PopulateTreeNode("Y", "");

                    if (list[0].Territory_Code.Contains("T"))
                        hdnRegionType.Value = "T";
                    else
                        hdnRegionType.Value = "";
                    if (hdnRegionType.Value != "T")
                    {
                        hdnRegionCodes.Value = list[0].Country_Code.ToString();
                    }
                    else
                    {
                        hdnRegionCodes.Value = list[0].Territory_Code.ToString();
                    }
                    chkIsOriginalLanguage.Checked = list[0].Is_Original_Language.ToUpper() == "YES" ? true : false;
                    rblPeriodType.SelectedValue = list[0].Date_Type.ToString().Trim() == "MI" ? "MI" : (list[0].Date_Type.ToString().Trim() == "Flexi" ? "FL" : "FI");
                    hdnStartDate.Value = list[0].StartDate.ToString().Replace('-', '/');
                    hdnEndDate.Value = list[0].EndDate.ToString().Replace('-', '/');
                    chkRestRemarks.Checked = Convert.ToBoolean(list[0].RestrictionRemarks);
                    chkOtherRemarks.Checked = Convert.ToBoolean(list[0].OthersRemark);
                    //
                    //chkDigital.Checked = Convert.ToBoolean(list[0].Digital);
                    ddlBusinessUnit.SelectedValue = list[0].BU_Code.ToString();
                    BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);
                    ddlExclusive.SelectedValue = list[0].Exclusivity.ToString();
                    hdnMustHaveRegionCode.Value = list[0].Region_MustHave.ToString();
                    hdnExclusionRegionCode.Value = list[0].Region_Exclusion.ToString();
                    if (list[0].Region_ExactMatch.ToString().Trim().ToUpper() == "FALSE" || list[0].Region_ExactMatch.ToString().Trim().ToUpper() == "")
                    {
                        chkRegion.Items[0].Selected = false;
                        chkRegion.Items[1].Selected = false;
                    }
                    else
                        chkRegion.SelectedValue = list[0].Region_ExactMatch.ToString().Trim();

                    hdnSL_SQ.Value = list[0].SubLicense_Code.ToString();
                    hdnTL_SQ.Value = list[0].Language_Code.ToString();
                    hdnSubTit_SQ.Value = list[0].Subtit_Language_Code.ToString();
                    hdnDubb_SQ.Value = list[0].Dubbing_Language_Code.ToString();

                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "StartUpScript", "SetMultiselectDDLsAfterPageLoad();", true);
                    sbMovie.Clear();
                    sbMovie.Append(list[0].Title_Code.ToString());
                    platformCodes = list[0].Platform_Code.ToString();
                    sbTerritory.Clear();
                    sbTerritory.Append(list[0].Country_Code.ToString());
                    isOriginalLang = (list[0].Is_Original_Language.ToUpper() == "YES") ? "true" : "false";
                    sbTitleLanguage.Clear();
                    sbTitleLanguage.Append(list[0].Language_Code.ToString());
                    chkDigital.Checked = Convert.ToBoolean(list[0].Digital);
                    StartDate = list[0].StartDate.ToString();
                    EndDate = list[0].EndDate.ToString();
                    if (EndDate.Trim() == String.Empty)
                        EndDate = DateTime.MaxValue.ToString("dd/MM/yyyy");
                    strRestRemarks = list[0].RestrictionRemarks;
                    sbSublicensing.Clear();
                    sbSublicensing.Append(list[0].SubLicense_Code.ToString());
                    sbSubtitlingLanguage.Clear();
                    sbSubtitlingLanguage.Append(list[0].Subtit_Language_Code.ToString());
                    sbDubbingLanguage.Clear();
                    sbDubbingLanguage.Append(list[0].Dubbing_Language_Code.ToString());
                    if (Dubbing_Subtitling == "0")
                        Dubbing_Subtitling = (sbSubtitlingLanguage.ToString() != "0") ? "S" : "0";

                    if (Dubbing_Subtitling == "0")
                        Dubbing_Subtitling = (sbDubbingLanguage.ToString() != "0") ? "D" : "0";
                    else
                    {
                        if (sbDubbingLanguage.ToString() != "0")
                            Dubbing_Subtitling = Dubbing_Subtitling + "," + "D";
                    }
                    chkMetadata.Checked = Convert.ToBoolean(list[0].IncludeMetadata);
                    //}
                }
                else
                    hdnIsCriteriaChange.Value = "N";
            }
            if (hdnIsCriteriaChange.Value == "Y")
            {

                //ReportParameter[] parm = new ReportParameter[25];
                //parm[0] = new ReportParameter("Title_Code", sbMovie.ToString());
                //parm[1] = new ReportParameter("Platform_Code", platformCodes);
                //parm[2] = new ReportParameter("Country_Code", sbTerritory.ToString());
                //parm[3] = new ReportParameter("Is_Original_Language", isOriginalLang);
                //parm[4] = new ReportParameter("Title_Language_Code", sbTitleLanguage.ToString());
                //parm[5] = new ReportParameter("Date_Type", rblPeriodType.SelectedValue);
                //parm[6] = new ReportParameter("StartDate", GlobalUtil.MakedateFormat(StartDate));
                //parm[7] = new ReportParameter("EndDate", GlobalUtil.MakedateFormat(EndDate));
                //parm[8] = new ReportParameter("StartMonth", StartMonth);
                //parm[9] = new ReportParameter("EndYear", EndYear);
                //parm[10] = new ReportParameter("RestrictionRemarks", strRestRemarks);
                //parm[11] = new ReportParameter("OthersRemarks", chkOtherRemarks.Checked.ToString());
                //parm[12] = new ReportParameter("Platform_ExactMatch", (chkExact.SelectedValue == "") ? "False" : chkExact.SelectedValue);
                //parm[13] = new ReportParameter("MustHave_Platform", (chkExact.SelectedValue == "MH") ? uctabSelectedplt.PlatformCodes_Selected_Out : "0");
                //parm[14] = new ReportParameter("Exclusivity", ddlExclusive.SelectedValue);
                //parm[15] = new ReportParameter("SubLicense_Code", sbSublicensing.ToString());
                //parm[16] = new ReportParameter("Region_ExactMatch", (chkRegion.SelectedValue == "") ? "False" : chkRegion.SelectedValue);
                //parm[17] = new ReportParameter("Region_MustHave", hdnMustHaveRegionCode.Value);
                //parm[18] = new ReportParameter("Subtit_Language_Code", sbSubtitlingLanguage.ToString());
                //parm[19] = new ReportParameter("Dubbing_Subtitling", Dubbing_Subtitling);
                //parm[20] = new ReportParameter("Region_Exclusion", hdnExclusionRegionCode.Value);
                //parm[21] = new ReportParameter("Dubbing_Language_Code", sbDubbingLanguage.ToString());
                //parm[22] = new ReportParameter("Created_By", objLoginedUser.First_Name + " " + objLoginedUser.Last_Name);
                //parm[23] = new ReportParameter("BU_Code", BU_Code.ToString());
                //parm[24] = new ReportParameter("Is_Digital", Digital);

                string Metadata = chkMetadata.Checked.ToString();
                if (Metadata == "False")
                {
                    Metadata = "N";
                }
                else
                {
                    Metadata = "Y";
                }

                string IFTA_Cluster = chkIFTACluster.Checked.ToString();
                if (IFTA_Cluster == "False")
                {
                    IFTA_Cluster = "N";
                }
                else
                {
                    IFTA_Cluster = "Y";
                }

                ReportParameter[] parm = new ReportParameter[44];
                parm[0] = new ReportParameter("Title_Code", sbMovie.ToString());
                parm[1] = new ReportParameter("Platform_Code", platformCodes);
                parm[2] = new ReportParameter("Country_Code", sbTerritory.ToString());
                parm[3] = new ReportParameter("Is_Original_Language", isOriginalLang);
                parm[4] = new ReportParameter("Dubbing_Subtitling", Dubbing_Subtitling);
                parm[5] = new ReportParameter("Date_Type", rblPeriodType.SelectedValue);
                parm[6] = new ReportParameter("StartDate", GlobalUtil.MakedateFormat(StartDate));
                parm[7] = new ReportParameter("EndDate", GlobalUtil.MakedateFormat(EndDate));
                parm[8] = new ReportParameter("Title_Language_Code", sbTitleLanguage.ToString());
                parm[9] = new ReportParameter("RestrictionRemarks", strRestRemarks);
                parm[10] = new ReportParameter("Platform_ExactMatch", (chkExact.SelectedValue == "") ? "False" : chkExact.SelectedValue);
                parm[11] = new ReportParameter("MustHave_Platform", (chkExact.SelectedValue == "MH") ? uctabSelectedplt.PlatformCodes_Selected_Out : "0");
                parm[12] = new ReportParameter("Exclusivity", ddlExclusive.SelectedValue);
                parm[13] = new ReportParameter("SubLicense_Code", sbSublicensing.ToString());
                parm[14] = new ReportParameter("Region_ExactMatch", (chkRegion.SelectedValue == "") ? "False" : chkRegion.SelectedValue);
                parm[15] = new ReportParameter("Region_MustHave", hdnMustHaveRegionCode.Value);
                parm[16] = new ReportParameter("Created_By", objLoginedUser.First_Name + " " + objLoginedUser.Last_Name);
                parm[17] = new ReportParameter("StartMonth", StartMonth);
                parm[18] = new ReportParameter("EndYear", EndYear);
                parm[19] = new ReportParameter("Region_Exclusion", hdnExclusionRegionCode.Value);
                parm[20] = new ReportParameter("Subtit_Language_Code", sbSubtitlingLanguage.ToString());
                parm[21] = new ReportParameter("Dubbing_Language_Code", sbDubbingLanguage.ToString());
                parm[22] = new ReportParameter("BU_Code", BU_Code.ToString());
                parm[23] = new ReportParameter("OthersRemarks", chkOtherRemarks.Checked.ToString());
                parm[24] = new ReportParameter("Is_Digital", Digital);
                parm[25] = new ReportParameter("Include_Metadata", Metadata);
                parm[26] = new ReportParameter("Is_IFTA_Cluster", IFTA_Cluster);
                parm[27] = new ReportParameter("Platform_Group_Code", "0");
                parm[28] = new ReportParameter("Subtitling_Group_Code", "0");
                parm[29] = new ReportParameter("Subtitling_ExactMatch", "0");
                parm[30] = new ReportParameter("Subtitling_MustHave", "0");
                parm[31] = new ReportParameter("Subtitling_Exclusion", "0");
                parm[32] = new ReportParameter("Dubbing_Group_Code", "0");
                parm[33] = new ReportParameter("Dubbing_ExactMatch", "0");
                parm[34] = new ReportParameter("Dubbing_MustHave", "0");
                parm[35] = new ReportParameter("Dubbing_Exclusion", "0");
                parm[36] = new ReportParameter("Territory_Code", "0");
                parm[37] = new ReportParameter("Country_Level", "N");
                parm[38] = new ReportParameter("Territory_Level", "Y");
                parm[39] = new ReportParameter("TabName", "IF");

                parm[40] = new ReportParameter("OthersRemark", "false");
                parm[41] = new ReportParameter("Language_Code", "0");
                parm[42] = new ReportParameter("CallFrom", "3");
                parm[43] = new ReportParameter("Include_Ancillary", "N");

                ReportViewer1.ServerReport.ReportPath = string.Empty;

                ReportCredential();
                ReportViewer1.ServerReport.ReportPath = string.Empty;
                if (ReportViewer1.ServerReport.ReportPath == "")
                {
                    ReportSetting objRS = new ReportSetting();
                    ReportViewer1.ServerReport.ReportPath = objRS.GetReport("Title_Availability_Languagewise_V18_Demo");
                }
                ReportViewer1.ServerReport.SetParameters(parm);
                ReportViewer1.ServerReport.Refresh();
                hdnIsCriteriaChange.Value = "N";
            }
        }

        private void bindDropDownList<T>(DropDownList ddl, string selectedText, string selectedValue, List<T> list)
        {
            ddl.DataSource = list;
            ddl.DataTextField = selectedText;
            ddl.DataValueField = selectedValue;
            ddl.DataBind();
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

        #endregion

        #region---------------------COLUMNS---------------------------------


        #endregion

        public void BindTerritoryList()
        {

            System_Parameter_New_Service objSystemParamservice = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            Is_IFTA_Cluster = objSystemParamservice.SearchFor(p => p.Parameter_Name == "Is_IFTA_Cluster").ToList().FirstOrDefault().Parameter_Value;
            string IFTACLuster = chkIFTACluster.Checked.ToString();

            if (IFTACLuster == "True")
            {
                Report_Territory_Service reportTerritoryServiceInstance = new Report_Territory_Service(ObjLoginEntity.ConnectionStringName);
                ddlTerritory.DataSource = reportTerritoryServiceInstance.SearchFor(c => c.Is_Active == "Y").Select(c => new ListItem { Text = c.Report_Territory_Name, Value = "T" + c.Report_Territory_Code }).ToList();
                ddlTerritory.DataTextField = "Text";
                ddlTerritory.DataValueField = "Value";
                ddlTerritory.DataBind();
                ddlTerritory.Items.Insert(0, new ListItem { Text = "--Please Select--", Value = "0", Selected = true });
                //ddlTerritory.Items.Insert(0, "--Please Select");
            }
            else
            {
                Territory_Service territoryServiceInstance = new Territory_Service(ObjLoginEntity.ConnectionStringName);
                ddlTerritory.DataSource = territoryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Thetrical == "N").Select(c => new ListItem { Text = c.Territory_Name, Value = "T" + c.Territory_Code }).ToList();
                ddlTerritory.DataTextField = "Text";
                ddlTerritory.DataValueField = "Value";
                ddlTerritory.DataBind();
                ddlTerritory.Items.Insert(0, new ListItem { Text = "--Please Select--", Value = "0", Selected = true });
                //ddlTerritory.Items.Insert(0, "--Please Select");
            }


            Country_Service countryServiceInstance = new Country_Service(ObjLoginEntity.ConnectionStringName);
            var countryList = countryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Theatrical_Territory == "N").Select(c => new ListItem { Text = c.Country_Name, Value = c.Country_Code.ToString() }).OrderBy(l => l.Text).ToList();
            lstLTerritory.DataSource = countryList;
            lstLTerritory.DataTextField = "Text";
            lstLTerritory.DataValueField = "Value";
            lstLTerritory.DataBind();
        }

        //public void BindLanguageNewList()
        //{
        //    Language_Group_Service langGroupServiceInstance = new Language_Group_Service();
        //    ddlLanguageGroupNew.DataSource = langGroupServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Group_Name, Value = "G" + l.Language_Group_Code }).ToList();
        //    ddlLanguageGroupNew.DataTextField = "Text";
        //    ddlLanguageGroupNew.DataValueField = "Value";
        //    ddlLanguageGroupNew.DataBind();
        //    ddlLanguageGroupNew.Items.Insert(0, new ListItem { Text = "--Please Select", Value = "0" });

        //    Language_Service langServiceInstance = new Language_Service();
        //    var langList = langServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Name, Value = "L" + l.Language_Code }).OrderBy(l => l.Text).ToList();
        //    lstLLanguageGroupNew.DataSource = langList;
        //    lstLLanguageGroupNew.DataTextField = "Text";
        //    lstLLanguageGroupNew.DataValueField = "Value";
        //    lstLLanguageGroupNew.DataBind();


        //}

        //public void BindLanguageNewList_dub()
        //{
        //    Language_Group_Service langGroupServiceInstance = new Language_Group_Service();
        //    ddlLanguageGroupNew_dub.DataSource = langGroupServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Group_Name, Value = "G" + l.Language_Group_Code }).ToList();
        //    ddlLanguageGroupNew_dub.DataTextField = "Text";
        //    ddlLanguageGroupNew_dub.DataValueField = "Value";
        //    ddlLanguageGroupNew_dub.DataBind();
        //    ddlLanguageGroupNew_dub.Items.Insert(0, new ListItem { Text = "--Please Select", Value = "0" });

        //    Language_Service langServiceInstance = new Language_Service();
        //    var langList = langServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Name, Value = "L" + l.Language_Code }).OrderBy(l => l.Text).ToList();
        //    lstLLanguageGroupNew_dub.DataSource = langList;
        //    lstLLanguageGroupNew_dub.DataTextField = "Text";
        //    lstLLanguageGroupNew_dub.DataValueField = "Value";
        //    lstLLanguageGroupNew_dub.DataBind();
        //}


        public void BindLanguageList()
        {
            //Language_Group_Service langGroupServiceInstance = new Language_Group_Service();
            //var langList = langGroupServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Group_Name, Value = "G" + l.Language_Group_Code }).ToList();
            //ddlLanguageGroup.DataSource = langList;
            //ddlLanguageGroup.DataTextField = "Text";
            //ddlLanguageGroup.DataValueField = "Value";
            //ddlLanguageGroup.DataBind();
            //ddlLanguageGroup.Items.Insert(0, new ListItem { Text = "--Please Select", Value = "0" });

            Language_Service langServiceInstance = new Language_Service(ObjLoginEntity.ConnectionStringName);
            lbSubtitling.DataSource = langServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Name, Value = "L" + l.Language_Code }).OrderBy(l => l.Text).ToList();
            lbSubtitling.DataTextField = "Text";
            lbSubtitling.DataValueField = "Value";
            lbSubtitling.DataBind();

            lbLanguage.DataSource = lbSubtitling.DataSource;
            lbLanguage.DataTextField = "Text";
            lbLanguage.DataValueField = "Value";
            lbLanguage.DataBind();
        }

        private void HideShowAddYear()
        {
            //ddlPlatformGroup.Style.Add("display", "none");
            ////lnkbtnPltform.Style.Add("display", "none");
            //if (chkSpecficPlt.Checked == true)
            //    ddlPlatformGroup.Style.Add("display", "block");
            //else
            //    lnkbtnPltform.Style.Add("display", "block");

            //if (rblDateCriteria.SelectedValue == "FL") { tdAddYear.Style.Add("display", "block"); }
            //else { tdAddYear.Style.Add("display", "none"); }


            //if (rbPlatform.SelectedValue == "P") { tdAllPlt.Style.Add("display", "block"); tdDigPlt.Style.Add("display", "none"); }
            //else { tdAllPlt.Style.Add("display", "none"); tdDigPlt.Style.Add("display", "block"); }
        }

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
            //liImgResults.Attributes["class"] = "";
            //liImgCriteria.Attributes["class"] = "";
            //liImgSavedQuery.Attributes["class"] = "active";

            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "hideTab", "hideTab();", true);
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

        protected void hdnTitleCodes_ValueChanged(object sender, EventArgs e)
        {

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

        protected void btnSearch_plt_Click(object sender, EventArgs e)
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

        protected void btnShowAll_plt_Click(object sender, EventArgs e)
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

        protected void ResetSelectedPlatform()
        {
            uctabSelectedplt.PlatformCodes_Display = "0";
            uctabSelectedplt.PopulateTreeNode("N", "");
            chkExact.SelectedIndex = -1;
            upExact.Update();
            upSelectedPlatform.Update();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }

        protected void btnShowAll_plt_Selected_Click(object sender, EventArgs e)
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

        protected void btnSearch_plt_Selected_Click(object sender, EventArgs e)
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

        protected void spPlatform_Click(object sender, EventArgs e)
        {
            txtPlatformSearch.Text = "";
            BindPlatform("");
            divPlatformFilter.Attributes.Add("style", "display:block;");
            divPlatformGroup.Attributes.Add("style", "display:none;");
            ddlPlatformGroup.SelectedIndex = -1;
            spPlatform.Attributes.Add("class", "tabCountry");
            spPlatformGroup.Attributes.Remove("class");
            spPlatformGroup.Attributes.Add("class", "tabTerritory");
            upMainPlatform.Update();

            ResetSelectedPlatform();
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);
        }

        protected void spPlatformGroup_Click(object sender, EventArgs e)
        {
            ddlPlatformGroup.SelectedIndex = -1;
            uctabPTV.PlatformCodes_Display = "0";
            uctabPTV.PopulateTreeNode("N", txtSelectedPlatformSearch.Text.Trim());
            divPlatformFilter.Attributes.Add("style", "display:none;");
            divPlatformGroup.Attributes.Add("style", "display:block;");
            spPlatformGroup.Attributes.Add("class", "tabCountry");
            spPlatform.Attributes.Remove("class");
            spPlatform.Attributes.Add("class", "tabTerritory");
            upMainPlatform.Update();
            ResetSelectedPlatform();
            hdnIsCriteriaChange.Value = "Y";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkedChangeEvent", "checkedChangeEvent();", true);

        }

        [WebMethod(EnableSession = true)]
        public string LoadUserControl()
        {
            using (Page page = new Page())
            {
                int[] arrPlatform;
                arrPlatform = new Platform_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y")
                                                                                    .Select(p => p.Platform_Code).Distinct().ToArray();
                RightsU_WebApp.UserControl.UC_Platform_Tree userControl = (RightsU_WebApp.UserControl.UC_Platform_Tree)page.LoadControl("Reports/UserControl/UC_Platform_Tree.ascx");
                userControl.PlatformCodes_Display = string.Join(",", arrPlatform);
                userControl.Connection_Str = ObjLoginEntity.ConnectionStringName;
                userControl.PopulateTreeNode("N");
                System.Web.UI.HtmlControls.HtmlForm form = new System.Web.UI.HtmlControls.HtmlForm();
                form.Controls.Add(userControl);
                page.Controls.Add(form);
                using (StringWriter writer = new StringWriter())
                {
                    //page.Controls.Add(userControl);
                    HttpContext.Current.Server.Execute(page, writer, false);
                    return writer.ToString();
                }
            }
        }

        protected void btnSubmitReport_Click(object sender, EventArgs e)
        {
            hdnTabVal.Value = "";
            hdnDupQueryName.Value = "N";
            string query = "SELECT Parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'Reports_DB'";
            string result = DatabaseBroker.ProcessScalarReturnString(query);

            query = "SELECT COUNT(*) FROM " + result + "..Avail_Report_Schedule WHERE ReportName = '" + txtReportName.Text.Trim() + "' AND Report_Status='Y'";
            int count = DatabaseBroker.ProcessScalarDirectly(query);
            //if (count >= 1 && rdQueryYes.Checked == true)
            if (count >= 1)
            {
                hdnIsSaveQuery.Value = "Y";
                hdnDupQueryName.Value = "Y";

                //CreateMessageAlert(btnSubmit,"ABC");
                //return;
            }
            else
            {
                hdnIsSaveQuery.Value = "";
                //liImgResults.Attributes["class"] = "active";
                //liImgCriteria.Attributes["class"] = "";
                //liImgSavedQuery.Attributes["class"] = "";
                //tblCriteria.Attributes["style"] = "display:none";
                //SavedQuery.Attributes["style"] = "display:none";
                //Results.Attributes["style"] = "";
                hdnTabName.Value = "Result";
                showHideTab();
                //if (rdQueryYes.Checked == true)
                //{
                ShowResults("Y");

                BindGridView();
                //}
                //else
                //{
                //    if (hdnIsCriteriaChange.Value == "Y")
                //    {
                //        ShowResults("N");
                //    }
                //}
            }

        }

        private void BindGridView(bool showNorecAlert = true)
        {
            if (PageNo == 0)
                PageNo = 1;

            List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
            Avail_Report_Schedule_UDT objAvail_Report_Schedule_UDT = new Avail_Report_Schedule_UDT();
            objAvail_Report_Schedule_UDT.Visibility = "PR";
            objAvail_Report_Schedule_UDT.Module_Code = Convert.ToInt32(205); ;
            lst_Avail_Report_Schedule_UDT.Add(objAvail_Report_Schedule_UDT);
            int pageSize = 10;
            int RecordCount = 0;
            string isPaging = "Y";

            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            USP_Service objUSP = new USP_Service(ObjLoginEntity.ConnectionStringName);
            List<USP_Get_Title_Avail_Language_Data> objAvailResult = new List<USP_Get_Title_Avail_Language_Data>();
            string strFilter = " ";//AND ISNULL(Report_Status,'''') <> ''X'' ";

            //if (hdnTabVal.Value == "Q")
            strFilter = "AND ((Visibility='PR' AND User_Code = " + objLoginedUser.Users_Code +
                    " ) or (Visibility='RO' AND User_Code IN(select Users_Code from Users where Security_Group_Code=" +
                    "(Select Security_Group_Code from Users where Users_Code=" + objLoginedUser.Users_Code
                    + "))) or Visibility='PU') AND ISNULL(ReportName, '') <> '' AND Report_Status <> 'X' " +
                    "AND BU_CODE =" + ddlBusinessUnit.SelectedValue + " AND Report_Type = 'SQ' AND IndiaCast = 'N' AND Module_Code = " + Convert.ToInt32(205) + " ";


            gvSchedule.DataSource = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginedUser.Users_Code, "F", strFilter, PageNo, "", isPaging, pageSize).ToList();
           // RecordCount = Convert.ToInt32(objRecordCount.Value);
            objAvailResult = objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginedUser.Users_Code, "F", strFilter, PageNo, "", isPaging, pageSize).ToList();
            RecordCount = objAvailResult.Select(s => s.Recordcount).FirstOrDefault();

            GlobalUtil.ShowBatchWisePaging("", pageSize, 5, lblTotal, PageNo, dtLst, RecordCount);
            lblTotal.Text = RecordCount.ToString();
            gvSchedule.DataBind();

            if (RecordCount == 0 && showNorecAlert)
                CreateMessageAlert("No records found");
        }

        protected void dtLst_ItemCommand(object source, DataListCommandEventArgs e)
        {
            gvSchedule.EditIndex = -1;
            PageNo = Convert.ToInt32(e.CommandArgument);

            BindGridView();
            //tblCriteria.Visible = false;
            //SavedQuery.Visible = true;
            //Results.Visible = false;
            //liImgResults.Attributes["class"] = "";
            //liImgCriteria.Attributes["class"] = "";
            //liImgSavedQuery.Attributes["class"] = "active";
            //tblCriteria.Attributes["style"] = "display:none";
            //SavedQuery.Attributes["style"] = "";
            //Results.Attributes["style"] = "display:none";
            hdnTabName.Value = "QueryList";
            showHideTab();
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
                List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
                string intCode = gvSchedule.DataKeys[e.RowIndex].Values[0].ToString();

                ObjectParameter objRecordCount = new ObjectParameter("RecordCount", 10);
                USP_Service objUSP = new USP_Service(ObjLoginEntity.ConnectionStringName);
                objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginedUser.Users_Code, "D", intCode, 0, "", "", 0);

                BindGridView();

            }
            catch (Exception ex) { }
            finally
            {
                //liImgResults.Attributes["class"] = "";
                //liImgCriteria.Attributes["class"] = "";
                //liImgSavedQuery.Attributes["class"] = "active";
                //tblCriteria.Attributes["style"] = "display:none";
                //SavedQuery.Attributes["style"] = "";
                //Results.Attributes["style"] = "display:none";
                hdnTabName.Value = "QueryList";
                showHideTab();

            }

        }

        protected void gvSchedule_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
               (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
            {
                //LinkButton hlnkFileName = e.Row.FindControl("hlnkFileName") as LinkButton;
                //ScriptManager.GetCurrent(this).RegisterPostBackControl(hlnkFileName);

                //Label lblAvail_Report_Schedule_Code = e.Row.FindControl("lblAvail_Report_Schedule_Code") as Label;
                //Label lblReport_Status = e.Row.FindControl("lblReport_Status") as Label;
                //Label lblFileName = e.Row.FindControl("lblFileName") as Label;
                //Label lblMailSent = e.Row.FindControl("lblMailSent") as Label;

                string intCode = gvSchedule.DataKeys[e.Row.RowIndex].Values[0].ToString();

                //if (hdnTabVal.Value == "S")
                //{
                //    string strScript = "refreshStatus('" + lblReport_Status.ClientID + "', '" + lblFileName.ClientID + "', '" + lblMailSent.ClientID + "', " + intCode + ", '" + lblAvail_Report_Schedule_Code.ClientID + "');";
                //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertKey" + intCode, strScript, true);
                //}

            }
        }

        protected void gvSchedule_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "GENERATE":
                    int rowIndex = int.Parse(e.CommandArgument.ToString());
                    int intCode = Convert.ToInt32(gvSchedule.DataKeys[rowIndex]["Avail_Report_Schedule_Code"]);
                    //liImgResults.Attributes["class"] = "active";
                    //liImgCriteria.Attributes["class"] = "";
                    //liImgSavedQuery.Attributes["class"] = "";
                    //tblCriteria.Attributes["style"] = "display:none";
                    //SavedQuery.Attributes["style"] = "display:none";
                    //Results.Attributes["style"] = "";
                    hdnTabName.Value = "Result";
                    showHideTab();
                    hdnIsSaveQuery.Value = "Y";
                    hdnIsCriteriaChange.Value = "Y";
                    ShowResults("R", intCode);
                    hdnTabVal.Value = Convert.ToString(intCode);
                    break;
            }
        }

        protected void btnSaveQuery_Click(object sender, EventArgs e)
        {
            hdnTabVal.Value = "";
            hdnDupQueryName.Value = "N";
            string query = "SELECT Parameter_value FROM System_Parameter_New WHERE Parameter_Name = 'Reports_DB'";
            string result = DatabaseBroker.ProcessScalarReturnString(query);
            StringBuilder sbMovie = new StringBuilder("0");
            StringBuilder sbTitleLanguage = new StringBuilder("0");
            StringBuilder sbTerritory = new StringBuilder("0");
            StringBuilder sbSublicensing = new StringBuilder("0");
            StringBuilder sbDubbingLanguage = new StringBuilder("0");
            StringBuilder sbSubtitlingLanguage = new StringBuilder("0");

            string StartDate = "", EndDate = "", StartMonth, EndYear, Digital = "true";
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
                //EndDate = (txtto.Text == "DD/MM/YYYY" || txtto.Text == "") ? DateTime.MaxValue.ToString("dd/MM/yyyy") : txtto.Text;
                //EndDate = (txtto.Text == "DD/MM/YYYY" || txtto.Text == "") ? null : txtto.Text;
                EndDate = (txtto.Text == "DD/MM/YYYY") ? "" : txtto.Text;
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
            if (StartDate != "")
                hdnStartDate.Value = StartDate.Replace('-', '/');
            else
                hdnStartDate.Value = "";
            if (EndDate != "")
                hdnEndDate.Value = EndDate.Replace('-', '/');
            else
                hdnEndDate.Value = "";
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
            int[] selected_Language = lbLanguage.GetSelectedIndices();
            if (selected_Language.Length > 0)
            {
                foreach (int index in selected_Language)
                {
                    string languageCode = lbLanguage.Items[index].Value;
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
            }

            if (hdnIsDidital.Value == "Y")
                if (chkDigital.Checked)
                {
                    Digital = "true";
                }
                else
                    Digital = "false";
            else
                Digital = "false";

            int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);

            string platformCodes = uctabPTV.PlatformCodes_Selected_Out;
            string isOriginalLang = chkIsOriginalLanguage.Checked.ToString();
            string strPeriodType = rblPeriodType.SelectedValue;
            string strRestRemarks = chkRestRemarks.Checked.ToString();

            //if (isSaveQry == "Y")
            //{
            string strReportName = "";
            //if (rdQueryYes.Checked)
            strReportName = txtReportName.Text.Trim();
            USP_Service objUSP = new USP_Service(ObjLoginEntity.ConnectionStringName);
            string strPlt_EM = chkExact.SelectedValue.ToString() == "" ? "False" : chkExact.SelectedValue;
            string strPlt_MH = chkExact.SelectedValue.ToString() == "MH" ? uctabSelectedplt.PlatformCodes_Selected_Out : "0";
            string strRegion_EM = chkRegion.SelectedValue.ToString() == "" ? "False" : chkRegion.SelectedValue;


            query = "SELECT COUNT(*) FROM " + result + "..Avail_Report_Schedule WHERE ReportName = N'" + txtReportName.Text.Trim() + "' AND Report_Status='Y'";
            if (hdnReportCode.Value != "")
            {
                //query = "SELECT COUNT(*) FROM " + result + "..Avail_Report_Schedule WHERE ReportName = '" + txtReportName.Text.Trim() + "' AND Report_Status='Y' AND"+
                //" Avail_Report_Schedule!=" + hdnReportCode.Value;
            }
            string Codes = hdnTitleCodes.Value;
            int count = DatabaseBroker.ProcessScalarDirectly(query);
            //if (count >= 1 && rdQueryYes.Checked == true)
            if (count >= 1)
            {
                hdnIsSaveQuery.Value = "Y";
                hdnDupQueryName.Value = "Y";

                //CreateMessageAlert(btnSubmit,"ABC");
                //return;
            }
            else
            {
                hdnIsSaveQuery.Value = "";
                //liImgResults.Attributes["class"] = "";
                //liImgCriteria.Attributes["class"] = "";
                //liImgSavedQuery.Attributes["class"] = "active";
                //tblCriteria.Attributes["style"] = "display:none";
                //SavedQuery.Attributes["style"] = "";
                //Results.Attributes["style"] = "display:none";
                hdnTabName.Value = "QueryList";
                showHideTab();
                try
                {
                    string platform_codes = sbTerritory.ToString();
                    string Country_Codes = platformCodes;
                    //hdnstrCriteria.Value += ",N''" + txtReportName.Text + "'',''" + rblVisibility.SelectedValue + "'''";
                    hdnstrCriteria.Value += ",'" + rblVisibility.SelectedValue + "'";
                    ObjectParameter objRecordCount = new ObjectParameter("RecordCount", 10);
                    List<Avail_Report_Schedule_UDT> lst_Avail_Report_Schedule_UDT = new List<Avail_Report_Schedule_UDT>();
                    Avail_Report_Schedule_UDT objAvail_Report_Schedule_UDT = new Avail_Report_Schedule_UDT();
                    objAvail_Report_Schedule_UDT.Title_Code = string.Join(",", sbMovie.ToString());
                    objAvail_Report_Schedule_UDT.Platform_Code = (hdnRegionType.Value == "T") ? "" : platform_codes;
                    objAvail_Report_Schedule_UDT.Country_Code = Country_Codes;
                    objAvail_Report_Schedule_UDT.Is_Original_Language = (chkIsOriginalLanguage.Checked == true ? "1" : "0");
                    objAvail_Report_Schedule_UDT.Dubbing_Subtitling = Dubbing_Subtitling.ToString();
                    objAvail_Report_Schedule_UDT.Language_Code = sbTitleLanguage.ToString();
                    objAvail_Report_Schedule_UDT.Date_Type = rblPeriodType.SelectedValue;
                    objAvail_Report_Schedule_UDT.StartDate = GlobalUtil.MakedateFormat(StartDate);
                    objAvail_Report_Schedule_UDT.EndDate = GlobalUtil.MakedateFormat(EndDate);
                    objAvail_Report_Schedule_UDT.UserCode = objLoginedUser.Users_Code;
                    objAvail_Report_Schedule_UDT.Inserted_On = System.DateTime.Now;
                    objAvail_Report_Schedule_UDT.Report_Status = "Y";
                    objAvail_Report_Schedule_UDT.Visibility = rblVisibility.SelectedValue;
                    // objAvail_Report_Schedule_UDT.ReportName = ReportName;
                    objAvail_Report_Schedule_UDT.RestrictionRemark = chkRestRemarks.Checked.ToString();
                    objAvail_Report_Schedule_UDT.OtherRemark = chkOtherRemarks.Checked.ToString();
                    objAvail_Report_Schedule_UDT.Platform_ExactMatch = strPlt_EM;
                    objAvail_Report_Schedule_UDT.MustHave_Platform = strPlt_MH;
                    objAvail_Report_Schedule_UDT.Exclusivity = ddlExclusive.SelectedValue;
                    objAvail_Report_Schedule_UDT.SubLicenseCode = sbSublicensing.ToString();
                    objAvail_Report_Schedule_UDT.Region_ExactMatch = strRegion_EM;
                    objAvail_Report_Schedule_UDT.Region_MustHave = hdnMustHaveRegionCode.Value;
                    objAvail_Report_Schedule_UDT.Region_Exclusion = hdnExclusionRegionCode.Value;
                    objAvail_Report_Schedule_UDT.Subtit_Language_Code = sbSubtitlingLanguage.ToString();
                    objAvail_Report_Schedule_UDT.Dubbing_Language_Code = sbDubbingLanguage.ToString();
                    objAvail_Report_Schedule_UDT.BU_Code = BU_Code;
                    objAvail_Report_Schedule_UDT.Report_Type = "SQ";
                    objAvail_Report_Schedule_UDT.Digital = false;
                    objAvail_Report_Schedule_UDT.IncludeMetadata = chkMetadata.Checked.ToString();
                    objAvail_Report_Schedule_UDT.Is_IFTA_Cluster = "";
                    objAvail_Report_Schedule_UDT.Platform_Group_Code = "";
                    objAvail_Report_Schedule_UDT.Subtitling_Group_Code = "";
                    objAvail_Report_Schedule_UDT.Subtitling_ExactMatch = "";
                    objAvail_Report_Schedule_UDT.Subtitling_MustHave = "";
                    objAvail_Report_Schedule_UDT.Subtitling_Exclusion = "";
                    objAvail_Report_Schedule_UDT.Dubbing_Group_Code = "";
                    objAvail_Report_Schedule_UDT.Dubbing_ExactMatch = "";
                    objAvail_Report_Schedule_UDT.Dubbing_MustHave = "";
                    objAvail_Report_Schedule_UDT.Dubbing_Exclusion = "";
                    objAvail_Report_Schedule_UDT.Territory_Code = hdnRegionType.Value == "T" ? sbTerritory.ToString() : "";
                    objAvail_Report_Schedule_UDT.IndiaCast = "N";
                    objAvail_Report_Schedule_UDT.Region_On = "IF";
                    objAvail_Report_Schedule_UDT.Include_Ancillary = "N";
                    objAvail_Report_Schedule_UDT.Promoter_Code = "";
                    objAvail_Report_Schedule_UDT.Promoter_ExactMatch = "";
                    objAvail_Report_Schedule_UDT.MustHave_Promoter = "";
                    objAvail_Report_Schedule_UDT.Module_Code = Convert.ToInt32("205");
                    objAvail_Report_Schedule_UDT.Episode_From = Convert.ToInt32("0");
                    objAvail_Report_Schedule_UDT.Episode_To = Convert.ToInt32("0");                   
                    objAvail_Report_Schedule_UDT.ReportName = txtReportName.Text.Trim();
                    lst_Avail_Report_Schedule_UDT.Add(objAvail_Report_Schedule_UDT);
                    objUSP.USP_Get_Title_Avail_Language_Data(lst_Avail_Report_Schedule_UDT, objLoginedUser.Users_Code, "T",  hdnstrCriteria.Value, 0, "", "", 0);

                }
                catch (Exception) { }
                //if (rdQueryYes.Checked == true)
                //{
                //ShowResults("Y");
                BindGridView();
                //}
                //else
                //{
                //    if (hdnIsCriteriaChange.Value == "Y")
                //    {
                //        ShowResults("N");
                //    }
                //}

            }
        }
        protected void showHideTab()
        {
            if (hdnTabName.Value == "QueryList")
            {
                liImgSavedQuery.Attributes["class"] = "active";
                liImgCriteria.Attributes["class"] = "";
                liImgResults.Attributes["class"] = "";
                SavedQuery.Attributes["style"] = "";
                tblCriteria.Attributes["style"] = "display:none";
                Results.Attributes["style"] = "display:none";
                ddlBusinessUnit.Enabled = true;
            }
            else if (hdnTabName.Value == "Criteria")
            {
                liImgSavedQuery.Attributes["class"] = "";
                liImgCriteria.Attributes["class"] = "active";
                liImgResults.Attributes["class"] = "";
                SavedQuery.Attributes["style"] = "display:none";
                tblCriteria.Attributes["style"] = "";
                Results.Attributes["style"] = "display:none";
                ddlBusinessUnit.Enabled = true;
            }
            else if (hdnTabName.Value == "Result")
            {
                liImgSavedQuery.Attributes["class"] = "";
                liImgCriteria.Attributes["class"] = "";
                liImgResults.Attributes["class"] = "active";
                SavedQuery.Attributes["style"] = "display:none";
                tblCriteria.Attributes["style"] = "display:none";
                Results.Attributes["style"] = "";
                ddlBusinessUnit.Enabled = false;
            }
        }

        protected void chkIFTACluster_CheckedChanged(object sender, EventArgs e)
        {
            BindTerritoryList();
        }
    }
}