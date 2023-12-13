using Newtonsoft.Json;
using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using RightsU.BMS.WebAPI.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace RightsU.BMS.WebAPI.Controllers
{
    [SwaggerConsumes("application/json")]
    [SwaggerProduces("application/json")]
    [HideInDocs]
    [AssetsLogFilter]
    [CustomExceptionFilter]
    public class titleController : ApiController
    {
        public enum Order
        {
            Asc = 1,
            Desc = 2
        }
        public enum SortColumn
        {
            CreatedDate = 1,
            UpdatedDate = 2,
            TitleName = 3
        }

        private readonly TitleServices objTitleServices = new TitleServices();
        private readonly System_Module_Service objSystemModuleServices = new System_Module_Service();

        /// <summary>
        /// Asset List 
        /// </summary>
        /// <remarks>Retrieves all available Assets</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="search">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <param name="dateGt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <param name="dateLt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(TitleReturn))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [Route("api/title")]
        public async Task<HttpResponseMessage> GetTitleList(Order order, SortColumn sort, Int32 page, Int32 size, string search = "", string dateGt = "", string dateLt = "")
        {
            string authenticationToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("Authorization").FirstOrDefault()).Replace("Bearer ", "");
            string RefreshToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("token").FirstOrDefault()).Replace("Bearer ", "");

            if (!objSystemModuleServices.hasModuleRights(GlobalParams.Assets_List, authenticationToken, RefreshToken))
            {
                HttpContext.Current.Response.AddHeader("AuthorizationStatus", "Forbidden");
                return Request.CreateResponse(HttpStatusCode.Forbidden, "Access Forbidden");
            }

            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GetReturn objReturn = objTitleServices.GetTitleList(order.ToString(), sort.ToString(), size, page, search, dateGt, dateLt, 0);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn.AssetResponse, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }

            return response;
        }

        #region Old api/title

        //public HttpResponseMessage Get(Order order, SortColumn sort, Int32 page, Int32 size, string search = "", string dateGt = "", string dateLt = "")
        //{
        //    string authenticationToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("Authorization").FirstOrDefault()).Replace("Bearer ", "");
        //    string RefreshToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("token").FirstOrDefault()).Replace("Bearer ", "");

        //    if (!objSystemModuleServices.hasModuleRights(GlobalParams.Assets_List, authenticationToken, RefreshToken))
        //    {
        //        HttpContext.Current.Response.AddHeader("AuthorizationStatus", "Forbidden");
        //        return Request.CreateResponse(HttpStatusCode.Forbidden, "Access Forbidden");
        //    }

        //    Return _objRet = new Return();
        //    _objRet.Message = "Success";
        //    _objRet.IsSuccess = true;

        //    TitleInput Input = new TitleInput();
        //    BMS_Log objLog = new BMS_Log();

        //    #region Input Validations

        //    if (!string.IsNullOrEmpty(order.ToString()))
        //    {
        //        if (order.ToString() == Order.Ascending.ToString())
        //        {
        //            Input.order = "ASC";
        //        }
        //        else if (order.ToString() == Order.Descending.ToString())
        //        {
        //            Input.order = "DESC";
        //        }
        //        else
        //        {
        //            _objRet.Message = "Input Paramater 'order' is not in valid format";
        //            _objRet.IsSuccess = false;
        //            objLog.Record_Status = "E";
        //            objLog.Error_Description = _objRet.Message;
        //        }
        //    }

        //    if (page > 0)
        //    {
        //        Input.page = page;
        //    }
        //    else
        //    {
        //        _objRet.Message = "Input Paramater 'page' should be greater than or equal to 1";
        //        _objRet.IsSuccess = false;
        //        objLog.Record_Status = "E";
        //        objLog.Error_Description = _objRet.Message;
        //    }

        //    if (size > 0)
        //    {
        //        Int32 definedPageSize = Convert.ToInt32(ConfigurationManager.AppSettings["pageSize"]);
        //        if (size > definedPageSize)
        //        {
        //            _objRet.Message = "Input Paramater 'size' should be less than or equal to " + definedPageSize;
        //            _objRet.IsSuccess = false;
        //            objLog.Record_Status = "E";
        //            objLog.Error_Description = _objRet.Message;
        //        }
        //        else
        //        {
        //            Input.size = size;
        //        }
        //    }
        //    else
        //    {
        //        _objRet.Message = "Input Paramater 'size' should be greater than or equal to 1";
        //        _objRet.IsSuccess = false;
        //        objLog.Record_Status = "E";
        //        objLog.Error_Description = _objRet.Message;
        //    }

        //    if (!string.IsNullOrEmpty(sort.ToString()))
        //    {
        //        if (sort.ToString() == SortColumn.CreatedDate.ToString())
        //        {
        //            Input.sort = "Inserted_On";
        //        }
        //        else if (sort.ToString() == SortColumn.UpdatedDate.ToString())
        //        {
        //            Input.sort = "Last_UpDated_Time";
        //        }
        //        else if (sort.ToString() == SortColumn.TitleName.ToString())
        //        {
        //            Input.sort = "Title_Name";
        //        }
        //        else
        //        {
        //            _objRet.Message = "Input Paramater 'sort' is not in valid format";
        //            _objRet.IsSuccess = false;
        //            objLog.Record_Status = "E";
        //            objLog.Error_Description = _objRet.Message;
        //        }
        //    }

        //    if (!string.IsNullOrEmpty(search))
        //    {
        //        Input.search = search;
        //    }

        //    try
        //    {
        //        if (!string.IsNullOrEmpty(dateGt))
        //        {
        //            try
        //            {
        //                Input.date_gt = DateTime.Parse(dateGt).ToString("yyyy-MM-dd");
        //            }
        //            catch (Exception ex)
        //            {
        //                _objRet.Message = "Input Paramater 'dateGt' is not in valid format";
        //                _objRet.IsSuccess = false;
        //                objLog.Record_Status = "E";
        //                objLog.Error_Description = _objRet.Message;
        //            }

        //        }
        //        if (!string.IsNullOrEmpty(dateLt))
        //        {
        //            try
        //            {
        //                Input.date_lt = DateTime.Parse(dateLt).ToString("yyyy-MM-dd");
        //            }
        //            catch (Exception ex)
        //            {
        //                _objRet.Message = "Input Paramater 'dateLt' is not in valid format";
        //                _objRet.IsSuccess = false;
        //                objLog.Record_Status = "E";
        //                objLog.Error_Description = _objRet.Message;
        //            }
        //        }

        //        if (!string.IsNullOrEmpty(dateGt) && !string.IsNullOrEmpty(dateLt))
        //        {
        //            if (DateTime.Parse(dateGt) > DateTime.Parse(dateLt))
        //            {
        //                _objRet.Message = "Input Paramater 'dateLt' should not be less than 'dateGt'";
        //                _objRet.IsSuccess = false;
        //                objLog.Record_Status = "E";
        //                objLog.Error_Description = _objRet.Message;
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        _objRet.Message = "Input Paramater 'dateLt' or 'dateGt' is not in valid format";
        //        _objRet.IsSuccess = false;
        //        objLog.Record_Status = "E";
        //        objLog.Error_Description = _objRet.Message;
        //    }

        //    #endregion

        //    objLog.Request_Time = DateTime.Now;
        //    objLog.Module_Name = "Title";
        //    objLog.Method_Type = Request.Method.Method;
        //    objLog.Record_Status = "D";
        //    objLog.Request_Xml = JsonConvert.SerializeObject(Input);

        //    TitleReturn _TitleReturn = new TitleReturn();

        //    try
        //    {
        //        if (_objRet.IsSuccess)
        //        {
        //            _TitleReturn = objTitleServices.List_Titles(Input.order.ToString(), Input.page, Input.search, Input.size, Input.sort.ToString(), Input.date_gt, Input.date_lt, 0);

        //            for (int i = 0; i < _TitleReturn.assets.Count(); i++)
        //            {
        //                List<USP_Bind_Extend_Column_Grid_Result> lstExtended = new List<USP_Bind_Extend_Column_Grid_Result>();
        //                lstExtended = objTitleServices.USP_Bind_Extend_Column_Grid(_TitleReturn.assets[i].Id);

        //                if (lstExtended.Count() > 0)
        //                {
        //                    var objGroupCode = lstExtended.Where(x => x.Extended_Group_Code != null).Select(x => x.Extended_Group_Code).Distinct().ToList();

        //                    foreach (Int32 item in objGroupCode)
        //                    {
        //                        string strGroupName = lstExtended.Where(x => x.Extended_Group_Code == item).Select(x => x.Group_Name).Distinct().FirstOrDefault();
        //                        Dictionary<string, string> objDictionary = new Dictionary<string, string>();
        //                        lstExtended.Where(x => x.Extended_Group_Code == item).ToList().ForEach(x =>
        //                        {
        //                            if (string.IsNullOrEmpty(x.Column_Value))
        //                            {
        //                                objDictionary.Add(x.Columns_Name, x.Name);
        //                            }
        //                            else
        //                            {
        //                                objDictionary.Add(x.Columns_Name, x.Column_Value);
        //                            }

        //                        });

        //                        _TitleReturn.assets[i].MetaData.Add(strGroupName, objDictionary);
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        _objRet.Message = ex.Message;
        //        _objRet.IsSuccess = false;
        //        objLog.Request_Xml = JsonConvert.SerializeObject(Input);
        //        objLog.Error_Description = _objRet.Message;
        //        objLog.Record_Status = "E";
        //        objLog.Response_Xml = JsonConvert.SerializeObject(_TitleReturn);
        //        objLog.Response_Time = DateTime.Now;
        //        _objRet.LogId = objBMSLogServices.InsertLog(objLog);

        //        var response = Request.CreateResponse(HttpStatusCode.InternalServerError, _TitleReturn, Configuration.Formatters.JsonFormatter);
        //        response.Headers.Add("requestid", _objRet.LogId.ToString());
        //        response.Headers.Add("message", _objRet.Message);
        //        response.Headers.Add("issuccess", _objRet.IsSuccess.ToString());
        //        return response;
        //    }

        //    objLog.Response_Xml = JsonConvert.SerializeObject(_TitleReturn);
        //    objLog.Response_Time = DateTime.Now;
        //    _objRet.LogId = objBMSLogServices.InsertLog(objLog);

        //    _TitleReturn.paging.page = page;
        //    _TitleReturn.paging.size = size;

        //    if (_objRet.IsSuccess)
        //    {
        //        var response = Request.CreateResponse(HttpStatusCode.OK, _TitleReturn, Configuration.Formatters.JsonFormatter); ;
        //        response.Headers.Add("requestid", _objRet.LogId.ToString());
        //        response.Headers.Add("message", _objRet.Message);
        //        response.Headers.Add("issuccess", _objRet.IsSuccess.ToString());
        //        return response;
        //    }
        //    else
        //    {
        //        var response = Request.CreateResponse(HttpStatusCode.BadRequest, _TitleReturn, Configuration.Formatters.JsonFormatter); ;
        //        response.Headers.Add("requestid", _objRet.LogId.ToString());
        //        response.Headers.Add("message", _objRet.Message);
        //        response.Headers.Add("issuccess", _objRet.IsSuccess.ToString());
        //        return response;
        //    }
        //}

        #endregion

        /// <summary>
        /// Asset by id
        /// </summary>
        /// <remarks>Retrieves Assets by Id</remarks>
        /// <param name="id">get specific asset data using id.</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(TitleReturn))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [Route("api/title/{id}")]
        public async Task<HttpResponseMessage> GetTitleById(int? id)
        {
            string authenticationToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("Authorization").FirstOrDefault()).Replace("Bearer ", "");
            string RefreshToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("token").FirstOrDefault()).Replace("Bearer ", "");

            if (!objSystemModuleServices.hasModuleRights(GlobalParams.Assets_GetById, authenticationToken, RefreshToken))
            {
                HttpContext.Current.Response.AddHeader("AuthorizationStatus", "Forbidden");
                return Request.CreateResponse(HttpStatusCode.Forbidden, "Access Forbidden");
            }

            var abc = Convert.ToInt32("hello");

            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GetTitleReturn objReturn = objTitleServices.GetTitleById(id.Value);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;                
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn.AssetResponse, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }

            return response;
        }

        #region api/title/{id}

        //public HttpResponseMessage Get(int? id)
        //{
        //    string authenticationToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("Authorization").FirstOrDefault()).Replace("Bearer ", "");
        //    string RefreshToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("token").FirstOrDefault()).Replace("Bearer ", "");

        //    if (!objSystemModuleServices.hasModuleRights(GlobalParams.Assets_GetById, authenticationToken, RefreshToken))
        //    {
        //        HttpContext.Current.Response.AddHeader("AuthorizationStatus", "Forbidden");
        //        return Request.CreateResponse(HttpStatusCode.Forbidden, "Access Forbidden");
        //    }

        //    Return _objRet = new Return();
        //    _objRet.Message = "Success";
        //    _objRet.IsSuccess = true;

        //    BMS_Log objLog = new BMS_Log();
        //    objLog.Request_Time = DateTime.Now;
        //    objLog.Module_Name = "Title";
        //    objLog.Method_Type = Request.Method.Method;
        //    objLog.Record_Status = "D";
        //    objLog.Request_Xml = JsonConvert.SerializeObject(id);

        //    if (id.Value == 0)
        //    {
        //        _objRet.Message = "Input Paramater 'id' is mandatory";
        //        _objRet.IsSuccess = false;
        //        objLog.Record_Status = "E";
        //        objLog.Error_Description = _objRet.Message;
        //    }

        //    title _TitleReturn = new title();
        //    try
        //    {
        //        if (_objRet.IsSuccess)
        //        {
        //            _TitleReturn = objTitleServices.GetById(id.Value);

        //            if (_TitleReturn != null)
        //            {
        //                List<USP_Bind_Extend_Column_Grid_Result> lstExtended = new List<USP_Bind_Extend_Column_Grid_Result>();
        //                lstExtended = objTitleServices.USP_Bind_Extend_Column_Grid(_TitleReturn.Id);

        //                if (lstExtended.Count() > 0)
        //                {
        //                    var objGroupCode = lstExtended.Select(x => x.Extended_Group_Code).Distinct().ToList();

        //                    foreach (Int32 item in objGroupCode)
        //                    {
        //                        string strGroupName = lstExtended.Where(x => x.Extended_Group_Code == item).Select(x => x.Group_Name).Distinct().FirstOrDefault();
        //                        Dictionary<string, string> objDictionary = new Dictionary<string, string>();
        //                        lstExtended.Where(x => x.Extended_Group_Code == item).ToList().ForEach(x =>
        //                        {
        //                            if (string.IsNullOrEmpty(x.Column_Value))
        //                            {
        //                                objDictionary.Add(x.Columns_Name, x.Name);
        //                            }
        //                            else
        //                            {
        //                                objDictionary.Add(x.Columns_Name, x.Column_Value);
        //                            }

        //                        });

        //                        _TitleReturn.MetaData.Add(strGroupName, objDictionary);
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        _objRet.Message = ex.Message;
        //        _objRet.IsSuccess = false;
        //        objLog.Request_Xml = JsonConvert.SerializeObject(id);
        //        objLog.Error_Description = _objRet.Message;
        //        objLog.Record_Status = "E";
        //        objLog.Response_Xml = JsonConvert.SerializeObject(_TitleReturn);
        //        objLog.Response_Time = DateTime.Now;
        //        _objRet.LogId = objBMSLogServices.InsertLog(objLog);

        //        var response = Request.CreateResponse(HttpStatusCode.InternalServerError, _TitleReturn, Configuration.Formatters.JsonFormatter);
        //        response.Headers.Add("requestid", _objRet.LogId.ToString());
        //        response.Headers.Add("message", _objRet.Message);
        //        response.Headers.Add("issuccess", _objRet.IsSuccess.ToString());
        //        return response;
        //    }

        //    objLog.Response_Xml = JsonConvert.SerializeObject(_TitleReturn);
        //    objLog.Response_Time = DateTime.Now;
        //    _objRet.LogId = objBMSLogServices.InsertLog(objLog);

        //    if (_objRet.IsSuccess)
        //    {
        //        var response = Request.CreateResponse(HttpStatusCode.OK, _TitleReturn, Configuration.Formatters.JsonFormatter); ;
        //        response.Headers.Add("requestid", _objRet.LogId.ToString());
        //        response.Headers.Add("message", _objRet.Message);
        //        response.Headers.Add("issuccess", _objRet.IsSuccess.ToString());
        //        return response;
        //    }
        //    else
        //    {
        //        var response = Request.CreateResponse(HttpStatusCode.BadRequest, new { }, Configuration.Formatters.JsonFormatter); ;
        //        response.Headers.Add("requestid", _objRet.LogId.ToString());
        //        response.Headers.Add("message", _objRet.Message);
        //        response.Headers.Add("issuccess", _objRet.IsSuccess.ToString());
        //        return response;
        //    }
        //}

        #endregion
    }

    public class TitleInput
    {
        /// <summary>
        /// Defines how the results will be ordered
        /// </summary>
        /// <value>ASC</value>        
        public string order { get; set; } = "ASC";
        /// <summary>
        /// The page number that should be retrieved
        /// </summary>
        public Int32 page { get; set; } = 1;
        /// <summary>
        /// The size (total records) of each page
        /// </summary>
        public Int32 size { get; set; } = 50;
        /// <summary>
        /// The value of the search across the plan name
        /// </summary>
        /// <summary>
        /// Defines on which attribute the results should be sorted
        /// </summary>
        /// <example>CREATED_DATE</example>               
        public string sort { get; set; } = "Last_UpDated_Time";
        public string search { get; set; }
        public string date_gt { get; set; }
        public string date_lt { get; set; }
    }
}
