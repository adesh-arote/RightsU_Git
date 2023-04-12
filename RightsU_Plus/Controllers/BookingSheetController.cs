using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class BookingSheetController : BaseController
    {
        #region --- Properties ---

        private List<USPAL_GetBookingSheetList_Result> lstBooking_Sheet
        {
            get
            {
                if (Session["lstBooking_Sheet"] == null)
                    Session["lstBooking_Sheet"] = new List<USPAL_GetBookingSheetList_Result>();
                return (List<USPAL_GetBookingSheetList_Result>)Session["lstBooking_Sheet"];
            }
            set { Session["lstBooking_Sheet"] = value; }
        }

        List<USPAL_GetBookingSheetList_Result> lstBooking_Sheet_Searched
        {
            get
            {
                if (Session["lstBooking_Sheet_Searched"] == null)
                    Session["lstBooking_Sheet_Searched"] = new List<USPAL_GetBookingSheetList_Result>();
                return (List<USPAL_GetBookingSheetList_Result>)Session["lstBooking_Sheet_Searched"];
            }
            set
            {
                Session["lstBooking_Sheet_Searched"] = value;
            }
        }

        private RightsU_Entities.AL_Booking_Sheet objBooking_Sheet
        {
            get
            {
                if (Session["objBooking_Sheet"] == null)
                    Session["objBooking_Sheet"] = new RightsU_Entities.AL_Booking_Sheet();
                return (RightsU_Entities.AL_Booking_Sheet)Session["objBooking_Sheet"];
            }
            set { Session["objBooking_Sheet"] = value; }
        }

        private AL_Booking_Sheet_Service objBooking_Sheet_Service
        {
            get
            {
                if (Session["objBooking_Sheet_Service"] == null)
                    Session["objBooking_Sheet_Service"] = new AL_Booking_Sheet_Service(objLoginEntity.ConnectionStringName);
                return (AL_Booking_Sheet_Service)Session["objBooking_Sheet_Service"];
            }
            set { Session["objBooking_Sheet_Service"] = value; }
        }

        //--------------------------------------------------------------------------------------------------------------------------------------------------

        private List<USPAL_GetReCommendationList_Result> lstRecommendation
        {
            get
            {
                if (Session["lstRecommendation"] == null)
                    Session["lstRecommendation"] = new List<USPAL_GetReCommendationList_Result>();
                return (List<USPAL_GetReCommendationList_Result>)Session["lstRecommendation"];
            }
            set { Session["lstRecommendation"] = value; }
        }

        List<USPAL_GetReCommendationList_Result> lstRecommendation_Searched
        {
            get
            {
                if (Session["lstRecommendation_Searched"] == null)
                    Session["lstRecommendation_Searched"] = new List<USPAL_GetReCommendationList_Result>();
                return (List<USPAL_GetReCommendationList_Result>)Session["lstRecommendation_Searched"];
            }
            set
            {
                Session["lstRecommendation_Searched"] = value;
            }
        }

        private RightsU_Entities.AL_Recommendation objRecommendation
        {
            get
            {
                if (Session["objRecommendation"] == null)
                    Session["objRecommendation"] = new RightsU_Entities.AL_Recommendation();
                return (RightsU_Entities.AL_Recommendation)Session["objRecommendation"];
            }
            set { Session["objRecommendation"] = value; }
        }

        private AL_Recommendation_Service objRecommendation_Service
        {
            get
            {
                if (Session["objRecommendation_Service"] == null)
                    Session["objRecommendation_Service"] = new AL_Recommendation_Service(objLoginEntity.ConnectionStringName);
                return (AL_Recommendation_Service)Session["objRecommendation_Service"];
            }
            set { Session["objRecommendation_Service"] = value; }
        }

        //--------------------------------------------------------------------------------------------------------------------------------------------------

        private List<RightsU_Entities.DM_Master_Import> lstImportMaster
        {
            get
            {
                if (Session["lstImportMaster"] == null)
                    Session["lstImportMaster"] = new List<RightsU_Entities.DM_Master_Import>();
                return (List<RightsU_Entities.DM_Master_Import>)Session["lstImportMaster"];
            }
            set { Session["lstImportMaster"] = value; }
        }

        List<RightsU_Entities.DM_Master_Import> lstMasterImportSearched
        {
            get
            {
                if (Session["lstMasterImportSearched"] == null)
                    Session["lstMasterImportSearched"] = new List<RightsU_Entities.DM_Master_Import>();
                return (List<RightsU_Entities.DM_Master_Import>)Session["lstMasterImportSearched"];
            }
            set
            {
                Session["lstMasterImportSearched"] = value;
            }
        }

        private RightsU_Entities.DM_Master_Import objMaster_Import
        {
            get
            {
                if (Session["objMaster_Import"] == null)
                    Session["objMaster_Import"] = new RightsU_Entities.DM_Master_Import();
                return (RightsU_Entities.DM_Master_Import)Session["objMaster_Import"];
            }
            set { Session["objMaster_Import"] = value; }
        }

        private DM_Master_Import_Service objMasterImport_Service
        {
            get
            {
                if (Session["objMasterImport_Service"] == null)
                    Session["objMasterImport_Service"] = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName);
                return (DM_Master_Import_Service)Session["objMasterImport_Service"];
            }
            set { Session["objMasterImport_Service"] = value; }
        }

        //--------------------------------------------------------------------------------------------------------------------------------------------------
       
        private SelectDateAndBKSCode objSDAB
        {
            get
            {
                if (Session["objSDAB"] == null)
                    Session["objSDAB"] = new SelectDateAndBKSCode();
                return (SelectDateAndBKSCode)Session["objSDAB"];
            }
            set { Session["objSDAB"] = value; }
        }

        private SelectDmMasterCodeAndFiletType objDMCFT
        {
            get
            {
                if (Session["objDMCFT"] == null)
                    Session["objDMCFT"] = new SelectDmMasterCodeAndFiletType();
                return (SelectDmMasterCodeAndFiletType)Session["objDMCFT"];
            }
            set { Session["objDMCFT"] = value; }
        }

        #endregion

        //-----------------------------------------------------Paging---------------------------------------------------------------------------------------

        public ActionResult Index()
        {
            objSDAB = null;
            BookingSheetData();
            PendingReccomendationData();

            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            //lstSort.Add(new SelectListItem { Text = "Sort Name Asc", Value = "NA" });
            //lstSort.Add(new SelectListItem { Text = "Sort Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            //Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            //List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).Where(w => w.Party_Type == "C" && w.Is_Active == "Y").ToList();
            //ViewBag.ddlClient = new SelectList(lstVendors.OrderBy(o => o.Vendor_Name), "Vendor_Code", "Vendor_Name");

            if (Session["Message"] != null)
            {                                            //-----To show success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }

            return View();
        }

        private void BookingSheetData()
        {
            //lstBooking_Sheet_Searched = lstBooking_Sheet = objBooking_Sheet_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
            lstBooking_Sheet_Searched = lstBooking_Sheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingSheetList().ToList();
        }

        private void PendingReccomendationData()
        {
            //lstRecommendation_Searched = lstRecommendation = objRecommendation_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
            lstRecommendation_Searched = lstRecommendation = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetReCommendationList().ToList();
        }

        public ActionResult BindBookingSheetList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetBookingSheetList_Result> lst = new List<USPAL_GetBookingSheetList_Result>();
            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);

            int RecordCount = 0;
            RecordCount = lstBooking_Sheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstBooking_Sheet_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).ToList();
            ViewBag.ClientCode = lstVendors;

            List<RightsU_Entities.User> lstUsers = objUser_Service.SearchFor(s => true).ToList();
            ViewBag.UserCode = lstUsers;

            return PartialView("_BookingSheetList", lst);
        }

        public ActionResult PendingRecommendationsList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetReCommendationList_Result> lst = new List<USPAL_GetReCommendationList_Result>();

            int RecordCount = 0;
            RecordCount = lstRecommendation_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstRecommendation_Searched.OrderByDescending(o => o.AL_Recommendation_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("_PendingRecommendationsList", lst);
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

        public JsonResult SearchOnList(string searchText, string TabName)
        {
            int recordcount = 0;
            if (TabName == "BS")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstBooking_Sheet_Searched = lstBooking_Sheet.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToString().Contains(searchText.ToString()) || (w.Booking_Sheet_No != null && w.Booking_Sheet_No.ToString().Contains(searchText.ToString()))).ToList();
                }
                else
                {
                    BookingSheetData();
                    lstBooking_Sheet_Searched = lstBooking_Sheet;
                }

                recordcount = lstBooking_Sheet_Searched.Count;
            }
            else if(TabName == "PR")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstRecommendation_Searched = lstRecommendation.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToString().Contains(searchText.ToString()) || (w.Proposal_No != null && w.Proposal_No.ToString().Contains(searchText.ToString()))).ToList();
                }
                else
                {
                    PendingReccomendationData();
                    lstRecommendation_Searched = lstRecommendation;
                }

                recordcount = lstRecommendation_Searched.Count;
            }

            var obj = new
            {
                Record_Count = recordcount
            };

            return Json(obj);
        }

        //-----------------------------------------------------GenerateBookingSheet-------------------------------------------------------------------------

        public JsonResult GenerateBookingSheet(int RecommendationCode)
        {
            string Status = "";
            string Message = "";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            AL_Booking_Sheet objABS = new AL_Booking_Sheet();
            USPAL_GetReCommendationList_Result objRc = new USPAL_GetReCommendationList_Result();

            if (RecommendationCode != 0)
            {
                objRc = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetReCommendationList().Where(w => w.AL_Recommendation_Code == RecommendationCode).FirstOrDefault();

                objABS.AL_Recommendation_Code = objRc.AL_Recommendation_Code;
                objABS.Last_Action_By = objLoginUser.Users_Code;
                objABS.Last_Updated_Time = DateTime.Now;
                objABS.Record_Status = "P";

                objABS.Vendor_Code = objRc.Vendor_Code;

                Random ran = new Random();
                int SheetNo = ran.Next(1, 100);
                objABS.Booking_Sheet_No = "BS000" + SheetNo;

                objABS.EntityState = State.Added;
            }

            dynamic resultSet;
            if (!objBooking_Sheet_Service.Save(objABS, out resultSet))
            {
                Status = "E";
                Message = resultSet;
            }
            else
            {
                Status = "S";
                Message = "Sheet Generated Succesfully";
            }

            var Obj = new
            {
                Status = Status,
                Message = Message
            };
            return Json(Obj);
        }

        //-----------------------------------------------------GetFileNameToDownload------------------------------------------------------------------------

        public JsonResult GetFileName(int BookingSheetCode)
        {
            string Filename = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingSheetList().Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).Select(s => s.Vendor_Name).FirstOrDefault();

            return Json(Filename);
        }

        //-----------------------------------------------------BookingSheetImport---------------------------------------------------------------------------

        public JsonResult BindImportExportView(int BookingSheetCode)
        {
            string status = "S";
            AL_Booking_Sheet_Details_Service objBooking_Sheet_Details_Service = new AL_Booking_Sheet_Details_Service(objLoginEntity.ConnectionStringName);
            List<AL_Booking_Sheet_Details> lstBKSDetails = objBooking_Sheet_Details_Service.SearchFor(s => true).Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).ToList();

            DateTime? maxDate = lstBKSDetails.Select(s => s.Action_Date).Max();

            objSDAB.BookingSheetCode = BookingSheetCode;
            objSDAB.MaxDate = Convert.ToDateTime(maxDate);

            var obj = new
            {
                status
            };
            return Json(obj);
        }

        public ActionResult ImportMasterView()
        {
            //int BookingSheetCode = 0;
            //DateTime? MaxDate = null;
            MasterImportData();
            objDMCFT = null;

            List<SelectListItem> lstFliter = new List<SelectListItem>();
            lstFliter.Add(new SelectListItem { Text = "All", Value = "A", Selected = true });
            lstFliter.Add(new SelectListItem { Text = "Error", Value = "E" });
            lstFliter.Add(new SelectListItem { Text = "In Process", Value = "N" });
            lstFliter.Add(new SelectListItem { Text = "Success", Value = "S" });
            ViewBag.FilterBy = lstFliter;

            //BookingSheetCode = Convert.ToInt32(TempData["BookingSheetCode"]);
            //ViewBag.BKSCode = BookingSheetCode;

            //MaxDate = Convert.ToDateTime(TempData["MaxDate"]);
            //ViewBag.MaxDate = MaxDate;

            return View();
        }

        private void MasterImportData()
        {
            lstMasterImportSearched = lstImportMaster = objMasterImport_Service.SearchFor(x => true).Where(w => w.Record_Code != null).ToList();
        }

        public ActionResult BindImportMasterList(int pageNo, int recordPerPage, string FilterBy)
        {
            List<DM_Master_Import> lst = new List<DM_Master_Import>();
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);

            int RecordCount = 0;
            RecordCount = lstMasterImportSearched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetImportMasterPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (FilterBy == "A")
                    lst = lstMasterImportSearched.OrderByDescending(o => o.Uploaded_Date).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            List<RightsU_Entities.User> lstUser = objUser_Service.SearchFor(s => true).ToList();
            ViewBag.UserCodes = lstUser;

            return PartialView("_MasterImportList", lst);
        }

        private int GetImportMasterPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
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

        public JsonResult SearchOnImportMasterList(string searchText)
        {
            int recordcount = 0;

            if (!string.IsNullOrEmpty(searchText))
            {
                //lstMasterImportSearched = lstImportMaster.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToString().Contains(searchText.ToString()) || (w.Booking_Sheet_No != null && w.Booking_Sheet_No.ToString().Contains(searchText.ToString()))).ToList();
            }
            else
            {
                MasterImportData();
                lstMasterImportSearched = lstImportMaster;
            }

            recordcount = lstMasterImportSearched.Count;

            var obj = new
            {
                Record_Count = recordcount
            };
            return Json(obj);
        }

        //---------------------------------------------------------FileUpload-------------------------------------------------------------------------------

        public ActionResult UploadFiles(HttpPostedFileBase InputFile, int BookingSheetCode)
        {
            string message = "";
            string status = "";
            
            DM_Master_Import obj_DM_Master_Import = new DM_Master_Import();

            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var PostedFile = InputFile;
                string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadSheetPath"];
                string ext = System.IO.Path.GetExtension(PostedFile.FileName);

                if (ext == ".xlsx" || ext == ".xls")
                {
                    try
                    {
                        #region EXCEL File Upload 
                        string strActualFileNameWithDate;
                        string fileExtension = "";
                        string strFileName = System.IO.Path.GetFileName(PostedFile.FileName);
                        fileExtension = System.IO.Path.GetExtension(PostedFile.FileName);
                        strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
                        string fullpathname = (Server.MapPath("~") + "\\" + System.Configuration.ConfigurationManager.AppSettings["UploadSheetPath"] + strActualFileNameWithDate);
                        PostedFile.SaveAs(fullpathname);                            
                        #endregion

                        dynamic resultSet;
                        obj_DM_Master_Import.File_Name = PostedFile.FileName;
                        obj_DM_Master_Import.System_File_Name = strActualFileNameWithDate;
                        obj_DM_Master_Import.Upoaded_By = objLoginUser.Users_Code;
                        obj_DM_Master_Import.Uploaded_Date = DateTime.Now;
                        obj_DM_Master_Import.Action_By = objLoginUser.Users_Code;
                        obj_DM_Master_Import.Action_On = DateTime.Now;
                        obj_DM_Master_Import.Status = "P";
                        obj_DM_Master_Import.File_Type = "B";
                        obj_DM_Master_Import.Record_Code = BookingSheetCode;
                        obj_DM_Master_Import.EntityState = State.Added;
                        if (!objMasterImport_Service.Save(obj_DM_Master_Import, out resultSet))
                        {
                            status = "E";
                            message = "File not saved";
                        }
                        else
                        {
                            status = "S";
                            message = "File Imported successfully";
                        }
                    }
                    catch (Exception ex)
                    {
                        message = ex.Message;
                        status = "E";
                    }

                }
                else
                {
                    message = "Please select excel file...";
                    status = "E";
                }
            }
            else
            {
                message = "Please select excel file...";
                status = "E";
            }

            var Obj = new
            {
                Status = status,
                Message = message
            };

            return Json(Obj);
        }

        //---------------------------------------------------------FileUpload-------------------------------------------------------------------------------

        public ActionResult ImportedSheetView(int DM_Master_Import_Code, string fileType = "")
        {
            MovieTabData();
            ShowTabData();
            objDMCFT.DmMasterImportCode = DM_Master_Import_Code;
            objDMCFT.FileType = fileType;
            
            return View();
        }

        private void MovieTabData()
        {
            lstMasterImportSearched = lstImportMaster = objMasterImport_Service.SearchFor(x => true).Where(w => w.Record_Code != null).ToList();
        }

        private void ShowTabData()
        {
            lstMasterImportSearched = lstImportMaster = objMasterImport_Service.SearchFor(x => true).Where(w => w.Record_Code != null).ToList();
        }

    }

    #region
    public class SelectDateAndBKSCode
    {
        public DateTime MaxDate { get; set; }
        public int BookingSheetCode { get; set; }
    }

    public class SelectDmMasterCodeAndFiletType
    {
        public string FileType { get; set; }
        public int DmMasterImportCode { get; set; }
    }
    #endregion
}