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
    public partial class Theatrical_Language_Avail : ParentPage
    {
        public User objLoginedUser { get; set; }
        public static string Report_Folder { get; set; }
        protected string MaxSelectedOption;
        protected void Page_Load(object sender, EventArgs e)
        {
            objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
            if (!IsPostBack)
            {
                Page.Header.DataBind();
                string strTodaysDate = DBUtil.getServerDate().ToString("dd/MM/yyyy");
                Report_Folder = GetCurrentLoggedInEntity();
                BindListBoxes();
                txtfrom.Text = strTodaysDate;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AssignDateJQuery", "AssignDateJQuery();", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "InitializeStartDate", "InitializeStartDate();", true);
            }
            else
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "T", "AssignChosenJQuery();", true);
            System_Parameter_New_Service objSystemParamService = new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName);
            MaxSelectedOption = objSystemParamService.SearchFor(p => p.Parameter_Name == "MaxSelectedOption").ToList().FirstOrDefault().Parameter_Value;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "sliceOption", "sliceOption();", true);
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "sliceLanguageOption", "sliceLanguageOption();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "toolbarCss", "Assign_Css();", true);
        }

        private void BindListBoxes()
        {
            BindddlBusiness_Unit();
            BindListMovie();
            BindTerritoryList();
            //BindLanguageList();
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

        protected void lnkbtnPltform_Click(object sender, EventArgs e)
        {
            var rslt = string.Empty;
            Platform_Service objPlatformService = new Platform_Service(ObjLoginEntity.ConnectionStringName);
            rslt = string.Join(",", objPlatformService.SearchFor(p => p.Is_Active == "Y").Select(p => p.Platform_Code));
            string[] selectedPlatforms = hdnPlatform.Value.Split(',');
            if (!string.IsNullOrEmpty(rslt))
            {
                uctabPTV.PlatformCodes_Selected = selectedPlatforms;
                uctabPTV.PlatformCodes_Display = rslt;
                btnSavePlatform.Visible = true;
                uctabPTV.PopulateTreeNode("N");
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "popup", "OpenPopup();", true);
            }
            else
                CreateMessageAlert("No Platforms available.");
        }

        protected void btnSavePlatform_Click(object sender, EventArgs e)
        {
            hdnPlatform.Value = uctabPTV.PlatformCodes_Selected_Out;
            if (!string.IsNullOrEmpty(uctabPTV.PlatformCodes_Selected_Out))
                lnkbtnPltform.Text = uctabPTV.PlatformCodes_Selected_Out.Split(',').Count() + " selected";
            else
                lnkbtnPltform.Text = "Select Platforms";
            UpPlatformPopup.Update();
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
            var countryList = territoryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Thetrical == "Y").Select(c => new ListItem { Text = c.Territory_Name, Value = "T" + c.Territory_Code }).ToList();
            Country_Service countryServiceInstance = new Country_Service(ObjLoginEntity.ConnectionStringName);
            countryList.AddRange(countryServiceInstance.SearchFor(c => c.Is_Active == "Y" && c.Is_Theatrical_Territory == "Y").Select(c => new ListItem { Text = c.Country_Name, Value = "C" + c.Country_Code }).ToList());
            lstLTerritory.DataSource = countryList;
            lstLTerritory.DataTextField = "Text";
            lstLTerritory.DataValueField = "Value";
            lstLTerritory.DataBind();
        }

        //public void BindLanguageList()
        //{
        //    Language_Group_Service langGroupServiceInstance = new Language_Group_Service(objLoginEntity.ConnectionStringName);
        //    var langList = langGroupServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Group_Name, Value = "G" + l.Language_Group_Code }).ToList();
        //    Language_Service langServiceInstance = new Language_Service();
        //    langList.AddRange(langServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Name, Value = "L" + l.Language_Code }).ToList());
        //    lbLanguage.DataSource = langList;
        //    lbLanguage.DataTextField = "Text";
        //    lbLanguage.DataValueField = "Value";
        //    lbLanguage.DataBind();

        //}

        public static string GetCurrentLoggedInEntity()
        {

            return ((LoginEntity)System.Web.HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity]).ReportingServerFolder;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            StringBuilder sbMovie = new StringBuilder("0");
            StringBuilder sbTerritory = new StringBuilder("0");
            StringBuilder sbDubbingSubtitling = new StringBuilder("0");
            StringBuilder sbLanguage = new StringBuilder("0");

            //if (rblDateCriteria.SelectedValue == "FL") { tdAddYear.Style.Add("display", "block"); }
            //else { tdAddYear.Style.Add("display", "none"); }

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
            //int[] selected_Language = lbLanguage.GetSelectedIndices();
            //if (selected_Language.Length > 0)
            //{
            //    foreach (int index in selected_Language)
            //    {
            //        string languageCode = lbLanguage.Items[index].Value;
            //        if (sbLanguage.Length == 0)
            //            sbLanguage.Append(languageCode);
            //        else
            //            sbLanguage.Append("," + languageCode);
            //    }
            //}

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
            parm[3] = new ReportParameter("Is_Original_Language", "1");
            parm[4] = new ReportParameter("Dubbing_Subtitling", sbDubbingSubtitling.ToString());
            parm[5] = new ReportParameter("GroupBy", "L");
            parm[6] = new ReportParameter("Node", "C");
            parm[7] = new ReportParameter("Language_Code", sbLanguage.ToString());
            parm[8] = new ReportParameter("Date_Type", rblDateCriteria.SelectedValue);
            parm[9] = new ReportParameter("StartDate", startDate);
            parm[10] = new ReportParameter("EndDate", endDate);
            parm[11] = new ReportParameter("ShowRemark", chkShowRemarks.Checked.ToString());

            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport("Theatrical_Availability_Languagewise");
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
                txtto.Text = Convert.ToDateTime(txtfrom.Text.Trim().ToString().Trim('\'')).AddYears(1).ToString("dd/MM/yyyy");
            else
                txtto.Text = string.Empty;
        }
    }
}