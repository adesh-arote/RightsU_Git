using RightsU.API.BLL.Services;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using RightsU.API.Entities.ReturnClasses;
using Swashbuckle.Swagger.Annotations;
using System;
using System.ComponentModel;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace RightsU.API.Controllers
{
    [DisplayName("Acquisition Deal")]
    [Route("api/acqdeal")]
    //[SwaggerResponse(HttpStatusCode.OK, "Status ok / Success", Type = typeof(DealReturn))]
    public class AcqDealController : BaseController
    {
        private readonly DealServices objDealServices = new DealServices();

        public enum SortColumn
        {
            CreatedDate = 1,
            UpdatedDate = 2
        }

        /// <summary>
        /// Deal General List 
        /// </summary>
        /// <remarks>Retrieves all available Deal General</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <param name="dateGt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <param name="dateLt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<HttpResponseMessage> GetDealList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "", string dateGt = "", string dateLt = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealServices.GetDealList(order.ToString(), sort.ToString(), size, page, searchValue, dateGt, dateLt);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /// <summary>
        /// Deal General by id
        /// </summary>
        /// <remarks>Retrieves Deal General by Id</remarks>
        /// <param name="id">get specific deal data using id.</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/acqdeal/{id}")]
        public async Task<HttpResponseMessage> GetDealById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealServices.GetById(id);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /// <summary>
        /// Save Deal General Details
        /// </summary>
        /// <remarks>Create / Save New Deal General</remarks>
        /// <param name="Input">Input data object for Create/Save New Deal General</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> Post(Acq_Deal Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealServices.Post(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Modify Deal General details
        /// </summary>
        /// <remarks>Update / Modify Deal General details by id</remarks>
        /// <param name="Input">Input data object for Modify existing Deal General</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<HttpResponseMessage> Put(Acq_Deal Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealServices.Put(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Delete Deal General details
        /// </summary>
        /// <remarks>Delete Deal General details by id</remarks>
        /// <param name="id">delete specific deal data using id.</param>
        /// <returns></returns>
        [HttpDelete]
        [Route("api/acqdeal/{deal_id}")]
        public async Task<HttpResponseMessage> Delete(int? deal_id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealServices.Delete(deal_id);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Deal Complete Status
        /// </summary>
        /// <remarks>Check Deal Complete Status</remarks>
        /// <param name="Input">Input data object for get deal completion status</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/acqdeal/dealcompletestatus")]
        public async Task<HttpResponseMessage> DealCompleteStatus(int? deal_id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealServices.DealCompeteStatus(deal_id);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Deal Rollback
        /// </summary>
        /// <remarks>Used for rollback the changes on deal since last approval</remarks>
        /// <param name="Input">Input data object for rollback deal</param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/acqdeal/rollback")]
        public async Task<HttpResponseMessage> rollback(Acq_Deal Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealServices.rollback(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Can Delete Title
        /// </summary>
        /// <remarks>Used for check can delete title from deal.</remarks>
        /// <param name="Input">Input data object to check can delete title from deal</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/acqdeal/candeletetitle")]
        public async Task<HttpResponseMessage> candeletetitle(int? deal_id, int? title_id, int? episode_from, int? episode_to)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objDealServices.candeletetitle(deal_id, title_id, episode_from, episode_to);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }
    }
}
