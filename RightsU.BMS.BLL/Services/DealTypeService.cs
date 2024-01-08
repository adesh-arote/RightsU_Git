using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
namespace RightsU.BMS.BLL.Services
{
    //public class DealTypeService
    //{
    //    private readonly DealTypeRepositories objDealTypeRepositories = new DealTypeRepositories();

    //    public GenericReturn GetDealTypeList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
    //    {
    //        GenericReturn _objRet = new GenericReturn();
    //        _objRet.Message = "Success";
    //        _objRet.IsSuccess = true;
    //        _objRet.StatusCode = HttpStatusCode.OK;

    //        #region Input Validations

    //        if (!string.IsNullOrEmpty(order))
    //        {
    //            if (order.ToUpper() != "ASC")
    //            {
    //                if (order.ToUpper() != "DESC")
    //                {
    //                    _objRet.Message = "Input Paramater 'order' is not in valid format";
    //                    _objRet.IsSuccess = false;
    //                    _objRet.StatusCode = HttpStatusCode.BadRequest;
    //                }
    //            }
    //        }
    //        else
    //        {
    //            order = ConfigurationManager.AppSettings["defaultOrder"];
    //        }

    //        if (page == 0)
    //        {
    //            page = Convert.ToInt32(ConfigurationManager.AppSettings["defaultPage"]);
    //        }

    //        if (size > 0)
    //        {
    //            var maxSize = Convert.ToInt32(ConfigurationManager.AppSettings["maxSize"]);
    //            if (size > maxSize)
    //            {
    //                _objRet.Message = "Input Paramater 'size' should not be greater than " + maxSize;
    //                _objRet.IsSuccess = false;
    //                _objRet.StatusCode = HttpStatusCode.BadRequest;
    //            }
    //        }
    //        else
    //        {
    //            size = Convert.ToInt32(ConfigurationManager.AppSettings["defaultSize"]);
    //        }

    //        if (!string.IsNullOrEmpty(sort.ToString()))
    //        {
    //            if (sort.ToLower() == "CreatedDate".ToLower())
    //            {
    //                sort = "Inserted_On";
    //            }
    //            else if (sort.ToLower() == "UpdatedDate".ToLower())
    //            {
    //                sort = "Last_Updated_Time";
    //            }
    //            else if (sort.ToLower() == "DealTypeName".ToLower())
    //            {
    //                sort = "Deal_Type_Name";
    //            }
    //            else
    //            {
    //                _objRet.Message = "Input Paramater 'sort' is not in valid format";
    //                _objRet.IsSuccess = false;
    //                _objRet.StatusCode = HttpStatusCode.BadRequest;
    //            }
    //        }
    //        else
    //        {
    //            sort = ConfigurationManager.AppSettings["defaultSort"];
    //        }

    //        try
    //        {
    //            if (!string.IsNullOrEmpty(Date_GT))
    //            {
    //                try
    //                {
    //                    Date_GT = DateTime.Parse(Date_GT).ToString("yyyy-MM-dd");
    //                }
    //                catch (Exception ex)
    //                {
    //                    _objRet.Message = "Input Paramater 'dateGt' is not in valid format";
    //                    _objRet.IsSuccess = false;
    //                    _objRet.StatusCode = HttpStatusCode.BadRequest;
    //                }

    //            }
    //            if (!string.IsNullOrEmpty(Date_LT))
    //            {
    //                try
    //                {
    //                    Date_LT = DateTime.Parse(Date_LT).ToString("yyyy-MM-dd");
    //                }
    //                catch (Exception ex)
    //                {
    //                    _objRet.Message = "Input Paramater 'dateLt' is not in valid format";
    //                    _objRet.IsSuccess = false;
    //                    _objRet.StatusCode = HttpStatusCode.BadRequest;
    //                }
    //            }

    //            if (!string.IsNullOrEmpty(Date_GT) && !string.IsNullOrEmpty(Date_LT))
    //            {
    //                if (DateTime.Parse(Date_GT) > DateTime.Parse(Date_LT))
    //                {
    //                    _objRet.Message = "Input Paramater 'dateLt' should not be less than 'dateGt'";
    //                    _objRet.IsSuccess = false;
    //                    _objRet.StatusCode = HttpStatusCode.BadRequest;
    //                }
    //            }
    //        }
    //        catch (Exception ex)
    //        {
    //            _objRet.Message = "Input Paramater 'dateLt' or 'dateGt' is not in valid format";
    //            _objRet.IsSuccess = false;
    //            _objRet.StatusCode = HttpStatusCode.BadRequest;
    //        }

    //        #endregion

    //        Deal_TypeReturn _DealTypeReturn = new Deal_TypeReturn();

    //        try
    //        {
    //            if (_objRet.IsSuccess)
    //            {
    //                _DealTypeReturn = objDealTypeRepositories.GetDealType_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
    //            }
    //        }
    //        catch (Exception ex)
    //        {
    //            throw;
    //        }

    //        _DealTypeReturn.paging.page = page;
    //        _DealTypeReturn.paging.size = size;

    //        _objRet.Response = _DealTypeReturn;

    //        return _objRet;
    //    }
    //}
}
