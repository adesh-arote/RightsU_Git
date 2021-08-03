using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class IPR_OppBy_AgainstController : BaseController
    {

        #region --- Properties ---
        public int PageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = 1;
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
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
        private int RowIndex
        {
            get
            {
                if (Session["RowIndex"] == null)
                    Session["RowIndex"] = -1;
                return Convert.ToInt32(Session["RowIndex"]);
            }
            set
            {
                Session["RowIndex"] = value;
            }
        }
        private int IPR_Rep_Code
        {
            get
            {
                if (Session["IPR_Rep_Code"] == null)
                    Session["IPR_Rep_Code"] = 0;
                return Convert.ToInt32(Session["IPR_Rep_Code"]);
            }
            set
            {
                Session["IPR_Rep_Code"] = value;
            }
        }
        private string Attachment_Flag
        {
            get
            {
                if (Session["Attachment_Flag"] == null)
                    Session["Attachment_Flag"] = "";
                return Session["Attachment_Flag"].ToString();
            }
            set
            {
                Session["Attachment_Flag"] = value;
            }
        }

        private IPR_Opp objIPR_Opp
        {
            get
            {
                if (Session["objIPR_Opp"] == null)
                    Session["objIPR_Opp"] = new IPR_Opp();
                return (IPR_Opp)Session["objIPR_Opp"];
            }
            set
            {
                Session["objIPR_Opp"] = value;
            }
        }
        private IPR_Opp_Service objIPR_Opp_Service
        {
            get
            {
                if (Session["objIPR_Opp_Service"] == null)
                    Session["objIPR_Opp_Service"] = new IPR_Opp_Service(objLoginEntity.ConnectionStringName);
                return (IPR_Opp_Service)Session["objIPR_Opp_Service"];
            }
            set
            {
                Session["objIPR_Opp_Service"] = value;
            }
        }
        private List<IPR_Opp_Attachment> listAttachment
        {
            get
            {
                if (Session["listOppAttachment"] == null)
                    Session["listOppAttachment"] = new List<IPR_Opp_Attachment>();
                return (List<IPR_Opp_Attachment>)Session["listOppAttachment"];
            }
            set
            {
                Session["listOppAttachment"] = value;
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

        private string CurrentTab
        {
            get
            {
                if (Session["CurrentTab"] == null)
                    Session["CurrentTab"] = "";
                return Session["CurrentTab"].ToString();
            }
            set
            {
                Session["CurrentTab"] = value;
            }
        }

        private const string CurrentTab_OppositionBy = "B";
        private const string CurrentTab_OppositionAgainst = "A";
        private const string CurrentTab_Domestic = "D";
        private const string CurrentTab_International = "I";
        private const string dateFormat = "dd/MM/yyyy";
        #endregion
        //
        // GET: /IPR_OppBy_Against/

        public ActionResult Index()
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            int code = 0;
            if (TempData["QueryString_IPR"] != null)
            {
                obj_Dictionary = TempData["QueryString_IPR"] as Dictionary<string, string>;
                TempData.Keep("QueryString_IPR");
                Mode = obj_Dictionary["MODE"];
                ViewBag.Mode = Mode;
                CurrentTab = obj_Dictionary["Tab"];
                code = Convert.ToInt32(obj_Dictionary["IPR_Opp_Code"]);
            }

            List<string> lstFrq = new List<string>();
            if (code == 0)
            {
                objIPR_Opp = new IPR_Opp();
                for (int i = 0; i < 6; i++)
                {
                    lstFrq.Add("");
                }
                objIPR_Opp.IPR_For = CurrentTab;
                IPR_Rep_Code = 0;
            }
            else
            {

                objIPR_Opp = objIPR_Opp_Service.GetById(code);
                for (int i = 0; i < 6; i++)
                {
                    if (i < objIPR_Opp.IPR_Opp_Email_Freq.Count)
                    {
                        IPR_Opp_Email_Freq objIPR_Opp_Email_Frq = objIPR_Opp.IPR_Opp_Email_Freq.ElementAt(i);
                        if (objIPR_Opp_Email_Frq != null)
                            lstFrq.Add(objIPR_Opp_Email_Frq.Days.ToString());
                    }
                    else
                        lstFrq.Add("");
                }
                listAttachment = objIPR_Opp.IPR_Opp_Attachment.Where(a => a.EntityState != State.Deleted && a.Flag == "G").ToList();
            }

            List<IPR_Opp_Status> lstIprOppStatus = (new IPR_Opp_Status_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y").OrderBy(o => o.Opp_Status).ToList();
            lstIprOppStatus.Insert(0, new IPR_Opp_Status { Opp_Status = "--- Please select ---", IPR_Opp_Status_Code = 0 });
            ViewBag.IRP_Opp_Status = new SelectList(lstIprOppStatus, "IPR_Opp_Status_Code", "Opp_Status", objIPR_Opp.IPR_Opp_Status_Code);

            List<IPR_CLASS> lstIprClass = (new IPR_CLASS_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y" && x.Parent_Class_Code == 0).OrderBy(o => o.Description).ToList();
            lstIprClass.Insert(0, new IPR_CLASS { Description = "--- Please select ---", IPR_Class_Code = 0 });
            ViewBag.IRP_Class = new SelectList(lstIprClass, "IPR_Class_Code", "Description", objIPR_Opp.IPR_Class_Code);

            List<IPR_APP_STATUS> lstIprAppStatus = (new IPR_APP_STATUS_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y").OrderBy(o => o.App_Status).ToList();
            lstIprAppStatus.Insert(0, new IPR_APP_STATUS { App_Status = "--- Please select ---", IPR_App_Status_Code = 0 });
            ViewBag.IRP_App_Status = new SelectList(lstIprAppStatus, "IPR_App_Status_Code", "App_Status", objIPR_Opp.IPR_App_Status_Code);

            ViewBag.Frq_List = lstFrq;
            ViewBag.IPR_Status_History = (new USP_Service(objLoginEntity.ConnectionStringName)).USP_List_IPR_Opp_Status_History(objIPR_Opp.IPR_Opp_Code).ToList();

            if (TempData["RecodLockingCode"] == "" || TempData["RecodLockingCode"] == null)
                ViewBag.RecordLockingCode = 0;
            else
                ViewBag.RecordLockingCode = TempData["RecodLockingCode"];
            TempData.Keep("RecodLockingCode");

            if (Mode == GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.ChannelList = string.Join(", ", objIPR_Opp.IPR_Opp_Channel.Select(s => s.Channel.Channel_Name).ToArray());
                ViewBag.BusinessUnitList = string.Join(", ", objIPR_Opp.IPR_Opp_Business_Unit.Select(s => s.Business_Unit.Business_Unit_Name).ToArray());
            }
            else
            {
                List<RightsU_Entities.Channel> lstChannel = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Channel_Name).ToList();
                var channelCodes = objIPR_Opp.IPR_Opp_Channel.Select(s => s.Channel_Code).ToArray();
                ViewBag.ChannelList = new MultiSelectList(lstChannel, "Channel_Code", "Channel_Name", channelCodes);

                List<Business_Unit> lstBusinessUnit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).OrderBy(o => o.Business_Unit_Name).ToList();
                var businessUnitCodes = objIPR_Opp.IPR_Opp_Business_Unit.Select(s => s.Business_Unit_Code).ToArray();
                ViewBag.BusinessUnitList = new MultiSelectList(lstBusinessUnit, "Business_Unit_Code", "Business_Unit_Name", businessUnitCodes);
            }

            if (Mode != GlobalParams.DEAL_MODE_VIEW)
                return View(objIPR_Opp);
            else
                return View("View", objIPR_Opp);
        }

        public PartialViewResult BindAppGridview(string txtApp_No_Search, bool firstTime = false)
        {
            List<App_Search_GV> list = new List<App_Search_GV>();
            if (!firstTime)
            {
                string searchText = txtApp_No_Search.ToUpper();
                list = new IPR_REP_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.IPR_For == CurrentTab_Domestic && s.IPR_Rep_Code != IPR_Rep_Code
                && (s.Application_No.ToUpper().Contains(searchText) || s.Trademark.ToUpper().Contains(searchText)
                     || s.IPR_TYPE.Type.ToUpper().Contains(searchText))).
                 Select(s => new App_Search_GV()
                 {
                     IPR_Rep_Code = s.IPR_Rep_Code,
                     Application_No = s.Application_No,
                     Trademark = s.Trademark,
                     Type = s.IPR_TYPE.Type
                 }
                 ).ToList();
            }

            if (IPR_Rep_Code > 0)
            {
                IPR_REP objIR = new IPR_REP_Service(objLoginEntity.ConnectionStringName).GetById(IPR_Rep_Code);
                App_Search_GV objApp_Search_GV = new App_Search_GV();
                objApp_Search_GV.IPR_Rep_Code = objIR.IPR_Rep_Code;
                objApp_Search_GV.Application_No = objIR.Application_No;
                objApp_Search_GV.Trademark = objIR.Trademark;
                objApp_Search_GV.Type = objIR.IPR_TYPE.Type;
                list.Insert(0, objApp_Search_GV);
            }
            ViewBag.IPR_Rep_Code = IPR_Rep_Code;
            return PartialView("_List_Application_No", list);
        }

        [HttpPost]
        public ActionResult SaveFile(string hdnAttachment_Flag, string hdnAttachment_RowIndex = "-1", string txt_Description = "")
        {
            string oldSystemFileName = "";
            IPR_Opp_Attachment objIPR_Opp_Attachment = null;
            if (hdnAttachment_Flag == "M")
            {
                objIPR_Opp_Attachment = objIPR_Opp.IPR_Opp_Attachment.Where(x => x.Flag == "M").FirstOrDefault();
                if (objIPR_Opp_Attachment != null)
                    oldSystemFileName = objIPR_Opp_Attachment.System_File_Name;

            }
            else if (hdnAttachment_Flag == "G")
            {
                RowIndex = Convert.ToInt32(hdnAttachment_RowIndex);
                if (RowIndex >= 0)
                    objIPR_Opp_Attachment = listAttachment[RowIndex];
                if (objIPR_Opp_Attachment != null)
                    oldSystemFileName = objIPR_Opp_Attachment.System_File_Name;
            }

            if (objIPR_Opp_Attachment == null)
            {
                objIPR_Opp_Attachment = new IPR_Opp_Attachment();
                objIPR_Opp_Attachment.Flag = hdnAttachment_Flag;
                if (File_Name != string.Empty && System_File_Name != string.Empty)
                    objIPR_Opp.IPR_Opp_Attachment.Add(objIPR_Opp_Attachment);
            }

            if (objIPR_Opp_Attachment.IPR_Opp_Attachment_Code > 0)
                objIPR_Opp_Attachment.EntityState = State.Modified;
            else
                objIPR_Opp_Attachment.EntityState = State.Added;

            if (hdnAttachment_Flag == "G")
                objIPR_Opp_Attachment.Description = txt_Description.Replace("\r\n", "\n");

            string fullPath = Server.MapPath("~") + ConfigurationManager.AppSettings["UploadFilePath"];

            if (File_Name != string.Empty && System_File_Name != string.Empty)
            {
                objIPR_Opp_Attachment.File_Name = File_Name;
                objIPR_Opp_Attachment.System_File_Name = System_File_Name;

                if (System.IO.File.Exists(fullPath + oldSystemFileName))
                    System.IO.File.Delete(fullPath + oldSystemFileName);
            }
            if (hdnAttachment_Flag == "M")
                return Json(File_Name);
            else
            {
                listAttachment = objIPR_Opp.IPR_Opp_Attachment.Where(a => a.EntityState != State.Deleted && a.Flag == "G").ToList();
                return PartialView("_List_IPR_Opp_Attachment", listAttachment);
            }
        }

        public JsonResult GetApplicationProperty(int rep_Code)
        {
            string imagePage = string.Empty;
            bool imageshow = true;
            IPR_Application objApp = new IPR_Application();
            IPR_REP objRep = new IPR_REP_Service(objLoginEntity.ConnectionStringName).GetById(rep_Code);
            IPR_Rep_Code = rep_Code;
            if (objRep != null)
            {
                objApp.Application_No = objRep.Application_No;
                int[] arrClassCodes = objRep.IPR_REP_CLASS.Select(s => (int)s.IPR_CLASS.Parent_Class_Code).Distinct().ToArray();
                objApp.ClassName = string.Join(", ", new IPR_CLASS_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrClassCodes.Contains(s.IPR_Class_Code)).Select(s => s.Description).ToArray());
                objApp.App_Status = objRep.IPR_APP_STATUS.App_Status;
                objApp.Entity = objRep.IPR_ENTITY.Entity;
                objApp.Trademark = objRep.Trademark;
                objApp.Trademark_Attorney = objRep.Trademark_Attorney;
                objApp.Type = objRep.IPR_TYPE.Type;
                IPR_REP_ATTACHMENTS objIPR_REP_ATTACHMENTS = objRep.IPR_REP_ATTACHMENTS.Where(x => x.Flag == "M").FirstOrDefault();
                if (objIPR_REP_ATTACHMENTS != null)
                {
                    //string folderPath = "\\" + ConfigurationManager.AppSettings["UploadFilePath"];
                    //objApp.ImageUrl = Url.Content(folderPath + objIPR_REP_ATTACHMENTS.System_File_Name);
                   // string folderPath = ConfigurationManager.AppSettings["UploadFilePath"];
                    string folderPath = ConfigurationManager.AppSettings["UploadFilePath"];
                    string fullPath = folderPath + objIPR_REP_ATTACHMENTS.System_File_Name;
                    objApp.ImageUrl = fullPath;
                    imagePage = fullPath;
                    //imageshow = true;
                    imageshow = checkImage(objIPR_REP_ATTACHMENTS.System_File_Name);
                    if (!imageshow)
                        objApp.ImageUrl = "";
                }
                else
                {
                    //string folderPath = "~\\Images\\";
                    //objApp.ImageUrl = Url.Content(folderPath + "NoImageFound.jpg");
                    objApp.ImageUrl = "";
                }
                ViewBag.imagePage = imagePage;
                ViewBag.ImageShow = imageshow;

            }

            return Json(objApp);
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
        [HttpPost]
        public void UploadAttachment()
        {
            foreach (string file in Request.Files)
            {
                HttpPostedFileBase fileContent = Request.Files[file];
                File_Name = fileContent.FileName;
                System_File_Name = DateTime.Now.Ticks + "~" + fileContent.FileName.Replace(" ", "_");
                fileContent.SaveAs(Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"] + System_File_Name);
            }
        }

        public ActionResult DeleteAttachment(int row_index)
        {
            IPR_Opp_Attachment objIPR_Opp_Attachment = listAttachment[row_index];
            objIPR_Opp_Attachment.EntityState = State.Deleted;
            if (System.IO.File.Exists(Server.MapPath("~") + ConfigurationManager.AppSettings["UploadFilePath"] + objIPR_Opp_Attachment.System_File_Name))
                System.IO.File.Exists(Server.MapPath("~") + ConfigurationManager.AppSettings["UploadFilePath"] + objIPR_Opp_Attachment.System_File_Name);
            listAttachment = objIPR_Opp.IPR_Opp_Attachment.Where(a => a.EntityState != State.Deleted && a.Flag == "G").ToList();
            return PartialView("_List_IPR_Opp_Attachment", listAttachment);
        }
        public JsonResult checkDownloadFile(string For, string systemFileName = "")
        {
            string str = "";
            string path = string.Empty;
            //  string fullPath = Server.MapPath("~") + ConfigurationManager.AppSettings["UploadFilePath"];
            string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]; ;

            if (For == "M")
            {
                IPR_Opp_Attachment objIPR_Opp_Attachment = objIPR_Opp.IPR_Opp_Attachment.Where(x => x.Flag == "M").FirstOrDefault();
                systemFileName = objIPR_Opp_Attachment.System_File_Name;
            }
            path = fullPath + systemFileName;
            Dictionary<string, object> obj = new Dictionary<string, object>();


            FileInfo file = new FileInfo(path);
            if (file.Exists)
            {
                obj.Add("path", path);
                obj.Add("systemFileName", systemFileName);
            }
            else
            {
                obj.Add("path", "");
                obj.Add("systemFileName", "");
            }
            return Json(obj);
        }

        public void DownloadFile(string systemFileName = "", string For = "")
        {
            if (systemFileName != "")
            {
                string path = string.Empty;
                //string fullPath = Server.MapPath("~") + ConfigurationManager.AppSettings["UploadFilePath"];
                string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]; ;

                if (For == "M")
                {
                    IPR_Opp_Attachment objIPR_Opp_Attachment = objIPR_Opp.IPR_Opp_Attachment.Where(x => x.Flag == "M").FirstOrDefault();
                    systemFileName = objIPR_Opp_Attachment.System_File_Name;
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
        }
        private string SaveRecord(IPR_Opp iprOppInstance, FormCollection formCollectionInstance)
        {
            bool isSubmit = Convert.ToBoolean(formCollectionInstance["hdnIsSubmit"]);
            string message = string.Empty;
            FillObject(iprOppInstance, formCollectionInstance);
            if (isSubmit)
            {
                objIPR_Opp.Workflow_Status = GlobalParams.dealWorkFlowStatus_Approved;
            }
            else
            {
                if (objIPR_Opp.IPR_Opp_Code > 0)
                    objIPR_Opp.Workflow_Status = GlobalParams.dealWorkFlowStatus_Edit;
                else
                    objIPR_Opp.Workflow_Status = GlobalParams.dealWorkFlowStatus_New;
            }
            dynamic resultSet;
            if (objIPR_Opp.IPR_Opp_Code > 0)
                message = "Record Updated Successfully";
            else
                message = "Record Added Successfully";

            bool isValid = objIPR_Opp_Service.Save(objIPR_Opp, out resultSet);
            if (isValid)
                ClearSession();

            if (!isValid)
                return resultSet;
            return message;
        }

        private void FillObject(IPR_Opp iprOppInstance, FormCollection formCollectionInstance)
        {
            IPR_Opp_Attachment objMAttachment = objIPR_Opp.IPR_Opp_Attachment.Where(a => a.Flag == "M").FirstOrDefault();
            if (objMAttachment != null)
                listAttachment.Add(objMAttachment);
            if (iprOppInstance.IPR_Opp_Code > 0)
            {
                objIPR_Opp = objIPR_Opp_Service.GetById(iprOppInstance.IPR_Opp_Code);
                objIPR_Opp.EntityState = State.Modified;
                if (objIPR_Opp.Workflow_Status == GlobalParams.dealWorkFlowStatus_Approved)
                    objIPR_Opp.Version = (Convert.ToInt32(objIPR_Opp.Version) + 1).ToString("0000");


            }
            else
            {
                objIPR_Opp = new IPR_Opp();
                objIPR_Opp.EntityState = State.Added;
                objIPR_Opp.Creation_Date = DateTime.Now;
                objIPR_Opp.Version = "0001";
            }

            objIPR_Opp.Created_By = objLoginUser.Users_Code;
            objIPR_Opp.IPR_For = iprOppInstance.IPR_For;
            objIPR_Opp.Opp_No = iprOppInstance.Opp_No;
            objIPR_Opp.IPR_Rep_Code = IPR_Rep_Code;
            objIPR_Opp.Party_Name = iprOppInstance.Party_Name;
            objIPR_Opp.Trademark = iprOppInstance.Trademark;
            objIPR_Opp.Application_No = iprOppInstance.Application_No;

            if (iprOppInstance.IPR_Opp_Status_Code > 0)
                objIPR_Opp.IPR_Opp_Status_Code = iprOppInstance.IPR_Opp_Status_Code;
            else
                objIPR_Opp.IPR_Opp_Status_Code = null;

            if (iprOppInstance.IPR_Class_Code > 0)
                objIPR_Opp.IPR_Class_Code = iprOppInstance.IPR_Class_Code;
            else
                objIPR_Opp.IPR_Class_Code = null;

            if (iprOppInstance.IPR_App_Status_Code > 0)
                objIPR_Opp.IPR_App_Status_Code = iprOppInstance.IPR_App_Status_Code;
            else
                objIPR_Opp.IPR_App_Status_Code = null;

            string txtFreqId = "";

            objIPR_Opp.Publication_Date = null;
            objIPR_Opp.Date_Opposition_Notice = null;
            objIPR_Opp.Date_Counter_Statement = null;
            objIPR_Opp.Deadline_Evidence_UR50 = null;
            objIPR_Opp.Date_Evidence_UR50 = null;
            objIPR_Opp.Date_Evidence_UR51 = null;
            objIPR_Opp.Deadline_Rebuttal_UR52 = null;
            objIPR_Opp.Date_Rebuttal_UR52 = null;
            objIPR_Opp.Deadline_Counter_Statement = null;
            objIPR_Opp.Deadline_Evidence_UR51 = null;
            objIPR_Opp.Deadline_Opposition_Notice = null;
            objIPR_Opp.Order_Date = null;
            if (objIPR_Opp.IPR_For == CurrentTab_OppositionBy) //(hdnCurrentTab.Value == CurrentTab_OppositionBy)
            {
                objIPR_Opp.Journal_No = formCollectionInstance["txtBy_JournalNo"];
                objIPR_Opp.Page_No = formCollectionInstance["txtBy_PageNo"];
                txtFreqId = "txtBy_Freq";

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_PublicationDate"]))
                    objIPR_Opp.Publication_Date = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_PublicationDate"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DateOppositionNotice"]))
                    objIPR_Opp.Date_Opposition_Notice = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DateOppositionNotice"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DateCounterStatement"]))
                    objIPR_Opp.Date_Counter_Statement = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DateCounterStatement"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DeadlineEvidenceUR50"]))
                    objIPR_Opp.Deadline_Evidence_UR50 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DeadlineEvidenceUR50"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DateEvidenceUR50"]))
                    objIPR_Opp.Date_Evidence_UR50 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DateEvidenceUR50"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DateEvidenceUR51"]))
                    objIPR_Opp.Date_Evidence_UR51 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DateEvidenceUR51"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DeadlineRebuttalUR52"]))
                    objIPR_Opp.Deadline_Rebuttal_UR52 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DeadlineRebuttalUR52"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DateRebuttalUR52"]))
                    objIPR_Opp.Date_Rebuttal_UR52 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DateRebuttalUR52"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DeadlineCounterStatement"]))
                    objIPR_Opp.Deadline_Counter_Statement = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DeadlineCounterStatement"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtBy_DeadlineEvidenceUR51"]))
                    objIPR_Opp.Deadline_Evidence_UR51 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtBy_DeadlineEvidenceUR51"]);
            }
            if (objIPR_Opp.IPR_For == CurrentTab_OppositionAgainst)// (hdnCurrentTab.Value == CurrentTab_OppositionAgainst)
            {
                objIPR_Opp.Journal_No = formCollectionInstance["txtAgainst_JournalNo"];
                objIPR_Opp.Page_No = formCollectionInstance["txtAgainst_PageNo"];
                txtFreqId = "txtAgainst_Freq";

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_PublicationDate"]))
                    objIPR_Opp.Publication_Date = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_PublicationDate"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DateOppositionNotice"]))
                    objIPR_Opp.Date_Opposition_Notice = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DateOppositionNotice"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DeadlineCounterStatement"]))
                    objIPR_Opp.Deadline_Counter_Statement = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DeadlineCounterStatement"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DateCounterStatement"]))
                    objIPR_Opp.Date_Counter_Statement = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DateCounterStatement"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DateEvidenceUR50"]))
                    objIPR_Opp.Date_Evidence_UR50 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DateEvidenceUR50"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DeadlineEvidenceUR51"]))
                    objIPR_Opp.Deadline_Evidence_UR51 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DeadlineEvidenceUR51"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DateEvidenceUR51"]))
                    objIPR_Opp.Date_Evidence_UR51 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DateEvidenceUR51"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DateRebuttalUR52"]))
                    objIPR_Opp.Date_Rebuttal_UR52 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DateRebuttalUR52"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DeadlineOppositionNotice"]))
                    objIPR_Opp.Deadline_Opposition_Notice = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DeadlineOppositionNotice"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DeadlineEvidenceUR50"]))
                    objIPR_Opp.Deadline_Evidence_UR50 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DeadlineEvidenceUR50"]);

                if (!string.IsNullOrEmpty(formCollectionInstance["txtAgainst_DeadlineRebuttalUR52"]))
                    objIPR_Opp.Deadline_Rebuttal_UR52 = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtAgainst_DeadlineRebuttalUR52"]);
            }

            ArrayList arrTextBox = new ArrayList();
            for (int i = 1; i <= 6; i++)
            {
                arrTextBox.Add(formCollectionInstance[txtFreqId + i]);
            }

            if (!string.IsNullOrEmpty(formCollectionInstance["txtOrder_Date"]))
                objIPR_Opp.Order_Date = GlobalUtil.GetFormatedDateTimeNew(formCollectionInstance["txtOrder_Date"]);
            if (!string.IsNullOrEmpty(formCollectionInstance["txtOutcomes"]))
                objIPR_Opp.Outcomes = formCollectionInstance["txtOutcomes"].Replace("\r\n", "\n");

            if (!string.IsNullOrEmpty(formCollectionInstance["txtComments"].Replace("\r\n", "\n")))
                objIPR_Opp.Comments = formCollectionInstance["txtComments"].Replace("\r\n", "\n");

            #region --- Channel ---
            ICollection<IPR_Opp_Channel> channelList = new HashSet<IPR_Opp_Channel>();
            if (formCollectionInstance["ddlChannel"] != null)
            {
                string[] arrChannelCodes = formCollectionInstance["ddlChannel"].Split(',');
                foreach (string channelCode in arrChannelCodes)
                {
                    IPR_Opp_Channel objIPR_OC = new IPR_Opp_Channel();
                    objIPR_OC.EntityState = State.Added;
                    objIPR_OC.Channel_Code = Convert.ToInt32(channelCode);
                    channelList.Add(objIPR_OC);
                }
            }
            IEqualityComparer<IPR_Opp_Channel> comparerChannel = new LambdaComparer<IPR_Opp_Channel>((x, y) => x.Channel_Code == y.Channel_Code && x.EntityState != State.Deleted);
            var Deleted_IPR_Opp_Channel = new List<IPR_Opp_Channel>();
            var Updated_IPR_Opp_Channel = new List<IPR_Opp_Channel>();
            var Added_IPR_Opp_Channel = CompareLists<IPR_Opp_Channel>(channelList.ToList<IPR_Opp_Channel>(), objIPR_Opp.IPR_Opp_Channel.ToList<IPR_Opp_Channel>(), comparerChannel, ref Deleted_IPR_Opp_Channel, ref Updated_IPR_Opp_Channel);
            Added_IPR_Opp_Channel.ToList<IPR_Opp_Channel>().ForEach(t => objIPR_Opp.IPR_Opp_Channel.Add(t));
            Deleted_IPR_Opp_Channel.ToList<IPR_Opp_Channel>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            #region --- Business Unit ---
            ICollection<IPR_Opp_Business_Unit> businessUnitList = new HashSet<IPR_Opp_Business_Unit>();
            if (formCollectionInstance["ddlBusinessUnit"] != null)
            {
                string[] arrBusinessUnitCodes = formCollectionInstance["ddlBusinessUnit"].Split(',');
                foreach (string businessUnitCode in arrBusinessUnitCodes)
                {
                    IPR_Opp_Business_Unit objIPR_OBU = new IPR_Opp_Business_Unit();
                    objIPR_OBU.EntityState = State.Added;
                    objIPR_OBU.Business_Unit_Code = Convert.ToInt32(businessUnitCode);
                    businessUnitList.Add(objIPR_OBU);
                }
            }
            IEqualityComparer<IPR_Opp_Business_Unit> comparerBusinessUnit = new LambdaComparer<IPR_Opp_Business_Unit>((x, y) => x.Business_Unit_Code == y.Business_Unit_Code && x.EntityState != State.Deleted);
            var Deleted_IPR_Opp_Business_Unit = new List<IPR_Opp_Business_Unit>();
            var Updated_IPR_Opp_Business_Unit = new List<IPR_Opp_Business_Unit>();
            var Added_IPR_Opp_Business_Unit = CompareLists<IPR_Opp_Business_Unit>(businessUnitList.ToList<IPR_Opp_Business_Unit>(), objIPR_Opp.IPR_Opp_Business_Unit.ToList<IPR_Opp_Business_Unit>(), comparerBusinessUnit, ref Deleted_IPR_Opp_Business_Unit, ref Updated_IPR_Opp_Business_Unit);
            Added_IPR_Opp_Business_Unit.ToList<IPR_Opp_Business_Unit>().ForEach(t => objIPR_Opp.IPR_Opp_Business_Unit.Add(t));
            Deleted_IPR_Opp_Business_Unit.ToList<IPR_Opp_Business_Unit>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            #region --- Fill Email Freq Data ---
            for (int i = 0; i < arrTextBox.Count; i++)
            {
                string txt = (string)arrTextBox[i];
                if (!string.IsNullOrEmpty(txt))
                {
                    IPR_Opp_Email_Freq objIPR_Opp_Email_Freq = new IPR_Opp_Email_Freq();
                    if (objIPR_Opp.IPR_Opp_Email_Freq.Count > i)
                        objIPR_Opp_Email_Freq = objIPR_Opp.IPR_Opp_Email_Freq.ElementAt(i);
                    else
                    {
                        objIPR_Opp.IPR_Opp_Email_Freq.Add(objIPR_Opp_Email_Freq);
                    }

                    if (objIPR_Opp_Email_Freq.IPR_Opp_Email_Freq_Code > 0)
                        objIPR_Opp_Email_Freq.EntityState = State.Modified;
                    else
                        objIPR_Opp_Email_Freq.EntityState = State.Added;

                    objIPR_Opp_Email_Freq.Days = Convert.ToInt32(txt);
                }
            }

            #endregion

            #region Fill Attachment Data
            IEqualityComparer<IPR_Opp_Attachment> ComparerRepeat = new LambdaComparer<IPR_Opp_Attachment>((x, y) => x.System_File_Name == y.System_File_Name && x.EntityState != State.Deleted);
            var Deleted_IPR_Opp_Attachment = new List<IPR_Opp_Attachment>();
            var Updated_IPR_Opp_Attachment = new List<IPR_Opp_Attachment>();
            var Added_IPR_Opp_Attachment = CompareLists<IPR_Opp_Attachment>(listAttachment, objIPR_Opp.IPR_Opp_Attachment.ToList(), ComparerRepeat, ref Deleted_IPR_Opp_Attachment, ref Updated_IPR_Opp_Attachment);

            Added_IPR_Opp_Attachment.ToList<IPR_Opp_Attachment>().ForEach(t => objIPR_Opp.IPR_Opp_Attachment.Add(t));
            Deleted_IPR_Opp_Attachment.ToList<IPR_Opp_Attachment>().ForEach(t => t.EntityState = State.Deleted);
            #endregion
        }

        public string Save(IPR_Opp iprOppInstance, FormCollection formCollectionInstance)
        {
            if(Mode == "C")
            {
                iprOppInstance.IPR_Opp_Code = 0;
            }
            return SaveRecord(iprOppInstance, formCollectionInstance);
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

        private void ClearSession()
        {
            objIPR_Opp_Service = null;
            objIPR_Opp = null;
            IPR_Rep_Code = 0;
            listAttachment = null;
        }
    }

    public class App_Search_GV
    {
        public int IPR_Rep_Code { get; set; }
        public string Application_No { get; set; }
        public string Trademark { get; set; }
        public string Type { get; set; }
    }

    public class IPR_Application
    {
        public string Application_No { get; set; }
        public string Entity { get; set; }
        public string Trademark { get; set; }
        public string ClassName { get; set; }
        public string App_Status { get; set; }
        public string Trademark_Attorney { get; set; }
        public string Type { get; set; }
        public string ImageUrl { get; set; }
    }
}
