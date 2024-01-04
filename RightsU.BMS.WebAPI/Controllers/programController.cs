using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.InputClasses;
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
    [AssetsLogFilter]
    [CustomExceptionFilter]
    public class programController : ApiController
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
            ProgramName = 3
        }

        private readonly ProgramServices objProgramServices = new ProgramServices();
        private readonly System_Module_Service objSystemModuleServices = new System_Module_Service();

        /// <summary>
        /// Program List 
        /// </summary>
        /// <remarks>Retrieves all available Program</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <param name="dateGt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <param name="dateLt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(ProgramReturn))]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpGet]
        [Route("api/program")]
        public async Task<HttpResponseMessage> GetProgramList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "", string dateGt = "", string dateLt = "")
        {           

            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objProgramServices.GetProgramList(order.ToString(), sort.ToString(), size, page, searchValue, dateGt, dateLt, 0);

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
        /// <remarks>Modify Active/Deactive Status of Existing Program</remarks>
        /// <param name="Input">Input data object for Modify existing program Active/Deactive Status</param>
        /// <returns></returns>
        [SwaggerResponse(HttpStatusCode.OK, "Status ok / Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error / Bad Request")]
        [SwaggerResponse(HttpStatusCode.Unauthorized, "Unauthorized / Token Expried / Invalid Token")]
        [SwaggerResponse(HttpStatusCode.Forbidden, "Access Forbidden")]
        [SwaggerResponse(HttpStatusCode.ExpectationFailed, "Expectation Failed / Token Missing")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPut]
        [Route("api/program/ChangeActiveStatus")]
        public async Task<HttpResponseMessage> ChangeActiveStatus(PutInput Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = new GenericReturn();
            objReturn = objProgramServices.ChangeActiveStatus(Input);
            objReturn.StatusCode = HttpStatusCode.OK;

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
