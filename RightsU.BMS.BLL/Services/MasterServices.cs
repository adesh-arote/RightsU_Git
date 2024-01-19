﻿
using RightsU.BMS.DAL;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using System.Net;
using System.Configuration;
using System.Web;
using RightsU.BMS.Entities.ReturnClasses;

namespace RightsU.BMS.BLL.Services
{
    public class UserServices
    {
        private readonly UserRepositories objUserRepository;

        public UserServices()
        {
            this.objUserRepository = new UserRepositories();
        }

        public User GetUserByID(int ID)
        {
            return objUserRepository.Get(ID);
        }

        public IEnumerable<User> GetUserList()
        {
            return objUserRepository.GetAll();
        }
        public void UpdateUser(User obj)
        {
            objUserRepository.Update(obj);
        }

        public IEnumerable<User> SearchForUser(object param)
        {
            return objUserRepository.SearchFor(param);
        }

        public IEnumerable<User> GetDataWithSQLStmt(string strSQL)
        {

            return objUserRepository.GetDataWithSQLStmt(strSQL);
        }


    }
    public class SystemParameterServices
    {
        private readonly SystemParametersRepositories objSystemParametersRepositories;
        public SystemParameterServices()
        {
            this.objSystemParametersRepositories = new SystemParametersRepositories();
        }
        public IEnumerable<System_Parameter_New> GetSystemParameterList()
        {
            return objSystemParametersRepositories.GetAll();
        }
        public IEnumerable<System_Parameter_New> SearchFor(object param)
        {
            return objSystemParametersRepositories.SearchFor(param);
        }
    }

    public class BMS_Log_Service
    {
        private readonly BMS_Log_Repositories objBMSLogRepositories;
        public BMS_Log_Service()
        {
            this.objBMSLogRepositories = new BMS_Log_Repositories();
        }
        public IEnumerable<BMS_Log> GetBMS_LogList()
        {
            return objBMSLogRepositories.GetAll();
        }
        public IEnumerable<BMS_Log> SearchFor(object param)
        {
            return objBMSLogRepositories.SearchFor(param);
        }
        public int InsertLog(BMS_Log param)
        {
            return objBMSLogRepositories.InsertBMSLog(param);
        }
    }

    public class Channel_Service
    {
        private readonly Channel_Repositories objChannelRepositories;
        public Channel_Service()
        {
            this.objChannelRepositories = new Channel_Repositories();
        }
        public IEnumerable<Channel> GetChannelList()
        {
            return objChannelRepositories.GetAll();
        }
        public IEnumerable<Channel> SearchFor(object param)
        {
            return objChannelRepositories.SearchFor(param);
        }
    }

    public class BMS_Schedule_Import_Config_Service
    {
        private readonly BMS_Schedule_Import_Config_Repositories objBMSScheduleImportConfigRepositories;
        public BMS_Schedule_Import_Config_Service()
        {
            this.objBMSScheduleImportConfigRepositories = new BMS_Schedule_Import_Config_Repositories();
        }
        public IEnumerable<BMS_Schedule_Import_Config> GetChannelList()
        {
            return objBMSScheduleImportConfigRepositories.GetAll();
        }
        public IEnumerable<BMS_Schedule_Import_Config> SearchFor(object param)
        {
            return objBMSScheduleImportConfigRepositories.SearchFor(param);
        }
    }

    public class Upload_Files_Service
    {
        private readonly Upload_Files_Repositories objUploadFilesRepositories;
        public Upload_Files_Service()
        {
            this.objUploadFilesRepositories = new Upload_Files_Repositories();
        }
        public void Upload_Files_Save(Upload_Files objUploadFiles)
        {
            this.objUploadFilesRepositories.Add(objUploadFiles);
        }
    }

    public class ServiceLogServices
    {
        private readonly ServiceLogRepositories objServiceLogRepositories = new ServiceLogRepositories();

        public ServiceLogServices()
        {
            this.objServiceLogRepositories = new ServiceLogRepositories();
        }

        public int AddEntity(ServiceLog param)
        {
            objServiceLogRepositories.Add(param);
            return param.ServiceLogID.Value;
        }

        public void UpdateServiceLog(ServiceLog obj)
        {
            objServiceLogRepositories.Update(obj);
        }
    }

    public class LoggedInUsersServices
    {
        private readonly LoggedInUsersRepository objLoggedInUsersRepository;

        public LoggedInUsersServices()
        {
            this.objLoggedInUsersRepository = new LoggedInUsersRepository();
        }
        public LoggedInUsers GetLoggedInUserByID(int ID)
        {
            return objLoggedInUsersRepository.Get(ID);
        }
        public IEnumerable<LoggedInUsers> GetLoggedInUsersList()
        {
            return objLoggedInUsersRepository.GetAll();
        }
        public void AddEntity(LoggedInUsers param)
        {
            objLoggedInUsersRepository.Add(param);
        }
        public void UpdateLoggedInUser(LoggedInUsers obj)
        {
            objLoggedInUsersRepository.Update(obj);
        }
        public void DeleteLoggedInUsers(LoggedInUsers obj)
        {
            objLoggedInUsersRepository.Delete(obj);
        }

        public IEnumerable<LoggedInUsers> SearchFor(object param)
        {
            return objLoggedInUsersRepository.SearchFor(param);
        }
    }

    public class System_Module_Service
    {
        private readonly System_Module_Repositories objSystemModuleRepositories;
        public System_Module_Service()
        {
            this.objSystemModuleRepositories = new System_Module_Repositories();
        }
        public IEnumerable<System_Module> GetAll()
        {
            return objSystemModuleRepositories.GetAll();
        }
        public IEnumerable<System_Module> SearchFor(object param)
        {
            return objSystemModuleRepositories.SearchFor(param);
        }
        public List<System_Module> USP_GetModule(Int32 Security_Group_Code, Int32 Users_Code)
        {
            return objSystemModuleRepositories.USP_GetModule(Security_Group_Code, Users_Code);
        }

        public List<USPAPI_GetModuleRights> USPAPI_GetModuleRights(Int32 Security_Group_Code)
        {
            return objSystemModuleRepositories.USPAPI_GetModuleRights(Security_Group_Code);
        }

        public int hasModuleRights(string Module_Url, string Rights_Name, string authenticationToken, string RefreshToken)
        {
            int hasRights = 0;

            LoggedInUsersServices objLoggedInUsersServices = new LoggedInUsersServices();
            UserServices objUserServices = new UserServices();

            LoggedInUsers objUserDetails = objLoggedInUsersServices.SearchFor(new { AccessToken = authenticationToken, RefreshToken = RefreshToken }).ToList().FirstOrDefault();

            if (objUserDetails != null)
            {
                User objUser = new User();
                objUser = objUserServices.SearchForUser(new { Login_Name = objUserDetails.LoginName }).FirstOrDefault();

                var UserModuleRights = USPAPI_GetModuleRights(objUser.Security_Group_Code.Value);

                var domainSubFolder = ConfigurationManager.AppSettings["DomainSubFolder"];

                var lstModuleUrl = Module_Url.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries).Where(x => x.ToLower() != domainSubFolder.ToLower()).ToArray();

                var objModuleRights = UserModuleRights.Where(x => x.Module_Name.ToLower() == lstModuleUrl[1].ToLower()).ToList();

                if (objModuleRights.Count() > 0)
                {
                    if (lstModuleUrl.Count() > 2)
                    {
                        if (Rights_Name.ToLower() == "get" && objModuleRights.Any(x => x.Right_Name.ToLower() == Rights_Name.ToLower()))
                        {
                            hasRights = objUser.Users_Code.Value;
                        }
                        else if (objModuleRights.Any(x => x.Right_Name.ToLower() == lstModuleUrl[2].ToLower()))
                        {
                            hasRights = objUser.Users_Code.Value;
                        }
                        else
                        {
                            hasRights = 0;
                        }
                    }
                    else if (objModuleRights.Any(x => x.Right_Name == Rights_Name))
                    {
                        hasRights = objUser.Users_Code.Value;
                    }
                    else
                    {
                        hasRights = 0;
                    }
                }
                else
                {
                    hasRights = 0;
                }
            }

            return hasRights;
        }
    }

    #region Role
    public class RoleService
    {
        private readonly RoleRepositories objRoleRepositories = new RoleRepositories();

        public GenericReturn GetRoleList(string order, string sort, Int32 size, Int32 page, string search_value, Int32? id)
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
                if (sort.ToLower() == "RoleName".ToLower())
                {
                    sort = "Role_Name";
                }
            }
            else
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }
            #endregion

            RoleReturn _RoleReturn = new RoleReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _RoleReturn = objRoleRepositories.GetRole_List(order, page, search_value, size, sort, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            _RoleReturn.paging.page = page;
            _RoleReturn.paging.size = size;
            _objRet.Response = _RoleReturn;
            return _objRet;
        }
    }
    #endregion

    #region DealType
    public class DealTypeService
    {
        private readonly DealTypeRepositories objDealTypeRepositories = new DealTypeRepositories();

        public GenericReturn GetDealTypeList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                    sort = "Last_Updated_Time";
                }
                else if (sort.ToLower() == "DealTypeName".ToLower())
                {
                    sort = "Deal_Type_Name";
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

            Deal_TypeReturn _DealTypeReturn = new Deal_TypeReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _DealTypeReturn = objDealTypeRepositories.GetDealType_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _DealTypeReturn.paging.page = page;
            _DealTypeReturn.paging.size = size;

            _objRet.Response = _DealTypeReturn;

            return _objRet;
        }
    }
    #endregion

    #region ChannelCategory
    public class ChannelCategoryService
    {
        private readonly ChannelCategoryRepositories objChannelCategoryRepositories = new ChannelCategoryRepositories();

        public GenericReturn GetChannelCategoryList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                    sort = "Last_Updated_Time";
                }
                else if (sort.ToLower() == "ChannelCategoryName".ToLower())
                {
                    sort = "Channel_Category_Name";
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

            Channel_CategoryReturn _ChannelCategoryReturn = new Channel_CategoryReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _ChannelCategoryReturn = objChannelCategoryRepositories.GetChannelCategory_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _ChannelCategoryReturn.paging.page = page;
            _ChannelCategoryReturn.paging.size = size;

            _objRet.Response = _ChannelCategoryReturn;

            return _objRet;
        }
    }
    #endregion

    #region Platform
    public class PlatformService
    {
        private readonly PlatformRepositories objPlatformRepositories = new PlatformRepositories();

        public GenericReturn GetPlatformList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                    sort = "Last_Updated_Time";
                }
                else if (sort.ToLower() == "ChannelCategoryName".ToLower())
                {
                    sort = "Platform_Name";
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

            PlatformReturn _PlatformReturn = new PlatformReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _PlatformReturn = objPlatformRepositories.GetPlatform_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _PlatformReturn.paging.page = page;
            _PlatformReturn.paging.size = size;

            _objRet.Response = _PlatformReturn;

            return _objRet;
        }
    }
    #endregion

    #region Genres
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
        public GenericReturn GetGenreById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Genres objGenre = new Genres();

                    objGenre = objGenreRepositories.GetById(id);

                    _objRet.Response = objGenre;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }
        public GenericReturn PostGenre(Genres objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Genres_Name))
            {
                _objRet.Message = "Input Paramater 'genre_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objGenreRepositories.SearchFor(new { Genres_Name = objInput.Genres_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'genre_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre.Genres_Name = objInput.Genres_Name;
                objGenre.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Inserted_On = DateTime.Now;
                objGenre.Last_Updated_Time = DateTime.Now;
                objGenre.Is_Active = "Y";

                objGenreRepositories.Add(objGenre);
                _objRet.Response = new { id = objGenre.Genres_Code };

            }

            return _objRet;
        }
        public GenericReturn PutGenre(Genres objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Genres_Code == null || objInput.Genres_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'genres_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Genres_Name))
            {
                _objRet.Message = "Input Paramater 'genre_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objGenreRepositories.SearchFor(new { Genres_Name = objInput.Genres_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'genre_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre = objGenreRepositories.Get(objInput.Genres_Code.Value);

                objGenre.Genres_Name = objInput.Genres_Name;
                objGenre.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Last_Updated_Time = DateTime.Now;
                //objGenre.Is_Active = "Y";

                objGenreRepositories.AddEntity(objGenre);

                _objRet.Response = new { id = objGenre.Genres_Code };
            }

            return _objRet;
        }
        public GenericReturn ChangeActiveStatus(Genres objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Genres_Code == null || objInput.Genres_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'genres_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre = objGenreRepositories.Get(objInput.Genres_Code.Value);

                objGenre.Last_Updated_Time = DateTime.Now;
                objGenre.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Is_Active = objInput.Is_Active.ToUpper();

                objGenreRepositories.Update(objGenre);
                _objRet.Response = new { id = objGenre.Genres_Code };

            }

            return _objRet;
        }
    }
    #endregion

    #region Program
    public class ProgramServices
    {
        private readonly ProgramRepositories objProgramRepositories = new ProgramRepositories();

        public GenericReturn GetProgramList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                else if (sort.ToLower() == "ProgramName".ToLower())
                {
                    sort = "Program_Name";
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

            ProgramReturn _ProgramReturn = new ProgramReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _ProgramReturn = objProgramRepositories.GetProgram_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _ProgramReturn.paging.page = page;
            _ProgramReturn.paging.size = size;

            _objRet.Response = _ProgramReturn;

            return _objRet;
        }
        public GenericReturn GetProgramById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'program_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Program objGenre = new Program();

                    objGenre = objProgramRepositories.GetById(id);

                    _objRet.Response = objGenre;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }
        public GenericReturn PostProgram(Program objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Program_Name))
            {
                _objRet.Message = "Input Paramater 'program_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objProgramRepositories.SearchFor(new { Program_Name = objInput.Program_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'program_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Program objProgram = new Program();

                objProgram.Program_Name = objInput.Program_Name;
                objProgram.Deal_Type_Code = objInput.Deal_Type_Code;
                objProgram.Genres_Code = objInput.Genres_Code;
                objProgram.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objProgram.Inserted_On = DateTime.Now;
                objProgram.Last_UpDated_Time = DateTime.Now;
                objProgram.Is_Active = "Y";

                objProgramRepositories.Add(objProgram);

                _objRet.Response = new { id = objProgram.Program_Code };

            }

            return _objRet;
        }
        public GenericReturn PutProgram(Program objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Program_Code == null || objInput.Program_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'program_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Program_Name))
            {
                _objRet.Message = "Input Paramater 'program_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objProgramRepositories.SearchFor(new { Program_Name = objInput.Program_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'program_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Program objProgram = new Program();

                objProgram = objProgramRepositories.Get(objInput.Program_Code.Value);

                objProgram.Program_Name = objInput.Program_Name;
                objProgram.Deal_Type_Code = objInput.Deal_Type_Code;
                objProgram.Genres_Code = objInput.Genres_Code;
                objProgram.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objProgram.Last_UpDated_Time = DateTime.Now;
                //objProgram.Is_Active = "Y";

                objProgramRepositories.AddEntity(objProgram);

                _objRet.Response = new { id = objProgram.Program_Code };
            }

            return _objRet;
        }
        public GenericReturn ChangeActiveStatus(Program objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Program_Code == null || objInput.Program_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'program_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Program objProgram = new Program();

                objProgram = objProgramRepositories.Get(objInput.Program_Code.Value);

                objProgram.Last_UpDated_Time = DateTime.Now;
                objProgram.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objProgram.Is_Active = objInput.Is_Active.ToUpper();

                objProgramRepositories.Update(objProgram);
                _objRet.Response = new { id = objProgram.Program_Code };

            }

            return _objRet;
        }
    }
    #endregion

    #region Talent
    public class TalentServices
    {
        private readonly TalentRepositories objTalentRepositories = new TalentRepositories();
        private readonly Talent_RoleRepositories objTalent_RoleRepositories = new Talent_RoleRepositories();

        public GenericReturn GetTalentList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                else if (sort.ToLower() == "TalentName".ToLower())
                {
                    sort = "Talent_Name";
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

            TalentReturn _TalentReturn = new TalentReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _TalentReturn = objTalentRepositories.GetTalent_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _TalentReturn.paging.page = page;
            _TalentReturn.paging.size = size;

            _objRet.Response = _TalentReturn;

            return _objRet;
        }
        public GenericReturn PostTalent(Talent objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Talent_Name))
            {
                _objRet.Message = "Input Paramater 'Talent Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            //if (objInput.Talent_Role.Count() > 0)
            //{
            //    string strRole = String.Join(",", objInput.Talent_Role.Select(x => x.Role_Code.ToString()).ToArray());

            //    var Role = objTalentRepositories.Talent_Validation(strRole, "Role");

            //    if (Role.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'Role :" + Role.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            #endregion

            if (_objRet.IsSuccess)
            {
                Talent objTalent = new Talent();

                objTalent.Talent_Name = objInput.Talent_Name;
                objTalent.Gender = objInput.Gender;
                objTalent.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTalent.Inserted_On = DateTime.Now;
                objTalent.Last_Updated_Time = DateTime.Now;
                objTalent.Is_Active = "Y";

                foreach (var item in objInput.Talent_Role)
                {
                    Talent_Role objTalent_Role = new Talent_Role();
                    objTalent_Role.Role_Code = item.Role_Code;
                    objTalent.Talent_Role.Add(objTalent_Role);
                }

                objTalentRepositories.Add(objTalent);
                _objRet.Response = new { id = objTalent.Talent_Code };
            }

            return _objRet;
        }
        public GenericReturn PutTalent(Talent objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Talent_Code == null || objInput.Talent_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Talent_Name))
            {
                _objRet.Message = "Input Paramater 'Talent Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            //if (objInput.Talent_Role.Count() > 0)
            //{
            //    string strRole = String.Join(",", objInput.Talent_Role.Select(x => x.Role_Code.ToString()).ToArray());

            //    var Role = objTalentRepositories.Talent_Validation(strRole, "Role");

            //    if (Role.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'Role :" + Role.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            #endregion

            if (_objRet.IsSuccess)
            {
                Talent objTalent = new Talent();

                objTalent = objTalentRepositories.Get(objInput.Talent_Code.Value);

                objTalent.Talent_Name = objInput.Talent_Name;
                objTalent.Gender = objInput.Gender;
                objTalent.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTalent.Last_Updated_Time = DateTime.Now;
                objTalent.Is_Active = "Y";

                #region Talent_Role

                objTalent.Talent_Role.ToList().ForEach(i => i.EntityState = State.Deleted);

                foreach (var item in objInput.Talent_Role)
                {
                    Talent_Role objT = (Talent_Role)objTalent.Talent_Role.Where(t => t.Role_Code == item.Role_Code).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Talent_Role();
                    if (objT.Talent_Role_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Talent_Code = objInput.Talent_Code;
                        objT.Role_Code = item.Role_Code;
                        objTalent.Talent_Role.Add(objT);
                    }
                }

                foreach (var item in objTalent.Talent_Role.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objTalent_RoleRepositories.Delete(item);
                }

                var objRole = objTalent.Talent_Role.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                objRole.ForEach(i => objTalent.Talent_Role.Remove(i));

                #endregion


                objTalentRepositories.AddEntity(objTalent);

                _objRet.Response = new { id = objTalent.Talent_Code };
            }

            return _objRet;
        }
        public GenericReturn ChangeActiveStatus(Talent objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Talent_Code == null || objInput.Talent_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'Status' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'Status' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Talent objTalent = new Talent();

                objTalent = objTalentRepositories.Get(objInput.Talent_Code.Value);

                objTalent.Last_Updated_Time = DateTime.Now;
                objTalent.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTalent.Is_Active = objInput.Is_Active.ToUpper();

                objTalentRepositories.Update(objTalent);
                _objRet.Response = new { id = objTalent.Talent_Code };

            }

            return _objRet;
        }
    }
    #endregion

    #region -------- Business Unit -----------
    public class BusinessUnitService
    {
        private readonly BusinessUnitRepositories objBusinessUnitRepositories = new BusinessUnitRepositories();
        public GenericReturn GetBusinessUnit(string order, string sort, Int32 size, Int32 page, string search_value, Int32? id)
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
                if (sort.ToLower() == "BusinessUnitName".ToLower())
                {
                    sort = "Business_Unit_Name";
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

            #endregion
            BusinessUnitReturn _BusinessUnitReturn = new BusinessUnitReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _BusinessUnitReturn = objBusinessUnitRepositories.GetBusinessUnit_List(order, page, search_value, size, sort, Convert.ToInt32(id));
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _BusinessUnitReturn.paging.page = page;
            _BusinessUnitReturn.paging.size = size;

            _objRet.Response = _BusinessUnitReturn;

            return _objRet;
        }
    }
    #endregion

    #region -------- Sub License -----------
    public class SubLicenseService
    {

        private readonly SubLicenseRepositories objSubLicenseRepositories = new SubLicenseRepositories();

        public GenericReturn GetSubLicense(string order, string sort, Int32 size, Int32 page, string search_value, Int32? id)
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
                if (sort.ToLower() == "SubLicenseName".ToLower())
                {
                    sort = "Sub_License_Name";
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

            #endregion


            SubLicenseReturn _SubLicenseReturn = new SubLicenseReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _SubLicenseReturn = objSubLicenseRepositories.GetSub_License(order, page, search_value, size, sort, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _SubLicenseReturn.paging.page = page;
            _SubLicenseReturn.paging.size = size;

            _objRet.Response = _SubLicenseReturn;

            return _objRet;
        }
    }

    #endregion
    #region -------- Entity -----------
    public class EntityServices
    {
        private readonly EntityRepositories objEntityRepositories = new EntityRepositories();
        public GenericReturn GetEntityList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                else if (sort.ToLower() == "EntityName".ToLower())
                {
                    sort = "Entity_Name";
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

            EntityReturn _entityReturn = new EntityReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _entityReturn = objEntityRepositories.GetEntity_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            _entityReturn.paging.page = page;
            _entityReturn.paging.size = size;

            _objRet.Response = _entityReturn;

            return _objRet;
        }
    }
    #endregion

    #region -------- Deal Tag -----------
    public class DealTagService
    {
        public readonly DealTagRepositories objDealTagRepositories = new DealTagRepositories();
        public GenericReturn GetDealTag(string order, string sort, Int32 size, Int32 page, string search_value, Int32? id)
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
                if (sort.ToLower() == "Deal_Flag".ToLower())
                {
                    sort = "Deal_Flag";
                }
                else if (sort.ToLower() == "IsActive".ToLower())
                {
                    sort = "Is_Active";
                }
                else if (sort.ToLower() == "Deal_Tag_Description".ToLower())
                {
                    sort = "Deal_Tag_Description";
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

            #endregion

            DealTagReturn _DealTagReturn = new DealTagReturn();
            try
            {
                if (_objRet.IsSuccess)
                {
                    _DealTagReturn = objDealTagRepositories.GetDealTag_List(order, page, search_value, size, sort, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _DealTagReturn.paging.page = page;
            _DealTagReturn.paging.size = size;

            _objRet.Response = _DealTagReturn;

            return _objRet;
        }


    }
    #endregion

    #region -------- Milestone Type -----------
    public class MilestoneTypeService
    {
        public readonly MilestoneTypeRepositories ObjMilestoneTypeRepositories = new MilestoneTypeRepositories();

        public GenericReturn GetMilestoneType(string order, string sort, Int32 size, Int32 page, string search_value, Int32? id)
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
                if (sort.ToLower() == "MilestoneTypeName".ToLower())
                {
                    sort = "Milestone_Type_Name";
                }
                else if (sort.ToLower() == "IsAutomated".ToLower())
                {
                    sort = "Is_Automated";
                }
                //else if (sort.ToLower() == "IsActive".ToLower())
                //{
                //    sort = "IsActive";
                //}
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
            #endregion
            MilestoneTypeReturn _MilestoneTypeReturn = new MilestoneTypeReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _MilestoneTypeReturn = ObjMilestoneTypeRepositories.GetMilestoneType_List(order, page, search_value, size, sort, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _MilestoneTypeReturn.paging.page = page;
            _MilestoneTypeReturn.paging.size = size;

            _objRet.Response = _MilestoneTypeReturn;

            return _objRet;

        }
    }
    #endregion
    #region -------- ROFR -----------
    public class ROFRService
    {
        private readonly ROFRRepositories objROFRRepositories = new ROFRRepositories();

        public GenericReturn GetROFR(string order, string sort, Int32 size, Int32 page, string search_value, Int32? id)
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
                if (sort.ToLower() == "ROFRType".ToLower())
                {
                    sort = "ROFR_Type";
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

            #endregion
            ROFRReturn _ROFRReturn = new ROFRReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _ROFRReturn = objROFRRepositories.GetROFR_List(order, page, search_value, size, sort, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _ROFRReturn.paging.page = page;
            _ROFRReturn.paging.size = size;

            _objRet.Response = _ROFRReturn;

            return _objRet;
        }
    }
    #endregion

    #region -------- Language -----------
    public class LanguageServices
    {
        private readonly LanguageRepositories objLanguageRepositories = new LanguageRepositories();
        public GenericReturn GetLanguageList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                else if (sort.ToLower() == "LanguageName".ToLower())
                {
                    sort = "Language_Name";
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

            LanguageReturn _LanguageReturn = new LanguageReturn();

            try
            {
                _LanguageReturn = objLanguageRepositories.GetLanguage_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
            }
            catch (Exception ex)
            {
                throw;
            }

            _LanguageReturn.paging.page = page;
            _LanguageReturn.paging.size = size;

            _objRet.Response = _LanguageReturn;

            return _objRet;
        }

        public GenericReturn GetLanguageById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            Language _language = new Language();

            try
            {
                _language = objLanguageRepositories.Get(id);

            }
            catch (Exception ex)
            {
                throw;
            }
            _objRet.Response = _language;

            return _objRet;
        }

        public GenericReturn PostLanguage(Language objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation
            if (string.IsNullOrEmpty(objInput.Language_Name))
            {
                _objRet.Message = "Input Paramater 'Language Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            var CheckDuplicate = objLanguageRepositories.SearchFor(new { Language_Name = objInput.Language_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'Language Name already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            #endregion
            if (_objRet.IsSuccess)
            {
                Language objlanguage = new Language();

                objlanguage.Language_Name = objInput.Language_Name;
                objlanguage.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objlanguage.Inserted_On = DateTime.Now;
                objlanguage.Last_Updated_Time = DateTime.Now;
                objlanguage.Is_Active = "Y";

                objLanguageRepositories.Add(objlanguage);

                _objRet.Response = new { id = objlanguage.Language_Code };

            }

            return _objRet;
        }

        public GenericReturn PutLanguage(Language objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Language_Code == null || objInput.Language_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Language_Name))
            {
                _objRet.Message = "Input Paramater 'Language Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objLanguageRepositories.SearchFor(new { Language_Name = objInput.Language_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'Language name already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Language objlanguage = new Language();

                // int language_id = Convert.ToInt32(objInput.language_id);
                objlanguage = objLanguageRepositories.Get(Convert.ToInt32(objInput.Language_Code));

                objlanguage.Language_Name = objInput.Language_Name;
                objlanguage.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objlanguage.Last_Updated_Time = DateTime.Now;
                objlanguage.Is_Active = "Y";

                objLanguageRepositories.Update(objlanguage);

                _objRet.Response = new { id = objlanguage.Language_Code };
            }
            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(Language objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Language_Code == null || objInput.Language_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                Language objLanguage = new Language();
                // int language_id = Convert.ToInt32(objInput.language_id);
                objLanguage = objLanguageRepositories.Get(Convert.ToInt32(objInput.Language_Code));

                objLanguage.Last_Updated_Time = DateTime.Now;
                objLanguage.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objLanguage.Is_Active = objInput.Is_Active.ToUpper();

                objLanguageRepositories.Update(objLanguage);
                _objRet.Response = new { language_id = objLanguage.Language_Code };

            }
            return _objRet;
        }
    }


    #endregion

    #region PromoterRemark
    public class PromoterRemarkService
    {
        private readonly PromoterRemarkRepositories objPromoterRemarkRepositories = new PromoterRemarkRepositories();

        public GenericReturn GetPromoterRemarkList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                    sort = "Last_Updated_Time";
                }
                else if (sort.ToLower() == "PromoterRemarkName".ToLower())
                {
                    sort = "Promoter_Remark_Desc";
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

            PromoterRemarkReturn _PromoterRemarkReturn = new PromoterRemarkReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _PromoterRemarkReturn = objPromoterRemarkRepositories.GetPromoterRemark_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _PromoterRemarkReturn.paging.page = page;
            _PromoterRemarkReturn.paging.size = size;

            _objRet.Response = _PromoterRemarkReturn;

            return _objRet;
        }

        public GenericReturn GetPromoterRemarkById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'promoter_remarks_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    PromoterRemark objReturn = new PromoterRemark();

                    objReturn = objPromoterRemarkRepositories.GetById(id);

                    _objRet.Response = objReturn;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn PostPromoterRemark(PromoterRemark objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Promoter_Remark_Desc))
            {
                _objRet.Message = "Input Paramater 'promoter_remark_desc' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            var CheckDuplicate = objPromoterRemarkRepositories.SearchFor(new { Promoter_Remark_Desc = objInput.Promoter_Remark_Desc }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'promoter_remark_desc' already exists";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                PromoterRemark objPromoterRemark = new PromoterRemark();

                objPromoterRemark.Promoter_Remark_Desc = objInput.Promoter_Remark_Desc;
                objPromoterRemark.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objPromoterRemark.Inserted_On = DateTime.Now;
                objPromoterRemark.Last_Updated_Time = DateTime.Now;
                objPromoterRemark.Is_Active = "Y";

                objPromoterRemarkRepositories.Add(objPromoterRemark);

                _objRet.Response = new { id = objPromoterRemark.Promoter_Remarks_Code };

            }
            return _objRet;
        }

        public GenericReturn PutPromoterRemark(PromoterRemark objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Promoter_Remarks_Code == null || objInput.Promoter_Remarks_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Promoter_Remark_Desc))
            {
                _objRet.Message = "Input Paramater 'promoter_remark_desc' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            var CheckDuplicate = objPromoterRemarkRepositories.SearchFor(new { Promoter_Remark_Desc = objInput.Promoter_Remark_Desc }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'promoter_remark_desc' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                PromoterRemark objPromoterRemark = new PromoterRemark();

                objPromoterRemark = objPromoterRemarkRepositories.Get(objInput.Promoter_Remarks_Code.Value);
                objPromoterRemark.Promoter_Remark_Desc = objInput.Promoter_Remark_Desc;
                objPromoterRemark.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objPromoterRemark.Last_Updated_Time = DateTime.Now;
                objPromoterRemark.Is_Active = "Y";

                objPromoterRemarkRepositories.Update(objPromoterRemark);

                _objRet.Response = new { id = objPromoterRemark.Promoter_Remarks_Code };

            }
            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(PromoterRemark objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Promoter_Remarks_Code == null || objInput.Promoter_Remarks_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                PromoterRemark objPromoterRemark = new PromoterRemark();
                objPromoterRemark = objPromoterRemarkRepositories.Get(Convert.ToInt32(objInput.Promoter_Remarks_Code));

                objPromoterRemark.Last_Updated_Time = DateTime.Now;
                objPromoterRemark.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objPromoterRemark.Is_Active = objInput.Is_Active.ToUpper();

                objPromoterRemarkRepositories.Update(objPromoterRemark);
                _objRet.Response = new { id = objPromoterRemark.Promoter_Remarks_Code };

            }
            return _objRet;
        }
    }
    #endregion

    #region Error_Code_Master

    public class Error_Code_MasterServices
    {
        private readonly Error_Code_MasterRepositories objError_Code_MasterRepositories;
        public Error_Code_MasterServices()
        {
            this.objError_Code_MasterRepositories = new Error_Code_MasterRepositories();
        }
        public IEnumerable<Error_Code_Master> GetList()
        {
            return objError_Code_MasterRepositories.GetAll();
        }
        public IEnumerable<Error_Code_Master> SearchFor(object param)
        {
            return objError_Code_MasterRepositories.SearchFor(param);
        }
        public IEnumerable<Error_Code_Master> SearchBySql(string param)
        {
            return objError_Code_MasterRepositories.GetDataWithSQLStmt(param);
        }
    }

    #endregion

    #region Category
    public class CategoryService
    {
        private readonly CategoryRepositories objCategoryRepositories = new CategoryRepositories();
        public GenericReturn GetCategoryList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                    sort = "Last_Updated_Time";
                }
                else if (sort.ToLower() == "CategoryName".ToLower())
                {
                    sort = "Category_Name";
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

            CategoryReturn _CategoryRemarkReturn = new CategoryReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _CategoryRemarkReturn = objCategoryRepositories.GetCategory_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _CategoryRemarkReturn.paging.page = page;
            _CategoryRemarkReturn.paging.size = size;

            _objRet.Response = _CategoryRemarkReturn;

            return _objRet;
        }

        public GenericReturn GetCategoryById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'category_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Category objReturn = new Category();

                    objReturn = objCategoryRepositories.GetById(id);

                    _objRet.Response = objReturn;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn PostCategory(Category objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Category_Name))
            {
                _objRet.Message = "Input Paramater 'category_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            var CheckDuplicate = objCategoryRepositories.SearchFor(new { Category_Name = objInput.Category_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'category_name' already exists";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                Category objCategory = new Category();

                objCategory.Category_Name = objInput.Category_Name;
                objCategory.Is_System_Generated = objInput.Is_System_Generated;
                objCategory.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCategory.Inserted_On = DateTime.Now;
                objCategory.Last_Updated_Time = DateTime.Now;
                objCategory.Is_Active = "Y";

                objCategoryRepositories.Add(objCategory);

                _objRet.Response = new { id = objCategory.Category_Code };

            }
            return _objRet;
        }

        public GenericReturn PutCategory(Category objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Category_Name))
            {
                _objRet.Message = "Input Paramater 'category_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            var CheckDuplicate = objCategoryRepositories.SearchFor(new { Category_Name = objInput.Category_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'category_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Category objCategory = new Category();

                objCategory = objCategoryRepositories.Get(objInput.Category_Code.Value);
                objCategory.Category_Name = objInput.Category_Name;
                objCategory.Is_System_Generated = objInput.Is_System_Generated;
                objCategory.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCategory.Last_Updated_Time = DateTime.Now;
                objCategory.Is_Active = "Y";

                objCategoryRepositories.Update(objCategory);

                _objRet.Response = new { id = objCategory.Category_Code };

            }
            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(Category objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                Category objCategory = new Category();
                objCategory = objCategoryRepositories.Get(Convert.ToInt32(objInput.Category_Code));

                objCategory.Last_Updated_Time = DateTime.Now;
                objCategory.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCategory.Is_Active = objInput.Is_Active.ToUpper();
                objCategoryRepositories.Update(objCategory);
                _objRet.Response = new { id = objCategory.Category_Code };

            }
            return _objRet;
        }
    }
    #endregion

    #region RightRule
    public class RightRuleService
    {
        private readonly RightRuleRepositories objRightRuleRepositories = new RightRuleRepositories();

        public GenericReturn GetRightRuleList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT)
        {
            int noOfRecordSkip, noOfRecordTake;
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
                else if (sort.ToLower() == "RightRuleName".ToLower())
                {
                    sort = "Right_Rule_Name";
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

            RightRuleReturn _RightRuleReturn = new RightRuleReturn();
            List<RightRule> rightRules = new List<RightRule>();

            try
            {

                if (_objRet.IsSuccess)
                {
                    rightRules = objRightRuleRepositories.GetAll().ToList();
                    _RightRuleReturn.paging.total = rightRules.Count;
                    if (!string.IsNullOrEmpty(search_value))
                    {
                        rightRules = rightRules.Where(w => w.Right_Rule_Name.ToUpper().Contains(search_value.ToUpper())).ToList();
                    }

                    GetPage.GetPaging(page, size, rightRules.Count, out noOfRecordSkip, out noOfRecordTake);
                    if (order.ToUpper() == "ASC")
                    {
                        rightRules = rightRules.OrderBy(o => o.Right_Rule_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                    if (order.ToUpper() == "DESC")
                    {
                        rightRules = rightRules.OrderByDescending(o => o.Right_Rule_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _RightRuleReturn.content = rightRules;
            _RightRuleReturn.paging.page = page;
            _RightRuleReturn.paging.size = size;

            _objRet.Response = _RightRuleReturn;

            return _objRet;
        }

        public GenericReturn GetRightRuleById(int id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'right_rule_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    RightRule objReturn = new RightRule();
                    objReturn = objRightRuleRepositories.GetById(id);
                    _objRet.Response = objReturn;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn PostRightRule(RightRule objInput)
        {
            
             GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;
         

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Right_Rule_Name))
            {
                _objRet.Message = "Input Paramater 'right_rule_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (string.IsNullOrEmpty(objInput.Start_Time))
            {
                _objRet.Message = "Input Paramater 'start_time' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (objInput.Play_Per_Day == null || objInput.Play_Per_Day <= 0)
            {
                _objRet.Message = "Input Paramater 'play_per_day' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if(objInput.Duration_Of_Day == null || objInput.Duration_Of_Day <= 0)
            {
                _objRet.Message = "Input Paramater 'duration_of_day' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if(objInput.No_Of_Repeat == null || objInput.No_Of_Repeat <= 0)
            {
                _objRet.Message = "Input Paramater 'no_of_repeat' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if(string.IsNullOrEmpty(objInput.Short_Key))
            {
                _objRet.Message = "Input Paramater 'short_key' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            var CheckDuplicate = objRightRuleRepositories.SearchFor(new { Right_Rule_Name = objInput.Right_Rule_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'right_rule_name' already exists";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                RightRule objRightRule = new RightRule();

                objRightRule.Right_Rule_Name = objInput.Right_Rule_Name;
                objRightRule.Start_Time = objInput.Start_Time;
                objRightRule.Play_Per_Day = objInput.Play_Per_Day;
                objRightRule.Duration_Of_Day = objInput.Duration_Of_Day;
                objRightRule.No_Of_Repeat = objInput.No_Of_Repeat;
                objRightRule.Short_Key = objInput.Short_Key;
                objRightRule.IS_First_Air = objInput.IS_First_Air;
                objRightRule.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objRightRule.Inserted_On = DateTime.Now;
                objRightRule.Last_Updated_Time = DateTime.Now;
                objRightRule.Is_Active = "Y";

                objRightRuleRepositories.Add(objRightRule);

                _objRet.Response = new { id = objRightRule.Right_Rule_Code };

            }
            return _objRet;
        }

        public GenericReturn PutRightRule(RightRule objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Right_Rule_Code == null || objInput.Right_Rule_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Right_Rule_Name))
            {
                _objRet.Message = "Input Paramater 'right_rule_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (string.IsNullOrEmpty(objInput.Start_Time))
            {
                _objRet.Message = "Input Paramater 'start_time' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (objInput.Play_Per_Day == null || objInput.Play_Per_Day <= 0)
            {
                _objRet.Message = "Input Paramater 'play_per_day' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (objInput.Duration_Of_Day == null || objInput.Duration_Of_Day <= 0)
            {
                _objRet.Message = "Input Paramater 'duration_of_day' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (objInput.No_Of_Repeat == null || objInput.No_Of_Repeat <= 0)
            {
                _objRet.Message = "Input Paramater 'no_of_repeat' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (string.IsNullOrEmpty(objInput.Short_Key))
            {
                _objRet.Message = "Input Paramater 'short_key' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            var CheckDuplicate = objRightRuleRepositories.SearchFor(new { Right_Rule_Name = objInput.Right_Rule_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'right_rule_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                RightRule objRightRule = new RightRule();

                objRightRule = objRightRuleRepositories.Get(objInput.Right_Rule_Code.Value);
                objRightRule.Right_Rule_Name = objInput.Right_Rule_Name;
                objRightRule.Start_Time = objInput.Start_Time;
                objRightRule.Play_Per_Day = objInput.Play_Per_Day;
                objRightRule.Duration_Of_Day = objInput.Duration_Of_Day;
                objRightRule.No_Of_Repeat = objInput.No_Of_Repeat;
                objRightRule.Short_Key = objInput.Short_Key;
                objRightRule.IS_First_Air = objInput.IS_First_Air;
                objRightRule.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objRightRule.Last_Updated_Time = DateTime.Now;
                objRightRule.Is_Active = "Y";

                objRightRuleRepositories.Update(objRightRule);

                _objRet.Response = new { id = objRightRule.Right_Rule_Code };

            }
            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(RightRule objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Right_Rule_Code == null || objInput.Right_Rule_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                RightRule objRightRule = new RightRule();
                objRightRule = objRightRuleRepositories.Get(Convert.ToInt32(objInput.Right_Rule_Code));

                objRightRule.Last_Updated_Time = DateTime.Now;
                objRightRule.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objRightRule.Is_Active = objInput.Is_Active.ToUpper();
                objRightRuleRepositories.Update(objRightRule);
                _objRet.Response = new { id = objRightRule.Right_Rule_Code };

            }
            return _objRet;
        }
    }


    #endregion

    #region LanguageGroup
    public class LanguageGroupService
    {
        private readonly LanguageGroupDetailsRepositories objLanguageDetailsRepositories = new LanguageGroupDetailsRepositories();
        private readonly LanguageGroupRepositories objLanguageGroupRepositories = new LanguageGroupRepositories();

        public GenericReturn GetLanguageGroupList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT)
        {
            int noOfRecordSkip, noOfRecordTake;
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
                else if (sort.ToLower() == "LanguageGroupName".ToLower())
                {
                    sort = "Language_Group_Name";
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

            LanguageGroupReturn _LanguageGroupReturn = new LanguageGroupReturn();
            List<LanguageGroup> languageGroups= new List<LanguageGroup>();

            try
            {

                if (_objRet.IsSuccess)
                {
                    languageGroups = objLanguageGroupRepositories.GetAll().ToList();
                    _LanguageGroupReturn.paging.total = languageGroups.Count;
                    if (!string.IsNullOrEmpty(search_value))
                    {
                        languageGroups = languageGroups.Where(w => w.Language_Group_Name.ToUpper().Contains(search_value.ToUpper())).ToList();
                    }

                    GetPage.GetPaging(page, size, languageGroups.Count, out noOfRecordSkip, out noOfRecordTake);
                    if (order.ToUpper() == "ASC")
                    {
                        languageGroups = languageGroups.OrderBy(o => o.Language_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                    if (order.ToUpper() == "DESC")
                    {
                        languageGroups = languageGroups.OrderByDescending(o => o.Language_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _LanguageGroupReturn.content = languageGroups;
            _LanguageGroupReturn.paging.page = page;
            _LanguageGroupReturn.paging.size = size;

            _objRet.Response = _LanguageGroupReturn;

            return _objRet;
        }

        public GenericReturn GetLanguageGroupById(int id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'language_group_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    LanguageGroup objReturn = new LanguageGroup();
                    objReturn = objLanguageGroupRepositories.GetById(id);
                    _objRet.Response = objReturn;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn PostLanguageGroup(LanguageGroup objInput)
        {

            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;


            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Language_Group_Name))
            {
                _objRet.Message = "Input Paramater 'language_group_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (objInput.languagegroup_details.ToList().Count == 0)
            {
                _objRet.Message = "Input Paramater 'languages' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            var CheckDuplicate = objLanguageGroupRepositories.SearchFor(new { Language_Group_Name = objInput.Language_Group_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'language_group_name' already exists";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                LanguageGroup objLanguageGroup  = new LanguageGroup();

                List<LanguageGroupDetails> lstLangGrp_Details = new List<LanguageGroupDetails>();
                foreach (var item in objInput.languagegroup_details)
                {
                    LanguageGroupDetails objLangGrp_Details = new LanguageGroupDetails();

                    objLangGrp_Details.Language_Code = item.Language_Code;
                    objLangGrp_Details.Language_Group_Code = item.Language_Group_Code;
                    lstLangGrp_Details.Add(objLangGrp_Details);
                }
                objLanguageGroup.languagegroup_details = lstLangGrp_Details;

                objLanguageGroup.Language_Group_Name = objInput.Language_Group_Name;
                objLanguageGroup.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objLanguageGroup.Inserted_On = DateTime.Now;
                objLanguageGroup.Last_Updated_Time = DateTime.Now;
                objLanguageGroup.Is_Active = "Y";

                objLanguageGroupRepositories.Add(objLanguageGroup);

                _objRet.Response = new { id = objLanguageGroup.Language_Group_Code};

            }
            return _objRet;
        }

        public GenericReturn PutLanguageGroup(LanguageGroup objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Language_Group_Code == null || objInput.Language_Group_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Language_Group_Name))
            {
                _objRet.Message = "Input Paramater 'language_group_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            var CheckDuplicate = objLanguageGroupRepositories.SearchFor(new { Language_Group_Name = objInput.Language_Group_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'language_group_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion

            if (_objRet.IsSuccess)
            {
               var  objLanguageGroup = objLanguageGroupRepositories.GetById(objInput.Language_Group_Code.Value);

                objLanguageGroup.languagegroup_details.ToList().ForEach(f=>f.EntityState = State.Deleted);
               
              foreach(var item in objInput.languagegroup_details)
                {
                    LanguageGroupDetails objL = (LanguageGroupDetails)objLanguageGroup.languagegroup_details.Where(t => t.Language_Group_Details_Code == item.Language_Group_Details_Code).Select(i => i).FirstOrDefault();

                    if (objL == null)
                    //{
                        objL = new LanguageGroupDetails();
                        if(objL.Language_Group_Details_Code > 0)
                        {
                            objL.EntityState = State.Unchanged;
                        }
                        else
                        {
                            objL.EntityState = State.Added;
                            objL.Language_Group_Details_Code = item.Language_Group_Details_Code;
                            objL.Language_Code = item.Language_Code;
                            objL.Language_Group_Code = item.Language_Group_Code;
                            objLanguageGroup.languagegroup_details.Add(objL);
                        }
                   // }

                }

                foreach (var item in objLanguageGroup.languagegroup_details.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objLanguageDetailsRepositories.Delete(item);
                }

                var dataDetails = objLanguageGroup.languagegroup_details.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                dataDetails.ForEach(i => objLanguageGroup.languagegroup_details.Remove(i));

                objLanguageGroup.languagegroup_details = objInput.languagegroup_details;
                objLanguageGroup.Language_Group_Name = objInput.Language_Group_Name;
                objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Last_Updated_Time = DateTime.Now;
                objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Inserted_On = DateTime.Now;
                objInput.Is_Active = "Y";

                objLanguageGroupRepositories.Update(objInput);

                _objRet.Response = new { id = objLanguageGroup.Language_Group_Code};

            }
            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(LanguageGroup objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Language_Group_Code == null || objInput.Language_Group_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                LanguageGroup objLanguageGroup = new LanguageGroup();
                objLanguageGroup = objLanguageGroupRepositories.Get(Convert.ToInt32(objInput.Language_Group_Code));

                objLanguageGroup.Last_Updated_Time = DateTime.Now;
                objLanguageGroup.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objLanguageGroup.Is_Active = objInput.Is_Active.ToUpper();
                objLanguageGroup.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objLanguageGroup.Inserted_On = DateTime.Now;
                objLanguageGroupRepositories.Update(objLanguageGroup);
               
                _objRet.Response = new { id = objLanguageGroup.Language_Group_Code };

            }
            return _objRet;
        }
    }
    #endregion


    #region Currency
    public class CurrencyService
    {
        private readonly CurrencyRepositories objCurrencyRepositories = new CurrencyRepositories();
        private readonly CurrencyExchangeReturnRepositories objCurrencyExchangeReturnRepositories = new CurrencyExchangeReturnRepositories();
        public GenericReturn GetCurrencyList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT)
        {
            int noOfRecordSkip, noOfRecordTake;
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
                else if (sort.ToLower() == "CurrencyName".ToLower())
                {
                    sort = "Currency_Name";
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

            CurrencyReturn _CurrencyReturn = new CurrencyReturn();
            List<Currency> currencies = new List<Currency>();

            try
            {

                if (_objRet.IsSuccess)
                {
                    currencies = objCurrencyRepositories.GetAll().ToList();
                    _CurrencyReturn.paging.total = currencies.Count;
                    if (!string.IsNullOrEmpty(search_value))
                    {
                        currencies = currencies.Where(w => w.Currency_Name.ToUpper().Contains(search_value.ToUpper())).ToList();
                    }

                    GetPage.GetPaging(page, size, currencies.Count, out noOfRecordSkip, out noOfRecordTake);
                    if (order.ToUpper() == "ASC")
                    {
                        currencies = currencies.OrderBy(o => o.Currency_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                    if (order.ToUpper() == "DESC")
                    {
                        currencies = currencies.OrderByDescending(o => o.Currency_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _CurrencyReturn.content = currencies;
            _CurrencyReturn.paging.page = page;
            _CurrencyReturn.paging.size = size;

            _objRet.Response = _CurrencyReturn;

            return _objRet;
        }

        public GenericReturn GetCurrencyById(int id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'currency_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Currency objReturn = new Currency();
                    objReturn = objCurrencyRepositories.GetById(id);
                    _objRet.Response = objReturn;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn PostCurrency(Currency  objInput)
        {

            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;


            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Currency_Name))
            {
                _objRet.Message = "Input Paramater 'currency_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (string.IsNullOrEmpty(objInput.Currency_Sign))
            {
                _objRet.Message = "Input Paramater 'currency_sign' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (objInput.currency_exchange.ToList().Count == 0)
            {
                _objRet.Message = "Please add currency exchange rate";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            var CheckDuplicate = objCurrencyRepositories.SearchFor(new { Currency_Name = objInput.Currency_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'currency_name' already exists";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                Currency objCurrrency = new Currency();

                List<CurrencyExchangeRate> lstCurrencyExchange_Details = new List<CurrencyExchangeRate>();
                foreach (var item in objInput.currency_exchange)
                {
                    CurrencyExchangeRate objCurrencyExchange_Details = new CurrencyExchangeRate();
                    objCurrencyExchange_Details.Currency_Code = item.Currency_Code;
                    objCurrencyExchange_Details.Effective_Start_Date = item.Effective_Start_Date;
                    objCurrencyExchange_Details.Exchange_Rate = item.Exchange_Rate;
                    lstCurrencyExchange_Details.Add(objCurrencyExchange_Details);
                }
                objCurrrency.currency_exchange = lstCurrencyExchange_Details;

                objCurrrency.Currency_Name = objInput.Currency_Name;
                objCurrrency.Currency_Sign = objInput.Currency_Sign;
                objCurrrency.Is_Base_Currency = objInput.Is_Base_Currency;
                objCurrrency.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCurrrency.Inserted_On = DateTime.Now;
                objCurrrency.Last_Updated_Time = DateTime.Now;
                objCurrrency.Is_Active = "Y";

                objCurrencyRepositories.Add(objCurrrency);

                _objRet.Response = new { id = objCurrrency.Currency_Code };

            }
            return _objRet;
        }

        public GenericReturn PutCurrency(Currency objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Currency_Name))
            {
                _objRet.Message = "Input Paramater 'currency_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (string.IsNullOrEmpty(objInput.Currency_Sign))
            {
                _objRet.Message = "Input Paramater 'currency_sign' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            if (objInput.currency_exchange.ToList().Count == 0)
            {
                _objRet.Message = "Please add currency exchange rate";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            var CheckDuplicate = objCurrencyRepositories.SearchFor(new { Currency_Name = objInput.Currency_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'currency_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                var objCurrency = objCurrencyRepositories.GetById(objInput.Currency_Code.Value);

                objCurrency.currency_exchange.ToList().ForEach(f => f.EntityState = State.Deleted);

                foreach (var item in objInput.currency_exchange)
                {
                    CurrencyExchangeRate objC = (CurrencyExchangeRate)objCurrency.currency_exchange.Where(t => t.Currency_Exchange_Rate_Code == item.Currency_Exchange_Rate_Code).Select(i => i).FirstOrDefault();

                    if (objC == null)
                        objC = new CurrencyExchangeRate();
                    if (objC.Currency_Exchange_Rate_Code > 0)
                    {
                        objC.EntityState = State.Unchanged;
                    }
                    else
                    {
                        objC.EntityState = State.Added;
                        objC.Currency_Exchange_Rate_Code = item.Currency_Exchange_Rate_Code;
                        objC.Currency_Code = item.Currency_Code;
                        objC.Exchange_Rate = item.Exchange_Rate;
                        objC.Effective_Start_Date = item.Effective_Start_Date;
                        objCurrency.currency_exchange.Add(objC);
                    }
                }

                foreach (var item in objCurrency.currency_exchange.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objCurrencyExchangeReturnRepositories.Delete(item);
                }

                var dataDetails = objCurrency.currency_exchange.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                dataDetails.ForEach(i => objCurrency.currency_exchange.Remove(i));

                objCurrency.currency_exchange = objInput.currency_exchange;
                objCurrency.Currency_Name = objInput.Currency_Name;
                objCurrency.Currency_Sign = objInput.Currency_Sign;
                objCurrency.Is_Base_Currency = objInput.Is_Base_Currency;

                objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Last_Updated_Time = DateTime.Now;
                objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Inserted_On = DateTime.Now;
                objInput.Is_Active = "Y";

                objCurrencyRepositories.Update(objInput);

                _objRet.Response = new { id = objCurrency.Currency_Code };

            }
            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(Currency objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                Currency objCurrency = new Currency();
                objCurrency = objCurrencyRepositories.Get(Convert.ToInt32(objInput.Currency_Code));

                objCurrency.Last_Updated_Time = DateTime.Now;
                objCurrency.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCurrency.Is_Active = objInput.Is_Active.ToUpper();
                objCurrency.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCurrency.Inserted_On = DateTime.Now;
                objCurrencyRepositories.Update(objCurrency);

                _objRet.Response = new { id = objCurrency.Currency_Code };

            }
            return _objRet;
        }
    }
    #endregion


    #region Country
    public class CountryService
    {
        private readonly CountryRepositories objCountryRepositories = new CountryRepositories();
        private readonly CountryLanguageDetailsRepositories objCountryLangDetails = new CountryLanguageDetailsRepositories();
        public GenericReturn GetCountryList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT)
        {
            int noOfRecordSkip, noOfRecordTake;
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
                else if (sort.ToLower() == "CountryName".ToLower())
                {
                    sort = "Country_Name";
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

            CountryReturn _countryReturn = new CountryReturn();
            List<Country> countries = new List<Country>();

            try
            {

                if (_objRet.IsSuccess)
                {
                    countries = objCountryRepositories.GetAll().ToList();

                    countries.ForEach(i =>
                    {
                        if (i.Parent_Country_Code != null || i.Parent_Country_Code > 0 )
                        { 
                            i.parent_country = new CountryRepositories().Get(i.Parent_Country_Code.Value);
                          
                        }
                    });
                  
                        _countryReturn.paging.total = countries.Count;
                    if (!string.IsNullOrEmpty(search_value))
                    {
                        countries = countries.Where(w => w.Country_Name.ToUpper().Contains(search_value.ToUpper())).ToList();
                    }

                    GetPage.GetPaging(page, size, countries.Count, out noOfRecordSkip, out noOfRecordTake);
                    if (order.ToUpper() == "ASC")
                    {
                        countries = countries.OrderBy(o => o.Country_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                    if (order.ToUpper() == "DESC")
                    {
                        countries = countries.OrderByDescending(o => o.Country_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _countryReturn.content = countries;
            _countryReturn.paging.page = page;
            _countryReturn.paging.size = size;

            _objRet.Response = _countryReturn;

            return _objRet;
        }

        public GenericReturn GetCountryById(int id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'country_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Country objReturn = new Country();

                    objReturn = objCountryRepositories.Get(id);
                    if (objReturn.Parent_Country_Code != null || objReturn.Parent_Country_Code > 0)
                    {
                        objReturn.parent_country = new CountryRepositories().Get(objReturn.Parent_Country_Code.Value);

                    }
                    _objRet.Response = objReturn;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn PostCountry(Country objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Country_Name))
            {
                _objRet.Message = "Input Paramater 'country_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
           
            var CheckDuplicate = objCountryRepositories.SearchFor(new { Country_Name = objInput.Country_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'country_name' already exists";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            
            if (_objRet.IsSuccess)
            {
                Country objCountry = new Country();

                List<CountryLanguage> lstCountrylang_Details = new List<CountryLanguage>();
                foreach (var item in objInput.country_language)
                {
                    CountryLanguage objCountry_Details = new CountryLanguage();

                    objCountry_Details.Country_Code = item.Country_Code;
                    objCountry_Details.Language_Code = item.Language_Code;
                    lstCountrylang_Details.Add(objCountry_Details);
                }
                objCountry.country_language = lstCountrylang_Details;
                objCountry.Parent_Country_Code = objInput.Parent_Country_Code;
                objCountry.Country_Name = objInput.Country_Name;
                objCountry.Is_Theatrical_Territory = objInput.Is_Theatrical_Territory;
                objCountry.Is_Domestic_Territory = objInput.Is_Domestic_Territory;
                objCountry.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCountry.Inserted_On = DateTime.Now;
                objCountry.Last_Updated_Time = DateTime.Now;
                objCountry.Is_Active = "Y";

                objCountryRepositories.Add(objCountry);

                _objRet.Response = new { id = objCountry.Country_Code };

            }

            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(Country objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Country_Code == null || objInput.Country_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion
            if (_objRet.IsSuccess)
            {
                Country objCountry = new Country();
                objCountry = objCountryRepositories.Get(Convert.ToInt32(objInput.Country_Code));

                objCountry.Last_Updated_Time = DateTime.Now;
                objCountry.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCountry.Is_Active = objInput.Is_Active.ToUpper();
                objCountry.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objCountry.Inserted_On = DateTime.Now;
                objCountryRepositories.Update(objCountry);

                _objRet.Response = new { id = objCountry.Country_Code };

            }
            return _objRet;
        }

        public GenericReturn PutCountry(Country objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Country_Code == null || objInput.Country_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            if (string.IsNullOrEmpty(objInput.Country_Name))
            {
                _objRet.Message = "Input Paramater 'country_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            var CheckDuplicate = objCountryRepositories.SearchFor(new { Country_Name = objInput.Country_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'country_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                _objRet.Response = new { _objRet.Message };
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                var objCountry = objCountryRepositories.Get(objInput.Country_Code.Value);

                objCountry.country_language.ToList().ForEach(f => f.EntityState = State.Deleted);

                foreach (var item in objInput.country_language)
                {
                    CountryLanguage objC = (CountryLanguage)objCountry.country_language.Where(t => t.Country_Language_Code == item.Country_Language_Code).Select(i => i).FirstOrDefault();

                    if (objC == null)
                        objC = new CountryLanguage();
                    if (objC.Country_Language_Code > 0)
                    {
                        objC.EntityState = State.Unchanged;
                    }
                    else
                    {
                        objC.EntityState = State.Added;
                        objC.Country_Language_Code = item.Country_Language_Code;
                        objC.Country_Code = item.Country_Code;
                        objC.Language_Code = item.Language_Code;
                        objCountry.country_language.Add(objC);
                    }
                }

                foreach (var item in objCountry.country_language.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objCountryLangDetails.Delete(item);
                }

                var dataDetails = objCountry.country_language.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                dataDetails.ForEach(i => objCountry.country_language.Remove(i));

                objCountry.country_language = objInput.country_language;
                objCountry.Country_Name = objInput.Country_Name;
                objCountry.Is_Domestic_Territory = objInput.Is_Domestic_Territory;
                objCountry.Is_Theatrical_Territory = objInput.Is_Theatrical_Territory;
                objCountry.Parent_Country_Code = objInput.Parent_Country_Code;
                objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Last_Updated_Time = DateTime.Now;
                objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Inserted_On = DateTime.Now;
                objInput.Is_Active = "Y";

                objCountryRepositories.Update(objInput);

                _objRet.Response = new { id = objCountry.Country_Code };

            }
            return _objRet;
        }
    }
    #endregion

    #region Territory
    public class TerritoryService
    {
        //public GenericReturn GetTerritoryList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT)
        //{
        //    int noOfRecordSkip, noOfRecordTake;
        //    GenericReturn _objRet = new GenericReturn();
        //    _objRet.Message = "Success";
        //    _objRet.IsSuccess = true;
        //    _objRet.StatusCode = HttpStatusCode.OK;


        //    #region Input Validations

        //    if (!string.IsNullOrEmpty(order))
        //    {
        //        if (order.ToUpper() != "ASC")
        //        {
        //            if (order.ToUpper() != "DESC")
        //            {
        //                _objRet.Message = "Input Paramater 'order' is not in valid format";
        //                _objRet.IsSuccess = false;
        //                _objRet.StatusCode = HttpStatusCode.BadRequest;
        //            }
        //        }
        //    }
        //    else
        //    {
        //        order = ConfigurationManager.AppSettings["defaultOrder"];
        //    }

        //    if (page == 0)
        //    {
        //        page = Convert.ToInt32(ConfigurationManager.AppSettings["defaultPage"]);
        //    }

        //    if (size > 0)
        //    {
        //        var maxSize = Convert.ToInt32(ConfigurationManager.AppSettings["maxSize"]);
        //        if (size > maxSize)
        //        {
        //            _objRet.Message = "Input Paramater 'size' should not be greater than " + maxSize;
        //            _objRet.IsSuccess = false;
        //            _objRet.StatusCode = HttpStatusCode.BadRequest;
        //        }
        //    }
        //    else
        //    {
        //        size = Convert.ToInt32(ConfigurationManager.AppSettings["defaultSize"]);
        //    }

        //    if (!string.IsNullOrEmpty(sort.ToString()))
        //    {
        //        if (sort.ToLower() == "CreatedDate".ToLower())
        //        {
        //            sort = "Inserted_On";
        //        }
        //        else if (sort.ToLower() == "UpdatedDate".ToLower())
        //        {
        //            sort = "Last_UpDated_Time";
        //        }
        //        else if (sort.ToLower() == "LanguageGroupName".ToLower())
        //        {
        //            sort = "Territory_Name";
        //        }
        //        else
        //        {
        //            _objRet.Message = "Input Paramater 'sort' is not in valid format";
        //            _objRet.IsSuccess = false;
        //            _objRet.StatusCode = HttpStatusCode.BadRequest;
        //        }
        //    }
        //    else
        //    {
        //        sort = ConfigurationManager.AppSettings["defaultSort"];
        //    }

        //    try
        //    {
        //        if (!string.IsNullOrEmpty(Date_GT))
        //        {
        //            try
        //            {
        //                Date_GT = DateTime.Parse(Date_GT).ToString("yyyy-MM-dd");
        //            }
        //            catch (Exception ex)
        //            {
        //                _objRet.Message = "Input Paramater 'dateGt' is not in valid format";
        //                _objRet.IsSuccess = false;
        //                _objRet.StatusCode = HttpStatusCode.BadRequest;
        //            }

        //        }
        //        if (!string.IsNullOrEmpty(Date_LT))
        //        {
        //            try
        //            {
        //                Date_LT = DateTime.Parse(Date_LT).ToString("yyyy-MM-dd");
        //            }
        //            catch (Exception ex)
        //            {
        //                _objRet.Message = "Input Paramater 'dateLt' is not in valid format";
        //                _objRet.IsSuccess = false;
        //                _objRet.StatusCode = HttpStatusCode.BadRequest;
        //            }
        //        }

        //        if (!string.IsNullOrEmpty(Date_GT) && !string.IsNullOrEmpty(Date_LT))
        //        {
        //            if (DateTime.Parse(Date_GT) > DateTime.Parse(Date_LT))
        //            {
        //                _objRet.Message = "Input Paramater 'dateLt' should not be less than 'dateGt'";
        //                _objRet.IsSuccess = false;
        //                _objRet.StatusCode = HttpStatusCode.BadRequest;
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        _objRet.Message = "Input Paramater 'dateLt' or 'dateGt' is not in valid format";
        //        _objRet.IsSuccess = false;
        //        _objRet.StatusCode = HttpStatusCode.BadRequest;
        //    }

        //    #endregion

        //    LanguageGroupReturn _LanguageGroupReturn = new LanguageGroupReturn();
        //    List<LanguageGroup> languageGroups = new List<LanguageGroup>();

        //    try
        //    {

        //        if (_objRet.IsSuccess)
        //        {
        //            languageGroups = objLanguageGroupRepositories.GetAll().ToList();
        //            _LanguageGroupReturn.paging.total = languageGroups.Count;
        //            if (!string.IsNullOrEmpty(search_value))
        //            {
        //                languageGroups = languageGroups.Where(w => w.Language_Group_Name.ToUpper().Contains(search_value.ToUpper())).ToList();
        //            }

        //            GetPage.GetPaging(page, size, languageGroups.Count, out noOfRecordSkip, out noOfRecordTake);
        //            if (order.ToUpper() == "ASC")
        //            {
        //                languageGroups = languageGroups.OrderBy(o => o.Language_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
        //            }
        //            if (order.ToUpper() == "DESC")
        //            {
        //                languageGroups = languageGroups.OrderByDescending(o => o.Language_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw;
        //    }

        //    _LanguageGroupReturn.content = languageGroups;
        //    _LanguageGroupReturn.paging.page = page;
        //    _LanguageGroupReturn.paging.size = size;

        //    _objRet.Response = _LanguageGroupReturn;

        //    return _objRet;
        //}

    }
    #endregion
    public static class GetPage{
        public static int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                //int cnt = pageNo * recordPerPage;
                //if (cnt >= recordCount)
                //{
                //    int v1 = recordCount / recordPerPage;
                //    if ((v1 * recordPerPage) == recordCount)
                //        pageNo = v1;
                //    else
                //        pageNo = v1 + 1;
                //}
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }
    }
}
