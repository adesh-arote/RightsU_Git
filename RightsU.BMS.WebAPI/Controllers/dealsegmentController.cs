using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.ReturnClasses;
using RightsU.BMS.Entities.Master_Entities;
using RightsU.BMS.WebAPI.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
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
    public class dealsegmentController : ApiController
    {
        public enum SortColumn
        {
            DealSegmentName = 1
        }

        private readonly DealSegmentService objDealSegmentServices = new DealSegmentService();
        // <summary>
        /// DealSegment List 
        /// </summary>
        /// <remarks>Retrieves all available DealSegment</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the DealSegment</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(Deal_Segment))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [System.Web.Http.Route("api/dealsegment")]
        public async Task<HttpResponseMessage> GetDealSegmentList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealSegmentServices.GetDealSegmentList(order.ToString(), sort.ToString(), size, page, searchValue);

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
        /// DealSegment by id
        /// </summary>
        /// <remarks>Retrieves DealSegment by Id</remarks>
        /// <param name="id">get specific DealSegment data using id.</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(Deal_Segment))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [Route("api/dealsegment/{id}")]
        public async Task<HttpResponseMessage> GetDealSegmentById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealSegmentServices.GetDealSegmentById(id.Value);

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
                var xyz = System.Text.Json.JsonSerializer.Serialize<GenericReturn>(objReturn);

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
        /// Save DealSegment Details
        /// </summary>
        /// <remarks>Create / Save New DealSegment</remarks>
        /// <param name="Input">Input data object for Create/Save New DealSegment</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPost]
        [Route("api/dealsegment")]
        public async Task<HttpResponseMessage> PostDealSegment(Deal_Segment Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;


            GenericReturn objReturn = objDealSegmentServices.PostDealSegment(Input);

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
                var xyz = System.Text.Json.JsonSerializer.Serialize<GenericReturn>(objReturn);

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
        /// Modify DealSegment details
        /// </summary>
        /// <remarks>Update / Modify DealSegment details by id</remarks>
        /// <param name="Input">Input data object for Modify existing DealSegment</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPut]
        [Route("api/dealsegment")]
        public async Task<HttpResponseMessage> PutDealSegment(Deal_Segment Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = new GenericReturn();
            objReturn = objDealSegmentServices.PutDealSegment(Input);

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