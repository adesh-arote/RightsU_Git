using RightsU.API.BLL.Services;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities.ReturnClasses;
using RightsU.API.Entities;
using RightsU.API.Filters;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.ComponentModel;

namespace RightsU.API.Controllers
{
    [DisplayName("Talent")]
    [Route("api/talent")]
    public class talentController : BaseController
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
            TalentName = 3
        }

        private readonly TalentServices objTalentServices = new TalentServices();
        private readonly System_Module_Service objSystemModuleServices = new System_Module_Service();

        /// <summary>
        /// Talent List 
        /// </summary>
        /// <remarks>Retrieves all available Talent</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <param name="dateGt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <param name="dateLt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <returns></returns>        
        [HttpGet]        
        public async Task<HttpResponseMessage> GetTalentList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "", string dateGt = "", string dateLt = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTalentServices.GetTalentList(order.ToString(), sort.ToString(), size, page, searchValue, dateGt, dateLt, 0);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /// <summary>
        /// Save Talent Details
        /// </summary>
        /// <remarks>Create / Save New Talent</remarks>
        /// <param name="Input">Input data object for Create/Save New Talent</param>
        /// <returns></returns>
        [HttpPost]        
        public async Task<HttpResponseMessage> PostTalent(Talent Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTalentServices.PostTalent(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Modify Talent details
        /// </summary>
        /// <remarks>Update / Modify Talent details by id</remarks>
        /// <param name="Input">Input data object for Modify existing Talent</param>
        /// <returns></returns>
        [HttpPut]        
        public async Task<HttpResponseMessage> PutTalent(Talent Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objTalentServices.PutTalent(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Active/Deactive Status 
        /// </summary>
        /// <remarks>Modify Active/Deactive Status of Existing Talent</remarks>
        /// <param name="Input">Input data object for Modify existing talent Active/Deactive Status</param>
        /// <returns></returns>
        [HttpPut]
        [Route("api/talent/ChangeActiveStatus")]
        public async Task<HttpResponseMessage> ChangeActiveStatus(Talent Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = new GenericReturn();
            objReturn = objTalentServices.ChangeActiveStatus(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);
                        
            return response;
        }
    }
}
