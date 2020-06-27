using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using System.Data.SqlTypes;
using System.Web.SessionState;
using AjaxControlToolkit;
using UTOFrameWork.FrameworkClasses;
using System.IO;


namespace UTOFrameWork.FrameworkClasses
{
    public class ParentPage : Page
    {
        protected UtoSession objSession;

        Criteria objCrt;
        public int recordPerPage;
        private string url;
        public HiddenField hdnRights = new HiddenField();
        public ParentPage()
        {
            objCrt = new Criteria();
            recordPerPage = objCrt.RecordPerPage;
        }
        private Users _objLoginUser;
        public Users objLoginUser
        {
            get { return _objLoginUser; }
            set { _objLoginUser = value; }
        }

        public string _IsReqLoadingPanel = "Y";
        public string IsReqLoadingPanel
        {
            get { return _IsReqLoadingPanel; }
            set { _IsReqLoadingPanel = value; }
        }

        private int _moduleCode;
        public int ModuleCode
        {
            get { return _moduleCode; }
            set { _moduleCode = value; }
        }
        public LoginEntity ObjLoginEntity
        {
            get
            {
                if (Session["objLoginEntity"] == null)
                    Session["objLoginEntity"] = new LoginEntity();
                return (LoginEntity)Session["objLoginEntity"];
            }
            set { Session["objLoginEntity"] = value; }
        }
        protected virtual int GetSecurityKey()
        {
            //override this method and return the Module Code for your page.
            return -1;
        }

        protected override void OnLoad(EventArgs e)
        {
            //ModuleCode = Convert.ToInt32(Request.QueryString["modulecode"]);
            //objSession = (UtoSession)Session[UtoSession.SESS_KEY];
            //objLoginUser = (Users)objSession.Objuser;
            //url = ConfigurationManager.AppSettings["DefaultSiteUrl"].ToString().Trim();
            //url = HttpRuntime.AppDomainAppVirtualPath + url.Replace("~", "");

            //if (Session[RightsU_Session.SESS_KEY] == null)
            //{
            //    //Response.Redirect(url); //need to be uncomment 
            //    //string JS = "parent.left_frame.location='" + url + "'";
            //    string JS = "window.open('" + url + "','_top')";
            //    ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);

            //    // base.OnLoad(e);
            //    return;
            //}
            //else
            //{
            //objSession = (RightsU_Session)Session[RightsU_Session.SESS_KEY];
            //objLoginUser = (Users)objSession.Objuser;
            //    SessAppTimeOut();
            //}

            SetDefaultProperty(Response, Request);
            AddAlertControlOnPage();
            LoadNewAlertMessageBoxes();
            if (IsReqLoadingPanel == "Y")
                AddLoddingPanelAndModelPopoupExtender();

            base.OnLoad(e);

            //if (!IsPostBack)
            //    createHiddenForRights();
        }

        //private void LogoutDeletedUsers(string resetLogin, string url)
        //{
        //    Hashtable htLoggedUser = new Hashtable();
        //    htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];
        //    string entityKey = Convert.ToString(HttpContext.Current.Session["Entity_Type"]);

        //    if (!htLoggedUser.ContainsKey(resetLogin + "#" + entityKey))
        //        Response.Redirect(url);
        //}
        //private void createHiddenForRights()
        //{
        //    this.Form.Controls.Add(hdnRights);

        //    if (objLoginUser.objSecurityGroup.IntCode > 0)
        //    {
        //        hdnRights.ID = "hdnRights";
        //        SecurityGroup ObjSecGr = new SecurityGroup();
        //        ObjSecGr.IntCode = objLoginUser.objSecurityGroup.IntCode;

        //        int ModuleCode = (Request.QueryString["moduleCode"] != null ? Convert.ToInt32(Request.QueryString["moduleCode"]) : objLoginUser.moduleCode);
        //        objLoginUser.moduleCode = ModuleCode;
        //        string strUserRights = "";

        //        if (ModuleCode > 0)
        //            strUserRights = ObjSecGr.getArrUserRightCodesString(ObjSecGr.IntCode, ModuleCode, "");

        //        hdnRights.Value = strUserRights.Trim();
        //    }
        //}

        //private void SessAppTimeOut()
        //{
        //    HttpSessionState ss = HttpContext.Current.Session;
        //    string sessionId = ss.SessionID;
        //    string entityKey = Convert.ToString(HttpContext.Current.Session["Entity_Type"]);
        //    Hashtable htLoggedUser = new Hashtable();

        //    if (Application["LOGGEDUSERS"] != null)
        //    {
        //        htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];

        //        if (htLoggedUser.ContainsKey(objLoginUser.loginName + "#" + entityKey))
        //        {
        //            string[] timeSessionId = new string[2];
        //            timeSessionId = GetTimeAndSessionId(Convert.ToString(htLoggedUser[objLoginUser.loginName + "#" + entityKey]));
        //            string storedSessionId = timeSessionId[1];

        //            if (storedSessionId != sessionId)
        //            {
        //                // htLoggedUser.Remove(objLoginUser.loginName);
        //                Response.Redirect(url);
        //            }
        //            else
        //            {
        //                int maxTime = Session.Timeout;
        //                long maxTimeInSec = maxTime * 60;
        //                long loggedTime = Convert.ToInt64(timeSessionId[0]);
        //                long currentTime = Convert.ToInt64(GetDateComparisionNumber(DateTime.Now.ToString("s")));
        //                long totalTimeDiffInSec = currentTime - loggedTime;

        //                if (totalTimeDiffInSec > maxTimeInSec)
        //                {
        //                    htLoggedUser.Remove(objLoginUser.loginName + "#" + entityKey);
        //                    Response.Redirect(url);
        //                }
        //                else
        //                {
        //                    htLoggedUser.Remove(objLoginUser.loginName + "#" + entityKey);
        //                    htLoggedUser.Add(objLoginUser.loginName + "#" + entityKey, GetDateComparisionNumber(DateTime.Now.ToString("s")) + "#" + sessionId);
        //                    Application.Lock();
        //                    Application["LOGGEDUSERS"] = htLoggedUser;
        //                    Application.UnLock();
        //                    //break;
        //                }
        //            }
        //        }
        //        else
        //        {
        //            Response.Redirect(url);
        //        }
        //    }
        //}
        public string[] GetTimeAndSessionId(string timeSessionId)
        {
            string[] timeSession = new string[2];
            timeSession = timeSessionId.Split('#');
            return timeSession;
        }
        public static string GetDateComparisionNumber(string strDate)
        {
            string actualStr = strDate.Trim().Replace("T", "~").Replace(":", "~").Replace("-", "~");
            string[] arrDt = actualStr.Split('~');
            string tmpTimeInSec = arrDt[0].Trim() + arrDt[1].Trim() + arrDt[2].Trim() + Convert.ToString(Convert.ToInt64(Convert.ToInt64(arrDt[3].Trim()) * 60 * 60) + Convert.ToInt64(Convert.ToInt64(arrDt[4].Trim()) * 60) + Convert.ToInt64(arrDt[5].Trim()));
            //return Convert.ToInt64(tmpTimeInSec);
            return tmpTimeInSec;
        }
        public static DateTime GetFormatedDateTime(string strDateTime)
        {
            if (strDateTime.Length >= 8)
            {
                string[] strArr = strDateTime.Split('/');
                strDateTime = strArr[1] + "/" + strArr[0] + "/" + strArr[2];
                return Convert.ToDateTime(strDateTime);
            }
            else
            {
                //return Convert.ToDateTime(strDateTime);
                return Convert.ToDateTime("1/1/0001");
            }
        }
        public static DateTime GetFormatedDateTimeNew(string strDateTime)
        {
            if (strDateTime.Length >= 8)
            {
                string[] strArr = strDateTime.Split('/');
                strDateTime = strArr[0] + "/" + strArr[1] + "/" + strArr[2];
                return Convert.ToDateTime(strDateTime);
            }
            else
            {
                //return Convert.ToDateTime(strDateTime);
                return Convert.ToDateTime("1/1/0001");
            }
        }

        public void SetDefaultProperty(System.Web.HttpResponse resp, System.Web.HttpRequest req)
        {
            //resp.Expires = 0;
            //resp.ExpiresAbsolute = DateTime.Now.AddDays(-1);
            //resp.AddHeader("pragma", "no-cache");
            //resp.CacheControl = "no-cache";
            //CheckHTTPS(resp, req);
            resp.Cache.SetExpires(System.DateTime.Now);
            resp.Cache.SetCacheability(HttpCacheability.NoCache);
            resp.Cache.SetMaxAge(new TimeSpan(0, 0, 0));
        }

        public void CheckHTTPS(System.Web.HttpResponse resp, System.Web.HttpRequest req)
        {
            string tempUrl = "";
            if (!Convert.ToBoolean(ConfigurationManager.AppSettings["nonSecureTest"]))
            {
                if (Convert.ToInt32(req.ServerVariables["SERVER_PORT"]) == 80)
                {
                    tempUrl += "https://";
                    tempUrl += req.ServerVariables["SERVER_NAME"];
                    tempUrl += req.ServerVariables["URL"];
                    resp.Redirect(tempUrl);
                }
            }
        }

        //public static Hashtable SessAppTimeOut(Hashtable appVar, ref  Users userObj)
        //{
        //    Hashtable loggedHash = appVar;
        //    loggedHash.Remove(userObj.loginName);
        //    loggedHash.Add(userObj.loginName, GetDateComparisionNumber(DateTime.Now.ToString("s")));
        //    return loggedHash;
        //}    

        private void AddLoddingPanelAndModelPopoupExtender()
        {
            Panel loadingPanel = new Panel();
            loadingPanel.ID = "loadingPanel";
            loadingPanel.Style.Add("display", "none");
            loadingPanel.Attributes.Add("runat", "server");
            #region Panel Content

            HtmlTable tab = new HtmlTable();
            tab.Width = "100%";
            tab.CellPadding = 3;
            tab.CellSpacing = 0;
            tab.Align = "center";

            HtmlTableCell cell1 = new HtmlTableCell();
            cell1.Attributes.Add("class", "normalAjax");
            cell1.Align = "center";
            HtmlTable tabInner = new HtmlTable();
            tabInner.Width = "220px";
            tabInner.Attributes.Add("class", "mainAjax");
            tabInner.CellPadding = 3;
            tabInner.CellSpacing = 0;
            tabInner.Align = "center";
            HtmlTableRow innerrow1 = new HtmlTableRow();
            HtmlTableCell innercell1 = new HtmlTableCell();
            innercell1.Align = "center";
            innercell1.BgColor = "#5DACEF";
            //Image imgbk = new Image();
            //imgbk.ImageUrl = "~/Images/textarea.jpg";
            //innercell1.Style.Add("background-image", "~/Images/textarea.jpg");
            innercell1.InnerHtml = "Loading, Please wait .....";
            //innercell1.Controls.Add(imgbk);
            innerrow1.Cells.Add(innercell1);//add innercell to innerrow
            HtmlTableRow innerrow2 = new HtmlTableRow();
            HtmlTableCell innercell2 = new HtmlTableCell();
            innercell2.Attributes.Add("class", "borderAjax");
            innercell2.Align = "center";
            HtmlImage img = new HtmlImage();
            img.Src = "~/Images/activity.gif";
            img.Align = "left";
            img.Border = 0;
            img.Height = 19;
            img.Width = 220;
            innercell2.Controls.Add(img);
            innerrow2.Cells.Add(innercell2);
            tabInner.Rows.Add(innerrow1); //add innerrow1 to inner table
            tabInner.Rows.Add(innerrow2);//add innerrow2 to inner table
            cell1.Controls.Add(tabInner);
            HtmlTableRow row1 = new HtmlTableRow();
            row1.Cells.Add(cell1);
            tab.Rows.Add(row1);
            loadingPanel.Controls.Add(tab);
            #endregion
            this.Form.Controls.Add(loadingPanel);
            ModalPopupExtender mpeLoading = new ModalPopupExtender();
            mpeLoading.ID = "mpeLoading";
            mpeLoading.TargetControlID = "btnJunk";
            mpeLoading.PopupControlID = "loadingPanel";
            mpeLoading.BackgroundCssClass = "modalBackground1";
            this.Form.Controls.Add(mpeLoading);
            //Modified by Anita on 16-feb-2010 to add script on page for loading panel
            //string strscript = @"<script type='text/javascript'> Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);" +
            //" Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(initRequest);function initRequest(sender, args) {" +
            //" $find('mpeLoading').show(); $get('loadingPanel').focus();}" +
            //" function endRequest(sender, args) { $find('mpeLoading').hide();}  </script>";

            string strscript = @"<script type='text/javascript'> Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);" +
            " Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(initRequest);function initRequest(sender, args) {" +
            " showLoading(); }" +
            " function endRequest(sender, args) { hideLoading();}  </script>";

            //this.Page.RegisterStartupScript("showhidemodal", strscript);
            this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "showhidemodal", strscript);
        }

        //protected virtual bool BindGridViewUsingRecordStatus(Control ctl, string strStaus, Users objUser)
        //{
        //    bool retVal = false;
        //    if (strStaus == DBUtil.RECORD_STATUS_CHANGED)
        //    {
        //        CreateMessageAlert(ctl, msgRecChanged + " by " + objUser.firstName);
        //        BindGrid();
        //        retVal = true;
        //    }
        //    else if (strStaus == DBUtil.RECORD_STATUS_DELETED)
        //    {
        //        CreateMessageAlert(ctl, msgRecDeleted);
        //        BindGrid();
        //        retVal = true;
        //    }
        //    else if (strStaus == DBUtil.RECORD_STATUS_LOCKED)
        //    {
        //        CreateMessageAlert(ctl, msgRecInUse + " by " + objUser.firstName);
        //        BindGrid();
        //        retVal = true;
        //    }

        //    return retVal;
        //}

        public void ClearAlertFromPage(Page objPage)
        {
            ModalPopupExtender MPExtAlert = (ModalPopupExtender)objPage.FindControl("MPExtAlert");
            MPExtAlert.OnOkScript = "";
        }
        public string getHTMLSpaceDecodedString(object str)
        {
            if (str != null)
            {
                string strNew = System.Text.RegularExpressions.Regex.Replace(str.ToString(), " ", Server.HtmlDecode(" "));
                System.IO.StringWriter writer = new System.IO.StringWriter();
                Server.HtmlDecode(strNew, writer);
                return writer.ToString();
            }
            return null;
        }
        protected virtual bool BindRecordStatus(Control ctl, string strStaus, string userName)
        {
            bool retVal = false;

            if (strStaus == GlobalParams.RECORD_STATUS_CHANGED)
            {
                CreateMessageAlert(ctl, getGlobalRes("msgRecChanged") + userName);
                //BindGrid();
                retVal = true;
            }
            else if (strStaus == GlobalParams.RECORD_STATUS_DELETED)
            {
                CreateMessageAlert(ctl, getGlobalRes("msgRecDeleted"));
                //BindGrid();
                retVal = true;
            }
            else if (strStaus == GlobalParams.RECORD_STATUS_LOCKED)
            {
                CreateMessageAlert(ctl, getGlobalRes("msgRecInUse") + userName);
                //BindGrid();
                retVal = true;
            }

            return retVal;
        }
        protected virtual bool BindRecordStatus(Page objPage, Control ctl, string strStaus, string userName)
        {
            bool retVal = false;

            if (strStaus == GlobalParams.RECORD_STATUS_CHANGED)
            {
                CreateMessageAlert(objPage, ctl, getGlobalRes("msgRecChanged") + userName);
                //BindGrid();
                retVal = true;
            }
            else if (strStaus == GlobalParams.RECORD_STATUS_DELETED)
            {
                CreateMessageAlert(objPage, ctl, getGlobalRes("msgRecDeleted"));
                //BindGrid();
                retVal = true;
            }
            else if (strStaus == GlobalParams.RECORD_STATUS_LOCKED)
            {
                CreateMessageAlert(objPage, ctl, getGlobalRes("msgRecInUse") + userName);
                //BindGrid();
                retVal = true;
            }

            return retVal;
        }
        protected virtual bool BindRecordStatusLocking(Control ctl, string strStaus, string userName)
        {
            bool retVal = false;

            if (strStaus == GlobalParams.RECORD_STATUS_CHANGED)
            {
                CreateMessageAlert(this, ctl, getGlobalRes("msgRecChanged") + userName);
                retVal = true;
            }
            else if (strStaus == GlobalParams.RECORD_STATUS_DELETED)
            {
                CreateMessageAlert(this, ctl, getGlobalRes("msgRecDeleted"));
                retVal = true;
            }
            else if (strStaus == GlobalParams.RECORD_STATUS_LOCKED)
            {
                CreateMessageAlert(this, ctl, getGlobalRes("msgRecInUse") + userName);
                retVal = true;
            }

            return retVal;
        }
        public string getGlobalRes(string msgType)
        {
            return (string)GetGlobalResourceObject("STAR_RIGHTS", msgType);
        }

        public string getGlobalRes(string msgType, string resName)
        {
            return (string)GetGlobalResourceObject(resName, msgType);
        }
        public void DownloadFile(string fname, bool forceDownload, Control controlId)
        {
            //string errorMsg = "";
            string path = fname;
            FileInfo file = new FileInfo(path);

            if (file.Exists)
            {
                string name = Path.GetFileName(fname);
                string ext = Path.GetExtension(path);
                string type = "";

                if (ext != null)
                {
                    switch (ext.ToLower())
                    {
                        case ".htm":

                        case ".html":
                            type = "text/HTML";
                            break;

                        case ".txt":
                            type = "text/plain";
                            break;

                        case ".doc":

                        case ".rtf":
                            type = "Application/msword";
                            break;
                    }
                }

                if (forceDownload)
                    Response.AppendHeader("content-disposition", "attachment; filename=" + name.Split(Convert.ToChar("~")).GetValue(1));

                if (type != "")
                    Response.ContentType = type;

                Response.WriteFile(path);
                Response.End();
            }
            else
            {
                if (controlId != null)
                    CreateMessageAlert(controlId, "File does not exist");
                else
                    CreateMessageAlert("File does not exists");
            }
        }

        #region --------------- Old Alert Message Box ---------------

        public void TransferAlertMessage(string alertMSG, string toUrl)
        {
            string JS = "TransferMessage('" + alertMSG + "','" + toUrl + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void TransferAlertMessage(Page objPage, string alertMSG, string toUrl)
        {
            Label lblMessage = (Label)objPage.FindControl("lblMessage");
            lblMessage.Text = alertMSG;
            ModalPopupExtender MPExtAlert = (ModalPopupExtender)objPage.FindControl("MPExtAlert");
            MPExtAlert.Show();
            MPExtAlert.OnOkScript = "TransferUrl('" + toUrl + "');";
        }

        private void AddAlertControlOnPage()
        {
            Panel pnlAlert = new Panel();
            Button btnJunk = new Button();
            ModalPopupExtender MPExtAlert = new ModalPopupExtender();

            pnlAlert.ID = "pnlAlert";
            pnlAlert.GroupingText = "Information";
            pnlAlert.Style.Add("display", "none");
            pnlAlert.CssClass = "modalPopup";
            pnlAlert.Attributes.Add("runat", "server");
            #region Panel Content

            HtmlTable tab = new HtmlTable();
            HtmlTableRow row1 = new HtmlTableRow();
            HtmlTableRow row2 = new HtmlTableRow();
            HtmlTableCell cell1 = new HtmlTableCell();
            HtmlTableCell cell2 = new HtmlTableCell();
            HtmlTableCell cell3 = new HtmlTableCell();
            HtmlImage img = new HtmlImage();
            Button btnOK = new Button();
            Label lblMessage = new Label();

            img.Src = "~/Images/Info.gif";
            img.Align = "left";

            cell1.Align = "right";
            cell1.Width = "20%";
            cell1.Controls.Add(img);
            cell2.Align = "center";

            lblMessage.ID = "lblMessage";
            lblMessage.Style.Add("text-align", "center");
            lblMessage.Attributes.Add("runat", "server");
            cell2.Controls.Add(lblMessage);

            row1.Cells.Add(cell1);
            row1.Cells.Add(cell2);
            tab.Rows.Add(row1);

            cell3.Align = "center";
            cell3.ColSpan = 2;

            btnOK.CssClass = "button";
            btnOK.ID = "btnOK";
            btnOK.Text = "  OK  ";
            btnOK.Attributes.Add("runat", "server");
            btnOK.CausesValidation = false;
            btnOK.Attributes.Add("onblur", "if($get('pnlAlert').style.display=='') this.focus();");

            cell3.Controls.Add(btnOK);
            row2.Cells.Add(cell3);
            tab.Rows.Add(row2);
            pnlAlert.Controls.Add(tab);

            #endregion
            pnlAlert.DefaultButton = "btnOK";
            this.Form.Controls.Add(pnlAlert);

            MPExtAlert.ID = "MPExtAlert";
            MPExtAlert.TargetControlID = "btnJunk";
            MPExtAlert.PopupControlID = "pnlAlert";
            MPExtAlert.BackgroundCssClass = "modalBackground";
            MPExtAlert.OkControlID = "btnOK";
            MPExtAlert.OnOkScript = "SetFocus();";
            this.Form.Controls.Add(MPExtAlert);

            btnJunk.ID = "btnJunk";
            btnJunk.Attributes.Add("runat", "server");
            btnJunk.Style.Add("display", "none");
            btnJunk.CausesValidation = false;       //Added by Adesh and Yogesh
            this.Form.Controls.Add(btnJunk);

            AddDeleteAndConfirmationExtender();
        }

        private void AddDeleteAndConfirmationExtender()
        {
            Panel pnlConfirm = new Panel();
            ConfirmButtonExtender CBExtDelete = new ConfirmButtonExtender();
            ModalPopupExtender MPExtConfirm = new ModalPopupExtender();

            pnlConfirm.ID = "pnlConfirm";
            pnlConfirm.GroupingText = "Confirmation";
            pnlConfirm.Style.Add("display", "none");
            pnlConfirm.CssClass = "modalPopup";
            //pnlConfirm.Attributes.Add("runat", "server");
            #region Panel Content

            HtmlTable tab = new HtmlTable();
            HtmlTableRow row1 = new HtmlTableRow();
            HtmlTableRow row2 = new HtmlTableRow();
            HtmlTableCell cell1 = new HtmlTableCell();
            HtmlTableCell cell2 = new HtmlTableCell();
            HtmlTableCell cell3 = new HtmlTableCell();
            HtmlImage img = new HtmlImage();
            Label lblConfirmText = new Label();
            Button btnConfirmOK = new Button();
            Button btnConfirmCancel = new Button();
            Literal ctlLiteral = new Literal();

            tab.Width = "100%";

            img.Src = "~/Images/Confirm.gif";
            img.Align = "left";

            cell1.Align = "right";
            cell1.Width = "20%";
            cell1.Controls.Add(img);
            cell2.Align = "center";

            lblConfirmText.ID = "lblConfirmText";
            lblConfirmText.Style.Add("text-align", "center");
            lblConfirmText.Text = "Are you sure you want to delete this record?";
            cell2.Controls.Add(lblConfirmText);

            row1.Align = "Center";
            row1.Cells.Add(cell1);
            row1.Cells.Add(cell2);
            tab.Rows.Add(row1);

            row2.Align = "Center";

            cell3.Align = "center";
            cell3.ColSpan = 2;

            btnConfirmOK.CssClass = "button";
            btnConfirmOK.ID = "btnConfirmOK";
            btnConfirmOK.Text = "  OK  ";
            btnConfirmOK.CausesValidation = false;
            btnConfirmOK.Attributes.Add("onblur", "if($get('pnlConfirm').style.display=='') $get('btnConfirmCancel').focus();");
            cell3.Controls.Add(btnConfirmOK);

            ctlLiteral.Text = "&nbsp;&nbsp;&nbsp;";
            cell3.Controls.Add(ctlLiteral);

            btnConfirmCancel.CssClass = "button";
            btnConfirmCancel.ID = "btnConfirmCancel";
            btnConfirmCancel.Text = "Cancel";
            btnConfirmCancel.CausesValidation = false;
            btnConfirmCancel.Attributes.Add("onblur", "if($get('pnlConfirm').style.display=='') $get('btnConfirmOK').focus();");

            cell3.Controls.Add(btnConfirmCancel);
            row2.Cells.Add(cell3);
            tab.Rows.Add(row2);
            pnlConfirm.Controls.Add(tab);

            #endregion

            this.Form.Controls.Add(pnlConfirm);

            CBExtDelete.ID = "CBExtDelete";
            CBExtDelete.ConfirmText = "Are you sure want to delete this record?";
            CBExtDelete.TargetControlID = "btnJunk";
            CBExtDelete.DisplayModalPopupID = "MPExtConfirm";
            CBExtDelete.OnClientCancel = "HandleConfirmCancel";
            this.Form.Controls.Add(CBExtDelete);

            MPExtConfirm.ID = "MPExtConfirm";
            MPExtConfirm.TargetControlID = "btnJunk";
            MPExtConfirm.PopupControlID = "pnlConfirm";
            MPExtConfirm.BackgroundCssClass = "modalBackground";
            MPExtConfirm.OkControlID = "btnConfirmOK";
            MPExtConfirm.CancelControlID = "btnConfirmCancel";
            this.Form.Controls.Add(MPExtConfirm);
        }

        /// <summary>
        /// This method call when u have postback on ur page others required AsyncPostBack
        /// </summary>
        /// <param name="objPage"></param>
        /// <param name="alertMSG"></param>
        public void CreateMessageAlert(Page objPage, string alertMSG)
        {
            Label lblMessage = (Label)objPage.FindControl("lblMessage");
            lblMessage.Text = alertMSG;
            ModalPopupExtender MPExtAlert = (ModalPopupExtender)objPage.FindControl("MPExtAlert");
            MPExtAlert.Show();
        }

        public void CreateMessageAlert(Page objPage, Control ctl, string alertMSG)
        {
            Label lblMessage = (Label)objPage.FindControl("lblMessage");
            lblMessage.Text = alertMSG;
            ModalPopupExtender MPExtAlert = (ModalPopupExtender)objPage.FindControl("MPExtAlert");
            MPExtAlert.Show();
            MPExtAlert.OnOkScript = "controlToFocus='" + ctl.ClientID + "';SetFocus();";
        }

        public void CreateMessageAlert(Control ctl, string alertMSG)
        {
            string JS = "AlertModalPopup('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlert(HtmlControl ctl, string alertMSG)
        {
            string JS = "AlertModalPopup('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlert(string alertMSG)
        {
            string JS = "AlertModalPopup(null,'" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        #endregion

        #region --------------- New Alert Message Box ---------------
        //-- New Alert Messages Added by DADA on 24Jan2013

        public void TransferAlertMessageSuccess(string alertMSG, string toUrl)
        {
            string JS = "TransferMessageSuccess('" + alertMSG + "','" + toUrl + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void TransferAlertMessageSuccess(Page objPage, string alertMSG, string toUrl)
        {
            Label lblMessage = (Label)objPage.FindControl("lblMessageSuccess");
            lblMessage.Text = alertMSG;
            ModalPopupExtender MPExtAlert = (ModalPopupExtender)objPage.FindControl("MPExtAlertSuccess");
            MPExtAlert.Show();
            MPExtAlert.OnOkScript = "TransferUrl('" + toUrl + "');";
        }

        private void AddAlertControlOnPageSuccess()
        {
            Panel pnlAlertSuccess = new Panel();
            ModalPopupExtender MPExtAlert = new ModalPopupExtender();

            pnlAlertSuccess.ID = "pnlAlertSuccess";
            pnlAlertSuccess.GroupingText = "Message";
            pnlAlertSuccess.Style.Add("display", "none");
            pnlAlertSuccess.CssClass = "modalPopupSuccess";
            pnlAlertSuccess.Attributes.Add("runat", "server");

            //Panel pnlAlertSuccessHead = new Panel();
            //pnlAlertSuccessHead.ID = "pnlAlertSuccessHead";
            //pnlAlertSuccessHead.GroupingText = "Message";
            ////pnlAlertSuccessHead.Style.Add("display", "none");
            //pnlAlertSuccessHead.CssClass = "modalPopupSuccessHead";

            #region --------------- Success Panel Content ---------------

            HtmlTable tab = new HtmlTable();
            HtmlTableRow row1 = new HtmlTableRow();
            HtmlTableRow row2 = new HtmlTableRow();
            HtmlTableCell cell1 = new HtmlTableCell();
            HtmlTableCell cell2 = new HtmlTableCell();
            HtmlTableCell cell3 = new HtmlTableCell();
            HtmlImage img = new HtmlImage();
            Label lblMessage = new Label();
            Button btnOK = new Button();
            Button btnJunk = new Button();

            //HtmlTableCell cellHeader = new HtmlTableCell();
            //cellHeader.Align = "left";
            //cellHeader.Width = "100%";
            //cellHeader.ColSpan = 2;
            //Label lblMessageheader = new Label();
            //lblMessageheader.ID = "lblMessageheader";
            //lblMessageheader.Text = "Message";
            //lblMessageheader.CssClass = "modalPopupSuccessHead";
            //cellHeader.Controls.Add(lblMessageheader);
            //HtmlTableRow rowHeader = new HtmlTableRow();
            //rowHeader.Cells.Add(cellHeader);
            //tab.Rows.Add(rowHeader);

            img.Src = "~/Images/MsgSuccess.png";    // "../Images/Info.gif";
            img.Align = "left";
            cell1.Align = "right";
            cell1.Width = "20%";
            cell1.Controls.Add(img);
            cell2.Align = "center";
            lblMessage.ID = "lblMessageSuccess";
            lblMessage.Style.Add("text-align", "center");
            lblMessage.Attributes.Add("runat", "server");
            cell2.Controls.Add(lblMessage);

            row1.Cells.Add(cell1);
            row1.Cells.Add(cell2);
            tab.Rows.Add(row1);
            cell3.Align = "center";
            cell3.ColSpan = 2;

            btnOK.CssClass = "button";
            btnOK.ID = "btnOKSuccess";
            btnOK.Text = "  OK  ";
            btnOK.Attributes.Add("runat", "server");
            btnOK.CausesValidation = false;
            btnOK.Attributes.Add("onblur", "if($get('pnlAlertSuccess').style.display=='') this.focus();");
            cell3.Controls.Add(btnOK);
            row2.Cells.Add(cell3);
            tab.Rows.Add(row2);

            pnlAlertSuccess.Controls.Add(tab);

            #endregion

            pnlAlertSuccess.DefaultButton = "btnOKSuccess";
            this.Form.Controls.Add(pnlAlertSuccess);

            MPExtAlert.ID = "MPExtAlertSuccess";
            MPExtAlert.TargetControlID = "btnJunkSuccess";
            MPExtAlert.PopupControlID = "pnlAlertSuccess";
            MPExtAlert.BackgroundCssClass = "modalBackground";
            MPExtAlert.OkControlID = "btnOKSuccess";
            MPExtAlert.OnOkScript = "SetFocus();";
            this.Form.Controls.Add(MPExtAlert);

            btnJunk.ID = "btnJunkSuccess";
            btnJunk.Attributes.Add("runat", "server");
            btnJunk.Style.Add("display", "none");
            btnJunk.CausesValidation = false;
            this.Form.Controls.Add(btnJunk);
        }

        /*private void AddAlertControlOnPageSuccess()
        {
            Panel pnlAlertSuccess = new Panel();
            pnlAlertSuccess.ID = "pnlAlertSuccess";
            pnlAlertSuccess.GroupingText = " ";
            pnlAlertSuccess.Style.Add("display", "none");
            //pnlAlertSuccess.CssClass = "modalPopupSuccess";
            pnlAlertSuccess.Attributes.Add("runat", "server");

            #region --------------- Success Panel Content ---------------

            HtmlTable tab = new HtmlTable();
            tab.Width = "100%";
            tab.CellPadding = 5;
            tab.CellSpacing = 0;
            tab.Align = "center";
            //tab.Border = 0;
            tab.Attributes.Add("class", "modalPopupSuccTable");

            HtmlTableCell cellHeader = new HtmlTableCell();
            cellHeader.Align = "left";
            cellHeader.Width = "100%";
            cellHeader.ColSpan = 2;
            cellHeader.Attributes.Add("class", "modalPopupSuccessHead");
            Label lblMessageheader = new Label();
            lblMessageheader.ID = "lblMessageheader";
            lblMessageheader.Text = "Message";
            lblMessageheader.Style.Add("text-align", "left");
            lblMessageheader.CssClass = "modalPopupSuccessHead";
            cellHeader.Controls.Add(lblMessageheader);
            HtmlTableRow rowHeader = new HtmlTableRow();
            rowHeader.Cells.Add(cellHeader);
            tab.Rows.Add(rowHeader);

            HtmlTableCell cell1 = new HtmlTableCell();
            cell1.Align = "right";
            cell1.Width = "10%";
            HtmlImage img = new HtmlImage();
            img.Src = "~/Images/MsgSuccess.png";
            img.Align = "left";
            cell1.Controls.Add(img);

            HtmlTableCell cell2 = new HtmlTableCell();
            cell2.Align = "center";
            Label lblMessage = new Label();
            lblMessage.ID = "lblMessageSuccess";
            lblMessage.Style.Add("text-align", "center");
            lblMessage.Attributes.Add("runat", "server");
            cell2.Controls.Add(lblMessage);

            HtmlTableRow row1 = new HtmlTableRow();
            row1.Cells.Add(cell1);
            row1.Cells.Add(cell2);
            tab.Rows.Add(row1);

            HtmlTableCell cell3 = new HtmlTableCell();
            cell3.Attributes.Add("class", "mpClose");
            cell3.Align = "center";
            cell3.ColSpan = 2;
            Button btnOK = new Button();
            btnOK.CssClass = "button";
            btnOK.ID = "btnOKSuccess";
            btnOK.Text = "  OK  ";
            btnOK.Attributes.Add("runat", "server");
            btnOK.CausesValidation = false;
            btnOK.Attributes.Add("onblur", "if($get('pnlAlertSuccess').style.display=='') this.focus();");
            cell3.Controls.Add(btnOK);

            HtmlTableRow row2 = new HtmlTableRow();
            row2.Cells.Add(cell3);
            tab.Rows.Add(row2);

            pnlAlertSuccess.Controls.Add(tab);

            #endregion

            pnlAlertSuccess.DefaultButton = "btnOKSuccess";
            this.Form.Controls.Add(pnlAlertSuccess);
            ModalPopupExtender MPExtAlert = new ModalPopupExtender();
            MPExtAlert.ID = "MPExtAlertSuccess";
            MPExtAlert.TargetControlID = "btnJunkSuccess";
            MPExtAlert.PopupControlID = "pnlAlertSuccess";
            MPExtAlert.BackgroundCssClass = "modalBackground";
            MPExtAlert.OkControlID = "btnOKSuccess";
            MPExtAlert.OnOkScript = "SetFocus();";
            this.Form.Controls.Add(MPExtAlert);
            Button btnJunk = new Button();
            btnJunk.ID = "btnJunkSuccess";
            btnJunk.Attributes.Add("runat", "server");
            btnJunk.Style.Add("display", "none");

            btnJunk.CausesValidation = false;

            this.Form.Controls.Add(btnJunk);
        }*/

        private void AddAlertControlOnPageErr()
        {
            Panel pnlAlertErr = new Panel();
            Button btnJunkErr = new Button();
            ModalPopupExtender MPExtAlertErr = new ModalPopupExtender();

            pnlAlertErr.ID = "pnlAlertErr";
            pnlAlertErr.GroupingText = "Message";
            pnlAlertErr.Style.Add("display", "none");
            pnlAlertErr.CssClass = "modalPopupSuccess";
            pnlAlertErr.Attributes.Add("runat", "server");

            //Panel pnlAlertSuccessHead = new Panel();
            //pnlAlertSuccessHead.ID = "pnlAlertSuccessHead";
            //pnlAlertSuccessHead.GroupingText = "Message";
            ////pnlAlertSuccessHead.Style.Add("display", "none");
            //pnlAlertSuccessHead.CssClass = "modalPopupSuccessHead";

            #region --------------- Success Panel Content ---------------

            HtmlTable tab = new HtmlTable();
            HtmlTableRow row1 = new HtmlTableRow();
            HtmlTableRow row2 = new HtmlTableRow();
            HtmlTableCell cell1 = new HtmlTableCell();
            HtmlTableCell cell2 = new HtmlTableCell();
            HtmlTableCell cell3 = new HtmlTableCell();
            HtmlImage img = new HtmlImage();
            Button btnOKErr = new Button();
            Label lblMessageErr = new Label();

            //HtmlTableCell cellHeader = new HtmlTableCell();
            //cellHeader.Align = "left";
            //cellHeader.Width = "100%";
            //cellHeader.ColSpan = 2;
            //Label lblMessageheader = new Label();
            //lblMessageheader.ID = "lblMessageheader";
            //lblMessageheader.Text = "Message";
            //lblMessageheader.CssClass = "modalPopupSuccessHead";
            //cellHeader.Controls.Add(lblMessageheader);
            //HtmlTableRow rowHeader = new HtmlTableRow();
            //rowHeader.Cells.Add(cellHeader);
            //tab.Rows.Add(rowHeader);

            img.Src = "~/Images/MsgErr.png";
            img.Align = "left";

            cell1.Align = "right";
            cell1.Width = "20%";
            cell1.Controls.Add(img);
            cell2.Align = "center";

            lblMessageErr.ID = "lblMessageErr";
            lblMessageErr.Style.Add("text-align", "center");
            lblMessageErr.Attributes.Add("runat", "server");
            cell2.Controls.Add(lblMessageErr);

            row1.Cells.Add(cell1);
            row1.Cells.Add(cell2);
            tab.Rows.Add(row1);

            cell3.Align = "center";
            cell3.ColSpan = 2;

            btnOKErr.CssClass = "button";
            btnOKErr.ID = "btnOKErr";
            btnOKErr.Text = "  OK  ";
            btnOKErr.Attributes.Add("runat", "server");
            btnOKErr.CausesValidation = false;
            btnOKErr.Attributes.Add("onblur", "if($get('pnlAlertErr').style.display=='') this.focus();");
            cell3.Controls.Add(btnOKErr);
            row2.Cells.Add(cell3);
            tab.Rows.Add(row2);
            pnlAlertErr.Controls.Add(tab);

            #endregion

            pnlAlertErr.DefaultButton = "btnOKErr";
            this.Form.Controls.Add(pnlAlertErr);

            MPExtAlertErr.ID = "MPExtAlertErr";
            MPExtAlertErr.TargetControlID = "btnJunkErr";
            MPExtAlertErr.PopupControlID = "pnlAlertErr";
            MPExtAlertErr.BackgroundCssClass = "modalBackground";
            MPExtAlertErr.OkControlID = "btnOKErr";
            MPExtAlertErr.OnOkScript = "SetFocus();";
            this.Form.Controls.Add(MPExtAlertErr);

            btnJunkErr.ID = "btnJunkErr";
            btnJunkErr.Attributes.Add("runat", "server");
            btnJunkErr.Style.Add("display", "none");
            btnJunkErr.CausesValidation = false;
            this.Form.Controls.Add(btnJunkErr);
        }

        private void AddAlertControlOnPageWarn()
        {
            Panel pnlAlertWarn = new Panel();
            pnlAlertWarn.ID = "pnlAlertWarn";
            pnlAlertWarn.GroupingText = "Message";
            pnlAlertWarn.Style.Add("display", "none");
            pnlAlertWarn.CssClass = "modalPopupSuccess";
            pnlAlertWarn.Attributes.Add("runat", "server");

            //Panel pnlAlertSuccessHead = new Panel();
            //pnlAlertSuccessHead.ID = "pnlAlertSuccessHead";
            //pnlAlertSuccessHead.GroupingText = "Message";
            ////pnlAlertSuccessHead.Style.Add("display", "none");
            //pnlAlertSuccessHead.CssClass = "modalPopupSuccessHead";

            #region --------------- Success Panel Content ---------------

            HtmlTable tab = new HtmlTable();

            //HtmlTableCell cellHeader = new HtmlTableCell();
            //cellHeader.Align = "left";
            //cellHeader.Width = "100%";
            //cellHeader.ColSpan = 2;
            //Label lblMessageheader = new Label();
            //lblMessageheader.ID = "lblMessageheader";
            //lblMessageheader.Text = "Message";
            //lblMessageheader.CssClass = "modalPopupSuccessHead";
            //cellHeader.Controls.Add(lblMessageheader);
            //HtmlTableRow rowHeader = new HtmlTableRow();
            //rowHeader.Cells.Add(cellHeader);
            //tab.Rows.Add(rowHeader);

            HtmlTableCell cell1 = new HtmlTableCell();
            cell1.Align = "right";
            cell1.Width = "20%";
            HtmlImage img = new HtmlImage();
            //img.Src = "../Images/Info.gif";
            img.Src = "~/Images/MsgWarn.png";
            img.Align = "left";
            cell1.Controls.Add(img);

            HtmlTableCell cell2 = new HtmlTableCell();
            cell2.Align = "center";
            Label lblMessageWarn = new Label();
            lblMessageWarn.ID = "lblMessageWarn";
            lblMessageWarn.Style.Add("text-align", "center");
            lblMessageWarn.Attributes.Add("runat", "server");
            cell2.Controls.Add(lblMessageWarn);

            HtmlTableRow row1 = new HtmlTableRow();
            row1.Cells.Add(cell1);
            row1.Cells.Add(cell2);
            tab.Rows.Add(row1);

            HtmlTableCell cell3 = new HtmlTableCell();
            cell3.Align = "center";
            cell3.ColSpan = 2;
            Button btnOKWarn = new Button();
            btnOKWarn.CssClass = "button";
            btnOKWarn.ID = "btnOKWarn";
            btnOKWarn.Text = "  OK  ";
            btnOKWarn.Attributes.Add("runat", "server");
            btnOKWarn.CausesValidation = false;
            btnOKWarn.Attributes.Add("onblur", "if($get('pnlAlertWarn').style.display=='') this.focus();");
            cell3.Controls.Add(btnOKWarn);

            HtmlTableRow row2 = new HtmlTableRow();
            row2.Cells.Add(cell3);
            tab.Rows.Add(row2);

            pnlAlertWarn.Controls.Add(tab);

            #endregion

            pnlAlertWarn.DefaultButton = "btnOKWarn";
            this.Form.Controls.Add(pnlAlertWarn);
            ModalPopupExtender MPExtAlertWarn = new ModalPopupExtender();
            MPExtAlertWarn.ID = "MPExtAlertWarn";
            MPExtAlertWarn.TargetControlID = "btnJunkWarn";
            MPExtAlertWarn.PopupControlID = "pnlAlertWarn";
            MPExtAlertWarn.BackgroundCssClass = "modalBackground";
            MPExtAlertWarn.OkControlID = "btnOKWarn";
            MPExtAlertWarn.OnOkScript = "SetFocus();";
            this.Form.Controls.Add(MPExtAlertWarn);
            Button btnJunkWarn = new Button();
            btnJunkWarn.ID = "btnJunkWarn";
            btnJunkWarn.Attributes.Add("runat", "server");
            btnJunkWarn.Style.Add("display", "none");
            btnJunkWarn.CausesValidation = false;

            this.Form.Controls.Add(btnJunkWarn);
        }

        private void AddAlertControlOnPageInfo()
        {
            Panel pnlAlertInfo = new Panel();
            ModalPopupExtender MPExtAlertInfo = new ModalPopupExtender();
            Button btnJunkInfo = new Button();

            pnlAlertInfo.ID = "pnlAlertInfo";
            pnlAlertInfo.GroupingText = "Message";
            pnlAlertInfo.Style.Add("display", "none");
            pnlAlertInfo.CssClass = "modalPopupSuccess";
            pnlAlertInfo.Attributes.Add("runat", "server");

            //Panel pnlAlertSuccessHead = new Panel();
            //pnlAlertSuccessHead.ID = "pnlAlertSuccessHead";
            //pnlAlertSuccessHead.GroupingText = "Message";
            ////pnlAlertSuccessHead.Style.Add("display", "none");
            //pnlAlertSuccessHead.CssClass = "modalPopupSuccessHead";

            #region --------------- Success Panel Content ---------------

            HtmlTable tab = new HtmlTable();

            //HtmlTableCell cellHeader = new HtmlTableCell();
            //cellHeader.Align = "left";
            //cellHeader.Width = "100%";
            //cellHeader.ColSpan = 2;
            //Label lblMessageheader = new Label();
            //lblMessageheader.ID = "lblMessageheader";
            //lblMessageheader.Text = "Message";
            //lblMessageheader.CssClass = "modalPopupSuccessHead";
            //cellHeader.Controls.Add(lblMessageheader);
            //HtmlTableRow rowHeader = new HtmlTableRow();
            //rowHeader.Cells.Add(cellHeader);
            //tab.Rows.Add(rowHeader);

            HtmlTableCell cell1 = new HtmlTableCell();
            cell1.Align = "right";
            cell1.Width = "20%";
            HtmlImage img = new HtmlImage();
            //img.Src = "../Images/Info.gif";
            img.Src = "~/Images/MsgInfo.png";
            img.Align = "left";
            cell1.Controls.Add(img);

            HtmlTableCell cell2 = new HtmlTableCell();
            cell2.Align = "center";
            Label lblMessageInfo = new Label();
            lblMessageInfo.ID = "lblMessageInfo";
            lblMessageInfo.Style.Add("text-align", "center");
            lblMessageInfo.Attributes.Add("runat", "server");
            cell2.Controls.Add(lblMessageInfo);

            HtmlTableRow row1 = new HtmlTableRow();
            row1.Cells.Add(cell1);
            row1.Cells.Add(cell2);
            tab.Rows.Add(row1);

            HtmlTableCell cell3 = new HtmlTableCell();
            cell3.Align = "center";
            cell3.ColSpan = 2;
            Button btnOKInfo = new Button();
            btnOKInfo.CssClass = "button";
            btnOKInfo.ID = "btnOKInfo";
            btnOKInfo.Text = "  OK  ";
            btnOKInfo.Attributes.Add("runat", "server");
            btnOKInfo.CausesValidation = false;
            btnOKInfo.Attributes.Add("onblur", "if($get('pnlAlertInfo').style.display=='') this.focus();");
            cell3.Controls.Add(btnOKInfo);

            HtmlTableRow row2 = new HtmlTableRow();
            row2.Cells.Add(cell3);
            tab.Rows.Add(row2);

            pnlAlertInfo.Controls.Add(tab);

            #endregion

            pnlAlertInfo.DefaultButton = "btnOKInfo";
            this.Form.Controls.Add(pnlAlertInfo);

            MPExtAlertInfo.ID = "MPExtAlertInfo";
            MPExtAlertInfo.TargetControlID = "btnJunkInfo";
            MPExtAlertInfo.PopupControlID = "pnlAlertInfo";
            MPExtAlertInfo.BackgroundCssClass = "modalBackground";
            MPExtAlertInfo.OkControlID = "btnOKInfo";
            MPExtAlertInfo.OnOkScript = "SetFocus();";
            this.Form.Controls.Add(MPExtAlertInfo);

            btnJunkInfo.ID = "btnJunkInfo";
            btnJunkInfo.Attributes.Add("runat", "server");
            btnJunkInfo.Style.Add("display", "none");
            btnJunkInfo.CausesValidation = false;
            this.Form.Controls.Add(btnJunkInfo);
        }

        #region --------------- Alert Message Box Success---------------

        public void CreateMessageAlertSuccess(Page objPage, string alertMSG)
        {
            Label lblMessageSuccess = (Label)objPage.FindControl("lblMessageSuccess");
            lblMessageSuccess.Text = alertMSG;
            ModalPopupExtender MPExtAlertSuccess = (ModalPopupExtender)objPage.FindControl("MPExtAlertSuccess");
            MPExtAlertSuccess.Show();
        }

        public void CreateMessageAlertSuccess(Page objPage, Control ctl, string alertMSG)
        {
            Label lblMessageSuccess = (Label)objPage.FindControl("lblMessageSuccess");
            lblMessageSuccess.Text = alertMSG;
            ModalPopupExtender MPExtAlertSuccess = (ModalPopupExtender)objPage.FindControl("MPExtAlertSuccess");
            MPExtAlertSuccess.Show();
            MPExtAlertSuccess.OnOkScript = "controlToFocus='" + ctl.ClientID + "';SetFocus();";
        }

        public void CreateMessageAlertSuccess(Control ctl, string alertMSG)
        {
            string JS = "AlertModalPopupSuccess('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlertSuccess(HtmlControl ctl, string alertMSG)
        {
            string JS = "AlertModalPopupSuccess('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlertSuccess(string alertMSG)
        {
            string JS = "AlertModalPopupSuccess(null,'" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        #endregion

        #region --------------- Alert Message Box Err---------------

        public void CreateMessageAlertErr(Page objPage, string alertMSG)
        {
            Label lblMessageErr = (Label)objPage.FindControl("lblMessageErr");
            lblMessageErr.Text = alertMSG;
            ModalPopupExtender MPExtAlertErr = (ModalPopupExtender)objPage.FindControl("MPExtAlertErr");
            MPExtAlertErr.Show();
        }

        public void CreateMessageAlertErr(Page objPage, Control ctl, string alertMSG)
        {
            Label lblMessageErr = (Label)objPage.FindControl("lblMessageErr");
            lblMessageErr.Text = alertMSG;
            ModalPopupExtender MPExtAlertErr = (ModalPopupExtender)objPage.FindControl("MPExtAlertErr");
            MPExtAlertErr.Show();
            MPExtAlertErr.OnOkScript = "controlToFocus='" + ctl.ClientID + "';SetFocus();";
        }

        public void CreateMessageAlertErr(Control ctl, string alertMSG)
        {
            string JS = "AlertModalPopupErr('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlertErr(HtmlControl ctl, string alertMSG)
        {
            string JS = "AlertModalPopupErr('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlertErr(string alertMSG)
        {
            string JS = "AlertModalPopupErr(null,'" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        #endregion

        #region --------------- Alert Message Box Warn---------------

        public void CreateMessageAlertWarn(Page objPage, string alertMSG)
        {
            Label lblMessageWarn = (Label)objPage.FindControl("lblMessageWarn");
            lblMessageWarn.Text = alertMSG;
            ModalPopupExtender MPExtAlertWarn = (ModalPopupExtender)objPage.FindControl("MPExtAlertWarn");
            MPExtAlertWarn.Show();
        }

        public void CreateMessageAlertWarn(Page objPage, Control ctl, string alertMSG)
        {
            Label lblMessageWarn = (Label)objPage.FindControl("lblMessageWarn");
            lblMessageWarn.Text = alertMSG;
            ModalPopupExtender MPExtAlertWarn = (ModalPopupExtender)objPage.FindControl("MPExtAlertWarn");
            MPExtAlertWarn.Show();
            MPExtAlertWarn.OnOkScript = "controlToFocus='" + ctl.ClientID + "';SetFocus();";
        }

        public void CreateMessageAlertWarn(Control ctl, string alertMSG)
        {
            string JS = "AlertModalPopupWarn('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlertWarn(HtmlControl ctl, string alertMSG)
        {
            string JS = "AlertModalPopupWarn('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlertWarn(string alertMSG)
        {
            string JS = "AlertModalPopupWarn(null,'" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        #endregion

        #region --------------- Alert Message Box Info---------------

        public void CreateMessageAlertInfo(Page objPage, string alertMSG)
        {
            Label lblMessageInfo = (Label)objPage.FindControl("lblMessageInfo");
            lblMessageInfo.Text = alertMSG;
            ModalPopupExtender MPExtAlertInfo = (ModalPopupExtender)objPage.FindControl("MPExtAlertInfo");
            MPExtAlertInfo.Show();
        }

        public void CreateMessageAlertInfo(Page objPage, Control ctl, string alertMSG)
        {
            Label lblMessageInfo = (Label)objPage.FindControl("lblMessageInfo");
            lblMessageInfo.Text = alertMSG;
            ModalPopupExtender MPExtAlertInfo = (ModalPopupExtender)objPage.FindControl("MPExtAlertInfo");
            MPExtAlertInfo.Show();
            MPExtAlertInfo.OnOkScript = "controlToFocus='" + ctl.ClientID + "';SetFocus();";
        }

        public void CreateMessageAlertInfo(Control ctl, string alertMSG)
        {
            string JS = "AlertModalPopupInfo('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlertInfo(HtmlControl ctl, string alertMSG)
        {
            string JS = "AlertModalPopupInfo('" + ctl.ClientID + "','" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        public void CreateMessageAlertInfo(string alertMSG)
        {
            string JS = "AlertModalPopupInfo(null,'" + alertMSG + "');";
            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "showAlert", JS, true);
        }

        #endregion

        private void LoadNewAlertMessageBoxes()
        {
            AddAlertControlOnPageSuccess();
            AddAlertControlOnPageErr();
            AddAlertControlOnPageInfo();
            AddAlertControlOnPageWarn();
        }

        #endregion

        public void ExportToExcel(int Module_Code, string List_Name)
        {
            string strQuery = "EXEC USP_EXPORT_TABLE_TO_EXCEL @Module_Code = " + Module_Code;

            DataSet ds = DatabaseBroker.ProcessSelectDirectly(strQuery);
            Label lbl = new Label();
            lbl.Text = "<div><h3>" + List_Name + "</div></h3>";
            
            if (ds.Tables[0].Rows.Count > 0)
            {
                System.IO.StringWriter sw = new System.IO.StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);
                GridView grd = new GridView();
                grd.DataSource = ds.Tables[0];
                grd.DataBind();
                lbl.RenderControl(htw);
                grd.RenderControl(htw);

                Response.ClearContent();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", List_Name + ".xls"));
                
                Response.ContentType = "application/ms-excel";
                Response.Write(sw.ToString());
                HttpContext.Current.Response.End();

            }
        }

        //public override void VerifyRenderingInServerForm(Control control)
        //{ }
    }
}