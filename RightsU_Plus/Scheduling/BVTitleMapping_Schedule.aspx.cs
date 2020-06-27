using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;
using RightsU_BLL;
using RightsU_Entities;


    public partial class BVTitleMapping_Schedule : ParentPage
    {

        #region----------------Properties------------------

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

        public string RedirectTo
        {
            get
            {
                if (ViewState["RedirectTo"] == null)
                    ViewState["RedirectTo"] = string.Empty;
                return Convert.ToString(ViewState["RedirectTo"]);
            }
            set { ViewState["RedirectTo"] = value; }
        }

        private int _recordPerPage = 20;
        public int recordPerPage
        {
            get { return _recordPerPage; }
            set { _recordPerPage = value; }
        }

        public ArrayList arrBVHouseIDDataMain
        {
            get
            {
                if (Session["arrBVHouseIDDataMain"] == null)
                    Session["arrBVHouseIDDataMain"] = new ArrayList();
                return (ArrayList)Session["arrBVHouseIDDataMain"];
            }
            set { Session["arrBVHouseIDDataMain"] = value; }
        }

        //public ICollection arrDealTitles
        //{
        //    get
        //    {
        //        if (Session["arrDealTitles"] == null)
        //            Session["arrDealTitles"] = new ArrayList();
        //        return (ArrayList)Session["arrDealTitles"];
        //    }
        //    set { Session["arrDealTitles"] = value; }
        //}

        public dynamic arrDealTitles
        {
            get { return Session["arrDealTitles"]; }
            set { Session["arrDealTitles"] = value; }
        }

        public string Titles_Search
        {
            get
            {
                if (Session["Titles_Search"] == null)
                    Session["Titles_Search"] = string.Empty;
                return (string)Session["Titles_Search"];
            }
            set { Session["Titles_Search"] = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Page.Header.DataBind();
                Session["arrBVHouseIDDataMain"] = null;
                FillArrayListForDropDowns();
                BindTitleDropdown();
                Set_Srch_Criteria();
                BindGrid();

                if (Request.QueryString["RedirectTo"] != null)
                    RedirectTo = Convert.ToString(Request.QueryString["RedirectTo"]);

                if (RedirectTo != "HIU")
                    btnCancel.Visible = false;
            }

            RegisterJS();
        }

        #region----------------Methods----------------------

        public void BindGrid()
        {
            BVHouseidData objExternalTitle = new BVHouseidData();
            Criteria objCriteria = new Criteria();

            if (PageNo == 0)
                PageNo = 1;
            string Program_Category = Convert.ToString(new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault());
            hdnSearch.Value += " AND ISNULL(Is_Mapped,'N') = 'N' AND ISNULL(IsIgnore,'N') = 'N' AND ISNULL([Type],'S') = 'S' and Program_Category not in ('" + Program_Category + "')";

            objCriteria.ClassRef = objExternalTitle;
            objCriteria.IsPagingRequired = true;
            objCriteria.RecordPerPage = 20;
            objCriteria.RecordCount = GlobalUtil.ShowBatchWisePaging(objExternalTitle, hdnSearch.Value, objCriteria.RecordPerPage, 5, lblTotal, PageNo, dtLst);
            objCriteria.PageNo = PageNo;

            ArrayList arr = objCriteria.Execute(hdnSearch.Value);

            var List = (from BVHouseidData obj in arr select obj).Select(y => y.BVTitle).Distinct();

            gvTitleMapping.DataSource = arr;
            gvTitleMapping.DataBind();

            if (gvTitleMapping.Rows.Count == 0)
                DBUtil.AddDummyRowIfDataSourceEmpty(gvTitleMapping, new BVHouseidData());
            updatePanelouter.Update();
        }

        private void BindTitleDropdown()
        {
            string Program_Category = Convert.ToString(new System_Parameter_New_Service(ObjLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault());
            lbBVTitleSearch.DataSource = new BV_HouseId_Data_Service(ObjLoginEntity.ConnectionStringName).SearchFor(x => x.BV_HouseId_Data_Code > 0 && x.Program_Category != Program_Category).Select(s => new { Title_Name = s.BV_Title }).Distinct().ToList();
            lbBVTitleSearch.DataTextField = "Title_Name";
            lbBVTitleSearch.DataValueField = "Title_Name";
            lbBVTitleSearch.DataBind();
        }

        private void Get_Srch_Criteria()
        {
            int[] selected_Titles = lbBVTitleSearch.GetSelectedIndices();

            if (selected_Titles.Length > 0)
            {
                foreach (int index in selected_Titles)
                {
                    string title = lbBVTitleSearch.Items[index].Value;
                    Titles_Search += title + ",";
                }

                hdnBvTitle.Value = Titles_Search.Trim(',');
            }
            else
                Titles_Search = string.Empty;
        }
        private void Set_Srch_Criteria()
        {
            if (!string.IsNullOrEmpty(Titles_Search.Trim()))
                hdnSearch.Value = Titles_Search.Trim(',');
            else
                hdnSearch.Value = string.Empty;

            if (Titles_Search != null)
            {
                string[] arr = Titles_Search.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                
                foreach (ListItem item in lbBVTitleSearch.Items)
                {
                    if (arr.Contains(item.Value))
                        item.Selected = true;
                }
            }
        }
        private void Reset_Srch_Criteria()
        {
            Titles_Search = string.Empty;
            Session["Titles_Search"] = null;
        }

        private void RegisterJS()
        {
            //txtBVTitleSearch.Attributes.Add("onKeyPress", "doNotAllowTag();fnEnterKey('" + btnSearch.ClientID + "')");
            btnSearch.Attributes.Add("onclick", "javascript:return validateSearch();");
        }

        private void SaveStatusToSession()
        {
            if (Validate())
            {
                foreach (GridViewRow gvRow in gvTitleMapping.Rows)
                {
                    int BVHouseIDDataCode = Convert.ToInt32(gvTitleMapping.DataKeys[gvRow.RowIndex].Values[0]);
                    HtmlInputCheckBox chkCheckAll = (HtmlInputCheckBox)gvRow.FindControl("chkCheckAll");
                    TextBox txtTitleCode = (TextBox)gvRow.FindControl("txtTitleCode");
                    TextBox txtDealTitles = (TextBox)gvRow.FindControl("txtDealTitles");
                    BVHouseidData objBVHouseIdData = new BVHouseidData();
                    Label lblEpisodeNo = (Label)gvRow.FindControl("lblEpisodeNo");
                    HtmlInputCheckBox chkIgnore = (HtmlInputCheckBox)gvRow.FindControl("chkIgnore");

                    objBVHouseIdData.IntCode = BVHouseIDDataCode;
                    objBVHouseIdData.Fetch();
                   
                    try
                    {
                        objBVHouseIdData = (BVHouseidData)(from BVHouseidData obj1 in arrBVHouseIDDataMain where Convert.ToInt32(obj1.IntCode) == BVHouseIDDataCode select obj1).Single();

                        if (chkCheckAll.Checked)
                        {
                            txtDealTitles.Enabled = true;
                            objBVHouseIdData.EpisodeNo = lblEpisodeNo.Text.Trim();
                            if (txtTitleCode.Text.Trim() != "")
                                objBVHouseIdData.MappedDealTitleCode = Convert.ToInt32(txtTitleCode.Text);
                            else
                                objBVHouseIdData.MappedDealTitleCode = 0;
                            objBVHouseIdData.IsMapped = "Y";
                            objBVHouseIdData.IsIgnore = Convert.ToString(chkIgnore.Checked == true ? "Y" : "N");
                            if (objBVHouseIdData.IsIgnore == "Y")
                                objBVHouseIdData.IsMapped = "N";
                            arrBVHouseIDDataMain.Remove(objBVHouseIdData);
                            arrBVHouseIDDataMain.Add(objBVHouseIdData);
                        }
                        else
                        {
                            arrBVHouseIDDataMain.Remove(objBVHouseIdData);
                        }
                    }
                    catch (Exception)
                    {
                        if (chkCheckAll.Checked)
                        {
                            txtDealTitles.Enabled = true;
                            objBVHouseIdData.EpisodeNo = lblEpisodeNo.Text.Trim() ;
                            if (txtTitleCode.Text.Trim()!="")
                            objBVHouseIdData.MappedDealTitleCode = Convert.ToInt32(txtTitleCode.Text);
                            else
                                objBVHouseIdData.MappedDealTitleCode = 0;
                            objBVHouseIdData.IsMapped = "Y";
                            objBVHouseIdData.IsIgnore = Convert.ToString(chkIgnore.Checked == true ? "Y" : "N");
                            if (objBVHouseIdData.IsIgnore == "Y")
                                objBVHouseIdData.IsMapped = "N";
                            arrBVHouseIDDataMain.Add(objBVHouseIdData);
                        }
                        else
                        {
                            arrBVHouseIDDataMain.Remove(objBVHouseIdData);
                        }
                    }
                }
                BindGrid();
            }
        }

        public bool Validate()
        {
            string TITLE_Episode_No = "";
            bool result = true;

            foreach (GridViewRow gvRow in gvTitleMapping.Rows)
            {
                int BVHouseIDDataCode = Convert.ToInt32(gvTitleMapping.DataKeys[gvRow.RowIndex].Values[0]);
                HtmlInputCheckBox chkCheckAll = (HtmlInputCheckBox)gvRow.FindControl("chkCheckAll");
                //DropDownList ddlDealTitle = (DropDownList)gvRow.FindControl("ddlDealTitle");
                TextBox txtTitleCode = (TextBox)gvRow.FindControl("txtTitleCode");
                TextBox txtDealTitles = (TextBox)gvRow.FindControl("txtDealTitles");
                BVHouseidData objBVHouseIdData = new BVHouseidData();
                Label lblEpisodeNo = (Label)gvRow.FindControl("lblEpisodeNo");
                HtmlInputCheckBox chkIgnore = (HtmlInputCheckBox)gvRow.FindControl("chkIgnore");

                if (!chkIgnore.Checked && chkCheckAll.Checked)
                {
                    lblEpisodeNo.Text = lblEpisodeNo.Text == "" ? "1" : lblEpisodeNo.Text;
                    TITLE_Episode_No += txtTitleCode.Text.ToString() + "~" + lblEpisodeNo.Text + ",";
                }
            }

            TITLE_Episode_No = TITLE_Episode_No.Trim(',');
            USP_Service objUS = null;
            objUS = new USP_Service(ObjLoginEntity.ConnectionStringName);
            List<USP_Validate_Episode_Result> objTitleCnt = objUS.USP_Validate_Episode(TITLE_Episode_No,"M").ToList();
            int result_count = objTitleCnt.Count;
            var arrInvalidData = objTitleCnt.ToList();

            if (result_count > 0)
            {
                gvMappingException.DataSource = arrInvalidData;
                gvMappingException.DataBind();
                OpenInvalidMappingPopup();
                result = false;
            }
            
            return result;
        }

        private void OpenInvalidMappingPopup()
        {
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "pop up", "OpenPopup('MappingErrorPopup');", true);
        }
        private void CloseInvalidMappingPopup()
        {
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "Close", "ClosePopup('MappingErrorPopup');", true);
        }

        public void MapAllCheckedData()
        {
            ArrayList arr = new ArrayList();
            arr = arrBVHouseIDDataMain;
            SaveStatusToSession();

            if (hdnIntCode.Value == "")
            {
                CreateMessageAlert("Please select at least one CheckBox");
            }
            else
            {
                string msg = string.Empty;
                SqlTransaction sqlTrans = null;

                try
                {
                    foreach (BVHouseidData objBVHouseIdData in arrBVHouseIDDataMain)
                    {
                        objBVHouseIdData.IsDirty = true;
                        objBVHouseIdData.IsProxy = false;
                        //objBVHouseIdData.IsTransactionRequired = true; //--------- SET TRANSACTION ---------//

                        //if (sqlTrans == null)
                        //    objBVHouseIdData.IsBeginningOfTrans = true;
                        //else
                        //    objBVHouseIdData.SqlTrans = sqlTrans;      //--------- END SET TRANSACTION ---------//

                        msg = objBVHouseIdData.Save();
                        //sqlTrans = (SqlTransaction)objBVHouseIdData.SqlTrans;

                        //if (msg.ToUpper() == "D")
                        //{
                        //    throw (new DuplicateRecordException("House ID already assigned to different Title."));
                        //}

                        //    //objBVHouseIdData.ReprocessScheduleUnmappedHouseId(objBVHouseIdData.UploadFileCode);
                        //    //objBVHouseIdData.ReprocessScheduleUnmappedHouseId(objBVHouseIdData.BVTitle);
                    }

                    string strTitles = string.Empty;
                    var var_DistinctBVTitles = (from BVHouseidData obj in arrBVHouseIDDataMain select obj.BVTitle).Distinct();
                    ArrayList ArrDistinctBVTitles = new ArrayList(var_DistinctBVTitles.ToList());
                    BVHouseidData objBVHouseIdData_Temp = new BVHouseidData();

                    foreach (string str in ArrDistinctBVTitles)
                    {
                        //objBVHouseIdData_Temp.ReprocessAsRun(str, ref sqlTrans);
                        strTitles = strTitles + "'" + str.Replace("'", "''") + "'" + ',';
                    }

                    strTitles = strTitles.Trim(',');
                    strTitles = strTitles.Trim();

                    objBVHouseIdData_Temp.ReprocessScheduleUnmappedHouseId(strTitles, ref sqlTrans);    // SCHEDULE FILE REPROCESS
                    //objBVHouseIdData_Temp.ReprocessAsRun(strTitles, ref sqlTrans);                      // AsRun FILE REPROCESS 
                }
                catch (DuplicateRecordException ex)
                {
                    CreateMessageAlert("ERROR : " + ex.Message);
                    //if (sqlTrans != null)
                    //    if (sqlTrans.Connection != null)
                    //        sqlTrans.Rollback();
                }
                catch (Exception ex)
                {
                    CreateMessageAlert("ERROR : " + ex.Message);
                    //if (sqlTrans != null)
                    //    if (sqlTrans.Connection != null)
                    //        sqlTrans.Rollback();
                }
                finally
                {
                    //if (sqlTrans.Connection != null)
                    //    sqlTrans.Commit();

                    //if (sqlTrans != null)
                    //    if (sqlTrans.Connection != null)
                    //        if (sqlTrans.Connection.State == ConnectionState.Open)
                    //            sqlTrans.Connection.Close();

                    //sqlTrans = null;

                    //if (msg.ToUpper() == "U")
                    //{
                    CreateMessageAlert("Title Mapped Successfully");
                    arrBVHouseIDDataMain = null;
                    BindGrid();
                    //}
                }
            }
        }

        private void FillArrayListForDropDowns()
        {
            //string strTitleFilter = " and Title_Code in (select Title_Code from Acq_Deal_Movie where Acq_Deal_Code in ("
            //+ "SELECT Acq_Deal_Code from Acq_Deal where Entity_Code=" + objLoginUser.objEntity.IntCode + " and ISNULL(Is_Active,'N') = 'Y' "
            //+ "AND ISNULL(Deal_Workflow_Status,'N') = 'A' and Deal_Type_Code in (" + GlobalParams.Deal_Type_Movie + ")))";

            Session["arrDealTitles"] = null;
            var lst_Title = new Title_Service(ObjLoginEntity.ConnectionStringName).SearchFor(
                                                            x => x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Deal_Workflow_Status == "A" &&
                                                            AM.Title_Code == x.Title_Code)
                                                           )
                            .Select(R => new { Title_Code = R.Title_Code, Title_Name = R.Title_Name }).OrderBy(O => O.Title_Name).ToArray();
            arrDealTitles = lst_Title;
        }

        #endregion

        #region---------------Grid_Events----------------------

        protected void gvTitleMapping_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (DataControlRowType.DataRow == e.Row.RowType && e.Row.RowState != DataControlRowState.Edit &&
             (e.Row.RowState == DataControlRowState.Normal || e.Row.RowState == DataControlRowState.Alternate))
            {
                //string id
                //TextBox txtReleaseDate = (TextBox)e.Row.FindControl("txtReleaseDate");
                //id=txtReleaseDate.ClientID;
                //txtReleaseDate.Attributes.Add("Readonly", "javascript:textReadOnly('" + id + "');");

                Label lblIntCode = (Label)e.Row.FindControl("lblIntCode");
                //DropDownList ddlDealTitle = (DropDownList)e.Row.FindControl("ddlDealTitle");
                TextBox txtDealTitles = (TextBox)e.Row.FindControl("txtDealTitles");
                TextBox txtTitleCode = (TextBox)e.Row.FindControl("txtTitleCode");
                HtmlInputCheckBox chkCheckAll = (HtmlInputCheckBox)e.Row.FindControl("chkCheckAll");

                chkCheckAll.Attributes.Add("onclick", "javascript:IntCodeInHdnField('" + chkCheckAll.ClientID + "','" + lblIntCode.Text + "')");
                HtmlInputCheckBox chkIgnore = (HtmlInputCheckBox)e.Row.FindControl("chkIgnore");
                chkIgnore.Attributes.Add("onclick", "javascript:return CheckUnCheckIngnoreChk('" + chkIgnore.ClientID + "','" + gvTitleMapping.ClientID + "'," + e.Row.RowIndex + ");");

                //string strTitleFilter = " and title_code in(select title_code from deal_movie where deal_code in (select deal_code from Deal where entity_code=" + objLoginUser.objEntity.IntCode + " and ISNULL(is_active,'N') = 'Y' AND ISNULL(deal_workflow_status,'N') = 'A'))";
                //DBUtil.BindDropDownList(ref ddlDealTitle, new Title(),strTitleFilter , "englishTitle", "IntCode", true, "Title");                
                //try
                //{
                //    ddlDealTitle.DataSource = null;
                //    ddlDealTitle.DataSource = arrDealTitles;
                //    ddlDealTitle.DataTextField = "Title_Name";
                //    ddlDealTitle.DataValueField = "Title_Code";
                //    ddlDealTitle.DataBind();
                //    ddlDealTitle.Items.Insert(0, new ListItem("- - - Please select - - -", "0"));
                //}
                //catch (Exception exmsg)
                //{

                //}

                string[] hdnIntCodeValue = hdnIntCode.Value.Replace("!", ",").Replace("~", "").Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                foreach (string code in hdnIntCodeValue)
                {
                    if (lblIntCode.Text == code)
                    {
                        BVHouseidData obj = new BVHouseidData();
                        chkCheckAll.Checked = true;
                        txtDealTitles.Attributes.Remove("disabled");
                        try
                        {
                            obj = (BVHouseidData)(from BVHouseidData obj1 in arrBVHouseIDDataMain where Convert.ToInt32(obj1.IntCode) == Convert.ToInt32(code) select obj1).Single();
                            //ddlDealTitle.SelectedValue = Convert.ToString(obj.MappedDealTitleCode);
                            string[] arrTitleEpisode = obj.EpisodeNo.Split('~');
                            if (arrTitleEpisode.Length <= 2)
                            {
                                txtDealTitles.Text = arrTitleEpisode[1];
                            }
                            else
                            {
                                txtDealTitles.Text = "";
                            }
                            txtTitleCode.Text = Convert.ToString(obj.MappedDealTitleCode);
                            chkIgnore.Checked = (obj.IsIgnore == "Y" ? true : false);
                        }
                        catch { }
                    }
                }
            }
        }

        #endregion

        #region---------------Button_Events----------------------

        protected void btnMap_Click(object sender, EventArgs e)
        {
            MapAllCheckedData();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("HouseID_Upload.aspx?moduleCode=" + GlobalParams.HouseIDUpload);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            int[] selected_Titles = lbBVTitleSearch.GetSelectedIndices();
            hdnSearch.Value = string.Empty;
            hdnSearch.Value = " and (";     //+ lbBVTitleSearch.Text.Trim() + "%'";

            foreach (ListItem item in lbBVTitleSearch.Items)
            {
                if (item.Selected)
                    hdnSearch.Value += "BV_Title like '%" + item.Text.ToString().Replace("'","''") + "%' or ";
            }

            hdnSearch.Value = hdnSearch.Value.TrimEnd().TrimEnd('r').TrimEnd('o') + ")";

            Get_Srch_Criteria();
            BindGrid();
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            //txtBVTitleSearch.Text = string.Empty;
            foreach (ListItem item in lbBVTitleSearch.Items)
            {
                item.Selected = false;
            }

            hdnSearch.Value = string.Empty;
            Reset_Srch_Criteria();
            BindGrid();
        }

        #endregion

        #region------------------DTLIST EVENT----------------

        protected void dtLst_ItemCommand(object source, DataListCommandEventArgs e)
        {
            gvTitleMapping.EditIndex = -1;
            PageNo = Convert.ToInt32(e.CommandArgument);
            SaveStatusToSession();
            BindGrid();
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

        #endregion

    }
