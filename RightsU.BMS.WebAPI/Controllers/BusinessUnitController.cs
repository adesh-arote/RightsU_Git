using RightsU.BMS.WebAPI.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using RightsU.BMS.Entities.Master_Entities;
using System.Threading.Tasks;
using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.ReturnClasses;

namespace RightsU.BMS.WebAPI.Controllers
{
    [SwaggerConsumes("application/json")]
    [SwaggerProduces("application/json")]
    [HideInDocs]
    [AssetsLogFilter]
    [CustomExceptionFilter]
    public class businessunitController : ApiController
    {

        public enum SortColumn
        {
            BusinessUnitName = 1,
            //IsActive = 2,
        }
        private readonly BusinessUnitService objBusinessUnitService = new BusinessUnitService();
        /// <summary>
        /// Asset List 
        /// </summary>
        /// <remarks>Retrieves all available Assets</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(BusinessUnitReturn))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]

        [HttpGet]
        [Route("api/businessunit")]
        public async Task<HttpResponseMessage> GetBusinessUnit(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objBusinessUnitService.GetBusinessUnit(order.ToString(), sort.ToString(), size, page, searchValue, 0);
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
    }
}
