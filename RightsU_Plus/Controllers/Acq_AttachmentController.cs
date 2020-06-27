using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;

namespace RightsU_Plus.Controllers
{
    public class Acq_AttachmentController : BaseController
    {
        #region Properties

        public int PageNo
        {
            get
            {
                if (ViewBag.PageNo == null)
                    ViewBag.PageNo = 1;
                return (int)ViewBag.PageNo;
            }
            set { ViewBag.PageNo = value; }
        }

        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value; }
        }

        public string Deal_Type_Condition
        {
            get
            {
                if (Session["Deal_Type_Condition"] == null)
                    Session["Deal_Type_Condition"] = "";
                return (string)Session["Deal_Type_Condition"];
            }
            set { Session["Deal_Type_Condition"] = value; }
        }

        public Acq_Deal objDeal
        {
            get
            {
                if (Session["objDeal"] == null)
                    Session["objDeal"] = new Acq_Deal();
                return (Acq_Deal)Session["objDeal"];
            }
            set { Session["objDeal"] = value; }
        }
        public string ImageTime
        {
            get
            {
                if (Session["ImageTime"] == null)
                    Session["ImageTime"] = string.Empty;
                return (string)Session["ImageTime"];
            }
            set { Session["ImageTime"] = value; }
        }
        #endregion

        #region Actions

        public PartialViewResult Index(string Message = "")
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            ViewBag.CommandName = "";
            ViewBag.Message = Message;
            int Deal_Code = objDeal_Schema.Deal_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_Attachment;
            objDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(Deal_Code);
            Session["objDeal"] = objDeal;
            int Deal_Type_Code = Convert.ToInt32(objDeal.Deal_Type_Code);
            Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(Deal_Type_Code);
            ViewBag.PageMode = objDeal_Schema.Mode;
            ViewBag.Approver_Remark = objDeal_Schema.Approver_Remark;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;

            //return View("Index", objDeal.Acq_Deal_Attachment.ToList());
            Session["FileName"] = "";
            Session["FileName"] = "acq_Attachments";
            return PartialView("~/Views/Acq_Deal/_Acq_Attachment.cshtml", objDeal.Acq_Deal_Attachment.ToList());
        }

        public PartialViewResult Create(string isAdd, int txtPageSize, int pageNo)
        {
            ViewBag.Acq_Deal_Attachment_Code = 0;
            if (isAdd == "1")
            {
                ViewBag.CommandName = "Add";
            }
            else
            {
                ViewBag.CommandName = "";
            }

            BindTitle("");
            BindDocument(0);
            return BindGridAcqAttachment(txtPageSize, pageNo);
        }

        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            ClearSession();
            objDeal_Schema = null;
            //return RedirectToAction("Index", "Acq_List", new { Page_No = pageNo, ReleaseRecord = "Y" });
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                return RedirectToAction("Index", "Acq_List");
            }
        }

        public PartialViewResult Edit(int Acq_Deal_Attachment_Code, int txtPageSize, int pageNo)
        {
            ViewBag.Acq_Deal_Attachment_Code = Acq_Deal_Attachment_Code;
            Acq_Deal_Attachment_Service objAcq_Deal_Attachment_Service = new Acq_Deal_Attachment_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Attachment objAcq_Acq_Deal_Attachment = objAcq_Deal_Attachment_Service.GetById(Acq_Deal_Attachment_Code);
            ViewBag.CommandName = "Edit";
            TempData["Attachment_File_Name"] = objAcq_Acq_Deal_Attachment.Attachment_File_Name;
            string titleCodes = "";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
            {
                //var code = (from Acq_Deal_Attachment obj in objDeal.Acq_Deal_Attachment
                //            where obj.Acq_Deal_Attachment_Code == Acq_Deal_Attachment_Code
                //            select obj.Title_Code).FirstOrDefault();
                //if (code != null)
                //{
                //    titleCodes = (from Acq_Deal_Movie obj in objDeal.Acq_Deal_Movie
                //                  where obj.Title_Code == code
                //                  select Convert.ToString(obj.Acq_Deal_Movie_Code)).FirstOrDefault();
                //}
                titleCodes = string.Join(",", objDeal.Acq_Deal_Movie.Where(x => objAcq_Acq_Deal_Attachment.Title_Code == x.Title_Code && objAcq_Acq_Deal_Attachment.Episode_From == x.Episode_Starts_From && objAcq_Acq_Deal_Attachment.Episode_To == x.Episode_End_To).Select(x => x.Acq_Deal_Movie_Code));
            }
            else
            {
                titleCodes = string.Join(", ", objAcq_Acq_Deal_Attachment.Title_Code);
            }

            BindTitle(titleCodes);
            BindDocument(Convert.ToInt32(objAcq_Acq_Deal_Attachment.Document_Type_Code));
            return BindGridAcqAttachment(txtPageSize, pageNo);
        }

        public PartialViewResult Delete(int Acq_Deal_Attachment_Code, int txtPageSize, int pageNo)
        {
            if (Acq_Deal_Attachment_Code > 0)
            {
                Acq_Deal_Attachment_Service objAcq_Deal_Attachment_Service = new Acq_Deal_Attachment_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal_Attachment objAcq_Deal_Attachment = objAcq_Deal_Attachment_Service.GetById(Acq_Deal_Attachment_Code);
                objAcq_Deal_Attachment.EntityState = State.Deleted;
                dynamic resultSet;
                objAcq_Deal_Attachment_Service.Save(objAcq_Deal_Attachment, out resultSet);
            }
            return BindGridAcqAttachment(txtPageSize, pageNo);
        }

        public JsonResult DownloadFile(string Attachment_File_Name, string System_File_Name)
        {
            string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"];
            string path = fullPath + "/" + System_File_Name;
            FileInfo file = new FileInfo(path);
            FileInfo file1 = new FileInfo(path);
            if (file.Exists)
            {
                var obj = new
                {
                    path = path,
                    attachFileName = Attachment_File_Name
                };
                return Json(obj);
            }
            else
            {
                var obj = new
                {
                    path = "",
                    attachFileName = Attachment_File_Name
                };
                return Json(obj);
            }
        }
        //public void download(string Attachment_File_Name, string System_File_Name)
        public void download(int Attachment_Code)
        {
            string Attachment_File_Name = new Acq_Deal_Attachment_Service(objLoginEntity.ConnectionStringName).GetById(Attachment_Code).Attachment_File_Name;
            string System_File_Name = new Acq_Deal_Attachment_Service(objLoginEntity.ConnectionStringName).GetById(Attachment_Code).System_File_Name;
            string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"];
            string path = fullPath + "/" + System_File_Name;
            FileInfo file = new FileInfo(path);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            if (file.Exists)
            {
                byte[] bts = System.IO.File.ReadAllBytes(path);
                Response.Clear();
                Response.ClearHeaders();
                Response.AddHeader("Content-Type", "Application/octet-stream");
                Response.AddHeader("Content-Length", bts.Length.ToString());
                Response.AddHeader("Content-Disposition", "attachment;   filename=" + System_File_Name.Split('~')[1]);
                Response.BinaryWrite(bts);
                Response.Flush();
                // Response.End();
                //  return RedirectToAction("Index", new { Message = "Attachment File downloaded successfully" });
            }
        }
        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }

        [HttpPost]
        public PartialViewResult BindGridAcqAttachment(int txtPageSize, int page_No)
        {
            int pageSize;
            if (txtPageSize != null)
            {
                objDeal_Schema.Cost_PageSize = Convert.ToInt32(txtPageSize);
                pageSize = Convert.ToInt32(txtPageSize);
            }
            else
            {
                objDeal_Schema.Cost_PageSize = 50;
                pageSize = 50;
            }
            PageNo = page_No + 1;
            ICollection<Acq_Deal_Attachment> lst_Acq_Deal_Attachment;
            Acq_Deal_Attachment_Service objAcq_Deal_Attachment_Service = new Acq_Deal_Attachment_Service(objLoginEntity.ConnectionStringName);
            if (PageNo == 1)
                lst_Acq_Deal_Attachment = objAcq_Deal_Attachment_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Attachment_Code).Take(pageSize).ToList();
            else
            {
                lst_Acq_Deal_Attachment = objAcq_Deal_Attachment_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Attachment_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lst_Acq_Deal_Attachment.Count == 0)
                {
                    if (PageNo != 1)
                    {
                        objDeal_Schema.Cost_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst_Acq_Deal_Attachment = objAcq_Deal_Attachment_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).OrderBy(r => r.Acq_Deal_Attachment_Code).Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }

            ViewBag.RecordCount = objAcq_Deal_Attachment_Service.SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Count();
            //ViewBag.RecordCount = lst_Acq_Deal_Attachment.Count();
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = txtPageSize;
            ViewBag.PageMode = objDeal_Schema.Mode;
            ViewBag.Deal_Type_Condition = objDeal_Schema.Deal_Type_Condition;

            return PartialView("~/Views/Acq_Deal/_List_Attachment.cshtml", lst_Acq_Deal_Attachment);
        }

        #endregion

        #region Methods

        private void BindDocument(int Document_Type_Code)
        {
            if (Document_Type_Code == 0)
            {
                List<SelectListItem> lstDocumentType = new SelectList(new Document_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Document_Type_Code", "Document_Type_Name").ToList();//.OrderBy("Title_Name");
                lstDocumentType.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
                ViewBag.lstDocumentType = lstDocumentType;
            }
            else
            {
                List<SelectListItem> lstDocumentType = new SelectList(new Document_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Document_Type_Code", "Document_Type_Name", Document_Type_Code).ToList();
                lstDocumentType.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect});
                ViewBag.lstDocumentType = lstDocumentType;
            }
        }

        private void ClearSession()
        {
            objDeal = null;
        }

        private void BindTitle(string Title_Code)
        {
            List<SelectListItem> lst = new SelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Bind_Title(objDeal.Acq_Deal_Code, objDeal_Schema.Deal_Type_Code, "A").ToList(), "Title_Code", "Title_Name", Title_Code).ToList();
            lst.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.AllTitles });
            ViewBag.lstTitle = lst;
            ViewBag.lstTitle = lst;
        }

        public string Save(int Acq_Deal_Attachment_Code, int Title_Code, string Attachment_Title, int Document_Type_Code, string Attachment_File_Name)//Acq_Deal_Attachment objAcq_Deal_Attachment, HttpPostedFileBase Attachment_File_Name, string Title_Name
        {
            string ReturnMessage = "Y";
            if (Acq_Deal_Attachment_Code == 0)
                {
                    Acq_Deal_Attachment objAcq_Deal_Attachment = new Acq_Deal_Attachment();
                    Acq_Deal_Attachment_Service objAcq_Deal_Attachment_Service = new Acq_Deal_Attachment_Service(objLoginEntity.ConnectionStringName);
                    objAcq_Deal_Attachment.Acq_Deal_Code = objDeal.Acq_Deal_Code;

                    //For Title code
                    if (Title_Code != 0)
                    {
                        if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                        {
                            Acq_Deal_Movie objTitle_List = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).GetById(Title_Code);
                            objAcq_Deal_Attachment.Title_Code = objTitle_List.Title_Code;
                            objAcq_Deal_Attachment.Episode_From = objTitle_List.Episode_Starts_From;
                            objAcq_Deal_Attachment.Episode_To = objTitle_List.Episode_End_To;
                        }
                        else
                        {
                            objAcq_Deal_Attachment.Episode_From = 1;
                            objAcq_Deal_Attachment.Episode_To = 1;
                            objAcq_Deal_Attachment.Title_Code = Title_Code;
                        }
                    }
                    else
                    {
                        objAcq_Deal_Attachment.Episode_From = null;
                        objAcq_Deal_Attachment.Episode_To = null;
                        objAcq_Deal_Attachment.Title_Code = null;
                    }
                    //
                    objAcq_Deal_Attachment.Attachment_Title = Attachment_Title;
                    objAcq_Deal_Attachment.Document_Type_Code = Document_Type_Code;

                    objAcq_Deal_Attachment.Attachment_File_Name = Attachment_File_Name;
                    objAcq_Deal_Attachment.System_File_Name = (ImageTime == ""? DateTime.Now.Ticks.ToString() : ImageTime)  + "~" + objAcq_Deal_Attachment.Attachment_File_Name.Replace(" ", "_").Replace(",","_").Replace("-","_");
                    objAcq_Deal_Attachment.EntityState = State.Added;
                    dynamic resultSet;
                    objAcq_Deal_Attachment_Service.Save(objAcq_Deal_Attachment, out resultSet);
                }
                else
                {
                    Acq_Deal_Attachment_Service objAcq_Deal_Attachment_Service = new Acq_Deal_Attachment_Service(objLoginEntity.ConnectionStringName);
                    Acq_Deal_Attachment obj = objAcq_Deal_Attachment_Service.GetById(Acq_Deal_Attachment_Code);
                    if (obj != null)
                    {
                        if (Title_Code != 0)
                        {
                            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                            {
                                Acq_Deal_Movie objTitle_List = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).GetById(Title_Code);
                                obj.Title_Code = objTitle_List.Title_Code;
                                obj.Episode_From = objTitle_List.Episode_Starts_From;
                                obj.Episode_To = objTitle_List.Episode_End_To;
                            }
                            else
                            {
                                obj.Title_Code = Title_Code;
                                obj.Episode_From = 1;
                                obj.Episode_To = 1;
                            }
                        }
                        else
                        {
                            obj.Episode_From = null;
                            obj.Episode_To = null;
                            obj.Title_Code = null;
                        }
                        obj.Attachment_Title = Attachment_Title;
                        obj.Document_Type_Code = Document_Type_Code;
                        obj.Acq_Deal_Code = objDeal.Acq_Deal_Code;

                        if (Attachment_File_Name != "")
                        {
                            if (Attachment_File_Name.Trim() != obj.Attachment_File_Name)
                            {
                                obj.Attachment_File_Name = Attachment_File_Name.Trim();
                                obj.System_File_Name = (ImageTime == "" ? DateTime.Now.Ticks.ToString() : ImageTime) + "~" + Attachment_File_Name.Replace(" ", "_").Replace(",","_").Replace("-","_");
                            }
                        }
                        obj.EntityState = State.Modified;
                        dynamic resultSet;
                        objAcq_Deal_Attachment_Service.Save(obj, out resultSet);
                    }
                }
            return ReturnMessage;
        }

        public string SaveFile()
        {
            string ReturnMessage = "Y";
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var PostedFile = System.Web.HttpContext.Current.Request.Files["InputFile"];
                string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"];

                string fname = System.IO.Path.GetFileName(PostedFile.FileName.ToString());
                string  strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + fname.Replace(" ", "_").Replace(",","_").Replace("-","_");
                ImageTime = strActualFileNameWithDate.Split('~').FirstOrDefault();
                    string fullpathname = fullPath + strActualFileNameWithDate; ;
                if (fullpathname != "" || fullpathname != null)
                {
                    if (!Directory.Exists(fullPath))
                        Directory.CreateDirectory(fullPath);
                    //  PostedFile.SaveAs(fullPath + "\\" + PostedFile.FileName);
                    PostedFile.SaveAs(fullpathname);
                }
                //if (fname != "" || fname != null)
                //{
                //    if (!Directory.Exists(fullPath))
                //        Directory.CreateDirectory(fullPath);
                //    //  PostedFile.SaveAs(fullPath + "\\" + PostedFile.FileName);
                //    PostedFile.SaveAs(fullPath + "\\" + fname);
                //}
                return ReturnMessage;
            }
            else
                return ReturnMessage = "N";
        }

        #endregion
    }
}
