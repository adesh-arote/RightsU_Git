using RightsU.API.BLL.Services;
using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using RightsU.API.Entities.ReturnClasses;
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
    [DisplayName("Language")]
    [Route("api/language")]
    public class languageController : BaseController
    {
      
        public enum SortColumn
        {
            CreatedDate = 1,
            UpdatedDate = 2,
            LanguageName = 3
        }

        private readonly LanguageServices objLanguageServices = new LanguageServices();

        /// <summary>
        /// Language List 
        /// </summary>
        /// <remarks>Retrieves all available Assets</remarks>
        /// <param name="order">Defines how the results will be ordered</param>
        /// <param name="page">The page number that should be retrieved</param>
        /// <param name="searchValue">The value of the search across the title</param>
        /// <param name="size">The size (total records) of each page</param>
        /// <param name="sort">Defines on which attribute the results should be sorted</param>
        /// <param name="dateGt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <param name="dateLt">Format - "dd-mmm-yyyy", filter basis on creation or modification date whichever falls into criteria</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<HttpResponseMessage> GetLanguageList(Order order, Int32 page, Int32 size, SortColumn sort, string searchValue = "", string dateGt = "", string dateLt = "")
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;
            GenericReturn objReturn = objLanguageServices.GetLanguageList(order.ToString(), sort.ToString(), size, page, searchValue, dateGt, dateLt, 0);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /// <summary>
        /// Language by id
        /// </summary>
        /// <remarks>Retrieves Assets by Id</remarks>
        /// <param name="id">get specific asset data using id.</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/Language/{id}")]
        public async Task<HttpResponseMessage> GetTitleById(int? id)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;
            GenericReturn objReturn = objLanguageServices.GetLanguageById(id.Value);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, true);

            return response;
        }

        /// <summary>
        /// Save Language Details
        /// </summary>
        /// <remarks>Create / Save New Language</remarks>
        /// <param name="Input">Input data object for Create/Save New Language</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> PostLanguage(Language objInput)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objLanguageServices.PostLanguage(objInput);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Modify Language details
        /// </summary>
        /// <remarks>Update / Modify Language details by id</remarks>
        /// <param name="Input">Input data object for Modify existing Language</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<HttpResponseMessage> PutLanguage(Language objInput)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;
            GenericReturn objReturn = objLanguageServices.PutLanguage(objInput);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }

        /// <summary>
        /// Active/Deactive Status 
        /// </summary>
        /// <remarks>Modify Active/Deactive Status of Existing Language</remarks>
        /// <param name="Input">Input data object for Modify existing Language Active/Deactive Status</param>
        /// <returns></returns>
        [HttpPut]
        [Route("api/Language/ChangeActiveStatus")]
        public async Task<HttpResponseMessage> ChangeActiveStatus(Language Input)
        {
            var response = new HttpResponseMessage();
            DateTime startTime;
            startTime = DateTime.Now;

            GenericReturn objReturn = objLanguageServices.ChangeActiveStatus(Input);

            objReturn.TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            response = CreateResponse(objReturn, false);

            return response;
        }
    }
}
