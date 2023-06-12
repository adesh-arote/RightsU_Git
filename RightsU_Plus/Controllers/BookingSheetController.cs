using Microsoft.Reporting.WebForms;
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
using UTOFrameWork.FrameworkClasses;

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

        private List<RightsU_Entities.DM_Booking_Sheet_Data> lstBSMovieData
        {
            get
            {
                if (Session["lstBSMovieData"] == null)
                    Session["lstBSMovieData"] = new List<RightsU_Entities.DM_Booking_Sheet_Data>();
                return (List<RightsU_Entities.DM_Booking_Sheet_Data>)Session["lstBSMovieData"];
            }
            set { Session["lstBSMovieData"] = value; }
        }

        private List<RightsU_Entities.DM_Booking_Sheet_Data> lstBSShowData
        {
            get
            {
                if (Session["lstBSShowData"] == null)
                    Session["lstBSShowData"] = new List<RightsU_Entities.DM_Booking_Sheet_Data>();
                return (List<RightsU_Entities.DM_Booking_Sheet_Data>)Session["lstBSShowData"];
            }
            set { Session["lstBSShowData"] = value; }
        }

        List<RightsU_Entities.DM_Booking_Sheet_Data> lstBSMovieDataSearched
        {
            get
            {
                if (Session["lstBSMovieDataSearched"] == null)
                    Session["lstBSMovieDataSearched"] = new List<RightsU_Entities.DM_Booking_Sheet_Data>();
                return (List<RightsU_Entities.DM_Booking_Sheet_Data>)Session["lstBSMovieDataSearched"];
            }
            set
            {
                Session["lstBSMovieDataSearched"] = value;
            }
        }

        List<RightsU_Entities.DM_Booking_Sheet_Data> lstBSShowDataSearched
        {
            get
            {
                if (Session["lstBSShowDataSearched"] == null)
                    Session["lstBSShowDataSearched"] = new List<RightsU_Entities.DM_Booking_Sheet_Data>();
                return (List<RightsU_Entities.DM_Booking_Sheet_Data>)Session["lstBSShowDataSearched"];
            }
            set
            {
                Session["lstBSShowDataSearched"] = value;
            }
        }

        private DM_Booking_Sheet_Data_Service objBSData_Service
        {
            get
            {
                if (Session["objBSData_Service"] == null)
                    Session["objBSData_Service"] = new DM_Booking_Sheet_Data_Service(objLoginEntity.ConnectionStringName);
                return (DM_Booking_Sheet_Data_Service)Session["objBSData_Service"];
            }
            set { Session["objBSData_Service"] = value; }
        }

        //--------------------------------------------------------------------------------------------------------------------------------------------------

        private SelectedBKDetails objSDAB
        {
            get
            {
                if (Session["objSDAB"] == null)
                    Session["objSDAB"] = new SelectedBKDetails();
                return (SelectedBKDetails)Session["objSDAB"];
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

        //--------------------------------------------------------------------------------------------------------------------------------------------------

        private AL_Purchase_Order_Service objPurchase_Order_Service
        {
            get
            {
                if (Session["objPurchase_Order_Service"] == null)
                    Session["objPurchase_Order_Service"] = new AL_Purchase_Order_Service(objLoginEntity.ConnectionStringName);
                return (AL_Purchase_Order_Service)Session["objPurchase_Order_Service"];
            }
            set { Session["objPurchase_Order_Service"] = value; }
        }
       
        #endregion

        //--------------------------------------------------BookingSheet and Reccomendation-----------------------------------------------------------------

        public ActionResult Index()
        {
            objSDAB = null;

            Session["BookingSheetCode"] = null;
            Session["config"] = null;

            BookingSheetData();
            PendingReccomendationData();

            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Booking Sheet No Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Booking Sheet No Desc", Value = "ND" });
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
    
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);

            int RecordCount = 0;
            RecordCount = lstBooking_Sheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstBooking_Sheet_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (sortType == "NA")
                    lst = lstBooking_Sheet_Searched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (sortType == "ND")
                    lst = lstBooking_Sheet_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            //DataTable dt = ToDataTable(lst);
            
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

        public JsonResult SearchOnList(string searchText, string TabName)
        {
            int recordcount = 0;
            if (TabName == "BS")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstBooking_Sheet_Searched = lstBooking_Sheet.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToUpper().Contains(searchText.ToUpper()) || (w.Booking_Sheet_No != null && w.Booking_Sheet_No.ToUpper().Contains(searchText.ToUpper()))).ToList();
                }
                else
                {
                    BookingSheetData();
                    lstBooking_Sheet_Searched = lstBooking_Sheet;
                }

                recordcount = lstBooking_Sheet_Searched.Count;
            }
            else if (TabName == "PR")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstRecommendation_Searched = lstRecommendation.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
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

        //------------------------------------------------RefreshBookingSheet and GetStatus-----------------------------------------------------------------

        public JsonResult GetbookingSheetStatus(int BookingSheetCode)
        {
            BookingSheetData();
            string recordStatus = new AL_Booking_Sheet_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.AL_Booking_Sheet_Code == BookingSheetCode).Select(s => s.Record_Status).FirstOrDefault();
            
            var obj = new
            {
                RecordStatus = recordStatus,
            };
            return Json(obj);
        }

        public JsonResult RefreshBookingSheet(int BookingSheetCode)
        {
            string status = "S", message = "";

            AL_Booking_Sheet obj_AL_Booking_Sheet = new AL_Booking_Sheet();
            obj_AL_Booking_Sheet = objBooking_Sheet_Service.SearchFor(s => true).Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).FirstOrDefault();

            obj_AL_Booking_Sheet.Record_Status = "I";
            obj_AL_Booking_Sheet.Excel_File = "";
            obj_AL_Booking_Sheet.EntityState = State.Modified;
            
            dynamic resultSet;
            if (!objBooking_Sheet_Service.Save(obj_AL_Booking_Sheet, out resultSet))
            {
                status = "E";
                message = resultSet;
            }
            else
            {
                message = objMessageKey.Recordsavedsuccessfully;

                objBooking_Sheet = null;
                objBooking_Sheet_Service = null;

                BookingSheetData();
            }

            var obj = new
            {
                RecordCount = lstBooking_Sheet_Searched.Count,
                Status = status,
                Message = message
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

                objBooking_Sheet_Service = null;
                objABS.EntityState = State.Added;
                objABS.Record_Status = "P";
                objABS.Booking_Sheet_No = "BS" + GenerateBsNumber();
                objABS.Vendor_Code = objRc.Vendor_Code;
                objABS.AL_Recommendation_Code = objRc.AL_Recommendation_Code;
                objABS.Inserted_By = objLoginUser.Users_Code;
                objABS.Inserted_On = DateTime.Now;
                objABS.Last_Action_By = objLoginUser.Users_Code;
                objABS.Last_Updated_Time = DateTime.Now;
                
                //Random ran = new Random();
                //int SheetNo = ran.Next(1, 10000);
                //objABS.Booking_Sheet_No = "BS" + SheetNo;               
            }

            dynamic resultSet;
            if (!objBooking_Sheet_Service.Save(objABS, out resultSet))
            {
                Status = "E";
                Message = resultSet;
            }
            else
            {
                objBooking_Sheet_Service = null;
            
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

        //----------------------------------------------------GetFileNameToDownload-------------------------------------------------------------------------

        public JsonResult GetFileName(int BookingSheetCode)
        {
            string Filename = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingSheetList().Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).Select(s => s.Excel_File).FirstOrDefault();

            return Json(Filename);
        }

        //-----------------------------------------------------BookingSheetImport---------------------------------------------------------------------------

        public JsonResult BindImportExportView(int BookingSheetCode)
        {
            string status = "S";    
            AL_Booking_Sheet_Details_Service objBooking_Sheet_Details_Service = new AL_Booking_Sheet_Details_Service(objLoginEntity.ConnectionStringName);
            List<AL_Booking_Sheet_Details> lstBKSDetails = objBooking_Sheet_Details_Service.SearchFor(s => true).Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).ToList();

            string ClientName = lstBooking_Sheet_Searched.Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).Select(s => s.Vendor_Name).FirstOrDefault();
            string Proposal_Cycle = lstBooking_Sheet_Searched.Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).Select(s => s.Proposal_CY).FirstOrDefault();
            string Cycle = lstBooking_Sheet_Searched.Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).Select(s => s.Cycle).FirstOrDefault();

            DateTime? maxDate = lstBKSDetails.Select(s => s.Action_Date).Max();

            objSDAB.BookingSheetCode = BookingSheetCode;
            objSDAB.MaxDate = Convert.ToDateTime(maxDate);
            objSDAB.Client_Name = ClientName;
            objSDAB.Proposal_CY = Proposal_Cycle;
            objSDAB.Cycle = Cycle;

            var obj = new
            {
                status
            };
            return Json(obj);
        }

        public ActionResult ImportMasterView()
        {
            objDMCFT = null;
            if(objSDAB != null)
            {
                int BookingSheetCode = Convert.ToInt32(objSDAB.BookingSheetCode);
                BindImportExportView(BookingSheetCode);
            }            

            List<SelectListItem> lstFliter = new List<SelectListItem>();
            lstFliter.Add(new SelectListItem { Text = "All", Value = "A", Selected = true });
            lstFliter.Add(new SelectListItem { Text = "Error", Value = "E" });
            lstFliter.Add(new SelectListItem { Text = "In Process", Value = "N" });
            lstFliter.Add(new SelectListItem { Text = "Success", Value = "S" });
            ViewBag.FilterBy = lstFliter;

            return View();
        }

        private void MasterImportData()
        {
            lstImportMaster = new List<DM_Master_Import>();
            lstMasterImportSearched = new List<DM_Master_Import>();
            objMasterImport_Service = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName);
            lstMasterImportSearched = lstImportMaster = objMasterImport_Service.SearchFor(x => true).Where(w => w.Record_Code == objSDAB.BookingSheetCode).ToList();
        }

        public ActionResult BindImportMasterList(int pageNo, int recordPerPage, string FilterBy, int BookingSheetCode)
        {
            List<DM_Master_Import> lst = new List<DM_Master_Import>();
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);

            //string isShow = "";

            int RecordCount = 0;
            RecordCount = lstMasterImportSearched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (FilterBy == "A")
                    lst = lstMasterImportSearched.OrderByDescending(o => o.Uploaded_Date).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (FilterBy == "E")
                    lst = lstMasterImportSearched.OrderByDescending(o => o.Uploaded_Date).Where(w => w.Status == "E").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (FilterBy == "N")
                    lst = lstMasterImportSearched.OrderByDescending(o => o.Uploaded_Date).Where(w => w.Status == "N" || w.Status == "P").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (FilterBy == "S")
                    lst = lstMasterImportSearched.OrderByDescending(o => o.Uploaded_Date).Where(w => w.Status == "S").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            //if (lstImportMaster.Where(w => w.Status == "P" || w.Status == "N").Count() > 0)
            //{
            //    isShow = "N";
            //}
            //else if (lstImportMaster.Where(w => w.Status == "E" || w.Status == "S").Count() > 0)
            //{
            //    isShow = "Y";
            //}

            //ViewBag.isButtonShow = isShow;

            List<RightsU_Entities.User> lstUser = objUser_Service.SearchFor(s => true).ToList();
            ViewBag.UserCodes = lstUser;          

            return PartialView("_MasterImportList", lst);
        }

        public JsonResult SearchOnImportMasterList(string searchText)
        {
            int recordcount = 0;

            if (!string.IsNullOrEmpty(searchText))
            {
                MasterImportData();
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

        //-------------------------------------------------RefreshImportSheet and GetStatus-----------------------------------------------------------------

        public JsonResult GetImportedSheetStatus(int DmMasterCode)
        {
            string fileError = "";
            string latestFile = "";
            MasterImportData();
            DM_Master_Import objDMI = new DM_Master_Import();
            objDMI = objMasterImport_Service.SearchFor(w => w.DM_Master_Import_Code == DmMasterCode).FirstOrDefault();
            string recordStatus = objDMI.Status;
            if (recordStatus == "E")
            {
                int ValidCount = objBSData_Service.SearchFor(s => true).Where(w => w.DM_Master_Import_Code == DmMasterCode).Count();

                if (ValidCount == 0)
                {
                    fileError = "FE";
                }
            }

            List<DM_Master_Import> lstDMI = objMasterImport_Service.SearchFor(s => true).Where(w => w.Record_Code == objDMI.Record_Code).ToList();

            int DMICode = lstDMI.OrderByDescending(o => o.Uploaded_Date).Select(s => s.DM_Master_Import_Code).FirstOrDefault();

            if (objDMI.DM_Master_Import_Code == DMICode)
            {
                latestFile = "Y";
            }
            
            var obj = new
            {
                RecordStatus = recordStatus,
                FileError = fileError,
                LatestFile = latestFile
            };
            return Json(obj);
        }

        public JsonResult RefreshImportedSheet(int DmMasterCode)
        {
            string status = "S", message = "";

            DM_Master_Import obj_DM_Master_Import = new DM_Master_Import();
            obj_DM_Master_Import = objMasterImport_Service.SearchFor(s => true).Where(w => w.DM_Master_Import_Code == DmMasterCode).FirstOrDefault();

            obj_DM_Master_Import.Status = "I";
            obj_DM_Master_Import.File_Type = "B";
            obj_DM_Master_Import.EntityState = State.Modified;

            dynamic resultSet;
            if (!objMasterImport_Service.Save(obj_DM_Master_Import, out resultSet))
            {
                status = "E";
                message = resultSet;
            }
            else
            {
                message = objMessageKey.Recordsavedsuccessfully;

                obj_DM_Master_Import = null;
                objMasterImport_Service = null;

                MasterImportData();
            }

            var obj = new
            {
                RecordCount = lstMasterImportSearched.Count,
                Status = status,
                Message = message
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
                            objBooking_Sheet_Service = null;
                            BookingSheetData();

                            AL_Booking_Sheet obj_AL_Booking_Sheet = new AL_Booking_Sheet();
                            obj_AL_Booking_Sheet = objBooking_Sheet_Service.SearchFor(s => true).Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).FirstOrDefault();

                            obj_AL_Booking_Sheet.Record_Status = "I";
                            obj_AL_Booking_Sheet.Last_Action_By = objLoginUser.Users_Code;
                            obj_AL_Booking_Sheet.Last_Updated_Time = DateTime.Now;

                            obj_AL_Booking_Sheet.EntityState = State.Modified;
                            objBooking_Sheet_Service.Save(obj_AL_Booking_Sheet, out resultSet);
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

        //-------------------------------------------------------ImportedSheetView--------------------------------------------------------------------------

        public ActionResult ImportedSheetView(int DM_Master_Import_Code, string fileType = "")
        {
            MovieTabData();
            ShowTabData();
            objDMCFT.DmMasterImportCode = DM_Master_Import_Code;
            objDMCFT.FileType = fileType;

            if (Session["Message"] != null)
            {                                            //-----To show success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }

            return View();
        }

        private void MovieTabData()
        {
            lstBSMovieDataSearched = lstBSMovieData = objBSData_Service.SearchFor(x => true).Where(w => w.Sheet_Name == "Movie").ToList();
        }

        private void ShowTabData()
        {
            lstBSShowDataSearched = lstBSShowData = objBSData_Service.SearchFor(x => true).Where(w => w.Sheet_Name == "Show").ToList();
        }

        public ActionResult BindMovieSheetData(int pageNo, int recordPerPage, string sortType, int DM_Master_Import_Code)
        {
            string message = "";
            int RecordCount = 0;
            
            List<DM_Booking_Sheet_Data> lstBulkImport, lst = new List<DM_Booking_Sheet_Data>();
            DM_Booking_Sheet_Data firstItem = new DM_Booking_Sheet_Data();
            try
            {
                lstBulkImport = lstBSMovieDataSearched.Where(x => x.DM_Master_Import_Code == DM_Master_Import_Code && (x.Data_Type == "D" || x.Data_Type == "H")).ToList();              
                if (lstBulkImport.Count != 0)
                {
                    RecordCount = lstBulkImport.Count - 1;
                    ViewBag.RecordCount = RecordCount;

                    firstItem = lstBulkImport[0];
                    lstBulkImport.RemoveAt(0);
                }
                else
                {
                    RecordCount = lstBulkImport.Count();
                    ViewBag.RecordCount = RecordCount;
                }
                //var newBulkList = lstBulkImport.Select(x => new { Record_Status = x.Record_Status, Error_Message = x.Error_Message, Col1 = x.Col1, Col2 = x.Col2, Col3 = x.Col3 });

                if (RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    if (sortType == "T")
                        lst = lstBulkImport.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    if (sortType == "E")
                        lst = lstBulkImport.Where(s => s.Record_Status == "E").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    if (sortType == "N")
                        lst = lstBulkImport.Where(s => s.Record_Status == "C").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    lst.Insert(0, firstItem);
                    //DataTable dt = ToDataTable(lst);
                }
                else
                {
                    lst = lstBulkImport;
                    //DataTable dt = ToDataTable(lst);
                }
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }

            return PartialView("_MovieSheetData", lst);
        }

        public ActionResult BindShowSheetData(int pageNo, int recordPerPage, string sortType, int DM_Master_Import_Code)
        {
            string message = "";
            int RecordCount = 0;

            List<DM_Booking_Sheet_Data> lstBulkImport, lst = new List<DM_Booking_Sheet_Data>();
            DM_Booking_Sheet_Data firstItem = new DM_Booking_Sheet_Data();
            try
            {
                lstBulkImport = lstBSShowDataSearched.Where(x => x.DM_Master_Import_Code == DM_Master_Import_Code && (x.Data_Type == "D" || x.Data_Type == "H")).ToList();              
                if (lstBulkImport.Count != 0)
                {
                    RecordCount = lstBulkImport.Count - 1;
                    ViewBag.RecordCount = RecordCount;

                    firstItem = lstBulkImport[0];
                    lstBulkImport.RemoveAt(0);
                }
                else
                {
                    RecordCount = lstBulkImport.Count();
                    ViewBag.RecordCount = RecordCount;
                }

                if (RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    if (sortType == "T")
                        lst = lst = lstBulkImport.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    if (sortType == "E")
                        lst = lstBulkImport.Where(s => s.Record_Status == "E").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    if (sortType == "N")
                        lst = lstBulkImport.Where(s => s.Record_Status == "C").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    lst.Insert(0, firstItem);
                    //DataTable dt = ToDataTable(lst);
                }
                else
                {
                    lst = lstBulkImport;
                    //DataTable dt = ToDataTable(lst);
                }
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }

            return PartialView("_ShowSheetData", lst);
        }

        public JsonResult SearchOnSheet(string searchText, string TabName, int DM_Master_Import_Code)
        {
            int recordcount = 0;
            if (TabName == "MV")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstBSMovieDataSearched = lstBSMovieData.Where(m => (MyContains(m, searchText.ToUpper()) && (m.DM_Master_Import_Code == DM_Master_Import_Code) || (m.Data_Type == "H" && m.DM_Master_Import_Code == DM_Master_Import_Code))).ToList();
                    //lstBSMovieDataSearched = lstBSMovieData.Where(x => ((x.DM_Master_Import_Code == DM_Master_Import_Code) && (x.Col1 != null && x.Col1.ToString().Contains(searchText.ToString())) || (x.Data_Type == "H" && x.DM_Master_Import_Code == DM_Master_Import_Code)) || ((x.DM_Master_Import_Code == DM_Master_Import_Code) && (x.Record_Status != null && x.Record_Status.ToString().Contains(searchText.ToString().ToUpper())) || (x.Data_Type == "H" && x.DM_Master_Import_Code == DM_Master_Import_Code))).ToList();
                    ViewBag.RecordCount = lstBSMovieDataSearched.Count();

                }
                else
                {
                    MovieTabData();
                    ViewBag.RecordCount = lstBSMovieData.Where(x => x.DM_Master_Import_Code == DM_Master_Import_Code && (x.Data_Type == "D")).ToList().Count();
                }
                recordcount = ViewBag.RecordCount;
            }
            else if (TabName == "SH")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstBSShowDataSearched = lstBSShowData.Where(m => (MyContains(m, searchText.ToUpper()) && (m.DM_Master_Import_Code == DM_Master_Import_Code) || (m.Data_Type == "H" && m.DM_Master_Import_Code == DM_Master_Import_Code))).ToList();
                    //lstBSShowDataSearched = lstBSShowData.Where(x => x.DM_Master_Import_Code == DM_Master_Import_Code && (x.Col1 != null && x.Col1.ToString().Contains(searchText.ToString()))).ToList();
                    ViewBag.RecordCount = lstBSShowDataSearched.Count();
                }
                else
                {
                    ShowTabData();
                    ViewBag.RecordCount = lstBSShowData.Where(x => x.DM_Master_Import_Code == DM_Master_Import_Code && (x.Data_Type == "D")).ToList().Count();
                }
                recordcount = ViewBag.RecordCount;
            }
            var obj = new
            {
                Record_Count = recordcount,
            };
            return Json(obj);
        }

        public ActionResult ErrorMessagePopUp(int DM_Booking_Sheet_Data_Code, string TabName)
        {
            DM_Booking_Sheet_Data objDBS = new DM_Booking_Sheet_Data();
            DM_Booking_Sheet_Data_Service objDBS_Service = new DM_Booking_Sheet_Data_Service(objLoginEntity.ConnectionStringName);
            var SeperatedString = new List<string>();
            if (TabName == "MV")
            {
                int count = lstBSMovieDataSearched.Where(w => w.DM_Booking_Sheet_Data_Code == DM_Booking_Sheet_Data_Code).Count();
                if (count > 0)
                {
                    objDBS = objDBS_Service.GetById(DM_Booking_Sheet_Data_Code);
                    SeperatedString = objDBS.Error_Message.Split('~').ToList();
                    var firstItem = SeperatedString[0];
                    SeperatedString.RemoveAt(0);
                }
            }
            else if (TabName == "SH")
            {
                int count = lstBSShowDataSearched.Where(w => w.DM_Booking_Sheet_Data_Code == DM_Booking_Sheet_Data_Code).Count();
                if (count > 0)
                {
                    objDBS = objDBS_Service.GetById(DM_Booking_Sheet_Data_Code);
                    SeperatedString = objDBS.Error_Message.Split('~').ToList();
                    var firstItem = SeperatedString[0];
                    SeperatedString.RemoveAt(0);
                }
            }
            string MessageTr = "";
            int i = 1;
            foreach (string msg in SeperatedString)
            {
                MessageTr = MessageTr + "<tr><td>" + i + "</td><td>" + msg.TrimEnd(' ').TrimEnd(',') + "</td></tr>";
                i++;
            }

            return Json(MessageTr);
        }

        public void ExportToExcel(int DM_Import_Master_Code = 0, string TabName = "")
        {
            ReportViewer ReportViewer1 = new ReportViewer();
            ReportParameter[] parm = new ReportParameter[2];
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;

            parm[0] = new ReportParameter("DM_Master_Import_Code", Convert.ToString(DM_Import_Master_Code));
            parm[1] = new ReportParameter("TabName", TabName);

            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport("rptExportToExcelBulkImport");
            }
            ReportCredential();
            ReportViewer1.ServerReport.SetParameters(parm);
            Byte[] buffer = ReportViewer1.ServerReport.Render("Excel", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            if (TabName == "MV")
                Response.AddHeader("Content-disposition", "filename=MovieSheetDetails.xls");
            else if (TabName == "SH")
                Response.AddHeader("Content-disposition", "filename=ShowSheetDetails.xls");
            Response.OutputStream.Write(buffer, 0, buffer.Length);
            Response.End();
        }

        //-----------------------------------------------------------------PurchaseOrder--------------------------------------------------------------------

        public ActionResult RemarkPopUp(int Booking_Sheet_Code, int Proposal_Code, string config)
        {         
            string InputArea = "";
            int Count = 0;
            int TotalCount = 0;
            string ValidationFlag = "";
            int ValidCount = 0;

            AL_Booking_Sheet_Details_Service objBooking_Sheet_Details_Service = new AL_Booking_Sheet_Details_Service(objLoginEntity.ConnectionStringName);

            ValidCount = objPurchase_Order_Service.SearchFor(s => true).Where(w => w.AL_Booking_Sheet_Code == Booking_Sheet_Code).Count();

            //Count = objBooking_Sheet_Details_Service.SearchFor(s => true).Where(w => w.Validations.ToUpper() == "MAN" && w.AL_Booking_Sheet_Code == Booking_Sheet_Code).Count();
            //TotalCount = objBooking_Sheet_Details_Service.SearchFor(s => true).Where(w => w.Validations.ToUpper() == "MAN" && w.Cell_Status == "C" &&w.AL_Booking_Sheet_Code == Booking_Sheet_Code).Count();

            Count = objBooking_Sheet_Details_Service.SearchFor(s => true).Where(w => (w.Validations.ToUpper().Contains("MAN") || w.Validations.ToUpper().Contains("PO")) && (w.Allow_Import == "I" || w.Allow_Import == "B") && w.AL_Booking_Sheet_Code == Booking_Sheet_Code).Count();
            TotalCount = objBooking_Sheet_Details_Service.SearchFor(s => true).Where(w => (w.Validations.ToUpper().Contains("MAN") || w.Validations.ToUpper().Contains("PO")) && (w.Allow_Import == "I" || w.Allow_Import == "B") && (w.Columns_Value != "" && w.Columns_Value != null)  && w.AL_Booking_Sheet_Code == Booking_Sheet_Code).Count();

            if (ValidCount > 0)
            {
                Session["config"] = config;
                Session["BookingSheetCode"] = Booking_Sheet_Code;
                return Json("Redirect");
            }
            else
            { 
                if (Count == TotalCount)
                {
                    ValidationFlag = "Y";
                }
                else
                {
                    ValidationFlag = "N";
                }

                if (ValidationFlag == "Y")
                {
                    InputArea = "<tr><td style=\"text-align:center\"><b>Remark : </b></td><td><textarea id=\"Remark\" rows=\"4\" cols=\"50\" style=\"width:90%;margin-top:2%;\"></textarea></td></tr>" +
                        "<tr><td colspan=\"2\" ><input type=\"button\" id=\"btnSave\" style=\"width:20%;margin:1% 40% 2% 40%;background-color: #2b64a5;\" value=\"Generate\" class=\"btn btn-primary\" onclick=\"GeneratePO(" + Booking_Sheet_Code + "," + Proposal_Code + ")\"></td></tr>";
                }
                else
                {
                    InputArea = "<tr><td style=\"text-align:center\"><p style=\"color:red\"><b>You cannot generate purchase order. Please check mandatory fields again..!</b></p></td></tr>";
                }
            }

            Session["BookingSheetCode"] = Booking_Sheet_Code;

         return Json(InputArea);
        }

        public JsonResult GeneratePO(int BookingSheetCode, int ProposalCode, string Remark)
        {
            string Status = "";
            string Message = "";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            AL_Purchase_Order objAPO = new AL_Purchase_Order();

            objAPO.AL_Booking_Sheet_Code = BookingSheetCode;
            objAPO.AL_Proposal_Code = ProposalCode;
            objAPO.Remarks = Remark;
            objAPO.Status = "P";
            objAPO.Inserted_By = objLoginUser.Users_Code;
            objAPO.Inserted_On = DateTime.Now;
            objAPO.Updated_By = objLoginUser.Users_Code;
            objAPO.Updated_On = DateTime.Now;

            objAPO.EntityState = State.Added;


            dynamic resultSet;
            if (!objPurchase_Order_Service.Save(objAPO, out resultSet))
            {
                Status = "E";
                Message = resultSet;
            }
            else
            {
                Status = "S";
                Message = "Purchase Order Generated Succesfully";
            }

            var Obj = new
            {
                Status = Status,
                Message = Message
            };
            return Json(Obj);
        }

        //-----------------------------------------------------------------GenericMethods--------------------------------------------------------------------

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

        public void ReportCredential()
        {
            ReportViewer ReportViewer1 = new ReportViewer();
            var rptCredetialList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

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

        public bool MyContains(object instance, string word)
        {
            return instance.GetType()
                    .GetProperties()
                    .Where(x => x.PropertyType == typeof(string))
                    .Select(x => (string)x.GetValue(instance, null))
                    .Where(x => x != null)
                    .Any(x => x.IndexOf(word, StringComparison.CurrentCultureIgnoreCase) >= 0);
        }

        public static DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties
            System.Reflection.PropertyInfo[] Props = typeof(T).GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);
            foreach (System.Reflection.PropertyInfo prop in Props)
            {
                //Defining type of data column gives proper data table 
                var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name, type);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }

        private string GenerateBsNumber()
        {
            string demo = "";
            string BS_No = objBooking_Sheet_Service.SearchFor(x => true).OrderByDescending(x => x.AL_Booking_Sheet_Code).Select(s => s.Booking_Sheet_No).FirstOrDefault();
            if (!string.IsNullOrEmpty(BS_No))
            {
                int lastAddedNo = Convert.ToInt32(BS_No.Substring(2));
                demo = Convert.ToString(lastAddedNo + 1).PadLeft(5, '0');
            }
            else
            {
                int lastAddedNo = 00000;
                demo = Convert.ToString(lastAddedNo + 1).PadLeft(5, '0');
            }
            
            return demo;
            // it will return 00009
        }
    }

    #region
    public class SelectedBKDetails
    {
        public DateTime MaxDate { get; set; }
        public int BookingSheetCode { get; set; }
        public string Client_Name { get; set; }
        public string Proposal_CY { get; set; }
        public string Cycle { get; set; }
    }

    public class SelectDmMasterCodeAndFiletType
    {
        public string FileType { get; set; }
        public int DmMasterImportCode { get; set; }
    }
    #endregion
}