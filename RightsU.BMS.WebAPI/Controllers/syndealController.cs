using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using RightsU.BMS.WebAPI.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace RightsU.BMS.WebAPI.Controllers
{
    [SwaggerConsumes("application/json")]
    [SwaggerProduces("application/json")]
    [HideInDocs]
    [AssetsLogFilter]
    [CustomExceptionFilter]
    public class syndealController : ApiController
    {
        private readonly SynDealServices objSynDealServices = new SynDealServices();

        /// <summary>
        /// Save Syndication Deal General Details
        /// </summary>
        /// <remarks>Create / Save New Syndication Deal General</remarks>
        /// <param name="Input">Input data object for Create/Save New Syndication Deal General</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPost]
        [Route("api/syndeal")]
        public async Task<HttpResponseMessage> Post(Syn_Deal Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objSynDealServices.Post(Input);

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
        /// Modify Syndication Deal General details
        /// </summary>
        /// <remarks>Update / Modify Syndication Deal General details by id</remarks>
        /// <param name="Input">Input data object for Modify existing Syndication Deal General</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPut]
        [Route("api/syndeal")]
        public async Task<HttpResponseMessage> Put(Syn_Deal Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objSynDealServices.Put(Input);

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
