using Newtonsoft.Json;
using RightsU.Audit.BLL.Services;
using RightsU.Audit.Entities.FrameworkClasses;
using RightsU.Audit.Entities.HTTP;
using RightsU.Audit.Entities.HttpModel;
using RightsU.Audit.Entities.InputEntities;
using RightsU.Audit.WebAPI.Filters;
using RightsU.Audit.WebAPI.Models;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;

namespace RightsU.Audit.WebAPI.Controllers
{
    [SwaggerConsumes("application/json")]
    [SwaggerProduces("application/json")]
    [HideInDocs]
    //[AuthAttribute]
    [CustomExceptionFilter]
    public class AuditLogController : ApiController
    {
        public enum order
        {
            Asc = 1,
            Desc = 2
        }
        public enum sort
        {
            IntCode = 1,
            Version = 2
        }

        private readonly USPService objUSPServices = new USPService();

        /// <summary>
        /// Master Audit Log
        /// </summary>
        /// <remarks>This API will be used to store Master Audit data.</remarks>
        /// <param name="Input"></param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Success", Type = typeof(PostReturn))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Invalid AuthKey")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / AuthKey Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [LogFilter]
        [HttpPost]
        [Route("api/masterauditlog")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public async Task<HttpResponseMessage> masterauditlog(MasterAuditLogInput Input)
        {
            var response = new HttpResponseMessage();

            DateTime startTime;
            startTime = DateTime.Now;
            Input.requestId = Input.isExternal == true ? HttpContext.Current.Request.Headers["LogRequestId"] : string.Empty;
            
            PostReturn objReturn = objUSPServices.InsertAuditLog(Input);
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
        /// Master Audit List
        /// </summary>
        /// <remarks>This API will be used to get Master Audit data for the specific master using Search Value and date criteria.</remarks>
        /// <param name="order">Only below keyward are allowed "ASC","DESC"</param>
        /// <param name="sort">Only below keyward are allowed "IntCode","Version"</param>
        /// <param name="requestFrom">Linux Date and Time format</param>
        /// <param name="requestTo">Linux Date and Time format</param>
        /// <param name="moduleCode">Audit data of a specific transaction, only one module code is allowed</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the LogData</param>
        /// <param name="user">User name of a specific action, multiple users with "," separator allowed for output.</param>
        /// <param name="userAction">Specific User action, search with multiple actions like "C,X,A" allowed.</param>
        /// <param name="includePrevAuditVesion">Default "N"-Values "Y"/"N" pass "Y" to include the previous 1 version of data even if not fall into the provided period bracket.</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Success", Type = typeof(GenericReturn))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Invalid AuthKey")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / AuthKey Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [LogFilter]
        [HttpGet]
        [Route("api/masterauditlist")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public async Task<HttpResponseMessage> masterauditlist(order order, sort sort, Int32 requestFrom, Int32 requestTo, Int32 moduleCode, Int32 size = 0, Int32 page = 0, string searchValue = "", string user = "", string userAction = "")//, string includePrevAuditVesion = ""
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objUSPServices.GetAuditLogList(order.ToString(), sort.ToString(), size, page, requestFrom, requestTo, moduleCode, searchValue, user, userAction, "N");

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
}
