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

namespace RightsU_WebApp.Reports
{
    public partial class Title_Avail_Language_2 : ParentPage
    {
        protected string MaxSelectedOption;
        public User objLoginedUser { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
            ((Home)this.Page.Master).setVal("TitleAvailability2");
            if (!IsPostBack)
            {
                Page.Header.DataBind();
                AddAttributes();
                BindListBoxes();
                //string strTodaysDate = DBUtil.getServerDate().ToString("dd/MM/yyyy");
                //txtfrom.Text = strTodaysDate;
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "InitializeStartDate", "InitializeStartDate();", true);
            }
            else
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "T", "AssignChosenJQuery();", true);
            }
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            MaxSelectedOption = objSystemParamService.SearchFor(p => p.Parameter_Name == "MaxSelectedOption").ToList().FirstOrDefault().Parameter_Value;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "sliceOption", "sliceOption();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "sliceLanguageOption", "sliceLanguageOption();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "toolbarCss", "Assign_Css();", true);
        }

        private void BindListBoxes()
        {
            BindddlBusiness_Unit();
            BindListMovie();
            BindTerritoryList();
            BindLanguageList();
            PlatformGroupConfig();
        }
        private void PlatformGroupConfig()
        {
            ddlPlatformGroup.DataSource = new Platform_Group_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Platform_Group_Code != 0 && p.Is_Active == "Y").Select(R => new { Platform_Group_Value = R.Platform_Group_Code, Platform_Group_Name = R.Platform_Group_Name }).Distinct().ToList();
            ddlPlatformGroup.DataTextField = "Platform_Group_Name";
            ddlPlatformGroup.DataValueField = "Platform_Group_Value";
            ddlPlatformGroup.DataBind();
            hdnPGCount.Value = ddlPlatformGroup.Items.Count.ToString();
        }
        private void BindddlBusiness_Unit()
        {
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            string SelectedBU = objSystemParamService.SearchFor(p => p.Parameter_Name == "Title_Avail_BU").ToList().FirstOrDefault().Parameter_Value;
            string[] arr_BU_Codes = SelectedBU.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            ddlBusinessUnit.DataSource = new Business_Unit_Service(ObjLoginEntity.ConnectionStringName).SearchFor(
                b => b.Users_Business_Unit.Any(UB => UB.Business_Unit_Code == b.Business_Unit_Code && UB.Users_Code == objLoginedUser.Users_Code)
                && arr_BU_Codes.Contains(b.Business_Unit_Code.ToString())
                ).Select(R => new { Business_Unit_Code = R.Business_Unit_Code, Business_Unit_Name = R.Business_Unit_Name }).ToList();
            ddlBusinessUnit.DataTextField = "Business_Unit_Name";
            ddlBusinessUnit.DataValueField = "Business_Unit_Code";
            ddlBusinessUnit.DataBind();
        }
        private void AddAttributes()
        {
            txtSearch.Attributes.Add("OnKeyPress", "doNotAllowTag();fnEnterKey('" + btnSearch_plt.ClientID + "');");
        }

        private void BindPlatform(string strSearch)
        {
            int[] arrPlatform;
            if (hdnIsMustHave.Value == "Y")
            {
                string SelectedPlatform = string.Empty;
                if (chkSpecficPlt.Checked == true)
                {
                    int ddlPlatformGroupValue = Convert.ToInt32(ddlPlatformGroup.SelectedValue);
                    string[] arrPlatform1 = new Platform_Group_Details_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Platform_Group_Code == ddlPlatformGroupValue)
                                                                            .Select(p => p.Platform_Code.ToString()).Distinct().ToArray();
                    if (arrPlatform1.Count() > 0)
                    {
                        SelectedPlatform = string.Join(",", arrPlatform1);
                    }
                }
                else
                { SelectedPlatform = hdnPlatform.Value; }

                if (SelectedPlatform != string.Empty)
                {
                    uctabPTV.PlatformCodes_Display = SelectedPlatform;// string.Join(",", arrPlatform);
                    uctabPTV.PlatformCodes_Selected = hdnPlatformMH.Value.Split(',');
                }
                else
                    uctabPTV.PlatformCodes_Display = "0";
            }
            else
            {
                arrPlatform = new Platform_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y"
                                                                        && (p.Platform_Hiearachy.Contains(txtSearch.Text) || txtSearch.Text.Trim() == ""))
                                                                        .Select(p => p.Platform_Code).Distinct().ToArray();

                if (arrPlatform.Count() > 0)
                {
                    uctabPTV.PlatformCodes_Display = string.Join(",", arrPlatform);
                    uctabPTV.PlatformCodes_Selected = hdnPlatform.Value.Split(',');
                }
                else
                    uctabPTV.PlatformCodes_Display = "0";
            }

            string[] strMH = hdnPlatformMH.Value.Split(',');
            if (strMH.Count() > 0 && strMH[0] != "" && strMH[0] != "0")
                lnkbtPltMustHv.Text = strMH.Count() + " Must Have";
            else
                lnkbtPltMustHv.Text = "Must Have ";

            uctabPTV.PopulateTreeNode("N", txtSearch.Text.Trim());
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);
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
            Country_Service countryServiceInstance = new Country_Service(ObjLoginEntity.ConnectionStringName);
            var countryList = countryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Theatrical_Territory != "Y").Select(c => new ListItem { Text = c.Country_Name, Value = "C" + c.Country_Code }).ToList();
            countryList.AddRange(territoryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Thetrical != "Y").Select(c => new ListItem { Text = c.Territory_Name, Value = "T" + c.Territory_Code }).ToList());
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

        protected void lnkbtnPltform_Click(object sender, EventArgs e)
        {
            lblHeadingPopUp.Text = "Platform / Rights";
            HideShowAddYear();
            txtSearch.Focus();
            txtSearch.Text = "";
            hdnIsMustHave.Value = "";
            BindPlatform("");
        }

        protected void btnSavePlatform_Click(object sender, EventArgs e)
        {
            HideShowAddYear();
            string strMessage = String.Empty;
            if (hdnIsMustHave.Value == "Y")
                hdnPlatformMH.Value = uctabPTV.PlatformCodes_Selected_Out;
            else
                hdnPlatform.Value = uctabPTV.PlatformCodes_Selected_Out;

            //strMessage = uctabPTV.PlatformCodes_Selected_Out;
            //if (strMessage == "" || strMessage.Trim() == "Platform / Rights")
            //{
            //    CreateMessageAlert("Please select atleast one platform");
            //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "popup", "OpenPopup();", true);
            //    return;
            //}

            if (hdnIsMustHave.Value == "Y")
            {
                if (!string.IsNullOrEmpty(uctabPTV.PlatformCodes_Selected_Out))
                    lnkbtPltMustHv.Text = uctabPTV.PlatformCodes_Selected_Out.Split(',').Count() + " Must Have";
                else
                    lnkbtPltMustHv.Text = "Must Have";
            }
            else
            {
                hdnPlatformMH.Value = string.Empty;
                lnkbtPltMustHv.Text = "Must Have";

                if (!string.IsNullOrEmpty(uctabPTV.PlatformCodes_Selected_Out))
                    lnkbtnPltform.Text = uctabPTV.PlatformCodes_Selected_Out.Split(',').Count() + " selected";
                else
                    lnkbtnPltform.Text = "Select Platforms";
            }

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertKey", "ClosePopup();", true);
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
            HideShowAddYear();
            txtSearch.Text = "";
            BindPlatform("");
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            StringBuilder sbMovie = new StringBuilder("0");
            StringBuilder sbTerritory = new StringBuilder("0");
            StringBuilder sbDubbingSubtitling = new StringBuilder("0");
            StringBuilder sbLanguage = new StringBuilder("0");

            HideShowAddYear();

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
            
            if (chkSpecficPlt.Checked == true)
            {
                int ddlPlatformGroupValue = Convert.ToInt32(ddlPlatformGroup.SelectedValue);
                string[] arrPlatform1 = new Platform_Group_Details_Service(ObjLoginEntity.ConnectionStringName).SearchFor(p => p.Platform_Group_Code == ddlPlatformGroupValue)
                                                                        .Select(p => p.Platform_Code.ToString()).Distinct().ToArray();
                if (arrPlatform1.Count() > 0)
                {
                    SelectedPlatform = string.Join(",", arrPlatform1);
                }
            }
            else
            { SelectedPlatform = hdnPlatform.Value; }
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

            if (selected_Movie.Length == 0 && selected_Country.Length == 0 && selected_Country.Length == 0 && SelectedPlatform == "0")
            {
                CreateMessageAlert("Please select atleast one Title, Region or Platform .");
                return;
            }

            if (!chkIsOriginalLanguage.Checked && chkDubbingSubtitling.SelectedIndex == -1)
            {
                CreateMessageAlert("Please select atleast one language type.");
                return;
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
            startDate = txtMonths.Text;
            endDate = txtYears.Text;
            //startDate = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtfrom.Text.Trim()).ToString().Trim('\'')).ToString("yyyy-MM-dd");

            //if (!string.IsNullOrEmpty(txtto.Text) && !txtto.Text.Trim().Equals("DD/MM/YYYY"))
            //    endDate = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtto.Text.Trim()).ToString().Trim('\'')).ToString("yyyy-MM-dd");
            //else
            //{
            //    if (rblDateCriteria.SelectedValue == "FL" && chkAddYear.Checked)
            //        endDate = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtfrom.Text.Trim()).ToString().Trim('\'')).AddYears(1).ToString("yyyy-MM-dd");
            //    else
            //        endDate = DateTime.MaxValue.ToString("yyyy-MM-dd");
            //}

            string PltExactMatch = "false";
            if (hdnPlatformMH.Value.Trim() != string.Empty && hdnPlatformMH.Value.Trim() != "0")
                PltExactMatch = "MH";
            else
                hdnPlatformMH.Value = "0";

            if (chkExact.Checked == true)
            {
                PltExactMatch = "EM";
            }
            int BU_Code = Convert.ToInt32(ddlBusinessUnit.SelectedValue);

            ReportCredential();
            ReportParameter[] parm = new ReportParameter[17];


            parm[0] = new ReportParameter("Title_Code", sbMovie.ToString());
            parm[1] = new ReportParameter("Platform_Code", SelectedPlatform);
            parm[2] = new ReportParameter("Country_Code", sbTerritory.ToString());
            parm[3] = new ReportParameter("Is_Original_Language", IsOriginalLanguage.ToString());
            parm[4] = new ReportParameter("Dubbing_Subtitling", sbDubbingSubtitling.ToString());
            parm[5] = new ReportParameter("GroupBy", rdbGroupBy.SelectedValue);
            parm[6] = new ReportParameter("Node", "C");//rdlNode.SelectedValue
            parm[7] = new ReportParameter("Language_Code", sbLanguage.ToString());
            parm[8] = new ReportParameter("Date_Type", "FL");//rblDateCriteria.SelectedValue
            parm[9] = new ReportParameter("StartDate", startDate);
            parm[10] = new ReportParameter("EndDate", endDate);
            parm[11] = new ReportParameter("ShowRemark", chkShowRemarks.Checked.ToString());
            parm[12] = new ReportParameter("PltExactMatch", PltExactMatch);
            parm[13] = new ReportParameter("MustHavePlatform", hdnPlatformMH.Value);
            parm[14] = new ReportParameter("Created_By", objLoginedUser.First_Name + " " + objLoginedUser.Last_Name);
            parm[15] = new ReportParameter("CallFrom", "2");
            parm[16] = new ReportParameter("BU_Code", BU_Code.ToString());

            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport("Title_Availability_Languagewise_2");
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
            HideShowAddYear();
            BindListMovie();
        }

        protected void chkAddYear_CheckedChanged(object sender, EventArgs e)
        {
            //if (rblDateCriteria.SelectedValue == "FL" && chkAddYear.Checked)
            //    txtto.Text = Convert.ToDateTime(GlobalUtil.GetFormatedDate(txtfrom.Text.Trim()).ToString().Trim('\'')).AddYears(1).ToString("dd/MM/yyyy");
            //else
            //    txtto.Text = string.Empty;
        }

        private void HideShowAddYear()
        {
            ddlPlatformGroup.Style.Add("display", "none");
            lnkbtnPltform.Style.Add("display", "none");
            if (chkSpecficPlt.Checked == true)
                ddlPlatformGroup.Style.Add("display", "inline-block");
            else
                lnkbtnPltform.Style.Add("display", "block");

            string[] strMH = hdnPlatformMH.Value.Split(',');
            if (strMH.Count() > 0 && strMH[0] != "" && strMH[0] != "0")
                lnkbtPltMustHv.Text = strMH.Count() + " Must Have";
            else
                lnkbtPltMustHv.Text = "Must Have ";
            //if (rblDateCriteria.SelectedValue == "FL") { tdAddYear.Style.Add("display", "block"); }
            //else { tdAddYear.Style.Add("display", "none"); }


            //if (rbPlatform.SelectedValue == "P") { tdAllPlt.Style.Add("display", "block"); tdDigPlt.Style.Add("display", "none"); }
            //else { tdAllPlt.Style.Add("display", "none"); tdDigPlt.Style.Add("display", "block"); }
        }

        protected void lnkbtPltMustHv_Click(object sender, EventArgs e)
        {
            lblHeadingPopUp.Text = "Must Have";
            HideShowAddYear();
            txtSearch.Focus();
            txtSearch.Text = "";
            hdnIsMustHave.Value = "Y";
            BindPlatform("");
        }

    }
}