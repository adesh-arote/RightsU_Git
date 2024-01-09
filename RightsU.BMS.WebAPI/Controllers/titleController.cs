using Newtonsoft.Json;
using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.InputClasses;
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
        private readonly TitleServices objTitleServices = new TitleServices();
        private readonly System_Module_Service objSystemModuleServices = new System_Module_Service();

        /// <summary>
        /// Asset List 
        /// </summary>
        /// <remarks>Retrieves all available Assets</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
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
        public async Task<HttpResponseMessage> GetTitleList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "", string dateGt = "", string dateLt = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTitleServices.GetTitleList(order.ToString(), sort.ToString(), size, page, searchValue, dateGt, dateLt, 0);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
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

        /// <summary>
        /// Asset by id
        /// </summary>
        /// <remarks>Retrieves Assets by Id</remarks>
        /// <param name="id">get specific asset data using id.</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(TitleInput))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [Route("api/title/{id}")]
        public async Task<HttpResponseMessage> GetTitleById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTitleServices.GetTitleById(id.Value);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;                
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
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

        /// <summary>
        /// Save Asset Details
        /// </summary>
        /// <remarks>Create / Save New Asset</remarks>
        /// <param name="Input">Input data object for Create/Save New Asset</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPost]
        [Route("api/title")]
        public async Task<HttpResponseMessage> PostTitle(Title Input)
        {
            //Input.MetaData.ForEach(x =>
            //{
            //    if (x.Value.GetType() == typeof(Newtonsoft.Json.Linq.JArray))
            //    {
            //        var objjArray = (Newtonsoft.Json.Linq.JArray)x.Value;
            //        x.Value = objjArray.ToObject<List<ExtendedColumnDetails>>();
            //    }

            //});

            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTitleServices.PostTitle(Input);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
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

        /// <summary>
        /// Modify Asset details
        /// </summary>
        /// <remarks>Update / Modify Asset details by id</remarks>
        /// <param name="Input">Input data object for Modify existing Asset</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPut]
        [Route("api/title")]
        public async Task<HttpResponseMessage> PutTitle(Title Input)
        {            
            //Input.MetaData.ForEach(x =>
            //{
            //    if (x.Value.GetType() == typeof(Newtonsoft.Json.Linq.JArray))
            //    {
            //        var objjArray = (Newtonsoft.Json.Linq.JArray)x.Value;
            //        x.Value = objjArray.ToObject<List<ExtendedColumnDetails>>();
            //    }

            //});

            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTitleServices.PutTitle(Input);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
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

        /// <summary>
        /// Active/Deactive Status 
        /// </summary>
        /// <remarks>Modify Active/Deactive Status of Existing Asset</remarks>
        /// <param name="Input">Input data object for Modify existing Asset Active/Deactive Status</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPut]
        [Route("api/title/ChangeActiveStatus")]
        public async Task<HttpResponseMessage> ChangeActiveStatus(PutInput Input)
        {
            //string authenticationToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("Authorization").FirstOrDefault()).Replace("Bearer ", "");
            //string RefreshToken = Convert.ToString(HttpContext.Current.Request.Headers.GetValues("token").FirstOrDefault()).Replace("Bearer ", "");

            //if (!objSystemModuleServices.hasModuleRights(GlobalParams.Assets_Title_Post, authenticationToken, RefreshToken))
            //{
            //    HttpContext.Current.Response.AddHeader("AuthorizationStatus", "Forbidden");
            //    return Request.CreateResponse(HttpStatusCode.Forbidden, "Access Forbidden");
            //}

            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTitleServices.ChangeActiveStatus(Input);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
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
    }

    //public class TitleInput
    //{
    //    /// <summary>
    //    /// Defines how the results will be ordered
    //    /// </summary>
    //    /// <value>ASC</value>        
    //    public string order { get; set; } = "ASC";
    //    /// <summary>
    //    /// The page number that should be retrieved
    //    /// </summary>
    //    public Int32 page { get; set; } = 1;
    //    /// <summary>
    //    /// The size (total records) of each page
    //    /// </summary>
    //    public Int32 size { get; set; } = 50;
    //    /// <summary>
    //    /// The value of the search across the plan name
    //    /// </summary>
    //    /// <summary>
    //    /// Defines on which attribute the results should be sorted
    //    /// </summary>
    //    /// <example>CREATED_DATE</example>               
    //    public string sort { get; set; } = "Last_UpDated_Time";
    //    public string search { get; set; }
    //    public string date_gt { get; set; }
    //    public string date_lt { get; set; }
    //}
}
