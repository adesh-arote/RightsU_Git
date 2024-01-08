using RightsU.BMS.DAL;
using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.InputClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace RightsU.BMS.BLL.Services
{
    public class GenreServices
    {
        private readonly GenresRepositories objGenreRepositories = new GenresRepositories();
        public GenericReturn GetGenreList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validations

            if (!string.IsNullOrEmpty(order))
            {
                if (order.ToUpper() != "ASC")
                {
                    if (order.ToUpper() != "DESC")
                    {
                        _objRet.Message = "Input Paramater 'order' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }
            }
            else
            {
                order = ConfigurationManager.AppSettings["defaultOrder"];
            }

            if (page == 0)
            {
                page = Convert.ToInt32(ConfigurationManager.AppSettings["defaultPage"]);
            }

            if (size > 0)
            {
                var maxSize = Convert.ToInt32(ConfigurationManager.AppSettings["maxSize"]);
                if (size > maxSize)
                {
                    _objRet.Message = "Input Paramater 'size' should not be greater than " + maxSize;
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
            }
            else
            {
                size = Convert.ToInt32(ConfigurationManager.AppSettings["defaultSize"]);
            }

            if (!string.IsNullOrEmpty(sort.ToString()))
            {
                if (sort.ToLower() == "CreatedDate".ToLower())
                {
                    sort = "Inserted_On";
                }
                else if (sort.ToLower() == "UpdatedDate".ToLower())
                {
                    sort = "Last_UpDated_Time";
                }
                else if (sort.ToLower() == "GenreName".ToLower())
                {
                    sort = "Genres_Name";
                }
                else
                {
                    _objRet.Message = "Input Paramater 'sort' is not in valid format";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
            }
            else
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }

            try
            {
                if (!string.IsNullOrEmpty(Date_GT))
                {
                    try
                    {
                        Date_GT = DateTime.Parse(Date_GT).ToString("yyyy-MM-dd");
                    }
                    catch (Exception ex)
                    {
                        _objRet.Message = "Input Paramater 'dateGt' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }

                }
                if (!string.IsNullOrEmpty(Date_LT))
                {
                    try
                    {
                        Date_LT = DateTime.Parse(Date_LT).ToString("yyyy-MM-dd");
                    }
                    catch (Exception ex)
                    {
                        _objRet.Message = "Input Paramater 'dateLt' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }

                if (!string.IsNullOrEmpty(Date_GT) && !string.IsNullOrEmpty(Date_LT))
                {
                    if (DateTime.Parse(Date_GT) > DateTime.Parse(Date_LT))
                    {
                        _objRet.Message = "Input Paramater 'dateLt' should not be less than 'dateGt'";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }
            }
            catch (Exception ex)
            {
                _objRet.Message = "Input Paramater 'dateLt' or 'dateGt' is not in valid format";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            GenreReturn _GenreReturn = new GenreReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _GenreReturn = objGenreRepositories.GetGenre_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _GenreReturn.paging.page = page;
            _GenreReturn.paging.size = size;

            _objRet.Response = _GenreReturn;

            return _objRet;
        }
        public GenericReturn PostGenre(GenreInput objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.GenreName))
            {
                _objRet.Message = "Input Paramater 'Genre Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objGenreRepositories.SearchFor(new { Genres_Name = objInput.GenreName }).ToList();

            if(CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'Genre name already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre.genres_name = objInput.GenreName;
                objGenre.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Inserted_On = DateTime.Now;
                objGenre.Last_Updated_Time = DateTime.Now;
                objGenre.Is_Active = "Y";

                objGenreRepositories.Add(objGenre);
                _objRet.Response = new { id = objGenre.genres_id };
                
            }

            return _objRet;
        }
        public GenericReturn PutGenre(GenreInput objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.id <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.GenreName))
            {
                _objRet.Message = "Input Paramater 'Genre Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objGenreRepositories.SearchFor(new { Genres_Name = objInput.GenreName }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'Genre name already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre = objGenreRepositories.Get(objInput.id);

                objGenre.genres_name = objInput.GenreName;
                objGenre.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Last_Updated_Time = DateTime.Now;
                objGenre.Is_Active = "Y";

                objGenreRepositories.AddEntity(objGenre);

                _objRet.Response = new { id = objGenre.genres_id };
            }

            return _objRet;
        }
        public GenericReturn ChangeActiveStatus(PutInput objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.id <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Status))
            {
                _objRet.Message = "Input Paramater 'Status' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Status.ToUpper() != "Y" && objInput.Status.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'Status' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre = objGenreRepositories.Get(objInput.id);

                objGenre.Last_Updated_Time = DateTime.Now;
                objGenre.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Is_Active = objInput.Status.ToUpper();

                objGenreRepositories.Update(objGenre);
                _objRet.Response = new { id = objGenre.genres_id };

            }

            return _objRet;
        }
    }
}
