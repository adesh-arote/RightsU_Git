using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;
using RightsU_Entities;


public partial class Master_AddEditChannelV1 : ParentPage
{

    string mode;
    Channel objChannel;

    #region---------------Properties------------------
    public int pageNo
    {
        get
        {
            if (ViewState["pageNo"] == null)
                return 1;
            else
                return (int)ViewState["pageNo"];
        }
        set { ViewState["pageNo"] = value; }
    }
    #endregion

    public User objLoginedUser { get; set; }

    protected void Page_Load(object sender, EventArgs e) 
    {
        objLoginedUser = ((User)((Home)this.Page.Master).objLoginUser);
        if (Request.QueryString["mode"] != null)
        {
            mode = Convert.ToString(Request.QueryString["mode"]);
        }
        if (Request.QueryString["ChCode"] != null)
        {
            hdnIntCode.Value = Convert.ToString(Request.QueryString["ChCode"]);
        }
        if (Request.QueryString["pageNo"] != null)
        {
            pageNo = Convert.ToInt32(Request.QueryString["pageNo"]);
        }
        if (!IsPostBack)
        {
            Page.Header.DataBind();
            BindChannelBeam();
            FillForm();
            RegisterJS();
        }
    }

    private void BindChannelBeam()
    {
        if (Convert.ToString(ConfigurationManager.AppSettings["VersionFor"]) == "MSM")
        {
            ddlChannelId.Items.Clear();
            ddlChannelId.Items.Add(new ListItem("--Please Select--", "0"));
            ddlChannelId.Items.Add(new ListItem("India", "1"));
            ddlChannelId.Items.Add(new ListItem("UK", "2"));
            ddlChannelId.Items.Add(new ListItem("US", "3"));
            ddlChannelId.Items.Add(new ListItem("International", "4"));
            ddlChannelId.Items.Add(new ListItem("Africa", "5"));
            ddlChannelId.Items.Add(new ListItem("Canada", "6"));
            ddlChannelId.Items.Add(new ListItem("MiddleEast", "7"));
        }
        else
        {
            ddlChannelId.Items.Clear();
            ddlChannelId.Items.Add(new ListItem("--Please Select--", "0"));
            ddlChannelId.Items.Add(new ListItem("Colors India", "1"));
            ddlChannelId.Items.Add(new ListItem("Colors UK", "2"));
            ddlChannelId.Items.Add(new ListItem("Colors US", "3"));
            ddlChannelId.Items.Add(new ListItem("Colors MENA", "4"));
            ddlChannelId.Items.Add(new ListItem("Colors HD", "5"));
        }
    }

    #region --------------Methods------------
    private void RegisterJS()
    {
        //txtFChannelId.Attributes.Add("onKeypress", "doNotAllowTag();return fnEnterKey('" + btnSave.ClientID + "')");
        //txtFChannelId.Attributes.Add("onKeydown", "return EscHandler(event);");
        txtHidRangeFromprefix.Attributes.Add("readonly", "true");
        txtHidRangeToPrefix.Attributes.Add("readonly", "true");
        txtFChannelName.Attributes.Add("onKeypress", "doNotAllowTag();return fnEnterKey('" + btnSave.ClientID + "')");
        txtFChannelName.Attributes.Add("onKeydown", "return EscHandler(event);");
        ddlFGenresCode.Attributes.Add("onKeypress", "doNotAllowTag();return fnEnterKey('" + btnSave.ClientID + "')");
        ddlFEntityCode.Attributes.Add("onKeypress", "doNotAllowTag();return fnEnterKey('" + btnSave.ClientID + "')");
    }

    private void FillForm()
    {
        if (mode == "edit")
        {
            lblAddEdit.Text = "Edit Channel Details";
            Session["Channel"] = null;
            objChannel = new Channel();
            objChannel.IntCode = Convert.ToInt32(hdnIntCode.Value);
            if (objChannel.IntCode > 0)
                objChannel.FetchDeep();
            Session["Channel"] = objChannel;
            txtFChannelName.Focus();

            btnSave.Text = "Update";

            //Fill form--------------                
            int EntityCode = objChannel.EntityCode;
            rdoFEntityType.SelectedValue = objChannel.EntityType;
            lblChannelReferenceForOwn.Text = Convert.ToString(objChannel.channelReferenceOfOwn);
            lblChannelReferenceForOthers.Text = Convert.ToString(objChannel.channelReferenceOfOthers);
            txtFChannelName.Text = objChannel.ChannelName;
            if (Convert.ToString(ConfigurationManager.AppSettings["VersionFor"]) == "MSM")
            {
                if (objChannel.ChannelId.ToUpper() == "INDIA")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForChannelBeam_India);
                else if (objChannel.ChannelId.ToUpper() == "UK")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForChannelBeam_UK);
                else if (objChannel.ChannelId.ToUpper() == "US")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForChannelBeam_US);
                else if (objChannel.ChannelId.ToUpper() == "INTERNATIONAL")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForChannelBeam_International);
                else if (objChannel.ChannelId.ToUpper() == "AFRICA")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForChannelBeam_Africa);
                else if (objChannel.ChannelId.ToUpper() == "CANADA")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForChannelBeam_Canada);
                else if (objChannel.ChannelId.ToUpper() == "MIDDLEEAST")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForChannelBeam_MiddleEast);
            }
            else
            {
                if (objChannel.ChannelId.ToUpper() == "COLORS INDIA")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForColorsIndia);
                else if (objChannel.ChannelId.ToUpper() == "COLORS UK")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForColorsUK);
                else if (objChannel.ChannelId.ToUpper() == "COLORS US")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForColorsUS);
                else if (objChannel.ChannelId.ToUpper() == "COLORS MENA")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForColorsMENA);
                else if (objChannel.ChannelId.ToUpper() == "COLORS HD")
                    ddlChannelId.SelectedValue = Convert.ToString(GlobalParams.CodeForColorsHD);
            }

        

            if (objChannel.EntityType == "O")
            {
              
                DBUtil.BindDropDownList(ref ddlFEntityCode, new Entity(), " AND is_Active='Y' OR Entity_Code in (" + EntityCode + ") ", "EntityName", "IntCode", true, "");

            }
            else
            {
                DBUtil.BindDropDownList(ref ddlFEntityCode, new Vendor(), " AND vendor_code in (select vendor_code from vendor_role where role_code in (12)) AND is_Active='Y'  OR vendor_code in (" + EntityCode + ") ", "VendorName", "IntCode", true, "");
            }

            /*****   Code End *********/

            ddlFEntityCode.SelectedValue = EntityCode.ToString();

            DBUtil.BindDropDownList(ref ddlFGenresCode, new Genres(), " and (is_active='Y' or genres_code=" + objChannel.GenresCode + " )", "GenresName", "IntCode", true, "");
            ddlFGenresCode.SelectedValue = objChannel.GenresCode.ToString();


            string strMsg = "refreshLock('" + objChannel.IntCode + "', 'Channel');";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertKey", strMsg, true);



            rdoFEntityType.Attributes.Add("onclick", "checkChannelReferenceForOwnandOthers(" + rdoFEntityType.ClientID + ",'" + lblChannelReferenceForOwn.Text + "','" + lblChannelReferenceForOthers.Text + "')");
            //hdnEntityType.Value = null;

            if (rdoFEntityType.SelectedValue == "O")
            {
                hdnEntityType.Value = "O";
            }
            else
            {
                hdnEntityType.Value = "C";
            }


            Int32 strcountReferOwn = Convert.ToInt32(lblChannelReferenceForOwn.Text);
            Int32 strcountReferOthers = Convert.ToInt32(lblChannelReferenceForOthers.Text);

            if (strcountReferOwn > 0 || strcountReferOthers > 0)
            {
                ddlFEntityCode.Enabled = false;
            }
            else
                ddlFEntityCode.Enabled = true;

            if (string.IsNullOrEmpty(objChannel.HIDRangeFrom))
                objChannel.HIDRangeFrom = "";
            if (string.IsNullOrEmpty(objChannel.HIDRangeTo))
                objChannel.HIDRangeTo = "";

            txtschfpath.Text = objChannel.ScheduleScFilePath;
            txtschfpathpkg.Text = objChannel.ScheduleScFilePath_Pkg;
            txtBvchcode.Text = Convert.ToString(objChannel.BVChannelCode);
            txthidPrefix.Text = objChannel.HIDPrefix;
            txthiddigit.Text = Convert.ToString(objChannel.HIDDigitsPrefix);
            txthidrangefrom.Text = objChannel.HIDRangeFrom.TrimStart(objChannel.HIDPrefix.ToCharArray());
            txthidrangeto.Text = objChannel.HIDRangeTo.TrimStart(objChannel.HIDPrefix.ToCharArray());
            txtHidRangeFromprefix.Text = objChannel.HIDPrefix;
            txtHidRangeToPrefix.Text = objChannel.HIDPrefix;


            txthiddigit.Text = "1";
            txthidrangefrom.Text = "0";
            txthidrangeto.Text = "0";
            txtHidRangeFromprefix.Text = "";
            txtHidRangeToPrefix.Text = "";

            if (!string.IsNullOrEmpty(objChannel.OffsetTimeSchedule))
            {
                string[] offsetsc = objChannel.OffsetTimeSchedule.Split(":".ToCharArray());
                txtofstimeschr.Text = offsetsc[0];
                txtofstimescmin.Text = offsetsc[1];
            }
            else
            {
                txtofstimeschr.Text = "00";
                txtofstimescmin.Text = "00";
            }
            if (!string.IsNullOrEmpty(objChannel.OffsetTimeSchedule))
            {
                string[] offsetrun = objChannel.OffsetTimeAsRun.Split(":".ToCharArray());
                txtofstimerunhr.Text = offsetrun[0];
                txtofstimerunmin.Text = offsetrun[1];
            }
            else
            {
                txtofstimerunhr.Text = "00";
                txtofstimerunmin.Text = "00";
            }



            //testing---------------------



        }
        else if (mode == "add")
        {
            Bindddl();
            txtFChannelName.Focus();
            Session["Channel"] = null;
            objChannel = new Channel();
            Session["Channel"] = objChannel;
            lblAddEdit.Text = "Add Channel Details";
        }
    }
    private void Bindddl()
    {
        DBUtil.BindDropDownList(ref ddlFGenresCode, new Genres(), " and is_active='Y'", "GenresName", "IntCode", true, "");
        DBUtil.BindDropDownList(ref ddlFEntityCode, new Vendor(), " AND vendor_code in (select vendor_code from vendor_role where role_code in (12)) AND is_Active='Y'  ", "VendorName", "IntCode", true, "");
    }

    private string SaveRec()
    {
        string msg = "";
        try
        {
            objChannel = (Channel)Session["Channel"];
            objChannel.EntityCode = Convert.ToInt32(ddlFEntityCode.SelectedValue);

            objChannel.GenresCode = Convert.ToInt32(ddlFGenresCode.SelectedValue);
            objChannel.objGenres.IntCode = objChannel.GenresCode;
            objChannel.objGenres.Fetch();
            objChannel.ChannelId = ddlChannelId.SelectedItem.Text;
            objChannel.ChannelName = txtFChannelName.Text;
            objChannel.EntityType = rdoFEntityType.SelectedValue;
            if (objChannel.EntityType == "O")
            {
                objChannel.objEntity.IntCode = objChannel.EntityCode;
                objChannel.objEntity.Fetch();
            }
            else
            {
                objChannel.objVendor.IntCode = objChannel.EntityCode;
                objChannel.objVendor.Fetch();
            }

            objChannel.ScheduleScFilePath = txtschfpath.Text;
            objChannel.ScheduleScFilePath_Pkg = txtschfpathpkg.Text;

            objChannel.HIDPrefix = "";              
            objChannel.HIDRangeFrom = "";           
            objChannel.HIDRangeTo = "";             
            objChannel.HIDDigitsPrefix = 0;         


            objChannel.BVChannelCode = Convert.ToInt32(txtBvchcode.Text);
            objChannel.OffsetTimeSchedule = txtofstimeschr.Text + ":" + txtofstimescmin.Text;
            objChannel.OffsetTimeAsRun = txtofstimerunhr.Text + ":" + txtofstimerunmin.Text;
            objChannel.Is_Active = "Y";

            if (objChannel.IntCode > 0)
            {
                string strLastUpdatedTime = "";
                if (Request.QueryString["strLastUpdatedTime"] != null)
                {
                    strLastUpdatedTime = Convert.ToString(Request.QueryString["strLastUpdatedTime"]);
                }

                objChannel.LastActionBy = objLoginedUser.Users_Code;
                objChannel.IsDirty = true;
                objChannel.LastUpdatedTime = strLastUpdatedTime;
                objChannel.LastUpdatedBy = objLoginedUser.Users_Code;
            }
            else
            {
                objChannel.IsDirty = false;
                objChannel.InsertedBy = objLoginedUser.Users_Code;
            }
            msg = objChannel.Save();
            

        }
        catch (DuplicateRecordException ex)
        {
            CreateMessageAlert(txtFChannelName.Text + "Channel Record " + ex.Message);
        }
        return msg;

    }

    private string ValidateRecord()
    {
        string msg = "";

        if (CheckForhr(Convert.ToInt32(txtofstimeschr.Text)))
        {
            if (CheckForMin(Convert.ToInt32(txtofstimescmin.Text)))
            {
                if (CheckForhr(Convert.ToInt32(txtofstimerunhr.Text)))
                {

                    if (CheckForMin(Convert.ToInt32(txtofstimerunmin.Text)))
                        msg = "";
                    else msg = "Invalid entry for Offset Time AsRun Min.";
                }
                else msg = "Invalid entry for Offset Time AsRun Hrs.";
            }
            else msg = "Invalid entry for Offset Time Schedule Min.";

        }
        else
            msg = "Invalid entry for Offset Time Schedule Hrs.";

        int HidRange = Convert.ToInt32(txthiddigit.Text);
        if (HidRange != txthidrangefrom.Text.Length)
        {
            msg = "HouseId digit and no of digits in HouseId Range From should be same";
        }
        if (HidRange != txthidrangeto.Text.Length)
        {
            msg = "HouseId digit and no of digits in HouseId Range To should be same";
        }
        if (Convert.ToInt32(txthidrangefrom.Text) > Convert.ToInt32(txthidrangeto.Text))
        {
            msg = "HouseId From Range should be less than HouseId To Range";
        }

        return msg;
    }

    private bool CheckForhr(int val)
    {

        if (val <= 23)
            return true;
        else

            return false;

    }

    private bool CheckForMin(int val)
    {
        if (val <= 59)
            return true;
        else

            return false;


    }

    #endregion

    #region ----------radioButton Event-----------------

    protected void rdoEEntityType_SelectedIndexChanged(object sender, EventArgs e)
    {
        RadioButtonList rdoEEntityType = (RadioButtonList)sender;
        DropDownList ddlEEntityCode = (DropDownList)rdoEEntityType.NamingContainer.FindControl("ddlEEntityCode");
        string StrIsValidEntity = "";
        //if (objLoginUser != null)
        //    if (objLoginUser.objEntity != null)
        //        if (objLoginUser.objEntity.IntCode > 0)
        //        {
        //            //IsValidEntity = true;
        //            StrIsValidEntity = " and entity_code='" + objLoginUser.objEntity.IntCode + "'";
        //        }

        if (rdoEEntityType.SelectedValue == "O")
        {
            DBUtil.BindDropDownList(ref ddlEEntityCode, new Entity(), " AND is_Active='Y'", "EntityName", "IntCode", true, "");
            //DBUtil.BindDropDownList(ref ddlEEntityCode, new Entity(), "AND entity_code in(select ue.Entity_Code from Users_Entity ue where ue.users_code= '" + objLoginUser.IntCode + "') and is_Active='Y'", "EntityName", "IntCode", true, "");
        }
        else
        {
            DBUtil.BindDropDownList(ref ddlEEntityCode, new Vendor(), " AND vendor_code in (select vendor_code from vendor_role where role_code in (12)) AND is_Active='Y' ", "VendorName", "IntCode", true, "");
        }
    }
    protected void rdoFEntityType_SelectedIndexChanged(object sender, EventArgs e)
    {
        string StrIsValidEntity = "";
        //if (objLoginUser != null)
        //    if (objLoginUser.objEntity != null)
        //        if (objLoginUser.objEntity.IntCode > 0)
        //        {
        //            //IsValidEntity = true;
        //            StrIsValidEntity = " and entity_code='" + objLoginUser.objEntity.IntCode + "'";
        //        }
        //DBUtil.BindDropDownList(ref ddlFEntityCode, new Entity(), " AND is_Active='Y' " + StrIsValidEntity, "EntityName", "IntCode", true, "");
        RadioButtonList rdoFEntityType = (RadioButtonList)sender;
        DropDownList ddlFEntityCode = (DropDownList)rdoFEntityType.NamingContainer.FindControl("ddlFEntityCode");

        if (rdoFEntityType.SelectedValue == "O")
        {
            DBUtil.BindDropDownList(ref ddlFEntityCode, new Entity(), " AND is_Active='Y'", "EntityName", "IntCode", true, "");
            //DBUtil.BindDropDownList(ref ddlFEntityCode, new Entity(), "AND entity_code in(select Entity_Code from Users_Entity where Users_Code= '" + objLoginUser.IntCode + "') and is_Active='Y'", "EntityName", "IntCode", true, "");
        }
        else
        {
            ddlFEntityCode.Items.Clear();
            DBUtil.BindDropDownList(ref ddlFEntityCode, new Vendor(), " AND vendor_code in (select vendor_code from vendor_role where role_code in (12)) AND is_Active='Y'  ", "VendorName", "IntCode", true, "");
        }
    }

    #endregion

    #region ------------Button Events -------------------------

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string message = ValidateRecord();
        if (message == "")
        {
            string msg = SaveRec();
            if (msg == "A" || msg == "U")
                TransferAlertMessage("Record " + btnSave.Text + "d successfuly ", "ChannelV1.aspx?pageNo=" + pageNo);
            else
                CreateMessageAlert(txtFChannelName, "Channel Record " + msg);
        }
        else
            CreateMessageAlert(message);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {

        Response.Redirect("ChannelV1.aspx?pageNo=" + pageNo);
    }


    #endregion
}
