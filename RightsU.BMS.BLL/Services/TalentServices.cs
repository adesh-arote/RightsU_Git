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
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;

namespace RightsU.BMS.BLL.Services
{
    //public class TalentServices
    //{
    //    private readonly TalentRepositories objTalentRepositories = new TalentRepositories();
    //    private readonly Talent_RoleRepositories objTalent_RoleRepositories = new Talent_RoleRepositories();

    //    public GenericReturn GetTalentList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
    //                sort = "Last_UpDated_Time";
    //            }
    //            else if (sort.ToLower() == "TalentName".ToLower())
    //            {
    //                sort = "Talent_Name";
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

    //        TalentReturn _TalentReturn = new TalentReturn();

    //        try
    //        {
    //            if (_objRet.IsSuccess)
    //            {
    //                _TalentReturn = objTalentRepositories.GetTalent_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
    //            }
    //        }
    //        catch (Exception ex)
    //        {
    //            throw;
    //        }

    //        _TalentReturn.paging.page = page;
    //        _TalentReturn.paging.size = size;

    //        _objRet.Response = _TalentReturn;

    //        return _objRet;
    //    }
    //    public GenericReturn PostTalent(TalentInput objInput)
    //    {
    //        GenericReturn _objRet = new GenericReturn();
    //        _objRet.Message = "Success";
    //        _objRet.IsSuccess = true;
    //        _objRet.StatusCode = HttpStatusCode.OK;

    //        #region Input Validation

    //        if (string.IsNullOrEmpty(objInput.TalentName))
    //        {
    //            _objRet.Message = "Input Paramater 'Talent Name' is mandatory";
    //            _objRet.IsSuccess = false;
    //            _objRet.StatusCode = HttpStatusCode.BadRequest;
    //            return _objRet;
    //        }

    //        if (objInput.Role.Count() > 0)
    //        {
    //            string strRole = String.Join(",", objInput.Role.Select(x => x.RoleId.ToString()).ToArray());

    //            var Role = objTalentRepositories.Talent_Validation(strRole, "Role");

    //            if (Role.InputValueCode == 0)
    //            {
    //                _objRet.Message = "Input Paramater 'Role :" + Role.InvalidValue + "' is not Valid";
    //                _objRet.IsSuccess = false;
    //                _objRet.StatusCode = HttpStatusCode.BadRequest;
    //                return _objRet;
    //            }
    //        }

    //        #endregion

    //        if (_objRet.IsSuccess)
    //        {
    //            Talent objTalent = new Talent();

    //            objTalent.Talent_Name = objInput.TalentName;
    //            objTalent.Gender = objInput.Gender;
    //            objTalent.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
    //            objTalent.Inserted_On = DateTime.Now;
    //            objTalent.Last_Updated_Time = DateTime.Now;
    //            objTalent.Is_Active = "Y";

    //            foreach (var item in objInput.Role)
    //            {
    //                Talent_Role objTalent_Role = new Talent_Role();
    //                objTalent_Role.Role_Code = item.RoleId;
    //                objTalent.Talent_Role.Add(objTalent_Role);
    //            }

    //            objTalentRepositories.Add(objTalent);
    //            _objRet.Response = new { id = objTalent.Talent_Code };
    //        }

    //        return _objRet;
    //    }
    //    public GenericReturn PutTalent(TalentInput objInput)
    //    {
    //        GenericReturn _objRet = new GenericReturn();
    //        _objRet.Message = "Success";
    //        _objRet.IsSuccess = true;
    //        _objRet.StatusCode = HttpStatusCode.OK;

    //        #region Input Validation

    //        if (objInput.id <= 0)
    //        {
    //            _objRet.Message = "Input Paramater 'id' is mandatory";
    //            _objRet.IsSuccess = false;
    //            _objRet.StatusCode = HttpStatusCode.BadRequest;
    //            return _objRet;
    //        }

    //        if (string.IsNullOrEmpty(objInput.TalentName))
    //        {
    //            _objRet.Message = "Input Paramater 'Talent Name' is mandatory";
    //            _objRet.IsSuccess = false;
    //            _objRet.StatusCode = HttpStatusCode.BadRequest;
    //            return _objRet;
    //        }            

    //        if (objInput.Role.Count() > 0)
    //        {
    //            string strRole = String.Join(",", objInput.Role.Select(x => x.RoleId.ToString()).ToArray());

    //            var Role = objTalentRepositories.Talent_Validation(strRole, "Role");

    //            if (Role.InputValueCode == 0)
    //            {
    //                _objRet.Message = "Input Paramater 'Role :" + Role.InvalidValue + "' is not Valid";
    //                _objRet.IsSuccess = false;
    //                _objRet.StatusCode = HttpStatusCode.BadRequest;
    //                return _objRet;
    //            }
    //        }

    //        #endregion

    //        if (_objRet.IsSuccess)
    //        {
    //            Talent objTalent = new Talent();

    //            objTalent = objTalentRepositories.Get(objInput.id);

    //            objTalent.Talent_Name = objInput.TalentName;
    //            objTalent.Gender = objInput.Gender;
    //            objTalent.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
    //            objTalent.Last_Updated_Time = DateTime.Now;
    //            objTalent.Is_Active = "Y";

    //            #region Talent_Role

    //            objTalent.Talent_Role.ToList().ForEach(i => i.EntityState = State.Deleted);

    //            foreach (var item in objInput.Role)
    //            {
    //                Talent_Role objT = (Talent_Role)objTalent.Talent_Role.Where(t => t.Role_Code == item.RoleId).Select(i => i).FirstOrDefault();

    //                if (objT == null)
    //                    objT = new Talent_Role();
    //                if (objT.Talent_Role_Code > 0)
    //                    objT.EntityState = State.Unchanged;
    //                else
    //                {
    //                    objT.EntityState = State.Added;
    //                    objT.Talent_Code = objInput.id;
    //                    objT.Role_Code = item.RoleId;
    //                    objTalent.Talent_Role.Add(objT);
    //                }
    //            }

    //            foreach (var item in objTalent.Talent_Role.ToList().Where(x => x.EntityState == State.Deleted))
    //            {
    //                objTalent_RoleRepositories.Delete(item);
    //            }

    //            var objRole = objTalent.Talent_Role.ToList().Where(x => x.EntityState == State.Deleted).ToList();
    //            objRole.ForEach(i => objTalent.Talent_Role.Remove(i));

    //            #endregion
               

    //            objTalentRepositories.AddEntity(objTalent);

    //            _objRet.Response = new { id = objTalent.Talent_Code };
    //        }

    //        return _objRet;
    //    }
    //    public GenericReturn ChangeActiveStatus(PutInput objInput)
    //    {
    //        GenericReturn _objRet = new GenericReturn();
    //        _objRet.Message = "Success";
    //        _objRet.IsSuccess = true;
    //        _objRet.StatusCode = HttpStatusCode.OK;

    //        #region Input Validation

    //        if (objInput.id <= 0)
    //        {
    //            _objRet.Message = "Input Paramater 'id' is mandatory";
    //            _objRet.IsSuccess = false;
    //            _objRet.StatusCode = HttpStatusCode.BadRequest;
    //            return _objRet;
    //        }

    //        if (string.IsNullOrEmpty(objInput.Status))
    //        {
    //            _objRet.Message = "Input Paramater 'Status' is mandatory";
    //            _objRet.IsSuccess = false;
    //            _objRet.StatusCode = HttpStatusCode.BadRequest;
    //            return _objRet;
    //        }
    //        else if (objInput.Status.ToUpper() != "Y" && objInput.Status.ToUpper() != "N")
    //        {
    //            _objRet.Message = "Input Paramater 'Status' is invalid";
    //            _objRet.IsSuccess = false;
    //            _objRet.StatusCode = HttpStatusCode.BadRequest;
    //            return _objRet;
    //        }

    //        #endregion

    //        if (_objRet.IsSuccess)
    //        {
    //            Talent objTalent = new Talent();

    //            objTalent = objTalentRepositories.Get(objInput.id);

    //            objTalent.Last_Updated_Time = DateTime.Now;
    //            objTalent.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
    //            objTalent.Is_Active = objInput.Status.ToUpper();

    //            objTalentRepositories.Update(objTalent);
    //            _objRet.Response = new { id = objTalent.Talent_Code };

    //        }

    //        return _objRet;
    //    }
    //}
}
