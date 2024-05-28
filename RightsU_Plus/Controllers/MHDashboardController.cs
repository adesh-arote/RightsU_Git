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
using System.Data.Entity.Core.Objects;

namespace RightsU_Plus.Controllers
{
    public class MHDashboardController : BaseController
    {
        private List<RightsU_Entities.USPMHRequisitionList_Result> lst
        {
            get
            {
                if (Session["MHRequest"] == null)
                    Session["MHRequest"] = new List<RightsU_Entities.USPMHRequisitionList_Result>();
                return (List<RightsU_Entities.USPMHRequisitionList_Result>)Session["MHRequest"];
            }
            set { Session["MHRequest"] = value; }
        }
        private List<RightsU_Entities.USPMHGetChartPopupList_Result> lstChart
        {
            get
            {
                if (Session["lstMHChart"] == null)
                    Session["lstMHChart"] = new List<RightsU_Entities.USPMHGetChartPopupList_Result>();
                return (List<RightsU_Entities.USPMHGetChartPopupList_Result>)Session["lstMHChart"];
            }
            set { Session["lstMHChart"] = value; }
        }
   
        private List<RightsU_Entities.Vendor> lstVendor
        {
            get
            {
                if (Session["Vendor"] == null)
                    Session["Vendor"] = new List<RightsU_Entities.Vendor>();
                return (List<RightsU_Entities.Vendor>)Session["Vendor"];
            }
            set { Session["Vendor"] = value; }
        }
        private List<RightsU_Entities.MHRequest> lstMHRequest
        {
            get
            {
                if (Session["lstMHRequest"] == null)
                    Session["lstMHRequest"] = new List<RightsU_Entities.MHRequest>();
                return (List<RightsU_Entities.MHRequest>)Session["lstMHRequest"];
            }
            set { Session["lstMHRequest"] = value; }
        }
        private List<RightsU_Entities.MHRequestDetail> lstFilterRequest
        {
            get
            {
                if (Session["lstFilterRequest"] == null)
                    Session["lstFilterRequest"] = new List<RightsU_Entities.MHRequestDetail>();
                return (List<RightsU_Entities.MHRequestDetail>)Session["lstFilterRequest"];
            }
            set { Session["lstFilterRequest"] = value; }
        }

        private List<RightsU_Entities.MHRequestDetail> lstMHRequestDetails
        {
            get
            {
                if (Session["lstRequest"] == null)
                    Session["lstRequest"] = new List<RightsU_Entities.MHRequestDetail>();
                return (List<RightsU_Entities.MHRequestDetail>)Session["lstRequest"];
            }
            set { Session["lstRequest"] = value; }
        }

        public string LastRequiredDateForPieChart
        {
            get
            {
                if (Session["LastRequiredDateForPieChart"] == null)
                    Session["LastRequiredDateForPieChart"] = "";
                return (string)Session["LastRequiredDateForPieChart"];
            }
            set { Session["LastRequiredDateForPieChart"] = value; }
        }
        public string LastRequiredDateForBarChart
        {
            get
            {
                if (Session["LastRequiredDateForBarChart"] == null)
                    Session["LastRequiredDateForBarChart"] = "";
                return (string)Session["LastRequiredDateForBarChart"];
            }
            set { Session["LastRequiredDateForBarChart"] = value; }
        }
        public string DealTypeCodeForPieChart
        {
            get
            {
                if (Session["DealTypeCodeForPieChart"] == null)
                    Session["DealTypeCodeForPieChart"] = "";
                return (string)Session["DealTypeCodeForPieChart"];
            }
            set { Session["DealTypeCodeForPieChart"] = value; }
        }
        public string BUCodeForPieChart
        {
            get
            {
                if (Session["BUCodeForPieChart"] == null)
                    Session["BUCodeForPieChart"] = "";
                return (string)Session["BUCodeForPieChart"];
            }
            set { Session["BUCodeForPieChart"] = value; }
        }
        public string DealTypeCodeForBarChart
        {
            get
            {
                if (Session["DealTypeCodeForBarChart"] == null)
                    Session["DealTypeCodeForBarChart"] = "";
                return (string)Session["DealTypeCodeForBarChart"];
            }
            set { Session["DealTypeCodeForBarChart"] = value; }
        }
        public string BUCodeForBarChart
        {
            get
            {
                if (Session["BUCodeForBarChart"] == null)
                    Session["BUCodeForBarChart"] = "";
                return (string)Session["BUCodeForBarChart"];
            }
            set { Session["BUCodeForBarChart"] = value; }
        }
        
        public ViewResult Index()
        {
            List<SelectListItem> lstSort = new List<SelectListItem>();
                                      
            lstSort.Add(new SelectListItem { Text = "Current Month", Value = "M" });
            lstSort.Add(new SelectListItem { Text = "Current Quarter", Value = "Q" });
            lstSort.Add(new SelectListItem { Text = "Last 6 Motnhs", Value = "H" });
            lstSort.Add(new SelectListItem { Text = "Year To Date", Value = "Y" });

            ViewBag.SortType = lstSort;

            string strBUCodes = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BusinessUnitCodesForMHDashboard").Select(x => x.Parameter_Value).FirstOrDefault();
            string[] arrBUCodes = strBUCodes.Split(',');
            List<RightsU_Entities.Business_Unit> lstBU = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x=>x.Is_Active == "Y").ToList();
            List<RightsU_Entities.Business_Unit> lstBU1 = lstBU.Where(x => (arrBUCodes.Contains(x.Business_Unit_Code.ToString()))).ToList();
            ViewBag.Business_Unit_Code_All = string.Join(",", lstBU.Select(s => s.Business_Unit_Code).ToArray());
            //lstBU1.Insert(0,new SelectListItem() {Value = "0", Text = "All"})
            ViewBag.BU = new SelectList(lstBU1, "Business_Unit_Code", "Business_Unit_Name", 0);

            string strDealTypeCodes = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "DealTypeCodesForMHDashboard").Select(x => x.Parameter_Value).FirstOrDefault();
            string[] arrDealTypeCodes = strDealTypeCodes.Split(',');
            List<RightsU_Entities.Deal_Type> lstDealType = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
            List<RightsU_Entities.Deal_Type> lstDealType1 = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x=>(arrDealTypeCodes.Contains(x.Deal_Type_Code.ToString()))).ToList();
            ViewBag.Deal_Type_Codes_All = string.Join(",", lstDealType.Select(s => s.Deal_Type_Code).ToArray());
            ViewBag.ShowType = new SelectList(lstDealType1, "Deal_type_Code", "Deal_Type_Name");

           // lstMHRequest = new MHRequest_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            lstMHRequestDetails = new MHRequestDetails_Service(objLoginEntity.ConnectionStringName).SearchFor(x=>true && x.MHRequest.MHRequestTypeCode == 1).ToList();

            lstVendor = new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y"
                && s.Vendor_Role.Where(x => x.Role_Code == 9).Count() > 0).ToList();
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            lst = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequisitionList("", "", 1, "", "", "", "" ,"","", 1, 5, "", "", objRecordCount).ToList();        
            return View("~/Views/MHDashboard/Index.cshtml", lst);
        }
        public JsonResult GetChartData()
        {      
            List<PieChart> LstPie = new List<PieChart>();
            List<PieChart> objLstPie = new List<PieChart>();
            string[] VendorLst = null;
            int totalRecCount = 0;
            //int?[] a = lstMHRequest.Where(x => x.VendorCode != null && x.MHRequestTypeCode == 1).Select(x => x.VendorCode).Distinct().ToArray();
            int?[] a = lstFilterRequest.Where(x => x.MHRequest.VendorCode != null && x.MHRequest.MHRequestTypeCode == 1).Select(x => x.MHRequest.VendorCode).Distinct().ToArray();
            string[] Vendor_Lst = Array.ConvertAll(a,element => element.ToString());

          //  lstMHRequest = lstMHRequest.Where(x => x.MHRequestTypeCode == 1).ToList();  
            string VendorCodes = new USP_Service(objLoginEntity.ConnectionStringName).USPMHGetMaxVendorCodes(LastRequiredDateForPieChart, DealTypeCodeForPieChart,BUCodeForPieChart).FirstOrDefault();
            if (VendorCodes != null)
            {
                VendorLst = VendorCodes.Split(',');
            }          
                   
            if (VendorLst != null)
            {
                foreach (var item in VendorLst)
                {
                    PieChart objPie = new PieChart();                            
                    var objRecCount = lstFilterRequest.Where(x => x.MHRequest.VendorCode == Convert.ToInt32(item)).Count();
                    objPie.VendorName = lstVendor.Where(x => x.Vendor_Code == Convert.ToInt32(item) && item != null).Select(t => t.Vendor_Name).FirstOrDefault();
                    objPie.RequestCount = Convert.ToInt32(objRecCount);
                    objPie.VendorCodes = Convert.ToString(item);
                    LstPie.Add(objPie);
                }

                string[] OtherVendors = Vendor_Lst.Except(VendorLst).ToArray();

                foreach (var item in OtherVendors)
                {
                    PieChart objPie = new PieChart();
                    var objRecCount = lstFilterRequest.Where(x => x.MHRequest.VendorCode == Convert.ToInt32(item)).Count();
                    objPie.VendorName = lstVendor.Where(x => x.Vendor_Code == Convert.ToInt32(item) && item != null).Select(t => t.Vendor_Name).FirstOrDefault();
                    objPie.RequestCount = Convert.ToInt32(objRecCount);
                    objPie.VendorCodes = Convert.ToString(item);
                    objLstPie.Add(objPie);
                }

                totalRecCount = objLstPie.Sum(x => x.RequestCount);

                PieChart objectPie = new PieChart();
                objectPie.RequestCount = totalRecCount;
                objectPie.VendorName = "Others";
                var Vendor_Codes = objLstPie.Select(s => s.VendorCodes).ToArray();
                objectPie.VendorCodes = Convert.ToString(String.Join(",", Vendor_Codes));
                LstPie.Add(objectPie);
            }
                         
            return Json(LstPie, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetColumnChartData()
        {               
            List<ColumnChart> lstColumn = new List<ColumnChart>();
            List<ColumnChart> objLstColumn = new List<ColumnChart>();
            string[] VendorLst = null;

            int totalAApprovedCount = 0, totalPendingCount = 0, totalRejectedCount = 0, totalPartiallyApproved = 0;
            int?[] a = lstFilterRequest.Where(x => x.MHRequest.VendorCode != null && x.MHRequest.MHRequestTypeCode == 1).Select(x => x.MHRequest.VendorCode).Distinct().ToArray();
            string[] Vendor_Lst = Array.ConvertAll(a, element => element.ToString());

            string VendorCodes = new USP_Service(objLoginEntity.ConnectionStringName).USPMHGetMaxVendorCodes(LastRequiredDateForBarChart, DealTypeCodeForBarChart, BUCodeForBarChart).FirstOrDefault();
         
            lstMHRequest = lstMHRequest.Where(x => x.MHRequestTypeCode == 1).ToList();
            if (VendorCodes != null)
            {
                VendorLst = VendorCodes.Split(',');
            }      
          
            if (VendorLst != null)
            {
                foreach (var item in VendorLst)
                {
                    ColumnChart objColumnChart = new ColumnChart();
                    objColumnChart.VendorName = lstVendor.Where(x => x.Vendor_Code == Convert.ToInt32(item)).Select(t => t.Vendor_Name).FirstOrDefault();
                    objColumnChart.ApprovedCount = lstFilterRequest.Where(s => s.MHRequest.VendorCode == Convert.ToInt32(item) && s.MHRequest.MHRequestStatusCode == 1).Count();
                    objColumnChart.PendingCount = lstFilterRequest.Where(s => s.MHRequest.VendorCode == Convert.ToInt32(item) && s.MHRequest.MHRequestStatusCode == 2).Count();
                    objColumnChart.RejectedCount = lstFilterRequest.Where(s => s.MHRequest.VendorCode == Convert.ToInt32(item) && s.MHRequest.MHRequestStatusCode == 3).Count();
                    objColumnChart.PartiallyApproved = lstFilterRequest.Where(s => s.MHRequest.VendorCode == Convert.ToInt32(item) && s.MHRequest.MHRequestStatusCode == 4).Count();
                    lstColumn.Add(objColumnChart);
                }

                string[] OtherVendors = Vendor_Lst.Except(VendorLst).ToArray();

                foreach (var item in OtherVendors)
                {
                    ColumnChart objColumnChart = new ColumnChart();
                    objColumnChart.VendorName = lstVendor.Where(x => x.Vendor_Code == Convert.ToInt32(item)).Select(t => t.Vendor_Name).FirstOrDefault();
                    objColumnChart.ApprovedCount = lstFilterRequest.Where(s => s.MHRequest.VendorCode == Convert.ToInt32(item) && s.MHRequest.MHRequestStatusCode == 1).Count();
                    objColumnChart.PendingCount = lstFilterRequest.Where(s => s.MHRequest.VendorCode == Convert.ToInt32(item) && s.MHRequest.MHRequestStatusCode == 2).Count();
                    objColumnChart.RejectedCount = lstFilterRequest.Where(s => s.MHRequest.VendorCode == Convert.ToInt32(item) && s.MHRequest.MHRequestStatusCode == 3).Count();
                    objColumnChart.PartiallyApproved = lstFilterRequest.Where(s => s.MHRequest.VendorCode == Convert.ToInt32(item) && s.MHRequest.MHRequestStatusCode == 4).Count();
                    objLstColumn.Add(objColumnChart);
                }

                totalAApprovedCount = objLstColumn.Sum(x => x.ApprovedCount);
                totalPartiallyApproved = objLstColumn.Sum(x => x.PartiallyApproved);
                totalPendingCount = objLstColumn.Sum(x => x.PendingCount);
                totalRejectedCount = objLstColumn.Sum(x => x.RejectedCount);

                if (objLstColumn.Count != 0)
                {
                    ColumnChart objectColumn = new ColumnChart();
                    objectColumn.VendorName = "Others";
                    objectColumn.ApprovedCount = totalAApprovedCount;
                    objectColumn.PartiallyApproved = totalPartiallyApproved;
                    objectColumn.PendingCount = totalPendingCount;
                    objectColumn.RejectedCount = totalRejectedCount;

                    lstColumn.Add(objectColumn);
                }
            }

            return Json(lstColumn, JsonRequestBehavior.AllowGet);
        }

        public PartialViewResult BindGrid(string MHRequestCode = "",string VendorCodes = "", string DealType = "", string BU = "", string status = "", string callFor = "" ,int PageNo = 1, int recordPerPage = 10)
         {         
            if(callFor == "PieChart"){
                DealType = Convert.ToString(Session["DealTypeCodeForPieChart"]);
                BU = Convert.ToString(Session["BUCodeForPieChart"]);
                MHRequestCode = MHRequestCode + '~' + LastRequiredDateForPieChart;
            }
            else if(callFor == "BarChart")
            {
                DealType = Convert.ToString(Session["DealTypeCodeForBarChart"]);
                BU = Convert.ToString(Session["BUCodeForBarChart"]);
                MHRequestCode = MHRequestCode + '~' + LastRequiredDateForBarChart;
            }          
            string VendorName = "";                 
            if (callFor == "RecentRequest")
            {
                DealType = "";
                BU = "";
            }
               
            if (callFor == "BarChart" && VendorCodes != "Others")
            {
                var Vendor_Codes = lstVendor.Where(x => x.Vendor_Name == VendorCodes).Select(s => s.Vendor_Code).ToArray();
                VendorCodes = Convert.ToString(String.Join(",", Vendor_Codes));
                status = Convert.ToString(new MHRequestStatu_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.RequestStatusName == status).Select(t => t.MHRequestStatusCode).FirstOrDefault());
            }
            if (callFor == "BarChart" && VendorCodes == "Others")
            {
               
                int?[] a = lstFilterRequest.Where(x => x.MHRequest.VendorCode != null && x.MHRequest.MHRequestTypeCode == 1).Select(x => x.MHRequest.VendorCode).Distinct().ToArray();
                string[] VendorLst = Array.ConvertAll(a, element => element.ToString());
                string Vendor_Codes = new USP_Service(objLoginEntity.ConnectionStringName).USPMHGetMaxVendorCodes(LastRequiredDateForBarChart, DealType, BU).FirstOrDefault();
                string[] arrVendorCodes = Vendor_Codes.Split(',');
                string[] OtherVendorCodes = VendorLst.Except(arrVendorCodes).ToArray();

                VendorCodes = Convert.ToString(String.Join(",", OtherVendorCodes));
                status = Convert.ToString(new MHRequestStatu_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.RequestStatusName == status).Select(t => t.MHRequestStatusCode).FirstOrDefault());
            }
            if (callFor == "BarChart" || callFor == "PieChart")
            {
               
                string[] arrVendorCodes = VendorCodes.Split(',');
                if (arrVendorCodes.Length > 1)
                {
                    VendorName = "Others";
                }
                else
                {
                    VendorName = lstVendor.Where(x => x.Vendor_Code == Convert.ToInt32(VendorCodes)).Select(x => x.Vendor_Name).FirstOrDefault();
                }                
                ViewBag.VendorName = VendorName;
            }
           
            VendorCodes = VendorCodes.Replace('﹐', ',');
            status = status.Replace('﹐', ',');
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            lstChart = new USP_Service(objLoginEntity.ConnectionStringName).USPMHGetChartPopupList(MHRequestCode, VendorCodes, status, "", PageNo, recordPerPage, DealType, BU, objRecordCount).ToList();         
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = PageNo;
            ViewBag.callFor = callFor;
            ViewBag.PageSize = recordPerPage;

            return PartialView("~/Views/MHDashboard/_MHConsumptionList.cshtml", lstChart);
        }
        public JsonResult FetchPieChartData(string SortType = "M", string DealTypeCode = "", string BU = "")
        {           
            DateTime currentDate = DateTime.Now;
            DateTime lastDate ;
                              
                if (SortType == "M" && DealTypeCode != "" && BU != "")
                {
                    lastDate = DateTime.Now.AddMonths(-1);
                    string[] lst = DealTypeCode.Split(',');
                    string[] lstTitleCodes = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(w => lst.Contains(w.Deal_Type_Code.ToString())).Select(x => x.Title_Code.ToString()).ToArray();
                    string[] lst1 = BU.Split(',');
                    string[] lstTitleCodes1 = new Music_Deal_LinkShow_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lst1.Contains(x.Music_Deal.Business_Unit_Code.ToString())).Select(x => x.Title_Code.ToString()).ToArray();
                    lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate && (lstTitleCodes1.Contains(x.MHRequest.TitleCode.ToString())) && (lstTitleCodes.Contains(x.MHRequest.TitleCode.ToString()))).ToList();
                }
                else if(SortType == "M" && DealTypeCode == "" && BU == "")
                {
                    lastDate = DateTime.Now.AddMonths(-1);
                    lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate).ToList();
                }
                else if (SortType == "Q")
                {
                    lastDate = DateTime.Now.AddMonths(-3);
                    lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate).ToList();
                }
                else if (SortType == "H")
                {
                    lastDate = DateTime.Now.AddMonths(-6);
                    lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate).ToList();
                }
                else
                {
                    lastDate = DateTime.Now.AddYears(-1);
                    lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate).ToList();
                }
                if (DealTypeCode != "" && SortType == "")
                {
                    string[] lst = DealTypeCode.Split(',');
                    string[] lstTitleCodes = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(w => lst.Contains(w.Deal_Type_Code.ToString())).Select(x => x.Title_Code.ToString()).ToArray();
                    lstFilterRequest = lstMHRequestDetails.Where(x => (lstTitleCodes.Contains(x.MHRequest.TitleCode.ToString()))).ToList();
                }

                if (BU != "" && SortType == "")
                {
                    string[] lst = BU.Split(',');
                    string[] lstTitleCodes = new Music_Deal_LinkShow_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lst.Contains(x.Music_Deal.Business_Unit_Code.ToString())).Select(x => x.Title_Code.ToString()).ToArray();
                    lstFilterRequest = lstMHRequestDetails.Where(x => (lstTitleCodes.Contains(x.MHRequest.TitleCode.ToString()))).ToList();
                }
                if (SortType != "")
                {
                    LastRequiredDateForPieChart = lastDate.ToString();
                }
                else
                {
                    LastRequiredDateForPieChart = "";
                }

                Session["DealTypeCodeForPieChart"] = DealTypeCode.ToString();
                Session["BUCodeForPieChart"] = BU.ToString();
                                
            return Json("Success");
        }
        public JsonResult FetchBarChartData(string SortType = "M", string DealTypeCode = "", string BU = "")
        {
            DateTime currentDate = DateTime.Now;
            DateTime lastDate;

            if (SortType == "M" && DealTypeCode != "" && BU != "")
            {
                lastDate = DateTime.Now.AddMonths(-1);
                string[] lst = DealTypeCode.Split(',');
                string[] lstTitleCodes = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(w => lst.Contains(w.Deal_Type_Code.ToString())).Select(x => x.Title_Code.ToString()).ToArray();
                string[] lst1 = BU.Split(',');
                string[] lstTitleCodes1 = new Music_Deal_LinkShow_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lst1.Contains(x.Music_Deal.Business_Unit_Code.ToString())).Select(x => x.Title_Code.ToString()).ToArray();
                lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate && (lstTitleCodes1.Contains(x.MHRequest.TitleCode.ToString())) && (lstTitleCodes.Contains(x.MHRequest.TitleCode.ToString()))).ToList();           
            }
            else if (SortType == "M" && DealTypeCode == "" && BU == "")
            {
                lastDate = DateTime.Now.AddMonths(-1);
                lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate).ToList();
            }
            else if (SortType == "Q")
            {
                lastDate = DateTime.Now.AddMonths(-3);
                lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate).ToList();
            }
            else if (SortType == "H")
            {
                lastDate = DateTime.Now.AddMonths(-6);
                lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate).ToList();
            }
            else
            {
                lastDate = DateTime.Now.AddYears(-1);
                lstFilterRequest = lstMHRequestDetails.Where(x => x.MHRequest.RequestedDate <= currentDate && x.MHRequest.RequestedDate >= lastDate).ToList();
            }
            if (DealTypeCode != "" && SortType == "")
            {
                string[] lst = DealTypeCode.Split(',');
                string[] lstTitleCodes = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(w => lst.Contains(w.Deal_Type_Code.ToString())).Select(x => x.Title_Code.ToString()).ToArray();
                lstFilterRequest = lstMHRequestDetails.Where(x => (lstTitleCodes.Contains(x.MHRequest.TitleCode.ToString()))).ToList();
            }

            if (BU != "" && SortType == "")
            {
                string[] lst = BU.Split(',');
                string[] lstTitleCodes = new Music_Deal_LinkShow_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lst.Contains(x.Music_Deal.Business_Unit_Code.ToString())).Select(x => x.Title_Code.ToString()).ToArray();
                lstFilterRequest = lstMHRequestDetails.Where(x => (lstTitleCodes.Contains(x.MHRequest.TitleCode.ToString()))).ToList();
            }
            if (SortType != "")
            {
                LastRequiredDateForBarChart = lastDate.ToString();
            }
            else
            {
                LastRequiredDateForBarChart = "";
            }

            Session["DealTypeCodeForBarChart"] = DealTypeCode.ToString();
            Session["BUCodeForBarChart"] = BU.ToString();

            return Json("Success");
        }
      
    }
    public class PieChart
    {
        public string VendorName { get; set; }
        public int RequestCount { get; set; }
        public string VendorCodes { get; set; }
    }

    public class ColumnChart
    {
        public string VendorName { get; set; }
        public int ApprovedCount { get; set; }
        public int PendingCount { get; set; }
        public int RejectedCount { get; set; }
        public int PartiallyApproved { get; set; }        
    }
}