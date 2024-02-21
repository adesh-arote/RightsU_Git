using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using RightsU.BMS.WebAPI.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace RightsU.BMS.WebAPI.Controllers
{
    [DisplayName("Acquisition Deal Rights")]
    [Route("api/acqdealrights")]
    public class AcqDealRightsController : BaseController
    {
        public readonly AcqDealRightsServices objAcqDealRightsServices = new AcqDealRightsServices();

        /// <summary>
        /// Get Specific Acquisition Right
        /// </summary>
        /// <remarks>Retrieves acquisition right by Id</remarks>
        /// <param name="id">Get specific acquisition right data using id.</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/acqdealrights/{id}")]
        public async Task<HttpResponseMessage> GetAcqDealRightsById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objAcqDealRightsServices.GetById(id.Value);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /// <summary>
        /// Create Acquisition Right
        /// </summary>
        /// <remarks>Using this api new acquisition rights will be created</remarks>
        /// <param name="Input">Input data object for create new acquisition rights</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> AcqDealRightsPost(Acq_Deal_Rights Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objAcqDealRightsServices.Post(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Delete Acquisition Right
        /// </summary>
        /// <remarks>Using this api existing acquisition right can be delete</remarks>
        /// <param name="id">delete specific acquisition right data using id.</param>
        /// <returns></returns>
        [HttpDelete]
        [Route("api/acqdealrights/{id}")]
        public async Task<HttpResponseMessage> Delete(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objAcqDealRightsServices.Delete(id.Value);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Modify Acquisition Right
        /// </summary>
        /// <remarks>Using this api existing acquisition right can be modify</remarks>
        /// <param name="Input">Input data object for Modify existing acquisition right</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<HttpResponseMessage> Put(Acq_Deal_Rights Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objAcqDealRightsServices.Put(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }
    }
}
