using Newtonsoft.Json;
using RightsU.API.BLL.Services;
using RightsU.API.Entities;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using RightsU.API.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.Http;
using System.ComponentModel;

namespace RightsU.API.Controllers
{
    //[SwaggerConsumes("application/json")]
    //[SwaggerProduces("application/json")]
    //[HideInDocs]
    [DisplayName("BMS Integration")]
    public class bmsController : BaseController
    {
        public readonly BMSServices objBMSServices = new BMSServices();
        private readonly SystemParameterServices objSystemParameterServices = new SystemParameterServices();
        private readonly BMS_Log_Service objBMSLogServices = new BMS_Log_Service();
        private readonly System_Module_Service objSystemModuleServices = new System_Module_Service();

        /// <summary>
        /// Asset Details
        /// </summary>
        /// <remarks>This Api returns Asset Details</remarks>
        /// <param name="since">Find assets updated after this date. Format is 'dd-MMM-yyyy'. If no value is given, the default value will be passed</param>
        /// <returns></returns>               
        //[SwaggerResponse(HttpStatusCode.OK, "Success", Type = typeof(List<AssetsResult>))]
        //[SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        //[SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        //[SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        //[SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        //[SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPost]
        [ActionName("getassets")]
        public HttpResponseMessage GetAssets(string since = null)
        {
            var response = new HttpResponseMessage();

            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            DateTime startTime;
            startTime = DateTime.Now;

            AssetsInput AssetsInput = new AssetsInput();
            AssetsInput.since = since;

            BMS_Log objLog = new BMS_Log();
            objLog.Request_Time = DateTime.Now;
            objLog.Module_Name = "BMS_Asset";
            objLog.Method_Type = Request.Method.Method;
            objLog.Record_Status = "D";
            objLog.Request_Xml = JsonConvert.SerializeObject(AssetsInput);

            List<AssetsResult> lstAssetsResult = new List<AssetsResult>();
            try
            {
                Int32 BMS_API_Since_Days = 0;

                var objNew = new
                {
                    Parameter_Name = "BMS_API_Since_Days"
                };
                BMS_API_Since_Days = objSystemParameterServices.SearchFor(objNew).Select(x => Convert.ToInt32(x.Parameter_Value)).SingleOrDefault();

                if (string.IsNullOrEmpty(AssetsInput.since))
                {
                    AssetsInput.since = DateTime.Now.AddDays(-BMS_API_Since_Days).ToString("yyyy-MM-dd");
                    objLog.Request_Xml = JsonConvert.SerializeObject(AssetsInput);
                }
                else
                {
                    try
                    {
                        AssetsInput.since = DateTime.Parse(AssetsInput.since).ToString("yyyy-MM-dd");
                        if ((DateTime.Today - DateTime.Parse(AssetsInput.since)).Days > BMS_API_Since_Days)
                        {
                            _objRet.Message = "Since Date should not exceed more than " + BMS_API_Since_Days + " days.";
                            _objRet.IsSuccess = false;
                            _objRet.StatusCode = HttpStatusCode.BadRequest;
                            objLog.Record_Status = "E";
                            objLog.Error_Description = _objRet.Message;
                        }
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }

                if (_objRet.IsSuccess)
                {
                    lstAssetsResult = objBMSServices.GetAssets(AssetsInput.since);
                }
            }
            catch (Exception ex)
            {
                throw;
                //_objRet.Message = ex.Message;
                //_objRet.IsSuccess = false;
                //objLog.Request_Xml = JsonConvert.SerializeObject(AssetsInput);
                //objLog.Error_Description = _objRet.Message;
                //objLog.Record_Status = "E";
                //objLog.Response_Xml = JsonConvert.SerializeObject(lstAssetsResult);
                //objLog.Response_Time = DateTime.Now;
                //_objRet.LogId = objBMSLogServices.InsertLog(objLog);

                //var response = Request.CreateResponse(HttpStatusCode.InternalServerError, new { AssetsData = lstAssetsResult }, Configuration.Formatters.JsonFormatter); ;
                //response.Headers.Add("LogId", _objRet.LogId.ToString());
                //response.Headers.Add("Message", _objRet.Message);
                //response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                //return response;
            }

            //objLog.Response_Xml = JsonConvert.SerializeObject(lstAssetsResult);
            //objLog.Response_Time = DateTime.Now;
            //_objRet.LogId = objBMSLogServices.InsertLog(objLog);

            if (_objRet.IsSuccess)
            {
                _objRet.Response = lstAssetsResult;
                //var response = Request.CreateResponse(HttpStatusCode.OK, new { AssetsData = lstAssetsResult }, Configuration.Formatters.JsonFormatter); ;
                //response.Headers.Add("LogId", _objRet.LogId.ToString());
                //response.Headers.Add("Message", _objRet.Message);
                //response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                //return response;
            }
            //else
            //{
            //    var response = Request.CreateResponse(HttpStatusCode.BadRequest, new { AssetsData = lstAssetsResult }, Configuration.Formatters.JsonFormatter); ;
            //    response.Headers.Add("LogId", _objRet.LogId.ToString());
            //    response.Headers.Add("Message", _objRet.Message);
            //    response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
            //    return response;
            //}

            _objRet.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(_objRet, true);

            return response;
        }

        /// <summary>
        /// Deal Details
        /// </summary>
        /// <remarks>This Api returns Deal Details</remarks>
        /// <param name="since">Find deals updated after this date. Format is 'dd-MMM-yyyy'. If no value is given, the default value will be passed</param>
        /// <param name="assetId">AssetId used for fetching Deals Data for specific AssetId , Example:RUBMSA11</param>
        /// <returns></returns>
        //[SwaggerResponse(HttpStatusCode.OK, "Success", Type = typeof(List<DealResult>))]
        //[SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error")]
        //[SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        //[AcceptVerbs("GET", "POST")]
        [HttpPost]
        [ActionName("getdeals")]
        public HttpResponseMessage GetDeals(string since = null, string assetId = null)
        {
            var response = new HttpResponseMessage();

            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            DateTime startTime;
            startTime = DateTime.Now;

            DealsInput DealsInput = new DealsInput();
            DealsInput.since = since;
            DealsInput.assetId = assetId;


            BMS_Log objLog = new BMS_Log();
            objLog.Request_Time = DateTime.Now;
            objLog.Module_Name = "BMS_Deal";
            objLog.Method_Type = Request.Method.Method;
            objLog.Record_Status = "D";
            objLog.Request_Xml = JsonConvert.SerializeObject(DealsInput);

            List<DealResult> lstDealsResult = new List<DealResult>();
            try
            {
                Int32 BMS_API_Since_Days = 0;
                string BMS_API_Asset_Prefix = string.Empty;

                var objNew = new
                {
                    Parameter_Name = "BMS_API_Since_Days"
                };
                BMS_API_Since_Days = objSystemParameterServices.SearchFor(objNew).Select(x => Convert.ToInt32(x.Parameter_Value)).SingleOrDefault();

                BMS_API_Asset_Prefix = objSystemParameterServices.SearchFor(new { Parameter_Name = "BMS_API_Asset_Prefix" }).Select(x => x.Parameter_Value).SingleOrDefault();

                if (string.IsNullOrEmpty(DealsInput.since) && string.IsNullOrEmpty(DealsInput.assetId))
                {
                    DealsInput.since = DateTime.Now.AddDays(-BMS_API_Since_Days).ToString("yyyy-MM-dd");
                    objLog.Request_Xml = JsonConvert.SerializeObject(DealsInput);
                }
                else
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(DealsInput.assetId))
                        {
                            //string step1 = "1";
                            try
                            {
                                if (DealsInput.assetId.Contains(BMS_API_Asset_Prefix) || BMS_API_Asset_Prefix == "")
                                {
                                    //step1 = "2 - " + BMS_API_Asset_Prefix;
                                    int AssetId = 0;
                                    if (BMS_API_Asset_Prefix != "")
                                        AssetId = Convert.ToInt32(DealsInput.assetId.Replace(BMS_API_Asset_Prefix, ""));
                                    else
                                        AssetId = Convert.ToInt32(DealsInput.assetId);
                                    //step1 = "2.1";
                                    if (AssetId == 0)
                                    {
                                        //step1 = "3";
                                        _objRet.Message = "Invalid AssetId";
                                        _objRet.IsSuccess = false;
                                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                                        //step1 = "4";
                                        objLog.Record_Status = "E";
                                        objLog.Error_Description = _objRet.Message;
                                        //step1 = "5";
                                    }
                                    else
                                    {
                                        //step1 = "6";
                                        DealsInput.assetId = Convert.ToString(AssetId);
                                        //step1 = "7";
                                    }
                                }
                                else
                                {
                                    //step1 = "8";
                                    _objRet.Message = "Invalid AssetId";
                                    _objRet.IsSuccess = false;
                                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                                    //step1 = "9";
                                    objLog.Record_Status = "E";
                                    objLog.Error_Description = _objRet.Message;
                                    //step1 = "10";
                                }
                            }
                            catch (Exception ex)
                            {
                                _objRet.Message = "Invalid AssetId";
                                _objRet.IsSuccess = false;
                                _objRet.StatusCode = HttpStatusCode.BadRequest;

                                objLog.Record_Status = "E";
                                objLog.Error_Description = _objRet.Message;
                            }
                        }
                        else if (!string.IsNullOrEmpty(DealsInput.since))
                        {
                            DealsInput.since = DateTime.Parse(DealsInput.since).ToString("yyyy-MM-dd");
                            if ((DateTime.Today - DateTime.Parse(DealsInput.since)).Days > BMS_API_Since_Days)
                            {
                                _objRet.Message = "Since Date should not exceed more than " + BMS_API_Since_Days + " days.";
                                _objRet.IsSuccess = false;
                                _objRet.StatusCode = HttpStatusCode.BadRequest;

                                objLog.Record_Status = "E";
                                objLog.Error_Description = _objRet.Message;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }

                if (_objRet.IsSuccess)
                {
                    lstDealsResult = objBMSServices.GetDeals(DealsInput.since, DealsInput.assetId);
                }
            }
            catch (Exception ex)
            {
                throw;
                //_objRet.Message = ex.Message;
                //_objRet.IsSuccess = false;
                //objLog.Request_Xml = JsonConvert.SerializeObject(DealsInput);
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
                //objLog.Response_Xml = JsonConvert.SerializeObject(lstDealsResult);
                //objLog.Response_Time = DateTime.Now;
                //_objRet.LogId = objBMSLogServices.InsertLog(objLog);

                //var response= Request.CreateResponse(HttpStatusCode.InternalServerError, new { DealsData = lstDealsResult }, Configuration.Formatters.JsonFormatter);
                //response.Headers.Add("LogId", _objRet.LogId.ToString());
                //response.Headers.Add("Message", _objRet.Message);
                //response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                //return response;
            }

            //objLog.Response_Xml = JsonConvert.SerializeObject(lstDealsResult);
            //objLog.Response_Time = DateTime.Now;
            //_objRet.LogId = objBMSLogServices.InsertLog(objLog);


            if (_objRet.IsSuccess)
            {
                _objRet.Response = lstDealsResult;
                //var response= Request.CreateResponse(HttpStatusCode.OK, new {  DealsData = lstDealsResult }, Configuration.Formatters.JsonFormatter);
                //response.Headers.Add("LogId", _objRet.LogId.ToString());
                //response.Headers.Add("Message", _objRet.Message);
                //response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                //return response;
            }
            //else
            //{
            //    var response = Request.CreateResponse(HttpStatusCode.BadRequest, new { DealsData = lstDealsResult }, Configuration.Formatters.JsonFormatter);
            //    response.Headers.Add("LogId", _objRet.LogId.ToString());
            //    response.Headers.Add("Message", _objRet.Message);
            //    response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
            //    return response;
            //}
            _objRet.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(_objRet, true);

            return response;

        }

        /// <summary>
        /// Deal Contents Details
        /// </summary>
        /// <remarks>This Api returns Deal Content Details</remarks>
        /// <param name="since">Find deal contents updated after this date. Format is 'dd-MMM-yyyy'. If no value is given, the default value will be passed</param>
        /// <param name="assetId">AssetId used for fetching deal contents Data for specific AssetId , Example:RUBMSA11</param>
        /// <param name="dealId">DealId used for fetching deal contents Data for specific DealId , Example:RUBMSD11</param>
        /// <returns></returns>
        //[SwaggerResponse(HttpStatusCode.OK, "Success", Type = typeof(List<DealContentResult>))]
        //[SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error")]
        //[SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        //[AcceptVerbs("GET", "POST")]
        [HttpPost]
        [ActionName("getdealcontent")]
        public HttpResponseMessage GetDealContent(string since = null, string assetId = null, string dealId = null)
        {
            var response = new HttpResponseMessage();

            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            DateTime startTime;
            startTime = DateTime.Now;

            DealContentInput DealContentInput = new DealContentInput();
            DealContentInput.since = since;
            DealContentInput.assetId = assetId;
            DealContentInput.dealId = dealId;

            BMS_Log objLog = new BMS_Log();
            objLog.Request_Time = DateTime.Now;
            objLog.Module_Name = "BMS_Deal_Content";
            objLog.Method_Type = Request.Method.Method;
            objLog.Record_Status = "D";
            objLog.Request_Xml = JsonConvert.SerializeObject(DealContentInput);

            List<DealContentResult> lstDealContentResult = new List<DealContentResult>();
            try
            {
                Int32 BMS_API_Since_Days = 0;
                string BMS_API_Asset_Prefix = string.Empty;
                string BMS_API_Deal_Prefix = string.Empty;

                BMS_API_Since_Days = objSystemParameterServices.SearchFor(new { Parameter_Name = "BMS_API_Since_Days" }).Select(x => Convert.ToInt32(x.Parameter_Value)).SingleOrDefault();
                BMS_API_Asset_Prefix = objSystemParameterServices.SearchFor(new { Parameter_Name = "BMS_API_Asset_Prefix" }).Select(x => x.Parameter_Value).SingleOrDefault();
                BMS_API_Deal_Prefix = objSystemParameterServices.SearchFor(new { Parameter_Name = "BMS_API_Deal_Prefix" }).Select(x => x.Parameter_Value).SingleOrDefault();

                if (string.IsNullOrEmpty(DealContentInput.since) && string.IsNullOrEmpty(DealContentInput.assetId) && string.IsNullOrEmpty(DealContentInput.dealId))
                {
                    DealContentInput.since = DateTime.Now.AddDays(-BMS_API_Since_Days).ToString("yyyy-MM-dd");
                    objLog.Request_Xml = JsonConvert.SerializeObject(DealContentInput);
                }
                else
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(DealContentInput.assetId))
                        {
                            try
                            {
                                if (DealContentInput.assetId.Contains(BMS_API_Asset_Prefix) || BMS_API_Asset_Prefix == "")
                                {
                                    //int AssetId = Convert.ToInt32(DealContentInput.assetId.Replace(BMS_API_Asset_Prefix, ""));

                                    int AssetId = 0;
                                    if (BMS_API_Asset_Prefix != "")
                                        AssetId = Convert.ToInt32(DealContentInput.assetId.Replace(BMS_API_Asset_Prefix, ""));
                                    else
                                        AssetId = Convert.ToInt32(DealContentInput.assetId);

                                    if (AssetId == 0)
                                    {
                                        _objRet.Message = "Invalid AssetId";
                                        _objRet.IsSuccess = false;
                                        _objRet.StatusCode = HttpStatusCode.BadRequest;

                                        objLog.Record_Status = "E";
                                        objLog.Error_Description = _objRet.Message;
                                    }
                                    else
                                    {
                                        DealContentInput.assetId = Convert.ToString(AssetId);
                                    }
                                }
                                else
                                {
                                    _objRet.Message = "Invalid AssetId";
                                    _objRet.IsSuccess = false;
                                    _objRet.StatusCode = HttpStatusCode.BadRequest;

                                    objLog.Record_Status = "E";
                                    objLog.Error_Description = _objRet.Message;
                                }
                            }
                            catch (Exception ex)
                            {
                                _objRet.Message = "Invalid AssetId";
                                _objRet.IsSuccess = false;
                                _objRet.StatusCode = HttpStatusCode.BadRequest;

                                objLog.Record_Status = "E";
                                objLog.Error_Description = _objRet.Message;
                            }
                        }
                        if (!string.IsNullOrEmpty(DealContentInput.dealId))
                        {
                            try
                            {
                                if (DealContentInput.dealId.Contains(BMS_API_Deal_Prefix) || BMS_API_Deal_Prefix == "")
                                {
                                    //int DealId = Convert.ToInt32(DealContentInput.dealId.Replace(BMS_API_Deal_Prefix, ""));

                                    int DealId = 0;
                                    if (BMS_API_Deal_Prefix != "")
                                        DealId = Convert.ToInt32(DealContentInput.dealId.Replace(BMS_API_Deal_Prefix, ""));
                                    else
                                        DealId = Convert.ToInt32(DealContentInput.dealId);

                                    if (DealId == 0)
                                    {
                                        _objRet.Message = "Invalid DealId";
                                        _objRet.IsSuccess = false;
                                        _objRet.StatusCode = HttpStatusCode.BadRequest;

                                        objLog.Record_Status = "E";
                                        objLog.Error_Description = _objRet.Message;
                                    }
                                    else
                                    {
                                        DealContentInput.dealId = Convert.ToString(DealId);
                                    }
                                }
                                else
                                {
                                    _objRet.Message = "Invalid DealId";
                                    _objRet.IsSuccess = false;
                                    _objRet.StatusCode = HttpStatusCode.BadRequest;

                                    objLog.Record_Status = "E";
                                    objLog.Error_Description = _objRet.Message;
                                }
                            }
                            catch (Exception ex)
                            {
                                _objRet.Message = "Invalid DealId";
                                _objRet.IsSuccess = false;
                                _objRet.StatusCode = HttpStatusCode.BadRequest;

                                objLog.Record_Status = "E";
                                objLog.Error_Description = _objRet.Message;
                            }
                        }

                        if (!string.IsNullOrEmpty(DealContentInput.since))
                        {
                            DealContentInput.since = DateTime.Parse(DealContentInput.since).ToString("yyyy-MM-dd");
                            if ((DateTime.Today - DateTime.Parse(DealContentInput.since)).Days > BMS_API_Since_Days)
                            {
                                _objRet.Message = "Since Date should not exceed more than " + BMS_API_Since_Days + " days.";
                                _objRet.IsSuccess = false;
                                _objRet.StatusCode = HttpStatusCode.BadRequest;

                                objLog.Record_Status = "E";
                                objLog.Error_Description = _objRet.Message;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }

                if (_objRet.IsSuccess)
                {
                    lstDealContentResult = objBMSServices.GetDealContent(DealContentInput.since, DealContentInput.assetId, DealContentInput.dealId);
                }
            }
            catch (Exception ex)
            {
                throw;
                //_objRet.Message = ex.Message;
                //_objRet.IsSuccess = false;
                //objLog.Request_Xml = JsonConvert.SerializeObject(DealContentInput);
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
                //objLog.Response_Xml = JsonConvert.SerializeObject(lstDealContentResult);
                //objLog.Response_Time = DateTime.Now;
                //_objRet.LogId = objBMSLogServices.InsertLog(objLog);

                //var response= Request.CreateResponse(HttpStatusCode.InternalServerError, new { DealContentData = lstDealContentResult }, Configuration.Formatters.JsonFormatter);
                //response.Headers.Add("LogId", _objRet.LogId.ToString());
                //response.Headers.Add("Message", _objRet.Message);
                //response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                //return response;
            }

            //objLog.Response_Xml = JsonConvert.SerializeObject(lstDealContentResult);
            //objLog.Response_Time = DateTime.Now;
            //_objRet.LogId = objBMSLogServices.InsertLog(objLog);

            if (_objRet.IsSuccess)
            {
                _objRet.Response = lstDealContentResult;
                //var response= Request.CreateResponse(HttpStatusCode.OK, new {  DealContentData = lstDealContentResult }, Configuration.Formatters.JsonFormatter);
                //response.Headers.Add("LogId", _objRet.LogId.ToString());
                //response.Headers.Add("Message", _objRet.Message);
                //response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                //return response;
            }
            //else
            //{
            //    var response= Request.CreateResponse(HttpStatusCode.BadRequest, new {  DealContentData = lstDealContentResult }, Configuration.Formatters.JsonFormatter);
            //    response.Headers.Add("LogId", _objRet.LogId.ToString());
            //    response.Headers.Add("Message", _objRet.Message);
            //    response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
            //    return response;
            //}
            _objRet.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(_objRet, true);

            return response;
        }

        /// <summary>
        /// Deal Rights Details
        /// </summary>
        /// <remarks>This Api returns Deal Rights Details</remarks>
        /// <param name="since">Find deal rights updated after this date. Format is 'dd-MMM-yyyy'. If no value is given, the default value will be passed</param>
        /// <param name="assetId">AssetId used for fetching deal rights Data for specific AssetId , Example:RUBMSA11</param>
        /// <param name="dealId">DealId used for fetching deal rights Data for specific DealId , Example:RUBMSD11</param>
        /// <returns></returns>
        //[SwaggerResponse(HttpStatusCode.OK, "Success", Type = typeof(List<DealContentRightsResult>))]
        //[SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error")]
        //[SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        //[AcceptVerbs("GET", "POST")]
        [HttpPost]
        [ActionName("getdealrights")]
        public HttpResponseMessage GetDealRights(string since = null, string assetId = null, string dealId = null)
        {
            var response = new HttpResponseMessage();

            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            DateTime startTime;
            startTime = DateTime.Now;

            DealContentRightsInput DealContentRightsInput = new DealContentRightsInput();
            DealContentRightsInput.since = since;
            DealContentRightsInput.assetId = assetId;
            DealContentRightsInput.dealId = dealId;

            BMS_Log objLog = new BMS_Log();
            objLog.Request_Time = DateTime.Now;
            objLog.Module_Name = "BMS_Deal_Rights";
            objLog.Method_Type = Request.Method.Method;
            objLog.Record_Status = "D";
            objLog.Request_Xml = JsonConvert.SerializeObject(DealContentRightsInput);

            List<DealContentRightsResult> lstDealContentRightsResult = new List<DealContentRightsResult>();
            try
            {
                Int32 BMS_API_Since_Days = 0;
                string BMS_API_Asset_Prefix = string.Empty;
                string BMS_API_Deal_Prefix = string.Empty;

                BMS_API_Since_Days = objSystemParameterServices.SearchFor(new { Parameter_Name = "BMS_API_Since_Days" }).Select(x => Convert.ToInt32(x.Parameter_Value)).SingleOrDefault();
                BMS_API_Asset_Prefix = objSystemParameterServices.SearchFor(new { Parameter_Name = "BMS_API_Asset_Prefix" }).Select(x => x.Parameter_Value).SingleOrDefault();
                BMS_API_Deal_Prefix = objSystemParameterServices.SearchFor(new { Parameter_Name = "BMS_API_Deal_Prefix" }).Select(x => x.Parameter_Value).SingleOrDefault();

                if (string.IsNullOrEmpty(DealContentRightsInput.since) && string.IsNullOrEmpty(DealContentRightsInput.assetId) && string.IsNullOrEmpty(DealContentRightsInput.dealId))
                {
                    DealContentRightsInput.since = DateTime.Now.AddDays(-BMS_API_Since_Days).ToString("yyyy-MM-dd");
                    objLog.Request_Xml = JsonConvert.SerializeObject(DealContentRightsInput);
                }
                else
                {
                    try
                    {
                        if (!string.IsNullOrEmpty(DealContentRightsInput.assetId))
                        {
                            try
                            {
                                if (DealContentRightsInput.assetId.Contains(BMS_API_Asset_Prefix) || BMS_API_Asset_Prefix == "")
                                {
                                    //int AssetId = Convert.ToInt32(DealContentRightsInput.assetId.Replace(BMS_API_Asset_Prefix, ""));

                                    int AssetId = 0;
                                    if (BMS_API_Asset_Prefix != "")
                                        AssetId = Convert.ToInt32(DealContentRightsInput.assetId.Replace(BMS_API_Asset_Prefix, ""));
                                    else
                                        AssetId = Convert.ToInt32(DealContentRightsInput.assetId);

                                    if (AssetId == 0)
                                    {
                                        _objRet.Message = "Invalid AssetId";
                                        _objRet.IsSuccess = false;
                                        _objRet.StatusCode = HttpStatusCode.BadRequest;

                                        objLog.Record_Status = "E";
                                        objLog.Error_Description = _objRet.Message;
                                    }
                                    else
                                    {
                                        DealContentRightsInput.assetId = Convert.ToString(AssetId);
                                    }
                                }
                                else
                                {
                                    _objRet.Message = "Invalid AssetId";
                                    _objRet.IsSuccess = false;
                                    _objRet.StatusCode = HttpStatusCode.BadRequest;

                                    objLog.Record_Status = "E";
                                    objLog.Error_Description = _objRet.Message;
                                }
                            }
                            catch (Exception ex)
                            {
                                _objRet.Message = "Invalid AssetId";
                                _objRet.IsSuccess = false;
                                _objRet.StatusCode = HttpStatusCode.BadRequest;

                                objLog.Record_Status = "E";
                                objLog.Error_Description = _objRet.Message;
                            }
                        }
                        if (!string.IsNullOrEmpty(DealContentRightsInput.dealId))
                        {
                            try
                            {
                                if (DealContentRightsInput.dealId.Contains(BMS_API_Deal_Prefix) || BMS_API_Deal_Prefix == "")
                                {
                                    //int DealId = Convert.ToInt32(DealContentRightsInput.dealId.Replace(BMS_API_Deal_Prefix, ""));

                                    int DealId = 0;
                                    if (BMS_API_Deal_Prefix != "")
                                        DealId = Convert.ToInt32(DealContentRightsInput.dealId.Replace(BMS_API_Deal_Prefix, ""));
                                    else
                                        DealId = Convert.ToInt32(DealContentRightsInput.dealId);

                                    if (DealId == 0)
                                    {
                                        _objRet.Message = "Invalid DealId";
                                        _objRet.IsSuccess = false;
                                        _objRet.StatusCode = HttpStatusCode.BadRequest;

                                        objLog.Record_Status = "E";
                                        objLog.Error_Description = _objRet.Message;
                                    }
                                    else
                                    {
                                        DealContentRightsInput.dealId = Convert.ToString(DealId);
                                    }
                                }
                                else
                                {
                                    _objRet.Message = "Invalid DealId";
                                    _objRet.IsSuccess = false;
                                    _objRet.StatusCode = HttpStatusCode.BadRequest;

                                    objLog.Record_Status = "E";
                                    objLog.Error_Description = _objRet.Message;
                                }
                            }
                            catch (Exception ex)
                            {
                                _objRet.Message = "Invalid DealId";
                                _objRet.IsSuccess = false;
                                _objRet.StatusCode = HttpStatusCode.BadRequest;

                                objLog.Record_Status = "E";
                                objLog.Error_Description = _objRet.Message;
                            }
                        }

                        if (!string.IsNullOrEmpty(DealContentRightsInput.since))
                        {
                            DealContentRightsInput.since = DateTime.Parse(DealContentRightsInput.since).ToString("yyyy-MM-dd");
                            if ((DateTime.Today - DateTime.Parse(DealContentRightsInput.since)).Days > BMS_API_Since_Days)
                            {
                                _objRet.Message = "Since Date should not exceed more than " + BMS_API_Since_Days + " days.";
                                _objRet.IsSuccess = false;
                                _objRet.StatusCode = HttpStatusCode.BadRequest;

                                objLog.Record_Status = "E";
                                objLog.Error_Description = _objRet.Message;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }

                if (_objRet.IsSuccess)
                {
                    lstDealContentRightsResult = objBMSServices.GetDealContentRights(DealContentRightsInput.since, DealContentRightsInput.assetId, DealContentRightsInput.dealId);
                }
            }
            catch (Exception ex)
            {
                throw;
                //_objRet.Message = ex.Message;
                //_objRet.IsSuccess = false;

                //objLog.Request_Xml = JsonConvert.SerializeObject(DealContentRightsInput);
                //objLog.Record_Status = "E";
                //objLog.Error_Description = _objRet.Message;
                //objLog.Response_Xml = JsonConvert.SerializeObject(lstDealContentRightsResult);
                //objLog.Response_Time = DateTime.Now;
                //_objRet.LogId = objBMSLogServices.InsertLog(objLog);

                //var response= Request.CreateResponse(HttpStatusCode.InternalServerError, new {  DealRightsData = lstDealContentRightsResult }, Configuration.Formatters.JsonFormatter);
                //response.Headers.Add("LogId", _objRet.LogId.ToString());
                //response.Headers.Add("Message", _objRet.Message);
                //response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                //return response;
            }

            //objLog.Response_Xml = JsonConvert.SerializeObject(lstDealContentRightsResult);
            //objLog.Response_Time = DateTime.Now;
            //_objRet.LogId = objBMSLogServices.InsertLog(objLog);

            if (_objRet.IsSuccess)
            {
                _objRet.Response = lstDealContentRightsResult;
                //var response= Request.CreateResponse(HttpStatusCode.OK, new {  DealRightsData = lstDealContentResult }, Configuration.Formatters.JsonFormatter);
                //response.Headers.Add("LogId", _objRet.LogId.ToString());
                //response.Headers.Add("Message", _objRet.Message);
                //response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                //return response;
            }
            //else
            //{
            //    var response= Request.CreateResponse(HttpStatusCode.BadRequest, new {  DealRightsData = lstDealContentResult }, Configuration.Formatters.JsonFormatter);
            //    response.Headers.Add("LogId", _objRet.LogId.ToString());
            //    response.Headers.Add("Message", _objRet.Message);
            //    response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
            //    return response;
            //}
            _objRet.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(_objRet, true);

            return response;
        }
    }

    public class AssetsInput
    {
        /// <summary>
        /// since is date from which Assets records needs to be fetch (Format : "dd-MM-yyyy")
        /// </summary>
        public string since { get; set; }
    }

    public class DealsInput
    {
        /// <summary>
        /// since is date from which Deals records needs to be fetch (Format : "dd-MM-yyyy")
        /// </summary>
        public string since { get; set; }
        /// <summary>
        /// AssetId used for fetching Deals Data for specific AssetId
        /// </summary>
        public string assetId { get; set; }
    }

    public class DealContentInput
    {
        /// <summary>
        /// since is date from which Deal Content records needs to be fetch (Format : "dd-MM-yyyy")
        /// </summary>
        public string since { get; set; }
        /// <summary>
        /// AssetId used for fetching Deal Content Data for specific AssetId
        /// </summary>
        public string assetId { get; set; }
        /// <summary>
        /// DealId used for fetching Deal Content Data for specific DealId
        /// </summary>
        public string dealId { get; set; }
    }

    public class DealContentRightsInput
    {
        /// <summary>
        /// since is date from which Deal Rights records needs to be fetch (Format : "dd-MM-yyyy")
        /// </summary>
        public string since { get; set; }
        /// <summary>
        /// AssetId used for fetching Deal Rights Data for specific AssetId
        /// </summary>
        public string assetId { get; set; }
        /// <summary>
        /// DealId used for fetching Deal Rights Data for specific DealId
        /// </summary>
        public string dealId { get; set; }
    }
}
