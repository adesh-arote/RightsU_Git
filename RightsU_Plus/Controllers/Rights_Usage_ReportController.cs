using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;

using System.Data;
using System.Runtime.Serialization.Formatters.Binary;
using System.Data.OleDb;
using System.Configuration;
using System.Net;
using OfficeOpenXml;
using System.ComponentModel;
using System.Reflection;
using System.Text.RegularExpressions;

namespace RightsU_Plus.Controllers
{
    public class Rights_Usage_ReportController : BaseController
    {
        //
        // GET: /Rights_Usage_Report/


        private List<USP_Schedule_AsRun_Report_Result> schedule_AsRun_ReportList
        {
            get
            {
                if (Session["schedule_AsRun_ReportList"] == null)
                    Session["schedule_AsRun_ReportList"] = new List<USP_Schedule_AsRun_Report_Result>();
                return (List<USP_Schedule_AsRun_Report_Result>)Session["schedule_AsRun_ReportList"];
            }
            set { Session["schedule_AsRun_ReportList"] = value; }
        }

        private List<USP_Schedule_ShowDetails_Sche_Report_Result> scheduleRunList
        {
            get
            {
                if (Session["scheduleRunList"] == null)
                    Session["scheduleRunList"] = new List<USP_Schedule_ShowDetails_Sche_Report_Result>();
                return (List<USP_Schedule_ShowDetails_Sche_Report_Result>)Session["scheduleRunList"];
            }
            set { Session["scheduleRunList"] = value; }
        }

        //  List<USP_Schedule_AsRun_Report_Result> schedule_AsRun_ReportList = new List<USP_Schedule_AsRun_Report_Result>();

        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForRightsUsageReport);
            ViewBag.BusinessUnitList = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(b => b.Users_Business_Unit.Any(UB => UB.Business_Unit_Code == b.Business_Unit_Code && UB.Users_Code == objLoginUser.Users_Code)).Select(R => new { Business_Unit_Code = R.Business_Unit_Code, Business_Unit_Name = R.Business_Unit_Name }), "Business_Unit_Code", "Business_Unit_Name").ToList();
            //ViewBag.TitleList = new MultiSelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Reference_Flag != "T" && x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == 1)).OrderBy(t => t.Title_Name), "Title_Code", "Title_Name").ToList();
            ViewBag.ChannelList = new MultiSelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Channel_Code", "Channel_Name").ToList();

            List<SelectListItem> lstRunType = new List<SelectListItem>();
            lstRunType.Add(new SelectListItem { Text = objMessageKey.PleaseSelect, Value = "0" });
            lstRunType.Add(new SelectListItem { Text = objMessageKey.Limited, Value = "C" });
            lstRunType.Add(new SelectListItem { Text = objMessageKey.Unlimited, Value = "U" });
            ViewBag.RunType = lstRunType;
            return View();
        }

        public JsonResult BindTitle(int BU_Code, string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper())
                && x.Reference_Flag != "T" && x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code))
                .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList().Distinct();
                //result = objUSP_Service.USP_Get_BUWise_Title(BU_Code, searchString).ToList();
            }
            return Json(result);
        }
        public JsonResult SearchRightsUsageReport(string IsShowAll, string txtfrom, string txtto, string expiredDeal, string titleList, string[] channelList,
            string runType, int BUCode, int EpisodeFrom = 0, int EpisodeTo = 0)
        {
            string title_names = TitleAutosuggest(titleList, BUCode);

            string channelArray = "";
            for (int i = 0; i < channelList.Count(); i++)
            {
                channelArray = channelList[i] + "," + channelArray;
            }

            channelArray = channelArray.TrimEnd(',');

            if (txtfrom != "")
                txtfrom = GlobalUtil.MakedateFormat(txtfrom);
            if (txtto != "")
                txtto = GlobalUtil.MakedateFormat(txtto);


            Session["txtfrom"] = txtfrom;
            Session["txtto"] = txtto;
            Session["channelArray"] = channelArray;
            Session["runType"] = runType;

            //ViewBag.txtfrom = txtfrom;
            //ViewBag.txtto = txtto;
            //ViewBag.channelArray = channelArray;
            //ViewBag.runType = runType;

            //  string query = "";
            int recordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
            // List<USP_Schedule_AsRun_Report_Result> schedule_AsRun_ReportList = new List<USP_Schedule_AsRun_Report_Result>();

            bool IsExpired = true;
            if (expiredDeal == "False")
                IsExpired = false;

            schedule_AsRun_ReportList = objUSP_Service.USP_Schedule_AsRun_Report(title_names, EpisodeFrom, EpisodeTo, IsShowAll, txtfrom, txtto, channelArray, IsExpired, runType).ToList();

            //   lstUpload_Files_Searched = lstUpload_Files;

            var obj = new
            {

                Record_Count = schedule_AsRun_ReportList.Count
            };
            return Json(obj);
        }

        public PartialViewResult BindRightsUsageReport(int pageNo, int recordPerPage)
        {
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Rights_Usage_Report/_List.cshtml", schedule_AsRun_ReportList);
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = objUSP_Service.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.RightCodeForView), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
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

        public PartialViewResult ViewScheduleRun(int AcqDMCode)
        {
            BMS_Log_Service objBMS_Log_Service = new BMS_Log_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.BMS_Log objBMS_Log = new RightsU_Entities.BMS_Log();
            objBMS_Log = objBMS_Log_Service.GetById(AcqDMCode);
            return PartialView("~/Views/Rights_Usage_Report/_List_ScheduleRun.cshtml", objBMS_Log);

        }


        public JsonResult SearchScheduleRunReport(string AcqDMCode, string episode_Nos, string Deal_Type, string txtfrom,
            string txtto, string[] channelList, bool expiredDeal, string runType, string Title_Codes, int Deal_Code = 0)
        {
            string channelArray = "";
            for (int i = 0; i < channelList.Count(); i++)
            {
                channelArray = channelList[i] + "," + channelArray;
            }
            channelArray = channelArray.TrimEnd(',');
            int Title_Code = Convert.ToInt32(Title_Codes);
            int episode_No = episode_Nos == "" ? 0 : Convert.ToInt32(episode_Nos);
            scheduleRunList =
                objUSP_Service.USP_Schedule_ShowDetails_Sche_Report(AcqDMCode, Title_Code, Deal_Code, episode_No, Deal_Type, txtfrom, txtto, channelArray, false, runType).ToList();
            var obj = new
            {

                Record_Count = scheduleRunList.Count
            };
            return Json(obj);
        }

        public PartialViewResult BindScheduleRunReport(int pageNo, int recordPerPage, string AgreementNo, int TitleCode, int DealCode, string DealType, string TitleName, string RightsPeriod, string EpisodeNo)
        {
            ViewBag.AgreementNo = AgreementNo;
            ViewBag.TitleName = TitleName;
            ViewBag.RightsPeriod = RightsPeriod;
            ViewBag.UserModuleRights = GetUserModuleRights();
            ViewBag.EpisodeNo = EpisodeNo;
            ViewBag.TitleCode = TitleCode;
            ViewBag.DealCode = DealCode;
            ViewBag.DealType = DealType;
            return PartialView("~/Views/Rights_Usage_Report/_List_ScheduleRun.cshtml", scheduleRunList);
        }
        public string TitleAutosuggest(string Title, int BUCode)
        {
            Title = Title.Trim().Trim('﹐').Trim();
            string title_names = "";
            if (Title != "")
            {
                string[] terms = Title.Split('﹐');
                string[] Title_Codes = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Title_Name) && x.Reference_Flag != "T"
                && x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BUCode)).Select(s => s.Title_Code.ToString()).ToArray();
                title_names = string.Join(", ", Title_Codes);
                if (title_names == "")
                    title_names = "-1";
            }
            return title_names;
        }
        //public JsonResult ExportToExcel(List<SearchTitle> lstTitle, string txtfrom, string txtto, string[] channelList, string expiredDeal, string runType)
        //{
        //    string status = "S", message = "Export successfully";
        //    string filename = "", host = "";
        //    string channelArray = "";
        //    try
        //    {
        //        for (int i = 0; i < channelList.Count(); i++)
        //        {
        //            channelArray = channelList[i] + "," + channelArray;
        //        }

        //        channelArray = channelArray.TrimEnd(',');

        //        USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
        //        List<USP_Schedule_ShowDetails_Sche_Report_Result> USP_ScheduleAsRun_List = new List<USP_Schedule_ShowDetails_Sche_Report_Result>();
        //        foreach (SearchTitle ST in lstTitle)
        //        {
        //            USP_ScheduleAsRun_List.AddRange(objUSP.USP_Schedule_ShowDetails_Sche_Report(Convert.ToInt32(ST.Title_Code), Convert.ToInt32(ST.Deal_Code),
        //                Convert.ToInt32(ST.episode_No), ST.Deal_Type, txtfrom, txtto,
        //                channelArray, false, runType).ToList());

        //        }

        //        var ScheduleAsRunList = USP_ScheduleAsRun_List.Select(t => new
        //        {
        //            t.Program_Title,
        //            t.Program_Episode_Number,
        //            t.Program_Category,
        //            t.Schedule_Item_Log_Date,
        //            t.Schedule_Item_Log_Time,
        //            t.Scheduled_Version_House_Number_List,
        //            t.Channel_Name,
        //            t.RightsPeriod
        //        }).Distinct().ToList();

        //        FileInfo flInfo = new FileInfo(HttpContext.Server.MapPath("~/UploadFolder/Rights_Usage_Report_" + DateTime.Now.ToString("ddMMyyyyhhmmss.fff") + ".xlsx"));
        //        filename = flInfo.Name.ToString();
        //        FileInfo fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/Rights_Usage_Report_Sample.xlsx"));

        //        DataTable dt = new DataTable();
        //        dt = ToDataTable(ScheduleAsRunList);
        //        //dt.Columns.Add("Int_Episode");
        //        //for (int i = 0; i < dt.Rows.Count; i++)
        //        //{
        //        //    dt.Rows[i][7] = Convert.ToInt32(dt.Rows[i][1].ToString().Substring(8));
        //        //}
        //        //dt.DefaultView.Sort = "Title_Name ASC, Episode_No asc";
        //        //dt = dt.DefaultView.ToTable();
        //        using (ExcelPackage package = new ExcelPackage(flInfo, fliTemplate))
        //        {
        //            ExcelWorksheet worksheet = package.Workbook.Worksheets[1];
        //            for (int i = 0; i < dt.Rows.Count; i++)
        //            {
        //                worksheet.Cells[i + 2, 1].Value = dt.Rows[i][0];
        //                worksheet.Cells[i + 2, 2].Value = dt.Rows[i][1];
        //                worksheet.Cells[i + 2, 3].Value = dt.Rows[i][2];
        //                worksheet.Cells[i + 2, 4].Value = dt.Rows[i][3];
        //                worksheet.Cells[i + 2, 5].Value = dt.Rows[i][4];
        //                worksheet.Cells[i + 2, 6].Value = dt.Rows[i][5];
        //                worksheet.Cells[i + 2, 7].Value = dt.Rows[i][6];
        //                worksheet.Cells[i + 2, 8].Value = dt.Rows[i][7];
        //            }
        //            package.Save();
        //        }
        //        host = Request.Url.Host;
        //        status = "S";

        //        //System.Web.UI.WebControls.GridView gridvw = new System.Web.UI.WebControls.GridView();
        //        //gridvw.AutoGenerateColumns = false;
        //        //gridvw.Columns.Add(new BoundField { HeaderText = "Program Title", DataField = "Program_Title" });
        //        //gridvw.Columns.Add(new BoundField { HeaderText = "Program Category", DataField = "Program_Category" });
        //        //gridvw.Columns.Add(new BoundField { HeaderText = "Schedule Item Log Date", DataField = "Schedule_Item_Log_Date" });
        //        //gridvw.Columns.Add(new BoundField { HeaderText = "Schedule Item Log Date", DataField = "Schedule_Item_Log_Time" });
        //        //gridvw.Columns.Add(new BoundField { HeaderText = "Scheduled Version House Number List", DataField = "Scheduled_Version_House_Number_List" });
        //        //gridvw.Columns.Add(new BoundField { HeaderText = "Channel", DataField = "Channel_Name" });
        //        //gridvw.Columns.Add(new BoundField { HeaderText = "Rights Period", DataField = "RightsPeriod" });

        //        //gridvw.DataSource = ScheduleAsRunList.ToList(); //bind the datatable to the gridview
        //        //gridvw.DataBind();
        //        //Response.ClearContent();
        //        //Response.ContentType = "application/excel";
        //        //Response.AddHeader("content-disposition", "attachment;filename=RightsUsageReport.xlsx");

        //        //StringWriter swr = new StringWriter();
        //        //HtmlTextWriter tw = new HtmlTextWriter(swr);
        //        //gridvw.RenderControl(tw);
        //        //Response.Write("<b>Rights Usage Report </b><br/>");
        //        //Response.Write("<b>Total Records: " + ScheduleAsRunList.Count.ToString() + "</b>");
        //        //if (key == "Y")
        //        //{
        //        //    Response.Write("<b>Agreement No: " + agreement.ToString() + "</b><br/>");
        //        //    Response.Write("<b>Title: " + TitleName.ToString() + "</b><br/>");
        //        //    Response.Write("<b>Rights Period: " + RightsPeriod.ToString() + "</b><br/>");
        //        //}
        //        //Response.Write(swr.ToString());

        //        //Response.End();
        //    }
        //    //catch (Exception)
        //    //{
        //    //}
        //    //var obj = new
        //    //{
        //    //    Record_Count = ScheduleAsRunList.Count
        //    //};
        //    //  return Json("");
        //    catch (Exception ex)
        //    {
        //        status = "E";
        //        message = ex.Message;
        //    }

        //    var obj = new
        //    {
        //        Status = status,
        //        Message = message,
        //        FileName = filename,
        //        Host = host
        //    };
        //    return Json(obj);
        //}

        public void ExportToExcel(string DMCode, string txtfrom, string txtto, string[] channelList, string expiredDeal, string runType, string key, string agreement, string TitleName, string RightsPeriod)
        {
            string channelArray = "";
            try
            {
                for (int i = 0; i < channelList.Count(); i++)
                {
                    channelArray = channelList[i] + "," + channelArray;
                }
                channelArray = channelArray.TrimEnd(',');

                USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
                List<USP_Schedule_ShowDetails_Sche_Report_Result> USP_ScheduleAsRun_List = new List<USP_Schedule_ShowDetails_Sche_Report_Result>();
                var ScheduleAsRunList = USP_ScheduleAsRun_List.Select(t => new
                {
                    t.Program_Title,
                    t.Program_Category,
                    t.Schedule_Item_Log_Date,
                    t.Schedule_Item_Log_Time,
                    t.Scheduled_Version_House_Number_List,
                    t.Channel_Name,
                    t.RightsPeriod
                }).ToList();

                ScheduleAsRunList = objUSP.USP_Schedule_ShowDetails_Sche_Report(DMCode,0,0,0,"", txtfrom, txtto, channelArray, false, runType).Select(t => new
                {
                    t.Program_Title,
                    t.Program_Category,
                    t.Schedule_Item_Log_Date,
                    t.Schedule_Item_Log_Time,
                    t.Scheduled_Version_House_Number_List,
                    t.Channel_Name,
                    t.RightsPeriod
                }).ToList();

                System.Web.UI.WebControls.GridView gridvw = new System.Web.UI.WebControls.GridView();
                gridvw.AutoGenerateColumns = false;
                gridvw.Columns.Add(new BoundField { HeaderText = "Program Title", DataField = "Program_Title" });
                gridvw.Columns.Add(new BoundField { HeaderText = "Program Category", DataField = "Program_Category" });
                gridvw.Columns.Add(new BoundField { HeaderText = "Schedule Item Log Date", DataField = "Schedule_Item_Log_Date" });
                gridvw.Columns.Add(new BoundField { HeaderText = "Schedule Item Log Date", DataField = "Schedule_Item_Log_Time" });
                gridvw.Columns.Add(new BoundField { HeaderText = "Scheduled Version House Number List", DataField = "Scheduled_Version_House_Number_List" });
                gridvw.Columns.Add(new BoundField { HeaderText = "Channel", DataField = "Channel_Name" });
                gridvw.Columns.Add(new BoundField { HeaderText = "Rights Period", DataField = "RightsPeriod" });

                gridvw.DataSource = ScheduleAsRunList.ToList(); //bind the datatable to the gridview
                gridvw.DataBind();
                Response.ClearContent();
                Response.ContentType = "application/excel";
                Response.AddHeader("content-disposition", "attachment;filename=RightsUsageReport.xlsx");

                StringWriter swr = new StringWriter();
                HtmlTextWriter tw = new HtmlTextWriter(swr);
                gridvw.RenderControl(tw);
                if (key == "Y")
                {
                    Response.Write("<b>Agreement No: " + agreement.ToString() + "</b><br/>");
                    Response.Write("<b>Title: " + TitleName.ToString() + "</b><br/>");
                    Response.Write("<b>Rights Period: " + RightsPeriod.ToString() + "</b><br/>");
                }
                Response.Write(swr.ToString());
                Response.End();
            }
            catch (Exception)
            {

            }
        }

        public void DeleteUploadFile(string fileName)
        {
            try
            {
                FileInfo flInfo = new FileInfo(HttpContext.Server.MapPath("~/UploadFolder/" + fileName));
                flInfo.Delete();
            }
            catch
            {

            }
        }
        public DataTable ToDataTable<T>(IEnumerable<T> collection)
        {
                DataTable dataTable = new DataTable();
            PropertyDescriptorCollection propertyDescriptorCollection =
                TypeDescriptor.GetProperties(typeof(T));
            for (int i = 0; i < propertyDescriptorCollection.Count; i++)
            {
                PropertyDescriptor propertyDescriptor = propertyDescriptorCollection[i];
                Type type = propertyDescriptor.PropertyType;

                if (type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>))
                    type = Nullable.GetUnderlyingType(type);


                dataTable.Columns.Add(propertyDescriptor.Name, type);
            }
            object[] values = new object[propertyDescriptorCollection.Count];
            foreach (T iListItem in collection)
            {
                for (int i = 0; i < values.Length; i++)
                {
                    values[i] = propertyDescriptorCollection[i].GetValue(iListItem);
                }
                dataTable.Rows.Add(values);
            }
            return dataTable;
        }
    }

    public class SearchTitle
    {
        public string Title_Code { get; set; }
        public string Deal_Code { get; set; }
        public string episode_No { get; set; }
        public string Deal_Type { get; set; }


    }

}