using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;
using System.Collections;
namespace RightsU_Plus.Controllers
{
    public class IPR_Int_DomController : BaseController
    {

        //
        // GET: /IPR_Int_Dom/
        #region --- Attributes and Properties ---
        public int PageNo
        {
            get
            {
                if (TempData["PageNo"] == null)
                    TempData["PageNo"] = 1;
                return (int)TempData["PageNo"];
            }
            set { TempData["PageNo"] = value; }
        }

        private string Mode
        {
            get
            {
                if (Session["Record_Mode"] == null)
                    Session["Record_Mode"] = GlobalParams.DEAL_MODE_ADD;
                return Session["Record_Mode"].ToString();
            }
            set
            {
                Session["Record_Mode"] = value;
            }
        }

        private string CurrentTab
        {
            get
            {
                if (TempData["CurrentTab"] == null)
                    TempData["CurrentTab"] = "D";
                string tab = TempData["CurrentTab"].ToString();
                TempData.Keep("CurrentTab");
                return tab;
            }
            set
            {
                TempData["CurrentTab"] = value;
            }
        }

        private int RowIndex
        {
            get
            {
                if (TempData["RowIndex"] == null)
                    TempData["RowIndex"] = -1;
                return Convert.ToInt32(TempData["RowIndex"]);
            }
            set
            {
                TempData["RowIndex"] = value;
            }
        }

        private IPR_REP objIPR_REP
        {
            get
            {
                if (Session["objIPR_REP"] == null)
                    Session["objIPR_REP"] = new IPR_REP();
                return (IPR_REP)Session["objIPR_REP"];
            }
            set
            {
                Session["objIPR_REP"] = value;
            }
        }
        private IPR_REP_Service objIPR_REP_Service
        {
            get
            {
                if (Session["objIPR_REP_Service"] == null)
                    Session["objIPR_REP_Service"] = new IPR_REP_Service(objLoginEntity.ConnectionStringName);
                return (IPR_REP_Service)Session["objIPR_REP_Service"];
            }
            set
            {
                Session["objIPR_REP_Service"] = value;
            }
        }
        private List<IPR_REP_ATTACHMENTS> listAttachment
        {
            get
            {
                if (Session["listAttachment"] == null)
                    Session["listAttachment"] = new List<IPR_REP_ATTACHMENTS>();
                return (List<IPR_REP_ATTACHMENTS>)Session["listAttachment"];
            }
            set
            {
                Session["listAttachment"] = value;
            }
        }

        private string File_Name
        {
            get
            {
                if (Session["File_Name"] == null)
                    Session["File_Name"] = "";
                return Session["File_Name"].ToString();
            }
            set
            {
                Session["File_Name"] = value;
            }
        }
        private string System_File_Name
        {
            get
            {
                if (Session["System_File_Name"] == null)
                    Session["System_File_Name"] = "";
                return Session["System_File_Name"].ToString();
            }
            set
            {
                Session["System_File_Name"] = value;
            }
        }
        #endregion
        private const string CurrentTab_Domestic = "D";
        private const string CurrentTab_International = "I";

        public ActionResult Index(string Message = "")
        {

            #region --- Bind Global Properties ---

            ViewBag.hdnIPR_Renewed_Untill_Year1 = (new System_Parameter_New_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Parameter_Name == "IPR_Renewed_Untill_Year").Select(s => s.Parameter_Value).FirstOrDefault();

            TempData["hdnIPR_Renewed_Untill_Year"] = (new System_Parameter_New_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Parameter_Name == "IPR_Renewed_Untill_Year").Select(s => s.Parameter_Value).FirstOrDefault();
            #endregion
            string imagePage = string.Empty;
            ClearSession();
            int code = 0;
            bool imageshow = true;
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString_IPR"] != null)
            {
                obj_Dictionary = TempData["QueryString_IPR"] as Dictionary<string, string>;
                TempData.Keep("QueryString_IPR");
                Mode = obj_Dictionary["MODE"];
                CurrentTab = obj_Dictionary["Tab"];
                code = Convert.ToInt32(obj_Dictionary["IPR_Rep_Code"]);
            }
            int Selected_IPR_Type_Code = 0, Selected_Country_Code = 0, Selected_Application_Status_Code = 0, Selected_Applicant_Code = 0;
            List<string> lstFrq = new List<string>();
            if (code == 0)
            {
                objIPR_REP = new IPR_REP();
                lstFrq.Add("60");
                lstFrq.Add("30");
                lstFrq.Add("15");
                lstFrq.Add("7");
                lstFrq.Add("3");
                lstFrq.Add("1");
                objIPR_REP.IPR_For = CurrentTab;
                objIPR_REP.Version = "0001";
            }
            else
            {
                objIPR_REP = objIPR_REP_Service.GetById(code);
                for (int i = 0; i < 6; i++)
                {
                    if (i < objIPR_REP.IPR_REP_EMAIL_FREQ.Count)
                    {
                        IPR_REP_EMAIL_FREQ objIPR_REP_Email_Frq = objIPR_REP.IPR_REP_EMAIL_FREQ.ElementAt(i);
                        if (objIPR_REP_Email_Frq != null)
                            lstFrq.Add(objIPR_REP_Email_Frq.Days.ToString());
                    }
                    else
                        lstFrq.Add("");
                }
                listAttachment = objIPR_REP.IPR_REP_ATTACHMENTS.Where(a => a.EntityState != State.Deleted && a.Flag == "G").ToList();
                Selected_IPR_Type_Code = objIPR_REP.IPR_Type_Code ?? 0;
                Selected_Country_Code = objIPR_REP.Country_Code ?? 0;
                Selected_Application_Status_Code = objIPR_REP.Application_Status_Code ?? 0;
                Selected_Applicant_Code = objIPR_REP.Applicant_Code ?? 0;
                IPR_REP_ATTACHMENTS objAttach = objIPR_REP.IPR_REP_ATTACHMENTS.Where(a => a.EntityState != State.Deleted && a.Flag == "M").FirstOrDefault();
                if (objAttach != null)
                {
                    string folderPath =ConfigurationManager.AppSettings["UploadFilePath"];
                    string fullPath = folderPath + objAttach.System_File_Name;
                    imagePage = fullPath;
                    //imageshow = true;
                    imageshow = checkImage(objAttach.System_File_Name);
                }
            }

            ViewBag.Bindddl_IPR_Type = Bindddl_IPR_Type(Selected_IPR_Type_Code);
            ViewBag.Bindddl_Country = Bindddl_Country(Selected_Country_Code);
            ViewBag.Bindddl_Application_Status = Bindddl_Application_Status(Selected_Application_Status_Code);
            ViewBag.Bindddl_Applicant = Bindddl_Applicant(Selected_Applicant_Code);

            if (Mode == GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.ChannelList = string.Join(", ", objIPR_REP.IPR_Rep_Channel.Select(s => s.Channel.Channel_Name).ToArray());
                ViewBag.BusinessUnitList = string.Join(", ", objIPR_REP.IPR_Rep_Business_Unit.Select(s => s.Business_Unit.Business_Unit_Name).ToArray());
            }
            else
            {
                List<RightsU_Entities.Channel> lstChannel = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Channel_Name).ToList();
                var channelCodes = objIPR_REP.IPR_Rep_Channel.Select(s => s.Channel_Code).ToArray();
                ViewBag.ChannelList = new MultiSelectList(lstChannel, "Channel_Code", "Channel_Name", channelCodes);

                List<Business_Unit> lstBusinessUnit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).OrderBy(o => o.Business_Unit_Name).ToList();
                var businessUnitCodes = objIPR_REP.IPR_Rep_Business_Unit.Select(s => s.Business_Unit_Code).ToArray();
                ViewBag.BusinessUnitList = new MultiSelectList(lstBusinessUnit, "Business_Unit_Code", "Business_Unit_Name", businessUnitCodes);
            }

            ViewBag.IPR_Status_History = (new USP_Service(objLoginEntity.ConnectionStringName)).USP_List_IPR_Status_History(objIPR_REP.IPR_Rep_Code).ToList();
            ViewBag.Frq_List = lstFrq;
            ViewBag.ClassCodes = string.Join(",", objIPR_REP.IPR_REP_CLASS.Select(c => c.IPR_Class_Code));
            ViewBag.imagePage = imagePage;
            ViewBag.message = Message;
            ViewBag.ImageShow = imageshow;

            if (TempData["RecodLockingCode"] == "" || TempData["RecodLockingCode"] == null)
                ViewBag.RecordLockingCode = 0;
            else
                ViewBag.RecordLockingCode = TempData["RecodLockingCode"];
            TempData.Keep("RecodLockingCode");

            if (Mode != GlobalParams.DEAL_MODE_VIEW)
                return View(objIPR_REP);
            else
                return View("View", objIPR_REP);
        }


        #region ------- bindDDl --------
        private List<SelectListItem> Bindddl_IPR_Type(int Selected_IPR_Type_Code = 0)
        {
            List<SelectListItem> lst_IPR_Type = new List<SelectListItem>();
            lst_IPR_Type = new SelectList(new IPR_TYPE_Service(objLoginEntity.ConnectionStringName).SearchFor(x => 1 == 1).ToList().OrderBy(o => o.Type), "IPR_Type_Code", "Type", Selected_IPR_Type_Code).ToList();
            lst_IPR_Type.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            return lst_IPR_Type;
        }
        private List<SelectListItem> Bindddl_Country(int Selected_Country_Code = 0)
        {
            List<SelectListItem> lst_Country = new List<SelectListItem>();
            lst_Country = new SelectList(new IPR_Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Is_Domestic_Territory == "N").ToList().OrderBy(o => o.IPR_Country_Name), "IPR_Country_Code", "IPR_Country_Name", Selected_Country_Code).ToList();
            lst_Country.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            return lst_Country;
        }
        private List<SelectListItem> Bindddl_Application_Status(int Selected_Application_Status_Code = 0)
        {
            List<SelectListItem> lst_Application_Status = new List<SelectListItem>();
            lst_Application_Status = new SelectList(new IPR_APP_STATUS_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList().OrderBy(o => o.App_Status), "IPR_App_Status_Code", "App_Status", Selected_Application_Status_Code).ToList();
            lst_Application_Status.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            return lst_Application_Status;
        }
        private List<SelectListItem> Bindddl_Applicant(int Selected_Applicant_Code = 0)
        {
            List<SelectListItem> lst_Applicant = new List<SelectListItem>();
            lst_Applicant = new SelectList(new IPR_ENTITY_Service(objLoginEntity.ConnectionStringName).SearchFor(x => 1 == 1).ToList().OrderBy(o => o.Entity), "IPR_Entity_Code", "Entity", Selected_Applicant_Code).ToList();
            lst_Applicant.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            return lst_Applicant;
        }
        #endregion

        #region ------ Methods -------
        private void ClearSession()
        {
            objIPR_REP_Service = null;
            objIPR_REP = null;
        }

        public PartialViewResult BindClassTreeView(string[] strPlatform)
        {

            ViewBag.TV_Platform = (Mode == GlobalParams.DEAL_MODE_VIEW) ? PopulateTreeNode("Y", strPlatform) : PopulateTreeNode("N", strPlatform);
            ViewBag.TreeId = "IPR_Class";
            ViewBag.TreeValueId = "hdnClassCodes";
            return PartialView("_TV_Platform");
        }
        #endregion

        #region Tree view

        public string PopulateTreeNode(string IsView, string[] selectedPlatformCodes)
        {
            string codes = string.Empty;
            if (IsView == "Y")
                codes = string.Join(",", selectedPlatformCodes);
            USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
            List<USP_Get_IPR_Class_Tree_Hierarchy_Result> lstPlatforms = objUS.USP_Get_IPR_Class_Tree_Hierarchy(codes).ToList();

            string tvChildData = "";
            List<USP_Get_IPR_Class_Tree_Hierarchy_Result> arr = lstPlatforms.Where(x => x.Parent_Class_Code == 0).ToList();
            bool IsMenuChecked = false;
            for (int i = 0; i < arr.Count; i++)
            {
                //TreeNode trNode = new TreeNode();
                USP_Get_IPR_Class_Tree_Hierarchy_Result objClass = arr[i];

                string strChild = "";
                bool IsChecked = false;

                if (objClass.ChildCount > 0)
                {
                    string strLeastChild = "";
                    IsChecked = AddChildDetailForGroup(objClass.IPR_Class_Code, lstPlatforms, IsView, out strLeastChild, selectedPlatformCodes);
                    strChild += ", key: '0', children: [ " + strLeastChild + " ]";
                }
                else
                    strChild += ", key: '0', children: [ " + objClass.IPR_Class_Code + " ]";

                if (IsChecked != true)
                {
                    if (selectedPlatformCodes != null)
                        if (selectedPlatformCodes.Where(x => x == Convert.ToString(objClass.IPR_Class_Code)).Count() > 0)
                        {
                            IsChecked = true;
                            strChild += ", selected: true";
                        }
                }
                if (IsChecked)
                    IsMenuChecked = true;
                //else
                //{
                //    if (selectedPlatformCodes  !=  null)
                //        strChild += ", expanded: true";
                //    else
                //        strChild += ", expanded: false";
                //}

                if (IsView == "Y")
                    strChild += ", hideCheckbox: true";


                if (tvChildData != "")
                    tvChildData += ",";

                tvChildData += "{ title: '" + objClass.Description + "' " + (objClass.ChildCount > 0 ? ", folder: true" : "") + strChild + " } ";

            }

            string IsRef = "";
            if (IsView == "Y")
                IsRef += ", hideCheckbox: true";


            if (IsMenuChecked)
                IsRef += ", selected: true";

            string treeViewData = "";
            if (tvChildData == "")
                treeViewData = "[{ title: 'All Classes', key: '0', folder: true, expanded: true " + IsRef + "}];";
            else
                treeViewData = "[{ title: 'All Classes', key: '0', folder: true, expanded: true " + IsRef + ", children: [" + tvChildData + "] }];";

            return treeViewData;

        }

        private bool AddChildDetailForGroup(int Platform_Code, List<USP_Get_IPR_Class_Tree_Hierarchy_Result> lstPlatforms, string IsView, out string strChild, string[] selectedPlatformCodes)
        {
            List<USP_Get_IPR_Class_Tree_Hierarchy_Result> arr = lstPlatforms.Where(x => x.Parent_Class_Code == Platform_Code).ToList();
            bool IsChecked = false;
            strChild = "";
            for (int i = 0; i < arr.Count; i++)
            {
                string strLocalChild = "";
                USP_Get_IPR_Class_Tree_Hierarchy_Result objClass = arr[i];

                if (objClass.ChildCount > 0)
                {
                    string strLeastChild = "";
                    IsChecked = AddChildDetailForGroup(objClass.IPR_Class_Code, lstPlatforms, IsView, out strLeastChild, selectedPlatformCodes);
                    strLocalChild += ", key: '0', children: [ " + strLeastChild + " ]";
                }
                else
                {
                    strLocalChild += ", key: '" + objClass.IPR_Class_Code + "'";
                    if (selectedPlatformCodes != null)
                        if (selectedPlatformCodes.Where(x => x == Convert.ToString(objClass.IPR_Class_Code)).Count() > 0)
                            IsChecked = true;
                }
                if (selectedPlatformCodes != null)
                    if (selectedPlatformCodes.Where(x => x == Convert.ToString(objClass.IPR_Class_Code)).Count() > 0)
                        strLocalChild += ", selected: true";


                if (IsView == "Y")
                    strLocalChild += ", hideCheckbox: true";

                if (selectedPlatformCodes != null)
                    strLocalChild += ", expanded: true";
                else
                    strLocalChild += ", expanded: false";

                strChild += (i > 0 ? "," : "") + " { title: '" + objClass.Description + "' " + (objClass.ChildCount > 0 ? ", folder: true " : "") + strLocalChild + " }";
            }
            return IsChecked;
        }

        #endregion

        [HttpPost]
        public ActionResult SaveFile(string hdnAttachment_Flag, string hdnAttachment_RowIndex = "-1", string txt_Description = "")
        {
            string oldSystemFileName = "";
            IPR_REP_ATTACHMENTS objIPR_REP_Attachment = null;
            if (hdnAttachment_Flag == "M")
            {
                objIPR_REP_Attachment = objIPR_REP.IPR_REP_ATTACHMENTS.Where(x => x.Flag == "M").FirstOrDefault();
                if (objIPR_REP_Attachment != null)
                    oldSystemFileName = objIPR_REP_Attachment.System_File_Name;

            }
            else if (hdnAttachment_Flag == "G")
            {
                RowIndex = Convert.ToInt32(hdnAttachment_RowIndex);
                if (RowIndex >= 0)
                    objIPR_REP_Attachment = listAttachment[RowIndex];
                if (objIPR_REP_Attachment != null)
                    oldSystemFileName = objIPR_REP_Attachment.System_File_Name;
            }

            if (objIPR_REP_Attachment == null)
            {
                objIPR_REP_Attachment = new IPR_REP_ATTACHMENTS();
                objIPR_REP_Attachment.Flag = hdnAttachment_Flag;
                if (File_Name != string.Empty && System_File_Name != string.Empty)
                    objIPR_REP.IPR_REP_ATTACHMENTS.Add(objIPR_REP_Attachment);
            }

            if (objIPR_REP_Attachment.IPR_Rep_Attachment_Code > 0)
                objIPR_REP_Attachment.EntityState = State.Modified;
            else
                objIPR_REP_Attachment.EntityState = State.Added;

            if (hdnAttachment_Flag == "G")
                objIPR_REP_Attachment.Description = txt_Description.Replace("\r\n", "\n");

            string fullPath = Server.MapPath("~") +"\\"+ ConfigurationManager.AppSettings["UploadFilePath"];

            if (File_Name != string.Empty && System_File_Name != string.Empty)
            {
                objIPR_REP_Attachment.File_Name = File_Name;
                objIPR_REP_Attachment.System_File_Name = System_File_Name;

                if (System.IO.File.Exists(fullPath + oldSystemFileName))
                    System.IO.File.Delete(fullPath + oldSystemFileName);  
            }
            if (hdnAttachment_Flag == "M")
                return Json(System_File_Name);
            else
            {
                listAttachment = objIPR_REP.IPR_REP_ATTACHMENTS.Where(a => a.EntityState != State.Deleted && a.Flag == "G").ToList();
                return PartialView("List_Attachment", listAttachment);
            }
        }



        [HttpPost]
        public void UploadAttachment()
        {
            string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"];
            foreach (string file in Request.Files)
            {
                HttpPostedFileBase fileContent = Request.Files[file];
                File_Name = fileContent.FileName;
                System_File_Name = DateTime.Now.Ticks + "~" + fileContent.FileName.Replace(" ", "_");              
                fileContent.SaveAs(fullPath + System_File_Name);
            }
        }

        public ActionResult DeleteAttachment(int row_index)
        {
            IPR_REP_ATTACHMENTS objIPR_REP_Attachment = listAttachment[row_index];
            objIPR_REP_Attachment.EntityState = State.Deleted;
            if (System.IO.File.Exists(Server.MapPath("~") + ConfigurationManager.AppSettings["UploadFilePath"] + objIPR_REP_Attachment.System_File_Name))
                System.IO.File.Delete(Server.MapPath("~") + ConfigurationManager.AppSettings["UploadFilePath"] + objIPR_REP_Attachment.System_File_Name);
            listAttachment = objIPR_REP.IPR_REP_ATTACHMENTS.Where(a => a.EntityState != State.Deleted && a.Flag == "G").ToList();
            return PartialView("List_Attachment", listAttachment);
        }

        public string checkDownloadFile(string For, string systemFileName = "")
        {
            string str = "";
            string path = string.Empty;
            string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]; ;
            if (For == "M")
            {
                IPR_REP_ATTACHMENTS objIPR_REP_Attachment = objIPR_REP.IPR_REP_ATTACHMENTS.Where(x => x.Flag == "M").FirstOrDefault();
                systemFileName = objIPR_REP_Attachment.System_File_Name;
            }
            path = fullPath + systemFileName;

            FileInfo file = new FileInfo(path);
            if (file.Exists)
            {
                return path;
            }
            else
                return "";
        }

        private bool checkImage(string imagefileName)
        {
            string path = string.Empty;
            string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]; ;
            path = fullPath + imagefileName;
            FileInfo file = new FileInfo(path);
            if (file.Exists)
            {
                return true;
            }
            else
                return false;
        }

        public void DownloadFile()
        {
            string systemFileName = Request.QueryString["systemFileName"];
            string For = Request.QueryString["For"];
            string path = string.Empty;
            string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]; ;
          
            if (For == "M")
            {
                IPR_REP_ATTACHMENTS objIPR_REP_Attachment = objIPR_REP.IPR_REP_ATTACHMENTS.Where(x => x.Flag == "M").FirstOrDefault();
                systemFileName = objIPR_REP_Attachment.System_File_Name;
            }
            path = fullPath + systemFileName;

            FileInfo file = new FileInfo(path);
            byte[] bts = System.IO.File.ReadAllBytes(path);
            Response.Clear();
            Response.ClearHeaders();
            Response.AddHeader("Content-Type", "Application/octet-stream");
            Response.AddHeader("Content-Length", bts.Length.ToString());
            Response.AddHeader("Content-Disposition", "attachment;   filename=" + systemFileName.Split('~')[1]);
            Response.BinaryWrite(bts);
            Response.Flush();
            Response.End();
        }
        private string SaveRecord(IPR_REP iprREPInstance, FormCollection formCollectionInstance)
        {
            bool isSubmit = Convert.ToBoolean(formCollectionInstance["hdnIsSubmit"]);
            string message = string.Empty;
            FillObject(iprREPInstance, formCollectionInstance);
            if (isSubmit)
            {
                objIPR_REP.Workflow_Status = GlobalParams.dealWorkFlowStatus_Approved;
            }
            else
            {
                if (objIPR_REP.IPR_Rep_Code > 0)
                    objIPR_REP.Workflow_Status = GlobalParams.dealWorkFlowStatus_Edit;
                else
                    objIPR_REP.Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
            }
            dynamic resultSet;
            if (objIPR_REP.IPR_Rep_Code > 0)
                message = "Record Updated Successfully";
            else
                message = "Record Added Successfully";

            bool isValid = objIPR_REP_Service.Save(objIPR_REP, out resultSet);
            if (isValid)
                ClearSession();
            return message;
        }

        private void FillObject(IPR_REP iprREPInstance, FormCollection formCollectionInstance)
        {
            IPR_REP_ATTACHMENTS objMAttachment = objIPR_REP.IPR_REP_ATTACHMENTS.Where(a => a.Flag == "M").FirstOrDefault();
            if (objMAttachment != null)
                listAttachment.Add(objMAttachment);
            if (iprREPInstance.IPR_Rep_Code > 0)
            {
                objIPR_REP = objIPR_REP_Service.GetById(iprREPInstance.IPR_Rep_Code);
                objIPR_REP.EntityState = State.Modified;
                if (objIPR_REP.Workflow_Status == GlobalParams.dealWorkFlowStatus_Approved)
                    objIPR_REP.Version = (Convert.ToInt32(objIPR_REP.Version) + 1).ToString("0000");
            }
            else
            {
                objIPR_REP = new IPR_REP();
                objIPR_REP.EntityState = State.Added;
                objIPR_REP.Creation_Date = DateTime.Now;
                objIPR_REP.Version = "0001";
            }

            objIPR_REP.Created_By = objLoginUser.Users_Code;

            objIPR_REP.Date_Of_Registration = null;
            objIPR_REP.Date_Of_Use = null;

            objIPR_REP.IPR_For = iprREPInstance.IPR_For;
            if (iprREPInstance.IPR_Type_Code > 0)
                objIPR_REP.IPR_Type_Code = iprREPInstance.IPR_Type_Code;
            else
                objIPR_REP.IPR_Type_Code = null;

            objIPR_REP.Trademark = iprREPInstance.Trademark;
            objIPR_REP.Application_No = iprREPInstance.Application_No;
            objIPR_REP.Application_Date = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtApplication_Date"]);

            if (CurrentTab == CurrentTab_International)
            {
                if (iprREPInstance.Country_Code > 0)
                    objIPR_REP.Country_Code = Convert.ToInt32(iprREPInstance.Country_Code);

                objIPR_REP.International_Trademark_Attorney = formCollectionInstance["International_Trademark_Attorney"];
                if (!formCollectionInstance["txtDate_Of_Registration"].Trim().Equals(""))
                    objIPR_REP.Date_Of_Registration = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtDate_Of_Registration"]);
                objIPR_REP.Registration_No = iprREPInstance.Registration_No;
            }
            else
            {
                int countryCode = (new IPR_Country_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y" && x.Is_Domestic_Territory == "Y").Select(s => s.IPR_Country_Code).FirstOrDefault();
                objIPR_REP.Country_Code = Convert.ToInt32(countryCode);
            }


            objIPR_REP.Proposed_Or_Date = iprREPInstance.Proposed_Or_Date;

            if (objIPR_REP.Proposed_Or_Date == "D")
                objIPR_REP.Date_Of_Use = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtDate_Of_Use"]);
            else
                objIPR_REP.Date_Of_Use = null;

            objIPR_REP.Date_Of_Actual_Use = null;
            if (!formCollectionInstance["txtDate_Of_Actual_Use"].Equals(""))
                objIPR_REP.Date_Of_Actual_Use = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtDate_Of_Actual_Use"]);

            objIPR_REP.Application_Status_Code = iprREPInstance.Application_Status_Code;

            if (!string.IsNullOrEmpty(formCollectionInstance["txtRenewed_Until"]))
            {
                objIPR_REP.Renewed_Until = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtRenewed_Until"]);
            }
            objIPR_REP.Applicant_Code = iprREPInstance.Applicant_Code;
            objIPR_REP.Trademark_Attorney = formCollectionInstance["Trademark_Attorney"];
            objIPR_REP.Trademark = iprREPInstance.Trademark;
            objIPR_REP.Comments = (iprREPInstance.Comments != null) ? iprREPInstance.Comments.Replace("\r\n", "\n") : "";
            objIPR_REP.Class_Comments = (iprREPInstance.Class_Comments != null) ? iprREPInstance.Class_Comments.Replace("\r\n", "\n") : "";

            #region --- Channel ---
            ICollection<IPR_Rep_Channel> channelList = new HashSet<IPR_Rep_Channel>();
            if (formCollectionInstance["ddlChannel"] != null)
            {
                string[] arrChannelCodes = formCollectionInstance["ddlChannel"].Split(',');
                foreach (string channelCode in arrChannelCodes)
                {
                    IPR_Rep_Channel objIPR_RC = new IPR_Rep_Channel();
                    objIPR_RC.EntityState = State.Added;
                    objIPR_RC.Channel_Code = Convert.ToInt32(channelCode);
                    channelList.Add(objIPR_RC);
                }
            }
            IEqualityComparer<IPR_Rep_Channel> comparerChannel = new LambdaComparer<IPR_Rep_Channel>((x, y) => x.Channel_Code == y.Channel_Code && x.EntityState != State.Deleted);
            var Deleted_IPR_Rep_Channel = new List<IPR_Rep_Channel>();
            var Updated_IPR_Rep_Channel = new List<IPR_Rep_Channel>();
            var Added_IPR_Rep_Channel = CompareLists<IPR_Rep_Channel>(channelList.ToList<IPR_Rep_Channel>(), objIPR_REP.IPR_Rep_Channel.ToList<IPR_Rep_Channel>(), comparerChannel, ref Deleted_IPR_Rep_Channel, ref Updated_IPR_Rep_Channel);
            Added_IPR_Rep_Channel.ToList<IPR_Rep_Channel>().ForEach(t => objIPR_REP.IPR_Rep_Channel.Add(t));
            Deleted_IPR_Rep_Channel.ToList<IPR_Rep_Channel>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            #region --- Business Unit ---
            ICollection<IPR_Rep_Business_Unit> businessUnitList = new HashSet<IPR_Rep_Business_Unit>();
            if (formCollectionInstance["ddlBusinessUnit"] != null)
            {
                string[] arrBusinessUnitCodes = formCollectionInstance["ddlBusinessUnit"].Split(',');
                foreach (string businessUnitCode in arrBusinessUnitCodes)
                {
                    IPR_Rep_Business_Unit objIPR_RBU = new IPR_Rep_Business_Unit();
                    objIPR_RBU.EntityState = State.Added;
                    objIPR_RBU.Business_Unit_Code = Convert.ToInt32(businessUnitCode);
                    businessUnitList.Add(objIPR_RBU);
                }
            }
            IEqualityComparer<IPR_Rep_Business_Unit> comparerBusinessUnit = new LambdaComparer<IPR_Rep_Business_Unit>((x, y) => x.Business_Unit_Code == y.Business_Unit_Code && x.EntityState != State.Deleted);
            var Deleted_IPR_Rep_Business_Unit = new List<IPR_Rep_Business_Unit>();
            var Updated_IPR_Rep_Business_Unit = new List<IPR_Rep_Business_Unit>();
            var Added_IPR_Rep_Business_Unit = CompareLists<IPR_Rep_Business_Unit>(businessUnitList.ToList<IPR_Rep_Business_Unit>(), objIPR_REP.IPR_Rep_Business_Unit.ToList<IPR_Rep_Business_Unit>(), comparerBusinessUnit, ref Deleted_IPR_Rep_Business_Unit, ref Updated_IPR_Rep_Business_Unit);
            Added_IPR_Rep_Business_Unit.ToList<IPR_Rep_Business_Unit>().ForEach(t => objIPR_REP.IPR_Rep_Business_Unit.Add(t));
            Deleted_IPR_Rep_Business_Unit.ToList<IPR_Rep_Business_Unit>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            #region --- Fill Email Freq Data ---
            string txtFreqId = "txtFreq_";
            ArrayList arrTextBox = new ArrayList();
            for (int i = 1; i <= 6; i++)
            {
                arrTextBox.Add(formCollectionInstance[txtFreqId + i]);
            }


            for (int i = 0; i < arrTextBox.Count; i++)
            {
                string txt = (string)arrTextBox[i];
                if (!string.IsNullOrEmpty(txt))
                {
                    IPR_REP_EMAIL_FREQ objIPR_REP_Email_Freq = new IPR_REP_EMAIL_FREQ();
                    if (objIPR_REP.IPR_REP_EMAIL_FREQ.Count > i)
                        objIPR_REP_Email_Freq = objIPR_REP.IPR_REP_EMAIL_FREQ.ElementAt(i);
                    else
                    {
                        objIPR_REP.IPR_REP_EMAIL_FREQ.Add(objIPR_REP_Email_Freq);
                    }

                    if (objIPR_REP_Email_Freq.IPR_Rep_Email_Freq_Code > 0)
                        objIPR_REP_Email_Freq.EntityState = State.Modified;
                    else
                        objIPR_REP_Email_Freq.EntityState = State.Added;

                    objIPR_REP_Email_Freq.Days = Convert.ToInt32(txt);
                }
            }

            #endregion

            #region--- Fill Attachment Data ---
            IEqualityComparer<IPR_REP_ATTACHMENTS> ComparerRepeat = new LambdaComparer<IPR_REP_ATTACHMENTS>((x, y) => x.System_File_Name == y.System_File_Name && x.EntityState != State.Deleted);
            var Deleted_IPR_REP_ATTACHMENTS = new List<IPR_REP_ATTACHMENTS>();
            var Updated_IPR_REP_ATTACHMENTS = new List<IPR_REP_ATTACHMENTS>();
            var Added_IPR_REP_ATTACHMENTS = CompareLists<IPR_REP_ATTACHMENTS>(listAttachment, objIPR_REP.IPR_REP_ATTACHMENTS.ToList(), ComparerRepeat, ref Deleted_IPR_REP_ATTACHMENTS, ref Updated_IPR_REP_ATTACHMENTS);

            Added_IPR_REP_ATTACHMENTS.ToList<IPR_REP_ATTACHMENTS>().ForEach(t => objIPR_REP.IPR_REP_ATTACHMENTS.Add(t));
            Deleted_IPR_REP_ATTACHMENTS.ToList<IPR_REP_ATTACHMENTS>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            #region --- Fill Class Data ---
            if (objIPR_REP.IPR_REP_CLASS == null)
                objIPR_REP.IPR_REP_CLASS = new HashSet<IPR_REP_CLASS>();


            string[] arrSelectedClassCode = formCollectionInstance["hdnClassCodes"].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            objIPR_REP.IPR_REP_CLASS.ToList<IPR_REP_CLASS>().ForEach(x => x.EntityState = (!arrSelectedClassCode.Contains(x.IPR_Class_Code.ToString())) ? State.Deleted : x.EntityState);

            foreach (string strClassCode in arrSelectedClassCode)
            {
                int IPR_Class_Code = Convert.ToInt32(strClassCode);
                if (IPR_Class_Code > 0)
                {
                    int count = objIPR_REP.IPR_REP_CLASS.Where(w => w.IPR_Class_Code == IPR_Class_Code).Count();
                    if (count == 0)
                    {
                        IPR_REP_CLASS objIPR_REP_CLASS = new IPR_REP_CLASS();
                        objIPR_REP_CLASS.IPR_Class_Code = IPR_Class_Code;
                        objIPR_REP_CLASS.EntityState = State.Added;
                        objIPR_REP.IPR_REP_CLASS.Add(objIPR_REP_CLASS);
                    }
                }
            }

            #endregion
        }

        public string Save(IPR_REP iprREPInstance, FormCollection formCollectionInstance)
        {
            return SaveRecord(iprREPInstance, formCollectionInstance);
        }

        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult, ref List<T> UPResult) where T : class
        {
            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);
            var UpdateResult = FirstList.Except(DeleteResult, comparer);
            var Modified_Result = UpdateResult.Except(AddResult);

            DelResult = DeleteResult.ToList<T>();
            UPResult = Modified_Result.ToList<T>();

            return AddResult.ToList<T>();
        }

        public ActionResult Cancel(string TABNAME)
        {
            ClearSession();
            return RedirectToAction("Index", "IPR_List", new { TABNAME = TABNAME });
        }
    }
}
