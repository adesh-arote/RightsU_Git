using Dapper;
using RightsU.BMS.DAL;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using System.Net;
using System.Configuration;

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

        public bool hasModuleRights(Int32 Module_Code, string authenticationToken, string RefreshToken)
        {
            bool hasRights = true;

            LoggedInUsersServices objLoggedInUsersServices = new LoggedInUsersServices();
            UserServices objUserServices = new UserServices();

            LoggedInUsers objUserDetails = objLoggedInUsersServices.SearchFor(new { AccessToken = authenticationToken, RefreshToken = RefreshToken }).ToList().FirstOrDefault();

            if (objUserDetails != null)
            {
                User objUser = new User();
                objUser = objUserServices.SearchForUser(new { Login_Name = objUserDetails.LoginName }).FirstOrDefault();

                var UserModuleRights = USP_GetModule(objUser.Security_Group_Code.Value, objUser.Users_Code.Value);

                if (UserModuleRights.Where(x => x.Module_Code == Module_Code).ToList().Count() > 0)
                {
                    hasRights = true;
                }
                else
                {
                    hasRights = false;
                }
            }

            return hasRights;
        }
    }

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
}
