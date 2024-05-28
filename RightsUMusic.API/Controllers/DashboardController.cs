using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using RightsUMusic.Entity;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.Web;
using RightsUMusic.BLL.Services;
using System.IO;
using System.Text;
using System.Threading;
using System.Configuration;
using System.Collections;

namespace RightsUMusic.API.Controllers
{
    public class DashboardController : ApiController
    {
        private readonly DashboardManagementServices obj = new DashboardManagementServices();

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetPieChartData(Month objMonth)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");
            dynamic[] a = new dynamic[10];
            try
            {
                //dynamic[] lstPieChartDataTemp = obj.GetPieChartData(Convert.ToInt32(UsersCode), objMonth.NoOfMonths).Select(x => "['" + x.LabelName + "'," + x.NoOfLabels1 + "]").ToArray();
                var lstPieChartData = obj.GetPieChartData(Convert.ToInt32(UsersCode), objMonth.NoOfMonths);
                //for (int i = 0; i < lstPieChartDataTemp.Length; i++)
                //{
                //    a[i] = lstPieChartDataTemp[i];
                //}

                //a = a.Trim().TrimStart(',');

                string[] arrLabels = lstPieChartData.Select(x => x.LabelName).ToArray();
                int[] arrData = lstPieChartData.Select(x => x.NoOfLabels1).ToArray();
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, labels = arrLabels, Data = arrData}, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetBarChartData(Month objMonth)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");
            List<Show> objList = new List<Show>();
            List<Details> newLst = new List<Details>();

            try
            {
                var lstBarChartData = obj.GetBarChartData(Convert.ToInt32(UsersCode), objMonth.NoOfMonths);
                List<string> lstShowNames = new List<string>();
                string[] arrShowName = lstBarChartData.Select(x => x.ShowName).Distinct().ToArray();
                var lstBarChartData1 = lstBarChartData.Select(x => x.ShowName).Distinct().ToList();

                //string[] showNameArray = lstBarChartData.Select(x => x.ShowName).Distinct().ToArray();
                //string[] labelArray = lstBarChartData.Select(x => x.LabelName).Distinct().ToArray();
                //int[] usageArray;
                //ArrayList arr = new ArrayList();

                //foreach (var item1 in showNameArray)
                //{
                //    usageArray = lstBarChartData.Where(x => x.ShowName.ToLower() == item1.ToLower()).Select(x => x.Usage).ToArray();
                //    arr.Add(usageArray);
                //}

                foreach (var item in arrShowName)
                {
                    newLst = lstBarChartData.Where(x => x.ShowName.ToUpper() == item.ToUpper()).Select(x => new Details() { LabelName = x.LabelName, Usage = x.Usage }).ToList();
                    Show objShow = new Show();
                    objShow.ShowName = item.ToString();
                    objShow.Details = newLst;
                    objList.Add(objShow);
                    //objShow.label = newLst.Select(x => x.LabelName).ToList();
                    //objShow.usage = newLst.Select(x => x.Usage).ToList();

                }
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, BarChart = objList/*, ShowName = showNameArray, Labels = labelArray, temp = arr */}, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetLabelWiseUsage(LabelWiseUsageInput objLabelWiseUsageInput)
        {
            string LabelName = "", ShowName = "";
            int NoOfMonths = 0;

            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");
            LabelName = objLabelWiseUsageInput.LabelName.Trim();
            ShowName = objLabelWiseUsageInput.ShowName.Trim();
            NoOfMonths = objLabelWiseUsageInput.NoOfMonths;
            try
            {
                var lstLabelWiseData = obj.GetLabelWiseUsage(Convert.ToInt32(UsersCode), LabelName, ShowName, NoOfMonths);
                //if (!string.IsNullOrEmpty(ShowName))
                //{
                //     var lstLabelWiseUsage = lstLabelWiseData.Select(x => new { MusicTrackName = x.MusicTrackName,MovieAlbum = x.Movie_Album,MusicLanguage = x.MusicLanguage,YearOfRelease = x.YearOfRelease,MusicTag = x.Music_Tag}).ToList();
                //    _objRet.Message = "";
                //    _objRet.IsSuccess = true;
                //    return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, LabelWiseList = lstLabelWiseUsage }, Configuration.Formatters.JsonFormatter);
                //}
                //else
                //{
                //    var lstShowWiseUsage = lstLabelWiseData.Select(x => new { ShowName = x.ShowName, MusicTrackName = x.MusicTrackName, MovieAlbum = x.Movie_Album,MusicTag = x.Music_Tag }).ToList();
                //    _objRet.Message = "";
                //    _objRet.IsSuccess = true;
                //    return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, ShowWiseList = lstShowWiseUsage }, Configuration.Formatters.JsonFormatter);
                //}
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, LabelWiseList = lstLabelWiseData }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }
    }


    public class Show
    {
        //public Show()
        //{
        //    this.Details = new List<Details>();

        //}
        public string ShowName { get; set; }
        public List<Details> Details { get; set; }
    }

    public class Details
    {
        public string LabelName { get; set; }
        public int Usage { get; set; }
    }

    public class Month
    {
        public int NoOfMonths { get; set; }
    }
}
