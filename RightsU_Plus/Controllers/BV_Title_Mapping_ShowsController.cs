using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Web.Mail;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;

namespace RightsU_Plus.Controllers
{
    public class BV_Title_Mapping_ShowsController : BaseController
    {
        string Program_Category = "";
        public string BV_HouseID_Data
        {
            get
            {
                if (Session["BV_HouseID_Data"] == null)
                    Session["BV_HouseID_Data"] = "";
                return (string)Session["BV_HouseID_Data"];
            }
            set { Session["BV_HouseID_Data"] = value; }
        }
        public string BV_Title { get; set; }
        public string MappedName
        {
            get
            {
                if (Session["MappedName"] == null)
                    Session["MappedName"] = "";
                return (string)Session["MappedName"];
            }
            set { Session["MappedName"] = value; }
        }
        public string EpisodeNo
        {
            get
            {
                if (Session["EpisodeNo"] == null)
                    Session["EpisodeNo"] = "";
                return (string)Session["EpisodeNo"];
            }
            set { Session["EpisodeNo"] = value; }
        }
        
        private List<RightsU_Entities.BV_HouseId_Data> lstBVHouseIDData
        {
            get
            {
                if (Session["lstBVHouseIDData"] == null)
                    Session["lstBVHouseIDData"] = new List<RightsU_Entities.BV_HouseId_Data>();
                return (List<RightsU_Entities.BV_HouseId_Data>)Session["lstBVHouseIDData"];
            }
            set { Session["lstBVHouseIDData"] = value; }
        }
        private List<RightsU_Entities.BV_HouseId_Data> lstBVHouseIDDataSearch
        {
            get
            {
                if (Session["lstBVHouseIDDataSearch"] == null)
                    Session["lstBVHouseIDDataSearch"] = new List<RightsU_Entities.BV_HouseId_Data>();
                return (List<RightsU_Entities.BV_HouseId_Data>)Session["lstBVHouseIDDataSearch"];
            }
            set { Session["lstBVHouseIDDataSearch"] = value; }
        }
        public ActionResult Index()
        {
            FetchData();
            Program_Category = Convert.ToString(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault());
            lstBVHouseIDDataSearch =  new BV_HouseId_Data_Service(objLoginEntity.ConnectionStringName)
                                .SearchFor(w => w.Is_Mapped == "N" && (w.IsIgnore == "N" || w.IsIgnore== null) && Program_Category.Contains(w.Program_Category))
                                .OrderByDescending(o=>o.InsertedOn).Distinct().ToList();

            BindDDL();
            return View("~/Views/BV_Title_Mapping_Shows/Index.cshtml");
        }
        public PartialViewResult BindTitleMappingShows(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.BV_HouseId_Data> lst = new List<RightsU_Entities.BV_HouseId_Data>();
            int RecordCount = 0;
            RecordCount = lstBVHouseIDDataSearch.Count;
            ViewBag.RecordCount = lstBVHouseIDDataSearch.Count;


            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstBVHouseIDDataSearch.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("~/Views/BV_Title_Mapping_Shows/_BV_Title_Mapping_ShowsList.cshtml", lst);
        }

        public JsonResult SearchBVTitleMapping(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                string[] arrCodes = searchText.Split(',');
                lstBVHouseIDDataSearch = lstBVHouseIDData.Where(w => arrCodes.Contains(w.BV_Title.ToString())).ToList();
            }
            else
                lstBVHouseIDDataSearch = lstBVHouseIDData;
            ViewBag.RecordCount = lstBVHouseIDDataSearch.Count;
            var obj = new
            {
                Record_Count = lstBVHouseIDDataSearch.Count
            };
            return Json(obj);
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
        public void FetchData()
        {
            string program_category = Convert.ToString(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault());
            lstBVHouseIDDataSearch = lstBVHouseIDData = new BV_HouseId_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Mapped == "N" && (w.IsIgnore == null || w.IsIgnore == "N") && program_category.Contains(w.Program_Category)).OrderByDescending(x=>x.InsertedOn).ToList();
        }
        private MultiSelectList BindBVTitle()
        {
            string Program_Category = Convert.ToString(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault());

            MultiSelectList lst = new MultiSelectList(new BV_HouseId_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Mapped == "N" && (x.IsIgnore == "N" || x.IsIgnore == null) && Program_Category.Contains(x.Program_Category)).OrderBy(o => o.BV_Title).Select(i => new { BV_Title = i.BV_Title }).Distinct().ToList(), "BV_Title", "BV_Title", "Select some options");
            return lst;
        }
        public JsonResult BindDDL()
        {
            ViewBag.BVTitleName = BindBVTitle();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("BV_Title", ViewBag.BVTitleName);
            return Json(obj);
        }
        //public ActionResult GetDealTitles(string keyword, string scheduleDate_Time)
        //{
        //    DateTime dtSchedule = Convert.ToDateTime(scheduleDate_Time);
        //    USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
        //    List<USP_GET_TITLE_DATA_Result> arrDealTitlesEPS = objUS.USP_GET_TITLE_DATA(keyword, 0).ToList();
        //    List<string> LstDealTitles = new List<string>();
        //    var result = (from USP_GET_TITLE_DATA_Result UGT in arrDealTitlesEPS
        //                  where UGT.Title_Name.ToUpper().Contains(keyword.ToUpper())
        //                  select UGT.Title_Name + "~" + UGT.Title_Code + "^" + UGT.Episode_Starts_From + "^" + UGT.Episode_End_To
        //                  ).Distinct().ToList();

        //    return Json(result);
        //}
        public ActionResult GetDealTitles1(string keyword, string scheduleDate_Time)
        {
            DateTime dtSchedule = Convert.ToDateTime(scheduleDate_Time);
            USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
            List<USP_GET_TITLE_DATA_Result> arrDealTitlesEPS = objUS.USP_GET_TITLE_DATA(keyword, 0).ToList();
            List<string> LstDealTitles = new List<string>();
            var result = (from USP_GET_TITLE_DATA_Result UGT in arrDealTitlesEPS
                          where UGT.Title_Name.ToUpper().Contains(keyword.ToUpper())
                          select UGT.Title_Name + "~" + UGT.Title_Code + "^" + UGT.Episode_Starts_From + "^" + UGT.Episode_End_To
                          ).Distinct().ToList();

            return Json(result);
        }
        public JsonResult validateEpisode(string episodeNo,int mappedDealCode,string mappedDealName,int code)
        {
            bool valid = true;
            string Message = "";
            int count = 0;
            try
            {
                int BVEpisodeNo = Convert.ToInt32(episodeNo);
                int? Title_Code = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Movie_Code == mappedDealCode).Select(x => x.Title_Code).FirstOrDefault();
                count = new Title_Content_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content.Episode_No == BVEpisodeNo &&
                    (x.Title_Content.Title_Code == Title_Code || x.Acq_Deal_Movie_Code == mappedDealCode)).Count();
                //count = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Episode_No == BVEpisodeNo &&
                //    x.Title_Code == mappedDealCode).Count();
            }
            catch (Exception) { count = 0; }

            if (count == 0)
            {
                valid = false;
                Message = "Content has not been released for this title "+ mappedDealName + " for Episode "+ episodeNo + "";
            }
            else
            {
                valid = true;
            }
            MappedName = mappedDealName;
            EpisodeNo = episodeNo;
            var obj =
              new
              {
                  BV_Code = code,
                  valid = valid,
                  Message = Message
              };
            return Json(obj);
        }
        public ActionResult MapData(List<RightsU_Entities.BV_HouseId_Data> lst)
        {
            List<RightsU_Entities.BV_HouseId_Data> lstBV = new List<BV_HouseId_Data>();
            string Message = "", status = "";
            string TITLE_Episode_No = "";
            bool valid = true;
            int BV_Code = 0;
            if (lst != null)
            {
                foreach (RightsU_Entities.BV_HouseId_Data objBVHouseIDTemp in lst)
                {
                    if (objBVHouseIDTemp.BV_Title != null)
                    {
                        BV_HouseId_Data_Service objBVHouse_Service = new BV_HouseId_Data_Service(objLoginEntity.ConnectionStringName);
                        BV_HouseId_Data objBVHouseID = new BV_HouseId_Data();
                        objBVHouseID = objBVHouse_Service.GetById(objBVHouseIDTemp.BV_HouseId_Data_Code);
                        objBVHouseID.EntityState = State.Modified;
                        var MappedDealName = objBVHouseIDTemp.BV_Title;
                        var DealTitleCode = objBVHouseIDTemp.Title_Code;
                        var EpisodeNo = objBVHouseIDTemp.Episode_No;
                        if (objBVHouseIDTemp.IsIgnore == "N" && objBVHouseIDTemp.Is_Mapped == "True")
                        {
                            TITLE_Episode_No += MappedDealName.Trim() + "~" + DealTitleCode + "~" + EpisodeNo.Trim() + ",";
                        }
                        TITLE_Episode_No = TITLE_Episode_No.Trim(',');
                        USP_Service objUS = null;
                        objUS = new USP_Service(objLoginEntity.ConnectionStringName);
                        List<USP_Validate_Episode_Result> objTitleCnt = objUS.USP_Validate_Episode(TITLE_Episode_No,"S").ToList();
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
                        BV_HouseID_Data += (objBVHouseID.BV_HouseId_Data_Code).ToString() + ",";
                        BV_Title += (objBVHouseID.BV_Title) + ",";
                        if (valid == true)
                        {
                            if (objBVHouseIDTemp.IsIgnore == "Y")
                            {
                                objBVHouseID.IsIgnore = "Y";
                                objBVHouseID.Is_Mapped = "N";
                                objBVHouseID.Title_Code = objBVHouseIDTemp.Title_Code;

                            }
                            else
                            {
                                objBVHouseID.IsIgnore = "N";
                                objBVHouseID.Is_Mapped = "Y";
                                objBVHouseID.Title_Code = objBVHouseIDTemp.Title_Code;
                                objBVHouseID.Episode_No = objBVHouseIDTemp.Episode_No;
                            }
                            if (objBVHouseID.Title_Code.ToString() == "")
                            {
                                status = "E";
                                Message = "Please select either Ignore or Deal title to Map";
                            }
                            else
                            {
                                objBVHouse_Service.Save(objBVHouseID);
                                new USP_Service(objLoginEntity.ConnectionStringName).USP_UpdateContentHouseID(objBVHouseID.BV_HouseId_Data_Code, objBVHouseID.Title_Code);
                                int before = lstBVHouseIDDataSearch.Count();
                                RightsU_Entities.BV_HouseId_Data objRemove = lstBVHouseIDDataSearch.Where(i => i.BV_HouseId_Data_Code == objBVHouseID.BV_HouseId_Data_Code).FirstOrDefault();
                                if (objRemove != null)
                                {
                                    lstBVHouseIDDataSearch.Remove(objRemove);
                                    int AfterDelete = lstBVHouseIDDataSearch.Count();
                                    status = "S";
                                    Message = "BV Title Mapped successfully";
                                }
                            }
                        }
                    }
                }
            }
           // BV_HouseID_Data = BV_HouseID_Data.Split(',');
            new USP_Service(objLoginEntity.ConnectionStringName).USP_BV_Title_Mapping_Shows(BV_HouseID_Data);
            if (BV_Title != null)
            {
                string[] BVTitle = BV_Title.Split(',');
            }
            if (BV_Title == null)
            {
                valid = false;
                Message = "Content has not been released for this title " + MappedName + " for Episode " + EpisodeNo + "";
            }
            int a = lstBVHouseIDDataSearch.Count();
            // lstRemove = lstBVHouseIDDataSearch.Where(i => BVTitle.Contains(i.BV_Title) && i.Is_Mapped == "Y").ToList();
            string program_category = Convert.ToString(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Show_Program_Category").Select(s => s.Parameter_Value).FirstOrDefault());
            lstBVHouseIDDataSearch = lstBVHouseIDData = new BV_HouseId_Data_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Mapped == "N" && (w.IsIgnore == null || w.IsIgnore == "N") && program_category.Contains(w.Program_Category)).ToList();
            BindTitleMappingShows(1, 10);
            ViewBag.RecordCount = lstBVHouseIDDataSearch.Count();
            
            var obj =
             new
             {
                 valid = valid,
                 BV_Code = BV_Code,
                 Message = Message,
                 status = status
             };
            return Json(obj);
        }
    }
}
