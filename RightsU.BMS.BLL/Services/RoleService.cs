using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;

namespace RightsU.BMS.BLL.Services
{
    //public class RoleService
    //{
    //    private readonly RoleRepositories objRoleRepositories = new RoleRepositories();

    //    public GenericReturn GetRoleList(string order, string sort, Int32 size, Int32 page, string search_value, Int32? id)
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
    //            if (sort.ToLower() == "RoleName".ToLower())
    //            {
    //                sort = "Role_Name";
    //            }
    //        }
    //        else
    //        {
    //            sort = ConfigurationManager.AppSettings["defaultSort"];
    //        }
    //        #endregion

    //        RoleReturn _RoleReturn = new RoleReturn();

    //        try
    //        {
    //            if (_objRet.IsSuccess)
    //            {
    //                _RoleReturn = objRoleRepositories.GetRole_List(order, page, search_value, size, sort, id.Value);
    //            }
    //        }
    //        catch (Exception ex)
    //        {
    //            throw;
    //        }
    //        _RoleReturn.paging.page = page;
    //        _RoleReturn.paging.size = size;
    //        _objRet.Response = _RoleReturn;
    //        return _objRet;
    //    }
    //}
}

