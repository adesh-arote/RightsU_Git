using Newtonsoft.Json;
using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.ReturnClasses;
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
    [SysLogFilter]
    [CustomExceptionFilter]
    public class titleController : ApiController
    {
        private readonly TitleServices objTitleServices = new TitleServices();
        private readonly System_Module_Service objSystemModuleServices = new System_Module_Service();

        /// <summary>
        /// Title List 
        /// </summary>
        /// <remarks>Retrieves all available Titles</remarks>
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
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn.Response, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }

            return response;
        }

        /// <summary>
        /// Title by id
        /// </summary>
        /// <remarks>Retrieves Title by Id</remarks>
        /// <param name="id">get specific title data using id.</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(Title))]
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

            GenericReturn objReturn = objTitleServices.GetTitleById(id);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;                
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn.Response, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }

            return response;
        }

        /// <summary>
        /// Save Title Details
        /// </summary>
        /// <remarks>Create / Save New Title</remarks>
        /// <param name="Input">Input data object for Create/Save New Title</param>
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
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTitleServices.PostTitle(Input);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }

            return response;
        }

        /// <summary>
        /// Modify Title details
        /// </summary>
        /// <remarks>Update / Modify Title details by id</remarks>
        /// <param name="Input">Input data object for Modify existing Title</param>
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
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTitleServices.PutTitle(Input);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }

            return response;
        }

        /// <summary>
        /// Active/Deactive Status 
        /// </summary>
        /// <remarks>Modify Active/Deactive Status of Existing Title</remarks>
        /// <param name="Input">Input data object for Modify existing Title Active/Deactive Status</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPut]
        [Route("api/title/ChangeActiveStatus")]
        public async Task<HttpResponseMessage> ChangeActiveStatus(Title Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTitleServices.ChangeActiveStatus(Input);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.InternalServerError)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.InternalServerError, objReturn, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("timetaken", Convert.ToString(objReturn.TimeTaken));
                response.Headers.Add("request_completion", Convert.ToString(objReturn.IsSuccess));
                response.Headers.Add("message", objReturn.Message);
                return response;
            }

            return response;
        }
    }
}
