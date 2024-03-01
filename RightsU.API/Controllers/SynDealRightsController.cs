using RightsU.API.BLL.Services;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using RightsU.API.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace RightsU.API.Controllers
{
    [DisplayName("Syndication Deal Rights")]
    [Route("api/syndealrights")]
    public class SynDealRightsController : BaseController
    {
        public readonly Syn_Deal_RightsServices objSyn_Deal_RightsServices = new Syn_Deal_RightsServices();

        /// <summary>
        /// Create Syndication Right
        /// </summary>
        /// <remarks>Using this api new syndication rights will be created</remarks>
        /// <param name="Input">Input data object for create new syndication rights</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> syndealrightsPost(Syn_Deal_Rights Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objSyn_Deal_RightsServices.Post(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Modify Syndication Right
        /// </summary>
        /// <remarks>Using this api existing syndication right can be modify</remarks>
        /// <param name="Input">Input data object for Modify existing syndication right</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<HttpResponseMessage> Put(Syn_Deal_Rights Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objSyn_Deal_RightsServices.Put(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Get Specific Syndication Right
        /// </summary>
        /// <remarks>Retrieves syndication right by Id</remarks>
        /// <param name="id">Get specific syndication right data using id.</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/syndealrights/{id}")]
        public async Task<HttpResponseMessage> GetsyndealrightsById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objSyn_Deal_RightsServices.GetById(id.Value);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /*
        /// <summary>
        /// Delete Syn Dela Rights
        /// </summary>
        /// <remarks>Delete deal rights by id</remarks>
        /// <param name="id">delete specific deal rights data using id.</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(Syn_Deal_Rights))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpDelete]
        [Route("api/syndealrights/{id}")]
        public async Task<HttpResponseMessage> Delete(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objSyn_Deal_RightsServices.Delete(id.Value);

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
        */

    }
}
