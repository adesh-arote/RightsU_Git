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
    public class rightruleController : ApiController
    {
        public enum SortColumn
        {
            CreatedDate = 1,
            UpdatedDate = 2,
            RightRuleName = 3
        }

        private readonly RightRuleService objRightRuleServices = new RightRuleService();
        /// <summary>
        /// RightRule List 
        /// </summary>
        /// <remarks>Retrieves all available RightRule</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the RightRule</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <param name="dateGt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <param name="dateLt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(RightRule))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [System.Web.Http.Route("api/rightrule")]
        public async Task<HttpResponseMessage> GetRightRuleList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "", string dateGt = "", string dateLt = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objRightRuleServices.GetRightRuleList(order.ToString(), sort.ToString(), size, page, searchValue, dateGt, dateLt);

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
        /// RightRule by id
        /// </summary>
        /// <remarks>Retrieves RightRule by Id</remarks>
        /// <param name="id">get specific RightRule data using id.</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(RightRule))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [Route("api/rightrule/{id}")]
        public async Task<HttpResponseMessage> GetRightRuleById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objRightRuleServices.GetRightRuleById(id.Value);

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
        /// Save RightRule Details
        /// </summary>
        /// <remarks>Create / Save New RightRule</remarks>
        /// <param name="Input">Input data object for Create/Save New RightRule</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPost]
        [Route("api/rightrule")]
        public async Task<HttpResponseMessage> PostRightRule(RightRule Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;


            GenericReturn objReturn = objRightRuleServices.PostRightRule(Input);

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
        /// Modify RightRule details
        /// </summary>
        /// <remarks>Update / Modify RightRule details by id</remarks>
        /// <param name="Input">Input data object for Modify existing RightRule</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPut]
        [Route("api/rightrule")]
        public async Task<HttpResponseMessage> PutRightRule(RightRule Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = new GenericReturn();
            objReturn = objRightRuleServices.PutRightRule(Input);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn.Response, Configuration.Formatters.JsonFormatter);
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
        /// <remarks>Modify Active/Deactive Status of Existing RightRule</remarks>
        /// <param name="Input">Input data object for Modify existing RightRule Active/Deactive Status</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPut]
        [Route("api/rightrule/ChangeActiveStatus")]
        public async Task<HttpResponseMessage> ChangeActiveStatus(RightRule Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = new GenericReturn();
            objReturn = objRightRuleServices.ChangeActiveStatus(Input);

            if (objReturn.StatusCode == HttpStatusCode.OK)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.OK, objReturn, Configuration.Formatters.JsonFormatter);
                return response;
            }
            else if (objReturn.StatusCode == HttpStatusCode.BadRequest)
            {
                objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                response = Request.CreateResponse(HttpStatusCode.BadRequest, objReturn.Response, Configuration.Formatters.JsonFormatter);
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
}