﻿using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class LoadSheetController : BaseController
    {
        private List<USPAL_GetLoadsheetList_Result> lstAL_LoadSheet
        {
            get
            {
                if (Session["lstAL_Load_Sheet"] == null)
                    Session["lstAL_Load_Sheet"] = new List<USPAL_GetLoadsheetList_Result>();
                return (List<USPAL_GetLoadsheetList_Result>)Session["lstAL_Load_Sheet"];
            }
            set { Session["lstAL_Load_Sheet"] = value; }
        }

        private List<USPAL_GetLoadsheetList_Result> lstAL_Load_Sheet_Searched
        {
            get
            {
                if (Session["lstAL_Load_Sheet_Searched"] == null)
                    Session["lstAL_Load_Sheet_Searched"] = new List<USPAL_GetLoadsheetList_Result>();
                return (List<USPAL_GetLoadsheetList_Result>)Session["lstAL_Load_Sheet_Searched"];
            }
            set { Session["lstAL_Load_Sheet_Searched"] = value; }
        }

        List<USPAL_GetBookingsheetDataForLoadsheet_Result> lstBookingsheetDataForLoadsheet_Searched
        {
            get
            {
                if (Session["lstBookingsheetDataForLoadsheet_Searched"] == null)
                    Session["lstBookingsheetDataForLoadsheet_Searched"] = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
                return (List<USPAL_GetBookingsheetDataForLoadsheet_Result>)Session["lstBookingsheetDataForLoadsheet_Searched"];
            }
            set
            {
                Session["lstBookingsheetDataForLoadsheet_Searched"] = value;
            }
        }

        private RightsU_Entities.AL_Load_Sheet objAL_Load_Sheet
        {
            get
            {
                if (Session["objAL_Load_Sheet"] == null)
                    Session["objAL_Load_Sheet"] = new RightsU_Entities.AL_Load_Sheet();
                return (RightsU_Entities.AL_Load_Sheet)Session["objAL_Load_Sheet"];
            }
            set { Session["objAL_Load_Sheet"] = value; }
        }

        private AL_Load_Sheet_Service objAL_Load_Sheet_Service
        {
            get
            {
                if (Session["objAL_Load_Sheet_Service"] == null)
                    Session["objAL_Load_Sheet_Service"] = new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName);
                return (AL_Load_Sheet_Service)Session["objAL_Load_Sheet_Service"];
            }
            set { Session["objCurrency_Service"] = value; }
        }

        private LoadSheetData objLsData
        {
            get
            {
                if (Session["objLsData"] == null)
                    Session["objLsData"] = new LoadSheetData();
                return (LoadSheetData)Session["objLsData"];
            }
            set { Session["objLsData"] = value; }
        }

        List<USPAL_GetBookingsheetDataForLoadsheet_Result> lstUsedBookingsheet
        {
            get
            {
                if (Session["lstUsedBookingsheet"] == null)
                    Session["lstUsedBookingsheet"] = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
                return (List<USPAL_GetBookingsheetDataForLoadsheet_Result>)Session["lstUsedBookingsheet"];
            }
            set
            {
                Session["lstUsedBookingsheet"] = value;
            }
        }

        List<USPAL_GetRevisionHistoryForLoadsheet_Result> lstModuleHistory
        {
            get
            {
                if (Session["lstModuleHistory"] == null)
                    Session["lstModuleHistory"] = new List<USPAL_GetRevisionHistoryForLoadsheet_Result>();
                return (List<USPAL_GetRevisionHistoryForLoadsheet_Result>)Session["lstModuleHistory"];
            }
            set
            {
                Session["lstModuleHistory"] = value;
            }
        }

        //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        // GET: LoadSheet
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCurrency);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForCurrency.ToString();
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = SysLanguageCode;
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            lstAL_Load_Sheet_Searched = lstAL_LoadSheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().ToList();
            return View("~/Views/LoadSheet/Index.cshtml");
        }

        public JsonResult SearchBookingsheet(string loadsheetMonth = "", int loadsheetCode = 0, string CommandName = "", string TabName = "", int Module_Code = 0)
        {
            int recordcount = 0;
            List<USPAL_GetBookingsheetDataForLoadsheet_Result> lstUnusedBookingsheet = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
            if (TabName == "BS")
            {
                if (!string.IsNullOrEmpty(loadsheetMonth) && loadsheetCode == 0)
                {   
                    lstUnusedBookingsheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingsheetDataForLoadsheet(loadsheetMonth, loadsheetCode).ToList();
                }
                else if (loadsheetMonth == "" && loadsheetCode > 0)
                {
                    lstUsedBookingsheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingsheetDataForLoadsheet(loadsheetMonth, loadsheetCode).ToList();
                }
                else
                {
                    lstBookingsheetDataForLoadsheet_Searched = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
                }

                lstBookingsheetDataForLoadsheet_Searched = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
                lstBookingsheetDataForLoadsheet_Searched.AddRange(lstUsedBookingsheet);
                lstBookingsheetDataForLoadsheet_Searched.AddRange(lstUnusedBookingsheet);
                recordcount = lstBookingsheetDataForLoadsheet_Searched.Count();
            }
            else
            {
                lstModuleHistory = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetRevisionHistoryForLoadsheet(loadsheetCode).ToList();
                recordcount = lstModuleHistory.Count();
            }

            var obj = new
            {
                Record_Count = recordcount
            };
            return Json(obj);
        }

        public PartialViewResult OpenBookingsheetPopup(string CommandName, string LoadSheetMonth = "", int AL_Load_Sheet_Code = 0)
        {
            AL_Load_Sheet objLoadSheet = new AL_Load_Sheet();
            objLsData = null;

            if (CommandName == "VIEW" || CommandName == "Regenerate")
            {
                objLoadSheet = objAL_Load_Sheet_Service.SearchFor(s => true).Where(w => w.AL_Load_Sheet_Code == AL_Load_Sheet_Code).FirstOrDefault();
                //ViewBag.LoadsheetMonthView = Convert.ToDateTime(objLoadSheet.Load_Sheet_Month).ToString("MMMM yyyy");
                //ViewBag.LoadsheetMonth = Convert.ToDateTime(objLoadSheet.Load_Sheet_Month).ToString("yyyy-MM");
                //ViewBag.LSRemark = objLoadSheet.Remarks;
                objLsData.LoadsheetMonthView = Convert.ToDateTime(objLoadSheet.Load_Sheet_Month).ToString("MMMM yyyy");
                objLsData.LoadsheetMonth = Convert.ToDateTime(objLoadSheet.Load_Sheet_Month).ToString("yyyy-MM");
                objLsData.LSRemark = objLoadSheet.Remarks;
            }
            ViewBag.CommandName = CommandName;
            //ViewBag.AL_Load_Sheet_Code = AL_Load_Sheet_Code;
            objLsData.LoadSheetCode = AL_Load_Sheet_Code;
            //lstUnusedBookingsheet = null;
            return PartialView("~/Views/LoadSheet/_AddLoadSheet.cshtml", objLoadSheet);
        }

        public PartialViewResult BindBookingsheet(int pageNo, int recordPerPage, string sortType, string CommandName = "")
        {
            List<USPAL_GetBookingsheetDataForLoadsheet_Result> lst = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();

            lst = lstBookingsheetDataForLoadsheet_Searched;

            int RecordCount = 0;
            RecordCount = lstBookingsheetDataForLoadsheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstBookingsheetDataForLoadsheet_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstBookingsheetDataForLoadsheet_Searched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstBookingsheetDataForLoadsheet_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.CommandName = CommandName;

            return PartialView("~/Views/LoadSheet/_BookingsheetList.cshtml", lst);
        }

        public PartialViewResult BindLoadSheetList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetLoadsheetList_Result> lst = new List<USPAL_GetLoadsheetList_Result>();
            int RecordCount = 0;
            RecordCount = lstAL_Load_Sheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstAL_Load_Sheet_Searched.OrderByDescending(o => o.Inserted_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstAL_Load_Sheet_Searched.OrderBy(o => o.AL_Load_Sheet_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstAL_Load_Sheet_Searched.OrderByDescending(o => o.AL_Load_Sheet_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            lstUsedBookingsheet = null;
            //lstUnusedBookingsheet = null;
            return PartialView("~/Views/LoadSheet/_LoadSheetList.cshtml", lst);
        }

        public JsonResult SearchLoadSheet(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstAL_Load_Sheet_Searched = lstAL_LoadSheet.Where(w => w.Load_sheet_No.ToUpper().Contains(searchText.ToUpper())
                || w.Status.ToUpper().Contains(searchText.ToUpper()) || w.Load_Sheet_Month == Convert.ToDateTime(searchText)).ToList();
            }
            else
                lstAL_Load_Sheet_Searched = lstAL_LoadSheet;

            var obj = new
            {
                Record_Count = lstAL_Load_Sheet_Searched.Count
            };

            return Json(obj);
        }

        public JsonResult GenerateLoadSheet(string bookingSheetCodes, string Remark, DateTime LoadSheetMonth)
        {
            string status = "S", message = "";

            List<AL_Load_Sheet_Details> lst = new List<AL_Load_Sheet_Details>();

            try
            {
                //loadsheet month validation
                List<USPAL_GetLoadsheetList_Result> lstToValidateMonth = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().Where(w => w.Load_Sheet_Month == LoadSheetMonth).ToList();
                if (lstToValidateMonth.Count > 0)
                {
                    status = "E";
                    message = "You have already generated loadsheet for " + LoadSheetMonth.ToString("MMMM, yyyy") + ". Go to list page and search loadsheet for month and regenerate.";
                    lstAL_Load_Sheet_Searched = lstAL_LoadSheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().ToList();
                }
                else
                {
                    if (!string.IsNullOrEmpty(bookingSheetCodes))
                    {
                        foreach (var item in bookingSheetCodes.Split(','))
                        {
                            AL_Load_Sheet_Details objloadSheetDetails = new AL_Load_Sheet_Details();
                            objloadSheetDetails.AL_Booking_Sheet_Code = Convert.ToInt32(item);

                            lst.Add(objloadSheetDetails);
                        }

                        objAL_Load_Sheet_Service = null;
                        objAL_Load_Sheet.EntityState = State.Added;
                        objAL_Load_Sheet.Load_Sheet_No = "LS-" + GenerateId();
                        objAL_Load_Sheet.Load_Sheet_Month = LoadSheetMonth;
                        objAL_Load_Sheet.Remarks = Remark;
                        objAL_Load_Sheet.Status = "P";
                        objAL_Load_Sheet.Inserted_By = objLoginUser.Users_Code;
                        objAL_Load_Sheet.Inserted_On = DateTime.Now;
                        objAL_Load_Sheet.Updated_By = objLoginUser.Users_Code;
                        objAL_Load_Sheet.Updated_On = DateTime.Now;
                        objAL_Load_Sheet.AL_Load_Sheet_Details = lst;
                        
                        dynamic resultSet;
                        if (!objAL_Load_Sheet_Service.Save(objAL_Load_Sheet, out resultSet))
                        {
                            status = "E";
                            message = objMessageKey.CouldNotsavedRecord;
                        }
                        else
                        {
                            message = objMessageKey.Recordsavedsuccessfully;
                            status = "S";
                            int LoadSheetCode = objAL_Load_Sheet.AL_Load_Sheet_Code;
                            objAL_Load_Sheet = null;
                            objAL_Load_Sheet_Service = null;

                            Module_Status_History_Type_Service objModule_Status_History_Services = new Module_Status_History_Type_Service(objLoginEntity.ConnectionStringName);
                            Module_Status_History objMSH = new Module_Status_History();
                            objMSH.EntityState = State.Added;
                            objMSH.Module_Code = 264;
                            objMSH.Record_Code = LoadSheetCode;
                            objMSH.Status_Changed_On = DateTime.Now;
                            objMSH.Status_Changed_By = Convert.ToInt32(objLoginUser.Users_Code);
                            objMSH.Remarks = Remark;

                            objModule_Status_History_Services.Save(objMSH, out resultSet);

                            lstAL_Load_Sheet_Searched = lstAL_LoadSheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().ToList();
                            //FetchData();
                        }
                    }
                    else
                    {
                        status = "E";
                        message = "Please search loadsheet for month and Select atleast one booking sheet.";
                    }
                }
            }
            catch (Exception ex)
            {
                status = "E";
                message = ex.Message;
            }

            var obj = new
            {
                RecordCount = lstAL_Load_Sheet_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult RefreshLoadSheet(int AL_Load_Sheet_Code = 0, string bookingSheetCodes = "", string Remark = "")
        {
            string status = "S", message = "";
            AL_Load_Sheet_Service objService = new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName);
            AL_Load_Sheet objToSave = new AL_Load_Sheet();
            try
            {
                if (!string.IsNullOrEmpty(bookingSheetCodes))
                {
                    List<AL_Load_Sheet_Details> lst = new List<AL_Load_Sheet_Details>();
                    foreach (var item in bookingSheetCodes.Split(','))
                    {
                        AL_Load_Sheet_Details objloadSheetDetails = new AL_Load_Sheet_Details();
                        objloadSheetDetails.AL_Booking_Sheet_Code = Convert.ToInt32(item);

                        lst.Add(objloadSheetDetails);
                    }

                    objAL_Load_Sheet = objService.GetById(AL_Load_Sheet_Code);

                    //objToSave.AL_Load_Sheet_Details = new AL_Load_Sheet_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.AL_Load_Sheet_Code == AL_Load_Sheet_Code).ToList();
                    objAL_Load_Sheet.EntityState = State.Modified;
                    objAL_Load_Sheet.Status = "P";
                    objAL_Load_Sheet.Download_File_Name = "";
                    objAL_Load_Sheet.Remarks = Remark;
                    objAL_Load_Sheet.Updated_By = objLoginUser.Users_Code;
                    objAL_Load_Sheet.Updated_On = DateTime.Now;
                    lst.AddRange(objAL_Load_Sheet.AL_Load_Sheet_Details);
                    objAL_Load_Sheet.AL_Load_Sheet_Details = lst;

                    dynamic resultSet;
                    bool isValid = objService.Save(objAL_Load_Sheet, out resultSet);

                    if (!isValid)
                    {
                        status = "E";
                        message = resultSet;
                    }
                    else
                    {
                        message = objMessageKey.Recordsavedsuccessfully;
                        status = "S";
                        objAL_Load_Sheet = null;
                        objAL_Load_Sheet_Service = null;

                        Module_Status_History_Type_Service objModule_Status_History_Services = new Module_Status_History_Type_Service(objLoginEntity.ConnectionStringName);
                        Module_Status_History objMSH = new Module_Status_History();
                        objMSH.EntityState = State.Added;
                        objMSH.Module_Code = 264;
                        objMSH.Record_Code = AL_Load_Sheet_Code;
                        objMSH.Status_Changed_On = DateTime.Now;
                        objMSH.Status_Changed_By = Convert.ToInt32(objLoginUser.Users_Code);
                        objMSH.Remarks = Remark;

                        objModule_Status_History_Services.Save(objMSH, out resultSet);

                        lstAL_Load_Sheet_Searched = lstAL_LoadSheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().ToList();
                        //FetchData();
                    }
                }
                else
                {
                    status = "E";
                    message = "Please search loadsheet for month and Select atleast one booking sheet.";
                }
            }
            catch (Exception ex)
            {
                status = "E";
                message = ex.Message;
            }

            var obj = new
            {
                RecordCount = lstAL_Load_Sheet_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public PartialViewResult BindRevisionHistory(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetRevisionHistoryForLoadsheet_Result> lst = new List<USPAL_GetRevisionHistoryForLoadsheet_Result>();
            lst = lstModuleHistory;

            int RecordCount = 0;
            RecordCount = lstModuleHistory.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstModuleHistory.OrderByDescending(o => o.Last_Action_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstModuleHistory.OrderBy(o => o.Last_Action_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstModuleHistory.OrderByDescending(o => o.Module_Status_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("~/Views/LoadSheet/_RevisionHistoryList.cshtml", lst);
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCurrency), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        private int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }

        public JsonResult GetLoadSheetStatus(int AL_Load_Sheet_Code)
        {
            string recordStatus = new RightsU_BLL.AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.AL_Load_Sheet_Code == AL_Load_Sheet_Code).Select(s => s.Status).FirstOrDefault();
            double TotalCount = new RightsU_BLL.AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.AL_Load_Sheet_Code == AL_Load_Sheet_Code).Count();
            double PendingCount = new RightsU_BLL.AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.AL_Load_Sheet_Code == AL_Load_Sheet_Code && x.Status == "P").Count();

            var obj = new
            {
                RecordStatus = recordStatus,
                TotalCount = TotalCount,
                PendingCount = PendingCount
            };
            return Json(obj);
        }

        public JsonResult ValidateDownload(int AL_Load_Sheet_Code)
        {
            string FileName = Convert.ToString(new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).GetById(AL_Load_Sheet_Code).Download_File_Name);
            string fullPath = (Server.MapPath("~") + "\\" + System.Configuration.ConfigurationManager.AppSettings["UploadFilePath"]);
            string path = fullPath + FileName;
            FileInfo file = new FileInfo(path);
            if (file.Exists)
            {
                var obj = new
                {
                    path = path
                };
                return Json(obj);
            }
            else
            {
                var obj = new
                {
                    path = ""
                };
                return Json(obj);
            }
        }

        public void Download(int AL_Load_Sheet_Code)
        {
            string FileName = new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).GetById(AL_Load_Sheet_Code).Download_File_Name.ToString();
            string fullPath = (Server.MapPath("~") + "\\" + System.Configuration.ConfigurationManager.AppSettings["UploadFilePath"]);
            string path = fullPath + FileName;
            FileInfo file = new FileInfo(path);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            if (file.Exists)
            {
                byte[] bts = System.IO.File.ReadAllBytes(path);
                Response.Clear();
                Response.ClearHeaders();
                Response.AddHeader("Content-Type", "Application/ms-excel");
                Response.AddHeader("Content-Length", bts.Length.ToString());
                Response.AddHeader("Content-Disposition", "attachment;   filename=" + FileName);
                Response.BinaryWrite(bts);
                Response.Flush();
                //WebClient client = new WebClient();
                //Byte[] buffer = client.DownloadData(path);
                //Response.Clear();
                //Response.ContentType = "application/ms-excel";
                //Response.AddHeader("content-disposition", "Attachment;filename=" + fileName);
                //Response.WriteFile(path);
                //Response.End();

            }
        }

        private string GenerateId()
        {
            string demo = "";
            //string LS_No = objAL_Load_Sheet_Service.SearchFor(x => true).OrderByDescending(x => x.AL_Load_Sheet_Code).FirstOrDefault().Load_Sheet_No;     // get this value from database
            string LS_No = objAL_Load_Sheet_Service.SearchFor(x => true).OrderByDescending(x => x.AL_Load_Sheet_Code).Select(s => s.Load_Sheet_No).FirstOrDefault();
            if (!string.IsNullOrEmpty(LS_No))
            {
                int lastAddedId = Convert.ToInt32(LS_No.Split('-')[1]);
                demo = Convert.ToString(lastAddedId + 1).PadLeft(4, '0');
            }
            else
            {
                int lastAddedId = 0000;
                demo = Convert.ToString(lastAddedId + 1).PadLeft(4, '0');
            }

            return demo;
            // it will return 0009
        }
    }

    #region
    public class LoadSheetData
    {
        public int LoadSheetCode { get; set; }
        public string LoadsheetMonthView { get; set; }
        public string LoadsheetMonth { get; set; }
        public string LSRemark { get; set; }
    }
    #endregion
}