using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_BLL;
using System.Collections;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity;
using RightsU_Entities;

namespace RightsU_Plus.Controllers
{
    public class BVTitleMappingController : BaseController
    {
        private readonly BV_HouseId_Data_Service objBV_HouseId_Data_Service = new BV_HouseId_Data_Service();
        private readonly System_Parameter_NewService objSPNService = new System_Parameter_NewService();
        private readonly USP_Validate_Episode_Service objUSPService = new USP_Validate_Episode_Service();
        private readonly USP_UpdateContentHouseID_Service objUSP_UpdateContentHouseID_Service = new USP_UpdateContentHouseID_Service();        

        private List<RightsU_Dapper.Entity.BV_HouseId_Data> lstBVTitleMapping
        {
            get
            {
                if (Session["lstBVTitleMapping"] == null)
                    Session["lstBVTitleMapping"] = new List<RightsU_Dapper.Entity.BV_HouseId_Data>();
                return (List<RightsU_Dapper.Entity.BV_HouseId_Data>)Session["lstBVTitleMapping"];
            }
            set
            {
                Session["lstBVTitleMapping"] = value;
            }
        }
        private List<RightsU_Dapper.Entity.BV_HouseId_Data> lstBVTitleMapping_Searched
        {
            get
            {
                if (Session["lstBVTitleMapping_Searched"] == null)
                    Session["lstBVTitleMapping_Searched"] = new List<RightsU_Dapper.Entity.BV_HouseId_Data>();
                return (List<RightsU_Dapper.Entity.BV_HouseId_Data>)Session["lstBVTitleMapping_Searched"];
            }
            set
            {
                Session["lstBVTitleMapping_Searched"] = value;
            }
        }
        private RightsU_Dapper.Entity.BV_HouseId_Data objBVTitleMapping
        {
            get
            {
                if (objBVTitleMapping == null)
                    objBVTitleMapping = new RightsU_Dapper.Entity.BV_HouseId_Data();
                return (RightsU_Dapper.Entity.BV_HouseId_Data)objBVTitleMapping;
            }
            set
            {
                objBVTitleMapping = value;
            }
        }
        public ArrayList arrBVHouseIDDataMain
        {
            get
            {
                if (Session["arrBVHouseIDDataMain"] == null)
                    Session["arrBVHouseIDDataMain"] = new ArrayList();
                return (ArrayList)Session["arrBVHouseIDDataMain"];
            }
            set { Session["arrBVHouseIDDataMain"] = value; }
        }
        //private BV_HouseId_Data_Service objBVTitleMapping_Service
        //{
        //    get
        //    {
        //        if (objBVTitleMapping_Service == null)
        //            objBVTitleMapping_Service = new BV_HouseId_Data_Service(objLoginEntity.ConnectionStringName);
        //        return (BV_HouseId_Data_Service)objBVTitleMapping_Service;
        //    }
        //    set
        //    {
        //        objBVTitleMapping_Service = value;
        //    }
        //}
        string ConnectionString = Convert.ToString(((LoginEntity)System.Web.HttpContext.Current.Session[RightsU_Dapper.Entity.RightsU_Session.CurrentLoginEntity]).ConnectionStringName);

        public ActionResult Index()
        {
            //string Program_Category = Convert.ToString(objSPNService.GetList()
            //    .Where(x => x.Parameter_Name.ToUpper() == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault());

            string Program_Category = objSPNService.GetList().Where(s => s.Parameter_Name == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault();

            lstBVTitleMapping_Searched = lstBVTitleMapping = objBV_HouseId_Data_Service.GetList()
                .Where(x =>  x.Is_Mapped == "N" && (x.IsIgnore == "N" || x.IsIgnore == null) && (x.Program_Category != null && !Program_Category.Contains(x.Program_Category))).Distinct()
                .OrderByDescending(x=>x.InsertedOn).ToList();
            BindDDL();
            return View("~/Views/BVTitleMapping/Index.cshtml");
        }
        public PartialViewResult BindBVTitleMappingList(int pageNo, int recordPerPage)
        {
            List<RightsU_Dapper.Entity.BV_HouseId_Data> lst = new List<RightsU_Dapper.Entity.BV_HouseId_Data>();
            int RecordCount = 0;
            RecordCount = lstBVTitleMapping_Searched.Count;
            ViewBag.RecordCount = RecordCount;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstBVTitleMapping_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/BVTitleMapping/_BVTitleMappingList.cshtml", lst);
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
        public JsonResult SearchBVTitleMapping(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                string[] arrCodes = searchText.Split(',');
                lstBVTitleMapping_Searched = lstBVTitleMapping.Where(w => arrCodes.Contains(w.BV_HouseId_Data_Code.ToString())).ToList();
            }
            else
                lstBVTitleMapping_Searched = lstBVTitleMapping;

            var obj = new
            {
                Record_Count = lstBVTitleMapping_Searched.Count
            };
            return Json(obj);
        }
        private MultiSelectList BindBVTitle()
        {
        //    string Program_Category = Convert.ToString(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName)
        //        .SearchFor(x => x.Parameter_Name.ToUpper() == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault());
            string Program_Category = objSPNService.GetList().Where(s => s.Parameter_Name == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault();

            MultiSelectList lst = new MultiSelectList(objBV_HouseId_Data_Service.GetList()
                .Where(x => x.Is_Mapped == "N" && (x.IsIgnore == "N" || x.IsIgnore == null) && (x.Program_Category != null && !Program_Category.Contains(x.Program_Category)))
                .Select(i => new { BV_HouseId_Data_Code = i.BV_HouseId_Data_Code, BV_Title = i.BV_Title }).Distinct().ToList()
                , "BV_HouseId_Data_Code", "BV_Title", "Select some options");
            return lst;
        }
        public JsonResult BindDDL()
        {
            ViewBag.BVTitleName = BindBVTitle();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("BV_Title", ViewBag.BVTitleName);
            return Json(obj);
        }
        public JsonResult SearchBVTitle(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstBVTitleMapping_Searched = lstBVTitleMapping.Where(w => w.BV_Title.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstBVTitleMapping_Searched = lstBVTitleMapping;

            var obj = new
            {
                Record_Count = lstBVTitleMapping_Searched.Count
            };
            return Json(obj);
        }
        //public JsonResult PopulateTitleForMapping(string keyword)
        //{
        //    var result = objUSP_Service.USPPopulateTitleForMapping(keyword).ToList();
        //    return Json(result);
        //}
        public JsonResult PopulateTitleForMapping(string keyword)
        {
            var result = new RightsU_BLL.Title_Service(ConnectionString).SearchFor(x => x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Deal_Workflow_Status == "A" &&
                       AM.Title.Title_Name.ToUpper().Contains(keyword.ToUpper()) &&
                       AM.Acq_Deal.Deal_Type_Code == UTOFrameWork.FrameworkClasses.GlobalParams.Deal_Type_Movie)
                    ).Select(R => new { Mapping_Name = R.Title_Name, Mapping_Code = R.Title_Code }).ToList();
            return Json(result);
        }
        public ActionResult MapData(List<RightsU_Dapper.Entity.BV_HouseId_Data> lst)
        {
            List<RightsU_Dapper.Entity.BV_HouseId_Data> lstBV = new List<RightsU_Dapper.Entity.BV_HouseId_Data>();
            string Message = "", status = "";
            int? BV_Code = 0;
            string TITLE_Episode_No = "";
            bool valid = true;
            if (lst != null)
            {
                foreach (RightsU_Dapper.Entity.BV_HouseId_Data objBVHouseIDTemp in lst)
                {

                    //BV_HouseId_Data_Service objBVHouse_Service = new BV_HouseId_Data_Service(objLoginEntity.ConnectionStringName);
                    RightsU_Dapper.Entity.BV_HouseId_Data objBVHouseID = new RightsU_Dapper.Entity.BV_HouseId_Data();
                    objBVHouseID = objBV_HouseId_Data_Service.GetBV_HouseId_DataByID(objBVHouseIDTemp.BV_HouseId_Data_Code);
                    //objBVHouseID.EntityState = State.Modified;
                    var DealTitleCode = objBVHouseIDTemp.Mapped_Deal_Title_Code;
                    var EpisodeNo =  objBVHouseIDTemp.Episode_No;
                    if (objBVHouseIDTemp.IsIgnore == "N" && objBVHouseIDTemp.Is_Mapped == "True")
                    {
                        EpisodeNo = EpisodeNo == "" ? "1" : EpisodeNo;
                        TITLE_Episode_No += DealTitleCode + "~" + EpisodeNo + ",";
                    }
                    TITLE_Episode_No = TITLE_Episode_No.Trim(',');
                    //USP_Service objUS = null;
                    //objUS = new USP_Service(objLoginEntity.ConnectionStringName);
                    List<RightsU_Dapper.Entity.USP_Validate_Episode_Result> objTitleCnt = objUSPService.USP_Validate_Episode(TITLE_Episode_No,"M").ToList();
                    int result_count = objTitleCnt.Count;
                    if (result_count > 0)
                    {
                        valid = false;
                        status = "E";
                        Message = "Please select valid Deal Title";
                        BV_Code = objBVHouseID.BV_HouseId_Data_Code;
                    }
                    else
                    {
                        valid = true;
                        TITLE_Episode_No = "";
                    }
                    if (valid == true)
                    {
                        if (objBVHouseIDTemp.IsIgnore == "Y")
                        {
                            objBVHouseID.IsIgnore = "Y";
                            objBVHouseID.Is_Mapped = "N";
                            objBVHouseID.Mapped_Deal_Title_Code = objBVHouseIDTemp.Mapped_Deal_Title_Code;
                        }
                        else
                        {
                            objBVHouseID.IsIgnore = "N";
                            objBVHouseID.Is_Mapped = "Y";
                            objBVHouseID.Mapped_Deal_Title_Code = objBVHouseIDTemp.Mapped_Deal_Title_Code;
                        }
                        if (objBVHouseID.Mapped_Deal_Title_Code.ToString() == "")
                        {
                            status = "E";
                            Message = "Please select either Ignore or Deal title to Map";
                        }
                        else
                        {
                            objBV_HouseId_Data_Service.AddEntity(objBVHouseID);
                            //new USP_Service(objLoginEntity.ConnectionStringName).USP_UpdateContentHouseID(objBVHouseID.BV_HouseId_Data_Code, objBVHouseID.Mapped_Deal_Title_Code);
                            objUSP_UpdateContentHouseID_Service.USP_UpdateContentHouseID(objBVHouseID.BV_HouseId_Data_Code, objBVHouseID.Mapped_Deal_Title_Code);
                            int before = lstBVTitleMapping_Searched.Count();
                            RightsU_Dapper.Entity.BV_HouseId_Data objRemove = lstBVTitleMapping_Searched.Where(i => i.BV_HouseId_Data_Code == objBVHouseID.BV_HouseId_Data_Code).FirstOrDefault();
                            if (objRemove != null)
                            {
                                lstBVTitleMapping_Searched.Remove(objRemove);
                                int AfterDelete = lstBVTitleMapping_Searched.Count();
                                status = "S";
                                Message = "BV Title Mapped successfully";
                            }
                        }
                    }
                }
            }
            BindBVTitleMappingList(1, 10);
            var obj =
             new
             {
                 valid = valid,
                 BV_Code = BV_Code,
                 Message = Message,
                 status = status
             };
            BindBVTitle();

            return Json(obj);
        }
        
    }
}
