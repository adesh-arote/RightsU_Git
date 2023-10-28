using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class PurchaseOrderController : BaseController
    {
        #region --- Properties ---
       
        private List<USPAL_GetPurchaseOrderList_Result> lstPO
        {
            get
            {
                if (Session["lstPO"] == null)
                    Session["lstPO"] = new List<USPAL_GetPurchaseOrderList_Result>();
                return (List<USPAL_GetPurchaseOrderList_Result>)Session["lstPO"];
            }
            set { Session["lstPO"] = value; }
        }

        List<USPAL_GetPurchaseOrderList_Result> lstPOSearched
        {
            get
            {
                if (Session["lstPOSearched"] == null)
                    Session["lstPOSearched"] = new List<USPAL_GetPurchaseOrderList_Result>();
                return (List<USPAL_GetPurchaseOrderList_Result>)Session["lstPOSearched"];
            }
            set
            {
                Session["lstPOSearched"] = value;
            }
        }

        private AL_Purchase_Order_Service objPO_Service
        {
            get
            {
                if (Session["objPO_Service"] == null)
                    Session["objPO_Service"] = new AL_Purchase_Order_Service(objLoginEntity.ConnectionStringName);
                return (AL_Purchase_Order_Service)Session["objPO_Service"];
            }
            set { Session["objPO_Service"] = value; }
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        private List<RightsU_Entities.AL_Purchase_Order_Details> lstMovieTabData
        {
            get
            {
                if (Session["lstMovieTabData"] == null)
                    Session["lstMovieTabData"] = new List<RightsU_Entities.AL_Purchase_Order_Details>();
                return (List<RightsU_Entities.AL_Purchase_Order_Details>)Session["lstMovieTabData"];
            }
            set { Session["lstMovieTabData"] = value; }
        }

        private List<RightsU_Entities.AL_Purchase_Order_Details> lstShowTabData
        {
            get
            {
                if (Session["lstShowTabData"] == null)
                    Session["lstShowTabData"] = new List<RightsU_Entities.AL_Purchase_Order_Details>();
                return (List<RightsU_Entities.AL_Purchase_Order_Details>)Session["lstShowTabData"];
            }
            set { Session["lstShowTabData"] = value; }
        }

        List<RightsU_Entities.AL_Purchase_Order_Details> lstMovieDataSearched
        {
            get
            {
                if (Session["lstMovieDataSearched"] == null)
                    Session["lstMovieDataSearched"] = new List<RightsU_Entities.AL_Purchase_Order_Details>();
                return (List<RightsU_Entities.AL_Purchase_Order_Details>)Session["lstMovieDataSearched"];
            }
            set
            {
                Session["lstMovieDataSearched"] = value;
            }
        }

        List<RightsU_Entities.AL_Purchase_Order_Details> lstShowDataSearched
        {
            get
            {
                if (Session["lstShowDataSearched"] == null)
                    Session["lstShowDataSearched"] = new List<RightsU_Entities.AL_Purchase_Order_Details>();
                return (List<RightsU_Entities.AL_Purchase_Order_Details>)Session["lstShowDataSearched"];
            }
            set
            {
                Session["lstShowDataSearched"] = value;
            }
        }

        private AL_Purchase_Order_Details_Service objPoDetailsData_Service
        {
            get
            {
                if (Session["objPoDetailsData_Service"] == null)
                    Session["objPoDetailsData_Service"] = new AL_Purchase_Order_Details_Service(objLoginEntity.ConnectionStringName);
                return (AL_Purchase_Order_Details_Service)Session["objPoDetailsData_Service"];
            }
            set { Session["objPoDetailsData_Service"] = value; }
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        private AL_Purchase_Order_Rel_Service objPORel_Serice
        {
            get
            {
                if (Session["objPORel_Serice"] == null)
                    Session["objPORel_Serice"] = new AL_Purchase_Order_Rel_Service(objLoginEntity.ConnectionStringName);
                return (AL_Purchase_Order_Rel_Service)Session["objPORel_Serice"];
            }
            set { Session["objPORel_Serice"] = value; }
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        private PoDetails objPoD
        {
            get
            {
                if (Session["objPoD"] == null)
                    Session["objPoD"] = new PoDetails();
                return (PoDetails)Session["objPoD"];
            }
            set { Session["objPoD"] = value; }
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        private List<USPAL_GetRevisionHistoryForModule_Result> lstStatusHistory
        {
            get
            {
                if (Session["lstStatusHistory"] == null)
                    Session["lstStatusHistory"] = new List<USPAL_GetRevisionHistoryForModule_Result>();
                return (List<USPAL_GetRevisionHistoryForModule_Result>)Session["lstStatusHistory"];
            }
            set { Session["lstStatusHistory"] = value; }
        }

        List<USPAL_GetRevisionHistoryForModule_Result> lstStatusHistorySearched
        {
            get
            {
                if (Session["lstStatusHistorySearched"] == null)
                    Session["lstStatusHistorySearched"] = new List<USPAL_GetRevisionHistoryForModule_Result>();
                return (List<USPAL_GetRevisionHistoryForModule_Result>)Session["lstStatusHistorySearched"];
            }
            set
            {
                Session["lstStatusHistorySearched"] = value;
            }
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        private ApprovalDetails objApDetails
        {
            get
            {
                if (Session["objApDetails"] == null)
                    Session["objApDetails"] = new ApprovalDetails();
                return (ApprovalDetails)Session["objApDetails"];
            }
            set { Session["objobjApDetailsPoD"] = value; }
        }

        #endregion

        //-----------------------------------------------------Purchase Order--------------------------------------------------------------------------------

        public ActionResult Index(int BookingSheetCode = 0)
        {
            //int BookingSheetCode = 0;
            if(BookingSheetCode == 0)
            {
                Session["BookingSheetCode"] = null;
                Session["config"] = null;
            }

            if (Session["BookingSheetCode"] != null)
            {                                            
                BookingSheetCode = Convert.ToInt32(Session["BookingSheetCode"]);
                //Session["BookingSheetCode"] = null;
            }
            if(Session["config"] != null)
            {
                string config = "";
                config = Convert.ToString(Session["config"]);
            }
            
            POData(BookingSheetCode);

            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Booking Sheet No Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Booking Sheet No Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            if (Session["Message"] != null)
            {                                            //-----To show success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }
            return View();
        }

        private void POData(int BookingSheetCode = 0)
        {
            if (BookingSheetCode > 0)
            {
                lstPOSearched = lstPO = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetPurchaseOrderList(objLoginUser.Users_Code).Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).ToList();
            }
            else
            {
                lstPOSearched = lstPO = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetPurchaseOrderList(objLoginUser.Users_Code).ToList();
            }
        }

        public ActionResult BindPOList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetPurchaseOrderList_Result> lst = new List<USPAL_GetPurchaseOrderList_Result>();

            int RecordCount = 0;
            RecordCount = lstPOSearched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstPOSearched.OrderByDescending(o => o.Inserted_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (sortType == "NA")
                    lst = lstPOSearched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (sortType == "ND")
                    lst = lstPOSearched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            if (Session["config"] != null)
            {
                string config = "";
                config = Convert.ToString(Session["config"]);
                ViewBag.Configuration = config;
            }

            return PartialView("_PurchaseOrderList", lst);
        }

        public JsonResult SearchPOList(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstPOSearched = lstPO.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToUpper().Contains(searchText.ToUpper()) || (w.Booking_Sheet_No != null && w.Booking_Sheet_No.ToUpper().Contains(searchText.ToUpper()))).ToList();
            }
            else
                lstPOSearched = lstPO;

            var obj = new
            {
                Record_Count = lstPOSearched.Count
            };

            return Json(obj);
        }

        //-----------------------------------------------------Purchase Order Details------------------------------------------------------------------------

        public ActionResult BindPODetails(int Purchase_Order_Code, int Proposal_Code, string View)
        {
            USPAL_GetPurchaseOrderList_Result objPO = new USPAL_GetPurchaseOrderList_Result();
            objPO = lstPO.Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code).FirstOrDefault();

            objPoD.Client_Name = objPO.Vendor_Name;
            objPoD.Booking_sheet_No = objPO.Booking_Sheet_No;
            objPoD.Proposal_Cy = objPO.Proposal_CY;
            objPoD.Created_On = Convert.ToDateTime(objPO.Inserted_On);
            objPoD.Purchase_Order_Code = objPO.AL_Purchase_Order_Code;
            objPoD.Proposal_Code = objPO.AL_Proposal_Code;

            objApDetails = null;
            objApDetails.IsApproved = objPO.Workflow_Status;

            MovieTabData();
            ShowTabData();

            ViewBag.ViewName = View; 

            return PartialView("_PoDetailsView");
        }

        private void MovieTabData()
        {
            objPoDetailsData_Service = null;
            System_Parameter_New Movies_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Movies").FirstOrDefault();
            List<string> lstMovieCode = Movies_system_Parameter.Parameter_Value.Split(',').ToList();
            lstMovieDataSearched = lstMovieTabData = objPoDetailsData_Service.SearchFor(x => true).Where(w => lstMovieCode.Any(a => w.Title.Deal_Type_Code.ToString() == a)).ToList();
        }

        private void ShowTabData()
        {
            objPoDetailsData_Service = null;
            System_Parameter_New Show_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Show").FirstOrDefault();
            List<string> lstShowCode = Show_system_Parameter.Parameter_Value.Split(',').ToList();
            lstShowDataSearched = lstShowTabData = objPoDetailsData_Service.SearchFor(x => true).Where(w => lstShowCode.Any(a => w.Title.Deal_Type_Code.ToString() == a)).ToList();
        }

        public JsonResult SearchPoDetails(string IncludeHoldover, string TabName, int Purchase_Order_Code, int Proposal_Code)
        {
            List<AL_Purchase_Order_Details> lstPOD = new List<AL_Purchase_Order_Details>();
            List<AL_Purchase_Order_Rel> lstPOR = new List<AL_Purchase_Order_Rel>();

            int recordcount = 0;
            if (TabName == "MV")
            {
                MovieTabData();
                if (IncludeHoldover == "Y")
                {           
                    lstPOD = lstMovieTabData.Where(w => w.AL_Proposal_Code == Proposal_Code).ToList();
                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code && (w.Status == "H" || w.Status == "N")).ToList();
                    lstMovieDataSearched = lstPOD.Where(w => lstPOR.Any(a => w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code)).ToList();
                    recordcount = lstMovieDataSearched.Count();
                }
                else
                {
                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code && w.Status == "N").ToList();
                    lstMovieDataSearched = lstMovieTabData.Where(w => lstPOR.Any(a => w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code) && w.AL_Proposal_Code == Proposal_Code).ToList();
                    recordcount = lstMovieDataSearched.Count();
                }
            }
            else if (TabName == "SH")
            {
                ShowTabData();
                if (IncludeHoldover == "Y")
                {
                    lstPOD = lstShowTabData.Where(w => w.AL_Proposal_Code == Proposal_Code).ToList();
                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code && (w.Status == "H" || w.Status == "N")).ToList();
                    lstShowDataSearched = lstPOD.Where(w => lstPOR.Any(a => w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code)).GroupBy(g => g.PO_Number).Select(s => s.FirstOrDefault()).ToList();
                    recordcount = lstShowDataSearched.Count();
                }
                else
                {
                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code && w.Status == "N").ToList();
                    lstShowDataSearched = lstShowTabData.Where(w => lstPOR.Any(a => (w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code) && w.AL_Proposal_Code == Proposal_Code)).GroupBy(g => g.PO_Number).Select(s => s.FirstOrDefault()).ToList();
                    recordcount = lstShowDataSearched.Count();
                }
            }

            var obj = new
            {
                Record_Count = recordcount,
            };
            return Json(obj);
        }

        public ActionResult BindMovieTabData(int pageNo, int recordPerPage, string sortType)
        {
            string message = "";
            int RecordCount = 0;
            List<AL_Purchase_Order_Details> lst = new List<AL_Purchase_Order_Details>();

            try
            {              
                RecordCount = lstMovieDataSearched.Count;

                if (RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    if (sortType == "T")
                        lst = lstMovieDataSearched.OrderByDescending(o => o.Generated_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else
                {
                    lst = lstMovieDataSearched;
                }
                //DataTable dt = ToDataTable(lst);
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }
            return PartialView("_MovieTabDataView", lst);
        }

        public ActionResult BindShowTabData(int pageNo, int recordPerPage, string sortType)
        {
            string message = "";
            int RecordCount = 0;
            List<AL_Purchase_Order_Details> lst = new List<AL_Purchase_Order_Details>();
          
            try
            {
                RecordCount = lstShowDataSearched.Count;
              
                if (RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    if (sortType == "T")
                        lst = lstShowDataSearched.OrderByDescending(o => o.Generated_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else
                {
                    lst = lstShowDataSearched;
                }
                //DataTable dt = ToDataTable(lst);
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }
            return PartialView("_ShowTabDataView", lst);
        }

        //-------------------------------------------------Refresh PO/POD and GetStatus----------------------------------------------------------------------

        public JsonResult GetPurchaseOrderStatus(int PurchaseOrderCode)
        {
            //AL_Purchase_Order PO = new AL_Purchase_Order();
            //PO = new AL_Purchase_Order_Service(objLoginEntity.ConnectionStringName).GetById(PurchaseOrderCode);            

            USPAL_GetPurchaseOrderList_Result PO = new USPAL_GetPurchaseOrderList_Result();
            PO = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetPurchaseOrderList(objLoginUser.Users_Code).Where(w => w.AL_Purchase_Order_Code == PurchaseOrderCode).FirstOrDefault();

            var obj = new
            {
                RecordStatus = PO.Status,
                WorkflowStatus = PO.Workflow_Status,
                ApprovalStatus = PO.Final_PO_Workflow_Status,
                ShowHideButtons = PO.ShowHideButtons,
                InsertedBy = PO.Inserted_By
            };
            return Json(obj);
        }

        public JsonResult GetPurchaseOrderDetailStatus(int PurchaseOrderDetailCode)
        {
            string recordStatus = new AL_Purchase_Order_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.AL_Purchase_Order_Details_Code == PurchaseOrderDetailCode).Select(s => s.Status).FirstOrDefault();

            var obj = new
            {
                RecordStatus = recordStatus,
            };
            return Json(obj);
        }

        public JsonResult RefreshPoList(int PurchaseOrderCode, int BookingSheetCode)
        {
            string status = "S", message = "", FlagStatus = "";

            AL_Purchase_Order obj_AL_Purchase_Order = new AL_Purchase_Order();
            obj_AL_Purchase_Order = objPO_Service.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == PurchaseOrderCode).FirstOrDefault();
            
            RefreshPOD(PurchaseOrderCode, out FlagStatus);
            if (FlagStatus == "N")
            {
                obj_AL_Purchase_Order.Status = "I";
                obj_AL_Purchase_Order.EntityState = State.Modified;

                dynamic resultSet;
                if (!objPO_Service.Save(obj_AL_Purchase_Order, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    status = "S";
                    message = objMessageKey.Recordsavedsuccessfully;
                    var a = lstPOSearched.Where(w => w.AL_Purchase_Order_Code == PurchaseOrderCode).FirstOrDefault();
                    a.Status = "I";

                    obj_AL_Purchase_Order = null;
                    objPO_Service = null;

                    //POData(BookingSheetCode);
                }
            }
            else if(FlagStatus == "H")
            {
                status = "I";
                message = "Purchase order already generated with holdover data";
            }
            else
            {
                status = "I";
                message = "Purchase order contains deleted data, It Cannot be refreshed.";
            }

            var obj = new
            {
                RecordCount = lstPOSearched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public void RefreshPOD(int PurchaseOrderCode, out string FlagStatus)
        {
            FlagStatus = "";
            List<AL_Purchase_Order_Details>  lst_AL_Purchase_Order_Details = new List<AL_Purchase_Order_Details>();
            List<AL_Purchase_Order_Rel> lstPOR = new List<AL_Purchase_Order_Rel>();
            List<AL_Purchase_Order_Rel> lstPORALL = new List<AL_Purchase_Order_Rel>();
            lstPORALL = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == PurchaseOrderCode).ToList();
            if(lstPORALL.Count > 0)
            {
                if(!lstPORALL.Exists(e=>e.Status == "N"))
                {
                    if (lstPORALL.Exists(e => e.Status == "H"))
                    {
                        FlagStatus = "H";
                    }
                }
                else
                {
                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == PurchaseOrderCode && w.Status == "N").ToList();
                    lst_AL_Purchase_Order_Details = objPoDetailsData_Service.SearchFor(s => true).ToList();
                    lst_AL_Purchase_Order_Details = lst_AL_Purchase_Order_Details.Where(w => lstPOR.Any(a => w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code)).ToList();

                    foreach (AL_Purchase_Order_Details obj_AL_Purchase_Order_Details in lst_AL_Purchase_Order_Details)
                    {
                        obj_AL_Purchase_Order_Details.Status = "P";
                        obj_AL_Purchase_Order_Details.EntityState = State.Modified;

                        dynamic resultSet;
                        objPoDetailsData_Service.Save(obj_AL_Purchase_Order_Details, out resultSet);
                    }
                    FlagStatus = "N";
                } 
            }             
        }

        //-----------------------------------------------------GetFileNameToDownload------------------------------------------------------------------------

        //public JsonResult GetFileName(int PurchaseOrderDetailCode)
        //{
        //    AL_Purchase_Order_Details_Service objAPOD_Service = new AL_Purchase_Order_Details_Service(objLoginEntity.ConnectionStringName);
        //
        //    string Filename = objAPOD_Service.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Details_Code == PurchaseOrderDetailCode).Select(s => s.PDF_File_Name).FirstOrDefault();
        //
        //    return Json(Filename);
        //}

        public JsonResult ValidateDownload(int PurchaseOrderDetailCode)
        {
            AL_Purchase_Order_Details_Service objAPOD_Service = new AL_Purchase_Order_Details_Service(objLoginEntity.ConnectionStringName);
            string Filename = objAPOD_Service.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Details_Code == PurchaseOrderDetailCode).Select(s => s.PDF_File_Name).FirstOrDefault();
            string FilePath = ConfigurationManager.AppSettings["DownloadReportPath"];
            string path = HttpContext.Server.MapPath(FilePath + Filename);
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

        public void DownloadFile(int PurchaseOrderDetailCode)
        {
            string DownloadPath = ConfigurationManager.AppSettings["DownloadReportPath"];
            AL_Purchase_Order_Details_Service objAPOD_Service = new AL_Purchase_Order_Details_Service(objLoginEntity.ConnectionStringName);
            string Filename = objAPOD_Service.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Details_Code == PurchaseOrderDetailCode).Select(s => s.PDF_File_Name).FirstOrDefault();
            string filePath = HttpContext.Server.MapPath(DownloadPath + Filename);

            WebClient client = new WebClient();
            Byte[] buffer = client.DownloadData(filePath);
            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "Attachment;filename=" + Filename);
            Response.BinaryWrite(buffer);

            Response.End();
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        public ActionResult ResendForApproval(int PurchaseOrderCode, string Remark)
        {
            string status = "";
            string message = "";
            string ModuleCode = GlobalParams.ModuleCodeForPurchaseOrder.ToString();

            try
            {
                new USP_Service(objLoginEntity.ConnectionStringName).USP_Assign_Workflow(PurchaseOrderCode, Convert.ToInt32(ModuleCode), Convert.ToInt32(objLoginUser.Users_Code), Remark);
                status = "S";
                message = "Purchase Order sent for approval successfully.";
            }
            catch (Exception ex)
            {

                status = "E";
                message = ex.Message;
            }

            var Obj = new
            {
                Status = status,
                Message = message
            };
            return Json(Obj);
        }

        public ActionResult ApproveOrReject(int PurchaseOrderCode, string User_Action, string Remark)
        {
            string status = "";
            string message = "";
            string ModuleCode = GlobalParams.ModuleCodeForPurchaseOrder.ToString();

            try
            {
                new USP_Service(objLoginEntity.ConnectionStringName).USP_Process_Workflow(PurchaseOrderCode, Convert.ToInt32(ModuleCode), Convert.ToInt32(objLoginUser.Users_Code), User_Action, Remark);
                status = "S";
                if(User_Action == "A")
                {
                    message = "You approved Purchase Order.";
                }
                else
                {
                    message = "You rejected Purchase Order.";
                }
            }
            catch (Exception ex)
            {

                status = "E";
                message = ex.Message;
            }

            var Obj = new
            {
                Status = status,
                Message = message
            };
            return Json(Obj);
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        public PartialViewResult OpenStatusHistoryPopup(int PurchaseOrderCode = 0)
        {
            USPAL_GetRevisionHistoryForModule_Result objMSHistory = new USPAL_GetRevisionHistoryForModule_Result();
            string ModuleCode = GlobalParams.ModuleCodeForPurchaseOrder.ToString();

            lstStatusHistorySearched = lstStatusHistory = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetRevisionHistoryForModule(PurchaseOrderCode, Convert.ToInt32(ModuleCode)).ToList();

            return PartialView("~/Views/PurchaseOrder/_StatusHistoryPopup.cshtml", objMSHistory);
        }

        public JsonResult SearchStatusHistory(int PurchaseOrderCode = 0)
        {
            lstStatusHistorySearched = lstStatusHistory;

            var obj = new
            {
                Record_Count = lstStatusHistorySearched.Count
            };

            return Json(obj);
        }

        public ActionResult BindStatusHistoryList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetRevisionHistoryForModule_Result> lst = new List<USPAL_GetRevisionHistoryForModule_Result>();

            int RecordCount = 0;
            RecordCount = lstStatusHistorySearched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstStatusHistorySearched.OrderByDescending(o => o.Module_Status_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("_StatusHistoryList", lst);
        }

        //--------------------------------------------------------GenericMethods-----------------------------------------------------------------------------

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

    }

    public class PoDetails
    {
        public string Client_Name { get; set; }
        public string Booking_sheet_No { get; set; }
        public string Proposal_Cy { get; set; }
        public DateTime Created_On { get; set; }
        public int Purchase_Order_Code { get; set; }
        public int? Proposal_Code { get; set; }
    }

    public class ApprovalDetails
    {
        public string IsApproved { get; set; }
    }
}